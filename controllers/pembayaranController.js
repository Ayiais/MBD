// controllers/pembayaranController.js
const pembayaranModel = require('../models/pembayaranModel');

// Controller untuk menangani pembuatan pembayaran
const createPembayaran = async (req, res) => {
  const { usernameClient, projectTitle, jumlahPembayaran } = req.body;

  try {
    const result = await pembayaranModel.createPembayaran(usernameClient, projectTitle, jumlahPembayaran);
    res.status(200).json({ message: 'Pembayaran berhasil dibuat', data: result });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Controller untuk menangani pembacaan pembayaran
const readPembayaran = async (req, res) => {
  const { usernameClient } = req.query;

  try {
    const result = await pembayaranModel.readPembayaran(usernameClient);
    res.status(200).json({ data: result });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Controller untuk menangani penghapusan pembayaran
const deletePembayaran = async (req, res) => {
  const { projectTitle, tanggalPembayaran } = req.body;

  try {
    const result = await pembayaranModel.deletePembayaran(projectTitle, tanggalPembayaran);
    res.status(200).json({ message: 'Pembayaran berhasil dihapus', data: result });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  createPembayaran,
  readPembayaran,
  deletePembayaran,
};
