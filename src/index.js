const express = require('express');
require('dotenv').config();
const kegiatanRoutes = require('./routes/kegiatan');

const app = express();
app.use(express.json());

app.get('/', (req, res) => res.json({ message: 'API Desa Sejahtera aktif' }));
app.use('/api/kegiatan', kegiatanRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`🚀 Server jalan di http://localhost:${PORT}`));
