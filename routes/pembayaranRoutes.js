// routes/pembayaranRoutes.js
const express = require('express');
const router = express.Router();
const pembayaranController = require('../controllers/pembayaranController');

// Route untuk membuat pembayaran
router.post('/create', pembayaranController.createPembayaran);

// Route untuk membaca pembayaran
router.get('/read', pembayaranController.readPembayaran);

// Route untuk menghapus pembayaran
router.delete('/delete', pembayaranController.deletePembayaran);

module.exports = router;
