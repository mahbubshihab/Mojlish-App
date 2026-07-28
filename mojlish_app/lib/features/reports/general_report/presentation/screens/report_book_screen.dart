import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/features/reports/shared/data/services/report_storage_service.dart';
import 'package:mojlish_app/features/reports/personal_report/presentation/screens/personal_report_screen.dart';
import 'package:mojlish_app/features/reports/personal_report/presentation/screens/daily_entry_screen.dart';
import 'package:mojlish_app/features/reports/personal_report/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/reports/personal_report/data/models/daily_personal_entry.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'report_export_screen.dart';

/// ব্যক্তিগত রিপোর্ট বই — বছর/মাস নেভিগেশন ও মাসিক PDF ডাউনলোড
class ReportBookScreen extends StatefulWidget {
  final MajlisType majlisType;

  const ReportBookScreen({super.key, this.majlisType = MajlisType.khelafat});

  @override
  State<ReportBookScreen> createState() => _ReportBookScreenState();
}

class _ReportBookScreenState extends State<ReportBookScreen> {
  final _now = DateTime.now();
  late int _selectedYear;
  late int _selectedMonth;
  int _filledDays = 0;
  int _daysInMonth = 30;
  bool _isExporting = false;

  static const _monthShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
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
        builder: (_) => PersonalReportScreen(
          year: _selectedYear,
          month: month,
          majlisType: widget.majlisType,
        ),
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

