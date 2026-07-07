import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/services/report_storage_service.dart';
import 'report_book_screen.dart';
import 'baytulmal_report_book_screen.dart';
import 'sanghotonik_report_book_screen.dart';

/// রিপোর্টসমূহ — মূল হাব স্ক্রিন, সব রিপোর্টের কার্ড দেখায়
class ReportSelectionScreen extends StatefulWidget {
  const ReportSelectionScreen({super.key});

  @override
  State<ReportSelectionScreen> createState() => _ReportSelectionScreenState();
}

class _ReportSelectionScreenState extends State<ReportSelectionScreen> {
  int _personalFilledDays = 0;
  int _daysInMonth = 30;
  final _now = DateTime.now();

  static const _darkBg = Color(0xFF0D1B2A);
  static const _cardBg = Color(0xFF162032);
  static const _borderColor = Color(0xFF2A3F58);
  static const _accentGreen = Color(0xFF10B981);
  static const _textLight = Color(0xFFE2E8F0);
  static const _textMuted = Color(0xFF94A3B8);

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
      if (mounted) {
        setState(() {
          _personalFilledDays = days;
          _daysInMonth = dim;
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
    return Scaffold(
      backgroundColor: _darkBg,
      appBar: AppBar(
        backgroundColor: _cardBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _textLight, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'রিপোর্টসমূহ',
              style: TextStyle(color: _accentGreen, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${_monthNames[_now.month - 1]} ${_bn(_now.year)}',
              style: const TextStyle(color: _textMuted, fontSize: 11),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _HubBgPainter())),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
                // Cards list
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // ব্যক্তিগত রিপোর্ট
                      _buildReportCard(
                        title: 'ব্যক্তিগত তৎপরতার রিপোর্ট',
                        subtitle: '${_monthNames[_now.month - 1]} ${_bn(_now.year)} মাস',
                        badge: '$_personalFilledDays/$_daysInMonth দিন আপডেট',
                        badgeColor: _personalFilledDays >= _now.day ? const Color(0xFF059669) : const Color(0xFFF59E0B),
                        icon: Icons.person_outline,
                        color: const Color(0xFF10B981),
                        onTap: () async {
                          await Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const ReportBookScreen()));
                          _loadStats();
                        },
                      ),
                      const SizedBox(height: 12),

                      // বায়তুলমাল রিপোর্ট
                      _buildReportCard(
                        title: 'শাখা বায়তুলমাল রিপোর্ট',
                        subtitle: 'মাসিক আয়-ব্যয় রিপোর্ট',
                        badge: 'মাসিক',
                        badgeColor: const Color(0xFF0EA5E9),
                        icon: Icons.account_balance_wallet_outlined,
                        color: const Color(0xFF0EA5E9),
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
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const SanghotonikReportBookScreen())),
                      ),
                      const SizedBox(height: 12),

                      // জোনাল রিপোর্ট
                      _buildReportCard(
                        title: 'জোনাল রিপোর্ট',
                        subtitle: 'জোনাল পর্যায়ের রিপোর্ট',
                        badge: 'শীঘ্রই আসছে',
                        badgeColor: const Color(0xFF6B7280),
                        icon: Icons.map_outlined,
                        color: Colors.purple,
                        disabled: true,
                        onTap: () => _showComingSoon('জোনাল রিপোর্ট'),
                      ),
                      const SizedBox(height: 24),

                      // Info notice
                      _buildInfoNotice(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showComingSoon(String name) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$name শীঘ্রই যুক্ত হবে'),
      backgroundColor: _cardBg,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Widget _buildReportCard({
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool disabled = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: disabled ? _cardBg.withValues(alpha: 0.5) : _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: disabled ? _borderColor.withValues(alpha: 0.5) : _borderColor,
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
                      color: disabled ? _textMuted : _textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(color: _textMuted, fontSize: 12)),
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
              color: disabled ? _borderColor : _textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notifications_active_outlined, color: Color(0xFFF59E0B), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('প্রতিদিন রিপোর্ট আপডেট করুন',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _textLight)),
                const SizedBox(height: 3),
                Text(
                  'ব্যক্তিগত রিপোর্ট প্রতিদিন আপডেট করুন। যেদিন আপডেট করা হবে না, সেদিন "মিসিং" হিসেবে চিহ্নিত হবে।',
                  style: const TextStyle(color: _textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HubBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
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
