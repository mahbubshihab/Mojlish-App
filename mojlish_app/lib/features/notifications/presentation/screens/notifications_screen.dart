import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('নোটিশ বোর্ড')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'কেন্দ্রীয় ঘোষণা',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                      ),
                      Text(
                        '০৭ জুলাই ২০২৬',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'আসন্ন মাসিক সভার সময়সূচী পরিবর্তন করা হয়েছে। বিস্তারিত জানতে আপনার জোনাল দায়িত্বশীলের সাথে যোগাযোগ করুন।',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
