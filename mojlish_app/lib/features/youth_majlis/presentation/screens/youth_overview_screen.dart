import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import '../../data/models/youth_overview_data.dart';

class YouthOverviewScreen extends StatelessWidget {
  const YouthOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('সংক্ষিপ্ত পরিচিতি — যুব মজলিস')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(YouthOverviewData.organizationName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 10),
            Text(YouthOverviewData.goalText, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
