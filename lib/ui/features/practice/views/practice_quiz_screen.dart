import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../data/repositories/idiom_repository.dart';
import '../../../../data/repositories/singular_plural_repository.dart';
import '../../../../data/repositories/vocabulary_repository.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interactive English Quiz',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            Text(
              'خود کار مشق اور کوئز',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: AppColors.urduGreen,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Mode switch tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildModeChip('Singular/Plural', QuizType.singularPlural),
                const SizedBox(width: 8),
                _buildModeChip('Idioms', QuizType.idioms),
                const SizedBox(width: 8),
                _buildModeChip('Vocabulary', QuizType.vocabulary),
              ],
            ),
          ),

          // Score bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.stars_rounded, color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Score: $_score / $_totalAttempts',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white24,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Reset', style: TextStyle(fontSize: 12)),
                  onPressed: () {
                    setState(() {
                      _score = 0;
                      _totalAttempts = 0;
                    });
                    _loadNextQuestion();
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _currentQuestion == null
                    ? const Center(child: Text('Unable to load question'))
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.urduGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _currentQuestion!.prompt,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SpeakButton(
                                    text: _currentQuestion!.prompt,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Option choices
                            Expanded(
                              child: ListView.separated(
                                itemCount: _currentQuestion!.options.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final option = _currentQuestion!.options[index];
                                  final isSelected = _selectedOption == option;
                                  final isCorrect = option == _currentQuestion!.correctAnswer;

                                  Color borderColor = AppColors.borderLight;
                                  Color bgColor = Colors.white;
                                  Color textColor = AppColors.textDark;

                                  if (_hasAnswered) {
                                    if (isCorrect) {
                                      borderColor = AppColors.emerald;
                                      bgColor = AppColors.emerald.withAlpha(30);
                                      textColor = AppColors.emerald;
                                    } else if (isSelected) {
                                      borderColor = Colors.redAccent;
                                      bgColor = Colors.redAccent.withAlpha(30);
                                      textColor = Colors.redAccent;
                                    }
                                  }

                                  return GlassCard(
                                    onTap: () => _handleOptionSelect(option),
                                    backgroundColor: bgColor,
                                    border: Border.all(color: borderColor, width: 1.5),
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: borderColor.withAlpha(20),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              String.fromCharCode(65 + index),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
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
                                          const Icon(Icons.check_circle, color: AppColors.emerald)
                                        else if (_hasAnswered && isSelected)
                                          const Icon(Icons.cancel, color: Colors.redAccent),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Next button
                            if (_hasAnswered)
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: AppColors.primary,
                                ),
                                icon: const Icon(Icons.arrow_forward_rounded),
                                label: const Text(
                                  'Next Question',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                ),
                                onPressed: _loadNextQuestion,
                              ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeChip(String label, QuizType type) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (_selectedType != type) {
            setState(() => _selectedType = type);
            _loadNextQuestion();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.textMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
