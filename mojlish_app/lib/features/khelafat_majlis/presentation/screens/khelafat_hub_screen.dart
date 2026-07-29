import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/features/khelafat_majlis/syllabi/khelafot_syllabus/presentation/pages/khelafot_syllabus_page.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_book_screen.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import '../../overview/presentation/pages/overview_page.dart';
import '../../executive_rules/presentation/screens/executive_rules_screen.dart';
import '../../member_form/presentation/screens/member_form_screen.dart';
import '../../baytulmal_report/presentation/pages/baytulmal_report_page.dart';
import '../../branch_plan/presentation/screens/khelafat_branch_plan_book_screen.dart';
import '../../branch_report/presentation/screens/khelafat_branch_report_book_screen.dart';
import '../../zonal_report/presentation/screens/zonal_report_book_screen.dart';

/// Khelafat Majlis Central Hub Screen with Ambient Background & 6 Form Complete Integration
class KhelafatHubScreen extends StatelessWidget {
  const KhelafatHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
        final textColor = isDark ? Colors.white : AppTheme.textDark;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF162032) : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Row(
              children: [
                Icon(Icons.account_balance_rounded, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text('খেলাফত মজলিস হাব', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.wb_sunny : Icons.nightlight_round,
                  color: isDark ? Colors.yellow : Colors.black87,
                ),
                onPressed: () => themeManager.toggleTheme(),
              ),
            ],
          ),
          body: AmbientBackgroundWidget(
            primaryAccent: AppTheme.primaryColor,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBannerCard(isDark),
                  const SizedBox(height: 20),
                  Text(
                    'রিপোর্ট ও ফরম মডিউল',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.15,
                    children: [
                      _buildGridTile(
                        context,
                        title: 'ব্যক্তিগত রিপোর্ট',
                        subtitle: '৩১ দিনের টেবিল ভিউ',
                        icon: Icons.person_outline_rounded,
                        color: const Color(0xFF10B981),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReportBookScreen(majlisType: MajlisType.khelafat),
                          ),
                        ),
                      ),
                      _buildGridTile(
                        context,
                        title: 'শাখার রিপোর্ট',
                        subtitle: 'সাংগঠনিক বিবরণী',
                        icon: Icons.corporate_fare_rounded,
                        color: const Color(0xFF2563EB),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const KhelafatBranchReportBookScreen()),
                        ),
                      ),
                      _buildGridTile(
                        context,
                        title: 'শাখার পরিকল্পনা',
                        subtitle: 'বার্ষিক/মাসিক ছক',
                        icon: Icons.assignment_turned_in_rounded,
                        color: const Color(0xFF8B5CF6),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const KhelafatBranchPlanBookScreen()),
                        ),
                      ),
                      _buildGridTile(
                        context,
                        title: 'বায়তুলমাল হিসাব',
                        subtitle: 'আয়-ব্যয় ও অনুদান',
                        icon: Icons.account_balance_wallet_rounded,
                        color: const Color(0xFFD97706),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const BaytulmalReportPage()),
                        ),
                      ),
                      _buildGridTile(
                        context,
                        title: 'জোনাল রিপোর্ট',
                        subtitle: 'জোনাল সাংগঠনিক ছক',
                        icon: Icons.map_rounded,
                        color: const Color(0xFF0284C7),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ZonalReportBookScreen()),
                        ),
                      ),
                      _buildGridTile(
                        context,
                        title: 'সদস্য ফরম',
                        subtitle: 'প্রাথমিক সদস্য আবেদন',
                        icon: Icons.badge_rounded,
                        color: const Color(0xFFEC4899),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MemberFormScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'সংগঠন ও সিল্যাবাস',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildListTile(
                    context,
                    title: 'সংগঠনের সংক্ষিপ্ত পরিচিতি',
                    subtitle: 'উদ্দেশ্য, লক্ষ্য ও দাওয়াত',
                    icon: Icons.info_outline_rounded,
                    color: const Color(0xFF0D9488),
                    cardBg: cardBg,
                    textColor: textColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KhelafatOverviewPage()),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildListTile(
                    context,
                    title: 'দস্তুর ও পরিচালন বিধি',
                    subtitle: 'সাংগঠনিক নিয়মাবলী',
                    icon: Icons.gavel_rounded,
                    color: const Color(0xFF6366F1),
                    cardBg: cardBg,
                    textColor: textColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ExecutiveRulesScreen()),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildListTile(
                    context,
                    title: 'পাঠ্যক্রম ও সিলেবাস',
                    subtitle: 'অধ্যায়ন ও তারবিয়াত বইপুস্তক',
                    icon: Icons.auto_stories_rounded,
                    color: const Color(0xFF059669),
                    cardBg: cardBg,
                    textColor: textColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KhelafotSyllabusPage()),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBannerCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'খেলাফত মজলিস',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'কুরআন, সুন্নাহ ও খেলাফতে রাশেদার অনুসরণে ইনসাফপূর্ণ সমাজ বিনির্মাণে সংকল্পবদ্ধ।',
            style: TextStyle(
              color: Colors.white90,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color cardBg,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color cardBg,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}
