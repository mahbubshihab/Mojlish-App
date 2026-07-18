import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import '../../../reports/presentation/screens/report_selection_screen.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import 'about/about_screen.dart';
import 'social_media/social_media_screen.dart';
import 'resources/resources_screen.dart';

class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({super.key});

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
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                Text(
                  'আসসালামু আলাইকুম,',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: textTitle),
                ),
                const SizedBox(height: 6),
                const Text(
                  'মিজানুর রহমান',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                ),
                const SizedBox(height: 28),
                
                // Sync Data Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'আপনার রিপোর্টগুলো সুরক্ষিত রাখতে ও সিঙ্ক\nকরতে লগইন করুন',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: textMuted, height: 1.5),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: Image.asset('assets/images/google_logo.png', height: 20),
                          label: Text(
                            'ডাটা সিঙ্ক করতে গুগলে লগইন করুন',
                            style: TextStyle(color: textTitle, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // Menus Section
                Text(
                  'মেনুসমূহ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: menuHeaderColor),
                ),
                const SizedBox(height: 20),
                
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.95,
                  children: [
                    _buildMenuCard(
                      context,
                      title: 'পরিচিতি',
                      icon: Icons.badge,
                      iconColor: const Color(0xFF0EA5E9), // Light blue
                      iconBgColor: pBlueBg,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textTitle: textTitle,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
                      },
                    ),
                    _buildMenuCard(
                      context,
                      title: 'রিপোর্টসমূহ',
                      icon: Icons.pie_chart,
                      iconColor: const Color(0xFF22C55E), // Green
                      iconBgColor: pGreenBg,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textTitle: textTitle,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportSelectionScreen()));
                      },
                    ),
                    _buildMenuCard(
                      context,
                      title: 'সোশ্যাল মিডিয়া',
                      icon: Icons.share,
                      iconColor: const Color(0xFFF59E0B), // Orange
                      iconBgColor: pOrangeBg,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textTitle: textTitle,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SocialMediaScreen()));
                      },
                    ),
                    _buildMenuCard(
                      context,
                      title: 'রিসোর্স ও বই',
                      icon: Icons.menu_book,
                      iconColor: const Color(0xFF9333EA), // Purple
                      iconBgColor: pPurpleBg,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textTitle: textTitle,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ResourcesScreen()));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
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
