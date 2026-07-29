import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/services/user_storage_service.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/khelafat_majlis/baytulmal_report/presentation/screens/baytulmal_report_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/branch_report/presentation/screens/khelafat_branch_report_book_screen.dart';
import 'report_book_screen.dart';

/// রিপোর্টসমূহ — মূল হাব স্ক্রিন, সক্রিয় মজলিসের সব রিপোর্টের কার্ড দেখায়
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

    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;

        final bg = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
        final appBarBg = isDark ? const Color(0xFF162032) : Colors.white;
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
        final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);
        final textLight = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
        final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        const accentGreen = Color(0xFF10B981);

        return Scaffold(
          backgroundColor: bg,
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
                  '$majlisDisplayName — রিপোর্ট হাব',
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
          body: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _HubBgPainter(isDark: isDark))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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

                        // 2. সাংগঠনিক রিপোর্ট
                        _buildReportCard(
                          title: 'সাংগঠনিক শাখা রিপোর্ট',
                          subtitle: '$majlisDisplayName — শাখা ও প্রশাসনিক রিপোর্ট',
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

                        // 3. বায়তুলমাল ও হিসাব
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
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ],
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
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
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
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(subtitle, style: TextStyle(color: textMuted, fontSize: 12)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

class _HubBgPainter extends CustomPainter {
  final bool isDark;
  _HubBgPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isDark) {
      final grid = Paint()..color = Colors.grey.withValues(alpha: 0.05)..strokeWidth = 0.5..style = PaintingStyle.stroke;
      for (double x = 0; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
      for (double y = 0; y < size.height; y += 40) canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
      return;
    }

    final fill = Paint()..color = const Color(0xFF10B981).withValues(alpha: 0.025)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.05), 130, fill);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.5), 100, fill);

    final grid = Paint()..color = const Color(0xFF10B981).withValues(alpha: 0.012)..strokeWidth = 0.5..style = PaintingStyle.stroke;
    for (double x = 0; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    for (double y = 0; y < size.height; y += 40) canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);

    final star = Paint()..color = const Color(0xFF1E3A52)..style = PaintingStyle.fill;
    _drawStar(canvas, Offset(size.width * 0.85, size.height * 0.12), 18, star);
    _drawStar(canvas, Offset(size.width * 0.08, size.height * 0.3), 12, star);
  }

  void _drawStar(Canvas canvas, Offset c, double r, Paint p) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final a = i * 45 * pi / 180;
      final rad = i % 2 == 0 ? r : r * 0.45;
      i == 0 ? path.moveTo(c.dx + rad * cos(a), c.dy + rad * sin(a))
             : path.lineTo(c.dx + rad * cos(a), c.dy + rad * sin(a));
    }
    path.close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_HubBgPainter _) => false;
}
