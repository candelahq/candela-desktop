import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Candela dark theme — matches the web UI design language.
class CandelaTheme {
  CandelaTheme._();

  static ThemeData get dark {
    final baseText = ThemeData.dark().textTheme;
    final interText = GoogleFonts.interTextTheme(baseText).apply(
      bodyColor: CandelaColors.textPrimary,
      displayColor: CandelaColors.textPrimary,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: CandelaColors.bgPrimary,
      canvasColor: CandelaColors.bgSecondary,
      cardColor: CandelaColors.bgSecondary,
      dividerColor: CandelaColors.borderSubtle,
      colorScheme: const ColorScheme.dark(
        primary: CandelaColors.accent,
        onPrimary: Colors.black,
        secondary: CandelaColors.accentHover,
        surface: CandelaColors.bgSecondary,
        error: CandelaColors.error,
      ),
      textTheme: interText,
      cardTheme: CardThemeData(
        color: CandelaColors.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: CandelaColors.borderSubtle),
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CandelaColors.accent,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CandelaColors.textPrimary,
          side: const BorderSide(color: CandelaColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        ),
      ),
      iconTheme: const IconThemeData(
        color: CandelaColors.textSecondary,
        size: 18,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(CandelaColors.border),
        radius: const Radius.circular(3),
        thickness: WidgetStateProperty.all(6),
      ),
    );
  }
}
