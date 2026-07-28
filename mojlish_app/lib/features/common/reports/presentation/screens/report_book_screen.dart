import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';

/// Common Report Book Viewer Screen
class ReportBookScreen extends StatelessWidget {
  final String majlisName;
  final String reportType;

  const ReportBookScreen({
    super.key,
    required this.majlisName,
    this.reportType = 'Personal',
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;
        final bgColor = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF162032) : Colors.white,
            title: Text('$reportType রিপোর্ট — $majlisName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: cardBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.menu_book_rounded, size: 48, color: AppTheme.primaryColor),
                      const SizedBox(height: 12),
                      Text(
                        '$majlisName — $reportType রিপোর্ট বই',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'এই রিপোর্ট বইটি আপনার সিলেক্ট করা মজলিসের জন্য নির্ধারিত।',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
