import 'package:flutter/material.dart';

class AppColors {
  // Executive Royal Indigo, Sapphire & Gold Brand Palette
  static const Color primary = Color(0xFF4F46E5); // Royal Indigo
  static const Color primaryDark = Color(0xFF1E1B4B); // Deep Midnight Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color secondary = Color(0xFF0EA5E9); // Vibrant Ocean Sky
  static const Color accent = Color(0xFFF59E0B); // Warm Luxe Gold

  // Vibrant Functional Accents
  static const Color emerald = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color sky = Color(0xFF0284C7);
  static const Color purple = Color(0xFF7C3AED);
  static const Color coral = Color(0xFFF43F5E);
  static const Color teal = Color(0xFF0D9488);

  // Crisp High-Contrast Backgrounds & Surfaces
  static const Color bgLight = Color(0xFFF4F6FB); // Cool Pearl Alabaster
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFEEF2FF);

  // Borders & Dividers
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFF1F5F9);

  // Typography
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMedium = Color(0xFF334155);
  static const Color textLight = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Urdu Accent
  static const Color urduGreen = Color(0xFF059669);

  // Signature Multi-Stop Gradients
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF1E1B4B), Color(0xFF3730A3), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiCallGradient = LinearGradient(
    colors: [Color(0xFF4338CA), Color(0xFF6366F1), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient conversationGradient = LinearGradient(
    colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient vocabularyGradient = LinearGradient(
    colors: [Color(0xFF047857), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tensesGradient = LinearGradient(
    colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient idiomsGradient = LinearGradient(
    colors: [Color(0xFFB45309), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient singularPluralGradient = LinearGradient(
    colors: [Color(0xFFBE123C), Color(0xFFF43F5E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dictionaryGradient = LinearGradient(
    colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient phrasesGradient = LinearGradient(
    colors: [Color(0xFFC2410C), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient quizGradient = LinearGradient(
    colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
