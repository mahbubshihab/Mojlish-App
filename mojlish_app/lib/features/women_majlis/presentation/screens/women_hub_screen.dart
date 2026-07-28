import 'package:flutter/material.dart';
import 'women_overview_screen.dart';
import 'women_manifesto_screen.dart';

class WomenHubScreen extends StatelessWidget {
  const WomenHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('বাংলাদেশ ইসলামী মহিলা মজলিস')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline_rounded, color: Color(0xFFE11D48)),
            title: const Text('সংক্ষিপ্ত পরিচিতি'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WomenOverviewScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_rounded, color: Color(0xFF9333EA)),
            title: const Text('আহ্বান'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WomenManifestoScreen())),
          ),
        ],
      ),
    );
  }
}
