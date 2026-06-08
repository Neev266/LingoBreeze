import 'package:equatable/equatable.dart';
import '../models/vocabulary_model.dart';

abstract class VocabularyEvent extends Equatable {
  const VocabularyEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavedWordsEvent extends VocabularyEvent {}

class SaveWordEvent extends VocabularyEvent {
  final VocabularyModel word;

  const SaveWordEvent(this.word);

  @override
  List<Object?> get props => [word];
}

class DeleteWordEvent extends VocabularyEvent {
  final String docId;
  final String wordName;

  const DeleteWordEvent(this.docId, this.wordName);

  @override
  List<Object?> get props => [docId, wordName];
}
