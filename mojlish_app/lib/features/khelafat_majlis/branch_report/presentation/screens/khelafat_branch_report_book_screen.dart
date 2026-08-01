import 'package:flutter/material.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_download_screen.dart';
import 'package:mojlish_app/features/common/reports/presentation/widgets/universal_report_book_widget.dart';
import 'branch_report_screen.dart';

/// খেলাফত মজলিস — শাখা রিপোর্ট ফরম বই (মাস ও বছর নির্বাচন ও ডাউনলোড)
class KhelafatBranchReportBookScreen extends StatelessWidget {
  const KhelafatBranchReportBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UniversalReportBookWidget(
      title: 'শাখা রিপোর্ট বই',
      cardTitle: 'শাখা রিপোর্ট',
      cardSubtitle: 'মাসিক সাংগঠনিক বিবরণী, দাওয়াত, বৈঠক ও বায়তুলমাল রিপোর্ট',
      icon: Icons.assessment_rounded,
      accentColor: const Color(0xFFC084FC),
      onMonthSelected: (year, month) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BranchReportScreen(year: year, month: month),
          ),
        );
      },
      onDownloadPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReportDownloadScreen(
              majlisType: MajlisType.khelafat,
              initialYear: DateTime.now().year,
              initialMonth: DateTime.now().month,
            ),
          ),
        );
      },
      onTodayPressed: () {
        final now = DateTime.now();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BranchReportScreen(year: now.year, month: now.month),
          ),
        );
      },
    );
  }
}
