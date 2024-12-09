const jwt = require('jsonwebtoken');
const authModel = require('../models/authModel');

// Generate JWT Token
const generateToken = (user) => {
  return jwt.sign(
    { userId: user.user_id, username: user.username, role: user.is_role },
    process.env.JWT_SECRET,
    { expiresIn: '1d' }
  );
};

// Register User
exports.register = async (req, res) => {
    try {
      const { username, email, password_user, is_role } = req.body;
  
      // Hapus validasi panjang password di backend jika sudah ada di SQL
      // const passwordMinLength = 8;
      // if (!password_user || password_user.length < passwordMinLength) {
      //   return res.status(400).json({ error: 'Panjang password minimal 8 karakter' });
      // }
  
      // Panggil model untuk registrasi
      const result = await authModel.registerUser(req.body);
      res.status(201).json({ message: 'User registered successfully', result });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: error.message });
    }
};
   

// Login User
exports.login = async (req, res) => {
  try {
    const result = await authModel.loginUser(req.body);

    if (result.length > 0) {
      const user = result[0];
      const token = generateToken(user);

      // Set token in cookies
      res.cookie('authToken', token, {
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production',
        maxAge: 24 * 60 * 60 * 1000, // 1 day
      });

      res.status(200).json({
        message: 'Login successful',
        token,
        user: { id: user.user_id, username: user.username, email: user.email },
      });
    } else {
      res.status(401).json({ message: 'Invalid username or password' });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Logout User
exports.logout = (req, res) => {
  res.clearCookie('authToken');
  res.status(200).json({ message: 'Logout successful' });
};
