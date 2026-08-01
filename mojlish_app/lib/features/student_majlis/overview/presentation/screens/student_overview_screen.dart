import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';

/// বাংলাদেশ খেলাফত ছাত্র মজলিস — পরিচিতি ও তথ্যাবলী স্ক্রিন
class StudentOverviewScreen extends StatelessWidget {
  const StudentOverviewScreen({super.key});

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
        final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        const primaryGreen = Color(0xFF006A4E);

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
              'খেলাফত ছাত্র মজলিসের পরিচিতি',
              style: TextStyle(
                color: primaryGreen,
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
            primaryAccent: primaryGreen,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Banner Card
                  _buildHeaderBanner(cardBg, borderColor, textTitle, primaryGreen),

                  const SizedBox(height: 20),

                  // Introduction / Context Section
                  _buildSectionCard(
                    cardBg: cardBg,
                    borderColor: borderColor,
                    icon: Icons.menu_book_rounded,
                    iconColor: primaryGreen,
                    title: 'পরিচিতি',
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'সৃষ্টিজগতের সর্বশ্রেষ্ঠ মাখলুক হচ্ছে মানুষ। পবিত্র কুরআনের ভাষায় মানুষের প্রথম ও প্রধান পরিচয় হলো “মানুষ আল্লাহর খলীফা বা প্রতিনিধি”। এই পৃথিবীতে আল্লাহর প্রতিনিধিত্ব করার জন্য মহান আল্লাহ তার সকল সৃষ্টি থেকে মানুষকে নির্বাচন করেছেন। দিয়েছেন প্রতিনিধিত্বের মর্যাদা ও সম্মান। প্রতিনিধির কাজ হলো মালিকের মর্জি মোতাবেক সবকিছু পরিচালনা করা। তাই আল্লাহর জমিনে আল্লাহর আইন বাস্তবায়ন করা মানুষের দায়িত্ব।',
                          style: TextStyle(fontSize: 14.5, height: 1.6, color: textSub),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'মানবতার এ চরম দুর্দিনে বিশ্ববাসী আজ ভয়ানক উদ্বেগ ও উৎকণ্ঠা নিয়ে অপেক্ষমান এমন এক মযবুত সংঘবদ্ধ ঈমানী কাফেলার, যা হিম্মতের সাথে স্রোতের বিপরীতে দাঁড়িয়ে পৃথিবীর প্রান্তসীমায় খিলাফাহ আলা মিনহাজিন নাবুওয়াহর দাওয়াত পৌঁছে দেবে এবং বিপন্ন মানবতার সেবায় আত্মোৎসর্গী হবে। এ কাজের জন্য সবচেয়ে উপযুক্ত সময় হলো যৌবনকাল। ছাত্রজনতার অদম্য সাহস-নির্ভীকতা, বিপ্লবী মন-মানসিকতা, উদ্ভাবনমুখর মেধা-যোগ্যতা, তেজোদ্দীপ্ত চিন্তা-চেতনার সুন্দর সুষ্ঠু ব্যবহারই পারে একটি আদর্শ সুখের সমাজ ও রাষ্ট্র প্রতিষ্ঠা করতে। সেই ছাত্রজনতার উন্মুক্ত প্ল্যাটফর্ম বাংলাদেশ খেলাফত ছাত্র মজলিস।',
                          style: TextStyle(fontSize: 14.5, height: 1.6, color: textSub),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Call / আহ্বান Card
                  _buildCallCard(cardBg, borderColor, primaryGreen),

                  const SizedBox(height: 16),

                  // Aim and Objective (লক্ষ্য ও উদ্দেশ্য)
                  _buildSectionCard(
                    cardBg: cardBg,
                    borderColor: borderColor,
                    icon: Icons.ads_click_rounded,
                    iconColor: const Color(0xFF0284C7),
                    title: 'লক্ষ্য ও উদ্দেশ্য',
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBulletPoint('লক্ষ্য', 'এ‘লায়ে কালিমাতুল্লাহ্ তথা আল্লাহর দ্বীনকে বিজয়ী করা।', textTitle, textSub),
                        const SizedBox(height: 8),
                        _buildBulletPoint('উদ্দেশ্য', 'রেযায়ে মাওলা তথা আল্লাহর সন্তুষ্টি অর্জন।', textTitle, textSub),
                        const SizedBox(height: 14),
                        Text('লক্ষ্য অর্জনের ক্রমধারা (৪টি ধাপ):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textTitle)),
                        const SizedBox(height: 8),
                        _buildNumberedStep('১', 'ইসলামের জন্য নিবেদিতপ্রাণ যোগ্য ব্যক্তি গঠন।', textSub),
                        _buildNumberedStep('২', 'আদর্শ ইসলামী সমাজের পরিবেশ গড়া।', textSub),
                        _buildNumberedStep('৩', 'বাতিল প্রতিরোধ ও ইসলামের গৌরব রক্ষায় বলিষ্ঠ ভূমিকা পালন।', textSub),
                        _buildNumberedStep('৪', 'রাষ্ট্র ও সমাজের সর্বক্ষেত্রে ইসলাম প্রতিষ্ঠার লক্ষ্যে সর্বাত্মক সংগ্রাম করা।', textSub),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 5-Point Program (পাঁচ দফা কর্মসূচী)
                  _buildSectionCard(
                    cardBg: cardBg,
                    borderColor: borderColor,
                    icon: Icons.format_list_bulleted_rounded,
                    iconColor: const Color(0xFFD97706),
                    title: 'পাঁচ দফা কর্মসূচী',
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProgramItem('১. দাওয়াত', 'ছাত্র সমাজের কাছে ইসলামের দাওয়াত ও ইসলামকে বিজয়ী করার লক্ষ্যে সংঘবদ্ধ হওয়ার আহ্বান জানানো।', textTitle, textSub),
                        _buildProgramItem('২. সংগঠন', 'সংগঠনের দাওয়াত গ্রহণকারী ছাত্রদেরকে সংগঠিত করা।', textTitle, textSub),
                        _buildProgramItem('৩. প্রশিক্ষণ', 'সংগঠিত ছাত্রদেরকে ইসলামী আন্দোলনের প্রশিক্ষিত জনশক্তিরূপে গড়ে তোলা।', textTitle, textSub),
                        _buildProgramItem('৪. সমাজকল্যাণ', 'সংগঠিত সমাজের সর্বশ্রেণীর মানুষের প্রতি দায়িত্ব পালন ও জনকল্যাণমূলক কাজ করা।', textTitle, textSub),
                        _buildProgramItem('৫. আন্দোলন', 'অন্যায়ের প্রতিবাদ ও ইসলামের গৌরব রক্ষায় বলিষ্ঠ ভূমিকা পালন এবং খেলাফত কায়েমের লক্ষ্যে সর্বাত্মক আন্দোলন গড়ে তোলা।', textTitle, textSub),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Organizational Structure & Tiers (সাংগঠনিক কাঠামো ও স্তর)
                  _buildSectionCard(
                    cardBg: cardBg,
                    borderColor: borderColor,
                    icon: Icons.account_tree_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'সাংগঠনিক কাঠামো ও স্তর',
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('সাংগঠনিক কাঠামো:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textTitle)),
                        const SizedBox(height: 4),
                        Text(
                          'অভিভাবক পরিষদ, সভাপতি পরিষদ, কেন্দ্র, মহানগর শাখা, জেলা শাখা, থানা শাখা, ইউনিয়ন/ওয়ার্ড শাখা ও প্রাথমিক শাখার সমন্বয়ে গঠিত।',
                          style: TextStyle(fontSize: 13.5, height: 1.5, color: textSub),
                        ),
                        const SizedBox(height: 14),
                        Text('সাংগঠনিক ৪টি স্তর:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textTitle)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: const [
                            _TierChip(label: '১. সদস্য', color: Color(0xFF10B981)),
                            _TierChip(label: '২. কর্মী', color: Color(0xFF0284C7)),
                            _TierChip(label: '৩. সহযোগী সংগঠক', color: Color(0xFF8B5CF6)),
                            _TierChip(label: '৪. সংগঠক', color: Color(0xFFD97706)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Member / Worker Rules
                  _buildMemberRolesCard(cardBg, borderColor, textTitle, textSub, textMuted),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderBanner(Color cardBg, Color borderColor, Color textTitle, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
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
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/chatro_majlish.png',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(Icons.school_rounded, color: accentColor, size: 36),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'বাংলাদেশ খেলাফত ছাত্র মজলিস',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textTitle),
                ),
                const SizedBox(height: 4),
                Text(
                  'নিবন্ধিত ছাত্র সংগঠন — পরিচিতি ও মূলনীতি',
                  style: TextStyle(fontSize: 12.5, color: textTitle.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required Color cardBg,
    required Color borderColor,
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget contentWidget,
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
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: iconColor),
              ),
            ],
          ),
          const Divider(height: 20),
          contentWidget,
        ],
      ),
    );
  }

  Widget _buildCallCard(Color cardBg, Color borderColor, Color primaryGreen) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryGreen.withValues(alpha: 0.15),
            primaryGreen.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.campaign_rounded, color: primaryGreen, size: 22),
              const SizedBox(width: 10),
              Text(
                'বিপ্লবপ্রিয় ছাত্রবন্ধুদের প্রতি আহ্বান',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryGreen),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'আসুন, অলসতা আর শিথিলতা ঝেড়ে ফেলে, লোভ লালসা উপড়ে তুলে, আল্লাহর দেওয়া সাহস হিম্মত বুকে নিয়ে একটি আদর্শ সমাজ বিনির্মাণে ঐক্যবদ্ধ হই। ইসলাম ও দেশবিরোধী সকল শক্তিকে চ্যালেঞ্জ করে হৃদয়ে একটি আদর্শ খেলাফত রাষ্ট্রব্যবস্থার স্বপ্ন বুনি।\n\nআল্লাহর দেওয়া শৌর্যবীর্য ও শক্তিমত্তা আল্লাহর রাস্তায় বিলিয়ে মানুষ ও মানবতার মুক্তির স্লোগান তুলি। আছেন কি কেউ এই আহ্বানে সাড়া দেবার?',
            style: TextStyle(fontSize: 13.5, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String label, String text, Color textTitle, Color textSub) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textTitle)),
        Expanded(
          child: Text(text, style: TextStyle(fontSize: 14, height: 1.4, color: textSub)),
        ),
      ],
    );
  }

  Widget _buildNumberedStep(String number, String text, Color textSub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            alignment: Alignment.center,
            child: Text(number, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0284C7))),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 13.5, height: 1.4, color: textSub)),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramItem(String title, String desc, Color textTitle, Color textSub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textTitle)),
          const SizedBox(height: 2),
          Text(desc, style: TextStyle(fontSize: 13.5, height: 1.4, color: textSub)),
        ],
      ),
    );
  }

  Widget _buildMemberRolesCard(Color cardBg, Color borderColor, Color textTitle, Color textSub, Color textMuted) {
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
          const Row(
            children: [
              Icon(Icons.assignment_ind_rounded, color: Color(0xFF10B981), size: 22),
              SizedBox(width: 10),
              Text(
                'সদস্য ও কর্মীর দায়িত্বাবলী',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
              ),
            ],
          ),
          const Divider(height: 20),
          Text('সদস্যের প্রাথমিক কাজ:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textTitle)),
          const SizedBox(height: 6),
          Text('• ইবাদাত: পাঁচ ওয়াক্ত নামায জামাতে আদায় করা ও নিয়মিত কুরআন তিলাওয়াত করা।', style: TextStyle(fontSize: 13.5, height: 1.5, color: textSub)),
          Text('• পড়ালেখা: প্রাতিষ্ঠানিক ক্লাসের পড়ালেখায় যত্নবান হওয়া ও সদস্য সিলেবাস সম্পন্ন করা।', style: TextStyle(fontSize: 13.5, height: 1.5, color: textSub)),
          Text('• সাংগঠনিক: নিয়মিত ব্যক্তিগত রিপোর্ট সংরক্ষণ, বায়তুলমালে এয়ানত প্রদান ও কর্মসূচিতে অংশ নেওয়া।', style: TextStyle(fontSize: 13.5, height: 1.5, color: textSub)),
        ],
      ),
    );
  }
}

class _TierChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TierChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
