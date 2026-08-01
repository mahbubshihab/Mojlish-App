import 'package:flutter/material.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_download_screen.dart';
import 'package:mojlish_app/features/common/reports/presentation/widgets/universal_report_book_widget.dart';
import 'period_plan_screen.dart';

/// ছাত্র মজলিস — বার্ষিক/ষান্মাসিক/দ্বি-মাসিক পরিকল্পনা বই
class StudentPeriodPlanBookScreen extends StatelessWidget {
  const StudentPeriodPlanBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UniversalReportBookWidget(
      title: 'পর্যায় পরিকল্পনা বই',
      cardTitle: 'বার্ষিক/ষান্মাসিক/দ্বি-মাসিক পরিকল্পনা',
      cardSubtitle: 'পর্যায়ভিত্তিক সময়কালের স্থায়ী ও চলমান লক্ষ্যমাত্রা পরিকল্পনা',
      icon: Icons.assignment_rounded,
      accentColor: const Color(0xFF8B5CF6),
      onMonthSelected: (year, month) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PeriodPlanScreen(),
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
              reportCategory: ReportCategory.studentPeriodReport,
            ),
          ),
        );
      },
    );
  }
}
