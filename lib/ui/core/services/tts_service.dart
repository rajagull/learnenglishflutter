import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService._internal();
  static final TtsService instance = TtsService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;

  Future<void> _init() async {
    if (_isInitialized) return;
    try {
      _flutterTts = FlutterTts();
      await _flutterTts?.setLanguage('en-US');
      await _flutterTts?.setSpeechRate(0.48);
      await _flutterTts?.setVolume(1.0);
      await _flutterTts?.setPitch(1.0);
      _isInitialized = true;
    } catch (e) {
      debugPrint('[TtsService] Initialization note: $e');
    }
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    try {
      await _init();
      await _flutterTts?.stop();
      await _flutterTts?.speak(text.trim());
    } catch (e) {
      debugPrint('[TtsService] Speak error: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts?.stop();
    } catch (_) {}
  }
}
