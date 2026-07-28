import 'package:flutter/material.dart';

import '../baytulmal_report/presentation/pages/baytulmal_report_book_screen.dart';
import '../general_plan/presentation/pages/general_plan_book_screen.dart';
import '../period_plan/presentation/pages/period_plan_book_screen.dart';
import '../period_report/presentation/pages/period_report_book_screen.dart';
import '../personal_plan/presentation/pages/personal_plan_book_screen.dart';
import '../personal_report/presentation/pages/personal_report_book_screen.dart';
import '../member_form/presentation/screens/member_form_screen.dart';

class StudentHubScreen extends StatelessWidget {
  const StudentHubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF006A4E);
    final scaffoldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'ছাত্র মজলিস হাব',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, const Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'রিপোর্ট, পরিকল্পনা ও সাংগঠনিক মডিউলসমূহ',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFA7F3D0),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'রিপোর্ট ও পরিকল্পনা বইসমূহ',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),

            // 1. Personal Report Book (opens PersonalReportBookScreen first)
            _buildFeatureCard(
              context,
              title: 'ব্যক্তিগত রিপোর্ট বই',
              subtitle: 'মাসিক ব্যক্তিগত তৎপরতার রিপোর্ট',
              icon: Icons.person_outline_rounded,
              iconBg: const Color(0xFF059669),
              cardBg: cardBg,
              textColor: textColor,
              subtextColor: subtextColor,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonalReportBookScreen(),
                  ),
                );
              },
            ),

            // 2. Personal Plan Book (opens PersonalPlanBookScreen first)
            _buildFeatureCard(
              context,
              title: 'ব্যক্তিগত পরিকল্পনা বই',
              subtitle: 'মাসিক ব্যক্তিগত পরিকল্পনা',
              icon: Icons.edit_calendar_rounded,
              iconBg: const Color(0xFF7C3AED),
              cardBg: cardBg,
              textColor: textColor,
              subtextColor: subtextColor,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonalPlanBookScreen(),
                  ),
                );
              },
            ),

            // 3. Period Report Book (opens PeriodReportBookScreen first)
            _buildFeatureCard(
              context,
              title: 'পর্যায়ভিত্তিক রিপোর্ট বই',
              subtitle: 'মেয়াদী/পর্যায়ভিত্তিক সাংগঠনিক রিপোর্ট',
              icon: Icons.assessment_outlined,
              iconBg: const Color(0xFF0284C7),
              cardBg: cardBg,
              textColor: textColor,
              subtextColor: subtextColor,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PeriodReportBookScreen(),
                  ),
                );
              },
            ),

            // 4. Period Plan Book (opens PeriodPlanBookScreen first)
            _buildFeatureCard(
              context,
              title: 'পর্যায়ভিত্তিক পরিকল্পনা বই',
              subtitle: 'বার্ষিক/ষান্মাসিক/দ্বি-মাসিক পর্যায়ভিত্তিক পরিকল্পনা',
              icon: Icons.next_plan_outlined,
              iconBg: const Color(0xFF2563EB),
              cardBg: cardBg,
              textColor: textColor,
              subtextColor: subtextColor,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PeriodPlanBookScreen(),
                  ),
                );
              },
            ),

            // 5. General Plan Book (opens GeneralPlanBookScreen first)
            _buildFeatureCard(
              context,
              title: 'সাধারণ পরিকল্পনা বই',
              subtitle: 'শাখা ও স্তরের সাধারণ পরিকল্পনা',
              icon: Icons.playlist_add_check_circle_outlined,
              iconBg: const Color(0xFF0D9488),
              cardBg: cardBg,
              textColor: textColor,
              subtextColor: subtextColor,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GeneralPlanBookScreen(),
                  ),
                );
              },
            ),

            // 6. Baytulmal Report Book (opens BaytulmalReportBookScreen first)
            _buildFeatureCard(
              context,
              title: 'বায়তুলমাল রিপোর্ট বই',
              subtitle: 'বায়তুলমাল আয়-ব্যয় হিসাব ও রিপোর্ট',
              icon: Icons.account_balance_wallet_outlined,
              iconBg: const Color(0xFF006A4E),
              cardBg: cardBg,
              textColor: textColor,
              subtextColor: subtextColor,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BaytulmalReportBookScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            Text(
              'অন্যান্য ফরম ও সুবিধা',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),

            // 7. Member Form
            _buildFeatureCard(
              context,
              title: 'সদস্য ফরম',
              subtitle: 'নতুন সদস্য/কর্মী নিবন্ধন ও আবেদনের ফরম',
              icon: Icons.assignment_ind_outlined,
              iconBg: const Color(0xFFD97706),
              cardBg: cardBg,
              textColor: textColor,
              subtextColor: subtextColor,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MemberFormScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color cardBg,
    required Color textColor,
    required Color subtextColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: iconBg,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.5,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12.5, color: subtextColor),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}
