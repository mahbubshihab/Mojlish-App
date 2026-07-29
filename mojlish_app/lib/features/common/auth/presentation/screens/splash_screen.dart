import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/services/auth_service.dart';
import 'package:mojlish_app/core/services/user_storage_service.dart';
import 'google_login_screen.dart';
import 'org_selection_screen.dart';
import '../../../dashboard/presentation/screens/main_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final user = _authService.currentUser;

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GoogleLoginScreen()),
      );
    } else {
      await _authService.syncUserProfile(user);
      final activeMajlis = await UserStorageService.getActiveMajlis();

      if (activeMajlis == null || activeMajlis.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrgSelectionScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainDashboardScreen()),
        );
      }
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
            Image.asset(
              'assets/images/logo.png',
              height: 120,
              errorBuilder: (_, __, ___) => Icon(Icons.mosque, size: 80, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 20),
            Text(
              'মজলিশ অ্যাপ',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 10),
            Text(
              'সংগঠনের সকল রিপোর্ট ও পরিকল্পনার ডিজিটাল সমাধান',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
