import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/services/report_storage_service.dart';
import 'baytulmal_report_screen.dart';

/// বায়তুলমাল রিপোর্ট বই — বছর/মাস নেভিগেশন, মাস সিলেক্ট করলে monthly form খোলে
class BaytulmalReportBookScreen extends StatefulWidget {
  const BaytulmalReportBookScreen({super.key});

  @override
  State<BaytulmalReportBookScreen> createState() => _BaytulmalReportBookScreenState();
}

class _BaytulmalReportBookScreenState extends State<BaytulmalReportBookScreen> {
  final _now = DateTime.now();
  late int _selectedYear;
  late int _selectedMonth;
  Map<int, bool> _savedMonths = {};

  static const _darkBg = Color(0xFF0D1B2A);
  static const _cardBg = Color(0xFF162032);
  static const _borderColor = Color(0xFF2A3F58);
  static const _accentBlue = Color(0xFF0EA5E9);
  static const _textLight = Color(0xFFE2E8F0);
  static const _textMuted = Color(0xFF94A3B8);

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
      final entry = await ReportStorageService.getBaytulmalEntry(_selectedYear, m);
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
        builder: (_) => BaytulmalReportScreen(year: _selectedYear, month: month),
      ),
    );
    setState(() => _selectedMonth = month);
    _loadSavedMonths();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _BgPainter())),
          SafeArea(
            child: Column(
              children: [
                _buildTitleBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        _buildStatusCard(),
                        const SizedBox(height: 16),
                        _buildYearSelector(),
                        const SizedBox(height: 16),
                        _buildMonthGrid(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: _textLight, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'বায়তুলমাল রিপোর্ট বই',
            style: TextStyle(color: _accentBlue, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    int count = _savedMonths.values.where((v) => v).length;
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _accentBlue.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: _accentBlue.withValues(alpha: 0.4), width: 2),
            ),
            child: const Icon(Icons.account_balance_wallet, color: _accentBlue, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '[_selectedYear সালের শাখা বায়তুলমাল রিপোর্ট]',
                  style: TextStyle(color: _textLight.withValues(alpha: 0.8), fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  '১২ মাসের মধ্যে $count মাসের রিপোর্ট সেভ করা আছে',
                  style: const TextStyle(color: _accentBlue, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearSelector() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: _textLight),
            onPressed: () {
              setState(() => _selectedYear--);
              _loadSavedMonths();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(_bn(_selectedYear),
                style: const TextStyle(color: _textLight, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: _textLight),
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

  Widget _buildMonthGrid() {
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
          children: row.map(_buildMonthCircle).toList(),
        ),
      )).toList(),
    );
  }

  Widget _buildMonthCircle(int month) {
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
              ? _accentBlue.withValues(alpha: 0.15)
              : isFuture
                  ? const Color(0xFF0A1220)
                  : _cardBg,
          border: Border.all(
            color: isSelected
                ? _accentBlue
                : isSaved
                    ? const Color(0xFF10B981)
                    : _borderColor,
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
                    ? _accentBlue
                    : isFuture
                        ? _textMuted.withValues(alpha: 0.4)
                        : _textLight,
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
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = const Color(0xFF0EA5E9).withValues(alpha: 0.025)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.08), 120, fill);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.45), 90, fill);

    final grid = Paint()..color = const Color(0xFF0EA5E9).withValues(alpha: 0.012)..strokeWidth = 0.5..style = PaintingStyle.stroke;
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
