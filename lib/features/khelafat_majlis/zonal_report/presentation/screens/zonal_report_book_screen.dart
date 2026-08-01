import 'package:flutter/material.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_download_screen.dart';
import 'package:mojlish_app/features/common/reports/presentation/widgets/universal_report_book_widget.dart';
import 'zonal_report_screen.dart';

/// খেলাফত মজলিস — জোনাল রিপোর্ট বই
class ZonalReportBookScreen extends StatelessWidget {
  const ZonalReportBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UniversalReportBookWidget(
      title: 'জোনাল রিপোর্ট বই',
      cardTitle: 'জোনাল রিপোর্ট',
      cardSubtitle: 'আঞ্চলিক শাখার বিবরণী, সফর ও তদারকি সমন্বয় হিসাব',
      icon: Icons.map_rounded,
      accentColor: const Color(0xFF0284C7),
      onMonthSelected: (year, month) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ZonalReportScreen(year: year, month: month),
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
              reportCategory: ReportCategory.zonalReport,
            ),
          ),
        );
      },
    );
  }
}
