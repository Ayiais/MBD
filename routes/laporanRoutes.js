const express = require('express');
const router = express.Router();
const laporanController = require('../controllers/laporanController');

// Route untuk menambah laporan
router.post('/add', laporanController.addLaporan);

// Route untuk menghapus laporan
router.delete('/delete', laporanController.deleteLaporan);

// Route untuk membaca laporan
router.get('/read', laporanController.readLaporan);

// Route untuk memperbarui laporan
router.put('/update', laporanController.updateLaporan);

module.exports = router;
