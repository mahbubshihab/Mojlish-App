import 'package:flutter/material.dart';
import '../syllabi/khelafot_syllabus/presentation/pages/khelafot_syllabus_page.dart';
import '../../student_majlis/hub/student_hub_screen.dart';
import '../../khelafat_majlis/hub/khelafat_hub_screen.dart';
import '../../youth_majlis/personal_report/presentation/pages/personal_report_book_screen.dart';
import '../../women_majlis/personal_report/presentation/pages/women_majlis_personal_report_book_screen.dart';

class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('মজলিশ অ্যাপ - ড্যাশবোর্ড'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'মূল মেন্যু',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1B5E20),
                  child: Icon(Icons.auto_stories, color: Colors.white),
                ),
                title: const Text(
                  'খেলাফত মজলিস সিলেবাস',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: const Text('কর্মীদের ও সদস্য ভাইদের জন্য পাঠ্যসূচি ও বইসমূহ'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1B5E20),
                  child: Icon(Icons.account_balance, color: Colors.white),
                ),
                title: const Text(
                  'খেলাফত মজলিস হাব',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: const Text('ব্যক্তিগত রিপোর্ট বই, সিলেবাস ও ফরমসমূহ'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KhelafatHubScreen(),
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
                  backgroundColor: Color(0xFF006A4E),
                  child: Icon(Icons.school, color: Colors.white),
                ),
                title: const Text(
                  'ছাত্র মজলিস হাব',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: const Text('ছাত্র মজলিসের সকল রিপোর্ট বই ও পরিকল্পনা'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentHubScreen(),
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
                  backgroundColor: Color(0xFF2563EB),
                  child: Icon(Icons.groups, color: Colors.white),
                ),
                title: const Text(
                  'যুব মজলিস - ব্যক্তিগত রিপোর্ট বই',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: const Text('যুব মজলিসের মাসিক ব্যক্তিগত তৎপরতার রিপোর্ট বই'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const YouthPersonalReportBookScreen(),
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
                  backgroundColor: Color(0xFFDB2777),
                  child: Icon(Icons.female, color: Colors.white),
                ),
                title: const Text(
                  'মহিলা মজলিস - ব্যক্তিগত রিপোর্ট বই',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: const Text('মহিলা মজলিসের মাসিক ব্যক্তিগত তৎপরতার রিপোর্ট বই'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WomenMajlisPersonalReportBookScreen(),
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
