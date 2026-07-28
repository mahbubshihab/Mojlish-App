import 'package:flutter/material.dart';

class LaborOverviewScreen extends StatelessWidget {
  const LaborOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('সংক্ষিপ্ত পরিচিতি — শ্রমিক মজলিস')),
      body: const Center(child: Text('শ্রমিক মজলিস পরিচিতি')),
    );
  }
}
