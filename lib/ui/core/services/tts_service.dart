import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService._internal();
  static final TtsService instance = TtsService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  final ValueNotifier<bool> isSpeaking = ValueNotifier<bool>(false);

  Future<void> _init() async {
    if (_isInitialized) return;
    try {
      _flutterTts = FlutterTts();
      await _flutterTts?.setLanguage('en-US');
      await _flutterTts?.setSpeechRate(0.48);
      await _flutterTts?.setVolume(1.0);
      await _flutterTts?.setPitch(1.0);
      await _flutterTts?.awaitSpeakCompletion(true);

      _flutterTts?.setStartHandler(() {
        isSpeaking.value = true;
      });
      _flutterTts?.setCompletionHandler(() {
        isSpeaking.value = false;
      });
      _flutterTts?.setCancelHandler(() {
        isSpeaking.value = false;
      });
      _flutterTts?.setErrorHandler((_) {
        isSpeaking.value = false;
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint('[TtsService] Initialization note: $e');
    }
  }

  Future<void> setRate(double rate) async {
    try {
      await _init();
      await _flutterTts?.setSpeechRate(rate);
    } catch (_) {}
  }

  Future<void> speak(String text, {VoidCallback? onDone}) async {
    if (text.trim().isEmpty) {
      onDone?.call();
      return;
    }
    try {
      await _init();
      await _flutterTts?.stop();
      isSpeaking.value = true;
      await _flutterTts?.speak(text.trim());
      isSpeaking.value = false;
      onDone?.call();
    } catch (e) {
      isSpeaking.value = false;
      debugPrint('[TtsService] Speak error: $e');
      onDone?.call();
    }
  }

  Future<void> stop() async {
    try {
      isSpeaking.value = false;
      await _flutterTts?.stop();
    } catch (_) {}
  }
}
