import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/personal_report_table_screen.dart';

// Khelafat Majlis Features
import 'package:mojlish_app/features/khelafat_majlis/branch_report/presentation/screens/khelafat_branch_report_book_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/branch_plan/presentation/screens/khelafat_branch_plan_book_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/zonal_report/presentation/screens/zonal_report_book_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/member_form/presentation/screens/member_form_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/baytulmal_report/presentation/pages/baytulmal_report_page.dart';

// Youth Majlis Features
import 'package:mojlish_app/features/youth_majlis/member_form/presentation/screens/member_form_screen.dart' as youth_form;
import 'package:mojlish_app/features/youth_majlis/call_manifesto/presentation/screens/call_manifesto_screen.dart';

// Student Majlis Features
import 'package:mojlish_app/features/student_majlis/member_form/presentation/screens/member_form_screen.dart' as chatro_form;
import 'package:mojlish_app/features/student_majlis/period_report/presentation/screens/period_report_screen.dart';
import 'package:mojlish_app/features/student_majlis/period_plan/presentation/screens/period_plan_screen.dart';
import 'package:mojlish_app/features/student_majlis/general_plan/presentation/screens/general_plan_screen.dart';

// Labor Majlis Features
import 'package:mojlish_app/features/labor_majlis/member_form/presentation/screens/member_form_screen.dart';

// Women Majlis Features
import 'package:mojlish_app/features/women_majlis/resources/ahobban_mohila/presentation/screens/ahobban_screen.dart';

/// কেন্দ্রীয় রিপোর্ট ও ফরম হাব (Majlis-Specific Report & Form Hub Selection)
class ReportSelectionScreen extends StatefulWidget {
  final String? majlisName;

  const ReportSelectionScreen({super.key, this.majlisName});

  @override
  State<ReportSelectionScreen> createState() => _ReportSelectionScreenState();
}

