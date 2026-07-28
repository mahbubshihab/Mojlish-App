import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/overview_bloc.dart';
import '../bloc/overview_event.dart';
import '../bloc/overview_state.dart';
import '../../data/datasources/overview_remote_data_source.dart';
import '../../data/repositories/overview_repository_impl.dart';

class WomenMajlisOverviewPage extends StatelessWidget {
  const WomenMajlisOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OverviewBloc(
        repository: OverviewRepositoryImpl(
          remoteDataSource: OverviewRemoteDataSourceImpl(),
        ),
      )..add(LoadOverviewEvent()),
      child: const _WomenMajlisOverviewView(),
    );
  }
}

class _WomenMajlisOverviewView extends StatelessWidget {
  const _WomenMajlisOverviewView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? const Color(0xFF10B981) : const Color(0xFF059669);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final scaffoldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textTitle = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
    final textBody = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'ইসলামী মহিলা মজলিস — পরিচিতি',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF059669),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<OverviewBloc, OverviewState>(
        builder: (context, state) {
          if (state is OverviewLoading) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          } else if (state is OverviewError) {
            return Center(
              child: Text(
                'ত্রুটি: ${state.message}',
                style: TextStyle(color: Colors.red.shade400, fontSize: 16),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner Card
                _buildHeaderBanner(context, isDark, primaryColor, cardBg, borderColor),
                const SizedBox(height: 20),

                // Section 1: Introduction & Background
                _buildSectionCard(
                  context,
                  title: 'সংক্ষিপ্ত পরিচিতি ও প্রেক্ষাপট',
                  icon: Icons.menu_book_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'বিসমিল্লাহির রাহমানির রাহিম',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'আল্লাহ রাব্বুল আলামীন হচ্ছেন এই বিশ্বজগতের সৃষ্টিকর্তা, পালনকর্তা ও বিধানদাতা। তিনি সমস্ত কিছুর নিয়ন্ত্রক ও পরিচালক। তিনি মানুষকে সৃষ্টি করেছেন ‘আশরাফুল মাখলুকাত’ বা সৃষ্টির শ্রেষ্ঠ জীব হিসেবে। পৃথিবীর সমস্ত কিছুকে তিনি মানুষের কল্যাণের জন্য সৃষ্টি করেছেন এবং মানুষকে সৃষ্টি করেছেন তাঁরই খেলাফত বা প্রতিনিধিত্বের দায়িত্ব পালনের উদ্দেশ্যে।',
                        style: TextStyle(fontSize: 15, height: 1.6, color: textBody),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'খলিফা হিসেবে আমাদের দায়িত্ব সঠিকভাবে পালন করার জন্য তিনি যুগে যুগে তাঁরই মনোনীত বান্দাদের মাধ্যমে ‘সিরাতুল মুস্তাকিম’ বা সহজসরল জীবন যাপন পদ্ধতি শিক্ষা দিয়েছেন। এরই নাম ‘আদ দ্বীন’ বা ইসলাম। সর্বশেষ আসমানী কিতাব আল কুরআনের বাস্তব রূপায়ণ ঘটেছে সর্বশ্রেষ্ঠ মানব রাসূলে করীম (সা.)- এর জীবনে। তিনি হচ্ছেন সমগ্র বিশ্বের জন্য রহমত স্বরূপ।',
                        style: TextStyle(fontSize: 15, height: 1.6, color: textBody),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'ইসলাম হচ্ছে আল্লাহর মনোনীত একমাত্র জীবন ব্যবস্থা। এতে রয়েছে মানুষের ব্যক্তি, সমাজ তথা সার্বিক জীবনের দিক নির্দেশনা। আজকের এই সমস্যাসংকুল পৃথিবীতে একমাত্র ইসলামই দিতে পারে সকল সমস্যার সমাধান।',
                        style: TextStyle(fontSize: 15, height: 1.6, color: textBody),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'ইসলামের যথাযথ অনুসরণের মাধ্যমেই আসতে পারে নারী সমাজসহ সমগ্র মানব সমাজের সার্বিক কল্যাণ, নিরাপত্তা, শান্তি, মর্যাদা এবং আখেরাতের প্রকৃত মুক্তি।',
                        style: TextStyle(fontSize: 15, height: 1.6, color: textBody),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'আজ বাংলাদেশে তথা সমগ্র বিশ্বের নারীরা বিভিন্নমুখী সমস্যায় জর্জরিত। একদিকে নারীদের ন্যায্যসংগত মানবিক অধিকার থেকে বঞ্চিত রেখে তাদের উপর চাপিয়ে দেয়া হয়েছে অহেতুক বিধি-নিষেধ ও নিয়ন্ত্রণের বেড়াজাল। অপরদিকে আধুনিক জাহেলিয়াত অধিকার ও উন্নয়নের নামে নারীদের বিপথগামী করছে। আধুনিক এই জাহেলিয়াত নারীকে স্বাধীনতার স্লোগান শুনিয়ে তার সৃষ্টিগত, প্রাকৃতিক ও মনস্তাত্ত্বিক অবস্থান ভুলিয়ে সম্পূর্ণ বস্তুতঃ অর্থে পুরুষের সমান কোথাও কোথাও পরস্পর পরস্পরের প্রতিযোগী ও বৈরীশক্তি বলে প্রতিপন্ন করছে। ফলে নারীরা পরিবার গঠন ও সংরক্ষণের শাশ্বত তাগিদ হারিয়ে ফেলছে। তারা সংসারের কাজে শ্রম বিনিয়োগকে অনুৎপাদনশীল মনে করছে এবং সন্তান ধারণ, লালন-পালন ও স্বামীর সংসারকে অসন্মানজনক মনে করছে। নারী জাতির শালীনতা, অভিজাত্য ও সম্মানের প্রতীক যে হিজাব বা পর্দা তাকে গোড়ামী ও শৃঙ্খল বলে প্রচারণা চালিয়ে, নারী স্বাধীনতার নামে বিজ্ঞাপনের মডেল, ব্যবসায়ের পণ্য ও পুরুষের বিনোদনের উপকরণ বানিয়ে তাদের সম্মান ও মর্যাদাকে ভূ-লুণ্ঠিত করা হচ্ছে। এ হচ্ছে বস্তুবাদী, ভোগবাদী, পশ্চিমা সাম্রাজ্যবাদী শক্তির সুগভীর ষড়যন্ত্র।',
                        style: TextStyle(fontSize: 15, height: 1.6, color: textBody),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'শুধু নারী সমাজ নয় বরং দেশের সামগ্রিক অর্থনৈতিক, সামাজিক, রাজনৈতিক ও সাংস্কৃতিক ক্ষেত্রে চলছে এক চরম অবক্ষয় ও দেউলিয়াপনা। অপহরণ, হত্যা, ধর্ষণ, ক্ষুধা, দারিদ্র, বেকারত্ব, সুদ, ঘুষ, দুর্নীতিসহ সামাজিক অবক্ষয়, নৈরাজ্য ও অস্থিরতা দূর করতে হলে সর্বপ্রথম নারী সমাজকে বুঝতে হবে তাদের প্রকৃত মর্যাদা কিসে এবং কিভাবে সেটা ফিরে আসতে পারে। কোনো গঠনমূলক কাজই বিশৃঙ্খলাভাবে করা সম্ভব নয়। তাই আমরা যদি প্রকৃত অর্থেই বিরাজমান সমস্যার স্থায়ী সমাধান চাই, পরিবর্তন করতে চাই নারী সমাজ তথা সমাজকে তাহলে প্রয়োজন সামগ্রিক ও সাংগঠনিক প্রচেষ্টা ও প্রয়াস। এ প্রয়োজনকে সামনে রেখে ১৯৯০ সালের ১৯ জানুয়ারি বাংলাদেশ ইসলামী মহিলা মজলিসের যাত্রা শুরু হয়।',
                        style: TextStyle(fontSize: 15, height: 1.6, color: textBody),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 2: Aims & Objectives
                _buildSectionCard(
                  context,
                  title: 'লক্ষ্য ও উদ্দেশ্য',
                  icon: Icons.flag_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      'এ সংগঠনের লক্ষ্য ও উদ্দেশ্য হচ্ছে বাংলাদেশের মহিলা সমাজকে কুরআন ও সুন্নাহর আলোকে সঠিক ইসলামী চেতনায় উদ্বুদ্ধ করে দ্বীন প্রতিষ্ঠার কাজে সক্রিয় করে তোলা, এরই মাধ্যমে মানবতার মুক্তি, পরকালীন নাজাত ও সর্বোপরি আল্লাহর সন্তোষ অর্জন।',
                      style: TextStyle(
                        fontSize: 15.5,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                        color: textTitle,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Section 3: 5-Point Program
                _buildSectionCard(
                  context,
                  title: 'পাঁচ দফা কর্মসূচী',
                  icon: Icons.format_list_bulleted_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'এ লক্ষ্য ও উদ্দেশ্য বাস্তবায়নের জন্য বাংলাদেশ ইসলামী মহিলা মজলিস পাঁচ দফা কর্মসূচী প্রণয়ন করেছে :',
                        style: TextStyle(fontSize: 14.5, height: 1.5, color: textMuted),
                      ),
                      const SizedBox(height: 14),
                      _buildProgramTile(context, 'এক', 'দাওয়াত', 'বাংলাদেশের মহিলা সমাজের নিকট ইসলামের সঠিক দাওয়াত পৌঁছানো এবং এর আলোকে ব্যক্তি ও পারিবারিক জীবনকে পুনর্গঠনে উদ্বুদ্ধ করা।', primaryColor, isDark, textTitle, textBody),
                      _buildProgramTile(context, 'দুই', 'সংগঠন', 'যে সমস্ত মহিলা এ দাওয়াতে সাড়া দেবেন তাদেরকে সুসংগঠিত করা।', primaryColor, isDark, textTitle, textBody),
                      _buildProgramTile(context, 'তিন', 'প্রশিক্ষণ', 'সুসংগঠিত মহিলাদেরকে আদর্শ মুসলিম নারী ও দ্বীন প্রতিষ্ঠার যোগ্য কর্মী হিসেবে গড়ে তোলা।', primaryColor, isDark, textTitle, textBody),
                      _buildProgramTile(context, 'চার', 'নারী সমাজের সমস্যা সমাধান', 'ইসলামী মূল্যবোধের আলোকে মহিলাদের বিভিন্নমুখী সমস্যা সমাধান ও অধিকার আদায়ে সাধ্যমত প্রচেষ্টা চালানো।', primaryColor, isDark, textTitle, textBody),
                      _buildProgramTile(context, 'পাঁচ', 'ইসলামী আন্দোলনে ভূমিকা পালন', 'ইসলামী সমাজ তথা খেলাফত প্রতিষ্ঠার সংগ্রামে সহযোগী শক্তি হিসেবে সর্বাত্মক ভূমিকা পালন।', primaryColor, isDark, textTitle, textBody),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 4: Detailed Activities
                _buildSectionCard(
                  context,
                  title: 'বিস্তারিত কার্যক্রম',
                  icon: Icons.task_alt_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSubHeader('প্রথম দফা : দাওয়াত', primaryColor),
                      _buildBulletItem('personal_contact', 'ব্যক্তিগতভাবে সম্পর্ক স্থাপন ও দাওয়াত পৌঁছানো।', textBody),
                      _buildBulletItem('group_dawah', 'সামষ্টিকভাবে দাওয়াত পৌঁছানো।', textBody),
                      _buildBulletItem('meetings', 'সাধারণ সভা, সিম্পোজিয়াম, সেমিনার।', textBody),
                      _buildBulletItem('gatherings', 'চা চক্র, বিতর্ক সভা, রচনা ও বক্তৃতা প্রতিযোগিতা এবং সাধারণ জ্ঞানের আসর।', textBody),
                      _buildBulletItem('publications', 'পোস্টারিং, পরিচিতি, লিফলেট, বই ও বিভিন্ন সময় প্রকাশিত সাময়িকী বিতরণ।', textBody),
                      const Divider(height: 28),

                      _buildSubHeader('দ্বিতীয় দফা : সংগঠন', primaryColor),
                      _buildOrgDetailTile('কেন্দ্রীয় সংগঠন :', 'কেন্দ্রীয় সভানেত্রী, কেন্দ্রীয় মজলিসে শূরা ও কেন্দ্রীয় নির্বাহী পরিষদের সমন্বয়ে গঠিত হয় কেন্দ্রীয় সংগঠন।', textTitle, textBody, primaryColor),
                      _buildOrgDetailTile('সাংগঠনিক কাঠামো :', 'কেন্দ্রীয় সংগঠন, জেলা/ মহানগরী শাখা, উপজেলা/ থানা/ পৌর শাখা, ইউনিয়ন/ ওয়ার্ড (মহানগরভুক্ত), ওয়ার্ড, গ্রাম ও স্থানীয় শাখা সমন্বয়ে এ সংগঠনের সাংগঠনিক কাঠামো গঠিত।', textTitle, textBody, primaryColor),
                      _buildOrgDetailTile('জেলা/ মহানগরী শাখা :', 'জেলা সভানেত্রী ও সাধারণ সম্পাদিকা জেলা মজলিসে শূরার সদস্যদের গোপন ভোটে নির্বাচিত হবেন। নব-নির্বাচিত জেলা সভানেত্রী ও সাধারণ সম্পাদিকা জেলা মজলিসে শূরার সদস্যদের ভোটে জেলা নির্বাহী পরিষদের সম্পাদিকামণ্ডলী ও অন্যান্য সদস্যপদে নির্বাচন সম্পন্ন করবেন।', textTitle, textBody, primaryColor),
                      _buildOrgDetailTile('উপজেলা/ থানা/ পৌরসভা, ইউনিয়ন/ ওয়ার্ড/ গ্রাম শাখা :', 'উপজেলা/ থানা/ পৌরসভা, ইউনিয়ন/ ওয়ার্ড/ গ্রাম শাখার সভানেত্রী, সাধারণ সম্পাদিকাসহ নির্বাহী পরিষদ সংশ্লিষ্ট শাখার মজলিসে শূরা কর্তৃক নির্বাচিত হবেন।', textTitle, textBody, primaryColor),
                      const Divider(height: 28),

                      _buildSubHeader('তৃতীয় দফা : প্রশিক্ষণ', primaryColor),
                      _buildBulletItem('study', 'ব্যক্তিগত অধ্যয়ন', textBody),
                      _buildBulletItem('report', 'ব্যক্তিগত রিপোর্ট সংরক্ষণ', textBody),
                      _buildBulletItem('library', 'পাঠাগার প্রতিষ্ঠা', textBody),
                      _buildBulletItem('sessions', 'তালিমী বৈঠক, সামষ্টিক পাঠ, পাঠচক্র, প্রশিক্ষণ চক্র, বক্তৃতা চক্র, কুরআন ক্লাস, সাংস্কৃতিক কার্যক্রম।', textBody),
                      _buildBulletItem('education', 'শিক্ষা বৈঠক, শিক্ষা মজলিস', textBody),
                      _buildBulletItem('ibadah', 'এহতেসাব, নফল ইবাদত, নৈশ ইবাদত।', textBody),
                      const Divider(height: 28),

                      _buildSubHeader('চতুর্থ দফা : নারী সমাজের সমস্যা সমাধান', primaryColor),
                      _buildNumberedItem('(১)', 'নারী সমাজের বিভিন্নমুখী সমস্যার ইসলামী সমাধানের প্রচেষ্টা চালানো।', textBody),
                      _buildNumberedItem('(২)', 'নারী নির্যাতন ও যৌতুকের বিরুদ্ধে সোচ্চার হওয়া ও সচেতনতা সৃষ্টি করা।', textBody),
                      _buildNumberedItem('(৩)', 'নারীর মর্যাদা প্রতিষ্ঠার লক্ষ্যে তাদের বিভিন্ন ন্যায্যসংগত দাবি আদায় করার জন্য চেষ্টা চালানো।', textBody),
                      const Divider(height: 28),

                      _buildSubHeader('পঞ্চম দফা : ইসলামী আন্দোলনে ভূমিকা পালন', primaryColor),
                      _buildNumberedItem('(১)', 'ইসলামী আদর্শ পরিবার গঠনে যথাসাধ্য ভূমিকা পালন করা।', textBody),
                      _buildNumberedItem('(২)', 'খেলাফত প্রতিষ্ঠার লক্ষ্যে মহিলাদের মধ্যে সচেতনতা সৃষ্টি ও জনমত গঠন করা।', textBody),
                      _buildNumberedItem('(৩)', 'দ্বীন প্রতিষ্ঠার লক্ষ্যে ব্যাপক গণআন্দোলন গড়ে তোলার ক্ষেত্রে বৃহত্তর আন্দোলনে সম্ভাব্য সহায়ক ভূমিকা পালন করা।', textBody),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 5: Manpower Tiers
                _buildSectionCard(
                  context,
                  title: 'জনশক্তির স্তর',
                  icon: Icons.groups_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Column(
                    children: [
                      _buildTierCard(
                        context,
                        badgeTitle: 'প্রাথমিক সদস্য',
                        badgeColor: Colors.blue.shade700,
                        content: 'যদি কোন মহিলা এ সংগঠনের লক্ষ্য ও উদ্দেশ্যের সাথে ঐকমত্য পোষণ করে নির্দিষ্ট প্রাথমিক সদস্য ফরম পূরণ করেন তবে তিনি এ সংগঠনের প্রাথমিক সদস্য হিসেবে গণ্য হবেন।',
                        isDark: isDark,
                        textBody: textBody,
                      ),
                      const SizedBox(height: 14),
                      _buildTierCard(
                        context,
                        badgeTitle: 'কর্মী',
                        badgeColor: Colors.orange.shade800,
                        content: 'যে সমস্ত প্রাথমিক সদস্য নিয়মিত তিনটি কাজ করেন তিনি এ সংগঠনের কর্মী হিসেবে গণ্য হবেন। যেমন :\n'
                            '১) ব্যক্তিগত রিপোর্ট সংরক্ষণ।\n'
                            '২) নিয়মিত বৈঠকে যোগদান।\n'
                            '৩) বায়তুলমালে এয়ানত দান।',
                        isDark: isDark,
                        textBody: textBody,
                      ),
                      const SizedBox(height: 14),
                      _buildTierCard(
                        context,
                        badgeTitle: 'সদস্য',
                        badgeColor: primaryColor,
                        content: 'এই সংগঠনের যে কোন প্রাথমিক সদস্য যদি এ সংগঠনের লক্ষ্য-উদ্দেশ্যকে নিজের জীবনের লক্ষ্য ও উদ্দেশ্য হিসেবে গ্রহণ করেন, সংগঠনের কর্মপদ্ধতির সাথে ঐকমত্য পোষণ করেন, সংগঠনের সামগ্রিক তৎপরতায় সাধ্যানুসারে অংশগ্রহণ করেন, সংগঠনের সংবিধান মেনে চলার প্রতিশ্রুতি দেন, দ্বীন সম্পর্কে অন্তত: এতটুকু জ্ঞানের অধিকারী হন যাতে ইসলাম ও জাহেলিয়াতের মধ্যে পার্থক্য বিধান করতে পারেন এবং শরীয়তের সীমা সম্পর্কে ওয়াকিবহাল থাকেন, ইসলামের নির্ধারিত ফরজ, ওয়াজিব মেনে চলেন ও কবীরা গুনাহ থেকে বেঁচে থাকেন, তবে তিনি এ সংগঠনের সদস্য হতে পারেন।',
                        isDark: isDark,
                        textBody: textBody,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 6: Baitulmal
                _buildSectionCard(
                  context,
                  title: 'বায়তুলমাল',
                  icon: Icons.account_balance_wallet_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Row(
                    children: [
                      Icon(Icons.monetization_on_outlined, color: primaryColor, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'এ সংগঠনের আয়ের উৎস হবে জনশক্তি ও শুভাকাঙ্ক্ষীদের এয়ানত, সংগঠনের প্রকাশনার আয়, যাকাত ও অন্যান্য হালাল উৎস।',
                          style: TextStyle(fontSize: 15, height: 1.5, color: textBody),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 7: Message / Appeal
                _buildSectionCard(
                  context,
                  title: 'আমাদের উদাত্ত আহ্বান ও বার্তা',
                  icon: Icons.volunteer_activism_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryColor.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'মহিলা মজলিস পার্থিব কোন দলীয় উদ্দেশ্য সাধনের জন্য নয়, বরং অধিকার বঞ্চিত নারীদের প্ল্যাটফর্ম হিসেবে ইসলামী আদর্শের ভিত্তিতে নারীদের অধিকার আদায়ের সংগ্রামে, সমস্যা দূরীকরণের প্রয়াসে, দেশ ও জাতির অবক্ষয় প্রতিরোধে সর্বোপরি ইসলামী সমাজ প্রতিষ্ঠার আন্দোলনে সম্ভাব্য ভূমিকা পালন করতে চায়।',
                          style: TextStyle(fontSize: 14.5, height: 1.6, color: textBody),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'ইসলামী মহিলা মজলিস চায় পার্থিব লোভ-লালসা মুক্ত এমন একদল আদর্শ চরিত্রবান ও যোগ্যতার মহিলা কর্মীবাহিনী গড়ে তুলতে যারা আদর্শ মা, বোন ও স্ত্রী হিসেবে ঘরে ঘরে ইসলামী মূল্যবোধকে ছড়িয়ে দেবেন।',
                          style: TextStyle(fontSize: 14.5, height: 1.6, color: textBody),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'তথাকথিত নারী স্বাধীনতার নামে মহিলাদেরকে যেভাবে পণ্য সামগ্রীর মডেল ও ভোগ্যপণ্যে পরিণত করা হচ্ছে, অর্থনৈতিক স্বাধীনতার নামে তাদের উপর মনস্তাত্ত্বিক ও শারীরিক যে চাপ সৃষ্টি করা হচ্ছে তার বিরুদ্ধে বাংলাদেশ ইসলামী মহিলা মজলিস সোচ্চার হতে চায়। আমাদের কাছে নারীর মানবীয় সাম্য, মর্যাদা এবং অর্থনৈতিক নিরাপত্তা যেমন কাম্য তেমনি নারীর পরিশীলিত মানবিক জীবনও অপরিহার্য।',
                          style: TextStyle(fontSize: 14.5, height: 1.6, color: textBody),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'আমরা যদি সত্যিই সমাজকে নিয়ে কোন গঠনমূলক চিন্তাভাবনা করি, চাই সমস্যার সুষ্ঠু সমাধান তবে মা-বোনদেরকে প্রথমে এগিয়ে আসতে হবে। আমাদের মধ্য থেকেই জন্ম নেবে ভবিষ্যতের যোগ্যতার, চরিত্রবান খোদাভীতি মরদে মুজাহিদ সন্তানেরা যারা দুনিয়ার বুক থেকে সকল প্রকার অন্যায়, অত্যাচার ও জুলুমকে উৎখাত করে আল্লাহর আইনকে প্রতিষ্ঠার জন্য বুক পেতে দেবে। আসুন, বোনেরা, ইসলামে আমাদের যে সব অধিকার ও মর্যাদা রয়েছে তা কুরআন ও হাদিস থেকে জেনে নেই। নিজেদের চরিত্রকে আদর্শ মুসলিম নারীদের মত গড়ে তুলি এবং অন্যকেও সচেতন করে তুলি।',
                          style: TextStyle(fontSize: 14.5, height: 1.6, color: textBody),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'আসুন আমরা আল্লাহর রঙে রঞ্জিত হয়ে সমস্ত স্বার্থপরতা পরিহার করে তাঁরই রহমত লাভের আশায় এ পথে আত্মোৎসর্গ করি। আল্লাহ আমাদের এই পথে সুদৃঢ় রাখুন এবং কবুল করুন। আমীন।।',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Section 8: Address & Contact Card
                _buildAddressCard(context, isDark, primaryColor, cardBg, borderColor, textTitle, textBody, textMuted),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderBanner(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color cardBg,
    Color borderColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF064E3B), const Color(0xFF022C22)]
              : [const Color(0xFF059669), const Color(0xFF047857)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 54,
                errorBuilder: (context, error, stackTrace) => Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 36),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'বাংলাদেশ ইসলামী মহিলা মজলিস',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'সংক্ষিপ্ত পরিচিতি',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today_rounded, size: 14, color: Colors.white.withValues(alpha: 0.85)),
              const SizedBox(width: 6),
              Text(
                'প্রতিষ্ঠা: ১৯ জানুয়ারি ১৯৯০',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color primaryColor,
    required Color cardBg,
    required Color borderColor,
    required Color textTitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: primaryColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textTitle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildProgramTile(
    BuildContext context,
    String serial,
    String title,
    String description,
    Color primaryColor,
    bool isDark,
    Color textTitle,
    Color textBody,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor,
              child: Text(
                serial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textTitle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, height: 1.5, color: textBody),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSubHeader(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildBulletItem(String tag, String text, Color textBody) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14.5, height: 1.5, color: textBody),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedItem(String number, String text, Color textBody) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$number ', style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Colors.green)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14.5, height: 1.5, color: textBody),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrgDetailTile(
    String label,
    String detail,
    Color textTitle,
    Color textBody,
    Color primaryColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: textTitle),
          ),
          const SizedBox(height: 2),
          Text(
            detail,
            style: TextStyle(fontSize: 14, height: 1.5, color: textBody),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildTierCard(
    BuildContext context, {
    required String badgeTitle,
    required Color badgeColor,
    required String content,
    required bool isDark,
    required Color textBody,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badgeTitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 14.5, height: 1.55, color: textBody),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color cardBg,
    Color borderColor,
    Color textTitle,
    Color textBody,
    Color textMuted,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_rounded, color: primaryColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'যোগাযোগ ও কেন্দ্রীয় কার্যালয়',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textTitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Text(
            'বাংলাদেশ ইসলামী মহিলা মজলিস',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.business_rounded, size: 18, color: textMuted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ফায়েনাজ টাওয়ার, ফ্লাট-১১/এ, ৩৭/২ পুরানা পল্টন (কালভার্ট রোড), ঢাকা-১০০০',
                  style: TextStyle(fontSize: 14, color: textBody, height: 1.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.phone_rounded, size: 18, color: textMuted),
              const SizedBox(width: 8),
              Text(
                'মোবাইল : ০১৮১৫ ০৪২০৮৭',
                style: TextStyle(fontSize: 14, color: textBody),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.email_rounded, size: 18, color: textMuted),
              const SizedBox(width: 8),
              Text(
                'E-mail : mahilamajlisbd@gmail.com',
                style: TextStyle(fontSize: 14, color: textBody),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.shade700.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade700),
              ),
              child: Text(
                'বিনিময়: দুই টাকা মাত্র',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.amber.shade300 : Colors.amber.shade900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
