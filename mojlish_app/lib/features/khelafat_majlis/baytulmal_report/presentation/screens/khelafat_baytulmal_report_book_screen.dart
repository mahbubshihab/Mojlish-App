import 'package:flutter/material.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_download_screen.dart';
import 'package:mojlish_app/features/common/reports/presentation/widgets/universal_report_book_widget.dart';
import 'baytulmal_report_screen.dart';

/// খেলাফত মজলিস — বায়তুলমাল রিপোর্ট বই
class KhelafatBaytulmalReportBookScreen extends StatelessWidget {
  const KhelafatBaytulmalReportBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UniversalReportBookWidget(
      title: 'বায়তুলমাল রিপোর্ট বই',
      cardTitle: 'বায়তুলমাল রিপোর্ট',
      cardSubtitle: 'মাসিক আয়, ব্যয়, উদ্বৃত্ত ও বাজেটের পূর্ণাঙ্গ আর্থিক হিসাব',
      icon: Icons.account_balance_wallet_rounded,
      accentColor: const Color(0xFFD97706),
      onMonthSelected: (year, month) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BaytulmalReportScreen(year: year, month: month),
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
              reportCategory: ReportCategory.baytulmalReport,
            ),
          ),
        );
      },
    );
  }
}
