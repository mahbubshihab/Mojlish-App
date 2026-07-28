import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/services/user_storage_service.dart';
import 'org_selection_screen.dart';
import '../../../dashboard/presentation/screens/main_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSavedMajlisAndNavigate();
  }

  Future<void> _checkSavedMajlisAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    final hasSaved = await UserStorageService.hasSavedMajlis();
    if (!mounted) return;

    if (hasSaved) {
      // Direct entry to Dashboard if Majlis is already selected!
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainDashboardScreen()),
      );
    } else {
      // First-time selection page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrgSelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for Logo
            Icon(Icons.mosque, size: 80, color: AppTheme.primaryColor),
            const SizedBox(height: 20),
            Text(
              'খেলাফত মজলিস',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 10),
            Text(
              'খেলাফত প্রতিষ্ঠার লক্ষ্যে আন্দোলন গড়ে তুলুন',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
