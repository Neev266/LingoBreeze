const express = require('express');
const router = express.Router();
const wordsController = require('../controllers/words.controller');

// Middleware to authenticate requests using public API key
const authenticateApiKey = (req, res, next) => {
  const apiKey = req.headers['x-api-key'] || req.query.apiKey;
  const expectedKey = process.env.PUBLIC_API_KEY;

  if (!expectedKey) {
    return next(); // If no key configured in .env, bypass check
  }

  if (apiKey !== expectedKey) {
    return res.status(401).json({
      success: false,
      message: 'Unauthorized: Missing or invalid API key (x-api-key header or apiKey query param required)',
    });
  }
  next();
};

router.get('/', authenticateApiKey, wordsController.getWords);

module.exports = router;
