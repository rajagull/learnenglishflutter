import 'package:flutter/material.dart';
import '../../../../data/models/conversation_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Conversations',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            Text(
              'روزمرہ انگریزی بول چال',
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
                  onChanged: _viewModel.search,
                  decoration: InputDecoration(
                    hintText: 'Search situations (Hospital, Airport, ہوائی اڈہ)...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.sky),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _viewModel.search('');
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
                              'No conversation topics found',
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
                                          ConversationDetailScreen(category: cat),
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
                                        gradient: AppColors.conversationGradient,
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      child: Icon(
                                        _getCategoryIcon(cat.id - 1),
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
