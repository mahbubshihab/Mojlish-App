import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';

/// কমন ইউনিফাইড রিপোর্ট বই উইজেট (Universal Standardized Report Book UI Component)
class UniversalReportBookWidget extends StatefulWidget {
  final String title;
  final String cardTitle;
  final String cardSubtitle;
  final IconData icon;
  final Color accentColor;
  final Function(int year, int month) onMonthSelected;
  final VoidCallback? onDownloadPressed;
  final VoidCallback? onTodayPressed;
  final bool showTodayButton;
  final Widget? extraContent;

  const UniversalReportBookWidget({
    super.key,
    required this.title,
    required this.cardTitle,
    required this.cardSubtitle,
    this.icon = Icons.assessment_rounded,
    this.accentColor = const Color(0xFFC084FC),
    required this.onMonthSelected,
    this.onDownloadPressed,
    this.onTodayPressed,
    this.showTodayButton = false,
    this.extraContent,
  });

  @override
  State<UniversalReportBookWidget> createState() => _UniversalReportBookWidgetState();
}

class _UniversalReportBookWidgetState extends State<UniversalReportBookWidget> {
  final DateTime _now = DateTime.now();
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

  void _openMonth(int m) {
    setState(() => _selectedMonth = m);
    widget.onMonthSelected(_selectedYear, m);
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
        final accent = widget.accentColor;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: textLight, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.title,
              style: TextStyle(color: accent, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.wb_sunny : Icons.nightlight_round,
                  color: isDark ? Colors.yellow : Colors.black87,
                ),
                onPressed: () => themeManager.toggleTheme(),
              ),
            ],
          ),
          body: AmbientBackgroundWidget(
            primaryAccent: accent,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 1. Top Header Summary Card
                  _buildBookSummaryCard(cardBg, borderColor, textLight, accent),

                  const SizedBox(height: 16),

                  // 2. Year Selector Pill (<  ২০২৬  >)
                  _buildYearHeader(cardBg, borderColor, textLight, accent),

                  const SizedBox(height: 20),

                  // 3. Staggered 5-4-3 Circular Month Grid
                  _buildMonthGrid(cardBg, borderColor, textLight, textMuted, accent),

                  const SizedBox(height: 24),

                  if (widget.extraContent != null) ...[
                    widget.extraContent!,
                    const SizedBox(height: 16),
                  ],

                  // 4. Download Report Button
                  if (widget.onDownloadPressed != null) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: widget.onDownloadPressed,
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
                  ],

                  // 5. Today's Report Outlined Button
                  if (widget.showTodayButton && widget.onTodayPressed != null)
                    _buildTodayButton(accent),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookSummaryCard(Color cardBg, Color borderColor, Color textLight, Color accent) {
    final monthName = _monthNames[_selectedMonth - 1];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.icon, color: accent, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.cardTitle} — $monthName ${_bn(_selectedYear)}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textLight),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.cardSubtitle,
                  style: TextStyle(fontSize: 12.5, color: textLight.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearHeader(Color cardBg, Color borderColor, Color textLight, Color accent) {
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

  Widget _buildMonthGrid(Color cardBg, Color borderColor, Color textLight, Color textMuted, Color accent) {
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
                    color: isSelected ? accent.withValues(alpha: 0.15) : cardBg.withValues(alpha: 0.9),
                    border: Border.all(
                      color: isSelected ? accent : borderColor,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: accent.withValues(alpha: 0.35),
                              blurRadius: 12,
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
                      color: isSelected ? accent : textLight,
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

  Widget _buildTodayButton(Color accent) {
    return Center(
      child: SizedBox(
        width: 220,
        height: 48,
        child: OutlinedButton(
          onPressed: widget.onTodayPressed ?? () => _openMonth(_now.month),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: accent, width: 1.5),
            shape: const StadiumBorder(),
            foregroundColor: accent,
          ),
          child: Text(
            'আজকের রিপোর্ট',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
        ),
      ),
    );
  }
}
