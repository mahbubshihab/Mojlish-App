import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/features/syllabi/khelafot_syllabus/presentation/screens/khelafot_syllabus_screen.dart';
import 'package:mojlish_app/features/reports/general_report/presentation/screens/report_book_screen.dart';
import 'package:mojlish_app/features/reports/personal_report/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/reports/sanghotonik_report/presentation/screens/sanghotonik_report_book_screen.dart';
import 'package:mojlish_app/features/reports/baytulmal_report/presentation/screens/baytulmal_report_book_screen.dart';

import 'khelafat_overview_screen.dart';
import 'khelafat_rules_screen.dart';
import 'khelafat_member_form_screen.dart';
import 'khelafat_branch_plan_screen.dart';

/// Khelafat Majlis Central Hub Screen
class KhelafatHubScreen extends StatelessWidget {
  const KhelafatHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            title: const Row(
              children: [
                Icon(Icons.account_balance_rounded, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  'খেলাফত মজলিস হাব',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                onPressed: () => themeManager.toggleTheme(),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF059669), Color(0xFF047857)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'খেলাফত মজলিস',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'খেলাফত প্রতিষ্ঠার লক্ষ্যে গণ-আন্দোলন গড়ে তুলুন',
                        style: TextStyle(fontSize: 13, color: Color(0xFFA7F3D0), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  '৭টি মূল সাব-ফিচারসমূহ:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.primaryColor),
                ),
                const SizedBox(height: 14),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.05,
                  children: [
                    _buildHubCard(
                      title: 'সংক্ষিপ্ত পরিচিতি',
                      subtitle: 'ইতিহাস, লক্ষ্য, ৭-দফা ও ১৭-দফা নীতি',
                      icon: Icons.info_outline_rounded,
                      color: const Color(0xFF059669),
                      cardBg: cardBg,
                      textColor: textColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KhelafatOverviewScreen())),
                    ),
                    _buildHubCard(
                      title: 'কর্মপ্রণালী নির্দেশিকা',
                      subtitle: 'দাওয়াত, ট্রেইনিং ও অডিট অপারেটিং ম্যানুয়াল',
                      icon: Icons.menu_book_rounded,
                      color: const Color(0xFF0D9488),
                      cardBg: cardBg,
                      textColor: textColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KhelafatRulesScreen())),
                    ),
                    _buildHubCard(
                      title: 'প্রাথমিক সদস্য ফরম',
                      subtitle: 'ডিজিটাল সদস্যপদ আবেদন ও অঙ্গীকারনামা',
                      icon: Icons.badge_rounded,
                      color: const Color(0xFF2563EB),
                      cardBg: cardBg,
                      textColor: textColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KhelafatMemberFormScreen())),
                    ),
                    _buildHubCard(
                      title: 'শাখার পরিকল্পনা ফরম',
                      subtitle: '১০টি বিভাগে বার্ষিক/মাসিক পরিকল্পনা',
                      icon: Icons.assignment_rounded,
                      color: const Color(0xFF7C3AED),
                      cardBg: cardBg,
                      textColor: textColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KhelafatBranchPlanScreen())),
                    ),
                    _buildHubCard(
                      title: 'খেলাফত মজলিস সিলেবাস',
                      subtitle: 'কর্মী ও সদস্যদের ৩-স্তরের পাঠ্যক্রম',
                      icon: Icons.auto_stories_rounded,
                      color: const Color(0xFFD97706),
                      cardBg: cardBg,
                      textColor: textColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KhelafatSyllabusScreen())),
                    ),
                    _buildHubCard(
                      title: 'ব্যক্তিগত রিপোর্ট',
                      subtitle: 'দৈনন্দিন আমল ও দাওয়াতি কাজের হিসাব',
                      icon: Icons.person_outline_rounded,
                      color: const Color(0xFFDC2626),
                      cardBg: cardBg,
                      textColor: textColor,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ReportBookScreen(majlisType: MajlisTypeExtension.fromString('খেলাফত মজলিস'))),
                      ),
                    ),
                    _buildHubCard(
                      title: 'শাখা সাংগঠনিক রিপোর্ট',
                      subtitle: 'মাসিক সাংগঠনিক রিপোর্ট ফরম',
                      icon: Icons.assessment_outlined,
                      color: const Color(0xFF0284C7),
                      cardBg: cardBg,
                      textColor: textColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SanghotonikReportBookScreen())),
                    ),
                    _buildHubCard(
                      title: 'শাখা বায়তুলমাল রিপোর্ট',
                      subtitle: 'মাসিক আয়-ব্যয় ও বায়তুলমাল তহবিল',
                      icon: Icons.account_balance_wallet_outlined,
                      color: const Color(0xFF16A34A),
                      cardBg: cardBg,
                      textColor: textColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BaytulmalReportBookScreen())),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHubCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color cardBg,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
