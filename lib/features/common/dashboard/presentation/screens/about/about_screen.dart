import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import '../join/join_organization_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;

        // Dynamic theme colors
        final bg = isDark ? AppTheme.darkBg : const Color(0xFFF8FAFC);
        final appBarBg = isDark ? AppTheme.darkCardBg : Colors.white;
        final cardBg = isDark ? AppTheme.darkCardBg : Colors.white;
        final borderColor = isDark ? AppTheme.darkBorder : const Color(0xFFE2E8F0);
        final textLight = isDark ? AppTheme.darkTextLight : const Color(0xFF0F172A);
        final textMuted = isDark ? AppTheme.darkTextMuted : const Color(0xFF64748B);
        final primary = AppTheme.primaryColor;

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: bg,
            appBar: AppBar(
              backgroundColor: appBarBg,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: textLight, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'পরিচিতি',
                style: TextStyle(color: textLight, fontSize: 18, fontWeight: FontWeight.bold),
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
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: primary,
                indicatorWeight: 3.0,
                labelColor: primary,
                unselectedLabelColor: textMuted,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                tabs: const [
                  Tab(text: 'পরিচিতি ও পটভূমি'),
                  Tab(text: 'আদর্শ ও নীতিমালা'),
                  Tab(text: 'কর্মসূচি'),
                  Tab(text: 'সাংগঠনিক স্তর ও কাঠামো'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildIntroTab(cardBg, borderColor, textLight, textMuted, primary),
                _buildIdeologyTab(cardBg, borderColor, textLight, textMuted, primary),
                _buildProgramTab(cardBg, borderColor, textLight, textMuted, primary),
                _buildStructureTab(cardBg, borderColor, textLight, textMuted, primary),
              ],
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: appBarBg,
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const JoinOrganizationScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 2,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.group_add, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'সংগঠনে যুক্ত হোন',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // ট্যাব ১: পরিচিতি ও পটভূমি
  // ==========================================
  Widget _buildIntroTab(Color cardBg, Color borderColor, Color textLight, Color textMuted, Color primary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset('assets/images/logo.png', height: 90, errorBuilder: (_, __, ___) => Icon(Icons.group, size: 80, color: primary)),
                const SizedBox(height: 12),
                Text(
                  'ইসলামী যুব মজলিস',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primary),
                ),
                Text(
                  'ইসলামী আদর্শের আলোকে যুবসমাজ গঠনের আন্দোলন',
                  style: TextStyle(fontSize: 12, color: textMuted),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _cardSection(
            title: 'ভূমিকা',
            content: 'আল্লাহ রাব্বুল আলামীনের শুকরিয়া আদায় করছি যিনি আমাদের যৌবনের দৌলত দান করেছেন। আমরা জীবনের শ্রেষ্ঠ সময় যৌবন পার করছি। যৌবনের উপযুক্ত মূল্যায়ন করা প্রয়োজন। ইসলামী আদর্শে বিশ্বাসী মানুষের জনপদ বাংলাদেশ। দেশের মোট জনসংখ্যার প্রায় এক-তৃতীয়াংশ জনগোষ্ঠী যুবসমাজ। ব্যক্তি, পরিবার, সমাজ, রাষ্ট্র ও জাতিগঠনে যুবসমাজের ভূমিকা অপরিসীম। যুবসমাজের মেধা, শ্রম, সাহসীকতা, দক্ষতা, নৈতিক ও চারিত্রিক দৃঢ়তা, সৃজনশীল মনন ও প্রতিভাকে কেন্দ্র করে আকৃতি পায় একটি জাতির সামগ্রীক পরিমণ্ডল। যুবসমাজ জাতির ভবিষ্যৎ নেতৃত্ব সৃষ্টিতে একটি শক্তিশালী প্রত্যয়। এজন্য প্রয়োজন অর্থনৈতিক, সামাজিক, সাংস্কৃতিক ও রাজনৈতিক কার্যকর্মে যুবসমাজের সক্রিয় অংশগ্রহণ। এক্ষেত্রে যুবসমাজকে সুসংগঠিত করে আদর্শিক এবং দক্ষ জনশক্তিতে পরিণত করার লক্ষ্যে একটি সুশৃঙ্খল সংগঠনের আওতায় নিয়ে আসা সময়ের অপরিহার্য দাবি।',
            cardBg: cardBg,
            borderColor: borderColor,
            textLight: textLight,
            textMuted: textMuted,
            primary: primary,
          ),
          const SizedBox(height: 16),
          _cardSection(
            title: 'পরিচিতি',
            content: 'ইসলামী যুব মজলিস ইসলামী আদর্শের পূর্ণ অনুশীলনের মাধ্যমে এমন একটি সমাজ গড়তে চায়; যেখানে থাকবে না কোন অন্যায়, জুলুম, হানাহানি ও হিংসা-বিদ্বেষ। যুবসমাজ আজ এক কঠিন সময় অতিক্রম করছে। যুবসমাজের দায়িত্বানুভূতি জাগ্রত করতে তাদেরকে একটি অনন্য উৎকর্ষতায় নিয়ে আসতে হবে। ইসলামের প্রকৃত সৌন্দর্য যুবসমাজের সামনে উদ্ভাসিত হলে দুর্দমনীয় ও অদম্য যুবশক্তি ইসলামি পুনর্জাগরণের ক্ষেত্রে নবকল্লোল সৃষ্টি করবে।',
            cardBg: cardBg,
            borderColor: borderColor,
            textLight: textLight,
            textMuted: textMuted,
            primary: primary,
          ),
          const SizedBox(height: 16),
          _cardSection(
            title: 'পটভূমি',
            content: 'মনে রাখতে হবে যুবসমাজই একটি জাতির আশা-ভরসার কেন্দ্রস্থল। জাতীয় জীবনে যে কোনো গুরুত্বপূর্ণ মুহূর্তে যুবসমাজ অগ্রণী ও সাহসী ভূমিকা পালন করে। তাদের মনোবল ও সুপ্তপ্রতিভাকে শক্তিতে বিকশিত করে একটি কল্যাণমুখী সমাজ ও রাষ্ট্র কাঠামো তৈরি করা অপরিহার্য। সমাজ ও রাষ্ট্রের উন্নতি সাধনে যুবসমাজই মূলশক্তি। তারাই পারে একটি দেশের বৈপ্লবিক পরিবর্তন সাধন করতে।\n\nকিন্তু নৈতিকতার মানদণ্ডে আমাদের যুবসমাজ আজ প্রশ্নবিদ্ধ। বিভিন্ন অনৈতিক উপকরণের প্রভাবে তারা তাদের নৈতিক দায়িত্ববোধ হারিয়ে ফেলছে। এভাবে চলতে থাকলে একটি জাতির অর্জন অচিরেই বিলীন হয়ে নিজেদের অস্তিত্ব সংকটে পড়বে। তাই দেশের তাবৎ অচল আয়তন ভেঙে সামগ্রীক পরিবর্তন আনতে যুবসমাজের এগিয়ে আসার বিকল্প নেই। ন্যায় ও ইনসাফভিত্তিক ভারসাম্যপূর্ণ একটি জাতি গঠনে যুবসম্প্রদায়ের সম্পৃক্ততা একান্ত প্রয়োজন। এ লক্ষ্যে ২০২৩ সালের ১০ মার্চ জাতীয় মসজিদ বায়তুল মোকাররম চত্বর হতে ইসলামী যুব মজলিস আত্মপ্রকাশ করে।',
            cardBg: cardBg,
            borderColor: borderColor,
            textLight: textLight,
            textMuted: textMuted,
            primary: primary,
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_book, color: primary, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      'সংগঠক হতে যা পড়তে হবে',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textLight),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _bulletItem('১', 'ইসলামী যুব মজলিসের ঘোষণাপত্র', textLight, textMuted, primary),
                _bulletItem('২', 'গঠনতন্ত্র', textLight, textMuted, primary),
                _bulletItem('৩', 'কর্মপদ্ধতি', textLight, textMuted, primary),
                _bulletItem('৪', 'সিলেবাস', textLight, textMuted, primary),
                _bulletItem('৫', 'যুববার্তা', textLight, textMuted, primary),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==========================================
  // ট্যাব ২: আদর্শ ও নীতিমালা
  // ==========================================
  Widget _buildIdeologyTab(Color cardBg, Color borderColor, Color textLight, Color textMuted, Color primary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardSection(
            title: 'লক্ষ্য ও উদ্দেশ্য',
            content: 'আল্লাহ তা\'আলার সন্তুষ্টি অর্জনের লক্ষ্যে যুবকদের আত্মিক মানোন্নয়ন, মেধার বিকাশ ও দক্ষতা বৃদ্ধি এবং রাজনৈতিক সচেতনতা সৃষ্টির মাধ্যমে যুবসমাজকে ঐক্যবদ্ধ করে কল্যাণমুখী সমাজব্যবস্থা গড়ে তোলা।',
            cardBg: cardBg,
            borderColor: borderColor,
            textLight: textLight,
            textMuted: textMuted,
            primary: primary,
            icon: Icons.track_changes,
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.rule_folder, color: primary, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      'নীতিমালা',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textLight),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _bulletItem('১', 'যুবকদের শান্তি, ন্যায়বিচার, স্বাধীনতা, পারস্পরিক শ্রদ্ধাবোধ ও বোঝাপড়া ইত্যাদি চেতনা অর্জিত হবে যাতে করে সমাজে শান্তি, নিরাপত্তা ও স্থিতি আসে এবং আন্তর্জাতিক পর্যায়েও তার প্রভাব পড়ে। উচ্চতর নৈতিকতা ও সততায় সমৃদ্ধ হবে প্রতিটি যুবক। আল্লাহর নিকট সকল কাজে তারা দায়বদ্ধ থাকবে। সাংগঠনিক পদ্ধতিতেও জবাবদিহিতা নিশ্চিত করতে হবে।', textLight, textMuted, primary),
                _bulletItem('২', 'শিক্ষা, বক্তব্য, মোティブেশন, ভ্রমণ, কর্ম, সভা ও ভাব বিনিময়ে সর্বত্র যুবকদের অর্জিত চেতনার প্রতিফলন ঘটবে।', textLight, textMuted, primary),
                _bulletItem('৩', 'যাবতীয় সমস্যা সমাধানে সার্বিক জীবনবোধ প্রয়োজন। ইসলাম একটি সার্বজনীন ও সার্বিক জীবনবোধ দিয়েছে যার কোনো বিকল্প নেই। তাই জীবনের সর্বক্ষেত্রে আল্লাহর বিধান ও রাসূল (সা.) এর সুন্নাহর প্রয়োগ করতে হবে।', textLight, textMuted, primary),
                _bulletItem('৪', 'জাতীয় পলিসি নির্ধারণে যুবকদের অংশগ্রহণ প্রয়োজন।', textLight, textMuted, primary),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==========================================
  // ট্যাব ৩: কর্মসূচি
  // ==========================================
  Widget _buildProgramTab(Color cardBg, Color borderColor, Color textLight, Color textMuted, Color primary) {
    final list = [
      _ProgItem(
        '১. যুব সমাজের ঐক্য',
        'যুবকদের মাঝে ব্যাপকভাবে ইসলামের দাওয়াত পৌঁছে দেয়া এবং তাদেরকে সংগঠিত করে কল্যাণমুখী সমাজব্যবস্থা প্রতিষ্ঠায় চিন্তা ও চেতনার ঐক্য গড়ে তোলা।',
        Icons.group,
      ),
      _ProgItem(
        '২. প্রশিক্ষণ ও উন্নয়ন',
        'প্রতিবন্ধকতা ও অনৈতিকতা কাটিয়ে যুবকদের নৈতিক ও মানবিক জীবন গঠন, কর্ম ও কর্মসংস্থানমুখী প্রশিক্ষণ এবং টেকসই উন্নয়নে পরামর্শ প্রদান। সমাজের সর্বস্তরের যুবকদের দায়িত্বশীল নাগরিক ও মানবসম্পদে পরিণত করা।',
        Icons.psychology,
      ),
      _ProgItem(
        '৩. আদর্শিক দক্ষ নেতৃত্ব',
        'আদর্শবান দক্ষ নেতৃত্ব সৃষ্টির লক্ষ্যে সর্বাত্মক প্রচেষ্টা চালানো। শোষিত-বঞ্চিত জনগোষ্ঠী ও যুবসমাজের সকল প্রকার ন্যায্য অধিকার আদায়ের লক্ষ্যে কার্যকর পদক্ষেপ গ্রহণ এবং স্থানীয় সরকার ব্যবস্থাপনায় সৎ ও যোগ্য নেতৃত্ব নিশ্চিত করা।',
        Icons.leaderboard,
      ),
      _ProgItem(
        '৪. সামাজিক মূল্যবোধ প্রতিষ্ঠা ও দুর্নীতি প্রতিরোধ',
        'সর্বস্তরে সামাজিক ও ইসলামী মূল্যবোধ প্রতিষ্ঠা করা। পারিবারিক জীবন, পরিবার ব্যবস্থাপনা এবং সামাজিক সমস্যাদি নিয়ে কাজ করা, মাদক, জুয়াসহ যাবতীয় নেশাজাত দ্রব্য এবং সকল প্রকার দুর্নীতির বিরুদ্ধে যুবসমাজকে সচেতন করা ও সামাজিক আন্দোলন গড়ে তোলা।',
        Icons.gavel,
      ),
      _ProgItem(
        '৫. কল্যাণ রাষ্ট্র প্রতিষ্ঠায় সহযোগিতা',
        'বাংলাদেশের স্বাধীনতা-সার্বভৌমত্ব সুরক্ষার জন্য দেশের যুবসমাজকে ঐক্যবদ্ধ করার মাধ্যমে একটি সুষম, ভারসাম্যপূর্ণ, সমৃদ্ধ ও উৎপাদনশীল ইসলামী কল্যাণ রাষ্ট্র প্রতিষ্ঠায় সার্বিক সহযোগিতা করা।',
        Icons.location_city,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final item = list[i];
        return Card(
          color: cardBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: borderColor),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textLight),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.desc,
                        style: TextStyle(fontSize: 14, height: 1.4, color: textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // ট্যাব ৪: সাংগঠনিক স্তর ও কাঠামো
  // ==========================================
  Widget _buildStructureTab(Color cardBg, Color borderColor, Color textLight, Color textMuted, Color primary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // সাংগঠনিক স্তর
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.layers, color: primary, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      'সংগঠনের জনশক্তির দুটি স্তর',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textLight),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _manpowerLevelBlock(
                  'প্রাথমিক সদস্য',
                  'যে সকল যুবক ইসলামী যুব মজলিসের লক্ষ্য উদ্দেশ্য, নীতিমালা ও কর্মসূচির সাথে একমত পোষণ করে সংগঠনের নির্ধারিত প্রাথমিক সদস্য ফরম পূরণ করবেন তারা এ সংগঠনের প্রাথমিক সদস্য হিসেবে গণ্য হবেন।',
                  primary, textLight, textMuted,
                ),
                const SizedBox(height: 16),
                _manpowerLevelBlock(
                  'সদস্য',
                  'ইসলামী যুব মজলিসের যেসব প্রাথমিক সদস্য সংগঠনের কাজে নিয়মিত অংশগ্রহণ করবেন, সভাসমূহে উপস্থিত থাকবেন, আর্থিক সহযোগিতা করবেন, সংগঠনের সিলেবাস অনুযায়ী অধ্যয়ন করবেন এবং আত্মিক মানোন্নয়নে সচেষ্ট থাকবেন তারা সংগঠনের সদস্য হবেন।',
                  primary, textLight, textMuted,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // সাংগঠনিক কাঠামো
          _cardSection(
            title: 'সাংগঠনিক কাঠামো',
            content: 'ইসলামী যুব মজলিস নিম্নলিখিত ৫টি প্রশাসনিক স্তরে বিস্তৃত সাংগঠনিক কাঠামোর মাধ্যমে পরিচালিত হয়:\n\n১. কেন্দ্রীয় সংগঠন\n২. জেলা/মহানগরী শাখা\n৩. উপজেলা/পৌরসভা/থানা শাখা\n৪. ইউনিয়ন শাখা\n৫. ওয়ার্ড শাখা',
            cardBg: cardBg,
            borderColor: borderColor,
            textLight: textLight,
            textMuted: textMuted,
            primary: primary,
            icon: Icons.account_tree,
          ),
          const SizedBox(height: 16),

          // केंद्रीय संगठन विवरणী
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.corporate_fare, color: primary, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      'কেন্দ্রীয় সংগঠন পরিচালনা',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textLight),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Text(
                  'কেন্দ্রীয় সভাপতি, কেন্দ্রীয় নির্বাহী পরিষদ, জাতীয় কাউন্সিল ও কেন্দ্রীয় উপদেষ্টা পরিষদ নিয়ে এ সংগঠনের কেন্দ্রীয় সংগঠন গঠিত হবে।',
                  style: TextStyle(fontSize: 14, color: textLight, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                _subOrgBlock(
                  'কেন্দ্রীয় নির্বাহী পরিষদ',
                  'কেন্দ্রীয় সভাপতির নেতৃত্বে কাউন্সিলরদের মধ্য থেকে সর্বোচ্চ ৩ (তিন) জন সহ-সভাপতি, ১ (এক) জন সাধারণ সম্পাদক, ২ (দুই) জন সহ-সাধারণ সম্পাদক এবং প্রয়োজনীয় সংখ্যক বিভাগীয় সম্পাদক ও সদস্য নিয়ে সর্বোচ্চ ১৯ সদস্য বিশিষ্ট কেন্দ্রীয় নির্বাহী পরিষদ গঠিত হবে। সংগঠন পরিচালনা এবং জাতীয় কাউন্সিলের সিদ্ধান্ত ও কর্মসূচি বাস্তবায়নই হবে কেন্দ্রীয় নির্বাহী পরিষদের দায়িত্ব।',
                  primary, textLight, textMuted,
                ),
                const SizedBox(height: 12),
                _subOrgBlock(
                  'জাতীয় কাউন্সিল',
                  'কেন্দ্রীয় সভাপতি পদাধিকার বলে জাতীয় কাউন্সিলে সভাপতিত্ব করবেন। সংগঠন পরিচালনার ক্ষেত্রে জাতীয় কাউন্সিল মূলনীতি নির্ধারণী ফোরাম হিসেবে পরিগণিত হবে। জাতীয় কাউন্সিলের মেয়াদকাল এ সংগঠনের সেশনের সাথে সামঞ্জস্যপূর্ণ থাকবে।',
                  primary, textLight, textMuted,
                ),
                const SizedBox(height: 12),
                _subOrgBlock(
                  'কেন্দ্রীয় উপদেষ্টা পরিষদ',
                  'কনফারেন্স বা পরামর্শ সভায় অভিজ্ঞ সমাজতাত্ত্বিক, চিন্তাবিদ ও বিশেষজ্ঞদের মধ্য থেকে প্রয়োজনীয় সংখ্যক সদস্য নিয়ে জাতীয় কাউন্সিলের সিদ্ধান্তের আলোকে সংগঠনের একটি উপদেষ্টা পরিষদ থাকবে। কেন্দ্রীয় নির্বাহী পরিষদকে পরামর্শ প্রদান করা হবে কেন্দ্রীয় উপদেষ্টা পরিষদের প্রধান কাজ। প্রতি ইংরেজি সনে উপদেষ্টা পরিষদের ন্যূনতম একটি বৈঠক অনুষ্ঠিত হবে।',
                  primary, textLight, textMuted,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==========================================
  // সহায়ক উইজেটসমূহ
  // ==========================================
  Widget _cardSection({
    required String title,
    required String content,
    required Color cardBg,
    required Color borderColor,
    required Color textLight,
    required Color textMuted,
    required Color primary,
    IconData icon = Icons.info_outline,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primary, size: 24),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textLight),
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            content,
            style: TextStyle(fontSize: 14, height: 1.5, color: textMuted),
          ),
        ],
      ),
    );
  }

  Widget _bulletItem(String num, String text, Color textLight, Color textMuted, Color primary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              num,
              style: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: textMuted, fontSize: 14, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _manpowerLevelBlock(String name, String desc, Color primary, Color textLight, Color textMuted) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primary),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: TextStyle(fontSize: 13, height: 1.45, color: textMuted),
          ),
        ],
      ),
    );
  }

  Widget _subOrgBlock(String title, String desc, Color primary, Color textLight, Color textMuted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: primary, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textLight),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
            desc,
            style: TextStyle(fontSize: 13, height: 1.45, color: textMuted),
          ),
        ),
      ],
    );
  }
}

class _ProgItem {
  final String title;
  final String desc;
  final IconData icon;

  _ProgItem(this.title, this.desc, this.icon);
}
