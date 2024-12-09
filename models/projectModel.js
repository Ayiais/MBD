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

module.exports = {
  addProject,
  updateProject,
  deleteProjectByTitle,
};
