import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../core/theme/app_theme.dart';

class SocialMediaScreen extends StatelessWidget {
  const SocialMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('সোশ্যাল মিডিয়া', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSocialBtn('অফিসিয়াল ফেসবুক পেজ', FontAwesomeIcons.facebook, const Color(0xFF1877F2)),
            const SizedBox(height: 16),
            _buildSocialBtn('অফিসিয়াল ইউটিউব চ্যানেল', FontAwesomeIcons.youtube, const Color(0xFFFF0000)),
            const SizedBox(height: 16),
            _buildSocialBtn('অফিসিয়াল এক্স (টুইটার)', FontAwesomeIcons.xTwitter, Colors.black),
            const SizedBox(height: 16),
            _buildSocialBtn('অফিসিয়াল ওয়েবসাইট', FontAwesomeIcons.globe, AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialBtn(String title, dynamic icon, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: FaIcon(icon, color: Colors.white),
        label: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
