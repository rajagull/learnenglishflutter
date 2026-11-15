import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SpeechService {
  SpeechService._internal() {
    _channel.setMethodCallHandler(_handleNativeMethodCall);
  }

  static final SpeechService instance = SpeechService._internal();
  static const MethodChannel _channel =
      MethodChannel('com.rajagull.learnenglishflutter/speech');

  void Function(String status)? onStatusChanged;
  void Function(String text, bool isFinal)? onResult;
  void Function(double rms)? onRmsChanged;
  void Function(int errorCode, String message)? onError;

  Future<dynamic> _handleNativeMethodCall(MethodCall call) async {
    if (call.method == 'onSpeechEvent' && call.arguments is Map) {
      final map = Map<String, dynamic>.from(call.arguments as Map);
      final type = map['type'] as String? ?? '';

      switch (type) {
        case 'status':
          final status = map['status'] as String? ?? 'idle';
          onStatusChanged?.call(status);
          break;
        case 'result':
          final text = map['text'] as String? ?? '';
          final isFinal = map['isFinal'] as bool? ?? false;
          onResult?.call(text, isFinal);
          break;
        case 'rms':
          final rms = (map['rms'] as num?)?.toDouble() ?? 0.0;
          onRmsChanged?.call(rms);
          break;
        case 'error':
          final code = (map['errorCode'] as num?)?.toInt() ?? -1;
          final msg = map['message'] as String? ?? 'Speech error';
          onError?.call(code, msg);
          break;
      }
    }
  }

  Future<bool> checkOrRequestPermission() async {
    try {
      final granted =
          await _channel.invokeMethod<bool>('checkOrRequestPermission');
      return granted ?? false;
    } catch (e) {
      debugPrint('[SpeechService] Permission check error: $e');
      return false;
    }
  }

  Future<bool> startListening({
    String locale = 'en-US',
    bool usePopup = false,
  }) async {
    try {
      final started = await _channel.invokeMethod<bool>('startListening', {
        'locale': locale,
        'usePopup': usePopup,
      });
      return started ?? false;
    } catch (e) {
      debugPrint('[SpeechService] startListening error: $e');
      return false;
    }
  }

  Future<void> stopListening() async {
    try {
      await _channel.invokeMethod('stopListening');
    } catch (_) {}
  }

  Future<void> cancelListening() async {
    try {
      await _channel.invokeMethod('cancelListening');
    } catch (_) {}
  }
}
