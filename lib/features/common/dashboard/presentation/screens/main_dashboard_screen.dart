import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/services/user_storage_service.dart';
import '../../../reports/presentation/screens/report_selection_screen.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import 'social_media/social_media_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/syllabi/khelafot_syllabus/presentation/pages/khelafot_syllabus_page.dart';
import 'package:mojlish_app/features/women_majlis/call_manifesto/presentation/pages/call_manifesto_page.dart' as women_manifesto;
import 'package:mojlish_app/features/khelafat_majlis/executive_rules/presentation/pages/executive_rules_page.dart';
import 'package:mojlish_app/features/khelafat_majlis/overview/presentation/pages/overview_page.dart' as khelafat_overview;
import 'package:mojlish_app/features/women_majlis/overview/presentation/pages/overview_page.dart' as women_overview;
import 'package:mojlish_app/features/youth_majlis/overview/presentation/pages/overview_screen.dart' as youth_overview;
import 'package:mojlish_app/features/student_majlis/period_plan/presentation/screens/student_period_plan_book_screen.dart' as student_plan;
import 'package:mojlish_app/features/common/profile/presentation/screens/profile_screen.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  String _selectedMajlis = 'খেলাফত মজলিস';
  String _userName = 'মিজানুর রহমান';
  String _userPhotoUrl = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final majlis = await UserStorageService.getActiveMajlis();
    final userName = await UserStorageService.getUserName();
    final photoUrl = await UserStorageService.getUserPhotoUrl();
    if (mounted) {
      setState(() {
        _selectedMajlis = (majlis != null && majlis.isNotEmpty) ? majlis : 'খেলাফত মজলিস';
        _userName = userName.isNotEmpty ? userName : 'সম্মানিত সদস্য';
        _userPhotoUrl = photoUrl;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;

        // Theme colors
        final scaffoldBg = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
        final appBarBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
        final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);
        final textTitle = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
        final textMuted = isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600;
        final menuHeaderColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

        // Menu colors
        final pBlueBg = isDark ? const Color(0xFF0B2E4E) : const Color(0xFFE0F2FE);
        final pGreenBg = isDark ? const Color(0xFF063A2F) : const Color(0xFFDCFCE7);
        final pOrangeBg = isDark ? const Color(0xFF4E2B0B) : const Color(0xFFFEF3C7);
        final pPurpleBg = isDark ? const Color(0xFF3B0B5E) : const Color(0xFFF3E8FF);

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: 0,
            centerTitle: true,
            leading: null,
            automaticallyImplyLeading: false,
            title: const Text(
              'ড্যাশবোর্ড',
              style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 20),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.wb_sunny : Icons.nightlight_round,
                  color: isDark ? Colors.yellow : Colors.black87,
                ),
                tooltip: isDark ? 'হালকা থিম' : 'ডার্ক থিম',
                onPressed: () {
                  themeManager.toggleTheme();
                },
              ),
              IconButton(
                icon: Icon(Icons.notifications, color: isDark ? const Color(0xFFE2E8F0) : Colors.black87),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                },
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                  _loadUserData();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 8.0),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF059669).withValues(alpha: 0.15),
                    backgroundImage: _userPhotoUrl.isNotEmpty ? NetworkImage(_userPhotoUrl) : null,
                    child: _userPhotoUrl.isEmpty
                        ? Text(
                            _userName.isNotEmpty ? _userName[0] : 'ম',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF059669),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting & Active Majlis Badge
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'আসসালামু আলাইকুম',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _userName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: textTitle,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      const SizedBox(height: 24),

                      // Menus Section title
                      Text(
                        '$_selectedMajlis — মেনুসমূহ',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: menuHeaderColor),
                      ),
                      const SizedBox(height: 16),
                      
                      // Filtered Menu Cards according to Selected Majlis
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.95,
                        children: _buildMajlisMenuCards(
                          context,
                          selectedMajlis: _selectedMajlis,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textTitle: textTitle,
                          pGreenBg: pGreenBg,
                          pBlueBg: pBlueBg,
                          pPurpleBg: pPurpleBg,
                          pOrangeBg: pOrangeBg,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
        );
      },
    );
  }

  List<Widget> _buildMajlisMenuCards(
    BuildContext context, {
    required String selectedMajlis,
    required Color cardBg,
    required Color borderColor,
    required Color textTitle,
    required Color pGreenBg,
    required Color pBlueBg,
    required Color pPurpleBg,
    required Color pOrangeBg,
  }) {
    List<Widget> cards = [];

    // 1. Central Reports & Forms Hub (Always first, configured for selectedMajlis)
    cards.add(
      _buildMenuCard(
        context,
        title: 'রিপোর্ট ও ফরম কেন্দ্র',
        icon: Icons.assignment_turned_in_rounded,
        iconColor: const Color(0xFF22C55E),
        iconBgColor: pGreenBg,
        cardBg: cardBg,
        borderColor: borderColor,
        textTitle: textTitle,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ReportSelectionScreen(majlisName: selectedMajlis)),
          );
        },
      ),
    );

    // 2. Specific Overview for Selected Majlis
    cards.add(
      _buildMenuCard(
        context,
        title: 'সংক্ষিপ্ত পরিচিতি',
        icon: Icons.info_outline_rounded,
        iconColor: const Color(0xFF0EA5E9),
        iconBgColor: pBlueBg,
        cardBg: cardBg,
        borderColor: borderColor,
        textTitle: textTitle,
        onTap: () {
          Widget page;
          if (selectedMajlis == 'মহিলা মজলিস') {
            page = const women_overview.WomenMajlisOverviewPage();
          } else if (selectedMajlis == 'যুব মজলিস') {
            page = const youth_overview.OverviewScreen();
          } else {
            page = const khelafat_overview.OverviewPage();
          }
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );

    // 3. Manifesto / Call / Plan
    if (selectedMajlis == 'ছাত্র মজলিস') {
      cards.add(
        _buildMenuCard(
          context,
          title: 'কর্ম পরিকল্পনা',
          icon: Icons.assignment_outlined,
          iconColor: const Color(0xFF9333EA),
          iconBgColor: pPurpleBg,
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const student_plan.StudentPeriodPlanBookScreen()));
          },
        ),
      );
    } else if (selectedMajlis == 'মহিলা মজলিস') {
      cards.add(
        _buildMenuCard(
          context,
          title: 'আমাদের আহ্বান',
          icon: Icons.campaign_rounded,
          iconColor: const Color(0xFFE11D48),
          iconBgColor: pPurpleBg,
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const women_manifesto.CallManifestoPage()));
          },
        ),
      );
    }

    // 4. Syllabus / Executive Rules
    if (selectedMajlis == 'খেলাফত মজলিস') {
      cards.add(
        _buildMenuCard(
          context,
          title: 'সিলেবাস ও পাঠক্রম',
          icon: Icons.menu_book_rounded,
          iconColor: const Color(0xFF059669),
          iconBgColor: pGreenBg,
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const KhelafotSyllabusPage()));
          },
        ),
      );
      cards.add(
        _buildMenuCard(
          context,
          title: 'কার্যপ্রণালী',
          icon: Icons.gavel_rounded,
          iconColor: const Color(0xFF9333EA),
          iconBgColor: pPurpleBg,
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ExecutiveRulesPage()));
          },
        ),
      );
    }

    // 5. Social Media & Resources (Always available)
    cards.add(
      _buildMenuCard(
        context,
        title: 'সোশ্যাল মিডিয়া ও বই',
        icon: Icons.share_rounded,
        iconColor: const Color(0xFFF59E0B),
        iconBgColor: pOrangeBg,
        cardBg: cardBg,
        borderColor: borderColor,
        textTitle: textTitle,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SocialMediaScreen()));
        },
      ),
    );

    return cards;
  }


  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required Color cardBg,
    required Color borderColor,
    required Color textTitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 15,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: iconColor, size: 36),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textTitle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
