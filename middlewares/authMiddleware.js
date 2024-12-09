const jwt = require('jsonwebtoken');

// Middleware untuk memeriksa token autentikasi
const authenticateToken = (req, res, next) => {
  // Ambil token dari cookies
  const token = req.cookies.authToken;

  // Jika tidak ada token
  if (!token) {
    return res.status(401).json({ message: 'Access Denied: No Token Provided' });
  }

  try {
    // Verifikasi token
    const verified = jwt.verify(token, process.env.JWT_SECRET);
    req.user = verified; // Simpan data user di objek request
    next(); // Lanjut ke middleware berikutnya
  } catch (err) {
    res.status(403).json({ message: 'Invalid Token' });
  }
};

module.exports = authenticateToken;
