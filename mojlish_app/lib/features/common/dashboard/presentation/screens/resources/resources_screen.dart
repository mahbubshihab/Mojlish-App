import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('রিসোর্স ও বই', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBookCard('ইসলামী আন্দোলনের রূপরেখা', 'পিডিএফ ফরম্যাট (২.৫ মেগাবাইট)'),
          _buildBookCard('খেলাফত ব্যবস্থা: একটি পর্যালোচনা', 'পিডিএফ ফরম্যাট (৩.১ মেগাবাইট)'),
          _buildBookCard('মাসিক বুলেটিন - জুলাই ২০২৬', 'পিডিএফ ফরম্যাট (১.২ মেগাবাইট)'),
        ],
      ),
    );
  }

  Widget _buildBookCard(String title, String size) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(size, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.download, color: AppTheme.primaryColor),
              tooltip: 'ডাউনলোড করুন',
            )
          ],
        ),
      ),
    );
  }
}
