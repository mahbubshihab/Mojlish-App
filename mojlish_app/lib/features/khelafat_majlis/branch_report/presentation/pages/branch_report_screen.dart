import 'package:flutter/material.dart';
import '../screens/branch_report_screen.dart';
export '../screens/branch_report_screen.dart';

/// Legacy page export wrapping BranchReportScreen
class BranchReportPageWrapper extends StatelessWidget {
  final int? year;
  final int? month;

  const BranchReportPageWrapper({super.key, this.year, this.month});

  @override
  Widget build(BuildContext context) {
    return BranchReportScreen(year: year, month: month);
  }
}
