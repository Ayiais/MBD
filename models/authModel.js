const pool = require('../config/db');

const registerUser = async (data) => {
    const query = `
      CALL register(?, ?, ?, ?)
    `;
    const [result] = await pool.query(query, [
      data.username,
      data.email,
      data.password_user,
      data.is_role
    ]);
    return result;
};
  
  

const loginUser = async (data) => {
  const query = `
    CALL login(?, ?)
  `;
  const [result] = await pool.query(query, [data.username, data.password]);
  return result;
};

module.exports = {
  registerUser,
  loginUser,
};
