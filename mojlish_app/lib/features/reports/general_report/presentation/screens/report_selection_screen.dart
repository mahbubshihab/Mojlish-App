import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/services/user_storage_service.dart';
import 'package:mojlish_app/features/reports/shared/data/services/report_storage_service.dart';
import 'package:mojlish_app/features/reports/personal_report/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/reports/personal_report/presentation/screens/chatro_plan_screen.dart';
import 'report_book_screen.dart';
import 'package:mojlish_app/features/reports/baytulmal_report/presentation/screens/baytulmal_report_book_screen.dart';
import 'package:mojlish_app/features/reports/sanghotonik_report/presentation/screens/sanghotonik_report_book_screen.dart';
import 'package:mojlish_app/features/reports/zonal_report/presentation/screens/zonal_report_book_screen.dart';

/// রিপোর্টসমূহ — মূল হাব স্ক্রিন, সব রিপোর্টের কার্ড দেখায়
class ReportSelectionScreen extends StatefulWidget {
  const ReportSelectionScreen({super.key});

  @override
  State<ReportSelectionScreen> createState() => _ReportSelectionScreenState();
}

class _ReportSelectionScreenState extends State<ReportSelectionScreen> {
  int _personalFilledDays = 0;
  int _daysInMonth = 30;
  String _selectedMajlis = 'বাংলাদেশ ইসলামী ছাত্র মজলিস';
  final _now = DateTime.now();

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
  ];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final days = await ReportStorageService.getFilledDaysCount(_now.year, _now.month);
      final dim = DateTime(_now.year, _now.month + 1, 0).day;
      final majlis = await UserStorageService.getSelectedMajlis();
      if (mounted) {
        setState(() {
          _personalFilledDays = days;
          _daysInMonth = dim;
          _selectedMajlis = majlis;
        });
      }
    } catch (_) {}
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;

        // Theme colors
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
                const Text(
                  'রিপোর্টসমূহ',
                  style: TextStyle(color: accentGreen, fontSize: 18, fontWeight: FontWeight.bold),
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
                onPressed: () {
                  themeManager.toggleTheme();
                },
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
                  // Cards list
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        // ১. ব্যক্তিগত তৎপরতার রিপোর্ট
                        _buildReportCard(
                          title: 'ব্যক্তিগত তৎপরতার রিপোর্ট',
                          subtitle: '${_monthNames[_now.month - 1]} ${_bn(_now.year)} মাস',
                          badge: '$_personalFilledDays/$_daysInMonth দিন আপডেট',
                          badgeColor: _personalFilledDays >= _now.day ? const Color(0xFF059669) : const Color(0xFFF59E0B),
                          icon: Icons.person_outline,
                          color: const Color(0xFF10B981),
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textLight: textLight,
                          textMuted: textMuted,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReportBookScreen(
                                  majlisType: MajlisTypeExtension.fromString(_selectedMajlis),
                                ),
                              ),
                            );
                            _loadStats();
                          },
                        ),
                        const SizedBox(height: 12),

                        // ২. ছাত্র মজলিস স্বতন্ত্র পরিকল্পনা রিপোর্ট
                        if (_selectedMajlis.contains('ছাত্র')) ...[
                          _buildReportCard(
                            title: 'ছাত্র মজলিস মাসিক পরিকল্পনা',
                            subtitle: 'দাওয়াত, সংগঠন, প্রশিক্ষণ ও বাজেটের সমন্বিত পরিকল্পনা',
                            badge: 'পরিকল্পনা',
                            badgeColor: const Color(0xFF3B82F6),
                            icon: Icons.assignment_outlined,
                            color: const Color(0xFF3B82F6),
                            cardBg: cardBg,
                            borderColor: borderColor,
                            textLight: textLight,
                            textMuted: textMuted,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatroPlanScreen(
                                  initialYear: _now.year,
                                  initialMonth: _now.month,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // বায়তুলমাল রিপোর্ট
                        _buildReportCard(
                          title: 'শাখা বায়তুলমাল রিপোর্ট',
                          subtitle: 'মাসিক আয়-ব্যয় রিপোর্ট',
                          badge: 'মাসিক',
                          badgeColor: const Color(0xFF0EA5E9),
                          icon: Icons.account_balance_wallet_outlined,
                          color: const Color(0xFF0EA5E9),
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textLight: textLight,
                          textMuted: textMuted,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const BaytulmalReportBookScreen())),
                        ),
                        const SizedBox(height: 12),

                        // সাংগঠনিক রিপোর্ট
                        _buildReportCard(
                          title: 'শাখা সাংগঠনিক রিপোর্ট',
                          subtitle: 'মাসিক সাংগঠনিক রিপোর্ট',
                          badge: 'মাসিক',
                          badgeColor: Colors.orange,
                          icon: Icons.group_work_outlined,
                          color: Colors.orange,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textLight: textLight,
                          textMuted: textMuted,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const SanghotonikReportBookScreen())),
                        ),
                        const SizedBox(height: 12),

                        // জোনাল রিপোর্ট
                        _buildReportCard(
                          title: 'জোনাল রিপোর্ট',
                          subtitle: 'জোনাল পর্যায়ের রিপোর্ট',
                          badge: 'মাসিক',
                          badgeColor: Colors.purple,
                          icon: Icons.map_outlined,
                          color: Colors.purple,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textLight: textLight,
                          textMuted: textMuted,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const ZonalReportBookScreen())),
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
    bool disabled = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: disabled ? cardBg.withValues(alpha: 0.5) : cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: disabled ? borderColor.withValues(alpha: 0.5) : borderColor,
          ),
          boxShadow: disabled ? [] : [
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
            // Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: disabled ? 0.05 : 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withValues(alpha: disabled ? 0.1 : 0.25)),
              ),
              child: Icon(icon, color: disabled ? color.withValues(alpha: 0.4) : color, size: 26),
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: disabled ? textMuted : textLight,
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
              color: disabled ? borderColor : textMuted,
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
      // Light background grid
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
