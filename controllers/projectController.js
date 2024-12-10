const projectModel = require('../models/projectModel');

exports.addProject = async (req, res) => {
  try {
    const result = await projectModel.addProject(req.body);
    res.status(201).json({ message: 'Project added successfully', result });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.updateProject = async (req, res) => {
  try {
    const result = await projectModel.updateProject(req.body);
    res.status(200).json({ message: 'Project updated successfully', result });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.deleteProjectByTitle = async (req, res) => {
  try {
    const result = await projectModel.deleteProjectByTitle(req.params.title);
    res.status(200).json({ message: 'Project deleted successfully', result });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Controller untuk membaca proyek berdasarkan judul
exports.readProject = async (req, res) => {
  try {
    const title = req.query.title || null;  // Mengambil parameter title dari query string atau null jika tidak ada
    const result = await projectModel.readProject(title);

    if (result.length === 0) {
      return res.status(404).json({ message: 'Project not found' });
    }

    res.status(200).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.updateProjectToCompleted = async (req, res) => {
  try {
      const { projectName } = req.params; // Menggunakan params untuk mengambil projectName
      const result = await projectModel.updateProjectToCompleted(projectName);
      res.status(200).json({ message: 'Proyek berhasil diubah menjadi Selesai', data: result });
  } catch (error) {
      console.error(error);
      res.status(500).json({ error: error.message });
  }
};
