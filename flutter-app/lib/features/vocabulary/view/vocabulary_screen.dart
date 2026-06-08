import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingobreeze/main.dart' show sl;
import '../models/vocabulary_model.dart';
import '../bloc/vocabulary_bloc.dart';
import '../bloc/vocabulary_event.dart';
import '../bloc/vocabulary_state.dart';
import 'widgets/add_word_bottom_sheet.dart';
import 'widgets/shimmer_loading.dart';
import 'widgets/word_card.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  late final VocabularyBloc _bloc;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _bloc = sl<VocabularyBloc>();
    _bloc.add(LoadSavedWordsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _showAddWordBottomSheet(BuildContext context, VocabularyLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return AddWordBottomSheet(
          alreadySavedWords: state.savedWords,
          onSave: (word) async {
            _bloc.add(SaveWordEvent(word));
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, VocabularyModel word) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
              const SizedBox(width: 8),
              const Text('Delete Word'),
            ],
          ),
          content: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                const TextSpan(text: 'Are you sure you want to delete "'),
                TextSpan(
                  text: word.word,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '" from your vocabulary list?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                _bloc.add(DeleteWordEvent(word.id, word.word));
                Navigator.pop(dialogContext);
              },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Vocabulary',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
        ),
        body: BlocConsumer<VocabularyBloc, VocabularyState>(
          listener: (context, state) {
            if (state is VocabularyLoaded && state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(child: Text(state.successMessage!)),
                    ],
                  ),
                  backgroundColor: Colors.green[700],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            }
            if (state is VocabularyError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: theme.colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is VocabularyLoading || state is VocabularyInitial) {
              return const SingleChildScrollView(
                child: ShimmerLoading(),
              );
            }

            if (state is VocabularyError) {
              return _buildErrorState(theme);
            }

            if (state is VocabularyLoaded) {
              if (state.savedWords.isEmpty) {
                return _buildEmptyState(theme, state);
              }
              return Column(
                children: [
                  _buildSearchBar(theme),
                  Expanded(
                    child: _buildSuccessState(theme, state),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: BlocBuilder<VocabularyBloc, VocabularyState>(
          builder: (context, state) {
            if (state is VocabularyLoaded) {
              return FloatingActionButton.extended(
                onPressed: () => _showAddWordBottomSheet(context, state),
                icon: const Icon(Icons.add_rounded),
                label: const Text(
                  'Add Word',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: SearchBar(
        controller: _searchController,
        hintText: 'Search words...',
        leading: const Icon(Icons.search_rounded),
        trailing: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
            ),
        ],
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, VocabularyLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        _bloc.add(LoadSavedWordsEvent());
        await Future.delayed(const Duration(seconds: 1));
      },
      child: Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '📚',
                  style: TextStyle(fontSize: 64),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "You haven't saved any words yet",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Start expanding your vocabulary today by adding words from our learning servers.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => _showAddWordBottomSheet(context, state),
                icon: const Icon(Icons.add_rounded),
                label: const Text(
                  'Add Your First Word',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 72,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection or server status and try again.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                _bloc.add(LoadSavedWordsEvent());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Retry',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState(ThemeData theme, VocabularyLoaded state) {
    final filteredWords = state.savedWords.where((word) {
      final query = _searchQuery.toLowerCase();
      return word.word.toLowerCase().contains(query) ||
             word.meaning.toLowerCase().contains(query) ||
             word.translation.toLowerCase().contains(query);
    }).toList();

    if (filteredWords.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 64,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                'No matching words found',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try searching for another word, definition, or Hindi translation.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _bloc.add(LoadSavedWordsEvent());
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: filteredWords.length,
        itemBuilder: (context, index) {
          final word = filteredWords[index];
          return WordCard(
            word: word,
            onDelete: () => _showDeleteConfirmationDialog(context, word),
          );
        },
      ),
    );
  }
}
