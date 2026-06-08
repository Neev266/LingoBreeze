import 'package:equatable/equatable.dart';
import '../models/vocabulary_model.dart';

abstract class VocabularyState extends Equatable {
  const VocabularyState();

  @override
  List<Object?> get props => [];
}

class VocabularyInitial extends VocabularyState {}

class VocabularyLoading extends VocabularyState {}

class VocabularyLoaded extends VocabularyState {
  final List<VocabularyModel> savedWords;
  final String? successMessage;

  const VocabularyLoaded(this.savedWords, {this.successMessage});

  @override
  List<Object?> get props => [savedWords, successMessage];
}

class VocabularyError extends VocabularyState {
  final String message;

  const VocabularyError(this.message);

  @override
  List<Object?> get props => [message];
}
