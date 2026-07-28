import 'package:flutter/material.dart';

class WomenOverviewScreen extends StatelessWidget {
  const WomenOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('সংক্ষিপ্ত পরিচিতি — মহিলা মজলিস')),
      body: const Center(child: Text('মহিলা মজলিস পরিচিতি')),
    );
  }
}
