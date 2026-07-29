import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_download_screen.dart';
import 'baytulmal_report_screen.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস — বায়তুলমাল রিপোর্ট বই (মাসিক গ্রিড ও বুক ভিউ)
class ChatroBaytulmalReportBookScreen extends StatefulWidget {
  const ChatroBaytulmalReportBookScreen({super.key});

  @override
  State<ChatroBaytulmalReportBookScreen> createState() => _ChatroBaytulmalReportBookScreenState();
}

class _ChatroBaytulmalReportBookScreenState extends State<ChatroBaytulmalReportBookScreen> {
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
        builder: (_) => const BaytulmalReportScreen(),
      ),
    );
  }

  void _openDownloadScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportDownloadScreen(
          majlisType: MajlisType.chatro,
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
              'বায়তুলমাল রিপোর্ট বই',
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
                        backgroundColor: const Color(0xFF0284C7),
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

  Widget _buildBookSummaryCard(Color cardBg, Color borderColor, Color textLight, Color accentColor) {
    final monthName = _monthNames[_selectedMonth - 1];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.account_balance_wallet_rounded, color: accentColor, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'বায়তুলমাল রিপোর্ট — বাংলাদেশ ইসলামী ছাত্র মজলিস',
                  style: TextStyle(color: accentColor, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'নির্বাচন: $monthName, ${_bn(_selectedYear)}',
                  style: TextStyle(color: textLight, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearHeader(Color cardBg, Color borderColor, Color textLight, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: cardBg.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded, size: 28),
            onPressed: () {
              setState(() => _selectedYear--);
            },
          ),
          Row(
            children: [
              Icon(Icons.calendar_month_rounded, color: accentColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'সেশন / বছর: ${_bn(_selectedYear)}',
                style: TextStyle(color: textLight, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded, size: 28),
            onPressed: () {
              setState(() => _selectedYear++);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(Color cardBg, Color borderColor, Color textLight, Color textMuted, Color accentColor) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final monthNum = index + 1;
        final isSelected = monthNum == _selectedMonth;
        final monthName = _monthNames[index];
        final monthShort = _monthShort[index];

        return InkWell(
          onTap: () => _openMonth(monthNum),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? accentColor.withValues(alpha: 0.15)
                  : cardBg.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? accentColor : borderColor,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  monthShort.toUpperCase(),
                  style: TextStyle(
                    color: isSelected ? accentColor : textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  monthName,
                  style: TextStyle(
                    color: isSelected ? accentColor : textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTodayButton(Color accentColor) {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          _selectedYear = _now.year;
          _selectedMonth = _now.month;
        });
      },
      icon: Icon(Icons.today_rounded, color: accentColor, size: 18),
      label: Text(
        'বর্তমান মাসে ফিরে যান (${_monthNames[_now.month - 1]})',
        style: TextStyle(color: accentColor, fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}
