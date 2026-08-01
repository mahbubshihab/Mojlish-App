import 'package:flutter/material.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_download_screen.dart';
import 'package:mojlish_app/features/common/reports/presentation/widgets/universal_report_book_widget.dart';
import 'period_report_screen.dart';

/// ছাত্র মজলিস — বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট বই
class StudentPeriodReportBookScreen extends StatelessWidget {
  const StudentPeriodReportBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UniversalReportBookWidget(
      title: 'পর্যায় রিপোর্ট বই',
      cardTitle: 'বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট',
      cardSubtitle: 'ছাত্র মজলিসের পর্যায়ভিত্তিক মেয়াদের সমষ্টিগত রিপোর্ট',
      icon: Icons.date_range_rounded,
      accentColor: const Color(0xFF2563EB),
      onMonthSelected: (year, month) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PeriodReportScreen(),
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
