const express = require('express');
const feedbackController = require('../controllers/feedbackController');
const router = express.Router();

// Route untuk menambahkan feedback
router.post('/add', feedbackController.addFeedback);

// Route untuk menghapus feedback berdasarkan project
router.delete('/delete/:projectTitle', feedbackController.deleteFeedbackByProject);

// Route untuk membaca feedback berdasarkan project
router.get('/read', feedbackController.readFeedbackByProject); // Menggunakan parameter projectTitle

// Route untuk memperbarui feedback
router.put('/update/:projectTitle', feedbackController.updateFeedback); // Menggunakan parameter projectTitle

module.exports = router;
