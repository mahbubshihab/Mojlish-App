import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/personal_report_table_screen.dart';

import 'package:mojlish_app/features/khelafat_majlis/branch_report/presentation/screens/khelafat_branch_report_book_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/branch_plan/presentation/screens/khelafat_branch_plan_book_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/zonal_report/presentation/screens/zonal_report_book_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/member_form/presentation/screens/member_form_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/baytulmal_report/presentation/pages/baytulmal_report_page.dart';

import 'package:mojlish_app/features/youth_majlis/member_form/presentation/screens/member_form_screen.dart' as youth_form;
import 'package:mojlish_app/features/student_majlis/member_form/presentation/screens/member_form_screen.dart' as chatro_form;

/// কেন্দ্রীয় রিপোর্ট ও ফরম হাব (Report & Form Hub Selection)
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

  @override
  void initState() {
    super.initState();
    _loadActiveMajlisAndStats();
  }

  Future<void> _loadActiveMajlisAndStats() async {
    if (mounted) {
      setState(() {});
    }
  }

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

    final activeMajlisType = widget.majlisName ?? 'khelafat';
    final isKhelafat = activeMajlisType == 'khelafat';
    final isYouth = activeMajlisType == 'youth' || activeMajlisType == 'jubo';
    final isChatro = activeMajlisType == 'chatro';

    final majlisDisplayName = isKhelafat
        ? 'খেলাফত মজলিস'
        : isYouth
            ? 'ইসলামী যুব মজলিস'
            : isChatro
                ? 'ইসলামী ছাত্র মজলিস'
                : 'ইসলামী খেলাফত মজলিস';

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
                  style: const TextStyle(color: accentGreen, fontSize: 16, fontWeight: FontWeight.bold),
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
                // 1. কোনটা কোন মজলিস তার উপযোগী ব্যক্তিগত তৎপরতার রিপোর্ট
                _buildMinimalReportCard(
                  title: 'ব্যক্তিগত তৎপরতার রিপোর্ট',
                  icon: Icons.person_outline_rounded,
                  color: const Color(0xFF10B981),
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textLight: textLight,
                  textMuted: textMuted,
                  onTap: () async {
                    MajlisType parsedType;
                    if (activeMajlisType == 'youth' || activeMajlisType == 'jubo') {
                      parsedType = MajlisType.jubo;
                    } else if (activeMajlisType == 'chatro') {
                      parsedType = MajlisType.chatro;
                    } else {
                      parsedType = MajlisType.khelafat;
                    }

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PersonalReportTableScreen(
                          year: _now.year,
                          month: _now.month,
                          majlisType: parsedType,
                        ),
                      ),
                    );
                    _loadActiveMajlisAndStats();
                  },
                ),
                const SizedBox(height: 12),

                // 2. সাংগঠনিক শাখা রিপোর্ট
                _buildMinimalReportCard(
                  title: 'শাখার সাংগঠনিক রিপোর্ট',
                  icon: Icons.corporate_fare_rounded,
                  color: const Color(0xFF2563EB),
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textLight: textLight,
                  textMuted: textMuted,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const KhelafatBranchReportBookScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // 3. শাখার বার্ষিক/মাসিক পরিকল্পনা ফরম
                _buildMinimalReportCard(
                  title: 'শাখার বার্ষিক/মাসিক পরিকল্পনা',
                  icon: Icons.assignment_turned_in_rounded,
                  color: const Color(0xFF8B5CF6),
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textLight: textLight,
                  textMuted: textMuted,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const KhelafatBranchPlanBookScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // 4. বায়তুলমাল ও হিসাব
                _buildMinimalReportCard(
                  title: 'বায়তুলমাল ও আর্থিক হিসাব',
                  icon: Icons.account_balance_wallet_rounded,
                  color: const Color(0xFFD97706),
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textLight: textLight,
                  textMuted: textMuted,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BaytulmalReportPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // 5. জোনাল রিপোর্ট ফরম (Khelafat Majlis special)
                if (isKhelafat) ...[
                  _buildMinimalReportCard(
                    title: 'জোনাল রিপোর্ট ফরম',
                    icon: Icons.map_rounded,
                    color: const Color(0xFF0284C7),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    textMuted: textMuted,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ZonalReportBookScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                // 6. প্রাথমিক সদস্য আবেদন ফরম
                _buildMinimalReportCard(
                  title: 'প্রাথমিক সদস্য ফরম (আবেদন)',
                  icon: Icons.badge_rounded,
                  color: const Color(0xFFEC4899),
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textLight: textLight,
                  textMuted: textMuted,
                  onTap: () async {
                    Widget destination;
                    if (isYouth) {
                      destination = const youth_form.YouthMemberFormScreen();
                    } else if (isChatro) {
                      destination = const chatro_form.ChatroMemberFormScreen();
                    } else {
                      destination = const MemberFormScreen();
                    }

                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => destination),
                    );
                  },
                ),
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
