import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/premium_scaffold.dart';
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
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return PremiumScaffold(
          title: 'Vocabulary Builder',
          urduTitle: 'موضوعاتی ذخیرہ الفاظ (16+ Topics)',
          badgeText: '1,000+ Words',
          gradient: AppColors.vocabularyGradient,
          headerBottom: PremiumSearchField(
            controller: _searchController,
            onChanged: _viewModel.searchCategories,
            onClear: () {
              _searchController.clear();
              _viewModel.searchCategories('');
            },
            hintText: 'Search topics (Sports, Food, پھل)...',
            accentColor: AppColors.emerald,
          ),
          body: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _viewModel.filteredCategories.isEmpty
                  ? const Center(
                      child: Text(
                        'No vocabulary topics found',
                        style: TextStyle(color: AppColors.textLight),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                      itemCount: _viewModel.filteredCategories.length,
                      separatorBuilder: (context, index) =>
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
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: AppColors.vocabularyGradient,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.emerald.withAlpha(55),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cat.englishName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      cat.urduName,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.urduGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.emerald.withAlpha(22),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppColors.emerald,
                                  size: 14,
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
