import 'package:flutter/material.dart';
import '../screens/period_plan_screen.dart';

/// PeriodPlanPage delegates directly to the comprehensive PeriodPlanScreen
class PeriodPlanPage extends StatelessWidget {
  final String? initialMonth;
  final String? initialSession;
  final String? initialBranch;

  const PeriodPlanPage({
    super.key,
    this.initialMonth,
    this.initialSession,
    this.initialBranch,
  });

  @override
  Widget build(BuildContext context) {
    return PeriodPlanScreen(
      initialMonth: initialMonth,
      initialSession: initialSession,
      initialBranch: initialBranch,
    );
  }
}
