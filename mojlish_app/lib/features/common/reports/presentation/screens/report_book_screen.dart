import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_download_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/personal_report/presentation/screens/personal_report_screen.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/presentation/screens/personal_report_screen.dart';
import 'package:mojlish_app/features/youth_majlis/personal_report/presentation/screens/personal_report_screen.dart';
import 'package:mojlish_app/features/women_majlis/personal_report/presentation/screens/personal_report_screen.dart';


/// ব্যক্তিগত রিপোর্ট বই — বছর/মাস নেভিগেশন ও কাস্টম মাল্টি-মান্থ A4 PDF ডাউনলোড
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

  void _loadStats() async {
    final count = await ReportStorageService.getFilledDaysCount(_selectedYear, _selectedMonth);
    final days = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);
    if (mounted) {
      setState(() {
        _filledDays = count;
        _daysInMonth = days;
      });
    }
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  void _openMonth(int month) async {
    Widget page;
    switch (widget.majlisType) {
      case MajlisType.khelafat:
        page = const KhelafatPersonalReportScreen();
        break;
      case MajlisType.chatro:
        page = const StudentPersonalReportScreen();
        break;
      case MajlisType.jubo:
        page = const YouthPersonalReportScreen();
        break;
      case MajlisType.mohila:
        page = const WomenMajlisPersonalReportScreen();
        break;
      default:
        page = const KhelafatPersonalReportScreen();
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
    setState(() => _selectedMonth = month);
    _loadStats();
  }

  void _openToday() async {
    _openMonth(_now.month);
  }

  /// Opens Dedicated Multi-Month PDF Export Screen
  void _openDownloadDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportDownloadScreen(
          majlisType: widget.majlisType,
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
            title: const Text(
              'রিপোর্ট বই',
              style: TextStyle(color: accentGreen, fontSize: 16, fontWeight: FontWeight.bold),
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 12),
                _buildReportBookCard(cardBg, borderColor, textLight, accentGreen),
                const SizedBox(height: 16),
                _buildYearSelector(cardBg, borderColor, textLight),
                const SizedBox(height: 16),
                _buildMonthGrid(cardBg, borderColor, textLight, textMuted, accentGreen),
                const SizedBox(height: 24),

                // Report Download Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _openDownloadDialog,
                    icon: const Icon(Icons.file_download_outlined, size: 24),
                    label: const Text(
                      'রিপোর্ট ডাউনলোড',
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
                const SizedBox(height: 12),

                _buildTodayButton(accentGreen),
                const SizedBox(height: 24),
              ],
            ),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentGreen.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.menu_book_rounded, color: accentGreen, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$monthName ${_bn(_selectedYear)} — রিপোর্ট অগ্রগতির হিসাব',
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: textLight),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '${_bn(_filledDays)}/${_bn(_daysInMonth)} দিন',
                      style: TextStyle(fontSize: 13, color: accentGreen, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 6,
                          backgroundColor: Colors.grey.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(accentGreen),
                        ),
                      ),
                    ),
                  ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left_rounded, color: textLight, size: 28),
            onPressed: () {
              setState(() => _selectedYear--);
              _loadStats();
            },
          ),
          Text(
            _bn(_selectedYear),
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: textLight),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right_rounded, color: textLight, size: 28),
            onPressed: () {
              setState(() => _selectedYear++);
              _loadStats();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(Color cardBg, Color borderColor, Color textLight, Color textMuted, Color accentPurple) {
    const monthShorts = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final purpleColor = const Color(0xFFC084FC);

    final rows = [
      [1, 2, 3, 4, 5],
      [6, 7, 8, 9],
      [10, 11, 12],
    ];

    return Column(
      children: rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((m) {
              final isSelected = m == _selectedMonth;
              return GestureDetector(
                onTap: () => _openMonth(m),
                child: Container(
                  width: 58,
                  height: 58,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? purpleColor.withValues(alpha: 0.15) : cardBg,
                    border: Border.all(
                      color: isSelected ? purpleColor : borderColor,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: purpleColor.withValues(alpha: 0.3),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    monthShorts[m - 1],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? purpleColor : textLight,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTodayButton(Color accentPurple) {
    final purpleColor = const Color(0xFFC084FC);
    return Center(
      child: Container(
        width: 220,
        height: 48,
        child: OutlinedButton(
          onPressed: _openToday,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: purpleColor, width: 1.5),
            shape: const StadiumBorder(),
            foregroundColor: purpleColor,
          ),
          child: Text(
            'আজকের রিপোর্ট',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: purpleColor,
            ),
          ),
        ),
      ),
    );
  }
}
