import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF10B981);
  static const Color primaryDark = Color(0xFF059669);
  static const Color scaffoldBackground = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textLight = Color(0xFF64748B);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
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
}
