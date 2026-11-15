import 'package:flutter/material.dart';
import '../../../../data/models/tense_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/speak_button.dart';
import '../view_models/tenses_view_model.dart';

class TenseDetailScreen extends StatefulWidget {
  final TenseCategory tenseCategory;

  const TenseDetailScreen({super.key, required this.tenseCategory});

  @override
  State<TenseDetailScreen> createState() => _TenseDetailScreenState();
}

class _TenseDetailScreenState extends State<TenseDetailScreen>
    with SingleTickerProviderStateMixin {
  final TensesViewModel _viewModel = TensesViewModel();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _viewModel.loadExamples(widget.tenseCategory.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Widget _buildRuleCard({
    required String title,
    required String urduTitle,
    required String englishRule,
    required String urduRule,
    required Color color,
    required IconData icon,
  }) {
    return GlassCard(
      border: Border.all(color: color.withAlpha(50), width: 1.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    Text(
                      urduTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.urduGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            englishRule,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
              height: 1.4,
            ),
          ),
          if (urduRule.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              urduRule,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.urduGreen,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tense = widget.tenseCategory;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tense.englishName,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
            ),
            Text(
              tense.urduName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: AppColors.urduGreen,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textLight,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(icon: Icon(Icons.menu_book_rounded), text: 'Rules & Formula'),
            Tab(icon: Icon(Icons.format_quote_rounded), text: 'Sentence Examples'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Rules
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Definition Card
              GlassCard(
                backgroundColor: AppColors.primary.withAlpha(10),
                border: Border.all(color: AppColors.primary.withAlpha(40)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Definition & Overview',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tense.definitionEnglish,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textDark,
                        height: 1.4,
                      ),
                    ),
                    if (tense.definitionUrdu.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        tense.definitionUrdu,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.urduGreen,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Positive Rule
              _buildRuleCard(
                title: 'Affirmative / Positive Sentence Rule',
                urduTitle: 'مثبت جملہ بنانے کا قاعدہ',
                englishRule: tense.positiveRuleEnglish,
                urduRule: tense.positiveRuleUrdu,
                color: AppColors.emerald,
                icon: Icons.check_circle_outline_rounded,
              ),
              const SizedBox(height: 14),

              // Negative Rule
              _buildRuleCard(
                title: 'Negative Sentence Rule',
                urduTitle: 'منفی جملہ بنانے کا قاعدہ',
                englishRule: tense.negativeRuleEnglish,
                urduRule: tense.negativeRuleUrdu,
                color: AppColors.coral,
                icon: Icons.remove_circle_outline_rounded,
              ),
              const SizedBox(height: 14),

              // Interrogative Rule
              _buildRuleCard(
                title: 'Interrogative / Question Rule',
                urduTitle: 'سوالیہ جملہ بنانے کا قاعدہ',
                englishRule: tense.interrogativeRuleEnglish,
                urduRule: tense.interrogativeRuleUrdu,
                color: AppColors.amber,
                icon: Icons.help_outline_rounded,
              ),
            ],
          ),

          // Tab 2: Examples
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              if (_viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_viewModel.examples.isEmpty) {
                return const Center(
                  child: Text('No examples available for this tense'),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _viewModel.examples.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final ex = _viewModel.examples[index];
                  return GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Example #${index + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Positive
                        _buildSentenceRow(
                          label: 'Positive (+)',
                          english: ex.positiveEnglish,
                          urdu: ex.positiveUrdu,
                          color: AppColors.emerald,
                        ),
                        const SizedBox(height: 10),

                        // Negative
                        _buildSentenceRow(
                          label: 'Negative (-)',
                          english: ex.negativeEnglish,
                          urdu: ex.negativeUrdu,
                          color: AppColors.coral,
                        ),
                        const SizedBox(height: 10),

                        // Interrogative
                        _buildSentenceRow(
                          label: 'Question (?)',
                          english: ex.interrogativeEnglish,
                          urdu: ex.interrogativeUrdu,
                          color: AppColors.amber,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSentenceRow({
    required String label,
    required String english,
    required String urdu,
    required Color color,
  }) {
    if (english.isEmpty && urdu.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const Spacer(),
              SpeakButton(text: english, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            english,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            urdu,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.urduGreen,
            ),
          ),
        ],
      ),
    );
  }
}
