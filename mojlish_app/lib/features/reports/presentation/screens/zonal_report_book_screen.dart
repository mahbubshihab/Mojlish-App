import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import '../../data/services/report_storage_service.dart';
import 'zonal_report_screen.dart';

/// জোনাল রিপোর্ট বই — বছর/মাস নেভিগেশন
class ZonalReportBookScreen extends StatefulWidget {
  const ZonalReportBookScreen({super.key});

  @override
  State<ZonalReportBookScreen> createState() => _ZonalReportBookScreenState();
}

class _ZonalReportBookScreenState extends State<ZonalReportBookScreen> {
  final _now = DateTime.now();
  late int _selectedYear;
  late int _selectedMonth;
  Map<int, bool> _savedMonths = {};

  static const _monthShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _selectedYear = _now.year;
    _selectedMonth = _now.month;
    _loadSavedMonths();
  }

  Future<void> _loadSavedMonths() async {
    final Map<int, bool> saved = {};
    for (int m = 1; m <= 12; m++) {
      final entry = await ReportStorageService.getZonalEntry(_selectedYear, m);
      saved[m] = entry != null;
    }
    if (mounted) {
      setState(() {
        _savedMonths = saved;
      });
    }
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  void _openMonth(int month) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ZonalReportScreen(year: _selectedYear, month: month),
      ),
    );
    setState(() => _selectedMonth = month);
    _loadSavedMonths();
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
        const accentPurple = Colors.purple;

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
            title: const Text(
              'জোনাল রিপোর্ট বই',
              style: TextStyle(color: accentPurple, fontSize: 18, fontWeight: FontWeight.bold),
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
              Positioned.fill(child: CustomPaint(painter: _BgPainter(isDark: isDark))),
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _buildStatusCard(cardBg, borderColor, textLight, accentPurple),
                    const SizedBox(height: 16),
                    _buildYearSelector(cardBg, borderColor, textLight),
                    const SizedBox(height: 16),
                    _buildMonthGrid(cardBg, borderColor, textLight, textMuted, accentPurple),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusCard(Color cardBg, Color borderColor, Color textLight, Color accentPurple) {
    int count = _savedMonths.values.where((v) => v).length;
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: accentPurple.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: accentPurple.withValues(alpha: 0.4), width: 2),
            ),
            child: Icon(Icons.map, color: accentPurple, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '[_selectedYear সালের জোনাল রিপোর্ট]',
                  style: TextStyle(color: textLight.withValues(alpha: 0.8), fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  '১২ মাসের মধ্যে $count মাসের রিপোর্ট সেভ করা আছে',
                  style: TextStyle(color: accentPurple, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearSelector(Color cardBg, Color borderColor, Color textLight) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: textLight),
            onPressed: () {
              setState(() => _selectedYear--);
              _loadSavedMonths();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(_bn(_selectedYear),
                style: TextStyle(color: textLight, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: textLight),
            onPressed: () {
              if (_selectedYear < _now.year) {
                setState(() => _selectedYear++);
                _loadSavedMonths();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(Color cardBg, Color borderColor, Color textLight, Color textMuted, Color accentPurple) {
    final rows = [
      [1, 2, 3, 4, 5],
      [6, 7, 8, 9],
      [10, 11, 12],
    ];
    return Column(
      children: rows.map((row) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((m) => _buildMonthCircle(m, cardBg, borderColor, textLight, textMuted, accentPurple)).toList(),
        ),
      )).toList(),
    );
  }

  Widget _buildMonthCircle(int month, Color cardBg, Color borderColor, Color textLight, Color textMuted, Color accentPurple) {
    final isSelected = month == _selectedMonth;
    final isSaved = _savedMonths[month] ?? false;
    final isFuture = _selectedYear == _now.year && month > _now.month;

    return GestureDetector(
      onTap: isFuture ? null : () => _openMonth(month),
      child: Container(
        width: 64,
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? accentPurple.withValues(alpha: 0.15)
              : isFuture
                  ? cardBg.withValues(alpha: 0.2)
                  : cardBg,
          border: Border.all(
            color: isSelected
                ? accentPurple
                : isSaved
                    ? const Color(0xFF10B981)
                    : borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _monthShort[month - 1],
              style: TextStyle(
                color: isSelected
                    ? accentPurple
                    : isFuture
                        ? textMuted.withValues(alpha: 0.4)
                        : textLight,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            if (isSaved) ...[
              const SizedBox(height: 2),
              const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _BgPainter extends CustomPainter {
  final bool isDark;
  _BgPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isDark) {
      final grid = Paint()..color = Colors.grey.withValues(alpha: 0.05)..strokeWidth = 0.5..style = PaintingStyle.stroke;
      for (double x = 0; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
      for (double y = 0; y < size.height; y += 40) canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
      return;
    }

    final fill = Paint()..color = Colors.purple.withValues(alpha: 0.025)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.08), 120, fill);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.45), 90, fill);

    final grid = Paint()..color = Colors.purple.withValues(alpha: 0.012)..strokeWidth = 0.5..style = PaintingStyle.stroke;
    for (double x = 0; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    for (double y = 0; y < size.height; y += 40) canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);

    final star = Paint()..color = const Color(0xFF1E3A52)..style = PaintingStyle.fill;
    _drawStar(canvas, Offset(size.width * 0.85, size.height * 0.15), 18, star);
    _drawStar(canvas, Offset(size.width * 0.1, size.height * 0.35), 14, star);
  }

  void _drawStar(Canvas canvas, Offset c, double r, Paint p) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final a = i * 45 * pi / 180;
      final rad = i % 2 == 0 ? r : r * 0.45;
      final x = c.dx + rad * cos(a);
      final y = c.dy + rad * sin(a);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_BgPainter _) => false;
}
