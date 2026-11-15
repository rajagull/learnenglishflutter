import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class AiAgentCallScreen extends StatefulWidget {
  const AiAgentCallScreen({super.key});

  @override
  State<AiAgentCallScreen> createState() => _AiAgentCallScreenState();
}

class _AiAgentCallScreenState extends State<AiAgentCallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _timer;
  int _callSeconds = 0;
  bool _isMuted = false;
  bool _isSpeakerOn = true;
  String _selectedTopic = 'Casual Daily Conversation';

  final List<String> _topics = [
    'Casual Daily Conversation',
    'Job Interview Practice',
    'Airport & Travel Check-in',
    'Restaurant & Ordering Food',
    'Pronunciation & Fluency Drill',
  ];

  final List<Map<String, String>> _sampleDialogue = [
    {
      'role': 'ai',
      'text': 'Hello! I am your AI English Speaking Coach. What would you like to practice today?',
      'urdu': 'ہیلو! میں آپ کا اے آئی انگلش کوچ ہوں۔ آج آپ کس موضوع پر بول چال کرنا چاہتے ہیں؟'
    },
    {
      'role': 'user',
      'text': 'I want to practice speaking fluent English with correct pronunciation.',
      'urdu': 'میں صحیح تلفظ کے ساتھ روانی سے انگریزی بولنے کی مشق کرنا چاہتا ہوں۔'
    },
    {
      'role': 'ai',
      'text': 'Wonderful! Let\'s begin. Tell me about your day in full English sentences!',
      'urdu': 'شاندار! آئیے شروع کرتے ہیں۔ مجھے اپنے دن کے بارے میں انگریزی میں بتائیے!'
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _callSeconds++);
      }
    });

    // Auto speak initial greeting
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        TtsService.instance.speak(
          'Hello! I am your AI English Speaking Coach. Let us practice English together!',
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    TtsService.instance.stop();
    super.dispose();
  }

  String _formatCallTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark elegant call backdrop
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: const Text(
          'AI English Speaking Tutor',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.emerald.withAlpha(50),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.emerald),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.emerald,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Live Audio',
                  style: TextStyle(
                    color: AppColors.emerald,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Topic selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _topics.map((t) {
                final isSelected = t == _selectedTopic;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(
                      t,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    selectedColor: AppColors.secondary,
                    backgroundColor: const Color(0xFF1E293B),
                    onSelected: (val) {
                      setState(() => _selectedTopic = t);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Spacer(),

          // Pulsing Avatar
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.aiCallGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withAlpha(120),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.smart_toy_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Emma (AI English Voice Coach)',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formatCallTime(_callSeconds),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Listening to your English speech... Speak naturally!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.sky,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),

          // Interactive Sample Prompt Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Speaking Suggestions:',
                  style: TextStyle(color: Colors.white60, fontSize: 13),
                ),
                const SizedBox(height: 8),
                ..._sampleDialogue.take(2).map((msg) {
                  final isAi = msg['role'] == 'ai';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isAi
                          ? const Color(0xFF1E293B)
                          : AppColors.primary.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isAi ? Colors.white10 : AppColors.primaryLight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isAi ? Icons.record_voice_over : Icons.person,
                          color: isAi ? AppColors.secondary : Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg['text']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                msg['urdu']!,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                  color: AppColors.emerald,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up, color: Colors.white70, size: 18),
                          onPressed: () => TtsService.instance.speak(msg['text']!),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Call Controls Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 30),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Mute Mic
                IconButton.filledTonal(
                  style: IconButton.styleFrom(
                    backgroundColor: _isMuted ? Colors.red.withAlpha(60) : Colors.white12,
                    padding: const EdgeInsets.all(16),
                  ),
                  icon: Icon(
                    _isMuted ? Icons.mic_off : Icons.mic,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() => _isMuted = !_isMuted);
                  },
                ),
                // End Call
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.all(18),
                  ),
                  icon: const Icon(Icons.call_end, color: Colors.white, size: 32),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                // Speaker
                IconButton.filledTonal(
                  style: IconButton.styleFrom(
                    backgroundColor: _isSpeakerOn ? AppColors.secondary.withAlpha(60) : Colors.white12,
                    padding: const EdgeInsets.all(16),
                  ),
                  icon: Icon(
                    _isSpeakerOn ? Icons.volume_up : Icons.volume_mute,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() => _isSpeakerOn = !_isSpeakerOn);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
