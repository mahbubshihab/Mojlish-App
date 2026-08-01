import 'package:flutter/material.dart';
import '../pages/baytulmal_report_page.dart';
export '../pages/baytulmal_report_page.dart';

/// Screen alias for BaytulmalReportPage
class BaytulmalReportScreen extends StatelessWidget {
  final String? initialMonth;
  final String? initialSession;

  const BaytulmalReportScreen({
    super.key,
    this.initialMonth,
    this.initialSession,
  });

  @override
  Widget build(BuildContext context) {
    return BaytulmalReportPage(
      initialMonth: initialMonth,
      initialSession: initialSession,
    );
  }
}
