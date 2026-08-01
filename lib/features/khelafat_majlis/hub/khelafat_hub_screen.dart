import 'package:flutter/material.dart';
import '../../common/syllabi/khelafot_syllabus/presentation/pages/khelafot_syllabus_page.dart';
import '../personal_report/presentation/pages/personal_report_book_screen.dart';

class KhelafatHubScreen extends StatelessWidget {
  const KhelafatHubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('খেলাফত মজলিস হাব'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'খেলাফত মজলিস মডিউলসমূহ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1B5E20),
                  child: Icon(Icons.person_outline, color: Colors.white),
                ),
                title: const Text(
                  'ব্যক্তিগত রিপোর্ট বই',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: const Text('মাসিক ব্যক্তিগত তৎপরতার রিপোর্ট বই (মাস ও সাল ফিল্টারসহ)'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KhelafatPersonalReportBookScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1B5E20),
                  child: Icon(Icons.book, color: Colors.white),
                ),
                title: const Text(
                  'সিলেবাস (Syllabus)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: const Text('প্রথম স্তর, দ্বিতীয় স্তর, উচ্চতর স্তর ও নোট তৈরির বিষয়সমূহ'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KhelafotSyllabusPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
