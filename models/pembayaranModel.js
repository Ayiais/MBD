// models/pembayaranModel.js
const db = require('../config/db');

// Fungsi untuk memanggil stored procedure create_pembayaran
const createPembayaran = async (usernameClient, projectTitle, jumlahPembayaran) => {
  const query = 'CALL create_pembayaran(?, ?, ?)';
  const [rows] = await db.execute(query, [usernameClient, projectTitle, jumlahPembayaran]);
  return rows;
};

// Fungsi untuk memanggil stored procedure read_pembayaran
const readPembayaran = async (usernameClient = null) => {
  const query = 'CALL read_pembayaran(?)';
  const [rows] = await db.execute(query, [usernameClient]);
  return rows;
};

// Fungsi untuk memanggil stored procedure delete_pembayaran
const deletePembayaran = async (projectTitle, tanggalPembayaran) => {
  const query = 'CALL delete_pembayaran(?, ?)';
  const [rows] = await db.execute(query, [projectTitle, tanggalPembayaran]);
  return rows;
};

module.exports = {
  createPembayaran,
  readPembayaran,
  deletePembayaran,
};
