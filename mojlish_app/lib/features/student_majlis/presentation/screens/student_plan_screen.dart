import 'package:flutter/material.dart';

class StudentPlanScreen extends StatelessWidget {
  const StudentPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('পরিকল্পনা — ছাত্র মজলিস')),
      body: const Center(child: Text('ছাত্র মজলিস পরিকল্পনা')),
    );
  }
}
