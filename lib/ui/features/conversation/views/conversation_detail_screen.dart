import 'package:flutter/material.dart';
import '../../../../data/models/conversation_model.dart';
import '../../../core/services/share_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/premium_scaffold.dart';
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
    ShareHelper.shareText(
      '${item.english}\n${item.urdu}\n(${item.roman})\n\nLearn English with Learn English App!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return PremiumScaffold(
          title: widget.category.englishName,
          urduTitle: widget.category.urduName,
          badgeText: '${_viewModel.currentDetails.length} Lines',
          gradient: AppColors.conversationGradient,
          body: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _viewModel.currentDetails.isEmpty
                  ? const Center(
                      child: Text(
                        'No dialogues found for this topic',
                        style: TextStyle(color: AppColors.textLight),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      itemCount: _viewModel.currentDetails.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _viewModel.currentDetails[index];
                        final hasSpeaker = item.speaker.isNotEmpty;
                        final isAlternate = index.isOdd;
                        final accent =
                            isAlternate ? AppColors.sky : AppColors.primary;

                        return GlassCard(
                          border: Border.all(
                            color: accent.withAlpha(55),
                            width: 1.3,
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
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accent.withAlpha(24),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isAlternate
                                              ? Icons.person_outline_rounded
                                              : Icons.record_voice_over_rounded,
                                          size: 13,
                                          color: accent,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          hasSpeaker
                                              ? item.speaker
                                              : 'Speaker ${index + 1}',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w800,
                                            color: accent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  SpeakButton(
                                    text: item.dialogueText,
                                    size: 18,
                                    color: accent,
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
                              const SizedBox(height: 10),
                              Text(
                                item.dialogueText,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Divider(
                                height: 1,
                                color: AppColors.borderLight,
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  item.urdu,
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
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
                                    fontSize: 12.5,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ],
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
