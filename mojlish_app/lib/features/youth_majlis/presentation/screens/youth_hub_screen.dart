import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'youth_overview_screen.dart';
import 'youth_member_form_screen.dart';

class YouthHubScreen extends StatelessWidget {
  const YouthHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('বাংলাদেশ ইসলামী যুব মজলিস')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline_rounded, color: Color(0xFF2563EB)),
            title: const Text('সংক্ষিপ্ত পরিচিতি'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const YouthOverviewScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.badge_rounded, color: Color(0xFF0D9488)),
            title: const Text('প্রাথমিক সদস্য ফরম'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const YouthMemberFormScreen())),
          ),
        ],
      ),
    );
  }
}
