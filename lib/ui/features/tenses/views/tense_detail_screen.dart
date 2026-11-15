import 'package:flutter/material.dart';
import '../../../../data/models/tense_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/premium_scaffold.dart';
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
      border: Border.all(color: color.withAlpha(55), width: 1.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: color.withAlpha(24),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: color, size: 21),
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
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
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
              fontSize: 14.5,
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
                fontSize: 14.5,
                color: AppColors.urduGreen,
                fontWeight: FontWeight.w600,
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

    return PremiumScaffold(
      title: tense.englishName,
      urduTitle: tense.urduName,
      gradient: AppColors.tensesGradient,
      headerBottom: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(28),
          borderRadius: BorderRadius.circular(14),
        ),
        child: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          labelColor: AppColors.purple,
          unselectedLabelColor: Colors.white,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: 'Rules & Formulas'),
            Tab(text: 'Sentence Examples'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Rules
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              GlassCard(
                backgroundColor: Colors.white,
                border: Border.all(color: AppColors.purple.withAlpha(45)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.purple,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Definition & Overview',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tense.definitionEnglish,
                      style: const TextStyle(
                        fontSize: 14.5,
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
                          fontSize: 14.5,
                          color: AppColors.urduGreen,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _buildRuleCard(
                title: 'Affirmative / Positive Rule',
                urduTitle: 'مثبت جملہ بنانے کا قاعدہ',
                englishRule: tense.positiveRuleEnglish,
                urduRule: tense.positiveRuleUrdu,
                color: AppColors.emerald,
                icon: Icons.check_circle_outline_rounded,
              ),
              const SizedBox(height: 14),
              _buildRuleCard(
                title: 'Negative Sentence Rule',
                urduTitle: 'منفی جملہ بنانے کا قاعدہ',
                englishRule: tense.negativeRuleEnglish,
                urduRule: tense.negativeRuleUrdu,
                color: AppColors.coral,
                icon: Icons.remove_circle_outline_rounded,
              ),
              const SizedBox(height: 14),
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: _viewModel.examples.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final ex = _viewModel.examples[index];
                  return GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.purple.withAlpha(22),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Example #${index + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.purple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildSentenceRow(
                          label: 'Positive (+)',
                          english: ex.positiveEnglish,
                          urdu: ex.positiveUrdu,
                          color: AppColors.emerald,
                        ),
                        const SizedBox(height: 10),
                        _buildSentenceRow(
                          label: 'Negative (-)',
                          english: ex.negativeEnglish,
                          urdu: ex.negativeUrdu,
                          color: AppColors.coral,
                        ),
                        const SizedBox(height: 10),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(42)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
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
          const SizedBox(height: 3),
          Text(
            urdu,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.urduGreen,
            ),
          ),
        ],
      ),
    );
  }
}
