import 'package:flutter/material.dart';
import '../../../../data/models/vocabulary_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../view_models/vocabulary_view_model.dart';
import 'vocabulary_detail_screen.dart';

class VocabularyCategoriesScreen extends StatefulWidget {
  const VocabularyCategoriesScreen({super.key});

  @override
  State<VocabularyCategoriesScreen> createState() =>
      _VocabularyCategoriesScreenState();
}

class _VocabularyCategoriesScreenState
    extends State<VocabularyCategoriesScreen> {
  final VocabularyViewModel _viewModel = VocabularyViewModel();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  IconData _getTopicIcon(int id) {
    switch (id) {
      case 1:
        return Icons.accessibility_new_rounded; // body parts
      case 2:
        return Icons.access_time_filled_rounded; // time
      case 3:
        return Icons.waving_hand_rounded; // hello
      case 4:
        return Icons.warning_amber_rounded; // disasters
      case 5:
        return Icons.announcement_rounded; // complaints
      case 6:
        return Icons.back_hand_rounded; // goodbye
      case 7:
        return Icons.calendar_today_rounded; // routines
      case 8:
        return Icons.format_list_numbered_rounded; // 50 nouns
      case 9:
        return Icons.eco_rounded; // fruits & veggies
      case 10:
        return Icons.checkroom_rounded; // clothing actions
      case 11:
        return Icons.apple_rounded; // fruits
      case 12:
        return Icons.restaurant_menu_rounded; // cooking
      case 13:
        return Icons.dry_cleaning_rounded; // clothes
      case 14:
        return Icons.palette_rounded; // hobbies
      case 15:
        return Icons.groups_rounded; // family
      case 16:
        return Icons.sports_soccer_rounded; // sports
      default:
        return Icons.school_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vocabulary Builder',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            Text(
              'موضوعاتی ذخیرہ الفاظ',
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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: _viewModel.searchCategories,
                  decoration: InputDecoration(
                    hintText: 'Search topics (Sports, Food, پھل)...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.emerald),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _viewModel.searchCategories('');
                            },
                          )
                        : null,
                  ),
                ),
              ),
              Expanded(
                child: _viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _viewModel.filteredCategories.isEmpty
                        ? const Center(
                            child: Text(
                              'No vocabulary topics found',
                              style: TextStyle(color: AppColors.textLight),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: _viewModel.filteredCategories.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final cat = _viewModel.filteredCategories[index];
                              return GlassCard(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          VocabularyDetailScreen(category: cat),
                                    ),
                                  );
                                },
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        gradient: AppColors.vocabularyGradient,
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      child: Icon(
                                        _getTopicIcon(cat.id),
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cat.englishName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            cat.urduName,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.urduGreen,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
