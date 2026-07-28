import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';

import 'report_book_screen.dart';

/// Common Central Report Selection Screen (Adapts to Active Majlis)
class ReportSelectionScreen extends StatelessWidget {
  final String? majlisName;

  const ReportSelectionScreen({super.key, this.majlisName});

  @override
  Widget build(BuildContext context) {
    final activeMajlis = majlisName ?? 'খেলাফত মজলিস';

    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;
        final bgColor = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
        final textColor = isDark ? Colors.white : AppTheme.textDark;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF162032) : Colors.white,
            elevation: 0,
            title: Text(
              'রিপোর্ট সেকশন — $activeMajlis',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                onPressed: () => themeManager.toggleTheme(),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF059669), Color(0xFF047857)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeMajlis,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'মজলিসের রিপোর্ট বই ও হিসাবসমূহ পর্যবেক্ষণ করুন',
                      style: TextStyle(fontSize: 13, color: Color(0xFFA7F3D0)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _buildReportCard(
                context,
                title: 'ব্যক্তিগত রিপোর্ট বই',
                subtitle: 'দৈনন্দিন আমল, ইবাদত ও দাওয়াতি কাজের হিসাব',
                icon: Icons.person_outline_rounded,
                color: const Color(0xFFDC2626),
                cardBg: cardBg,
                textColor: textColor,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ReportBookScreen(majlisName: activeMajlis, reportType: 'Personal')),
                ),
              ),
              const SizedBox(height: 12),
              _buildReportCard(
                context,
                title: 'শাখা সাংগঠনিক রিপোর্ট বই',
                subtitle: 'মাসিক সাংগঠনিক সভার কার্য বিবরণী ও রিপোর্ট',
                icon: Icons.assessment_outlined,
                color: const Color(0xFF0284C7),
                cardBg: cardBg,
                textColor: textColor,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ReportBookScreen(majlisName: activeMajlis, reportType: 'Organizational')),
                ),
              ),
              const SizedBox(height: 12),
              _buildReportCard(
                context,
                title: 'শাখা বায়তুলমাল রিপোর্ট বই',
                subtitle: 'মাসিক আয়-ব্যয় ও বায়তুলমাল তহবিল হিসাব',
                icon: Icons.account_balance_wallet_outlined,
                color: const Color(0xFF16A34A),
                cardBg: cardBg,
                textColor: textColor,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ReportBookScreen(majlisName: activeMajlis, reportType: 'Baytulmal')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color cardBg,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Card(
      color: cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }
}
