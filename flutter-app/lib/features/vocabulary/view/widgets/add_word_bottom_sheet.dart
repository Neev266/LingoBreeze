import 'package:flutter/material.dart';
import 'package:lingobreeze/main.dart' show sl;
import 'package:lingobreeze/features/api/api.dart';
import 'package:lingobreeze/features/vocabulary/models/vocabulary_model.dart';

class AddWordBottomSheet extends StatefulWidget {
  final List<VocabularyModel> alreadySavedWords;
  final Function(VocabularyModel) onSave;

  const AddWordBottomSheet({
    super.key,
    required this.alreadySavedWords,
    required this.onSave,
  });

  @override
  State<AddWordBottomSheet> createState() => _AddWordBottomSheetState();
}

class _AddWordBottomSheetState extends State<AddWordBottomSheet> {
  final ApiService _apiService = sl<ApiService>();
  
  List<VocabularyModel> _backendWords = [];
  VocabularyModel? _selectedWord;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchWords();
  }

  Future<void> _fetchWords() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final words = await _apiService.getWords();
      setState(() {
        _backendWords = words;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  bool _isAlreadySaved(VocabularyModel word) {
    return widget.alreadySavedWords.any(
      (saved) => saved.word.toLowerCase() == word.word.toLowerCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 24, left: 16, right: 16),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Add New Vocabulary',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a word from our language server to save.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: _buildContent(theme),
          ),
          
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: (_selectedWord == null || _isSaving)
                  ? null
                  : () async {
                      setState(() {
                        _isSaving = true;
                      });
                      final navigator = Navigator.of(context);
                      await widget.onSave(_selectedWord!);
                      if (mounted) {
                        setState(() {
                          _isSaving = false;
                        });
                        navigator.pop();
                      }
                    },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Save Word',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Fetching words from server...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                'Failed to load words',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _fetchWords,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
              )
            ],
          ),
        ),
      );
    }

    if (_backendWords.isEmpty) {
      return const Center(
        child: Text('No words available from backend.'),
      );
    }

    return ListView.builder(
      itemCount: _backendWords.length,
      itemBuilder: (context, index) {
        final word = _backendWords[index];
        final saved = _isAlreadySaved(word);
        final isSelected = _selectedWord == word;

        return Card(
          elevation: isSelected ? 1 : 0,
          color: isSelected 
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4) 
              : (saved ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2) : Colors.transparent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected 
                  ? theme.colorScheme.primary 
                  : (saved ? Colors.transparent : Colors.grey[300]!),
              width: isSelected ? 2 : 1,
            ),
          ),
          margin: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: saved
                ? null
                : () {
                    setState(() {
                      _selectedWord = isSelected ? null : word;
                    });
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          word.word,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: saved ? theme.disabledColor : theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          word.meaning,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: saved ? theme.disabledColor : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Translation: ${word.translation}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: saved ? theme.disabledColor : theme.colorScheme.primary.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (saved)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline_rounded, 
                            size: 14, 
                            color: theme.colorScheme.outline
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Saved',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.outline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: theme.colorScheme.primary,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
