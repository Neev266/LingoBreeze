// 40 vocabulary words with English meaning and Hindi translation
const WORD_LIST = [
  { word: "Resilient", defaultMeaning: "Able to withstand or recover quickly from difficult conditions.", defaultTranslation: "लचीला (Lachila)" },
  { word: "Aesthetic", defaultMeaning: "Concerned with beauty or the appreciation of beauty.", defaultTranslation: "सौंदर्य संबंधी (Soundarya sambandhi)" },
  { word: "Ephemeral", defaultMeaning: "Lasting for a very short time; transient.", defaultTranslation: "क्षणिक (Kshanik)" },
  { word: "Serendipity", defaultMeaning: "The occurrence of events by chance in a happy or beneficial way.", defaultTranslation: "आकस्मिक लाभ (Aakasmik laabh)" },
  { word: "Luminous", defaultMeaning: "Full of or shedding light; bright or shining.", defaultTranslation: "चमकदार (Chamakdaar)" },
  { word: "Eloquence", defaultMeaning: "Fluent or persuasive speaking or writing.", defaultTranslation: "वाक्पटुता (Vaakpatuta)" },
  { word: "Melancholy", defaultMeaning: "A feeling of pensive sadness, typically with no obvious cause.", defaultTranslation: "उदासी (Udaasi)" },
  { word: "Nostalgia", defaultMeaning: "A sentimental longing or wistful affection for a period in the past.", defaultTranslation: "अतीत की याद (Ateet ki yaad)" },
  { word: "Solitude", defaultMeaning: "The state or situation of being alone.", defaultTranslation: "एकांत (Ekaant)" },
  { word: "Benevolent", defaultMeaning: "Well meaning and kindly.", defaultTranslation: "परोपकारी (Paropkari)" },
  { word: "Audacious", defaultMeaning: "Showing a willingness to take surprisingly bold risks.", defaultTranslation: "साहसी (Sahasi)" },
  { word: "Cacophony", defaultMeaning: "A harsh, discordant mixture of sounds.", defaultTranslation: "कोलाहल (Kolahal)" },
  { word: "Conundrum", defaultMeaning: "A confusing and difficult problem or question.", defaultTranslation: "पहेली (Paheli)" },
  { word: "Diaphanous", defaultMeaning: "Light, delicate, and translucent.", defaultTranslation: "पारदर्शी (Paardarshi)" },
  { word: "Epiphany", defaultMeaning: "A moment of sudden and great revelation or realization.", defaultTranslation: "अचानक सूझ (Achanak soojh)" },
  { word: "Fastidious", defaultMeaning: "Very attentive to and concerned about accuracy and detail.", defaultTranslation: "तुनकमिज़ाज (Tunakmizaaj)" },
  { word: "Halcyon", defaultMeaning: "Peaceful and happy, especially denoting a past golden age.", defaultTranslation: "शांत और सुखी (Shant aur sukhi)" },
  { word: "Ineffable", defaultMeaning: "Too great or extreme to be expressed or described in words.", defaultTranslation: "अकथनीय (Akathneeya)" },
  { word: "Juxtaposition", defaultMeaning: "Two things being placed close together with contrasting effect.", defaultTranslation: "तुलनात्मक रूप से पास रखना" },
  { word: "Loquacious", defaultMeaning: "Tending to talk a great deal; talkative.", defaultTranslation: "बातूनी (Baatooni)" },
  { word: "Nefarious", defaultMeaning: "Wicked or criminal.", defaultTranslation: "कुटिल (Kutil)" },
  { word: "Obsequious", defaultMeaning: "Obedient or attentive to an excessive or servile degree.", defaultTranslation: "चापलूस (Chaploos)" },
  { word: "Panacea", defaultMeaning: "A solution or remedy for all difficulties or diseases.", defaultTranslation: "रामबाण (Rambaan)" },
  { word: "Quixotic", defaultMeaning: "Exceedingly idealistic, unrealistic, and impractical.", defaultTranslation: "अव्यावहारिक (Avyavaharik)" },
  { word: "Redolent", defaultMeaning: "Strongly reminiscent or suggestive of something.", defaultTranslation: "याद दिलानेवाला" },
  { word: "Taciturn", defaultMeaning: "Reserved or uncommunicative in speech; saying little.", defaultTranslation: "अल्पभाषी (Alpabhashi)" },
  { word: "Ubiquitous", defaultMeaning: "Present, appearing, or found everywhere.", defaultTranslation: "सर्वव्यापी (Sarvavyapi)" },
  { word: "Vex", defaultMeaning: "Make someone feel annoyed, frustrated, or worried.", defaultTranslation: "तंग करना (Tang karna)" },
  { word: "Zenith", defaultMeaning: "The time at which something is most powerful or successful.", defaultTranslation: "शीर्ष बिंदु (Sheersh bindu)" },
  { word: "Alacrity", defaultMeaning: "Brisk and cheerful readiness.", defaultTranslation: "तत्परता (Tatparata)" },
  { word: "Capricious", defaultMeaning: "Given to sudden and unaccountable changes of mood or behavior.", defaultTranslation: "मनमौजी (Manmauji)" },
  { word: "Ennui", defaultMeaning: "A feeling of listlessness arising from lack of excitement.", defaultTranslation: "ऊब (Oob)" },
  { word: "Flabbergasted", defaultMeaning: "Greatly surprised or astonished.", defaultTranslation: "अचंभित (Achambhit)" },
  { word: "Garrulous", defaultMeaning: "Excessively talkative, especially on trivial matters.", defaultTranslation: "बकवादी (Bakvaadi)" },
  { word: "Harangue", defaultMeaning: "A lengthy and aggressive speech.", defaultTranslation: "उग्र भाषण (Ugra bhashan)" },
  { word: "Insidious", defaultMeaning: "Proceeding in a gradual, subtle way, but with harmful effects.", defaultTranslation: "कपटी (Kapti)" },
  { word: "Maverick", defaultMeaning: "An unorthodox or independent-minded person.", defaultTranslation: "स्वतंत्र विचारों वाला" },
  { word: "Plethora", defaultMeaning: "An large or excessive amount of something.", defaultTranslation: "अधिकता (Adhikata)" },
  { word: "Surreptitious", defaultMeaning: "Kept secret, especially because it would not be approved of.", defaultTranslation: "गुप्त (Gupt)" },
  { word: "Sycophant", defaultMeaning: "A person who acts obsequiously toward someone important.", defaultTranslation: "चापलूस (Chaploos)" }
];

/**
 * Fetches vocabulary words from the local fake dataset.
 */
const fetchWords = async () => {
  console.log("Serving vocabulary words from local fake dataset.");
  return WORD_LIST.map((item, index) => ({
    id: (index + 1).toString(),
    word: item.word,
    meaning: item.defaultMeaning,
    translation: item.defaultTranslation
  }));
};

module.exports = {
  fetchWords,
};