  Future<void> _exportSelectedMonthPdf() async {
    setState(() => _isExporting = true);
    try {
      final monthName = _monthNames[_selectedMonth - 1];
      final config = MajlisPersonalReportConfig.getConfig(widget.majlisType);

      final allEntries = await ReportStorageService.getAllPersonalEntries();
      final monthEntries = <String, DailyPersonalEntry>{};
      for (final e in allEntries.entries) {
        try {
          final d = DateTime.parse(e.key);
          if (d.year == _selectedYear && d.month == _selectedMonth) {
            monthEntries[e.key] = e.value;
          }
        } catch (_) {}
      }

      final List<List<String>> tableData = [];
      final daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;

      for (int day = 1; day <= daysInMonth; day++) {
        final dateStr = '${_selectedYear}-${_selectedMonth.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
        final entry = monthEntries[dateStr];
        final List<String> row = [_bn(day)];

        for (final col in config.columns) {
          if (entry == null) {
            row.add('-');
          } else {
            switch (col.id) {
              case 'quran':
                row.add(entry.quranStudy.isNotEmpty ? entry.quranStudy : '${entry.quranSura} ${entry.quranAyah}'.trim());
                break;
              case 'hadith':
                row.add(entry.hadithStudy.isNotEmpty ? entry.hadithStudy : '${entry.hadithCount} ${entry.hadithTopic}'.trim());
                break;
              case 'literature':
                row.add(entry.islamicLiterature.isNotEmpty ? entry.islamicLiterature : entry.islamicLitPages);
                break;
              case 'jamaat':
                row.add(entry.jamaatPrayer);
                break;
              case 'contact':
              case 'kormi_contact':
                row.add(entry.contactCount.isNotEmpty ? entry.contactCount : entry.memberContactCount);
                break;
              case 'dawat':
                row.add(entry.dawah.isNotEmpty ? entry.dawah : entry.dawahMaterials);
                break;
              case 'time':
              case 'sanghotonik_time':
                row.add(entry.orgTime.isNotEmpty ? entry.orgTime : entry.timeService);
                break;
              case 'atmo':
                row.add(entry.selfAnalysis);
                break;
              default:
                row.add('-');
            }
          }
        }
        tableData.add(row);
      }

      final headers = ['তারিখ', ...config.columns.map((c) => c.title)];

      await PdfExportService.printOrDownloadPdf(
        title: '${config.name} — মাসিক ব্যক্তিগত রিপোর্ট',
        majlisName: config.name,
        userName: 'রিপোর্ট প্রদানকারী',
        period: '$monthName ${_bn(_selectedYear)}',
        dataFields: {
          'মাস': monthName,
          'বছর': _bn(_selectedYear),
          'মোট দিন': _bn(daysInMonth),
          'পূরণকৃত দিন': _bn(monthEntries.length),
        },
        tableHeaders: headers,
        tableData: tableData,
        comments: config.footerNotes.join(' | '),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF এক্সপোর্টে সমস্যা হয়েছে: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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

        final selectedMonthName = _monthNames[_selectedMonth - 1];

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
            title: Text(
              '${widget.majlisType.displayName} — রিপোর্ট বই',
              style: const TextStyle(color: accentGreen, fontSize: 16, fontWeight: FontWeight.bold),
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
                    _buildReportBookCard(cardBg, borderColor, textLight, accentGreen),
                    const SizedBox(height: 16),
                    _buildYearSelector(cardBg, borderColor, textLight),
                    const SizedBox(height: 16),
                    _buildMonthGrid(cardBg, borderColor, textLight, textMuted, accentGreen),
                    const SizedBox(height: 20),

                    // Selected Month PDF Download Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _isExporting ? null : _exportSelectedMonthPdf,
                        icon: _isExporting
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.picture_as_pdf_rounded, size: 22),
                        label: Text(
                          '📥 $selectedMonthName ${_bn(_selectedYear)} এর PDF রিপোর্ট ডাউনলোড করুন',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0284C7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildTodayButton(accentGreen),
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

  Widget _buildReportBookCard(Color cardBg, Color borderColor, Color textLight, Color accentGreen) {
    double pct = _daysInMonth > 0 ? _filledDays / _daysInMonth : 0.0;
    pct = pct.clamp(0.0, 1.0);

    final monthName = _monthNames[_selectedMonth - 1];

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
              color: accentGreen.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: accentGreen.withOpacity(0.4), width: 2),
            ),
            child: Icon(Icons.menu_book, color: accentGreen, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$monthName ${_bn(_selectedYear)} — রিপোর্ট অগ্রগতির হিসাব',
                  style: TextStyle(color: textLight, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(children: [
                  Text('$_filledDays/$_daysInMonth দিন',
                      style: TextStyle(color: accentGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        backgroundColor: borderColor,
                        valueColor: AlwaysStoppedAnimation(accentGreen),
                        minHeight: 6,
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
            onPressed: () { setState(() => _selectedYear--); _loadStats(); },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(_bn(_selectedYear),
                style: TextStyle(color: textLight, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: textLight),
            onPressed: () {
              if (_selectedYear < _now.year) { setState(() => _selectedYear++); _loadStats(); }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(Color cardBg, Color borderColor, Color textLight, Color textMuted, Color accentGreen) {
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
          children: row.map((m) => _buildMonthCircle(m, cardBg, borderColor, textLight, textMuted, accentGreen)).toList(),
        ),
      )).toList(),
    );
  }

  Widget _buildMonthCircle(int month, Color cardBg, Color borderColor, Color textLight, Color textMuted, Color accentGreen) {
    final isSelected = month == _selectedMonth;
    final isFuture = _selectedYear == _now.year && month > _now.month;

    return GestureDetector(
      onTap: isFuture
          ? null
          : () {
              setState(() {
                _selectedMonth = month;
              });
              _loadStats();
              _openMonth(month);
            },
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? accentGreen.withOpacity(0.15)
              : isFuture
                  ? cardBg.withOpacity(0.2)
                  : cardBg,
          border: Border.all(
            color: isSelected ? accentGreen : borderColor,
            width: isSelected ? 2.5 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          _monthShort[month - 1],
          style: TextStyle(
            color: isSelected
                ? accentGreen
                : isFuture
                    ? textMuted.withOpacity(0.4)
                    : textLight,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTodayButton(Color accentGreen) {
    final isTodayFuture = _selectedYear > _now.year || (_selectedYear == _now.year && _selectedMonth > _now.month);
    if (isTodayFuture) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _openToday,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('আজকের রিপোর্ট আপডেট করুন',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
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
      final grid = Paint()..color = Colors.grey.withOpacity(0.05)..strokeWidth = 0.5..style = PaintingStyle.stroke;
      for (double x = 0; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
      for (double y = 0; y < size.height; y += 40) canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
      return;
    }

    final fill = Paint()..color = const Color(0xFF10B981).withOpacity(0.03)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.08), 120, fill);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.45), 90, fill);

    final grid = Paint()..color = const Color(0xFF10B981).withOpacity(0.012)..strokeWidth = 0.5..style = PaintingStyle.stroke;
    for (double x = 0; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    for (double y = 0; y < size.height; y += 40) canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
  }

  @override
  bool shouldRepaint(_BgPainter _) => false;
}
