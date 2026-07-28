import 'package:flutter/material.dart';
import 'student_plan_screen.dart';

class StudentHubScreen extends StatelessWidget {
  const StudentHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('বাংলাদেশ ইসলামী ছাত্র মজলিস')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.assignment_rounded, color: Color(0xFF2563EB)),
            title: const Text('পরিকল্পনা'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentPlanScreen())),
          ),
        ],
      ),
    );
  }
}
