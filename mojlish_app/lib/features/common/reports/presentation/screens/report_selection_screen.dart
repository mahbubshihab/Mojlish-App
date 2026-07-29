import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/services/user_storage_service.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/khelafat_majlis/baytulmal_report/presentation/pages/baytulmal_report_page.dart';
import 'package:mojlish_app/features/khelafat_majlis/branch_report/presentation/screens/khelafat_branch_report_book_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/branch_plan/presentation/screens/khelafat_branch_plan_book_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/zonal_report/presentation/screens/zonal_report_book_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/member_form/presentation/screens/member_form_screen.dart';
import 'report_book_screen.dart';

/// রিপোর্ট হাব স্ক্রিন — খেলাফত মজলিসসহ সকল মজলিসের ডাইনামিক ও সম্পূর্ণ রিপোর্ট ও ফরম কেন্দ্র
class ReportSelectionScreen extends StatefulWidget {
  final String? majlisName;
  final MajlisType? majlisType;

  const ReportSelectionScreen({super.key, this.majlisName, this.majlisType});

  @override
  State<ReportSelectionScreen> createState() => _ReportSelectionScreenState();
}

class _ReportSelectionScreenState extends State<ReportSelectionScreen> {
  int _personalFilledDays = 0;
  int _daysInMonth = 30;
  String _activeMajlisName = 'খেলাফত মজলিস';
  final _now = DateTime.now();

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
  ];

  @override
  void initState() {
    super.initState();
    _loadActiveMajlisAndStats();
  }

  Future<void> _loadActiveMajlisAndStats() async {
    try {
      final savedMajlis = await UserStorageService.getActiveMajlis();
      final days = await ReportStorageService.getFilledDaysCount(_now.year, _now.month);
      final dim = DateTime(_now.year, _now.month + 1, 0).day;

      if (mounted) {
        setState(() {
          if (savedMajlis != null && savedMajlis.isNotEmpty) {
            _activeMajlisName = savedMajlis;
          }
          _personalFilledDays = days;
          _daysInMonth = dim;
        });
      }
    } catch (_) {}
  }

  MajlisType _resolveMajlisType() {
    if (widget.majlisType != null) return widget.majlisType!;
    if (widget.majlisName != null && widget.majlisName!.isNotEmpty) {
      return MajlisTypeExtension.fromString(widget.majlisName!);
    }
    return MajlisTypeExtension.fromString(_activeMajlisName);
  }

  String _getEffectiveMajlisName() {
    if (widget.majlisName != null && widget.majlisName!.isNotEmpty) {
      return widget.majlisName!;
    }
    return _activeMajlisName;
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  @override
  Widget build(BuildContext context) {
    final activeMajlisType = _resolveMajlisType();
    final majlisDisplayName = _getEffectiveMajlisName();
    final isKhelafat = activeMajlisType == MajlisType.khelafat || majlisDisplayName.contains('খেলাফত');

    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;

        final appBarBg = isDark ? const Color(0xFF162032) : Colors.white;
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
        final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);
        final textLight = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
        final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        const accentGreen = Color(0xFF10B981);

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
                _buildReportCard(
                  title: 'ব্যক্তিগত তৎপরতার রিপোর্ট',
                  subtitle: '$majlisDisplayName — ${_monthNames[_now.month - 1]} ${_bn(_now.year)} মাস',
                  badge: '$_personalFilledDays/$_daysInMonth দিন আপডেট',
                  badgeColor: _personalFilledDays >= _now.day ? const Color(0xFF059669) : const Color(0xFFF59E0B),
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
                        builder: (_) => ReportBookScreen(majlisType: activeMajlisType),
                      ),
                    );
                    _loadActiveMajlisAndStats();
                  },
                ),
                const SizedBox(height: 14),

                // 2. সাংগঠনিক শাখা রিপোর্ট
                _buildReportCard(
                  title: 'শাখার সাংগঠনিক রিপোর্ট',
                  subtitle: '$majlisDisplayName — শাখা ও প্রশাসনিক বিবরণী',
                  badge: 'নিয়মিত সিঙ্ক',
                  badgeColor: const Color(0xFF2563EB),
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
                const SizedBox(height: 14),

                // 3. শাখার বার্ষিক/মাসিক পরিকল্পনা ফরম
                _buildReportCard(
                  title: 'শাখার বার্ষিক/মাসিক পরিকল্পনা',
                  subtitle: '$majlisDisplayName — পরিকল্পনা ও লক্ষ্যমাত্রা ফরম',
                  badge: 'পরিকল্পনা',
                  badgeColor: const Color(0xFF8B5CF6),
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
                const SizedBox(height: 14),

                // 4. বায়তুলমাল ও হিসাব
                _buildReportCard(
                  title: 'বায়তুলমাল ও আর্থিক হিসাব',
                  subtitle: '$majlisDisplayName — আয় ও ব্যয়ের হিসাব',
                  badge: 'আর্থিক মডিউল',
                  badgeColor: const Color(0xFFD97706),
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
                const SizedBox(height: 14),

                // 5. জোনাল রিপোর্ট ফরম (Khelafat Majlis special)
                if (isKhelafat) ...[
                  _buildReportCard(
                    title: 'জোনাল রিপোর্ট ফরম',
                    subtitle: 'খেলাফত মজলিস — জোনাল সাংগঠনিক প্রতিবেদন',
                    badge: 'জোনাল শাখা',
                    badgeColor: const Color(0xFF0284C7),
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
                  const SizedBox(height: 14),
                ],

                // 6. প্রাথমিক সদস্য আবেদন ফরম
                _buildReportCard(
                  title: 'প্রাথমিক সদস্য ফরম (আবেদন)',
                  subtitle: '$majlisDisplayName — সদস্যপদ ফরম ও প্রত্যয়নপত্র',
                  badge: 'সদস্য আবেদন',
                  badgeColor: const Color(0xFFEC4899),
                  icon: Icons.badge_rounded,
                  color: const Color(0xFFEC4899),
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textLight: textLight,
                  textMuted: textMuted,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MemberFormScreen(),
                      ),
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

  Widget _buildReportCard({
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withValues(alpha: 0.25)),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(subtitle, style: TextStyle(color: textMuted, fontSize: 12)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(badge,
                        style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
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
