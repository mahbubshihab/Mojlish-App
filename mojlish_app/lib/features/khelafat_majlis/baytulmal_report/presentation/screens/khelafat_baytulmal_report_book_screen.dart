import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_download_screen.dart';
import 'baytulmal_report_screen.dart';

/// খেলাফত মজলিস — বায়তুলমাল ও আর্থিক হিসাব রিপোর্ট বই (মাস ও বছর নির্বাচন ও ডাউনলোড)
class KhelafatBaytulmalReportBookScreen extends StatefulWidget {
  const KhelafatBaytulmalReportBookScreen({super.key});

  @override
  State<KhelafatBaytulmalReportBookScreen> createState() => _KhelafatBaytulmalReportBookScreenState();
}

class _KhelafatBaytulmalReportBookScreenState extends State<KhelafatBaytulmalReportBookScreen> {
  final _now = DateTime.now();
  late int _selectedYear;
  late int _selectedMonth;

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
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  void _openMonth(int month) async {
    setState(() => _selectedMonth = month);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BaytulmalReportScreen(year: _selectedYear, month: month),
      ),
    );
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
        const amberColor = Color(0xFFD97706);

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
              'বায়তুলমাল ও আর্থিক হিসাব বই',
              style: TextStyle(color: amberColor, fontSize: 16, fontWeight: FontWeight.bold),
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
            primaryAccent: amberColor,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildBookSummaryCard(cardBg, borderColor, textLight, amberColor),
                  const SizedBox(height: 16),
                  _buildYearHeader(cardBg, borderColor, textLight, amberColor),
                  const SizedBox(height: 20),
                  _buildMonthGrid(cardBg, borderColor, textLight, textMuted, amberColor),
                  const SizedBox(height: 24),

                  // Report Download Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _openDownloadScreen,
                      icon: const Icon(Icons.file_download_outlined, size: 24),
                      label: const Text(
                        'রিপোর্ট ডাউনলোড',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: amberColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildTodayButton(amberColor),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookSummaryCard(Color cardBg, Color borderColor, Color textLight, Color amberColor) {
    final monthName = _monthNames[_selectedMonth - 1];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: amberColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.account_balance_wallet_rounded, color: amberColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'বায়তুলমাল রিপোর্ট — $monthName ${_bn(_selectedYear)}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textLight),
                ),
                const SizedBox(height: 4),
                Text(
                  'মাসিক আয়-ব্যয়, আয়ানত, সফর ও অন্যান্য আর্থিক বিবরণী',
                  style: TextStyle(fontSize: 12.5, color: textLight.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearHeader(Color cardBg, Color borderColor, Color textLight, Color amberColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left_rounded, color: textLight, size: 28),
            onPressed: () => setState(() => _selectedYear--),
          ),
          Text(
            _bn(_selectedYear),
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: textLight),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right_rounded, color: textLight, size: 28),
            onPressed: () => setState(() => _selectedYear++),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(Color cardBg, Color borderColor, Color textLight, Color textMuted, Color amberColor) {
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
                    color: isSelected ? amberColor.withValues(alpha: 0.15) : cardBg.withValues(alpha: 0.9),
                    border: Border.all(
                      color: isSelected ? amberColor : borderColor,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: amberColor.withValues(alpha: 0.3),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _monthShort[m - 1],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? amberColor : textLight,
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

  Widget _buildTodayButton(Color amberColor) {
    return Center(
      child: SizedBox(
        width: 220,
        height: 48,
        child: OutlinedButton(
          onPressed: () => _openMonth(_now.month),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: amberColor, width: 1.5),
            shape: const StadiumBorder(),
            foregroundColor: amberColor,
          ),
          child: Text(
            'আজকের রিপোর্ট',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: amberColor,
            ),
          ),
        ),
      ),
    );
  }
}
