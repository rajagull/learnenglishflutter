import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../data/models/vocabulary_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
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
    SharePlus.share(
      'Word: ${item.english}\nUrdu: ${item.urdu}\nPronunciation: ${item.roman}\n\nLearn English with Learn English App!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category.englishName,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
            ),
            Text(
              widget.category.urduName,
              style: const TextStyle(
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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: _viewModel.searchItems,
                  decoration: InputDecoration(
                    hintText: 'Search words in this topic...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.emerald),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _viewModel.searchItems('');
                            },
                          )
                        : null,
                  ),
                ),
              ),
              Expanded(
                child: _viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _viewModel.filteredItems.isEmpty
                        ? const Center(
                            child: Text(
                              'No words found in this topic',
                              style: TextStyle(color: AppColors.textLight),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: _viewModel.filteredItems.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = _viewModel.filteredItems[index];
                              return GlassCard(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
              ),
            ],
          );
        },
      ),
    );
  }
}
