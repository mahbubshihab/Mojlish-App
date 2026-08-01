import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';

/// বাংলাদেশ খেলাফত ছাত্র মজলিস — আমাদের কার্যক্রম স্ক্রিন
class StudentActivitiesScreen extends StatelessWidget {
  const StudentActivitiesScreen({super.key});

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
        const primaryAmber = Color(0xFFD97706);

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
              'আমাদের কার্যক্রম — ছাত্র মজলিস',
              style: TextStyle(
                color: primaryAmber,
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
            primaryAccent: primaryAmber,
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
                          color: primaryAmber.withValues(alpha: 0.12),
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
                            color: primaryAmber.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.checklist_rtl_rounded, color: primaryAmber, size: 30),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'আমাদের সামগ্রিক কার্যক্রম',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textTitle),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'লক্ষ্য অর্জনের ক্রমধারা ও ৫ দফা কর্মসূচি',
                                style: TextStyle(fontSize: 12.5, color: textTitle.withValues(alpha: 0.7)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Section 1: Step Progress (লক্ষ্য অর্জনের ক্রমধারা)
                  Container(
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
                            Icon(Icons.track_changes_rounded, color: Color(0xFF0284C7), size: 22),
                            SizedBox(width: 10),
                            Text(
                              'লক্ষ্য অর্জনের ক্রমধারা (৪ ধাপ)',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'বাংলাদেশ খেলাফত ছাত্র মজলিস তার অভীষ্ট লক্ষ্যপানে পৌঁছার সুবিধার্থে তার পদক্ষেপকে চার ধাপে বিন্যস্ত করেছে:',
                          style: TextStyle(fontSize: 13.5, height: 1.5, color: textSub),
                        ),
                        const Divider(height: 20),
                        _buildActivityStepCard('১', 'যোগ্য ব্যক্তি গঠন', 'ইমলামের জন্য নিবেদিতপ্রাণ যোগ্য ব্যক্তি গঠন।', const Color(0xFF10B981), cardBg, textTitle, textSub),
                        _buildActivityStepCard('২', 'আদর্শ পরিবেশ গড়া', 'আদর্শ ইসলামী সমাজের পরিবেশ গড়া।', const Color(0xFF0284C7), cardBg, textTitle, textSub),
                        _buildActivityStepCard('৩', 'বাতিল প্রতিরোধ', 'বাতিল প্রতিরোধ ও ইসলামের গৌরব রক্ষায় বলিষ্ঠ ভূমিকা পালন।', const Color(0xFF8B5CF6), cardBg, textTitle, textSub),
                        _buildActivityStepCard('৪', 'সর্বাত্মক সংগ্রাম', 'রাষ্ট্র ও সমাজের সর্বক্ষেত্রে ইসলাম প্রতিষ্ঠার লক্ষ্যে সর্বাত্মক সংগ্রাম করা।', const Color(0xFFE11D48), cardBg, textTitle, textSub),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Section 2: 5-Point Program (পাঁচ দফা কর্মসূচী)
                  Container(
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
                            Icon(Icons.format_list_numbered_rounded, color: primaryAmber, size: 22),
                            SizedBox(width: 10),
                            Text(
                              'পাঁচ দফা কর্মসূচী',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryAmber),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'এই চারটি ধাপ অতিক্রম করার জন্য প্রণীত পাঁচ দফা কর্মসূচী:',
                          style: TextStyle(fontSize: 13.5, height: 1.5, color: textSub),
                        ),
                        const Divider(height: 20),
                        _buildProgramDetailItem(
                          icon: Icons.campaign_rounded,
                          title: '১. দাওয়াত',
                          description: 'ছাত্র সমাজের কাছে ইসলামের দাওয়াত ও ইসলামকে বিজয়ী করার লক্ষ্যে সংঘবদ্ধ হওয়ার আহ্বান জানানো।',
                          color: const Color(0xFF10B981),
                          textTitle: textTitle,
                          textSub: textSub,
                        ),
                        _buildProgramDetailItem(
                          icon: Icons.groups_rounded,
                          title: '২. সংগঠন',
                          description: 'সংগঠনের দাওয়াত গ্রহণকারী ছাত্রদেরকে সংগঠিত করা।',
                          color: const Color(0xFF0284C7),
                          textTitle: textTitle,
                          textSub: textSub,
                        ),
                        _buildProgramDetailItem(
                          icon: Icons.model_training_rounded,
                          title: '৩. প্রশিক্ষণ',
                          description: 'সংগঠিত ছাত্রদেরকে ইসলামী আন্দোলনের প্রশিক্ষিত জনশক্তিরূপে গড়ে তোলা।',
                          color: const Color(0xFF8B5CF6),
                          textTitle: textTitle,
                          textSub: textSub,
                        ),
                        _buildProgramDetailItem(
                          icon: Icons.volunteer_activism_rounded,
                          title: '৪. সমাজকল্যাণ',
                          description: '社会的 সর্বশ্রেণীর মানুষের প্রতি দায়িত্ব পালন ও ইসলামী আন্দোলনের অনুকূল পরিবেশ সৃষ্টির জন্য জনকল্যাণমূলক কাজ করা।',
                          color: const Color(0xFFD97706),
                          textTitle: textTitle,
                          textSub: textSub,
                        ),
                        _buildProgramDetailItem(
                          icon: Icons.shield_rounded,
                          title: '৫. আন্দোলন',
                          description: 'অন্যায়ের প্রতিবাদ ও ইসলামের গৌরব রক্ষায় বলিষ্ঠ ভূমিকা পালন এবং খেলাফত কায়েমের লক্ষ্যে সর্বাত্মক আন্দোলন গড়ে তোলা।',
                          color: const Color(0xFFE11D48),
                          textTitle: textTitle,
                          textSub: textSub,
                        ),
                      ],
                    ),
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

  Widget _buildActivityStepCard(String number, String title, String subtitle, Color color, Color cardBg, Color textTitle, Color textSub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color,
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textTitle)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 13, color: textSub)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramDetailItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Color textTitle,
    required Color textSub,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: textTitle)),
                const SizedBox(height: 3),
                Text(description, style: TextStyle(fontSize: 13.5, height: 1.45, color: textSub)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
