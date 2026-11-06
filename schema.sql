-- =========================================
-- DATABASE: desa_sejahtera
-- =========================================
DROP TABLE IF EXISTS pendaftaran CASCADE;
DROP TABLE IF EXISTS jadwal CASCADE;
DROP TABLE IF EXISTS kegiatan CASCADE;
DROP TABLE IF EXISTS lokasi CASCADE;
DROP TABLE IF EXISTS kategori_kegiatan CASCADE;
DROP TABLE IF EXISTS profil_warga CASCADE;
DROP TABLE IF EXISTS warga CASCADE;

-- ============ 1. TABEL WARGA ============
CREATE TABLE warga (
    id          SERIAL PRIMARY KEY,
    nik         VARCHAR(16) UNIQUE NOT NULL,
    nama        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    no_hp       VARCHAR(20),
    alamat      TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============ 2. TABEL PROFIL_WARGA (ONE TO ONE) ============
-- 1 warga hanya punya 1 profil, 1 profil hanya milik 1 warga
CREATE TABLE profil_warga (
    id           SERIAL PRIMARY KEY,
    warga_id     INT UNIQUE NOT NULL,  -- UNIQUE = jaminan one to one
    tanggal_lahir DATE,
    jenis_kelamin VARCHAR(10),
    pekerjaan    VARCHAR(100),
    foto_url     TEXT,
    CONSTRAINT fk_profil_warga
        FOREIGN KEY (warga_id)
        REFERENCES warga(id)
        ON DELETE CASCADE
);

-- ============ 3. TABEL KATEGORI_KEGIATAN ============
CREATE TABLE kategori_kegiatan (
    id          SERIAL PRIMARY KEY,
    nama        VARCHAR(100) UNIQUE NOT NULL,
    deskripsi   TEXT
);

-- ============ 4. TABEL LOKASI ============
CREATE TABLE lokasi (
    id          SERIAL PRIMARY KEY,
    nama        VARCHAR(150) NOT NULL,
    alamat      TEXT,
    rt_rw       VARCHAR(20)
);

-- ============ 5. TABEL KEGIATAN (ONE TO MANY) ============
-- 1 kategori bisa punya banyak kegiatan
-- 1 lokasi bisa dipakai banyak kegiatan
CREATE TABLE kegiatan (
    id            SERIAL PRIMARY KEY,
    nama_kegiatan VARCHAR(150) NOT NULL,
    deskripsi     TEXT,
    tanggal       DATE NOT NULL,
    kategori_id   INT NOT NULL,
    lokasi_id     INT NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_kegiatan_kategori
        FOREIGN KEY (kategori_id)
        REFERENCES kategori_kegiatan(id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_kegiatan_lokasi
        FOREIGN KEY (lokasi_id)
        REFERENCES lokasi(id)
        ON DELETE RESTRICT
);

-- ============ 6. TABEL JADWAL (ONE TO MANY) ============
-- 1 kegiatan bisa punya banyak jadwal (sesi)
CREATE TABLE jadwal (
    id           SERIAL PRIMARY KEY,
    kegiatan_id  INT NOT NULL,
    jam_mulai    TIME NOT NULL,
    jam_selesai  TIME NOT NULL,
    catatan      TEXT,
    CONSTRAINT fk_jadwal_kegiatan
        FOREIGN KEY (kegiatan_id)
        REFERENCES kegiatan(id)
        ON DELETE CASCADE
);

-- ============ 7. TABEL PENDAFTARAN (MANY TO MANY) ============
-- Warga ↔ Kegiatan: 1 warga bisa daftar banyak kegiatan
-- 1 kegiatan bisa diikuti banyak warga
CREATE TABLE pendaftaran (
    id           SERIAL PRIMARY KEY,
    warga_id     INT NOT NULL,
    kegiatan_id  INT NOT NULL,
    status       VARCHAR(20) DEFAULT 'terdaftar',
    tanggal_daftar TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pendaftaran_warga
        FOREIGN KEY (warga_id)
        REFERENCES warga(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_pendaftaran_kegiatan
        FOREIGN KEY (kegiatan_id)
        REFERENCES kegiatan(id)
        ON DELETE CASCADE,
    CONSTRAINT unique_pendaftaran UNIQUE (warga_id, kegiatan_id)
);

-- ============ SEED DATA ============
INSERT INTO warga (nik, nama, email, no_hp, alamat) VALUES
('3201010101010001', 'Budi Santoso', 'budi@mail.com', '081234567890', 'Jl. Merdeka No.1'),
('3201010101010002', 'Siti Aminah', 'siti@mail.com', '081234567891', 'Jl. Merdeka No.2');

INSERT INTO profil_warga (warga_id, tanggal_lahir, jenis_kelamin, pekerjaan) VALUES
(1, '1990-01-15', 'Laki-laki', 'Petani'),
(2, '1992-05-20', 'Perempuan', 'Guru');

INSERT INTO kategori_kegiatan (nama, deskripsi) VALUES
('Kerja Bakti', 'Kegiatan kebersihan lingkungan'),
('Siskamling', 'Kegiatan keamanan lingkungan'),
('Event Desa', 'Acara perayaan desa');

INSERT INTO lokasi (nama, alamat, rt_rw) VALUES
('Balai Desa', 'Jl. Utama No.1', 'RW 01'),
('Lapangan Desa', 'Jl. Utama No.5', 'RW 02');

INSERT INTO kegiatan (nama_kegiatan, deskripsi, tanggal, kategori_id, lokasi_id) VALUES
('Bersih-bersih RW 01', 'Kerja bakti bulanan', '2026-11-15', 1, 1),
('Ronda Malam Senin', 'Siskamling rutin', '2026-11-16', 2, 2);

INSERT INTO jadwal (kegiatan_id, jam_mulai, jam_selesai, catatan) VALUES
(1, '07:00', '10:00', 'Bawa alat kebersihan'),
(1, '15:00', '17:00', 'Sesi tambahan'),
(2, '22:00', '04:00', 'Bawa jaket');

INSERT INTO pendaftaran (warga_id, kegiatan_id, status) VALUES
(1, 1, 'terdaftar'),
(2, 1, 'terdaftar'),
(1, 2, 'terdaftar');
