import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/services/speech_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../services/ai_tutor_service.dart';

enum CallVoiceState {
  aiSpeaking,
  userListening,
  aiThinking,
  idle,
}

class AiAgentCallScreen extends StatefulWidget {
  const AiAgentCallScreen({super.key});

  @override
  State<AiAgentCallScreen> createState() => _AiAgentCallScreenState();
}

class _AiAgentCallScreenState extends State<AiAgentCallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  Timer? _callTimer;
  int _callSeconds = 0;

  bool _isSpeakerOn = true;
  bool _autoListenAfterAi = true;
  bool _slowSpeechMode = false;
  bool _hasMicPermission = false;

  CallVoiceState _voiceState = CallVoiceState.idle;
  String _selectedTopic = 'Casual Daily Conversation';
  String _livePartialSpeech = '';
  String _statusBanner = 'Connecting to Emma (AI Coach)...';
  double _currentRms = 0.0;

  final List<String> _topics = const [
    'Casual Daily Conversation',
    'Job Interview Practice',
    'Airport & Travel Check-in',
    'Restaurant & Ordering Food',
    'Pronunciation & Fluency Drill',
  ];

  final List<AiTurnMessage> _messages = [];
  List<QuickReplySuggestion> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _callSeconds++);
      }
    });

    _setupSpeechCallbacks();
    _initializeCallSession();
  }

  void _setupSpeechCallbacks() {
    final speech = SpeechService.instance;

    speech.onStatusChanged = (status) {
      if (!mounted) return;
      if (status == 'listening' || status == 'speaking') {
        setState(() {
          _voiceState = CallVoiceState.userListening;
          _statusBanner = status == 'speaking'
              ? 'Hearing your voice... Keep speaking!'
              : 'Microphone active — Speak in English now...';
        });
      } else if (status == 'processing') {
        setState(() {
          _statusBanner = 'Processing your speech...';
        });
      } else if (status == 'idle' && _voiceState == CallVoiceState.userListening) {
        setState(() {
          _voiceState = CallVoiceState.idle;
          _statusBanner = 'Tap the green Mic button to speak';
        });
      }
    };

    speech.onRmsChanged = (rms) {
      if (!mounted) return;
      setState(() {
        _currentRms = rms.clamp(0.0, 12.0);
      });
    };

    speech.onResult = (text, isFinal) {
      if (!mounted) return;
      if (!isFinal) {
        setState(() {
          _livePartialSpeech = text;
        });
      } else {
        final finalSpoken = text.trim().isNotEmpty
            ? text.trim()
            : _livePartialSpeech.trim();
        setState(() {
          _livePartialSpeech = '';
          _currentRms = 0.0;
        });
        if (finalSpoken.isNotEmpty) {
          _handleUserSpokenText(finalSpoken);
        } else {
          setState(() {
            _voiceState = CallVoiceState.idle;
            _statusBanner = 'Didn\'t catch that. Tap Mic to speak again.';
          });
        }
      }
    };

    speech.onError = (code, message) {
      if (!mounted) return;
      // If partial speech was already captured before silence timeout, submit it!
      if (_livePartialSpeech.trim().isNotEmpty) {
        final captured = _livePartialSpeech.trim();
        setState(() {
          _livePartialSpeech = '';
          _currentRms = 0.0;
        });
        _handleUserSpokenText(captured);
        return;
      }
      setState(() {
        _voiceState = CallVoiceState.idle;
        _currentRms = 0.0;
        _statusBanner = message;
      });
    };
  }

  Future<void> _initializeCallSession() async {
    AiTutorService.instance.resetSession();
    _hasMicPermission = await SpeechService.instance.checkOrRequestPermission();

    final greeting = AiTutorService.instance.getInitialGreeting(_selectedTopic);
    if (!mounted) return;

    setState(() {
      _messages.clear();
      _messages.add(
        AiTurnMessage(
          role: 'ai',
          text: greeting.replyEnglish,
          urdu: greeting.replyUrdu,
        ),
      );
      _suggestions = greeting.suggestions;
    });

    await _speakAiResponse(greeting.replyEnglish);
  }

  Future<void> _switchTopic(String newTopic) async {
    if (_selectedTopic == newTopic) return;
    await SpeechService.instance.cancelListening();
    await TtsService.instance.stop();

    setState(() {
      _selectedTopic = newTopic;
      _livePartialSpeech = '';
    });

    await _initializeCallSession();
  }

  Future<void> _speakAiResponse(String text) async {
    if (!mounted) return;
    await SpeechService.instance.cancelListening();

    if (!_isSpeakerOn) {
      if (_autoListenAfterAi && _hasMicPermission) {
        await _startListeningToUser();
      } else {
        setState(() {
          _voiceState = CallVoiceState.idle;
          _statusBanner = 'Tap the Mic button below to reply';
        });
      }
      return;
    }

    setState(() {
      _voiceState = CallVoiceState.aiSpeaking;
      _statusBanner = 'Emma is speaking...';
    });

    await TtsService.instance.speak(text);

    if (!mounted) return;
    if (_autoListenAfterAi && _hasMicPermission) {
      await Future.delayed(const Duration(milliseconds: 450));
      if (mounted && _voiceState != CallVoiceState.aiThinking) {
        await _startListeningToUser();
      }
    } else {
      setState(() {
        _voiceState = CallVoiceState.idle;
        _statusBanner = 'Your turn! Tap the Mic button and speak in English.';
      });
    }
  }

  Future<void> _startListeningToUser({bool usePopup = false}) async {
    if (!mounted) return;
    // Stop TTS first so mic never records AI voice
    await TtsService.instance.stop();

    if (!_hasMicPermission) {
      _hasMicPermission =
          await SpeechService.instance.checkOrRequestPermission();
      if (!_hasMicPermission) {
        if (!mounted) return;
        setState(() {
          _voiceState = CallVoiceState.idle;
          _statusBanner =
              'Microphone permission denied. Please allow Mic access or type below.';
        });
        return;
      }
    }

    setState(() {
      _livePartialSpeech = '';
      _voiceState = CallVoiceState.userListening;
      _statusBanner = 'Listening... Speak in English now!';
    });

    await SpeechService.instance.startListening(
      locale: 'en-US',
      usePopup: usePopup,
    );
  }

  Future<void> _stopListeningManually() async {
    if (_livePartialSpeech.trim().isNotEmpty) {
      final captured = _livePartialSpeech.trim();
      await SpeechService.instance.cancelListening();
      setState(() {
        _livePartialSpeech = '';
        _currentRms = 0.0;
      });
      await _handleUserSpokenText(captured);
    } else {
      await SpeechService.instance.stopListening();
      setState(() {
        _voiceState = CallVoiceState.idle;
        _statusBanner = 'Tap the Mic button when you are ready to speak.';
      });
    }
  }

  Future<void> _handleUserSpokenText(String userText) async {
    final cleaned = userText.trim();
    if (cleaned.isEmpty || !mounted) return;

    await SpeechService.instance.cancelListening();
    await TtsService.instance.stop();

    setState(() {
      _voiceState = CallVoiceState.aiThinking;
      _statusBanner = 'Emma is thinking & checking your grammar...';
      _messages.add(
        AiTurnMessage(
          role: 'user',
          text: cleaned,
          urdu: '',
        ),
      );
    });
    _scrollToBottom();

    final reply = await AiTutorService.instance.generateReply(
      userText: cleaned,
      topic: _selectedTopic,
      history: _messages,
    );

    if (!mounted) return;

    setState(() {
      // Attach grammar feedback to the user's message
      final lastUserIndex =
          _messages.lastIndexWhere((element) => element.role == 'user');
      if (lastUserIndex != -1 && reply.grammarCorrection != null) {
        final prev = _messages[lastUserIndex];
        _messages[lastUserIndex] = AiTurnMessage(
          role: 'user',
          text: prev.text,
          urdu: prev.urdu,
          grammarFeedback: reply.grammarCorrection,
          timestamp: prev.timestamp,
        );
      }

      _messages.add(
        AiTurnMessage(
          role: 'ai',
          text: reply.replyEnglish,
          urdu: reply.replyUrdu,
        ),
      );
      _suggestions = reply.suggestions;
    });
    _scrollToBottom();

    await _speakAiResponse(reply.replyEnglish);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _pulseController.dispose();
    _scrollController.dispose();
    _textController.dispose();
    SpeechService.instance.cancelListening();
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
    final isListening = _voiceState == CallVoiceState.userListening;
    final isAiSpeaking = _voiceState == CallVoiceState.aiSpeaking;
    final isThinking = _voiceState == CallVoiceState.aiThinking;

    return Scaffold(
      backgroundColor: const Color(0xFF071318),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF0B2229),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.aiCallGradient,
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Emma • AI English Coach',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: isListening
                            ? AppColors.amber
                            : AppColors.emerald,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Live Call • ${_formatCallTime(_callSeconds)}',
                      style: const TextStyle(
                        color: Color(0xFFA7F3D0),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Slow / Normal TTS speed button
          IconButton(
            tooltip: _slowSpeechMode ? 'Slow Speech (0.38x)' : 'Normal Speech',
            onPressed: () async {
              setState(() => _slowSpeechMode = !_slowSpeechMode);
              await TtsService.instance
                  .setRate(_slowSpeechMode ? 0.36 : 0.48);
            },
            icon: Icon(
              Icons.speed_rounded,
              color: _slowSpeechMode ? AppColors.amber : Colors.white70,
            ),
          ),
          // Auto-listen hands-free toggle
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ActionChip(
              backgroundColor: _autoListenAfterAi
                  ? AppColors.emerald.withAlpha(45)
                  : Colors.white12,
              side: BorderSide(
                color: _autoListenAfterAi ? AppColors.emerald : Colors.white24,
              ),
              label: Text(
                _autoListenAfterAi ? 'Auto-Mic ON' : 'Manual Mic',
                style: TextStyle(
                  color: _autoListenAfterAi ? AppColors.emerald : Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: () {
                setState(() => _autoListenAfterAi = !_autoListenAfterAi);
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Topic Selector Strip
          Container(
            color: const Color(0xFF0B2229),
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _topics.map((topic) {
                  final selected = topic == _selectedTopic;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(topic),
                      selected: selected,
                      onSelected: (_) => _switchTopic(topic),
                      selectedColor: AppColors.primary,
                      backgroundColor: const Color(0xFF13313A),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color:
                              selected ? AppColors.primaryLight : Colors.white12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Active Voice Status & Avatar Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0B2229), Color(0xFF071318)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, _) {
                    final extraScale = isListening
                        ? (_currentRms / 40.0)
                        : (isAiSpeaking ? (_pulseAnimation.value - 1.0) : 0.0);
                    return Transform.scale(
                      scale: (1.0 + extraScale).clamp(0.95, 1.25),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isListening
                              ? const LinearGradient(
                                  colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                                )
                              : AppColors.aiCallGradient,
                          boxShadow: [
                            BoxShadow(
                              color: (isListening
                                      ? AppColors.amber
                                      : AppColors.primaryLight)
                                  .withAlpha(110),
                              blurRadius: 18,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          isListening
                              ? Icons.mic_rounded
                              : (isAiSpeaking
                                  ? Icons.graphic_eq_rounded
                                  : Icons.smart_toy_rounded),
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _statusBanner,
                        style: TextStyle(
                          color: isListening
                              ? AppColors.amber
                              : (isAiSpeaking
                                  ? AppColors.primaryLight
                                  : Colors.white),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (_livePartialSpeech.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.amber.withAlpha(30),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.amber.withAlpha(90),
                            ),
                          ),
                          child: Text(
                            '"$_livePartialSpeech..."',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ] else if (isThinking) ...[
                        const SizedBox(height: 6),
                        const LinearProgressIndicator(
                          color: AppColors.primaryLight,
                          backgroundColor: Colors.white12,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Live Conversation Transcript List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isAi = msg.role == 'ai';
                return _buildTranscriptBubble(msg, isAi);
              },
            ),
          ),

          // Quick Speaking Suggestions ("What can I say next?")
          if (_suggestions.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: const BoxDecoration(
                color: Color(0xFF0B1E24),
                border: Border(
                  top: BorderSide(color: Colors.white12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.tips_and_updates_rounded,
                        size: 14,
                        color: AppColors.amber,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Say one of these aloud (or tap to send):',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _suggestions.map((s) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _handleUserSpokenText(s.english),
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 270),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF13313A),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primaryLight.withAlpha(65),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '"${s.english}"',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (s.urdu.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      s.urdu,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        color: Color(0xFFA7F3D0),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

          // Bottom Voice Call Controls + Optional Text Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            decoration: const BoxDecoration(
              color: Color(0xFF0E272F),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 16,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Optional Type Bar in case user is in a noisy place
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Or type English sentence here to reply...',
                            hintStyle: const TextStyle(
                              color: Colors.white38,
                              fontSize: 12.5,
                            ),
                            filled: true,
                            fillColor: const Color(0xFF07161B),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (val) {
                            if (val.trim().isNotEmpty) {
                              _textController.clear();
                              _handleUserSpokenText(val);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () {
                          final val = _textController.text.trim();
                          if (val.isNotEmpty) {
                            _textController.clear();
                            FocusScope.of(context).unfocus();
                            _handleUserSpokenText(val);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Primary Call Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Speaker On/Off
                      _buildSecondaryCallButton(
                        icon: _isSpeakerOn
                            ? Icons.volume_up_rounded
                            : Icons.volume_off_rounded,
                        label: _isSpeakerOn ? 'Speaker ON' : 'Muted TTS',
                        active: _isSpeakerOn,
                        onTap: () {
                          setState(() => _isSpeakerOn = !_isSpeakerOn);
                          if (!_isSpeakerOn) {
                            TtsService.instance.stop();
                          }
                        },
                      ),

                      // Main Microphone Button (Tap to Speak / Stop)
                      GestureDetector(
                        onTap: () {
                          if (isListening) {
                            _stopListeningManually();
                          } else {
                            _startListeningToUser(usePopup: false);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            gradient: isListening
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFF59E0B),
                                      Color(0xFFEA580C),
                                    ],
                                  )
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFF10B981),
                                      Color(0xFF059669),
                                    ],
                                  ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: (isListening
                                        ? AppColors.amber
                                        : AppColors.emerald)
                                    .withAlpha(110),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isListening
                                    ? Icons.stop_circle_rounded
                                    : Icons.mic_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isListening ? 'Done Speaking' : 'Tap to Speak',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // System Voice Dialog Fallback + End Call
                      _buildSecondaryCallButton(
                        icon: Icons.settings_voice_rounded,
                        label: 'Google Mic',
                        active: false,
                        onTap: () => _startListeningToUser(usePopup: true),
                      ),

                      // End Call Button
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.all(14),
                        ),
                        tooltip: 'End Call',
                        icon: const Icon(
                          Icons.call_end_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryCallButton({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primary.withAlpha(60)
                    : Colors.white.withAlpha(18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: active ? AppColors.primaryLight : Colors.white70,
                size: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranscriptBubble(AiTurnMessage msg, bool isAi) {
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.84,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isAi ? const Color(0xFF112C35) : const Color(0xFF065F46),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isAi ? 4 : 18),
            bottomRight: Radius.circular(isAi ? 18 : 4),
          ),
          border: Border.all(
            color: isAi
                ? Colors.white.withAlpha(22)
                : AppColors.primaryLight.withAlpha(70),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isAi ? Icons.support_agent_rounded : Icons.person_rounded,
                  size: 15,
                  color: isAi ? AppColors.amber : const Color(0xFFA7F3D0),
                ),
                const SizedBox(width: 6),
                Text(
                  isAi ? 'Emma (AI Coach)' : 'You (Spoken English)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: isAi ? AppColors.amber : const Color(0xFFA7F3D0),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => TtsService.instance.speak(msg.text),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.volume_up_rounded,
                      size: 17,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              msg.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
            if (msg.urdu.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                msg.urdu,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Color(0xFFA7F3D0),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (msg.grammarFeedback != null &&
                msg.grammarFeedback!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(45),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.amber.withAlpha(80),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_fix_high_rounded,
                      size: 14,
                      color: AppColors.amber,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        msg.grammarFeedback!,
                        style: const TextStyle(
                          color: Color(0xFFFDE68A),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
