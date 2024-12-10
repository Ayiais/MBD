const db = require('../config/db'); // Pastikan ini sesuai dengan konfigurasi koneksi DB Anda

// Menambahkan laporan
const addLaporan = async (_project_title, _user_name, _deskripsi_laporan, _tanggal_laporan, _hasil_project) => {
  const query = `CALL add_laporan(?, ?, ?, ?, ?)`;
  try {
    const [result] = await db.execute(query, [_project_title, _user_name, _deskripsi_laporan, _tanggal_laporan, _hasil_project]);
    return result;
  } catch (err) {
    throw err;
  }
};

// Menghapus laporan
const deleteLaporan = async (_project_title, _user_name) => {
  const query = `CALL delete_laporan(?, ?)`;
  try {
    const [result] = await db.execute(query, [_project_title, _user_name]);
    return result;
  } catch (err) {
    throw err;
  }
};

// Membaca laporan
const readLaporan = async (_project_title, _user_name) => {
  const query = `CALL read_laporan(?, ?)`;
  try {
    const [rows] = await db.execute(query, [_project_title, _user_name]);
    return rows;
  } catch (err) {
    throw err;
  }
};

// Memperbarui laporan
const updateLaporan = async (_project_title, _user_name, _deskripsi_laporan, _hasil_project) => {
  const query = `CALL update_laporan(?, ?, ?, ?)`;
  try {
    const [result] = await db.execute(query, [_project_title, _user_name, _deskripsi_laporan, _hasil_project]);
    return result;
  } catch (err) {
    throw err;
  }
};

module.exports = {
  addLaporan,
  deleteLaporan,
  readLaporan,
  updateLaporan
};
