import 'package:flutter/material.dart';
import '../../../../data/models/dictionary_model.dart';
import '../../../core/services/share_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/speak_button.dart';
import '../view_models/dictionary_view_model.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final DictionaryViewModel _viewModel = DictionaryViewModel();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.loadInitialWords();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _shareWord(DictionaryWord word) {
    final meaningsStr = word.meanings.map((m) => '${m.mean} (${m.roman})').join(', ');
    ShareHelper.shareText(
      'Word: ${word.word}\nUrdu: $meaningsStr\nDefinition: ${word.definition}\n\nLearn English App!',
    );
  }

  void _showWordDetails(DictionaryWord word) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderLight,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          word.word,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      SpeakButton(text: word.word, size: 24),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.share_outlined),
                        onPressed: () => _shareWord(word),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Urdu Meanings Section
                  if (word.meanings.isNotEmpty) ...[
                    const Text(
                      'اردو معانی (Urdu Meanings)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.urduGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: word.meanings.map((m) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.emerald.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.emerald.withAlpha(40)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                m.mean,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.urduGreen,
                                ),
                              ),
                              if (m.roman.isNotEmpty)
                                Text(
                                  m.roman,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textMedium,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                  ],

                  // Definition
                  if (word.definition.isNotEmpty && word.definition != 'not defined') ...[
                    const Text(
                      'English Definition',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      word.definition,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textDark,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Synonyms
                  if (word.synonyms.isNotEmpty && word.synonyms != 'not defined') ...[
                    const Text(
                      'Synonyms (ہم معنی الفاظ)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.sky,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      word.synonyms,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMedium,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Antonyms
                  if (word.antonyms.isNotEmpty && word.antonyms != 'not defined') ...[
                    const Text(
                      'Antonyms (متضاد الفاظ)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      word.antonyms,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMedium,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'English-Urdu Dictionary',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            Text(
              'جامع انگلش اردو لغت (140,000+ الفاظ)',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: AppColors.urduGreen,
              ),
            ),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                child: TextField(
                  controller: _searchController,
                  onChanged: _viewModel.onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search English, Urdu, or Roman (e.g. book, کتاب)...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _viewModel.onSearchChanged('');
                            },
                          )
                        : null,
                  ),
                ),
              ),
              Expanded(
                child: _viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _viewModel.words.isEmpty
                        ? const Center(
                            child: Text(
                              'No matching words found',
                              style: TextStyle(color: AppColors.textLight),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: _viewModel.words.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final word = _viewModel.words[index];
                              final primaryMeaning = word.meanings.isNotEmpty
                                  ? word.meanings.first.mean
                                  : '';
                              final roman = word.meanings.isNotEmpty
                                  ? word.meanings.first.roman
                                  : '';

                              return GlassCard(
                                onTap: () => _showWordDetails(word),
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            word.word,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                          if (primaryMeaning.isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              primaryMeaning,
                                              textDirection: TextDirection.rtl,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.urduGreen,
                                              ),
                                            ),
                                          ],
                                          if (roman.isNotEmpty) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              roman,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                                color: AppColors.textLight,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    SpeakButton(text: word.word, size: 18),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      color: AppColors.textMuted,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
