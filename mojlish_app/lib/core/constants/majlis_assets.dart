import 'package:flutter/material.dart';

/// Central Asset Helper for Majlis Specific Logos and Assets
class MajlisAssets {
  static const String khelafatLogo = 'assets/images/khelafot_majlish.png';
  static const String juboLogo = 'assets/images/jubo_majlish.png';
  static const String chatroLogo = 'assets/images/chatro_majlish.png';
  static const String mohilaLogo = 'assets/images/mohila-majlish.png';
  static const String sromikLogo = 'assets/images/sromik-mojlis.jpeg';
  static const String electionSymbolWallClock = 'assets/images/election_symbol_wall_clock.png';
  static const String defaultLogo = 'assets/images/logo.png';

  /// Returns the specific asset logo path for a given Majlis name
  static String getLogoPath(String? majlisName) {
    if (majlisName == null) return khelafatLogo;

    final trimmed = majlisName.trim();
    if (trimmed.contains('যুব')) {
      return juboLogo;
    } else if (trimmed.contains('ছাত্র')) {
      return chatroLogo;
    } else if (trimmed.contains('মহিলা')) {
      return mohilaLogo;
    } else if (trimmed.contains('শ্রমিক')) {
      return sromikLogo;
    } else {
      return khelafatLogo;
    }
  }

  /// Helper widget to display a styled Majlis Logo with fallback
  static Widget getLogoWidget(
    String? majlisName, {
    double size = 32,
    BoxFit fit = BoxFit.contain,
  }) {
    final logoPath = getLogoPath(majlisName);
    return Image.asset(
      logoPath,
      height: size,
      width: size,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          defaultLogo,
          height: size,
          width: size,
          fit: fit,
          errorBuilder: (_, _, _) => Icon(
            Icons.stars_rounded,
            color: const Color(0xFF059669),
            size: size,
          ),
        );
      },
    );
  }
}
