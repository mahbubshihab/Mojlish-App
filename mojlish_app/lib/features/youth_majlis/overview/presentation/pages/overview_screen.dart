import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/overview_bloc.dart';
import '../bloc/overview_event.dart';
import '../bloc/overview_state.dart';
import '../../data/datasources/overview_remote_datasource.dart';
import '../../data/repositories/overview_repository_impl.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OverviewBloc(
        repository: OverviewRepositoryImpl(
          remoteDataSource: OverviewRemoteDataSourceImpl(),
        ),
      )..add(LoadOverviewEvent()),
      child: const _YouthOverviewView(),
    );
  }
}

class _YouthOverviewView extends StatelessWidget {
  const _YouthOverviewView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? const Color(0xFF10B981) : const Color(0xFF059669);
    final accentColor = isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);
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
          'বাংলাদেশ ইসলামী যুব মজলিস — পরিচিতি',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner Card
                _buildHeaderBanner(context, isDark, primaryColor),
                const SizedBox(height: 20),

                // Section 1: ভূমিকা (Introduction)
                _buildSectionCard(
                  context,
                  title: 'ভূমিকা',
                  icon: Icons.auto_stories_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Text(
                    'আল্লাহ্‌ রাব্বুল আলামীনের শুকরিয়া আদায় করছি যিনি আমাদের যৌবনের দৌলত দান করেছেন। আমরা জীবনের শ্রেষ্ঠ সময় যৌবন পার করছি। যৌবনের উপযুক্ত মূল্যায়ন করা প্রয়োজন। ইসলামী আদর্শে বিশ্বাসী মানুষের জনপদ বাংলাদেশ। দেশের মোট জনসংখ্যার প্রায় এক-তৃতীয়াংশ জনগোষ্ঠী যুবসমাজ। ব্যক্তি, পরিবার, সমাজ, রাষ্ট্র ও জাতিগঠনে যুবসমাজের ভূমিকা অপরিসীম। যুবসমাজের মেধা, শ্রম, সাহসিকতা, দক্ষতা, নৈতিক ও চারিত্রিক দৃঢ়তা, সৃজনশীল মনন ও প্রতিভাকে কেন্দ্র করে আকৃতি পায় একটি জাতির সামগ্রীক পরিমন্ডল। যুবসমাজ জাতির ভবিষ্যৎ নেতৃত্ব সৃষ্টিতে একটি শক্তিশালী প্রত্যয়। এজন্য প্রয়োজন অর্থনৈতিক, সামাজিক, সাংস্কৃতিক ও রাজনৈতিক কর্মকাণ্ডে যুবসমাজের সক্রিয় অংশগ্রহণ। এক্ষেত্রে যুবসমাজকে সুসংগঠিত করে আদর্শিক এবং দক্ষ জনশক্তিতে পরিণত করার লক্ষ্যে একটি সুশৃঙ্খল সংগঠনের আওতায় নিয়ে আসা সময়ের অপরিহার্য দাবি।',
                    style: TextStyle(fontSize: 15, height: 1.6, color: textBody),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 20),

                // Section 2: পটভূমি (Background)
                _buildSectionCard(
                  context,
                  title: 'পটভূমি',
                  icon: Icons.history_edu_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'মনে রাখতে হবে যুবসমাজই একটি জাতির আশা-ভরসার কেন্দ্রস্থল। জাতীয় জীবনে যে কোনো গুরুত্বপূর্ণ মুহূর্তে যুবসমাজ অগ্রণী ও সাহসী ভূমিকা পালন করে। তাদের মনোবল ও সুগুপ্তপ্রভিাকে শক্তিতে বিকশিত করে একটি কল্যাণমুখী সমাজ ও রাষ্ট্র কাঠামো তৈরি করা অপরিহার্য। সমাজ ও রাষ্ট্রের উন্নতি সাধনে যুবসমাজই মূলশক্তি। তারাই পারে একটি দেশের বৈপ্লবিক পরিবর্তন সাধন করতে।',
                        style: TextStyle(fontSize: 15, height: 1.6, color: textBody),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'কিন্তু নৈতিকতার মানদণ্ডে আমাদের যুবসমাজ আজ প্রশ্নবিদ্ধ। বিভিন্ন অনৈতিক উপকরণের প্রভাবে তারা তাদের নৈতিক দায়িত্ববোধ হারিয়ে ফেলছে। এভাবে চলতে থাকলে একটি জাতির অর্জন অচিরেই বিলীন হয়ে নিজেদের অস্তিত্ব সংকটে পড়বে। তাই দেশের তাবৎ অচলায়তন ভেঙে সামগ্রীক পরিবর্তন আনতে যুবসমাজের এগিয়ে আসার বিকল্প নেই। ন্যায় ও ইনসাফভিত্তিক ভারসাম্যপূর্ণ একটি জাতি গঠনে যুবসম্প্রদায়ের সম্পৃক্ততা একান্ত প্রয়োজন। এ লক্ষ্যে ২০২৩ সালের ১০ মার্চ জাতীয় মসজিদ বায়তুল মোকাররম চত্বর হতে ইসলামী যুব মজলিস আত্মপ্রকাশ করে।',
                        style: TextStyle(fontSize: 15, height: 1.6, color: textBody),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 3: লক্ষ্য ও উদ্দেশ্য (Aims & Objectives)
                _buildSectionCard(
                  context,
                  title: 'লক্ষ্য ও উদ্দেশ্য',
                  icon: Icons.track_changes_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryColor.withValues(alpha: 0.25)),
                    ),
                    child: Text(
                      'আল্লাহ্‌ তা\'য়ালার সন্তুষ্টি অর্জনের লক্ষ্যে যুবকদের আত্মিক মানোন্নয়ন, মেধার বিকাশ ও দক্ষতা বৃদ্ধি এবং রাজনৈতিক সচেতনতা সৃষ্টির মাধ্যমে যুবসমাজকে ঐক্যবদ্ধ করে কল্যাণমুখী সমাজব্যবস্থা গড়ে তোলা।',
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

                // Section 4: নীতিমালা (Principles)
                _buildSectionCard(
                  context,
                  title: 'নীতিমালা',
                  icon: Icons.gavel_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNumberedTile(
                        context,
                        '১',
                        'যুবকদের শান্তি, ন্যায়বিচার, স্বাধীনতা, পারস্পরিক শ্রদ্ধাবোধ ও বোঝাপড়া ইত্যাদি চেতনা অর্জিত হবে যাতে করে সমাজে শান্তি, নিরাপত্তা ও স্থিতি আসে এবং আন্তর্জাতিক পর্যায়েও তার প্রভাব পড়ে। উচ্চতর নৈতিকতা ও সততায় সমৃদ্ধ হবে প্রতিটি যুবক। আল্লাহর নিকট সকল কাজে তারা দায়বদ্ধ থাকবে। সাংগঠনিক পদ্ধতিতেও জবাবদিহিতা নিশ্চিত করা হবে।',
                        primaryColor,
                        isDark,
                        textTitle,
                        textBody,
                      ),
                      _buildNumberedTile(
                        context,
                        '২',
                        'শিক্ষা, বক্তব্য, মোটিভেশন, ভ্রমণ, কর্ম, সভা ও ভাব বিনিময়ে সর্বত্র যুবকদের অর্জিত চেতনার প্রতিফলন ঘটবে।',
                        primaryColor,
                        isDark,
                        textTitle,
                        textBody,
                      ),
                      _buildNumberedTile(
                        context,
                        '৩',
                        'যাবতীয় সমস্যা সমাধানে সার্বিক জীবনবোধ প্রয়োজন। ইসলাম একটি সার্বজনীন ও সার্বিক জীবনবোধ দিয়েছে যার কোনো বিকল্প নেই। তাই জীবনের সর্বক্ষেত্রে আল্লাহর বিধান ও রাসূল (সা.) এর সুন্নাহর প্রয়োগ করতে হবে।',
                        primaryColor,
                        isDark,
                        textTitle,
                        textBody,
                      ),
                      _buildNumberedTile(
                        context,
                        '৪',
                        'জাতীয় পলিসি নির্ধারণে যুবকদের অংশগ্রহণ প্রয়োজন।',
                        primaryColor,
                        isDark,
                        textTitle,
                        textBody,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 5: কর্মসূচি (Action Programs)
                _buildSectionCard(
                  context,
                  title: 'কর্মসূচি',
                  icon: Icons.checklist_rtl_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgramTile(
                        context,
                        'এক',
                        'যুব সমাজের ঐক্য',
                        'যুবকদের মাঝে ব্যাপকভাবে ইসলামের দাওয়াত পৌঁছে দেয়া এবং তাদেরকে সংগঠিত করে কল্যাণমুখী সমাজব্যবস্থা প্রতিষ্ঠায় চিন্তা ও চেতনার ঐক্য গড়ে তোলা।',
                        primaryColor,
                        isDark,
                        textTitle,
                        textBody,
                      ),
                      _buildProgramTile(
                        context,
                        'দুই',
                        'প্রশিক্ষণ ও উন্নয়ন',
                        'যুবকদের নৈতিক ও মানবিক জীবন গঠন, কর্ম ও কর্মসংস্থানমুখী প্রশিক্ষণ এবং টেকসই উন্নয়নে পরামর্শ প্রদান। সমাজের সর্বস্তরের যুবকদের দায়িত্বশীল নাগরিক ও মানবসম্পদে পরিণত করা।',
                        primaryColor,
                        isDark,
                        textTitle,
                        textBody,
                      ),
                      _buildProgramTile(
                        context,
                        'তিন',
                        'আদর্শিক দক্ষ নেতৃত্ব',
                        'আদর্শবান দক্ষ নেতৃত্ব সৃষ্টির লক্ষ্যে সর্বাত্মক প্রচেষ্টা চালানো। শোষিত-বঞ্চিত জনগোষ্ঠী ও যুবসমাজের সকল প্রকার ন্যায় অধিকার আদায়ের লক্ষ্যে কার্যকর পদক্ষেপ গ্রহণ এবং স্থানীয় সরকার ব্যবস্থাপনায় সৎ ও যোগ্য নেতৃত্ব নিশ্চিত করা।',
                        primaryColor,
                        isDark,
                        textTitle,
                        textBody,
                      ),
                      _buildProgramTile(
                        context,
                        'চার',
                        'সামাজিক মূল্যবোধ প্রতিষ্ঠা ও দুর্নীতি প্রতিরোধ',
                        'সর্বস্তরে সামাজিক ও ইসলামী মূল্যবোধ প্রতিষ্ঠা করা। পারিবারিক জীবন, পরিবার ব্যবস্থাপনা এবং সামাজিক সমস্যাদি নিয়ে কাজ করা, মাদক, জুয়াসহ যাবতীয় নেশাজাত দ্রব্য এবং সকল প্রকার দুর্নীতির বিরুদ্ধে যুবসমাজকে সচেতন করা ও সামাজিক আন্দোলন গড়ে তোলা।',
                        primaryColor,
                        isDark,
                        textTitle,
                        textBody,
                      ),
                      _buildProgramTile(
                        context,
                        'পাঁচ',
                        'কল্যাণ রাষ্ট্র প্রতিষ্ঠায় সহযোগিতা',
                        'বাংলাদেশের স্বাধীনতা-সার্বভৌমত্ব সুরক্ষার জন্য দেশের যুবসমাজকে ঐক্যবদ্ধ করার মাধ্যমে একটি সুষম, ভারসাম্যপূর্ণ, সমৃদ্ধ ও উৎপাদনশীল ইসলামী কল্যাণ রাষ্ট্র প্রতিষ্ঠায় সার্বিক সহযোগিতা করা।',
                        primaryColor,
                        isDark,
                        textTitle,
                        textBody,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 6: সাংগঠনিক স্তর (Organizational Tiers)
                _buildSectionCard(
                  context,
                  title: 'সাংগঠনিক স্তর',
                  icon: Icons.groups_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'এ সংগঠনের জনশক্তির দুটি স্তর থাকবে:',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: textMuted),
                      ),
                      const SizedBox(height: 12),
                      _buildTierCard(
                        context,
                        badgeTitle: 'প্রাথমিক সদস্য',
                        badgeColor: accentColor,
                        content: 'যে সকল যুবক ইসলামী যুব মজলিসের লক্ষ্য উদ্দেশ্য, নীতিমালা ও কর্মসূচির সাথে একমত পোষণ করে সংগঠনের নির্ধারিত প্রাথমিক সদস্য ফরম পূরণ করবেন তারা এ সংগঠনের প্রাথমিক সদস্য হিসেবে গণ্য হবেন।',
                        isDark: isDark,
                        textBody: textBody,
                      ),
                      const SizedBox(height: 14),
                      _buildTierCard(
                        context,
                        badgeTitle: 'সদস্য',
                        badgeColor: primaryColor,
                        content: 'ইসলামী যুব মজলিসের যেসব প্রাথমিক সদস্য সংগঠনের কাজে নিয়মিত অংশগ্রহণ করবেন, সভাসমূহে উপস্থিত থাকবেন, আর্থিক সহযোগিতা করবেন, সংগঠনের সিলেবাস অনুযায়ী অধ্যয়ন করবেন এবং আত্মিক মানোন্নয়নে সচেষ্ট থাকবেন তারা সংগঠনের সদস্য হবেন।',
                        isDark: isDark,
                        textBody: textBody,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 7 & 8: সাংগঠনিক কাঠামো ও কেন্দ্রীয় সংগঠন (Structure & Central Setup)
                _buildSectionCard(
                  context,
                  title: 'সাংগঠনিক কাঠামো ও প্রশাসন',
                  icon: Icons.account_tree_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSubHeader('সাংগঠনিক কাঠামো', primaryColor),
                      Text(
                        'কেন্দ্রীয় সংগঠন, জেলা/মহানগরী শাখা, উপজেলা/পৌরসভা/ থানা শাখা, ইউনিয়ন শাখা, ওয়ার্ড শাখা নিয়ে এ সংগঠনের সাংগঠনিক কাঠামো গঠিত হবে।',
                        style: TextStyle(fontSize: 15, height: 1.5, color: textBody),
                      ),
                      const Divider(height: 28),

                      _buildSubHeader('কেন্দ্রীয় সংগঠন', primaryColor),
                      Text(
                        'কেন্দ্রীয় সভাপতি, কেন্দ্রীয় নির্বাহী পরিষদ, জাতীয় কাউন্সিল ও কেন্দ্রীয় উপদেষ্টা পরিষদ নিয়ে এ সংগঠনের কেন্দ্রীয় সংগঠন গঠিত হবে।',
                        style: TextStyle(fontSize: 15, height: 1.5, color: textBody),
                      ),
                      const SizedBox(height: 14),

                      _buildOrgDetailTile(
                        'কেন্দ্রীয় নির্বাহী পরিষদ :',
                        'কেন্দ্রীয় সভাপতির নেতৃত্বে কাউন্সিলরদের মধ্য থেকে সর্বোচ্চ ৩ (তিন) জন সহ-সভাপতি, ১ (এক) জন সাধারণ সম্পাদক, ২ (দুই) জন সহ-সাধারণ সম্পাদক এবং প্রয়োজনীয় সংখ্যক বিভাগীয় সম্পাদক ও সদস্য নিয়ে সর্বোচ্চ ১৯ সদস্য বিশিষ্ট কেন্দ্রীয় নির্বাহী পরিষদ গঠিত হবে। সংগঠন পরিচালনা এবং জাতীয় কাউন্সিলের সিদ্ধান্ত ও কর্মসূচি বাস্তবায়নই হবে কেন্দ্রীয় নির্বাহী পরিষদের দায়িত্ব।',
                        textTitle,
                        textBody,
                        primaryColor,
                      ),
                      const SizedBox(height: 10),

                      _buildOrgDetailTile(
                        'জাতীয় কাউন্সিল :',
                        'কেন্দ্রীয় সভাপতি পদাধিকার বলে জাতীয় কাউন্সিলে সভাপতিত্ব করবেন। সংগঠন পরিচালনার ক্ষেত্রে জাতীয় কাউন্সিল নীতি নির্ধারণী ফোরাম হিসেবে পরিগণিত হবে। জাতীয় কাউন্সিলের মেয়াদকাল এ সংগঠনের সেশনের সাথে সামঞ্জস্যপূর্ণ থাকবে।',
                        textTitle,
                        textBody,
                        primaryColor,
                      ),
                      const SizedBox(height: 10),

                      _buildOrgDetailTile(
                        'কেন্দ্রীয় উপদেষ্টা পরিষদ :',
                        'যুব সমাজের উন্নতিকল্পে ভূমিকা পালনে অভিজ্ঞ সমাজতাত্ত্বিক, চিন্তাবিদ ও বিশেষজ্ঞদের মধ্য থেকে প্রয়োজনীয় সংখ্যক সদস্য নিয়ে জাতীয় কাউন্সিলের সিদ্ধান্তের আলোকে সংগঠনের একটি উপদেষ্টা পরিষদ থাকবে। কেন্দ্রীয় নির্বাহী পরিষদকে পরামর্শ প্রদান করা হবে কেন্দ্রীয় উপদেষ্টা পরিষদের প্রধান কাজ। প্রতি ইংরেজি সনে উপদেষ্টা পরিষদের ন্যূনতম একটি বৈঠক অনুষ্ঠিত হবে।',
                        textTitle,
                        textBody,
                        primaryColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 9: পরিশিষ্ট ও আহ্বান (Hadith & Call Box)
                _buildSectionCard(
                  context,
                  title: 'পরিশিষ্ট ও যুবসমাজের প্রতি আহ্বান',
                  icon: Icons.auto_awesome_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ইসলামী যুব মজলিস ইসলামী আদর্শের পূর্ণ অনুশীলনের মাধ্যমে এমন একটি সমাজ গড়তে চায়; যেখানে থাকবে না কোন অন্যায়, জুলুম, হানাহানি ও হিংসা-বিদ্বেষ। যুবসমাজ আজ এক কঠিন সময় অতিক্রম করছে। যুবসমাজের দায়িত্বানুভূতি জাগ্রত করতে তাদেরকে একটি অনন্য উৎকর্ষতায় নিয়ে আসতে হবে। ইসলামের প্রকৃত সৌন্দর্য যুবসমাজের সামনে উদ্ভাসিত হলে দুর্দমনীয় ও অদম্য যুবশক্তি ইসলামি পুনর্জাগরণের ক্ষেত্রে নবকল্লোল সৃষ্টি করবে।',
                        style: TextStyle(fontSize: 15, height: 1.6, color: textBody),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 16),

                      // Hadith Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.format_quote_rounded, color: primaryColor, size: 28),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'রাসূল (সা.) জনৈক ব্যক্তি‌কে উপদেশ দি‌তে গি‌য়ে বলেন:',
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\'পাঁচটি বস্তুকে পাঁচটি বস্তুর পূর্বে গুরুত্ব দিবে এবং মূল্যবান মনে করবে। (১) বার্ধক্যের পূর্বে যৌবনকে (২) অসুস্থতার পূর্বে সুস্থতাকে (৩) দারিদ্রতার পূর্বে স্বচ্ছলতাকে (৪) ব্যস্ততার পূর্বে অবসরকে এবং (৫) মৃত্যুর পূর্বে জীবনকে\'।',
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.6,
                                fontWeight: FontWeight.w600,
                                color: textTitle,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'উল্লিখিত হাদিসেও বার্ধক্যের পূর্বে যৌবনকালকে গুরুত্ব দেওয়ার কথা বলা হয়েছে। সাত শ্রেণির লোককে আল্লাহ তা\'আলা কিয়ামতের দিন তাঁর আরশের নিচে ছায়া দান করবেন। যেদিন তাঁর ছায়া ব্যতীত অন্য কোনো ছায়া থাকবে না। তাদের মধ্যে দ্বিতীয় শ্রেণি হলো ঐ যুবক যে, তার যৌবনকাল আল্লাহর ইবাদতে কাটিয়েছে। যৌবনের সকল কামনা-বাসনা, সুখ-শান্তির ঊর্ধ্বে আল্লাহ তা\'আলার ইবাদত ও তাঁর সন্তুষ্টি অর্জন করাকেই একমাত্র কর্তব্য মনে করতো।',
                        style: TextStyle(fontSize: 15, height: 1.6, color: textBody),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'তাই আসুন, কল্যাণময় বাংলাদেশ গড়ে তোলার পক্ষে একটি নিয়মতান্ত্রিক আন্দোলনে শরীক হই। কাঙ্ক্ষিত লক্ষ্য অর্জন করতে বৃহৎ পরিসরে নিজেদের মেধা, শ্রম, প্রচেষ্টা ও প্রতিভাকে কাজে লাগিয়ে সর্বকল্যাণমুখী জীবনধারা গড়ে তুলি। সেকুলারিজম ও কমিউনিজম সমন্বিত তথাকথিত আধুনিক সভ্যতার কবরের ওপর দাঁড়িয়ে এক নবদিগন্তের সূচনা করি। এ লক্ষ্যে ইসলামী যুব মজলিসের আদর্শ, লক্ষ্য ও কর্মসূচির পূর্ণ বাস্তবায়নে এ সংগঠনে যোগদান করি। মহান আল্লাহ আমাদের যাবতীয় কর্মপ্রচেষ্টা জান্নাতের বিনিময়ে কবুল করুন। আমিন।',
                              style: TextStyle(fontSize: 15, height: 1.6, color: textBody),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 10: প্রকাশনা সমূহ (Publications List)
                _buildSectionCard(
                  context,
                  title: 'প্রকাশনা সমূহ',
                  icon: Icons.menu_book_rounded,
                  primaryColor: primaryColor,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textTitle: textTitle,
                  child: Column(
                    children: [
                      _buildPublicationItem('১', 'ইসলামী যুব মজলিসের ঘোষণাপত্র', textTitle, isDark),
                      _buildPublicationItem('২', 'গঠনতন্ত্র', textTitle, isDark),
                      _buildPublicationItem('৩', 'কর্মপদ্ধতি', textTitle, isDark),
                      _buildPublicationItem('৪', 'সিলেবাস', textTitle, isDark),
                      _buildPublicationItem('৫', 'যুববার্তা', textTitle, isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 11: ঠিকানা ও যোগাযোগ (Address & Contact Card)
                _buildAddressCard(context, isDark, primaryColor, cardBg, borderColor, textTitle, textBody, textMuted),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderBanner(BuildContext context, bool isDark, Color primaryColor) {
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
                'assets/images/jubo_majlish.png',
                height: 54,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.stars_rounded, color: Colors.white, size: 36),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'বাংলাদেশ ইসলামী যুব মজলিস',
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
                'আত্মপ্রকাশ: ১০ মার্চ ২০২৩',
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
                  fontSize: 12,
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

  Widget _buildNumberedTile(
    BuildContext context,
    String number,
    String description,
    Color primaryColor,
    bool isDark,
    Color textTitle,
    Color textBody,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$number.',
              style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 13),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              description,
              style: TextStyle(fontSize: 14.5, height: 1.5, color: textBody),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubHeader(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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

  Widget _buildOrgDetailTile(
    String label,
    String text,
    Color textTitle,
    Color textBody,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
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
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
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
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 14.5, height: 1.5, color: textBody),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildPublicationItem(String num, String title, Color textTitle, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: const Color(0xFF059669),
              child: Text(
                num,
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: textTitle),
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/jubo_majlish.png',
                height: 36,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.stars_rounded, color: primaryColor, size: 30),
              ),
              const SizedBox(width: 10),
              Text(
                'ইসলামী যুব মজলিস',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.location_on_rounded, color: primaryColor, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '১৬ বিজয়নগর, (৫ম তলা), পুরানা পল্টন, ঢাকা-১০০০।',
                  style: TextStyle(fontSize: 14, color: textBody),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.phone_rounded, color: primaryColor, size: 20),
              const SizedBox(width: 10),
              Text(
                'যোগাযোগ: ০১৮৩৮-০০৫৯১১',
                style: TextStyle(fontSize: 14, color: textBody, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.email_rounded, color: primaryColor, size: 20),
              const SizedBox(width: 10),
              Text(
                'E-mail: islamijubomajlis@gmail.com',
                style: TextStyle(fontSize: 14, color: textBody),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.language_rounded, color: primaryColor, size: 20),
              const SizedBox(width: 10),
              Text(
                'Web: www.islamijubomajlis.org',
                style: TextStyle(fontSize: 14, color: primaryColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
