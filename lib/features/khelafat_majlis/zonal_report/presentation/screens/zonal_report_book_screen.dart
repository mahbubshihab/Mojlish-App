import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_download_screen.dart';
import 'zonal_report_screen.dart';

/// জোনাল রিপোর্ট বই — বছর/মাস নেভিগেশন ও রিপোর্ট ডাউনলোড
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

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
  ];

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

  void _openDownloadScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportDownloadScreen(
          majlisType: MajlisType.khelafat,
          initialYear: _selectedYear,
          initialMonth: _selectedMonth,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;

        final appBarBg = isDark ? const Color(0xFF162032) : Colors.white;
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
        final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);
        final textLight = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
        final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        const accentPurple = Colors.purple;

        return Scaffold(
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
          body: AmbientBackgroundWidget(
            primaryAccent: accentPurple,
            child: SingleChildScrollView(
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

                  // Report Download Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _openDownloadScreen,
                      icon: const Icon(Icons.file_download_outlined, size: 24),
                      label: const Text(
                        'জোনাল রিপোর্ট ডাউনলোড',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusCard(Color cardBg, Color borderColor, Color textLight, Color accentPurple) {
    int count = _savedMonths.values.where((v) => v).length;
    final monthName = _monthNames[_selectedMonth - 1];

    return Container(
      decoration: BoxDecoration(
        color: cardBg.withValues(alpha: 0.9),
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
                  'জোনাল রিপোর্ট — $monthName ${_bn(_selectedYear)}',
                  style: TextStyle(color: textLight, fontSize: 14.5, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '১২ মাসের মধ্যে ${_bn(count)} মাসের জোনাল রিপোর্ট সেভ করা আছে',
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
        color: cardBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: textLight, size: 28),
            onPressed: () {
              setState(() => _selectedYear--);
              _loadSavedMonths();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(_bn(_selectedYear),
                style: TextStyle(color: textLight, fontSize: 19, fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: textLight, size: 28),
            onPressed: () {
              setState(() => _selectedYear++);
              _loadSavedMonths();
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

    return GestureDetector(
      onTap: () => _openMonth(month),
      child: Container(
        width: 62,
        height: 62,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? accentPurple.withValues(alpha: 0.15) : cardBg.withValues(alpha: 0.9),
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
                color: isSelected ? accentPurple : textLight,
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
