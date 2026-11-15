import 'package:flutter/material.dart';
import '../../../../data/repositories/idiom_repository.dart';
import '../../../../data/repositories/singular_plural_repository.dart';
import '../../../../data/repositories/vocabulary_repository.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/premium_scaffold.dart';
import '../../../core/widgets/speak_button.dart';

enum QuizType { singularPlural, idioms, vocabulary }

class QuizQuestion {
  final String prompt;
  final String promptUrdu;
  final String correctAnswer;
  final List<String> options;

  QuizQuestion({
    required this.prompt,
    required this.promptUrdu,
    required this.correctAnswer,
    required this.options,
  });
}

class PracticeQuizScreen extends StatefulWidget {
  const PracticeQuizScreen({super.key});

  @override
  State<PracticeQuizScreen> createState() => _PracticeQuizScreenState();
}

class _PracticeQuizScreenState extends State<PracticeQuizScreen> {
  final SingularPluralRepository _spRepo = SingularPluralRepository();
  final IdiomRepository _idiomRepo = IdiomRepository();
  final VocabularyRepository _vocabRepo = VocabularyRepository();

  QuizType _selectedType = QuizType.singularPlural;
  bool _isLoading = true;
  QuizQuestion? _currentQuestion;
  String? _selectedOption;
  bool _hasAnswered = false;
  int _score = 0;
  int _totalAttempts = 0;

  @override
  void initState() {
    super.initState();
    _loadNextQuestion();
  }

  Future<void> _loadNextQuestion() async {
    setState(() {
      _isLoading = true;
      _selectedOption = null;
      _hasAnswered = false;
    });

    try {
      if (_selectedType == QuizType.singularPlural) {
        final pairs = await _spRepo.getRandomPairs(count: 4);
        if (pairs.length >= 4) {
          final target = pairs[0];
          final options = pairs.map((p) => p.plural.trim()).toList()..shuffle();
          _currentQuestion = QuizQuestion(
            prompt: 'What is the plural of "${target.singular.trim()}"?',
            promptUrdu: 'اس لفظ کی جمع کیا ہوگی؟',
            correctAnswer: target.plural.trim(),
            options: options,
          );
        }
      } else if (_selectedType == QuizType.idioms) {
        final idioms = await _idiomRepo.getRandomIdioms(count: 4);
        if (idioms.length >= 4) {
          final target = idioms[0];
          final options = idioms.map((i) => i.urdu.trim()).toList()..shuffle();
          _currentQuestion = QuizQuestion(
            prompt: target.displayEnglish,
            promptUrdu: 'اس محاورے کا اردو مفہوم بتائیے:',
            correctAnswer: target.urdu.trim(),
            options: options,
          );
        }
      } else {
        final items = await _vocabRepo.getRandomItems(count: 4);
        if (items.length >= 4) {
          final target = items[0];
          final options = items.map((v) => v.urdu.trim()).toList()..shuffle();
          _currentQuestion = QuizQuestion(
            prompt: 'What is the meaning of "${target.english.trim()}"?',
            promptUrdu: 'اس لفظ کا اردو مطلب کیا ہے؟',
            correctAnswer: target.urdu.trim(),
            options: options,
          );
        }
      }
    } catch (e) {
      debugPrint('[PracticeQuizScreen] Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleOptionSelect(String option) {
    if (_hasAnswered) return;
    setState(() {
      _selectedOption = option;
      _hasAnswered = true;
      _totalAttempts++;
      if (option == _currentQuestion?.correctAnswer) {
        _score++;
      }
    });

    if (_currentQuestion != null) {
      TtsService.instance.speak(_currentQuestion!.correctAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: 'Interactive English Quiz',
      urduTitle: 'خود کار مشق اور کوئز',
      badgeText: 'Score: $_score/$_totalAttempts',
      gradient: AppColors.quizGradient,
      actions: [
        IconButton(
          tooltip: 'Reset Score',
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withAlpha(30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
          onPressed: () {
            setState(() {
              _score = 0;
              _totalAttempts = 0;
            });
            _loadNextQuestion();
          },
        ),
      ],
      headerBottom: Row(
        children: [
          _buildModeChip('Singular/Plural', QuizType.singularPlural),
          const SizedBox(width: 8),
          _buildModeChip('Idioms', QuizType.idioms),
          const SizedBox(width: 8),
          _buildModeChip('Vocabulary', QuizType.vocabulary),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentQuestion == null
              ? const Center(child: Text('Unable to load question'))
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Question Card
                      GlassCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              _currentQuestion!.promptUrdu,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.urduGreen,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currentQuestion!.prompt,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SpeakButton(
                              text: _currentQuestion!.prompt,
                              color: AppColors.primary,
                              backgroundColor: AppColors.primary.withAlpha(22),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Option choices
                      Expanded(
                        child: ListView.separated(
                          itemCount: _currentQuestion!.options.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final option = _currentQuestion!.options[index];
                            final isSelected = _selectedOption == option;
                            final isCorrect =
                                option == _currentQuestion!.correctAnswer;

                            Color borderColor = AppColors.borderLight;
                            Color bgColor = Colors.white;
                            Color textColor = AppColors.textDark;

                            if (_hasAnswered) {
                              if (isCorrect) {
                                borderColor = AppColors.emerald;
                                bgColor = AppColors.emerald.withAlpha(25);
                                textColor = AppColors.emerald;
                              } else if (isSelected) {
                                borderColor = Colors.redAccent;
                                bgColor = Colors.redAccent.withAlpha(25);
                                textColor = Colors.redAccent;
                              }
                            }

                            return GlassCard(
                              onTap: () => _handleOptionSelect(option),
                              backgroundColor: bgColor,
                              border:
                                  Border.all(color: borderColor, width: 1.5),
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: borderColor.withAlpha(25),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(65 + index),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                  if (_hasAnswered && isCorrect)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.emerald,
                                    )
                                  else if (_hasAnswered && isSelected)
                                    const Icon(
                                      Icons.cancel_rounded,
                                      color: Colors.redAccent,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Next button protected inside SafeArea via PremiumScaffold
                      if (_hasAnswered) ...[
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text(
                            'Next Question',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          onPressed: _loadNextQuestion,
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildModeChip(String label, QuizType type) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          if (_selectedType != type) {
            setState(() => _selectedType = type);
            _loadNextQuestion();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withAlpha(28),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.white.withAlpha(55),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppColors.primaryDark : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
