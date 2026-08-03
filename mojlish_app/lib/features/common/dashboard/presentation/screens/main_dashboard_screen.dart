import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/services/user_storage_service.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import '../../../reports/presentation/screens/report_selection_screen.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import 'package:mojlish_app/core/services/notification_service.dart';
import 'social_media/social_media_screen.dart';
import 'books/books_screen.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_book_screen.dart';

import 'package:mojlish_app/features/khelafat_majlis/syllabi/khelafot_syllabus/presentation/pages/khelafot_syllabus_page.dart';
import 'package:mojlish_app/features/women_majlis/call_manifesto/presentation/pages/call_manifesto_page.dart' as women_manifesto;
import 'package:mojlish_app/features/khelafat_majlis/executive_rules/presentation/pages/executive_rules_page.dart';
import 'package:mojlish_app/features/khelafat_majlis/overview/presentation/pages/overview_page.dart' as khelafat_overview;
import 'package:mojlish_app/features/women_majlis/overview/presentation/pages/overview_page.dart' as women_overview;
import 'package:mojlish_app/features/youth_majlis/overview/presentation/pages/overview_screen.dart' as youth_overview;
import 'package:mojlish_app/features/student_majlis/overview/presentation/screens/student_overview_screen.dart' as student_overview;
import 'package:mojlish_app/features/student_majlis/history/presentation/screens/student_history_screen.dart' as student_history;
import 'package:mojlish_app/features/student_majlis/activities/presentation/screens/student_activities_screen.dart' as student_activities;
import 'package:mojlish_app/features/common/profile/presentation/screens/profile_screen.dart';

// Khelafat Reports & Forms
import 'package:mojlish_app/features/khelafat_majlis/branch_report/presentation/screens/khelafat_branch_report_book_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/branch_plan/presentation/screens/khelafat_branch_plan_book_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/zonal_report/presentation/screens/zonal_report_book_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/member_form/presentation/screens/member_form_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/baytulmal_report/presentation/screens/khelafat_baytulmal_report_book_screen.dart';

// Youth Reports & Forms
import 'package:mojlish_app/features/youth_majlis/member_form/presentation/screens/member_form_screen.dart' as youth_form;
import 'package:mojlish_app/features/youth_majlis/call_manifesto/presentation/screens/call_manifesto_screen.dart';

// Student Reports & Forms
import 'package:mojlish_app/features/student_majlis/member_form/presentation/screens/member_form_screen.dart' as chatro_form;
import 'package:mojlish_app/features/student_majlis/period_report/presentation/screens/student_period_report_book_screen.dart';
import 'package:mojlish_app/features/student_majlis/baytulmal_report/presentation/screens/chatro_baytulmal_report_book_screen.dart';

// Labor Reports & Forms
import 'package:mojlish_app/features/labor_majlis/member_form/presentation/screens/member_form_screen.dart';

// Women Reports & Forms
import 'package:mojlish_app/features/women_majlis/resources/ahobban_mohila/presentation/screens/ahobban_screen.dart';

