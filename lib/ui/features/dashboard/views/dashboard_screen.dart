import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/category_card.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/speak_button.dart';
import '../../../core/widgets/stats_badge.dart';
import '../../ai_tutor/views/ai_agent_call_screen.dart';
import '../../conversation/views/conversation_categories_screen.dart';
import '../../dictionary/views/dictionary_screen.dart';
import '../../idioms/views/idioms_screen.dart';
import '../../phrases/views/phrases_screen.dart';
import '../../practice/views/practice_quiz_screen.dart';
import '../../singular_plural/views/singular_plural_screen.dart';
import '../../tenses/views/tenses_list_screen.dart';
import '../../vocabulary/views/vocabulary_categories_screen.dart';
import '../view_models/dashboard_view_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardViewModel _viewModel = DashboardViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadDashboardData();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            if (_viewModel.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading databases and learning modules...',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              );
            }

            final stats = _viewModel.stats;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top App Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Learn English',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.textDark,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.heroGradient,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'PRO',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'انگریزی سیکھیں اور روانی سے بولیں',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.urduGreen,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton.filledTonal(
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.surfaceElevated,
                              ),
                              icon: const Icon(
                                Icons.search_rounded,
                                color: AppColors.primary,
                              ),
                              tooltip: 'Open Dictionary Search',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const DictionaryScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 6),
                            IconButton.filledTonal(
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.surfaceElevated,
                              ),
                              icon: const Icon(
                                Icons.refresh_rounded,
                                color: AppColors.textMedium,
                              ),
                              tooltip: 'Refresh Daily Spotlight',
                              onPressed: _viewModel.refreshDailyFeatured,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Hero Card: AI Agent Voice Tutor
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.aiCallGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondary.withAlpha(90),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            top: -20,
                            child: Icon(
                              Icons.psychology_rounded,
                              size: 140,
                              color: Colors.white.withAlpha(30),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.mic_rounded,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'AI Voice Agent',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.emerald,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'READY',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'Call AI Agent to Improve English',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'اے آئی سے براہ راست بول چال کریں اور تلفظ بہتر بنائیں',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.primaryDark,
                                    elevation: 2,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.phone_in_talk_rounded,
                                    color: AppColors.primary,
                                  ),
                                  label: const Text(
                                    'Start Speaking Call',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const AiAgentCallScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Live Database Stats Row
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    child: Row(
                      children: [
                        StatsBadge(
                          icon: Icons.menu_book_rounded,
                          label: 'Dictionary Words',
                          count: '${stats.dictionaryCount}+',
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        StatsBadge(
                          icon: Icons.lightbulb_rounded,
                          label: 'Idioms & Proverbs',
                          count: '${stats.idiomsCount}+',
                          color: AppColors.amber,
                        ),
                        const SizedBox(width: 10),
                        StatsBadge(
                          icon: Icons.chat_bubble_rounded,
                          label: 'Dialogues (${stats.conversationCategories} Topics)',
                          count: '${stats.conversationDialogues}',
                          color: AppColors.sky,
                        ),
                        const SizedBox(width: 10),
                        StatsBadge(
                          icon: Icons.access_time_filled_rounded,
                          label: 'English Tenses',
                          count: '${stats.tensesCount}',
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 10),
                        StatsBadge(
                          icon: Icons.format_list_bulleted_rounded,
                          label: 'Vocab (${stats.vocabularyCategories} Topics)',
                          count: '${stats.vocabularyItems}',
                          color: AppColors.emerald,
                        ),
                        const SizedBox(width: 10),
                        StatsBadge(
                          icon: Icons.compare_arrows_rounded,
                          label: 'Singular/Plural',
                          count: '${stats.singularPluralCount}',
                          color: AppColors.coral,
                        ),
                      ],
                    ),
                  ),
                ),

                // Daily Spotlight: Idiom & Word of the Day
                if (_viewModel.dailyIdiom != null || _viewModel.dailyWord != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                color: Colors.amber,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Daily Learning Spotlight',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (_viewModel.dailyIdiom != null)
                            GlassCard(
                              padding: const EdgeInsets.all(16),
                              border: Border.all(
                                color: AppColors.amber.withAlpha(50),
                                width: 1.2,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.amber.withAlpha(25),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          'Idiom of the Day • محاورہ',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.amber,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      SpeakButton(
                                        text: _viewModel.dailyIdiom!.displayEnglish,
                                        color: AppColors.amber,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _viewModel.dailyIdiom!.displayEnglish,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _viewModel.dailyIdiom!.urdu,
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.urduGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                // Category Filter Pills
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Learning Modules & Categories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip(
                                label: 'All Modules',
                                filter: DashboardCategoryFilter.all,
                              ),
                              const SizedBox(width: 8),
                              _buildFilterChip(
                                label: 'Grammar & Core',
                                filter: DashboardCategoryFilter.grammar,
                              ),
                              const SizedBox(width: 8),
                              _buildFilterChip(
                                label: 'Dictionary & Words',
                                filter: DashboardCategoryFilter.reference,
                              ),
                              const SizedBox(width: 8),
                              _buildFilterChip(
                                label: 'Practice & AI',
                                filter: DashboardCategoryFilter.practice,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Categorized Grid / List
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(_buildFilteredCards(context)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required DashboardCategoryFilter filter,
  }) {
    final isSelected = _viewModel.selectedFilter == filter;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _viewModel.setFilter(filter),
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textMedium,
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
      backgroundColor: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.borderLight,
        ),
      ),
    );
  }

  List<Widget> _buildFilteredCards(BuildContext context) {
    final filter = _viewModel.selectedFilter;
    final List<Widget> cards = [];

    // 1. Conversations
    if (filter == DashboardCategoryFilter.all ||
        filter == DashboardCategoryFilter.grammar) {
      cards.add(
        CategoryCard(
          title: 'Daily Conversations',
          urduTitle: 'روزمرہ بول چال',
          subtitle: 'Real-life dialogues with Urdu translation & pronunciation',
          icon: Icons.chat_bubble_rounded,
          gradient: AppColors.conversationGradient,
          badge: '${_viewModel.stats.conversationCategories} Topics • ${_viewModel.stats.conversationDialogues} Dialogues',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ConversationCategoriesScreen(),
              ),
            );
          },
        ),
      );
      cards.add(const SizedBox(height: 12));
    }

    // 2. Tenses
    if (filter == DashboardCategoryFilter.all ||
        filter == DashboardCategoryFilter.grammar) {
      cards.add(
        CategoryCard(
          title: 'English Tenses Mastery',
          urduTitle: 'انگریزی زمانے اور قواعد',
          subtitle: 'Present, Past, Future tenses with positive, negative & question formulas',
          icon: Icons.access_time_filled_rounded,
          gradient: AppColors.tensesGradient,
          badge: '12 Tenses • Complete Formulas',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TensesListScreen()),
            );
          },
        ),
      );
      cards.add(const SizedBox(height: 12));
    }

    // 3. Vocabulary
    if (filter == DashboardCategoryFilter.all ||
        filter == DashboardCategoryFilter.grammar) {
      cards.add(
        CategoryCard(
          title: 'Vocabulary Builder',
          urduTitle: 'موضوعاتی ذخیرہ الفاظ',
          subtitle: 'Essential words categorized by body, food, hobbies & routines',
          icon: Icons.format_list_bulleted_rounded,
          gradient: AppColors.vocabularyGradient,
          badge: '${_viewModel.stats.vocabularyCategories} Topics • ${_viewModel.stats.vocabularyItems} Words',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const VocabularyCategoriesScreen(),
              ),
            );
          },
        ),
      );
      cards.add(const SizedBox(height: 12));
    }

    // 4. Dictionary
    if (filter == DashboardCategoryFilter.all ||
        filter == DashboardCategoryFilter.reference) {
      cards.add(
        CategoryCard(
          title: 'English-Urdu Dictionary',
          urduTitle: 'جامع انگلش اردو لغت',
          subtitle: 'Over 140,000 words with definitions, synonyms, antonyms & Roman Urdu',
          icon: Icons.menu_book_rounded,
          gradient: AppColors.dictionaryGradient,
          badge: '140,000+ Words • 300K+ Meanings',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DictionaryScreen()),
            );
          },
        ),
      );
      cards.add(const SizedBox(height: 12));
    }

    // 5. Idioms
    if (filter == DashboardCategoryFilter.all ||
        filter == DashboardCategoryFilter.reference) {
      cards.add(
        CategoryCard(
          title: 'Idioms & Proverbs',
          urduTitle: 'محاورات اور ضرب الامثال',
          subtitle: '2,000 common idioms with detailed Urdu translations',
          icon: Icons.lightbulb_rounded,
          gradient: AppColors.idiomsGradient,
          badge: '${_viewModel.stats.idiomsCount} Idioms & Proverbs',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const IdiomsScreen()),
            );
          },
        ),
      );
      cards.add(const SizedBox(height: 12));
    }

    // 6. Singular / Plural
    if (filter == DashboardCategoryFilter.all ||
        filter == DashboardCategoryFilter.reference) {
      cards.add(
        CategoryCard(
          title: 'Singular & Plural Words',
          urduTitle: 'واحد اور جمع الفاظ',
          subtitle: '199 pairs of singular and plural nouns with pronunciation audio',
          icon: Icons.compare_arrows_rounded,
          gradient: AppColors.singularPluralGradient,
          badge: '${_viewModel.stats.singularPluralCount} Word Pairs',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SingularPluralScreen(),
              ),
            );
          },
        ),
      );
      cards.add(const SizedBox(height: 12));
    }

    // 7. AI Voice Call
    if (filter == DashboardCategoryFilter.all ||
        filter == DashboardCategoryFilter.practice) {
      cards.add(
        CategoryCard(
          title: 'Call AI Agent Tutor',
          urduTitle: 'اے آئی وائس کوچ سے کال',
          subtitle: 'Live voice call simulation to improve pronunciation and speaking confidence',
          icon: Icons.smart_toy_rounded,
          gradient: AppColors.aiCallGradient,
          badge: 'Live Audio • AI Powered',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AiAgentCallScreen()),
            );
          },
        ),
      );
      cards.add(const SizedBox(height: 12));
    }

    // 8. Practice Quizzes
    if (filter == DashboardCategoryFilter.all ||
        filter == DashboardCategoryFilter.practice) {
      cards.add(
        CategoryCard(
          title: 'Interactive English Quiz',
          urduTitle: 'انگریزی کوئز اور مشق',
          subtitle: 'Test your vocabulary, idioms, and singular/plural skills with score tracking',
          icon: Icons.quiz_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
          ),
          badge: 'Interactive Score • 3 Modes',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PracticeQuizScreen()),
            );
          },
        ),
      );
      cards.add(const SizedBox(height: 12));
    }

    // 9. Everyday Phrases
    if (filter == DashboardCategoryFilter.all ||
        filter == DashboardCategoryFilter.practice) {
      cards.add(
        CategoryCard(
          title: 'Everyday Essential Phrases',
          urduTitle: 'اہم ترین بول چال کے جملے',
          subtitle: 'Greetings, directions, shopping, dining and emergencies',
          icon: Icons.record_voice_over_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFFEA580C), Color(0xFFF97316)],
          ),
          badge: 'Everyday Expressions • Audio',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PhrasesScreen()),
            );
          },
        ),
      );
    }

    return cards;
  }
}
