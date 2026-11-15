import 'package:flutter/material.dart';

class AppColors {
  // Brand Gradients & Primaries (Royal Emerald & Deep Teal Theme)
  static const Color primary = Color(0xFF0D9488); // Deep Teal
  static const Color primaryDark = Color(0xFF065F46); // Deep Forest Emerald
  static const Color primaryLight = Color(0xFF2DD4BF);
  static const Color secondary = Color(0xFF2563EB); // Royal Blue
  static const Color accent = Color(0xFFF59E0B); // Warm Gold

  // Vibrant Functional Accents
  static const Color emerald = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color sky = Color(0xFF0EA5E9);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color coral = Color(0xFFF43F5E);
  static const Color teal = Color(0xFF14B8A6);

  // Backgrounds & Surfaces
  static const Color bgLight = Color(0xFFF0FDF9); // Soft Mint-Tinted Porcelain
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFE6F7F2);

  // Borders & Dividers
  static const Color borderLight = Color(0xFFD1FAE5);
  static const Color borderSubtle = Color(0xFFECFDF5);

  // Typography
  static const Color textDark = Color(0xFF062C22);
  static const Color textMedium = Color(0xFF335C52);
  static const Color textLight = Color(0xFF5C8278);
  static const Color textMuted = Color(0xFF8BA8A0);

  // Urdu Accent
  static const Color urduGreen = Color(0xFF047857);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF042F2E), Color(0xFF0F766E), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiCallGradient = LinearGradient(
    colors: [Color(0xFF0F766E), Color(0xFF0D9488), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient conversationGradient = LinearGradient(
    colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient vocabularyGradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tensesGradient = LinearGradient(
    colors: [Color(0xFF6D28D9), Color(0xFFA78BFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient idiomsGradient = LinearGradient(
    colors: [Color(0xFFD97706), Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient singularPluralGradient = LinearGradient(
    colors: [Color(0xFFE11D48), Color(0xFFFB7185)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dictionaryGradient = LinearGradient(
    colors: [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
