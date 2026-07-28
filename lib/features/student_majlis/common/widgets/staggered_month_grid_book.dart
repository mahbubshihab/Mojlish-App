import 'package:flutter/material.dart';

class StaggeredMonthGridBook extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color primaryColor;
  final Function(String monthName, String year) onMonthSelected;

  const StaggeredMonthGridBook({
    Key? key,
    required this.title,
    required this.subtitle,
    this.primaryColor = const Color(0xFF006A4E),
    required this.onMonthSelected,
  }) : super(key: key);

  @override
  State<StaggeredMonthGridBook> createState() => _StaggeredMonthGridBookState();
}

class _StaggeredMonthGridBookState extends State<StaggeredMonthGridBook> {
  String _selectedYear = '২০২৬';

  final List<Map<String, String>> _months = const [
    {'bn': 'জানুয়ারি', 'en': 'Jan', 'num': '১'},
    {'bn': 'ফেব্রুয়ারি', 'en': 'Feb', 'num': '২'},
    {'bn': 'মার্চ', 'en': 'Mar', 'num': '৩'},
    {'bn': 'এপ্রিল', 'en': 'Apr', 'num': '৪'},
    {'bn': 'মে', 'en': 'May', 'num': '৫'},
    {'bn': 'জুন', 'en': 'Jun', 'num': '৬'},
    {'bn': 'জুলাই', 'en': 'Jul', 'num': '৭'},
    {'bn': 'আগস্ট', 'en': 'Aug', 'num': '৮'},
    {'bn': 'সেপ্টেম্বর', 'en': 'Sep', 'num': '৯'},
    {'bn': 'অক্টোবর', 'en': 'Oct', 'num': '১০'},
    {'bn': 'নভেম্বর', 'en': 'Nov', 'num': '১১'},
    {'bn': 'ডিসেম্বর', 'en': 'Dec', 'num': '১২'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subtextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: widget.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            // 1. Header Book Banner
            _buildBookHeaderCard(cardBg, textColor, subtextColor, isDark),

            const SizedBox(height: 24),

            // 2. Year Selector Row
            _buildYearSelectorRow(cardBg, textColor, isDark),

            const SizedBox(height: 28),

            // 3. Section Title
            Row(
              children: [
                Icon(Icons.calendar_month_rounded, color: widget.primaryColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  'মাস নির্বাচন করুন (Select Month)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 4. Staggered 5-4-3 Circular Month Grid
            _build543StaggeredGrid(context, isDark),

            const SizedBox(height: 32),

            // 5. Book Footer Info Badge
            _buildFooterBadge(isDark, subtextColor),
          ],
        ),
      ),
    );
  }

  Widget _buildBookHeaderCard(
    Color cardBg,
    Color textColor,
    Color subtextColor,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: widget.primaryColor.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.primaryColor, widget.primaryColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: subtextColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearSelectorRow(Color cardBg, Color textColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.date_range_rounded, color: widget.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'সেশন/বছর:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          DropdownButton<String>(
            value: _selectedYear,
            underline: const SizedBox(),
            icon: Icon(Icons.arrow_drop_down_circle_outlined, color: widget.primaryColor),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: widget.primaryColor,
            ),
            items: ['২০২৬', '২০২৫', '২০২৪'].map((String year) {
              return DropdownMenuItem<String>(
                value: year,
                child: Text(year),
              );
            }).toList(),
            onChanged: (String? newYear) {
              if (newYear != null) {
                setState(() {
                  _selectedYear = newYear;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _build543StaggeredGrid(BuildContext context, bool isDark) {
    // 5-4-3 staggered circular month grid
    final row1 = _months.sublist(0, 5); // 5 items
    final row2 = _months.sublist(5, 9); // 4 items
    final row3 = _months.sublist(9, 12); // 3 items

    return Column(
      children: [
        // Row 1 (5 items)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row1.map((m) => _buildCircularMonthButton(context, m, isDark, 62.0)).toList(),
        ),
        const SizedBox(height: 20),

        // Row 2 (4 items - staggered layout with padding)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row2.map((m) => _buildCircularMonthButton(context, m, isDark, 66.0)).toList(),
          ),
        ),
        const SizedBox(height: 20),

        // Row 3 (3 items - staggered layout centered)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row3.map((m) => _buildCircularMonthButton(context, m, isDark, 70.0)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCircularMonthButton(
    BuildContext context,
    Map<String, String> month,
    bool isDark,
    double diameter,
  ) {
    final bnName = month['bn']!;
    final enName = month['en']!;
    final numStr = month['num']!;

    return InkWell(
      onTap: () {
        widget.onMonthSelected(bnName, _selectedYear);
      },
      borderRadius: BorderRadius.circular(100),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), widget.primaryColor.withOpacity(0.4)]
                    : [widget.primaryColor.withOpacity(0.08), widget.primaryColor.withOpacity(0.2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: widget.primaryColor.withOpacity(0.6),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.primaryColor.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  numStr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
                Text(
                  enName,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: diameter + 12,
            child: Text(
              bnName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterBadge(bool isDark, Color subtextColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: widget.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, color: widget.primaryColor, size: 16),
          const SizedBox(width: 6),
          Text(
            'বাংলাদেশ ইসলামী ছাত্র মজলিস — রিপোর্ট বুক',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: widget.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
