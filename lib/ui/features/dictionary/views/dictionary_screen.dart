import 'package:flutter/material.dart';
import '../../../../data/models/dictionary_model.dart';
import '../../../core/services/share_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/premium_scaffold.dart';
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
    final meaningsStr =
        word.meanings.map((m) => '${m.mean} (${m.roman})').join(', ');
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: DraggableScrollableSheet(
            initialChildSize: 0.72,
            minChildSize: 0.45,
            maxChildSize: 0.92,
            expand: false,
            builder: (context, scrollController) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 4.5,
                        decoration: BoxDecoration(
                          color: AppColors.borderLight,
                          borderRadius: BorderRadius.circular(4),
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
                              fontWeight: FontWeight.w900,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        SpeakButton(
                          text: word.word,
                          size: 22,
                          color: AppColors.indigo,
                          backgroundColor: AppColors.indigo.withAlpha(22),
                        ),
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
                          fontWeight: FontWeight.w800,
                          color: AppColors.urduGreen,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: word.meanings.map((m) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.emerald.withAlpha(18),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.emerald.withAlpha(45),
                              ),
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
                    if (word.definition.isNotEmpty &&
                        word.definition != 'not defined') ...[
                      const Text(
                        'English Definition',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        word.definition,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Synonyms
                    if (word.synonyms.isNotEmpty &&
                        word.synonyms != 'not defined') ...[
                      const Text(
                        'Synonyms (ہم معنی الفاظ)',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.sky,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        word.synonyms,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: AppColors.textMedium,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Antonyms
                    if (word.antonyms.isNotEmpty &&
                        word.antonyms != 'not defined') ...[
                      const Text(
                        'Antonyms (متضاد الفاظ)',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        word.antonyms,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: AppColors.textMedium,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return PremiumScaffold(
          title: 'English-Urdu Dictionary',
          urduTitle: 'جامع انگلش اردو لغت (140,000+ الفاظ)',
          badgeText: 'Offline',
          gradient: AppColors.dictionaryGradient,
          headerBottom: PremiumSearchField(
            controller: _searchController,
            onChanged: _viewModel.onSearchChanged,
            onClear: () {
              _searchController.clear();
              _viewModel.onSearchChanged('');
            },
            hintText: 'Search English, Urdu, or Roman (e.g. book, کتاب)...',
            accentColor: AppColors.indigo,
          ),
          body: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _viewModel.words.isEmpty
                  ? const Center(
                      child: Text(
                        'No matching words found',
                        style: TextStyle(color: AppColors.textLight),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                      itemCount: _viewModel.words.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
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
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.indigo.withAlpha(20),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    word.word.isNotEmpty
                                        ? word.word[0].toUpperCase()
                                        : 'W',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.indigo,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      word.word,
                                      style: const TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    if (primaryMeaning.isNotEmpty) ...[
                                      const SizedBox(height: 3),
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
                              SpeakButton(
                                text: word.word,
                                size: 18,
                                color: AppColors.indigo,
                                backgroundColor:
                                    AppColors.indigo.withAlpha(20),
                              ),
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
        );
      },
    );
  }
}
