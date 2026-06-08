import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class VocabularyModel extends Equatable {
  final String id;
  final String word;
  final String meaning;
  final String translation;
  final DateTime? createdAt;

  const VocabularyModel({
    required this.id,
    required this.word,
    required this.meaning,
    required this.translation,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, word, meaning, translation, createdAt];

  factory VocabularyModel.fromJson(Map<String, dynamic> json) {
    return VocabularyModel(
      id: json['id']?.toString() ?? '',
      word: json['word'] ?? '',
      meaning: json['meaning'] ?? '',
      translation: json['translation'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'translation': translation,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory VocabularyModel.fromFirestore(Map<String, dynamic> json, String docId) {
    DateTime? createdTime;
    final rawCreated = json['createdAt'];
    if (rawCreated is Timestamp) {
      createdTime = rawCreated.toDate();
    } else if (rawCreated is String) {
      createdTime = DateTime.tryParse(rawCreated);
    }
    
    return VocabularyModel(
      id: docId,
      word: json['word'] ?? '',
      meaning: json['meaning'] ?? '',
      translation: json['translation'] ?? '',
      createdAt: createdTime,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'word': word,
      'meaning': meaning,
      'translation': translation,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
