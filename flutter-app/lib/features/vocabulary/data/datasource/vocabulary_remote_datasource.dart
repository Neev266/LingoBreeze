import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:lingobreeze/features/vocabulary/models/vocabulary_model.dart';


abstract class VocabularyRemoteDataSource {
  Future<List<VocabularyModel>> fetchBackendWords();
  Future<List<VocabularyModel>> fetchSavedWords();
  Future<void> saveWordToFirestore(VocabularyModel word);
  Future<void> deleteWordFromFirestore(String docId);
}

class VocabularyRemoteDataSourceImpl implements VocabularyRemoteDataSource {
  final Dio dio;
  final FirebaseFirestore firestore;

  VocabularyRemoteDataSourceImpl({
    required this.dio,
    required this.firestore,
  });

  String get _backendUrl {
    return 'http://10.103.247.228:3000';
  }

  @override
  Future<List<VocabularyModel>> fetchBackendWords() async {
    try {
      final response = await dio.get(
        '$_backendUrl/words',
        options: Options(
          headers: const {
            'x-api-key': 'lingobreeze_public_key_2026',
          },
          connectTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => VocabularyModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch words from backend: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred fetching backend words: $e');
    }
  }

  @override
  Future<List<VocabularyModel>> fetchSavedWords() async {
    try {
      final snapshot = await firestore
          .collection('vocabulary')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => VocabularyModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('not_found') || errStr.contains('database (default) does not exist') || errStr.contains('not-found')) {
        throw Exception('Cloud Firestore has not been initialized for this project. Please go to your Firebase Console and click "Create Database".');
      }
      throw Exception('Failed to fetch saved words from Firestore: $e');
    }
  }

  @override
  Future<void> saveWordToFirestore(VocabularyModel word) async {
    try {
      // Check if word already exists to avoid duplicates (optional check)
      final existing = await firestore
          .collection('vocabulary')
          .where('word', isEqualTo: word.word)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        throw Exception('"${word.word}" is already saved in your vocabulary.');
      }

      await firestore.collection('vocabulary').add(word.toFirestore());
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('not_found') || errStr.contains('database (default) does not exist') || errStr.contains('not-found')) {
        throw Exception('Cloud Firestore has not been initialized for this project. Please go to your Firebase Console and click "Create Database".');
      }
      throw Exception('Failed to save word: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  @override
  Future<void> deleteWordFromFirestore(String docId) async {
    try {
      await firestore.collection('vocabulary').doc(docId).delete();
    } catch (e) {
      throw Exception('Failed to delete word: $e');
    }
  }
}
