import 'package:flutter/material.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_download_screen.dart';
import 'package:mojlish_app/features/common/reports/presentation/widgets/universal_report_book_widget.dart';
import 'branch_plan_screen.dart';

/// খেলাফত মজলিস — শাখা পরিকল্পনা ফরম বই (মাস ও বছর নির্বাচন ও ডাউনলোড)
class KhelafatBranchPlanBookScreen extends StatelessWidget {
  const KhelafatBranchPlanBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UniversalReportBookWidget(
      title: 'শাখার পরিকল্পনা বই',
      cardTitle: 'শাখা পরিকল্পনা',
      cardSubtitle: 'মাসিক সাংগঠনিক লক্ষ্যমাত্রা, দাওয়াত, বায়তুলমাল ও সফর পরিকল্পনা',
      icon: Icons.calendar_month_rounded,
      accentColor: const Color(0xFF06B6D4),
      onMonthSelected: (year, month) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KhelafatBranchPlanScreen(year: year, month: month),
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
            builder: (_) => KhelafatBranchPlanScreen(year: now.year, month: now.month),
          ),
        );
      },
    );
  }
}
