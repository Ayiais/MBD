const penawaranModel = require('../models/penawaranModel');

// Menambahkan penawaran
exports.addPenawaran = async (req, res) => {
    try {
      const result = await penawaranModel.addPenawaran(req.body);
      // Mengirim response sukses
      res.status(201).json({ message: 'Penawaran added successfully', result });
    } catch (error) {
      // Mengirim response error jika terjadi masalah
      console.error(error);
      res.status(500).json({ error: error.message });
    }
};

// Menghapus penawaran berdasarkan project
exports.deletePenawaranByProject = async (req, res) => {
  try {
    const { projectTitle } = req.params;
    const result = await penawaranModel.deletePenawaranByProject(projectTitle);
    res.status(200).json({ message: 'Penawaran berhasil dihapus', data: result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
};

// Menerima penawaran berdasarkan project
exports.acceptPenawaranByProject = async (req, res) => {
    try {
      const { projectTitle } = req.params;
  
      // Validasi apakah project ada
      const projectId = await penawaranModel.checkProjectExistence(projectTitle);
      if (!projectId) {
        return res.status(404).json({ error: 'Project tidak ditemukan' });
      }
  
      // Jika project ditemukan, panggil prosedur untuk menerima penawaran
      const result = await penawaranModel.acceptPenawaranByProject(projectTitle);
      res.status(200).json({ message: 'Penawaran diterima', data: result });
    } catch (error) {
      console.error("Error in acceptPenawaranByProject:", error);
      res.status(500).json({ error: error.message });
    }
  };
  

// Membaca semua penawaran
exports.readAllPenawaran = async (req, res) => {
  try {
    const result = await penawaranModel.readAllPenawaran();
    res.status(200).json({ data: result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
};
