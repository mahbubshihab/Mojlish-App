import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/features/common/resources/ahobban_mohila/data/models/ahobban_data.dart';

/// বাংলাদেশ ইসলামী মহিলা মজলিস "আহ্বান" ম্যানিফেস্টো রিডার স্ক্রিন
class AhobbanMohilaScreen extends StatefulWidget {
  const AhobbanMohilaScreen({super.key});

  @override
  State<AhobbanMohilaScreen> createState() => _AhobbanMohilaScreenState();
}

class _AhobbanMohilaScreenState extends State<AhobbanMohilaScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _fontSize = 14.0;

  static const Color _rosePrimary = Color(0xFFE11D48); // Rose 600
  static const Color _roseLight = Color(0xFFFFF1F2); // Rose 50
  static const Color _roseDarkBg = Color(0xFF1F0B18); // Dark Rose tint

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _increaseFontSize() {
    if (_fontSize < 20.0) setState(() => _fontSize += 1.0);
  }

  void _decreaseFontSize() {
    if (_fontSize > 12.0) setState(() => _fontSize -= 1.0);
  }

  void _copyToClipboard(String text, String title) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title ক্লিপবোর্ডে কপি করা হয়েছে!'),
        backgroundColor: _rosePrimary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;
        final bgColor = isDark ? _roseDarkBg : const Color(0xFFFAF5F8);
        final cardBg = isDark ? const Color(0xFF2C1324) : Colors.white;
        final textColor = isDark ? Colors.grey.shade100 : AppTheme.textDark;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF2C1324) : Colors.white,
            elevation: 0,
            title: const Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: _rosePrimary),
                SizedBox(width: 8),
                Text(
                  'আহ্বান — মহিলা মজলিস',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.zoom_in_rounded),
                tooltip: 'ফন্ট বড় করুন',
                onPressed: _increaseFontSize,
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out_rounded),
                tooltip: 'ফন্ট ছোট করুন',
                onPressed: _decreaseFontSize,
              ),
              IconButton(
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                onPressed: () => themeManager.toggleTheme(),
              ),
              const SizedBox(width: 8),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: _rosePrimary,
              indicatorWeight: 3,
              labelColor: _rosePrimary,
              unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(text: '🌸 প্রারম্ভিক'),
                Tab(text: '⚖️ নারীদের সমস্যা'),
                Tab(text: '🧕 হিজাব ও মর্যাদা'),
                Tab(text: '🎯 ৫-দফা কর্মসূচি'),
                Tab(text: '📞 যোগাযোগ'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildIntroTab(isDark, cardBg, textColor),
              _buildProblemTab(isDark, cardBg, textColor),
              _buildDignityTab(isDark, cardBg, textColor),
              _buildProgramTab(isDark, cardBg, textColor),
              _buildContactTab(isDark, cardBg, textColor),
            ],
          ),
        );
      },
    );
  }

  // 1. Intro Tab
  Widget _buildIntroTab(bool isDark, Color cardBg, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF881337), const Color(0xFF4C0519)]
                    : [const Color(0xFFFFE4E6), const Color(0xFFFECDD3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: _rosePrimary.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.menu_book_rounded, size: 40, color: _rosePrimary),
                const SizedBox(height: 8),
                Text(
                  AhobbanData.mainTitle,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF9F1239),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AhobbanData.organizationName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFFECDD3) : const Color(0xFFBE123C),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AhobbanData.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Intro Paragraph 1
          Card(
            color: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AhobbanData.introTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _rosePrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AhobbanData.introParagraph1,
                    style: TextStyle(fontSize: _fontSize, height: 1.6, color: textColor),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Quranic Ayah Card 1
          _buildAyahCard(AhobbanData.introAyah1, isDark),

          const SizedBox(height: 14),

          // Intro Paragraph 2
          Card(
            color: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AhobbanData.introParagraph2,
                style: TextStyle(fontSize: _fontSize, height: 1.6, color: textColor),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Quranic Ayahs 2 & 3
          _buildAyahCard(AhobbanData.introAyah2, isDark),
          const SizedBox(height: 10),
          _buildAyahCard(AhobbanData.introAyah3, isDark),

          const SizedBox(height: 14),

          // Intro Paragraph 3
          Card(
            color: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AhobbanData.introParagraph3,
                style: TextStyle(fontSize: _fontSize, height: 1.6, color: textColor),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 2. Problem Tab
  Widget _buildProblemTab(bool isDark, Color cardBg, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3F1D2C) : const Color(0xFFFCE7F3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _rosePrimary.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: _rosePrimary, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AhobbanData.problemTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _rosePrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                AhobbanData.problemText,
                style: TextStyle(fontSize: _fontSize, height: 1.7, color: textColor),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 3. Dignity & Hijab Tab
  Widget _buildDignityTab(bool isDark, Color cardBg, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3F1D2C) : const Color(0xFFFCE7F3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _rosePrimary.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_user_rounded, color: _rosePrimary, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AhobbanData.dignityTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _rosePrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          ...AhobbanData.hijabAyahs.map((ayah) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildAyahCard(ayah, isDark),
              )),

          const SizedBox(height: 8),

          // Hadith Card
          Card(
            color: isDark ? const Color(0xFF2E1736) : const Color(0xFFF3E8FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.purple, width: 1.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.format_quote_rounded, color: Colors.purple, size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AhobbanData.hadithDignity,
                      style: TextStyle(fontSize: _fontSize, height: 1.6, color: isDark ? Colors.purple.shade100 : Colors.purple.shade900),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 4. Program Tab (5-Point Program)
  Widget _buildProgramTab(bool isDark, Color cardBg, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Goal Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_rosePrimary, Color(0xFFBE123C)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.flag_rounded, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      AhobbanData.goalTitle,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AhobbanData.mainGoal,
                  style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            '৫-দফা কর্মসূচি:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _rosePrimary),
          ),
          const SizedBox(height: 12),

          ...AhobbanData.programPoints.map(
            (point) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.04), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: _rosePrimary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      point.pointNo,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          point.title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? const Color(0xFFFDA4AF) : const Color(0xFF9F1239)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          point.description,
                          style: TextStyle(fontSize: _fontSize, height: 1.5, color: textColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 5. Contact & Final Appeal Tab
  Widget _buildContactTab(bool isDark, Color cardBg, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Final Appeal Box
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3F1D2C) : const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _rosePrimary),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.favorite_rounded, color: _rosePrimary, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'আন্তরিক আহ্বান',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _rosePrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  AhobbanData.finalAppeal,
                  style: TextStyle(fontSize: _fontSize, height: 1.6, color: textColor),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Contact Box
          Card(
            color: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.contact_mail_rounded, color: _rosePrimary),
                          SizedBox(width: 8),
                          Text(
                            'যোগাযোগের ঠিকানা',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, color: _rosePrimary, size: 20),
                        tooltip: 'ঠিকানা কপি করুন',
                        onPressed: () => _copyToClipboard(AhobbanData.contactInfo, 'ঠিকানা'),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Text(
                    AhobbanData.contactInfo,
                    style: TextStyle(fontSize: _fontSize, height: 1.7, color: textColor),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAyahCard(QuranAyah ayah, bool isDark) {
    return Card(
      color: isDark ? const Color(0xFF1E2838) : const Color(0xFFFFFBEB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDark ? Colors.amber.shade700 : Colors.amber.shade600, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_book_rounded, color: isDark ? Colors.amber.shade300 : Colors.amber.shade900, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '${ayah.surahName} (${ayah.surahAyahNo})',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isDark ? Colors.amber.shade300 : Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.copy_rounded, size: 18, color: isDark ? Colors.amber.shade300 : Colors.amber.shade900),
                  onPressed: () => _copyToClipboard('"${ayah.textBengali}" — (${ayah.surahName}: ${ayah.surahAyahNo})', 'আয়াত'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '“${ayah.textBengali}”',
              style: TextStyle(
                fontSize: _fontSize,
                height: 1.6,
                fontStyle: FontStyle.italic,
                color: isDark ? Colors.grey.shade100 : const Color(0xFF78350F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
