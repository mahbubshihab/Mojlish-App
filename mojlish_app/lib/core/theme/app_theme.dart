import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF10B981);
  static const Color primaryDark = Color(0xFF059669);
  static const Color scaffoldBackground = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textLight = Color(0xFF64748B);

  // Dark Theme Colors
  static const Color darkBg = Color(0xFF0D1B2A);
  static const Color darkCardBg = Color(0xFF162032);
  static const Color darkBorder = Color(0xFF2A3F58);
  static const Color darkTextLight = Color(0xFFE2E8F0);
  static const Color darkTextMuted = Color(0xFF94A3B8);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: const Color(0xFF3B82F6),
      ),
      textTheme: GoogleFonts.notoSansBengaliTextTheme().copyWith(
        displayLarge: GoogleFonts.notoSansBengali(color: textDark, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.notoSansBengali(color: textDark, fontSize: 16),
        bodyMedium: GoogleFonts.notoSansBengali(color: textLight, fontSize: 14),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        secondary: const Color(0xFF3B82F6),
        surface: darkCardBg,
      ),
      textTheme: GoogleFonts.notoSansBengaliTextTheme().copyWith(
        displayLarge: GoogleFonts.notoSansBengali(color: darkTextLight, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.notoSansBengali(color: darkTextLight, fontSize: 16),
        bodyMedium: GoogleFonts.notoSansBengali(color: darkTextMuted, fontSize: 14),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkCardBg,
        elevation: 0,
        iconTheme: IconThemeData(color: darkTextLight),
        titleTextStyle: TextStyle(color: darkTextLight, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
