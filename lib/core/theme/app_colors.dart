import 'package:flutter/material.dart';

/// Centralized color palette extracted from Stitch designs.
/// Design uses a dark-only theme with neon green (#59F20D) as primary accent.
abstract final class AppColors {
  // Primary
  static const primary = Color(0xFF59F20D);

  // Backgrounds (dark-mode)
  static const bgDark = Color(0xFF0A0A0A);
  static const cardDark = Color(0xFF1A1A1A);
  static const surfaceDark = Color(0xFF1E1E1E);
  static const surfaceDarkLight = Color(0xFF2A2A2A);
  static const neutralDark = Color(0xFF262626);

  // Text
  static const textPrimary = Color(0xFFF1F5F9); // slate-100
  static const textSecondary = Color(0xFF64748B); // slate-500
  static const textMuted = Color(0xFF94A3B8); // slate-400

  // Functional alpha colors
  static const primaryAlpha05 = Color(0x0D59F20D);
  static const primaryAlpha10 = Color(0x1A59F20D);
  static const primaryAlpha15 = Color(0x2659F20D);
  static const primaryAlpha20 = Color(0x3359F20D);
  static const primaryAlpha30 = Color(0x4D59F20D);
  static const whiteAlpha05 = Color(0x0DFFFFFF);
  static const whiteAlpha10 = Color(0x1AFFFFFF);
}
