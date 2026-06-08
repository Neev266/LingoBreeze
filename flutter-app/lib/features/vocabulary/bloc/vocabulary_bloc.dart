import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../api/api.dart';
import '../models/vocabulary_model.dart';
import 'vocabulary_event.dart';
import 'vocabulary_state.dart';

class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  final ApiService apiService;
  final FirebaseFirestore firestore;

  VocabularyBloc({
    required this.apiService,
    required this.firestore,
  }) : super(VocabularyInitial()) {
    on<LoadSavedWordsEvent>(_onLoadSavedWords);
    on<SaveWordEvent>(_onSaveWord);
    on<DeleteWordEvent>(_onDeleteWord);
  }

  Future<void> _onLoadSavedWords(
    LoadSavedWordsEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    emit(VocabularyLoading());
    try {
      final snapshot = await firestore
          .collection('vocabulary')
          .orderBy('createdAt', descending: true)
          .get();

      final words = snapshot.docs
          .map((doc) => VocabularyModel.fromFirestore(doc.data(), doc.id))
          .toList();

      emit(VocabularyLoaded(words));
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('not_found') || errStr.contains('database (default) does not exist') || errStr.contains('not-found')) {
        emit(const VocabularyError('Cloud Firestore has not been initialized for this project. Please go to your Firebase Console and click "Create Database".'));
      } else {
        emit(VocabularyError('Failed to fetch saved words: $e'));
      }
    }
  }

  Future<void> _onSaveWord(
    SaveWordEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    emit(VocabularyLoading());
    try {
      // Check if word already exists to avoid duplicates
      final existing = await firestore
          .collection('vocabulary')
          .where('word', isEqualTo: event.word.word)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        throw Exception('"${event.word.word}" is already saved in your vocabulary.');
      }

      await firestore.collection('vocabulary').add(event.word.toFirestore());
      
      // Reload words
      final snapshot = await firestore
          .collection('vocabulary')
          .orderBy('createdAt', descending: true)
          .get();

      final words = snapshot.docs
          .map((doc) => VocabularyModel.fromFirestore(doc.data(), doc.id))
          .toList();

      emit(VocabularyLoaded(words, successMessage: '"${event.word.word}" saved successfully!'));
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('not_found') || errStr.contains('database (default) does not exist') || errStr.contains('not-found')) {
        emit(const VocabularyError('Cloud Firestore has not been initialized for this project. Please go to your Firebase Console and click "Create Database".'));
      } else {
        emit(VocabularyError(e.toString().replaceAll('Exception: ', '')));
      }
    }
  }

  Future<void> _onDeleteWord(
    DeleteWordEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    emit(VocabularyLoading());
    try {
      await firestore.collection('vocabulary').doc(event.docId).delete();
      
      // Reload words
      final snapshot = await firestore
          .collection('vocabulary')
          .orderBy('createdAt', descending: true)
          .get();

      final words = snapshot.docs
          .map((doc) => VocabularyModel.fromFirestore(doc.data(), doc.id))
          .toList();

      emit(VocabularyLoaded(words, successMessage: '"${event.wordName}" deleted successfully!'));
    } catch (e) {
      emit(VocabularyError('Failed to delete word: $e'));
    }
  }
}
