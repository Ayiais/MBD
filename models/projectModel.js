const pool = require('../config/db');

const addProject = async (data) => {
  const query = `
    CALL add_project(?, ?, ?, ?, ?, ?)
  `;
  const [result] = await pool.query(query, [
    data.title,
    data.deskripsi,
    data.status_project,
    data.anggaran,
    data.tanggal_project,
    data.username,
  ]);
  return result;
};

const updateProject = async (data) => {
  const query = `
    CALL update_project(?, ?, ?, ?, ?, ?)
  `;
  const [result] = await pool.query(query, [
    data.old_title,
    data.new_title,
    data.deskripsi,
    data.status_project,
    data.anggaran,
    data.tanggal_project,
  ]);
  return result;
};

const deleteProjectByTitle = async (title) => {
  const query = `
    CALL delete_project_by_title(?)
  `;
  const [result] = await pool.query(query, [title]);
  return result;
};

const readProject = async (title) => {
  const query = `CALL read_project(?)`;  // Memanggil prosedur read_project
  const [result] = await pool.query(query, [title]);  // Menjalankan query dengan parameter _title
  return result;
};

const updateProjectToCompleted = async (projectName) => {
  const query = `CALL update_project_to_completed(?)`;
  const result = await pool.query(query, [projectName]);
  return result[0];  // Mengembalikan hasil dari query
};

module.exports = {
  addProject,
  updateProject,
  deleteProjectByTitle,
  readProject,
  updateProjectToCompleted,
};
