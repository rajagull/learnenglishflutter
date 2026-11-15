import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../data/models/conversation_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/speak_button.dart';
import '../view_models/conversation_view_model.dart';

class ConversationDetailScreen extends StatefulWidget {
  final ConversationCategory category;

  const ConversationDetailScreen({super.key, required this.category});

  @override
  State<ConversationDetailScreen> createState() =>
      _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  final ConversationViewModel _viewModel = ConversationViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadDetails(widget.category.id);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _shareDialogue(ConversationDetail item) {
    SharePlus.share(
      '${item.english}\n${item.urdu}\n(${item.roman})\n\nLearn English with Learn English App!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category.englishName,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
            ),
            Text(
              widget.category.urduName,
              style: const TextStyle(
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

          if (_viewModel.currentDetails.isEmpty) {
            return const Center(
              child: Text(
                'No dialogues found for this topic',
                style: TextStyle(color: AppColors.textLight),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: _viewModel.currentDetails.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = _viewModel.currentDetails[index];
              final hasSpeaker = item.speaker.isNotEmpty;
              final isAlternate = index.isOdd;

              return GlassCard(
                border: Border.all(
                  color: isAlternate
                      ? AppColors.sky.withAlpha(50)
                      : AppColors.primary.withAlpha(50),
                  width: 1.2,
                ),
                backgroundColor: isAlternate
                    ? const Color(0xFFF0F9FF)
                    : Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (hasSpeaker) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isAlternate
                                  ? AppColors.sky.withAlpha(30)
                                  : AppColors.primary.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.speaker,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: isAlternate
                                  ? AppColors.sky
                                  : AppColors.primary,
                              ),
                            ),
                          ),
                          const Spacer(),
                        ] else
                          const Spacer(),
                        SpeakButton(
                          text: item.dialogueText,
                          size: 18,
                          color: isAlternate ? AppColors.sky : AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => _shareDialogue(item),
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.share_outlined,
                                size: 18,
                                color: AppColors.textLight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.dialogueText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1, color: AppColors.borderLight),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        item.urdu,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.urduGreen,
                          height: 1.5,
                        ),
                      ),
                    ),
                    if (item.roman.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        item.roman,
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
