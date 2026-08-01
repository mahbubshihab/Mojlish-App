import 'package:flutter/material.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_download_screen.dart';
import 'package:mojlish_app/features/common/reports/presentation/widgets/universal_report_book_widget.dart';
import 'personal_plan_screen.dart';

/// ছাত্র মজলিস — ব্যক্তিগত মাসিক পরিকল্পনা বই
class StudentPersonalPlanBookScreen extends StatelessWidget {
  const StudentPersonalPlanBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UniversalReportBookWidget(
      title: 'ব্যক্তিগত পরিকল্পনা বই',
      cardTitle: 'ব্যক্তিগত মাসিক পরিকল্পনা',
      cardSubtitle: 'পড়াশোনা, সিলেবাস পাঠ, ইবাদত ও যোগাযোগের ব্যক্তিগত লক্ষ্যমাত্রা',
      icon: Icons.person_outline_rounded,
      accentColor: const Color(0xFF0D9488),
      onMonthSelected: (year, month) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PersonalPlanScreen(),
          ),
        );
      },
      onDownloadPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReportDownloadScreen(
              majlisType: MajlisType.chatro,
              initialYear: DateTime.now().year,
              initialMonth: DateTime.now().month,
            ),
          ),
        );
      },
      onTodayPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PersonalPlanScreen(),
          ),
        );
      },
    );
  }
}
