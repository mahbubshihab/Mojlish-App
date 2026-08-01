import 'package:flutter/material.dart';
import '../pages/baytulmal_report_page.dart';
export '../pages/baytulmal_report_page.dart';

/// Screen alias for BaytulmalReportPage
class BaytulmalReportScreen extends StatelessWidget {
  final int? year;
  final int? month;

  const BaytulmalReportScreen({super.key, this.year, this.month});

  @override
  Widget build(BuildContext context) {
    return const BaytulmalReportPage();
  }
}
