const express = require('express');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const dotenv = require('dotenv');
dotenv.config();
const projectRoutes = require('./routes/projectRoutes');
const authRoutes = require('./routes/authRoutes');

const app = express();
app.use(cookieParser());

app.use(bodyParser.json());
app.use('/api/project', projectRoutes);
app.use('/auth', authRoutes);

module.exports = app;