class _ReportSelectionScreenState extends State<ReportSelectionScreen> {
  final DateTime _now = DateTime.now();

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
  ];

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final appBarBg = isDark ? const Color(0xFF162032) : Colors.white;
    final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);
    final textLight = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    const accentGreen = Color(0xFF10B981);

    final rawMajlis = (widget.majlisName ?? '').toLowerCase();
    final isYouth = rawMajlis.contains('youth') || rawMajlis.contains('jubo') || rawMajlis.contains('যুব');
    final isChatro = rawMajlis.contains('chatro') || rawMajlis.contains('student') || rawMajlis.contains('ছাত্র');
    final isLabor = rawMajlis.contains('sromik') || rawMajlis.contains('labor') || rawMajlis.contains('শ্রমিক');
    final isWomen = rawMajlis.contains('mohila') || rawMajlis.contains('women') || rawMajlis.contains('মহিলা');
    final isKhelafat = !isYouth && !isChatro && !isLabor && !isWomen;

    final majlisDisplayName = isKhelafat
        ? 'বাংলাদেশ খেলাফত মজলিস'
        : isYouth
            ? 'বাংলাদেশ ইসলামী যুব মজলিস'
            : isChatro
                ? 'বাংলাদেশ ইসলামী ছাত্র মজলিস'
                : isLabor
                    ? 'বাংলাদেশ ইসলামী শ্রমিক মজলিস'
                    : isWomen
                        ? 'ইসলামী মহিলা মজলিস'
                        : 'ইসলামী খেলাফত মজলিস';

    MajlisType parsedMajlisType;
    if (isYouth) {
      parsedMajlisType = MajlisType.jubo;
    } else if (isChatro) {
      parsedMajlisType = MajlisType.chatro;
    } else if (isLabor) {
      parsedMajlisType = MajlisType.sromik;
    } else if (isWomen) {
      parsedMajlisType = MajlisType.mohila;
    } else {
      parsedMajlisType = MajlisType.khelafat;
    }

    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: textLight, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$majlisDisplayName — রিপোর্ট ও ফরম হাব',
                  style: const TextStyle(color: accentGreen, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_monthNames[_now.month - 1]} ${_bn(_now.year)}',
                  style: TextStyle(color: textMuted, fontSize: 11),
                ),
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
            primaryAccent: accentGreen,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                // 1. সকল মজলিসের নিজস্ব ব্যক্তিগত তৎপরতার রিপোর্ট
                _buildMinimalReportCard(
                  title: 'ব্যক্তিগত তৎপরতার রিপোর্ট ($majlisDisplayName)',
                  icon: Icons.person_outline_rounded,
                  color: const Color(0xFF10B981),
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textLight: textLight,
                  textMuted: textMuted,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PersonalReportTableScreen(
                          year: _now.year,
                          month: _now.month,
                          majlisType: parsedMajlisType,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // ==================== KHELAFAT MAJLIS ONLY ====================
                if (isKhelafat) ...[
                  _buildMinimalReportCard(
                    title: 'শাখার সাংগঠনিক রিপোর্ট',
                    icon: Icons.corporate_fare_rounded,
                    color: const Color(0xFF2563EB),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    textMuted: textMuted,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KhelafatBranchReportBookScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMinimalReportCard(
                    title: 'শাখার বার্ষিক/মাসিক পরিকল্পনা',
                    icon: Icons.assignment_turned_in_rounded,
                    color: const Color(0xFF8B5CF6),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    textMuted: textMuted,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KhelafatBranchPlanBookScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMinimalReportCard(
                    title: 'বায়তুলমাল ও আর্থিক হিসাব',
                    icon: Icons.account_balance_wallet_rounded,
                    color: const Color(0xFFD97706),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    textMuted: textMuted,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BaytulmalReportPage()),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMinimalReportCard(
                    title: 'জোনাল রিপোর্ট ফরম',
                    icon: Icons.map_rounded,
                    color: const Color(0xFF0284C7),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    textMuted: textMuted,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ZonalReportBookScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMinimalReportCard(
                    title: 'প্রাথমিক সদস্য ফরম (আবেদন)',
                    icon: Icons.badge_rounded,
                    color: const Color(0xFFEC4899),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    textMuted: textMuted,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MemberFormScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // ==================== YOUTH MAJLIS (JUBO) ONLY ====================
                if (isYouth) ...[
                  _buildMinimalReportCard(
                    title: 'দাওয়াতী ইশতেহার ও ম্যানিফেস্টো',
                    icon: Icons.auto_stories_rounded,
                    color: const Color(0xFF0284C7),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    textMuted: textMuted,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const YouthCallManifestoScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMinimalReportCard(
                    title: 'যুব মজলিস — প্রাথমিক সদস্য আবেদন ফরম',
                    icon: Icons.badge_rounded,
                    color: const Color(0xFFEC4899),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    textMuted: textMuted,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const youth_form.YouthMemberFormScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // ==================== STUDENT MAJLIS (CHATRO) ONLY ====================
                if (isChatro) ...[
                  _buildMinimalReportCard(
                    title: 'মেয়াদী/সেশনাল রিপোর্ট ফরম',
                    icon: Icons.date_range_rounded,
                    color: const Color(0xFF2563EB),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    textMuted: textMuted,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PeriodReportScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMinimalReportCard(
                    title: 'মেয়াদী/সেশনাল পরিকল্পনা ফরম',
                    icon: Icons.assignment_rounded,
                    color: const Color(0xFF8B5CF6),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    textMuted: textMuted,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PeriodPlanScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMinimalReportCard(
                    title: 'সাধারণ পরিকল্পনা ফরম',
                    icon: Icons.event_note_rounded,
                    color: const Color(0xFF06B6D4),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    textMuted: textMuted,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GeneralPlanScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMinimalReportCard(
                    title: 'ছাত্র মজলিস — বায়তুলমাল রিপোর্ট',
                    icon: Icons.account_balance_wallet_rounded,
                    color: const Color(0xFFD97706),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    textMuted: textMuted,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BaytulmalReportPage()),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMinimalReportCard(
                    title: 'ছাত্র মজলিস — প্রাথমিক সদস্য আবেদন ফরম',
                    icon: Icons.badge_rounded,
                    color: const Color(0xFFEC4899),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    textMuted: textMuted,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const chatro_form.ChatroMemberFormScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // ==================== LABOR MAJLIS (SROMIK) ONLY ====================
                if (isLabor) ...[
                  _buildMinimalReportCard(
                    title: 'শ্রমিক মজলিস — প্রাথমিক সদস্য আবেদন ফরম',
                    icon: Icons.badge_rounded,
                    color: const Color(0xFFEC4899),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    textMuted: textMuted,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LaborMemberFormScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // ==================== WOMEN MAJLIS (MOHILA) ONLY ====================
                if (isWomen) ...[
                  _buildMinimalReportCard(
                    title: 'মহিলা মজলিস — আমাদের আহ্বান ও ম্যানিফেস্টো',
                    icon: Icons.auto_stories_rounded,
                    color: const Color(0xFFE11D48),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    textMuted: textMuted,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AhobbanMohilaScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Minimal Clean Card Layout containing ONLY Title/Name
  Widget _buildMinimalReportCard({
    required String title,
    required IconData icon,
    required Color color,
    required Color cardBg,
    required Color borderColor,
    required Color textLight,
    required Color textMuted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.25)),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
