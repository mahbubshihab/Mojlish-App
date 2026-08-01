import 'package:flutter/material.dart';
import '../screens/baytulmal_report_screen.dart';
export '../screens/baytulmal_report_screen.dart';

/// Legacy alias widget for BaytulmalReportScreen
class BaytulmalReportPage extends StatelessWidget {
  final String? initialMonth;
  final String? initialSession;

  const BaytulmalReportPage({
    super.key,
    this.initialMonth,
    this.initialSession,
  });

  @override
  Widget build(BuildContext context) {
    return BaytulmalReportScreen(
      initialMonth: initialMonth,
      initialSession: initialSession,
    );
  }
}
