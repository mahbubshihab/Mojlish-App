import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../reports/presentation/screens/report_selection_screen.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import 'about/about_screen.dart';
import 'social_media/social_media_screen.dart';
import 'resources/resources_screen.dart';

class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slight off-white background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
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
            icon: const Icon(Icons.notifications, color: Colors.black87),
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
            const Text(
              'আসসালামু আলাইকুম,',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
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
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: Image.asset('assets/images/google_logo.png', height: 20),
                      label: const Text(
                        'ডাটা সিঙ্ক করতে গুগলে লগইন করুন',
                        style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 14),
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
            const Text(
              'মেনুসমূহ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF475569)),
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
                  iconBgColor: const Color(0xFFE0F2FE),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
                  },
                ),
                _buildMenuCard(
                  context,
                  title: 'রিপোর্টসমূহ',
                  icon: Icons.pie_chart,
                  iconColor: const Color(0xFF22C55E), // Green
                  iconBgColor: const Color(0xFFDCFCE7),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportSelectionScreen()));
                  },
                ),
                _buildMenuCard(
                  context,
                  title: 'সোশ্যাল মিডিয়া',
                  icon: Icons.share,
                  iconColor: const Color(0xFFF59E0B), // Orange
                  iconBgColor: const Color(0xFFFEF3C7),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SocialMediaScreen()));
                  },
                ),
                _buildMenuCard(
                  context,
                  title: 'রিসোর্স ও বই',
                  icon: Icons.menu_book,
                  iconColor: const Color(0xFF9333EA), // Purple
                  iconBgColor: const Color(0xFFF3E8FF),
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
  }

  Widget _buildMenuCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
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
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
