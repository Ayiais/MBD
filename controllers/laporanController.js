const laporanModel = require('../models/laporanModel');

// Menambahkan laporan
exports.addLaporan = async (req, res) => {
  try {
    const { projectTitle, userName, deskripsiLaporan, tanggalLaporan, hasilProject } = req.body;

    // Validasi parameter
    if (!projectTitle || !userName || !deskripsiLaporan || !tanggalLaporan || !hasilProject) {
      return res.status(400).json({ message: 'Parameter tidak lengkap' });
    }

    const result = await laporanModel.addLaporan(projectTitle, userName, deskripsiLaporan, tanggalLaporan, hasilProject);
    res.status(200).json({ message: 'Laporan berhasil ditambahkan', data: result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
};

// Menghapus laporan
exports.deleteLaporan = async (req, res) => {
  try {
    const { projectTitle, userName } = req.body;

    // Validasi parameter
    if (!projectTitle || !userName) {
      return res.status(400).json({ message: 'Parameter tidak lengkap' });
    }

    const result = await laporanModel.deleteLaporan(projectTitle, userName);
    res.status(200).json({ message: 'Laporan berhasil dihapus', data: result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
};

// Membaca laporan
exports.readLaporan = async (req, res) => {
  try {
    const { projectTitle, userName } = req.body;

    // Validasi parameter
    if (!projectTitle || !userName) {
      return res.status(400).json({ message: 'Parameter tidak lengkap' });
    }

    const laporan = await laporanModel.readLaporan(projectTitle, userName);
    if (laporan.length === 0) {
      return res.status(404).json({ message: 'Laporan tidak ditemukan' });
    }

    res.status(200).json({ data: laporan });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
};

// Memperbarui laporan
exports.updateLaporan = async (req, res) => {
  try {
    const { projectTitle, userName, deskripsiLaporan, hasilProject } = req.body;

    // Validasi parameter
    if (!projectTitle || !userName || !deskripsiLaporan || !hasilProject) {
      return res.status(400).json({ message: 'Parameter tidak lengkap' });
    }

    const result = await laporanModel.updateLaporan(projectTitle, userName, deskripsiLaporan, hasilProject);
    res.status(200).json({ message: 'Laporan berhasil diperbarui', data: result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
};
