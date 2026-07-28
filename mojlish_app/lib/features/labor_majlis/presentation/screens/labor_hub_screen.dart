import 'package:flutter/material.dart';
import 'labor_overview_screen.dart';
import 'labor_member_form_screen.dart';

class LaborHubScreen extends StatelessWidget {
  const LaborHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('বাংলাদেশ ইসলামী শ্রমিক মজলিস')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline_rounded, color: Color(0xFFD97706)),
            title: const Text('সংক্ষিপ্ত পরিচিতি'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LaborOverviewScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.badge_rounded, color: Color(0xFF059669)),
            title: const Text('প্রাথমিক সদস্য ফরম'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LaborMemberFormScreen())),
          ),
        ],
      ),
    );
  }
}
