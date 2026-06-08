const wordsService = require('../services/words.service');

const getWords = async (req, res, next) => {
  try {
    const words = await wordsService.fetchWords();
    return res.status(200).json(words);
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getWords,
};
