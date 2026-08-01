import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';

/// বাংলাদেশ খেলাফত ছাত্র মজলিস — ইতিকথা স্ক্রিন
class StudentHistoryScreen extends StatelessWidget {
  const StudentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;

        final appBarBg = isDark ? const Color(0xFF162032) : Colors.white;
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
        final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);
        final textTitle = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
        final textSub = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
        const primaryPurple = Color(0xFF9333EA);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: textTitle, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'ইতিকথা — খেলাফত ছাত্র মজলিস',
              style: TextStyle(
                color: primaryPurple,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
            primaryAccent: primaryPurple,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Header
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardBg.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: primaryPurple.withValues(alpha: 0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primaryPurple.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.history_edu_rounded, color: primaryPurple, size: 30),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'সংগঠনের ইতিকথা ও পটভূমি',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textTitle),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'ঐতিহাসিক খেলাফত আন্দোলন ও ছাত্র মজলিসের ইতিহাস',
                                style: TextStyle(fontSize: 12.5, color: textTitle.withValues(alpha: 0.7)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Content Cards
                  _buildHistoryParagraphCard(
                    cardBg: cardBg,
                    borderColor: borderColor,
                    icon: Icons.mosque_rounded,
                    iconColor: const Color(0xFF059669),
                    title: 'খেলাফতের সূচনা ও নাবাবিয়াত',
                    text:
                        'মহান আল্লাহ জাল্লা শানুহু তার মহান দ্বীনকে নবীগণের (আ.) মাধ্যমে আদর্শগত ও প্রমাণগতভাবে শ্রেষ্ঠত্ব দিয়ে প্রেরণ করেছেন। সেই সাথে ব্যবহারিক জীবনেও আল্লাহর সুমহান দ্বীনকে বিজয়ী করার জন্য নবীদেরকে দায়িত্ব দিয়েছেন। আখেরি নবী মুহাম্মাদ সাল্লাল্লাহু আলাইহি ওয়া সাল্লাম দ্বীনের পূর্ণাঙ্গ বিজয়ের লক্ষ্যে জগতে খেলাফত প্রতিষ্ঠা করে গেছেন। তারপর চার খলিফা খেলাফতে রাশেদার মাধ্যমে দ্বীনের বিজয়কে আরো সম্প্রসারিত করেছেন।',
                    textSub: textSub,
                  ),

                  const SizedBox(height: 16),

                  _buildHistoryParagraphCard(
                    cardBg: cardBg,
                    borderColor: borderColor,
                    icon: Icons.flag_rounded,
                    iconColor: const Color(0xFFD97706),
                    title: 'তাহরীকে খেলাফত ও স্বাধীনতা সংগ্রাম',
                    text:
                        'খেলাফতে রাশেদার পর সর্বোচ্চ মানের না হলেও দ্বীন বিজয়ের লক্ষ্যে খেলাফতের ধারা এ জগতে ১৯২৪ সাল অবধি সাড়ে তেরশত বছর অব্যাহত ছিল। ব্রিটিশ নেতৃত্বাধীন পশ্চিমাগোষ্ঠী খেলাফত ধ্বংসের মাধ্যমে এ জগত থেকে রাষ্ট্রীয় খেলাফতের শেষ চিহ্নটুকু মুছে ফেলা হলে ভারত উপমহাদেশের এক বিপ্লবী সাধক মহাপুরুষ শাইখুল হিন্দ মাহমুদ হাসান রহ. তাহরীকে খেলাফত নামে সেই হারানো খেলাফত পুনরুদ্ধারে আওয়াজ তোলেন। উপমহাদেশে স্বাধীনতা লাভে যে আওয়াজ বড় ভূমিকা পালন করে।',
                    textSub: textSub,
                  ),

                  const SizedBox(height: 16),

                  _buildHistoryParagraphCard(
                    cardBg: cardBg,
                    borderColor: borderColor,
                    icon: Icons.auto_stories_rounded,
                    iconColor: const Color(0xFF0284C7),
                    title: 'বাংলাদেশ খেলাফত মজলিস প্রতিষ্ঠা',
                    text:
                        'তাহরিকে খেলাফতের ছয় দশক পরে স্বাধীন বাংলাদেশে এক মহান বুযুর্গ হযরত হাফেজ্জী হুজুর রহ. ১৯৮১ সালে খেলাফত আন্দোলন নামে সে আওয়াজের প্রতিধ্বনি তোলেন। হযরত হাফেজ্জীর ডাকে খেলাফতের পক্ষে গড়ে ওঠা গণজাগরণকে স্থায়ী ও সাংগঠনিক রূপদান করতে ইসলামী আন্দোলনের মহান রাহবার শাইখুল হাদীস আল্লামা আজিজুল হক রহ. ১৯৮৯ সালে প্রতিষ্ঠা করেন বাংলাদেশ খেলাফত মজলিস।',
                    textSub: textSub,
                  ),

                  const SizedBox(height: 16),

                  _buildHistoryParagraphCard(
                    cardBg: cardBg,
                    borderColor: borderColor,
                    icon: Icons.groups_rounded,
                    iconColor: primaryPurple,
                    title: 'ছাত্র মজলিসের শুভ যাত্রা (২৯ মে ২০০৯)',
                    text:
                        'আল্লাহর দ্বীনকে বিজয়ী করার এ চলমান প্রচেষ্টাকে বেগবান করার লক্ষ্যে আহলুসসুন্নাহ ওয়াল জামায়াতের আদর্শের ভিত্তিতে একটি শক্তিশালী সংগঠন গড়ার দীর্ঘমেয়াদী পরিকল্পনা নিয়ে ২৯ মে ২০০৯ পবিত্র জুমার দিনে জাতীয় মসজিদ বায়তুল মোকাররম থেকে যাত্রা শুরু করে বাংলাদেশ খেলাফত যুব মজলিস। পাশাপাশি ছাত্রসমাজের মধ্য থেকে দ্বীন বিজয়ের যোগ্য নেতৃত্ব গড়ে তোলার লক্ষ্যে প্রতিষ্ঠিত হয় বাংলাদেশ খেলাফত ছাত্র মজলিস।',
                    textSub: textSub,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryParagraphCard({
    required Color cardBg,
    required Color borderColor,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String text,
    required Color textSub,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: iconColor),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Text(
            text,
            style: TextStyle(fontSize: 14, height: 1.65, color: textSub),
          ),
        ],
      ),
    );
  }
}
