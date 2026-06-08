const express = require('express');
const cors = require('cors');
require('dotenv').config();

const wordsRoutes = require('./routes/words.routes');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/words', wordsRoutes);

// Global Error Handler
app.use((err, req, res, next) => {
  console.error('Unhandled Error:', err.stack);
  res.status(500).json({
    success: false,
    message: err.message || 'Internal Server Error',
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`LingoBreeze Backend is running on port ${PORT}`);
});

module.exports = app;
