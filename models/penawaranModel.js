const db = require('../config/db'); // Koneksi database

// Fungsi untuk menambahkan penawaran
const addPenawaran = async (body) => {
    console.log(body)
    const data = [
        body.username,
        body.project_title,
        body.banding_penawaran,
        body.deskripsi_penawaran,
        body.tanggal_penawaran,
        body.status_penawaran
    ]
    const query = `
      CALL add_penawaran(?, ?, ?, ?, ?, ?);
    `;  
    const result = await db.query(query, data);
    return result[0];
};

// Fungsi untuk menghapus penawaran berdasarkan project
// Fungsi untuk menghapus penawaran berdasarkan project
const deletePenawaranByProject = async (projectTitle) => {
  const query = `
      CALL delete_penawaran_by_project(?);
  `;
  try {
      const [result] = await db.query(query, [projectTitle]);
      return result[0]; // Mengembalikan hasil prosedur
  } catch (err) {
      console.error("Error:", err); // Log error untuk debugging
      throw err;
  }
};

// Fungsi untuk menerima penawaran berdasarkan project
const acceptPenawaranByProject = async (projectTitle) => {
  const query = `CALL accept_penawaran_by_project(?);`;
  try {
      console.log("Mengirim projectTitle ke prosedur:", projectTitle); // Log untuk debug
      const [result] = await db.query(query, [projectTitle]);
      return result[0];
  } catch (err) {
      console.error("Error:", err); // Log error untuk debugging
      throw err;
  }
};

const checkProjectExistence = async (projectTitle) => {
  const query = `SELECT project_id FROM project WHERE title = ?;`;
  try {
    const [result] = await db.query(query, [projectTitle]);
    return result.length > 0 ? result[0].project_id : null;
  } catch (err) {
    console.error("Error in checkProjectExistence:", err);
    throw err;
  }
};


// Fungsi untuk membaca semua penawaran
const readAllPenawaran = async () => {
  const query = `
      CALL read_all_penawaran();
  `;
  try {
      const [result] = await db.query(query);
      return result[0]; // Mengembalikan hasil prosedur
  } catch (err) {
      console.error("Error:", err); // Log error untuk debugging
      throw err;
  }
};


module.exports = {
  addPenawaran,
  deletePenawaranByProject,
  acceptPenawaranByProject,
  readAllPenawaran,
  checkProjectExistence,
};
