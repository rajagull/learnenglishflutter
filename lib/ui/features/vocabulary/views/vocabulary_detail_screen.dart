import 'package:flutter/material.dart';
import '../../../../data/models/vocabulary_model.dart';
import '../../../core/services/share_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/premium_scaffold.dart';
import '../../../core/widgets/speak_button.dart';
import '../view_models/vocabulary_view_model.dart';

class VocabularyDetailScreen extends StatefulWidget {
  final VocabularyCategory category;

  const VocabularyDetailScreen({super.key, required this.category});

  @override
  State<VocabularyDetailScreen> createState() => _VocabularyDetailScreenState();
}

class _VocabularyDetailScreenState extends State<VocabularyDetailScreen> {
  final VocabularyViewModel _viewModel = VocabularyViewModel();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.loadItems(widget.category.id);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _shareItem(VocabularyItem item) {
    ShareHelper.shareText(
      'Word: ${item.english}\nUrdu: ${item.urdu}\nPronunciation: ${item.roman}\n\nLearn English with Learn English App!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return PremiumScaffold(
          title: widget.category.englishName,
          urduTitle: widget.category.urduName,
          gradient: AppColors.vocabularyGradient,
          headerBottom: PremiumSearchField(
            controller: _searchController,
            onChanged: _viewModel.searchItems,
            onClear: () {
              _searchController.clear();
              _viewModel.searchItems('');
            },
            hintText: 'Search words in this topic...',
            accentColor: AppColors.emerald,
          ),
          body: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _viewModel.filteredItems.isEmpty
                  ? const Center(
                      child: Text(
                        'No words found in this topic',
                        style: TextStyle(color: AppColors.textLight),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                      itemCount: _viewModel.filteredItems.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = _viewModel.filteredItems[index];
                        return GlassCard(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.english.trim(),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.urdu,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.urduGreen,
                                      ),
                                    ),
                                    if (item.roman.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        item.roman,
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
                                text: item.english,
                                color: AppColors.emerald,
                                backgroundColor:
                                    AppColors.emerald.withAlpha(25),
                              ),
                              const SizedBox(width: 8),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () => _shareItem(item),
                                  child: const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Icon(
                                      Icons.share_outlined,
                                      size: 18,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ),
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
