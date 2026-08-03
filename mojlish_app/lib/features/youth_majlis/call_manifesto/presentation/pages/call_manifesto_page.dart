import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';

/// বাংলাদেশ ইসলামী যুব মজলিস — সংক্ষিপ্ত পরিচিতি ও আহ্বান পেজ
class CallManifestoPage extends StatefulWidget {
  const CallManifestoPage({super.key});

  @override
  State<CallManifestoPage> createState() => _CallManifestoPageState();
}

class _CallManifestoPageState extends State<CallManifestoPage> {
  Future<void> _makeCall() async {
    final url = Uri.parse('tel:01838005911');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sendEmail() async {
    final url = Uri.parse('mailto:islamijubomajlis@gmail.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = const Color(0xFF0284C7); // Sky Blue / Ocean Blue for Youth Majlis
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textDark = isDark ? Colors.white : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'সংক্ষিপ্ত পরিচিতি ও আহ্বান',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: primaryAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Banner Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF0284C7), const Color(0xFF0369A1)]
                      : [const Color(0xFF0284C7), const Color(0xFF0284C7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryAccent.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(MajlisAssets.juboLogo, height: 60),
                  const SizedBox(height: 12),
                  const Text(
                    'বিসমিল্লাহির রাহমানির রাহীম',
                    style: TextStyle(color: Colors.amberAccent, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'বাংলাদেশ ইসলামী যুব মজলিস',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'সংক্ষিপ্ত পরিচিতি ও আহ্বান',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. ভূমিকা
            _buildContentCard(
              title: 'ভূমিকা',
              icon: Icons.menu_book_rounded,
              accentColor: const Color(0xFF10B981),
              cardBg: cardBg,
              textDark: textDark,
              textMuted: textMuted,
              content:
                  'আল্লাহ রাব্বুল আলামীনের শুকরিয়া আদায় করছি যিনি আমাদের যৌবনের দৌলত দান করেছেন। আমরা জীবনের শ্রেষ্ঠ সময় যৌবন পার করছি। যৌবনের উপযুক্ত মূল্যায়ন করা প্রয়োজন। ইসলামী আদর্শে বিশ্বাসী মানুষের জনপদ বাংলাদেশ। দেশের মোট জনসংখ্যার প্রায় এক-তৃতীয়াংশ জনগোষ্ঠী যুবসমাজ। ব্যক্তি, পরিবার, সমাজ, রাষ্ট্র ও জাতিগঠনে যুবসমাজের ভূমিকা অপরিসীম। যুবসমাজের মেধা, শ্রম, সাহসিকতা, দক্ষতা, নৈতিক ও চারিত্রিক দৃঢ়তা, সৃজনশীল মনন ও প্রতিভাকে কেন্দ্র করে আকৃতি পায় একটি জাতির সামগ্রিক পরিমণ্ডল। যুবসমাজ জাতির ভবিষ্যৎ নেতৃত্ব সৃষ্টিতে একটি শক্তিশালী প্রত্যয়। এজন্য প্রয়োজন অর্থনৈতিক, সামাজিক, সাংস্কৃতিক ও রাজনৈতিক কর্মকাণ্ডে যুবসমাজের সক্রিয় অংশগ্রহণ। ক্ষেত্রে যুবসমাজকে সুসংগঠিত করে আদর্শিক এবং দক্ষ জনশক্তিতে পরিণত করার লক্ষ্যে একটি সুশৃঙ্খল সংগঠনের আওতায় নিয়ে আসা সময়ের অপরিহার্য দাবি।',
            ),
            const SizedBox(height: 16),

            // 3. পটভূমি
            _buildContentCard(
              title: 'পটভূমি',
              icon: Icons.history_edu_rounded,
              accentColor: const Color(0xFF8B5CF6),
              cardBg: cardBg,
              textDark: textDark,
              textMuted: textMuted,
              content:
                  'মনে রাখতে হবে যুবসমাজই একটি জাতির আশা-ভরসার কেন্দ্রস্থল। জাতীয় জীবনে যে কোনো গুরুত্বপূর্ণ মুহূর্তে যুবসমাজ অগ্রণী ও সাহসী ভূমিকা পালন করে। তাদের মনোবল ও সুসংহতভাবে শক্তিতে বিকশিত করে একটি কল্যাণমুখী সমাজ ও রাষ্ট্র কাঠামো তৈরি করা অপরিহার্য। সমাজ ও রাষ্ট্রের উন্নতি সাধনে যুবসমাজই মূলশক্তি। তারাই পারে একটি দেশের বৈপ্লবিক পরিবর্তন সাধন করতে।\n\nকিন্তু নৈতিকতার মানদণ্ডে আমাদের যুবসমাজ আজ প্রশ্নবিদ্ধ। বিভিন্ন অনৈতিক উপকরণের প্রভাবে তারা তাদের নৈতিক দায়িত্ববোধ হারিয়ে ফেলছে। এভাবে চলতে থাকলে একটি জাতির অর্জন অচিরেই বিলীন হয়ে নিজেদের অস্তিত্ব সংকটে পড়বে। তাই দেশের তাবৎ অচলায়তন ভেঙে সামগ্রিক পরিবর্তন আনতে যুবসমাজের এগিয়ে আসার বিকল্প নেই। ন্যায় ও ইনসাফভিত্তিক ভারসাম্যপূর্ণ একটি জাতি গঠনে যুবসম্প্রদায়ের সম্পৃক্ততা একান্ত প্রয়োজন। এ লক্ষ্যে ২০২৩ সালের ১০ মার্চ জাতীয় মসজিদ বায়তুল মোকাররম চত্বর হতে ইসলামী যুব মজলিস আত্মপ্রকাশ করে।',
            ),
            const SizedBox(height: 16),

            // 4. লক্ষ্য ও উদ্দেশ্য
            _buildContentCard(
              title: 'লক্ষ্য ও উদ্দেশ্য',
              icon: Icons.flag_rounded,
              accentColor: const Color(0xFFD97706),
              cardBg: cardBg,
              textDark: textDark,
              textMuted: textMuted,
              content:
                  'আল্লাহ তা\'য়ালার সন্তুষ্টি অর্জনের লক্ষ্যে যুবকদের আত্মিক মানোন্নয়ন, মেধার বিকাশ ও দক্ষতা বৃদ্ধি এবং রাজনৈতিক সচেতনতা সৃষ্টির মাধ্যমে যুবসমাজকে ঐক্যবদ্ধ করে কল্যাণমুখী সমাজব্যবস্থা গড়ে তোলা।',
            ),
            const SizedBox(height: 16),

            // 5. নীতিমালা
            _buildListCard(
              title: 'নীতিমালা',
              icon: Icons.gavel_rounded,
              accentColor: const Color(0xFF2563EB),
              cardBg: cardBg,
              textDark: textDark,
              items: [
                '১. যুবকদের শান্তি, ন্যায়বিচার, স্বাধীনতা, পারস্পরিক শ্রদ্ধাবোধ ও বোঝাপড়া ইত্যাদি চেতনা অর্জিত হবে যাতে করে সমাজে শান্তি, নিরাপত্তা ও স্থিতি আসে এবং আন্তর্জাতিক পর্যায়েও তার প্রভাব পড়ে। উচ্চতর নৈতিকতা ও সততায় সমৃদ্ধ হবে প্রতিটি যুবক। আল্লাহর নিকট সকল কাজে তারা দায়বদ্ধ থাকবে। সাংগঠনিক পদ্ধতিতেও জবাবদিহিতা নিশ্চিত করা হবে।',
                '২. শিক্ষা, বক্তব্য, মোটিভেশন, ভ্রমণ, কর্ম, সভা ও ভাব বিনিময়ে সর্বত্র যুবকদের অর্জিত চেতনার প্রতিফলন ঘটবে।',
                '৩. যাবতীয় সমস্যা সমাধানে সার্বিক জীবনবোধ প্রয়োজন। ইসলাম একটি সার্বজনীন ও সার্বিক জীবনবোধ দিয়েছে যার কোনো বিকল্প নেই। তাই জীবনের সর্বক্ষেত্রে আল্লাহর বিধান ও রাসুল (সা.) এর সুন্নাহর প্রয়োগ করতে হবে।',
                '৪. জাতীয় পলিসি নির্ধারণে যুবকদের অংশগ্রহণ প্রয়োজন।',
              ],
            ),
            const SizedBox(height: 16),

            // 6. কর্মসূচি
            _buildListCard(
              title: 'কর্মসূচি (৫ দফা)',
              icon: Icons.assignment_turned_in_rounded,
              accentColor: const Color(0xFF059669),
              cardBg: cardBg,
              textDark: textDark,
              items: [
                'এক. যুব সমাজের ঐক্য : যুবকদের মাঝে ব্যাপকভাবে ইসলামের দাওয়াত পৌঁছে দেয়া এবং তাদেরকে সংগঠিত করে কল্যাণমুখী সমাজব্যবস্থা প্রতিষ্ঠায় চিন্তা ও চেতনার ঐক্য গড়ে তোলা।',
                'দুই. প্রশিক্ষণ ও উন্নয়ন : যুবকদের নৈতিক ও মানবিক জীবন গঠন, কর্ম ও কর্মসংস্থানমুখী প্রশিক্ষণ এবং টেকসই উন্নয়নে পরামর্শ প্রদান। সমাজের সর্বস্তরের যুবকদের দায়িত্বশীল নাগরিক ও মানবসম্পদে পরিণত করা।',
                'তিন. আদর্শিক দক্ষ নেতৃত্ব : আদর্শবান দক্ষ নেতৃত্ব সৃষ্টির লক্ষ্যে সর্বাত্মক প্রচেষ্টা চালানো। শোষিত-বঞ্চিত জনগোষ্ঠী ও যুবসমাজের সকল প্রকার ন্যায় অধিকার আদায়ের লক্ষ্যে কার্যকর পদক্ষেপ গ্রহণ এবং স্থানীয় সরকার ব্যবস্থাপনায় সৎ ও যোগ্য নেতৃত্ব নিশ্চিত করা।',
                'চার. সামাজিক মূল্যবোধ প্রতিষ্ঠা ও দুর্নীতি প্রতিরোধ : সর্বস্তরে সামাজিক ও ইসলামী মূল্যবোধ প্রতিষ্ঠা করা। পারিবারিক জীবন, পরিবার ব্যবস্থাপনা এবং সামাজিক সমস্যাদি নিয়ে কাজ করা, মাদক, জুয়াসহ যাবতীয় নেশাজাত দ্রব্য এবং সকল প্রকার দুর্নীতির বিরুদ্ধে যুবসমাজকে সচেতন করা ও সামাজিক আন্দোলন গড়ে তোলা।',
                'পাঁচ. কল্যাণ রাষ্ট্র প্রতিষ্ঠায় সহযোগিতা : বাংলাদেশের স্বাধীনতা-সার্বভৌমত্ব সুরক্ষার জন্য দেশের যুবসমাজকে ঐক্যবদ্ধ করার মাধ্যমে একটি সুষম, ভারসাম্যপূর্ণ, সমৃদ্ধ ও উৎপাদনশীল ইসলামী কল্যাণ রাষ্ট্র প্রতিষ্ঠায় সার্বিক সহযোগিতা করা।',
              ],
            ),
            const SizedBox(height: 16),

            // 7. সাংগঠনিক স্তর
            _buildContentCard(
              title: 'সাংগঠনিক স্তর',
              icon: Icons.groups_rounded,
              accentColor: const Color(0xFFEC4899),
              cardBg: cardBg,
              textDark: textDark,
              textMuted: textMuted,
              content:
                  'এ সংগঠনের জনশক্তির দুটি স্তর থাকবে:\n\n'
                  '♦ প্রাথমিক সদস্য : যে সকল যুবক ইসলামী যুব মজলিসের লক্ষ্য উদ্দেশ্য, নীতিমালা ও কর্মসূচির সাথে একমত পোষণ করে সংগঠনের নির্ধারিত প্রাথমিক সদস্য ফরম পূরণ করবেন তারা এ সংগঠনের প্রাথমিক সদস্য হিসেবে গণ্য হবেন।\n\n'
                  '♦ সদস্য : ইসলামী যুব মজলিসের যেসব প্রাথমিক সদস্য সংগঠনের কাজে নিয়মিত অংশগ্রহণ করবেন, সভাসমূহ উপস্থিত থাকবেন, আর্থিক সহযোগিতা করবেন, সংগঠনের সিলেবাস অনুযায়ী অধ্যয়ন করবেন এবং আত্মিক মানোন্নয়নে সচেষ্ট থাকবেন তারা সংগঠনের সদস্য হবেন।',
            ),
            const SizedBox(height: 16),

            // 8. সাংগঠনিক কাঠামো
            _buildContentCard(
              title: 'সাংগঠনিক কাঠামো ও পরিষদসমূহ',
              icon: Icons.account_tree_rounded,
              accentColor: const Color(0xFF0284C7),
              cardBg: cardBg,
              textDark: textDark,
              textMuted: textMuted,
              content:
                  '♦ সাংগঠনিক কাঠামো : কেন্দ্রীয় সংগঠন, জেলা/মহানগরী শাখা, উপজেলা/পৌরসভা/থানা শাখা, ইউনিয়ন শাখা, ওয়ার্ড শাখা নিয়ে গঠিত হবে।\n\n'
                  '♦ কেন্দ্রীয় সংগঠন : কেন্দ্রীয় সভাপতি, কেন্দ্রীয় নির্বাহী পরিষদ, জাতীয় কাউন্সিল ও কেন্দ্রীয় উপদেষ্টা পরিষদ নিয়ে গঠিত হবে।\n\n'
                  '♦ কেন্দ্রীয় নির্বাহী পরিষদ : কেন্দ্রীয় সভাপতির নেতৃত্বে সর্বোচ্চ ১৯ সদস্য বিশিষ্ট কমিটি থাকবে (সহ-সভাপতি ৩, সাধারণ সম্পাদক ১, সহ-সাধারণ সম্পাদক ২, বিভাগীয় সম্পাদক ও সদস্যবৃন্দ)।\n\n'
                  '♦ জাতীয় কাউন্সিল : কেন্দ্রীয় সভাপতি পদাধিকার বলে জাতীয় কাউন্সিলে সভাপতিত্ব করবেন। এটি নীতি নির্ধারণী ফোরাম হিসেবে পরিগণিত হবে।\n\n'
                  '♦ কেন্দ্রীয় উপদেষ্টা পরিষদ : অভিজ্ঞ সমাজতাত্ত্বিক ও চিন্তাবিদদের নিয়ে গঠিত উপদেষ্টা পরিষদ প্রতি ইংরেজি সনে ন্যূনতম ১টি বৈঠক করবে।',
            ),
            const SizedBox(height: 16),

            // 9. পরিসমাপ্তি ও রাসুল (সা.)-এর নসীহত
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF332A15) : const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.format_quote_rounded, color: Colors.amber, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'রাসুলুল্লাহ (সা.)-এর নসীহত',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'রাসুল (সা.) জনৈক ব্যক্তিকে উপদেশ দিতে গিয়ে বলেন,\n'
                    '"পাঁচটি বস্তুকে পাঁচটি বস্তুর পূর্বে গুরুত্ব দিবে এবং মূল্যবান মনে করবে:\n'
                    '(১) বার্ধক্যের পূর্বে যৌবনকে\n'
                    '(২) অসুস্থতার পূর্বে সুস্থতাকে\n'
                    '(৩) দারিদ্রতার পূর্বে স্বচ্ছলতাকে\n'
                    '(৪) ব্যস্ততার পূর্বে অবসরকে এবং\n'
                    '(৫) মৃত্যুর পূর্বে জীবনকে"।\n\n'
                    'কিয়ামতের দিন আল্লাহ তা\'আলা যে সাত শ্রেণীর লোককে তাঁর আরশের ছায়া দান করবেন, তাদের মধ্যে দ্বিতীয় শ্রেণী হলো ঐ যুবক যে তার যৌবনকাল আল্লাহর ইবাদতে কাটিয়েছে।',
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF78350F),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 10. যেসব বই পড়তে হবে
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryAccent.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ইসলামী যুব মজলিসকে জানতে আপনাকে পড়তে হবে:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: primaryAccent),
                  ),
                  const SizedBox(height: 8),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(label: Text('১. ঘোষণাপত্র'), backgroundColor: Color(0xFFE0F2FE)),
                      Chip(label: Text('২. গঠনতন্ত্র'), backgroundColor: Color(0xFFE0F2FE)),
                      Chip(label: Text('৩. কার্যপদ্ধতি'), backgroundColor: Color(0xFFE0F2FE)),
                      Chip(label: Text('৪. সিলেবাস'), backgroundColor: Color(0xFFE0F2FE)),
                      Chip(label: Text('৫. যুববার্তা'), backgroundColor: Color(0xFFE0F2FE)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 11. যোগাযোগের ঠিকানা
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'ইসলামী যুব মজলিস (কেন্দ্রীয় কার্যালয়)',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '১৬ বিজয়নগর, (৫ম তলা), পুরানা পল্টন, ঢাকা-১০০০।',
                    style: TextStyle(color: Colors.amberAccent, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _makeCall,
                        icon: const Icon(Icons.call_rounded, size: 18),
                        label: const Text('01838-005911'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primaryAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _sendEmail,
                        icon: const Icon(Icons.email_rounded, size: 18),
                        label: const Text('ইমেইল করুন'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amberAccent,
                          foregroundColor: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard({
    required String title,
    required IconData icon,
    required Color accentColor,
    required Color cardBg,
    required Color textDark,
    required Color textMuted,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: accentColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 13.5, height: 1.6, color: textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard({
    required String title,
    required IconData icon,
    required Color accentColor,
    required Color cardBg,
    required Color textDark,
    required List<String> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: accentColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                item,
                style: TextStyle(fontSize: 13.5, height: 1.5, color: textDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
