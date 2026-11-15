import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../view_models/tenses_view_model.dart';
import 'tense_detail_screen.dart';

class TensesListScreen extends StatefulWidget {
  const TensesListScreen({super.key});

  @override
  State<TensesListScreen> createState() => _TensesListScreenState();
}

class _TensesListScreenState extends State<TensesListScreen> {
  final TensesViewModel _viewModel = TensesViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadTenses();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'English Tenses Mastery',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            Text(
              'انگریزی کے تمام ۱۲ زمانے اور قواعد',
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
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Filter chips for Present, Past, Future
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    FilterChip(
                      selected: _viewModel.selectedTenseId == null,
                      label: const Text('All 12 Tenses'),
                      onSelected: (_) => _viewModel.filterByMainTense(null),
                      selectedColor: AppColors.primaryLight.withAlpha(50),
                    ),
                    const SizedBox(width: 8),
                    ..._viewModel.mainTenses.map((mt) {
                      final isSelected = _viewModel.selectedTenseId == mt.id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(mt.name),
                          onSelected: (_) => _viewModel.filterByMainTense(mt.id),
                          selectedColor: AppColors.primaryLight.withAlpha(50),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: _viewModel.visibleCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _viewModel.visibleCategories[index];
                    return GlassCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TenseDetailScreen(tenseCategory: item),
                          ),
                        );
                      },
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: AppColors.tensesGradient,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.access_time_filled_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.englishName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.urduName,
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
                          const SizedBox(height: 10),
                          Text(
                            item.definitionEnglish,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textLight,
                              height: 1.3,
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
