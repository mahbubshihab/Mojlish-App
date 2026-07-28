import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'branch_report_screen.dart';

/// খেলাফত মজলিস — শাখা রিপোর্ট ফরম বই (মাস ও বছর নির্বাচন)
class KhelafatBranchReportBookScreen extends StatefulWidget {
  const KhelafatBranchReportBookScreen({super.key});

  @override
  State<KhelafatBranchReportBookScreen> createState() => _KhelafatBranchReportBookScreenState();
}

class _KhelafatBranchReportBookScreenState extends State<KhelafatBranchReportBookScreen> {
  final _now = DateTime.now();
  late int _selectedYear;
  late int _selectedMonth;

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
        builder: (_) => BranchReportScreen(year: _selectedYear, month: month),
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
        const purpleColor = Color(0xFFC084FC);

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: textLight),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'শাখা রিপোর্ট বই',
              style: TextStyle(color: textLight, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildYearHeader(cardBg, borderColor, textLight, purpleColor),
                const SizedBox(height: 24),
                _buildMonthGrid(cardBg, borderColor, textLight, textMuted, purpleColor),
                const SizedBox(height: 24),
                _buildTodayButton(purpleColor),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildYearHeader(Color cardBg, Color borderColor, Color textLight, Color accentPurple) {
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
            icon: Icon(Icons.chevron_left_rounded, color: textLight),
            onPressed: () => setState(() => _selectedYear--),
          ),
          Text(
            _bn(_selectedYear),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textLight),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right_rounded, color: textLight),
            onPressed: () => setState(() => _selectedYear++),
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
      children: rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((m) {
              final isSelected = m == _selectedMonth;
              final isFuture = _selectedYear == _now.year && m > _now.month;

              return GestureDetector(
                onTap: isFuture ? null : () => _openMonth(m),
                child: Container(
                  width: 58,
                  height: 58,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? accentPurple.withValues(alpha: 0.15)
                        : isFuture
                            ? cardBg.withValues(alpha: 0.3)
                            : cardBg,
                    border: Border.all(
                      color: isSelected ? accentPurple : borderColor,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: accentPurple.withValues(alpha: 0.3),
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
                      color: isSelected
                          ? accentPurple
                          : isFuture
                              ? textMuted.withValues(alpha: 0.4)
                              : textLight,
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
    return Center(
      child: SizedBox(
        width: 220,
        height: 48,
        child: OutlinedButton(
          onPressed: () => _openMonth(_now.month),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: accentPurple, width: 1.5),
            shape: const StadiumBorder(),
            foregroundColor: accentPurple,
          ),
          child: Text(
            'আজকের রিপোর্ট',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: accentPurple,
            ),
          ),
        ),
      ),
    );
  }
}
