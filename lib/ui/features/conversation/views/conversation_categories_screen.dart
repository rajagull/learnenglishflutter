import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/premium_scaffold.dart';
import '../view_models/conversation_view_model.dart';
import 'conversation_detail_screen.dart';

class ConversationCategoriesScreen extends StatefulWidget {
  const ConversationCategoriesScreen({super.key});

  @override
  State<ConversationCategoriesScreen> createState() =>
      _ConversationCategoriesScreenState();
}

class _ConversationCategoriesScreenState
    extends State<ConversationCategoriesScreen> {
  final ConversationViewModel _viewModel = ConversationViewModel();
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

  IconData _getCategoryIcon(int index) {
    final icons = [
      Icons.hotel_rounded,
      Icons.local_hospital_rounded,
      Icons.store_rounded,
      Icons.phone_in_talk_rounded,
      Icons.shopping_bag_rounded,
      Icons.home_work_rounded,
      Icons.account_balance_rounded,
      Icons.person_pin_rounded,
      Icons.flight_takeoff_rounded,
      Icons.navigation_rounded,
      Icons.restaurant_rounded,
      Icons.school_rounded,
      Icons.directions_car_rounded,
      Icons.work_rounded,
      Icons.local_pharmacy_rounded,
      Icons.sports_esports_rounded,
      Icons.wb_sunny_rounded,
      Icons.camera_alt_rounded,
      Icons.celebration_rounded,
      Icons.fitness_center_rounded,
      Icons.coffee_rounded,
      Icons.business_center_rounded,
    ];
    return icons[index % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return PremiumScaffold(
          title: 'Daily Conversations',
          urduTitle: 'روزمرہ انگریزی بول چال کے موضوعات',
          badgeText: '${_viewModel.filteredCategories.length} Topics',
          gradient: AppColors.conversationGradient,
          headerBottom: PremiumSearchField(
            controller: _searchController,
            onChanged: _viewModel.search,
            onClear: () {
              _searchController.clear();
              _viewModel.search('');
            },
            hintText: 'Search situations (Hospital, Airport, ہوائی اڈہ)...',
            accentColor: AppColors.sky,
          ),
          body: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _viewModel.filteredCategories.isEmpty
                  ? const Center(
                      child: Text(
                        'No conversation topics found',
                        style: TextStyle(color: AppColors.textLight),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      itemCount: _viewModel.filteredCategories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final cat = _viewModel.filteredCategories[index];
                        return GlassCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ConversationDetailScreen(category: cat),
                              ),
                            );
                          },
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: AppColors.conversationGradient,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.sky.withAlpha(65),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _getCategoryIcon(cat.id - 1),
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.sky.withAlpha(22),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            'Topic #${cat.id}',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.sky,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      cat.englishName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
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
                                  color: AppColors.sky.withAlpha(20),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                  color: AppColors.sky,
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
