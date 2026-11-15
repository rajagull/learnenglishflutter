import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import '../theme/app_colors.dart';

class SpeakButton extends StatefulWidget {
  final String text;
  final double size;
  final Color? color;
  final Color? backgroundColor;

  const SpeakButton({
    super.key,
    required this.text,
    this.size = 20,
    this.color,
    this.backgroundColor,
  });

  @override
  State<SpeakButton> createState() => _SpeakButtonState();
}

class _SpeakButtonState extends State<SpeakButton> {
  bool _isSpeaking = false;

  void _handleSpeak() async {
    setState(() => _isSpeaking = true);
    await TtsService.instance.speak(widget.text);
    if (mounted) {
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) setState(() => _isSpeaking = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.backgroundColor ?? AppColors.primary.withAlpha(25),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _handleSpeak,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            _isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
            size: widget.size,
            color: widget.color ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}
