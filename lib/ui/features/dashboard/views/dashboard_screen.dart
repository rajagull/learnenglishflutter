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
  bool _isGridView = true;

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
      backgroundColor: AppColors.bgLight,
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16),
                  Text(
                    'Loading databases and learning modules...',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            );
          }

          final stats = _viewModel.stats;
          final modules = _getFilteredModules(context);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Curved Royal Emerald Hero Header + Search Bar + Quick Launch Dock
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.heroGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33042F2E),
                        blurRadius: 24,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Title Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.auto_stories_rounded,
                                        color: AppColors.amber,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Learn English',
                                        style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 9,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.amber,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          'ELITE UI',
                                          style: TextStyle(
                                            color: Color(0xFF042F2E),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'انگریزی سیکھیں اور روانی سے بولیں • Urdu & Hindi Guide',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFA7F3D0),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white.withAlpha(30),
                                ),
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                ),
                                tooltip: 'Refresh Daily Spotlight',
                                onPressed: _viewModel.refreshDailyFeatured,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Quick Dictionary Search Bar inside Hero Header
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DictionaryScreen(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 13,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(25),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search_rounded,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Text(
                                      'Search 140,000+ English & Urdu words...',
                                      style: TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceElevated,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'لغت',
                                      style: TextStyle(
                                        color: AppColors.urduGreen,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // 4-Item Quick Action Dock
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildQuickDockItem(
                                context,
                                icon: Icons.phone_in_talk_rounded,
                                label: 'AI Speaking',
                                urdu: 'اے آئی کال',
                                color: AppColors.amber,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AiAgentCallScreen(),
                                  ),
                                ),
                              ),
                              _buildQuickDockItem(
                                context,
                                icon: Icons.access_time_filled_rounded,
                                label: '12 Tenses',
                                urdu: 'زمانے',
                                color: const Color(0xFF38BDF8),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TensesListScreen(),
                                  ),
                                ),
                              ),
                              _buildQuickDockItem(
                                context,
                                icon: Icons.quiz_rounded,
                                label: 'Play Quiz',
                                urdu: 'کوئز گیم',
                                color: const Color(0xFF34D399),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PracticeQuizScreen(),
                                  ),
                                ),
                              ),
                              _buildQuickDockItem(
                                context,
                                icon: Icons.record_voice_over_rounded,
                                label: 'Phrases',
                                urdu: 'اہم جملے',
                                color: const Color(0xFFFB7185),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PhrasesScreen(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // AI Voice Agent Banner Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1E1B4B),
                          Color(0xFF312E81),
                          Color(0xFF4338CA),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF312E81).withAlpha(75),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.amber.withAlpha(40),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.graphic_eq_rounded,
                                        size: 14,
                                        color: AppColors.amber,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'LIVE AI ENGLISH COACH',
                                        style: TextStyle(
                                          color: AppColors.amber,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Practice Speaking with AI Voice Tutor',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'اے آئی سے براہ راست انگریزی بول چال کی مشق کریں',
                                  style: TextStyle(
                                    color: Color(0xFFC7D2FE),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.amber,
                                    foregroundColor: const Color(0xFF1E1B4B),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.call_rounded,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    'Start Voice Call',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const AiAgentCallScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 74,
                            height: 74,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(22),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.amber.withAlpha(110),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.support_agent_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Live Database Stats Strip
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
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
                        color: AppColors.purple,
                      ),
                      const SizedBox(width: 10),
                      StatsBadge(
                        icon: Icons.format_list_bulleted_rounded,
                        label: 'Vocab (${stats.vocabularyCategories} Topics)',
                        count: '${stats.vocabularyItems}',
                        color: AppColors.emerald,
                      ),
                    ],
                  ),
                ),
              ),

              // Daily Spotlight: Word of the Day + Idiom of the Day
              if (_viewModel.dailyIdiom != null || _viewModel.dailyWord != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome_rounded,
                                  color: AppColors.amber,
                                  size: 20,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Daily Learning Spotlight',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: _viewModel.refreshDailyFeatured,
                              icon: const Icon(Icons.shuffle_rounded, size: 16),
                              label: const Text(
                                'New Pick',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_viewModel.dailyWord != null) ...[
                          GlassCard(
                            padding: const EdgeInsets.all(16),
                            border: Border.all(
                              color: AppColors.primary.withAlpha(60),
                              width: 1.3,
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
                                        color: AppColors.primary.withAlpha(24),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Word of the Day • آج کا لفظ',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    SpeakButton(
                                      text: _viewModel.dailyWord!.word,
                                      color: AppColors.primary,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _viewModel.dailyWord!.word.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                if (_viewModel
                                    .dailyWord!.meanings.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _viewModel.dailyWord!.meanings.first.mean,
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.urduGreen,
                                    ),
                                  ),
                                ] else if (_viewModel
                                    .dailyWord!.definition.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _viewModel.dailyWord!.definition,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textMedium,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (_viewModel.dailyIdiom != null)
                          GlassCard(
                            padding: const EdgeInsets.all(16),
                            border: Border.all(
                              color: AppColors.amber.withAlpha(65),
                              width: 1.3,
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
                                        color: AppColors.amber.withAlpha(28),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Idiom of the Day • آج کا محاورہ',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFFB45309),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    SpeakButton(
                                      text: _viewModel
                                          .dailyIdiom!.displayEnglish,
                                      color: AppColors.amber,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _viewModel.dailyIdiom!.displayEnglish,
                                  style: const TextStyle(
                                    fontSize: 15.5,
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
                                    fontWeight: FontWeight.w700,
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

              // Section Title + Bento Grid / List Toggle + Filter Chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'All Learning Modules',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textDark,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: Icon(
                                    Icons.grid_view_rounded,
                                    size: 19,
                                    color: _isGridView
                                        ? AppColors.primary
                                        : AppColors.textMuted,
                                  ),
                                  tooltip: 'Grid View',
                                  onPressed: () =>
                                      setState(() => _isGridView = true),
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: Icon(
                                    Icons.view_agenda_rounded,
                                    size: 19,
                                    color: !_isGridView
                                        ? AppColors.primary
                                        : AppColors.textMuted,
                                  ),
                                  tooltip: 'List View',
                                  onPressed: () =>
                                      setState(() => _isGridView = false),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(
                              label: 'All Modules (9)',
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

              // Modules Bento Grid or List
              if (_isGridView)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.92,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildBentoTile(modules[index]),
                      childCount: modules.length,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = modules[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CategoryCard(
                            title: item.title,
                            urduTitle: item.urduTitle,
                            subtitle: item.subtitle,
                            icon: item.icon,
                            gradient: item.gradient,
                            badge: item.badge,
                            onTap: item.onTap,
                          ),
                        );
                      },
                      childCount: modules.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        elevation: 10,
        indicatorColor: AppColors.primary.withAlpha(35),
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DictionaryScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AiAgentCallScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PracticeQuizScreen()),
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Dictionary',
          ),
          NavigationDestination(
            icon: Icon(Icons.phone_in_talk_rounded),
            label: 'AI Coach',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_rounded),
            label: 'Quiz',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDockItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String urdu,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withAlpha(35)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(45),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              urdu,
              style: const TextStyle(
                color: Color(0xFFA7F3D0),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoTile(_ModuleItem item) {
    final primaryColor = item.gradient.colors.first;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryColor.withAlpha(45), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withAlpha(22),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: item.onTap,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: item.gradient,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withAlpha(70),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(item.icon, color: Colors.white, size: 25),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.urduGreen.withAlpha(18),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.urduTitle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.urduGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textLight,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    item.badge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
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

  List<_ModuleItem> _getFilteredModules(BuildContext context) {
    final filter = _viewModel.selectedFilter;
    final List<_ModuleItem> items = [];

    if (filter == DashboardCategoryFilter.all ||
        filter == DashboardCategoryFilter.grammar) {
      items.addAll([
        _ModuleItem(
          title: 'Conversations',
          urduTitle: 'روزمرہ بول چال',
          subtitle: 'Real-life dialogues with Urdu & audio',
          icon: Icons.chat_bubble_rounded,
          gradient: AppColors.conversationGradient,
          badge: '${_viewModel.stats.conversationDialogues} Dialogues',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ConversationCategoriesScreen(),
            ),
          ),
        ),
        _ModuleItem(
          title: 'English Tenses',
          urduTitle: 'انگریزی زمانے',
          subtitle: '12 Tenses with formulas & examples',
          icon: Icons.access_time_filled_rounded,
          gradient: AppColors.tensesGradient,
          badge: '12 Tenses • Formulas',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TensesListScreen()),
          ),
        ),
        _ModuleItem(
          title: 'Vocabulary',
          urduTitle: 'ذخیرہ الفاظ',
          subtitle: 'Topic-wise words with pronunciation',
          icon: Icons.format_list_bulleted_rounded,
          gradient: AppColors.vocabularyGradient,
          badge: '${_viewModel.stats.vocabularyItems} Words',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const VocabularyCategoriesScreen(),
            ),
          ),
        ),
      ]);
    }

    if (filter == DashboardCategoryFilter.all ||
        filter == DashboardCategoryFilter.reference) {
      items.addAll([
        _ModuleItem(
          title: 'Urdu Dictionary',
          urduTitle: 'انگلش اردو لغت',
          subtitle: '140,000+ words, synonyms & Roman Urdu',
          icon: Icons.menu_book_rounded,
          gradient: AppColors.dictionaryGradient,
          badge: '140,000+ Words',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DictionaryScreen()),
          ),
        ),
        _ModuleItem(
          title: 'Idioms & Proverbs',
          urduTitle: 'محاورات',
          subtitle: 'Popular idioms with Urdu meanings',
          icon: Icons.lightbulb_rounded,
          gradient: AppColors.idiomsGradient,
          badge: '${_viewModel.stats.idiomsCount} Idioms',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const IdiomsScreen()),
          ),
        ),
        _ModuleItem(
          title: 'Singular & Plural',
          urduTitle: 'واحد اور جمع',
          subtitle: 'Essential noun pairs with audio',
          icon: Icons.compare_arrows_rounded,
          gradient: AppColors.singularPluralGradient,
          badge: '${_viewModel.stats.singularPluralCount} Pairs',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SingularPluralScreen()),
          ),
        ),
      ]);
    }

    if (filter == DashboardCategoryFilter.all ||
        filter == DashboardCategoryFilter.practice) {
      items.addAll([
        _ModuleItem(
          title: 'AI Voice Coach',
          urduTitle: 'اے آئی کوچ',
          subtitle: 'Live speaking practice & feedback',
          icon: Icons.smart_toy_rounded,
          gradient: AppColors.aiCallGradient,
          badge: 'Live Audio • AI',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AiAgentCallScreen()),
          ),
        ),
        _ModuleItem(
          title: 'Practice Quiz',
          urduTitle: 'انگریزی کوئز',
          subtitle: 'Test vocabulary, idioms & grammar',
          icon: Icons.quiz_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
          ),
          badge: '3 Quiz Modes',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PracticeQuizScreen()),
          ),
        ),
        _ModuleItem(
          title: 'Daily Phrases',
          urduTitle: 'اہم جملے',
          subtitle: 'Greetings, travel, shopping & dining',
          icon: Icons.record_voice_over_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFFEA580C), Color(0xFFF97316)],
          ),
          badge: 'Essential Audio',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PhrasesScreen()),
          ),
        ),
      ]);
    }

    return items;
  }
}

class _ModuleItem {
  final String title;
  final String urduTitle;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final String badge;
  final VoidCallback onTap;

  const _ModuleItem({
    required this.title,
    required this.urduTitle,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.badge,
    required this.onTap,
  });
}
