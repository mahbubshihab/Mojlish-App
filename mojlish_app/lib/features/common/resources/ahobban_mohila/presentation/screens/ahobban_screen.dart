import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/features/common/resources/ahobban_mohila/data/models/ahobban_data.dart';

/// বাংলাদেশ ইসলামী মহিলা মজলিস "আমাদের আহ্বান" (Call Manifesto) রিডার স্ক্রিন
class AhobbanMohilaScreen extends StatefulWidget {
  const AhobbanMohilaScreen({super.key});

  @override
  State<AhobbanMohilaScreen> createState() => _AhobbanMohilaScreenState();
}

class _AhobbanMohilaScreenState extends State<AhobbanMohilaScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _fontSize = 15.0;

  static const Color _rosePrimary = Color(0xFFE11D48); // Rose 600
  static const Color _roseDarkBg = Color(0xFF1F0B18); // Dark Rose tint
  static const Color _roseCardDark = Color(0xFF2C1324);

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
    if (_fontSize < 22.0) setState(() => _fontSize += 1.0);
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
        final cardBg = isDark ? _roseCardDark : Colors.white;
        final textColor = isDark ? Colors.grey.shade100 : AppTheme.textDark;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: isDark ? _roseCardDark : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppTheme.textDark),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: _rosePrimary, size: 22),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AhobbanData.headerBannerTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
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
              const SizedBox(width: 4),
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
                Tab(text: '⚖️ নারী ও সমাজ'),
                Tab(text: '🧕 সম্মান ও হিজাব'),
                Tab(text: '🎯 লক্ষ্য ও ৫-দফা'),
                Tab(text: '📞 আহ্বান ও যোগাযোগ'),
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

  // 1. Intro Tab (Pages 1 & 2)
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
                const Icon(Icons.campaign_rounded, size: 44, color: _rosePrimary),
                const SizedBox(height: 8),
                Text(
                  AhobbanData.mainTitle,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF9F1239),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AhobbanData.organizationName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFFECDD3) : const Color(0xFFBE123C),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AhobbanData.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade300 : Colors.grey.shade800),
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
                  const Text(
                    AhobbanData.introTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _rosePrimary),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AhobbanData.introParagraph1,
                    style: TextStyle(fontSize: _fontSize, height: 1.65, color: textColor),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Quranic Ayah 1 (Surah Nahl 12-13)
          _buildAyahCard(AhobbanData.introAyah1, isDark),

          const SizedBox(height: 14),

          // Intro Paragraph 2 & Ashraful Makhlukat
          Card(
            color: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AhobbanData.introParagraph2,
                style: TextStyle(fontSize: _fontSize, height: 1.65, color: textColor),
                textAlign: TextAlign.justify,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Quranic Ayah 2 (Surah Ar-Rum 21)
          _buildAyahCard(AhobbanData.introAyah2, isDark),

          const SizedBox(height: 14),

          // Intro Paragraph 3 (Creation Purpose & Islam)
          Card(
            color: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AhobbanData.introParagraph3,
                style: TextStyle(fontSize: _fontSize, height: 1.65, color: textColor),
                textAlign: TextAlign.justify,
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 2. Problem & Society Tab (Pages 3 & 4)
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
              border: Border.all(color: _rosePrimary.withOpacity(0.4)),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: _rosePrimary, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AhobbanData.problemTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: _rosePrimary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Pre-Islamic Women Status
          _buildSectionCard(
            title: '১. অনৈসলামিক সমাজে নারীর অতীত অবস্থান',
            icon: Icons.history_edu_rounded,
            content: AhobbanData.preIslamicStatusText,
            cardBg: cardBg,
            textColor: textColor,
          ),

          const SizedBox(height: 14),

          // Insecurity
          _buildSectionCard(
            title: '২. বর্তমানের প্রধান সংকট: নিরাপত্তাহীনতা',
            icon: Icons.security_rounded,
            content: AhobbanData.insecurityText,
            cardBg: cardBg,
            textColor: textColor,
          ),

          const SizedBox(height: 14),

          // Disrespect & Dowry
          _buildSectionCard(
            title: '৩. সম্মানের অভাব, যৌতুক প্রথা ও অধিকার বঞ্চনা',
            icon: Icons.heart_broken_rounded,
            content: AhobbanData.disrespectText,
            cardBg: cardBg,
            textColor: textColor,
          ),

          const SizedBox(height: 14),

          // Degradation & Family Collapse
          _buildSectionCard(
            title: '৪. পণ্য হিসেবে প্রদর্শন ও পারিবারিক সম্পর্কের ধস',
            icon: Icons.family_restroom_rounded,
            content: AhobbanData.degradationText,
            cardBg: cardBg,
            textColor: textColor,
          ),

          const SizedBox(height: 14),

          // Systemic Crisis & Riba
          _buildSectionCard(
            title: '৫. সামগ্রিক সামাজিক অবক্ষয়, সুদ-ঘুষ ও একমাত্র সমাধান',
            icon: Icons.gavel_rounded,
            content: AhobbanData.systemicCrisisText,
            cardBg: cardBg,
            textColor: textColor,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 3. Dignity & Hijab Tab (Pages 5, 6 & Cover Back)
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
              border: Border.all(color: _rosePrimary.withOpacity(0.4)),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_user_rounded, color: _rosePrimary, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AhobbanData.dignityTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: _rosePrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Philosophy Card
          Card(
            color: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AhobbanData.islamPhilosophyText,
                style: TextStyle(fontSize: _fontSize, height: 1.65, color: textColor),
                textAlign: TextAlign.justify,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Dignity Ayahs
          const Text(
            'আল-কুরআনের বাণী (নারীর সম্মান ও ভূমিকা):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _rosePrimary),
          ),
          const SizedBox(height: 10),
          ...AhobbanData.dignityAyahs.map((ayah) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildAyahCard(ayah, isDark),
              )),

          const SizedBox(height: 10),

          // Hijab Header Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF581C87), const Color(0xFF3B0764)]
                    : [const Color(0xFFF3E8FF), const Color(0xFFE9D5FF)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purple.shade400),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_rounded, color: Colors.purple, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AhobbanData.hijabSectionTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: isDark ? Colors.purple.shade100 : Colors.purple.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          ...AhobbanData.hijabAyahs.map((ayah) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildAyahCard(ayah, isDark),
              )),

          const SizedBox(height: 10),

          // Hadith Card
          Card(
            color: isDark ? const Color(0xFF2E1736) : const Color(0xFFF5F3FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.purple, width: 1.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.format_quote_rounded, color: Colors.purple, size: 32),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AhobbanData.hadithDignity,
                      style: TextStyle(
                        fontSize: _fontSize,
                        height: 1.6,
                        color: isDark ? Colors.purple.shade100 : Colors.purple.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Financial Rights Card
          _buildSectionCard(
            title: 'নারীর অর্থনৈতিক অধিকার ও দেনমোহর',
            icon: Icons.account_balance_wallet_rounded,
            content: AhobbanData.financialRightsText,
            cardBg: cardBg,
            textColor: textColor,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 4. Program & Aims Tab (Page 7)
  Widget _buildProgramTab(bool isDark, Color cardBg, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // History Card
          _buildSectionCard(
            title: AhobbanData.organizationHistoryTitle,
            icon: Icons.flag_rounded,
            content: AhobbanData.organizationHistoryText,
            cardBg: cardBg,
            textColor: textColor,
          ),

          const SizedBox(height: 16),

          // Main Goal Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_rosePrimary, Color(0xFFBE123C)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: _rosePrimary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.track_changes_rounded, color: Colors.white, size: 26),
                    SizedBox(width: 8),
                    Text(
                      AhobbanData.goalTitle,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  AhobbanData.mainGoal,
                  style: const TextStyle(fontSize: 15, height: 1.55, color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            '৫-দফা কর্মসূচি:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: _rosePrimary),
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
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: _rosePrimary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      point.pointNo,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          point.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? const Color(0xFFFDA4AF) : const Color(0xFF9F1239),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          point.description,
                          style: TextStyle(fontSize: _fontSize, height: 1.55, color: textColor),
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

  // 5. Contact & Call Tab (Page 7)
  Widget _buildContactTab(bool isDark, Color cardBg, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Final Appeal Box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3F1D2C) : const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _rosePrimary, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.favorite_rounded, color: _rosePrimary, size: 26),
                    SizedBox(width: 8),
                    Text(
                      AhobbanData.appealTitle,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _rosePrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  AhobbanData.finalAppeal,
                  style: TextStyle(fontSize: _fontSize, height: 1.65, color: textColor),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Contact Information Card
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
                            AhobbanData.contactTitle,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, color: _rosePrimary, size: 20),
                        tooltip: 'ঠিকানা কপি করুন',
                        onPressed: () => _copyToClipboard(AhobbanData.contactInfoCombined, 'যোগাযোগের ঠিকানা'),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  _buildContactRow(Icons.business_rounded, AhobbanData.organizationName, isBold: true),
                  const SizedBox(height: 8),
                  _buildContactRow(Icons.location_on_rounded, AhobbanData.contactOffice),
                  const SizedBox(height: 8),
                  _buildContactRow(Icons.phone_rounded, 'মোবাইল: ${AhobbanData.contactPhone}'),
                  const SizedBox(height: 8),
                  _buildContactRow(Icons.email_rounded, 'E-mail: ${AhobbanData.contactEmail}'),
                  const Divider(height: 20),
                  Text(
                    AhobbanData.publicationInfo,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
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

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required String content,
    required Color cardBg,
    required Color textColor,
  }) {
    return Card(
      color: cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: _rosePrimary, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _rosePrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(fontSize: _fontSize, height: 1.65, color: textColor),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text, {bool isBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: _rosePrimary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
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
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
