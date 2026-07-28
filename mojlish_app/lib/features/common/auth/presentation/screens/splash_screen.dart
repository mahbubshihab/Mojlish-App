import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'org_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OrgSelectionScreen()));
    });
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
