const express = require('express');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const dotenv = require('dotenv');
dotenv.config();
const projectRoutes = require('./routes/projectRoutes');
const authRoutes = require('./routes/authRoutes');
const penawaranRoutes = require('./routes/penawaranRoutes');
const feedbackRoutes = require('./routes/feedbackRoutes');
const laporanRoutes = require('./routes/laporanRoutes');
const pembayaranRoutes = require('./routes/pembayaranRoutes');
const functionRoutes = require('./routes/functionRoutes');

const app = express();
app.use(cookieParser());

app.use(bodyParser.json());
app.use('/project', projectRoutes);
app.use('/auth', authRoutes);
app.use('/penawaran', penawaranRoutes);
app.use('/feedback', feedbackRoutes);
app.use('/laporan', laporanRoutes);
app.use('/pembayaran', pembayaranRoutes); 
app.use('/function', functionRoutes);

module.exports = app;
