const db = require('../config/db');

// Add Feedback
const addFeedback = async (body) => {
    console.log(body);  // Untuk debug, memeriksa body yang diterima
    const data = [
      body.clientUsername,      // Username client
      body.freelancerUsername,  // Username freelancer
      body.projectTitle,        // Title project
      body.komentar,            // Komentar feedback
      body.rating               // Rating feedback
    ];
  
    const query = `
      CALL add_feedback(?, ?, ?, ?, ?);
    `;
  
    // Menjalankan query ke database
    const result = await db.query(query, data);
    return result[0];  // Mengembalikan hasil dari query
  };
  

// Delete Feedback
const deleteFeedback = async (clientUsername, freelancerUsername, projectTitle) => {
    const query = `CALL delete_feedback(?, ?, ?)`;
    try {
      const result = await db.query(query, [clientUsername, freelancerUsername, projectTitle]);
      return result;
    } catch (err) {
      throw err; // Lemparkan error jika ada
    }
  };

// Membaca feedback berdasarkan client, freelancer, dan project title

const readFeedbackByProject = async (clientUsername, freelancerUsername, projectTitle) => {
    try {
        const query = `
            CALL read_feedback(?, ?, ?)
        `;
        const result = await db.query(query, [clientUsername, freelancerUsername, projectTitle]);
        return result;
    } catch (err) {
        throw err; // Jika ada error, lemparkan lagi error-nya
    }
};

// Update Feedback
const updateFeedback = async (clientUsername, freelancerUsername, projectTitle, newKomentar, newRating) => {
    const query = `CALL update_feedback(?, ?, ?, ?, ?)`;
    try {
      const result = await db.query(query, [clientUsername, freelancerUsername, projectTitle, newKomentar, newRating]);
      return result;
    } catch (err) {
      throw err; // Lemparkan error jika ada
    }
  };

// Ekspor semua fungsi menggunakan `module.exports`
module.exports = {
  addFeedback,
  deleteFeedback,
  readFeedbackByProject,
  updateFeedback,
};
