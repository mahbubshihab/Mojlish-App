import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_theme.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: null,
        automaticallyImplyLeading: false,
        title: const Text(
          'ড্যাশবোর্ড',
          style: TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              'আসসালামু আলাইকুম,',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24, color: AppTheme.textDark),
            ),
            const SizedBox(height: 4),
            const Text(
              'মিজানুর রহমান',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 24),
            
            // Sync Data Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'আপনার রিপোর্টগুলো সুরক্ষিত রাখতে ও সিঙ্ক\\nকরতে লগইন করুন',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.google, color: Colors.blue, size: 20), // Colored google logo needs custom or just colored icon. Using blue here or default.
                      label: const Text(
                        'ডাটা সিঙ্ক করতে গুগলে লগইন করুন',
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Menus Section
            const Text(
              'মেনুসমূহ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textLight),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.0, // Make it square
              children: [
                _buildMenuCard(
                  context,
                  title: 'পরিচিতি',
                  icon: Icons.badge,
                  iconColor: Colors.blue,
                  iconBgColor: Colors.blue.shade50,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
                  },
                ),
                _buildMenuCard(
                  context,
                  title: 'রিপোর্টসমূহ',
                  icon: Icons.pie_chart,
                  iconColor: Colors.green,
                  iconBgColor: Colors.green.shade50,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportSelectionScreen()));
                  },
                ),
                _buildMenuCard(
                  context,
                  title: 'সোশ্যাল মিডিয়া',
                  icon: Icons.share,
                  iconColor: Colors.orange,
                  iconBgColor: Colors.orange.shade50,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SocialMediaScreen()));
                  },
                ),
                _buildMenuCard(
                  context,
                  title: 'রিসোর্স ও বই',
                  icon: Icons.menu_book,
                  iconColor: Colors.purple,
                  iconBgColor: Colors.purple.shade50,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ResourcesScreen()));
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
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
    Color? borderColor,
    bool isNew = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor ?? Colors.grey.shade100, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: iconColor, size: 32),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          if (isNew)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
