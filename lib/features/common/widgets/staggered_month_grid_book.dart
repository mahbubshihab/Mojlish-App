import 'package:flutter/material.dart';

class StaggeredMonthGridBook extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color primaryColor;
  final Function(String monthName, String year) onMonthSelected;
  final VoidCallback? onDownloadPressed;
  final VoidCallback? onTodayPressed;

  const StaggeredMonthGridBook({
    Key? key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.assessment_rounded,
    this.primaryColor = const Color(0xFFC084FC),
    required this.onMonthSelected,
    this.onDownloadPressed,
    this.onTodayPressed,
  }) : super(key: key);

  @override
  State<StaggeredMonthGridBook> createState() => _StaggeredMonthGridBookState();
}

class _StaggeredMonthGridBookState extends State<StaggeredMonthGridBook> {
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

  void _openMonth(int monthIndex) {
    setState(() => _selectedMonth = monthIndex);
    final monthName = _monthNames[monthIndex - 1];
    widget.onMonthSelected(monthName, _selectedYear.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF0D172A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);
    final textLight = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final accentColor = widget.primaryColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textLight, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. Top Summary Banner Card
            _buildBookSummaryCard(cardBg, borderColor, textLight, accentColor),

            const SizedBox(height: 16),

            // 2. Year Selector Pill (<  ২০২৬  >)
            _buildYearHeader(cardBg, borderColor, textLight, accentColor),

            const SizedBox(height: 20),

            // 3. Staggered 5-4-3 Circular Month Grid
            _buildMonthGrid(cardBg, borderColor, textLight, textMuted, accentColor),

            const SizedBox(height: 24),

            // 4. Download Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: widget.onDownloadPressed ?? () {},
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

            // 5. Today Button
            _buildTodayButton(accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildBookSummaryCard(Color cardBg, Color borderColor, Color textLight, Color accentColor) {
    final monthName = _monthNames[_selectedMonth - 1];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.icon, color: accentColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.title} — $monthName ${_bn(_selectedYear)}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textLight),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle,
                  style: TextStyle(fontSize: 12.5, color: textLight.withOpacity(0.7)),
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

  Widget _buildMonthGrid(Color cardBg, Color borderColor, Color textLight, Color textMuted, Color accentColor) {
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
                    color: isSelected ? accentColor.withOpacity(0.15) : cardBg,
                    border: Border.all(
                      color: isSelected ? accentColor : borderColor,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: accentColor.withOpacity(0.35),
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
                      color: isSelected ? accentColor : textLight,
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

  Widget _buildTodayButton(Color accentColor) {
    return Center(
      child: SizedBox(
        width: 220,
        height: 48,
        child: OutlinedButton(
          onPressed: widget.onTodayPressed ?? () => _openMonth(_now.month),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: accentColor, width: 1.5),
            shape: const StadiumBorder(),
            foregroundColor: accentColor,
          ),
          child: Text(
            'আজকের রিপোর্ট',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