import 'package:mojlish_app/core/services/network_connectivity_service.dart';
import 'package:mojlish_app/core/services/offline_sync_manager.dart';

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
    NetworkConnectivityService().initialize();
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
            centerTitle: false,
            titleSpacing: 16,
            leading: null,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    MajlisAssets.getLogoPath(_selectedMajlis),
                    height: 28,
                    width: 28,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Image.asset(
                      MajlisAssets.khelafatLogo,
                      height: 28,
                      width: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _selectedMajlis,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
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
              StreamBuilder<int>(
                stream: NotificationService.getUnreadCountStream(),
                builder: (context, snapshot) {
                  final unreadCount = snapshot.data ?? 0;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications, color: isDark ? const Color(0xFFE2E8F0) : Colors.black87),
                        onPressed: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                          setState(() {});
                        },
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : '$unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
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
                  padding: const EdgeInsets.only(right: 16.0, left: 4.0),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting & User Name Header
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'আসসালামু আলাইকুম',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _userName,
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                              color: textTitle,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Real-time Network Connectivity & Offline Auto-Sync Banner
                      _buildConnectivityBanner(context, isDark: isDark),

                      const SizedBox(height: 20),

                      // Section 1: Top Organizational Menus Grid
                      Text(
                        '$_selectedMajlis — প্রধান মেনুসমূহ',
                        style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800, color: menuHeaderColor),
                      ),
                      const SizedBox(height: 14),
                      
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1.05,
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
                      const SizedBox(height: 28),

                      // Section 2: Direct Quick Reports & Forms List on Dashboard
                      _buildQuickReportsSection(
                        context,
                        selectedMajlis: _selectedMajlis,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textTitle: textTitle,
                        textMuted: textMuted,
                        isDark: isDark,
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

    // 1. Central Reports & Forms Hub Card
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

    // 2. Specific Overview Page
    if (!selectedMajlis.contains('শ্রমিক')) {
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
            } else if (selectedMajlis == 'ছাত্র মজলিস') {
              page = const student_overview.StudentOverviewScreen();
            } else {
              page = const khelafat_overview.OverviewPage();
            }
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          },
        ),
      );
    }

    // 3. Special Features according to Selected Majlis
    if (selectedMajlis == 'ছাত্র মজলিস') {
      cards.add(
        _buildMenuCard(
          context,
          title: 'ইতিকথা',
          icon: Icons.history_edu_rounded,
          iconColor: const Color(0xFF9333EA),
          iconBgColor: pPurpleBg,
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const student_history.StudentHistoryScreen()));
          },
        ),
      );
      cards.add(
        _buildMenuCard(
          context,
          title: 'আমাদের কার্যক্রম',
          icon: Icons.checklist_rtl_rounded,
          iconColor: const Color(0xFFD97706),
          iconBgColor: pOrangeBg,
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const student_activities.StudentActivitiesScreen()));
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

    // 4. Syllabus / Executive Rules for Khelafat
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

    // 5. Social Media Card
    cards.add(
      _buildMenuCard(
        context,
        title: 'সোশ্যাল মিডিয়া',
        icon: Icons.share_rounded,
        iconColor: const Color(0xFF0EA5E9),
        iconBgColor: pBlueBg,
        cardBg: cardBg,
        borderColor: borderColor,
        textTitle: textTitle,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SocialMediaScreen()));
        },
      ),
    );

    // 6. Dedicated Books & Library Card
    cards.add(
      _buildMenuCard(
        context,
        title: 'বই ও প্রকাশনা',
        icon: Icons.auto_stories_rounded,
        iconColor: const Color(0xFFF59E0B),
        iconBgColor: pOrangeBg,
        cardBg: cardBg,
        borderColor: borderColor,
        textTitle: textTitle,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const BooksScreen()));
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
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 12,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 30),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: textTitle),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickReportsSection(
    BuildContext context, {
    required String selectedMajlis,
    required Color cardBg,
    required Color borderColor,
    required Color textTitle,
    required Color textMuted,
    required bool isDark,
  }) {
    final parsedMajlisType = MajlisTypeExtension.fromString(selectedMajlis);
    bool isKhelafat = parsedMajlisType == MajlisType.khelafat;
    bool isYouth = parsedMajlisType == MajlisType.jubo;
    bool isChatro = parsedMajlisType == MajlisType.chatro;
    bool isLabor = parsedMajlisType == MajlisType.sromik;
    bool isWomen = parsedMajlisType == MajlisType.mohila;

    List<Widget> reportTiles = [];

    // 1. Personal Report (Always Available for all Majlises)
    reportTiles.add(
      _buildQuickReportTile(
        context,
        title: 'ব্যক্তিগত তৎপরতার রিপোর্ট',
        subtitle: 'মাসিক রিপোর্ট বই ও দৈনিক এন্ট্রি ফরম',
        icon: Icons.person_outline_rounded,
        color: const Color(0xFF10B981),
        cardBg: cardBg,
        borderColor: borderColor,
        textTitle: textTitle,
        textMuted: textMuted,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReportBookScreen(majlisType: parsedMajlisType),
            ),
          );
        },
      ),
    );

    // Khelafat Specific Reports & Forms
    if (isKhelafat) {
      reportTiles.add(
        _buildQuickReportTile(
          context,
          title: 'শাখার সাংগঠনিক রিপোর্ট',
          subtitle: 'শাখাভিত্তিক বিবরণী ও ১২ মাসের রিপোর্ট',
          icon: Icons.corporate_fare_rounded,
          color: const Color(0xFF2563EB),
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          textMuted: textMuted,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KhelafatBranchReportBookScreen()),
            );
          },
        ),
      );
      reportTiles.add(
        _buildQuickReportTile(
          context,
          title: 'শাখার বার্ষিক/মাসিক পরিকল্পনা',
          subtitle: 'শাখার বার্ষিক ও দ্বিমাসিক লক্ষ্যমাত্রা',
          icon: Icons.assignment_turned_in_rounded,
          color: const Color(0xFF8B5CF6),
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          textMuted: textMuted,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KhelafatBranchPlanBookScreen()),
            );
          },
        ),
      );
      reportTiles.add(
        _buildQuickReportTile(
          context,
          title: 'বায়তুলমাল ও আর্থিক হিসাব',
          subtitle: 'বায়তুলমাল আয়-ব্যয় সংক্রান্ত বই',
          icon: Icons.account_balance_wallet_rounded,
          color: const Color(0xFFD97706),
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          textMuted: textMuted,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KhelafatBaytulmalReportBookScreen()),
            );
          },
        ),
      );
      reportTiles.add(
        _buildQuickReportTile(
          context,
          title: 'জোনাল রিপোর্ট ফরম',
          subtitle: 'জোনভিত্তিক সাংগঠনিক প্রতিবেদন',
          icon: Icons.map_rounded,
          color: const Color(0xFF0284C7),
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          textMuted: textMuted,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ZonalReportBookScreen()),
            );
          },
        ),
      );
      reportTiles.add(
        _buildQuickReportTile(
          context,
          title: 'প্রাথমিক সদস্য ফরম (আবেদন)',
          subtitle: 'নতুন সদস্য যোগদানের আবেদন ফরম',
          icon: Icons.badge_rounded,
          color: const Color(0xFFEC4899),
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          textMuted: textMuted,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MemberFormScreen()),
            );
          },
        ),
      );
    }

    // Chatro Specific Reports & Forms
    if (isChatro) {
      reportTiles.add(
        _buildQuickReportTile(
          context,
          title: 'বার্ষিক / ষান্মাসিক / দ্বি-মাসিক রিপোর্ট',
          subtitle: 'মেয়াদভিত্তিক বিস্তারিত রিপোর্ট বই',
          icon: Icons.date_range_rounded,
          color: const Color(0xFF2563EB),
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          textMuted: textMuted,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StudentPeriodReportBookScreen()),
            );
          },
        ),
      );
      reportTiles.add(
        _buildQuickReportTile(
          context,
          title: 'বায়তুলমাল রিপোর্ট',
          subtitle: 'বায়তুলমাল আয়-ব্যয় এর মাসওয়ারি হিসাব',
          icon: Icons.account_balance_wallet_rounded,
          color: const Color(0xFFD97706),
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          textMuted: textMuted,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatroBaytulmalReportBookScreen()),
            );
          },
        ),
      );
      reportTiles.add(
        _buildQuickReportTile(
          context,
          title: 'প্রাথমিক সদস্য ফরম',
          subtitle: 'ছাত্র মজলিসের প্রাথমিক সদস্য আবেদন',
          icon: Icons.badge_rounded,
          color: const Color(0xFFEC4899),
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          textMuted: textMuted,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const chatro_form.ChatroMemberFormScreen()),
            );
          },
        ),
      );
    }

    // Youth Specific Reports & Forms
    if (isYouth) {
      reportTiles.add(
        _buildQuickReportTile(
          context,
          title: 'দাওয়াতী ইশতেহার ও ম্যানিফেস্টো',
          subtitle: 'যুব মজলিস দাওয়াতী ম্যানিফেস্টো',
          icon: Icons.auto_stories_rounded,
          color: const Color(0xFF0284C7),
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          textMuted: textMuted,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const YouthCallManifestoScreen()),
            );
          },
        ),
      );
      reportTiles.add(
        _buildQuickReportTile(
          context,
          title: 'যুব মজলিস — প্রাথমিক সদস্য আবেদন ফরম',
          subtitle: 'প্রাথমিক সদস্যপদ ফরম ও প্রিভিউ',
          icon: Icons.badge_rounded,
          color: const Color(0xFFEC4899),
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          textMuted: textMuted,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const youth_form.YouthMemberFormScreen()),
            );
          },
        ),
      );
    }

    // Labor Specific Reports & Forms
    if (isLabor) {
      reportTiles.add(
        _buildQuickReportTile(
          context,
          title: 'শ্রমিক মজলিস — প্রাথমিক সদস্য আবেদন ফরম',
          subtitle: 'শ্রমিক সদস্য আবেদন ও নিবন্ধকরণ ফরম',
          icon: Icons.badge_rounded,
          color: const Color(0xFFEC4899),
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          textMuted: textMuted,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LaborMemberFormScreen()),
            );
          },
        ),
      );
    }

    // Women Specific Reports & Forms
    if (isWomen) {
      reportTiles.add(
        _buildQuickReportTile(
          context,
          title: 'মহিলা মজলিস — আমাদের আহ্বান ও ম্যানিফেস্টো',
          subtitle: 'আমাদের আহ্বান সংক্রান্ত বিষয়াবলী',
          icon: Icons.auto_stories_rounded,
          color: const Color(0xFFE11D48),
          cardBg: cardBg,
          borderColor: borderColor,
          textTitle: textTitle,
          textMuted: textMuted,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AhobbanMohilaScreen()),
            );
          },
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.assignment_rounded, color: Color(0xFF10B981), size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'রিপোর্ট ও ফরমসমূহ',
                      style: TextStyle(
                        fontSize: 17.5,
                        fontWeight: FontWeight.w900,
                        color: textTitle,
                      ),
                    ),
                    Text(
                      'সরাসরি ফরম জমা বা রিপোর্ট বুক খুলুন',
                      style: TextStyle(
                        fontSize: 12,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
              ),
              child: Text(
                '${reportTiles.length} টি আইটেম',
                style: const TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reportTiles.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, index) => reportTiles[index],
        ),
      ],
    );
  }

  Widget _buildQuickReportTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color cardBg,
    required Color borderColor,
    required Color textTitle,
    required Color textMuted,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 23),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textTitle,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: textMuted,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectivityBanner(BuildContext context, {required bool isDark}) {
    return ValueListenableBuilder<bool>(
      valueListenable: NetworkConnectivityService().isOnlineNotifier,
      builder: (context, isOnline, _) {
        return ValueListenableBuilder<int>(
          valueListenable: OfflineSyncManager.pendingCountNotifier,
          builder: (context, pendingCount, _) {
            final isGreen = isOnline && pendingCount == 0;
            final color = isGreen ? const Color(0xFF10B981) : const Color(0xFFF59E0B);
            final bgColor = color.withValues(alpha: isDark ? 0.15 : 0.1);
            final borderColor = color.withValues(alpha: 0.3);

            String statusText;
            if (isOnline) {
              statusText = pendingCount > 0
                  ? 'অনলাইন — সিঙ্ক হচ্ছে ($pendingCount টি সিঙ্ক অপেক্ষমাণ)'
                  : 'অনলাইন — সার্ভারে সিঙ্কড (লাইভ)';
            } else {
              statusText = pendingCount > 0
                  ? 'অফলাইন মোড — ডেটা কুইকে জমা আছে ($pendingCount টি সিঙ্ক অপেক্ষমাণ)'
                  : 'অফলাইন মোড — ডেটা লোকালি সংরক্ষিত হচ্ছে';
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor, width: 1.2),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                      color: color,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? color.withValues(alpha: 0.95) : color.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                  if (pendingCount > 0 && isOnline)
                    GestureDetector(
                      onTap: () => OfflineSyncManager.syncPendingQueue(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'সিঙ্ক করুন',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
