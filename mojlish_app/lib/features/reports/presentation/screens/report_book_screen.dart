import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/services/report_storage_service.dart';
import 'personal_report_screen.dart';
import 'daily_entry_screen.dart';
import 'report_export_screen.dart';

/// রিপোর্ট বই — বছর/মাস নেভিগেশন, মাস সিলেক্ট করলে monthly table খোলে
class ReportBookScreen extends StatefulWidget {
  const ReportBookScreen({super.key});

  @override
  State<ReportBookScreen> createState() => _ReportBookScreenState();
}

class _ReportBookScreenState extends State<ReportBookScreen> {
  final _now = DateTime.now();
  late int _selectedYear;
  late int _selectedMonth;
  int _filledDays = 0;
  int _daysInMonth = 30;

  static const _darkBg = Color(0xFF0D1B2A);
  static const _cardBg = Color(0xFF162032);
  static const _borderColor = Color(0xFF2A3F58);
  static const _accentGreen = Color(0xFF10B981);
  static const _accentPurple = Color(0xFF8B5CF6);
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
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final days = await ReportStorageService.getFilledDaysCount(_selectedYear, _selectedMonth);
      final dim = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
      if (mounted) {
        setState(() {
          _filledDays = days;
          _daysInMonth = dim;
        });
      }
    } catch (_) {}
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  void _openMonth(int month) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PersonalReportScreen(year: _selectedYear, month: month),
      ),
    );
    setState(() => _selectedMonth = month);
    _loadStats();
  }

  void _openToday() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DailyEntryScreen(date: _now)),
    );
    _loadStats();
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
        title: const Text(
          'রিপোর্ট বই',
          style: TextStyle(color: _accentGreen, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: _textLight),
            color: _cardBg,
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'export',
                child: Text('PDF এক্সপোর্ট', style: TextStyle(color: _textLight)),
              ),
            ],
            onSelected: (val) {
              if (val == 'export') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReportExportScreen(reportType: 'personal'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _BgPainter())),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 12),
                _buildReportBookCard(),
                const SizedBox(height: 16),
                _buildYearSelector(),
                const SizedBox(height: 16),
                _buildMonthGrid(),
                const SizedBox(height: 16),
                _buildTodayButton(),
                const SizedBox(height: 16),
                _buildBottomCards(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportBookCard() {
    final pct = _daysInMonth > 0 ? _filledDays / _daysInMonth : 0.0;
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
              color: _accentGreen.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: _accentGreen.withValues(alpha: 0.4), width: 2),
            ),
            child: const Icon(Icons.menu_book, color: _accentGreen, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '[ব্যক্তিগত তথ্য আপডেট করুন।]',
                  style: TextStyle(color: _textLight.withValues(alpha: 0.8), fontSize: 14),
                ),
                const SizedBox(height: 6),
                Row(children: [
                  Text('$_filledDays/$_daysInMonth দিন',
                      style: const TextStyle(color: _accentGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        backgroundColor: _borderColor,
                        valueColor: const AlwaysStoppedAnimation(_accentGreen),
                        minHeight: 5,
                      ),
                    ),
                  ),
                ]),
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
            onPressed: () { setState(() => _selectedYear--); _loadStats(); },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(_bn(_selectedYear),
                style: const TextStyle(color: _textLight, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: _textLight),
            onPressed: () {
              if (_selectedYear < _now.year) { setState(() => _selectedYear++); _loadStats(); }
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
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map(_buildMonthCircle).toList(),
        ),
      )).toList(),
    );
  }

  Widget _buildMonthCircle(int month) {
    final isSelected = month == _selectedMonth;
    final isFuture = _selectedYear == _now.year && month > _now.month;
    return GestureDetector(
      onTap: isFuture ? null : () {
        setState(() => _selectedMonth = month);
        _openMonth(month);
      },
      child: Container(
        width: 64,
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? _accentPurple.withValues(alpha: 0.15) : isFuture ? const Color(0xFF0A1220) : _cardBg,
          border: Border.all(
            color: isSelected ? _accentPurple : _borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          _monthShort[month - 1],
          style: TextStyle(
            color: isSelected ? _accentPurple : isFuture ? _textMuted.withValues(alpha: 0.4) : _textLight,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTodayButton() {
    return GestureDetector(
      onTap: _openToday,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: _accentPurple, width: 1.5),
          color: _accentPurple.withValues(alpha: 0.08),
        ),
        child: const Text(
          'আজকের রিপোর্ট',
          style: TextStyle(color: _accentPurple, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildBottomCards() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Row(children: [
        Expanded(child: _navCard(Icons.chevron_left, 'মাসিক গড়', left: true)),
        Container(width: 1, height: 48, color: _borderColor),
        Expanded(child: _navCard(Icons.chevron_right, 'মাসিক পরিকল্পনা', left: false)),
      ]),
    );
  }

  Widget _navCard(IconData icon, String label, {required bool left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        mainAxisAlignment: left ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: left
            ? [Icon(icon, color: _textMuted, size: 18), const SizedBox(width: 6), Text(label, style: const TextStyle(color: _textLight, fontSize: 13))]
            : [Text(label, style: const TextStyle(color: _textLight, fontSize: 13)), const SizedBox(width: 6), Icon(icon, color: _textMuted, size: 18)],
      ),
    );
  }
}

class _BgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = const Color(0xFF10B981).withValues(alpha: 0.03)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.08), 120, fill);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.45), 90, fill);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.75), 150, fill);

    final grid = Paint()..color = const Color(0xFF10B981).withValues(alpha: 0.015)..strokeWidth = 0.5..style = PaintingStyle.stroke;
    for (double x = 0; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    for (double y = 0; y < size.height; y += 40) canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);

    final star = Paint()..color = const Color(0xFF2A3F58)..style = PaintingStyle.fill;
    _star(canvas, Offset(size.width * 0.85, size.height * 0.15), 20, star);
    _star(canvas, Offset(size.width * 0.1, size.height * 0.35), 14, star);
    _star(canvas, Offset(size.width * 0.75, size.height * 0.62), 16, star);
  }

  void _star(Canvas canvas, Offset c, double r, Paint p) {
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
