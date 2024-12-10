const feedbackModel = require('../models/feedbackModel');

// Menambahkan feedback
exports.addFeedback = async (req, res) => {
    try {
      // Memanggil model untuk menambahkan feedback
      const result = await feedbackModel.addFeedback(req.body);
      // Mengirim response sukses jika feedback berhasil ditambahkan
      res.status(201).json({ message: 'Feedback berhasil ditambahkan', result });
    } catch (error) {
      // Mengirim response error jika terjadi masalah
      console.error(error);
      res.status(500).json({ error: error.message });
    }
  };  

// Menghapus feedback berdasarkan project
// Menghapus feedback berdasarkan project
exports.deleteFeedbackByProject = async (req, res) => {
    try {
      const { projectTitle } = req.params; // Menggunakan params untuk mengambil projectTitle
      const { usernameClient, usernameFreelancer } = req.body; // Mendapatkan usernameClient dan usernameFreelancer dari body
  
      // Pastikan semua parameter ada
      if (!usernameClient || !usernameFreelancer || !projectTitle) {
        return res.status(400).json({ message: 'Parameter tidak lengkap' });
      }
  
      // Panggil model untuk menghapus feedback
      const result = await feedbackModel.deleteFeedback(usernameClient, usernameFreelancer, projectTitle);
  
      res.status(200).json({ message: 'Feedback berhasil dihapus', data: result });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: error.message });
    }
  };
  

// Membaca feedback berdasarkan proyek dan pengguna
exports.readFeedbackByProject = async (req, res) => {
    try {
        const { projectTitle } = req.query; // Ambil query string projectTitle
        const { usernameClient, usernameFreelancer } = req.query; // Ambil query string usernameClient dan usernameFreelancer

        if (!usernameClient || !usernameFreelancer || !projectTitle) {
            return res.status(400).json({ message: 'Parameter tidak lengkap' });
        }

        // Panggil model untuk membaca feedback
        const result = await feedbackModel.readFeedbackByProject(usernameClient, usernameFreelancer, projectTitle);

        if (result.length === 0) {
            return res.status(404).json({ message: 'Feedback tidak ditemukan untuk proyek ini' });
        }

        res.status(200).json({ data: result });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: error.message });
    }
};


// Memperbarui feedback
exports.updateFeedback = async (req, res) => {
    try {
      const { projectTitle } = req.params; // Menggunakan params untuk mengambil projectTitle
      const { usernameClient, usernameFreelancer, newComment, newRating } = req.body; // Mendapatkan data dari request body
  
      // Pastikan semua data yang diperlukan tersedia
      if (!usernameClient || !usernameFreelancer || !projectTitle || !newComment || !newRating) {
        return res.status(400).json({ message: 'Parameter tidak lengkap' });
      }
  
      // Panggil model untuk memperbarui feedback
      const result = await feedbackModel.updateFeedback(usernameClient, usernameFreelancer, projectTitle, newComment, newRating);
  
      res.status(200).json({ message: 'Feedback berhasil diperbarui', data: result });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: error.message });
    }
  };
