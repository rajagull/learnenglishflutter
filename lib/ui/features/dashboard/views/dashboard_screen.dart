import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _isGridView = false;

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bgLight,
        body: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            if (_viewModel.isLoading) {
              return const SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 16),
                      Text(
                        'Preparing your English learning studio...',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final stats = _viewModel.stats;
            final modules = _getFilteredModules(context);

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Edge-to-Edge Executive Royal Indigo Hero Header
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
                          color: Color(0x381E1B4B),
                          blurRadius: 24,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -35,
                          top: -25,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withAlpha(16),
                            ),
                          ),
                        ),
                        SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title + PRO Badge + Refresh
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  color: AppColors.amber
                                                      .withAlpha(38),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Icon(
                                                  Icons.school_rounded,
                                                  color: AppColors.amber,
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const Flexible(
                                                child: Text(
                                                  'Learn English',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 23,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white,
                                                    letterSpacing: -0.5,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 9,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.amber,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Text(
                                                  'PRO',
                                                  style: TextStyle(
                                                    color: Color(0xFF1E1B4B),
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          const Text(
                                            'انگریزی سیکھیں اور روانی سے بولیں • Complete Course',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFC7D2FE),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      style: IconButton.styleFrom(
                                        backgroundColor:
                                            Colors.white.withAlpha(28),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.refresh_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      tooltip: 'Refresh Daily Spotlight',
                                      onPressed: _viewModel.refreshDailyFeatured,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Instant Dictionary Search Bar
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const DictionaryScreen(),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
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
                                          size: 21,
                                        ),
                                        const SizedBox(width: 10),
                                        const Expanded(
                                          child: Text(
                                            'Search 140,000+ English & Urdu words...',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            'لغت',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // 4-Item Quick Launch Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildQuickDockItem(
                                        context,
                                        icon: Icons.phone_in_talk_rounded,
                                        label: 'AI Coach',
                                        urdu: 'اے آئی کال',
                                        color: AppColors.amber,
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const AiAgentCallScreen(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildQuickDockItem(
                                        context,
                                        icon: Icons.access_time_filled_rounded,
                                        label: '12 Tenses',
                                        urdu: 'زمانے',
                                        color: const Color(0xFF38BDF8),
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const TensesListScreen(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildQuickDockItem(
                                        context,
                                        icon: Icons.quiz_rounded,
                                        label: 'Play Quiz',
                                        urdu: 'کوئز گیم',
                                        color: const Color(0xFF34D399),
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const PracticeQuizScreen(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildQuickDockItem(
                                        context,
                                        icon: Icons.record_voice_over_rounded,
                                        label: 'Phrases',
                                        urdu: 'اہم جملے',
                                        color: const Color(0xFFFB7185),
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const PhrasesScreen(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Featured AI Voice Speaking Coach Banner
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF042F2E),
                            Color(0xFF0F766E),
                            Color(0xFF059669),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F766E).withAlpha(70),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(30),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.mic_rounded,
                                          size: 13,
                                          color: AppColors.amber,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '2-WAY VOICE CONVERSATION',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Speak Live with Emma (AI Coach)',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.5,
                                      fontWeight: FontWeight.w900,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'بول کر انگریزی کی مشق کریں اور فوری گرامر فیڈ بیک پائیں',
                                    style: TextStyle(
                                      color: Color(0xFFA7F3D0),
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.amber,
                                      foregroundColor: const Color(0xFF042F2E),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.phone_in_talk_rounded,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      'Start Voice Call',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 13,
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
                              width: 68,
                              height: 68,
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
                                size: 36,
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
                          label:
                              'Dialogues (${stats.conversationCategories} Topics)',
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
                if (_viewModel.dailyIdiom != null ||
                    _viewModel.dailyWord != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
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
                                    size: 19,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Daily Spotlight',
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
                                icon:
                                    const Icon(Icons.shuffle_rounded, size: 15),
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
                              padding: const EdgeInsets.all(15),
                              border: Border.all(
                                color: AppColors.primary.withAlpha(45),
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
                                          color:
                                              AppColors.primary.withAlpha(22),
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                      fontSize: 16.5,
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
                              padding: const EdgeInsets.all(15),
                              border: Border.all(
                                color: AppColors.amber.withAlpha(55),
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

                // Section Title + List / Grid Switcher + Category Filters
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
                              'Learning Modules',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textDark,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: AppColors.borderLight),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: Icon(
                                      Icons.view_agenda_rounded,
                                      size: 18,
                                      color: !_isGridView
                                          ? AppColors.primary
                                          : AppColors.textMuted,
                                    ),
                                    tooltip: 'Card List View',
                                    onPressed: () =>
                                        setState(() => _isGridView = false),
                                  ),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: Icon(
                                      Icons.grid_view_rounded,
                                      size: 18,
                                      color: _isGridView
                                          ? AppColors.primary
                                          : AppColors.textMuted,
                                    ),
                                    tooltip: 'Grid View',
                                    onPressed: () =>
                                        setState(() => _isGridView = true),
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

                // Modules List or Grid
                if (_isGridView)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.86,
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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(14),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            bottom: true,
            child: NavigationBar(
              height: 64,
              backgroundColor: Colors.white,
              elevation: 0,
              indicatorColor: AppColors.primary.withAlpha(28),
              selectedIndex: 0,
              onDestinationSelected: (index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DictionaryScreen(),
                    ),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AiAgentCallScreen(),
                    ),
                  );
                } else if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PracticeQuizScreen(),
                    ),
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
          ),
        ),
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withAlpha(32)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(42),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 19),
            ),
            const SizedBox(height: 5),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFC7D2FE),
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
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primaryColor.withAlpha(40), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withAlpha(18),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: item.onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: item.gradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(item.icon, color: Colors.white, size: 23),
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.urduGreen.withAlpha(16),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          item.urduTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.urduGreen,
                          ),
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
                    fontSize: 14.5,
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
      backgroundColor: Colors.white,
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
          title: 'Daily Conversations',
          urduTitle: 'روزمرہ بول چال',
          subtitle: 'Real-life situational dialogues with Urdu & audio',
          icon: Icons.chat_bubble_rounded,
          gradient: AppColors.conversationGradient,
          badge:
              '${_viewModel.stats.conversationCategories} Topics • ${_viewModel.stats.conversationDialogues} Dialogues',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ConversationCategoriesScreen(),
            ),
          ),
        ),
        _ModuleItem(
          title: 'English Tenses Mastery',
          urduTitle: 'انگریزی زمانے',
          subtitle: 'All 12 Tenses with positive, negative & question rules',
          icon: Icons.access_time_filled_rounded,
          gradient: AppColors.tensesGradient,
          badge: '12 Tenses • Complete Formulas',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TensesListScreen()),
          ),
        ),
        _ModuleItem(
          title: 'Vocabulary Builder',
          urduTitle: 'ذخیرہ الفاظ',
          subtitle: 'Topic-wise essential words with pronunciation',
          icon: Icons.format_list_bulleted_rounded,
          gradient: AppColors.vocabularyGradient,
          badge:
              '${_viewModel.stats.vocabularyCategories} Topics • ${_viewModel.stats.vocabularyItems} Words',
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
          title: 'English-Urdu Dictionary',
          urduTitle: 'جامع انگلش اردو لغت',
          subtitle: '140,000+ words, definitions, synonyms & Roman Urdu',
          icon: Icons.menu_book_rounded,
          gradient: AppColors.dictionaryGradient,
          badge: '140,000+ Words • 300K+ Meanings',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DictionaryScreen()),
          ),
        ),
        _ModuleItem(
          title: 'Idioms & Proverbs',
          urduTitle: 'محاورات اور ضرب الامثال',
          subtitle: '2,000 popular idioms with Urdu translations',
          icon: Icons.lightbulb_rounded,
          gradient: AppColors.idiomsGradient,
          badge: '${_viewModel.stats.idiomsCount} Idioms & Proverbs',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const IdiomsScreen()),
          ),
        ),
        _ModuleItem(
          title: 'Singular & Plural Words',
          urduTitle: 'واحد اور جمع',
          subtitle: '199 essential noun pairs with audio pronunciation',
          icon: Icons.compare_arrows_rounded,
          gradient: AppColors.singularPluralGradient,
          badge: '${_viewModel.stats.singularPluralCount} Word Pairs',
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
          title: 'AI Voice Speaking Coach',
          urduTitle: 'اے آئی وائس کوچ',
          subtitle: 'Live 2-way voice call & instant grammar feedback',
          icon: Icons.smart_toy_rounded,
          gradient: AppColors.aiCallGradient,
          badge: 'Live Audio • AI Powered',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AiAgentCallScreen()),
          ),
        ),
        _ModuleItem(
          title: 'Interactive English Quiz',
          urduTitle: 'انگریزی کوئز',
          subtitle: 'Test your vocabulary, idioms & singular/plural skills',
          icon: Icons.quiz_rounded,
          gradient: AppColors.quizGradient,
          badge: 'Interactive Score • 3 Modes',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PracticeQuizScreen()),
          ),
        ),
        _ModuleItem(
          title: 'Everyday Essential Phrases',
          urduTitle: 'اہم ترین جملے',
          subtitle: 'Greetings, travel, shopping, dining & emergencies',
          icon: Icons.record_voice_over_rounded,
          gradient: AppColors.phrasesGradient,
          badge: 'Everyday Expressions • Audio',
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
