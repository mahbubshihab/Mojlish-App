import 'package:flutter/material.dart';
import '../pages/period_report_page.dart';
export '../pages/period_report_page.dart';

/// Screen alias for PeriodReportPage
class PeriodReportScreen extends StatelessWidget {
  final String? initialMonth;
  final String? initialSession;

  const PeriodReportScreen({
    super.key,
    this.initialMonth,
    this.initialSession,
  });

  @override
  Widget build(BuildContext context) {
    return PeriodReportPage(
      initialMonth: initialMonth,
      initialSession: initialSession,
    );
  }
}
