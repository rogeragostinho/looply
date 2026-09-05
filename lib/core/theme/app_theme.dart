import 'package:flutter/material.dart';

/// ============================================================
/// LIGHT PALETTE
/// Paper-cool neutrals + a confident indigo, with review-state
/// colors borrowed from spaced-repetition grading (again / hard
/// / good / easy) so the palette is grounded in what the app
/// actually does, not a generic SaaS blue-on-white kit.
/// ============================================================
class AppColorsLight {
  AppColorsLight._();

  static const background = Color(0xFFF7F8FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFEEF1F6);
  static const primary = Color(0xFF3654D6);
  static const secondary = Color(0xFF24399C);
  static const accent = Color(0xFF6C8EEF);
  static const textPrimary = Color(0xFF1B2333);
  static const textMuted = Color(0xFF5B6472);
  static const error = Color(0xFFD64545);
  static const border = Color(0xFFDDE2EA);

  // Review-grade colors (Anki-style difficulty feedback)
  static const reviewAgain = Color(0xFFD64545);
  static const reviewHard = Color(0xFFD98A2B);
  static const reviewGood = Color(0xFF2F9E58);
  static const reviewEasy = Color(0xFF3D8BDB);
}

/// ============================================================
/// DARK PALETTE
/// Kept close to the original — it already reads as a coherent,
/// GitHub-adjacent dark UI — with the same review-grade colors
/// tuned for contrast on a dark surface.
/// ============================================================
class AppColorsDark {
  AppColorsDark._();

  static const background = Color(0xFF0D1117);
  static const surface = Color(0xFF161B22);
  static const surfaceVariant = Color(0xFF1C2333);
  static const primary = Color(0xFF4A90D9);
  static const secondary = Color(0xFF58A6FF);
  static const accent = Color(0xFF79C0FF);
  static const textPrimary = Color(0xFFE6EDF3);
  static const textMuted = Color(0xFF8B949E);
  static const error = Color(0xFFF85149);
  static const border = Color(0xFF30363D);

  static const reviewAgain = Color(0xFFF85149);
  static const reviewHard = Color(0xFFE3A008);
  static const reviewGood = Color(0xFF3FB950);
  static const reviewEasy = Color(0xFF79C0FF);
}

class AppTheme {
  AppTheme._();

  // Shared type scale — sizes/weights/tracking are set once and
  // reused by both themes so light/dark only differ in color.
  static TextTheme _textTheme(Color primaryText, Color mutedText) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.4, color: primaryText, height: 1.2),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.2, color: primaryText, height: 1.25),
      titleLarge: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: primaryText, height: 1.3),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryText, height: 1.35),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primaryText, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: mutedText, height: 1.5),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryText, letterSpacing: 0.1),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: mutedText, letterSpacing: 0.2),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: width),
  );

  // ======================================================
  // ========================= DARK ======================
  // ======================================================
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColorsDark.background,
    textTheme: _textTheme(AppColorsDark.textPrimary, AppColorsDark.textMuted),

    colorScheme: const ColorScheme.dark(
      primary: AppColorsDark.primary,
      secondary: AppColorsDark.secondary,
      tertiary: AppColorsDark.reviewGood,
      error: AppColorsDark.error,
      surface: AppColorsDark.surface,
      onSurface: AppColorsDark.textPrimary,
      onSurfaceVariant: AppColorsDark.textMuted,
      outline: AppColorsDark.border,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsDark.background,
      foregroundColor: AppColorsDark.textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      color: AppColorsDark.surfaceVariant,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColorsDark.border),
      ),
    ),

    dividerTheme: const DividerThemeData(color: AppColorsDark.border, thickness: 1, space: 1),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsDark.primary,
        foregroundColor: AppColorsDark.textPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColorsDark.textPrimary,
        side: const BorderSide(color: AppColorsDark.border),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColorsDark.accent,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColorsDark.surfaceVariant,
      side: const BorderSide(color: AppColorsDark.border),
      labelStyle: const TextStyle(color: AppColorsDark.textPrimary, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColorsDark.primary,
      linearTrackColor: AppColorsDark.surfaceVariant,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColorsDark.surfaceVariant,
      contentTextStyle: const TextStyle(color: AppColorsDark.textPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColorsDark.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorsDark.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: const TextStyle(color: AppColorsDark.textMuted),
      hintStyle: TextStyle(color: AppColorsDark.textMuted.withValues(alpha: 0.7)),
      border: _inputBorder(AppColorsDark.border),
      enabledBorder: _inputBorder(AppColorsDark.border),
      focusedBorder: _inputBorder(AppColorsDark.primary, width: 1.5),
      errorBorder: _inputBorder(AppColorsDark.error),
      focusedErrorBorder: _inputBorder(AppColorsDark.error, width: 1.5),
    ),
  );

  // ======================================================
  // ========================= LIGHT =====================
  // ======================================================
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColorsLight.background,
    textTheme: _textTheme(AppColorsLight.textPrimary, AppColorsLight.textMuted),

    colorScheme: const ColorScheme.light(
      primary: AppColorsLight.primary,
      secondary: AppColorsLight.secondary,
      tertiary: AppColorsLight.reviewGood,
      error: AppColorsLight.error,
      surface: AppColorsLight.surface,
      onSurface: AppColorsLight.textPrimary,
      onSurfaceVariant: AppColorsLight.textMuted,
      outline: AppColorsLight.border,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsLight.background,
      foregroundColor: AppColorsLight.textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),

    // No default drop-shadow here — on a light background a
    // uniform soft grey shadow under every card is the generic
    // "SaaS card kit" look. A crisp hairline border does the
    // same separation job without the borrowed-template feel.
    cardTheme: CardThemeData(
      color: AppColorsLight.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColorsLight.border),
      ),
    ),

    dividerTheme: const DividerThemeData(color: AppColorsLight.border, thickness: 1, space: 1),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsLight.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColorsLight.textPrimary,
        side: const BorderSide(color: AppColorsLight.border),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColorsLight.secondary,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    // Handy for a difficulty-selection row (Again / Hard / Good /
    // Easy) using FilterChip/ChoiceChip with selectedColor set
    // per-chip to reviewAgain/reviewHard/reviewGood/reviewEasy.
    chipTheme: ChipThemeData(
      backgroundColor: AppColorsLight.surfaceVariant,
      side: const BorderSide(color: AppColorsLight.border),
      labelStyle: const TextStyle(color: AppColorsLight.textPrimary, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColorsLight.primary,
      linearTrackColor: AppColorsLight.surfaceVariant,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColorsLight.textPrimary,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColorsLight.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorsLight.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: const TextStyle(color: AppColorsLight.textMuted),
      hintStyle: TextStyle(color: AppColorsLight.textMuted.withValues(alpha: 0.7)),
      border: _inputBorder(AppColorsLight.border),
      enabledBorder: _inputBorder(AppColorsLight.border),
      focusedBorder: _inputBorder(AppColorsLight.primary, width: 1.5),
      errorBorder: _inputBorder(AppColorsLight.error),
      focusedErrorBorder: _inputBorder(AppColorsLight.error, width: 1.5),
    ),
  );
}