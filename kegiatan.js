const express = require('express');
const router = express.Router();
const pool = require('../db');

// GET Semua Data
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM kegiatan ORDER BY id');
    res.json({ success: true, data: result.rows });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// GET Data by ID
router.get('/:id', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM kegiatan WHERE id = $1', [req.params.id]);
    if (result.rows.length === 0) return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
    res.json({ success: true, data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// POST Data Baru
router.post('/', async (req, res) => {
  try {
    const { nama_kegiatan, deskripsi, tanggal, kategori_id, lokasi_id } = req.body;
    const result = await pool.query(
      'INSERT INTO kegiatan (nama_kegiatan, deskripsi, tanggal, kategori_id, lokasi_id) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [nama_kegiatan, deskripsi, tanggal, kategori_id, lokasi_id]
    );
    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// PUT Update Data
router.put('/:id', async (req, res) => {
  try {
    const { nama_kegiatan, deskripsi, tanggal, kategori_id, lokasi_id } = req.body;
    const result = await pool.query(
      'UPDATE kegiatan SET nama_kegiatan = $1, deskripsi = $2, tanggal = $3, kategori_id = $4, lokasi_id = $5 WHERE id = $6 RETURNING *',
      [nama_kegiatan, deskripsi, tanggal, kategori_id, lokasi_id, req.params.id]
    );
    if (result.rows.length === 0) return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
    res.json({ success: true, data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// DELETE Data
router.delete('/:id', async (req, res) => {
  try {
    const result = await pool.query('DELETE FROM kegiatan WHERE id = $1 RETURNING *', [req.params.id]);
    if (result.rows.length === 0) return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
    res.json({ success: true, message: 'Data berhasil dihapus' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

module.exports = router;