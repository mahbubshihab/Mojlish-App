import 'package:flutter/material.dart';
import '../screens/branch_plan_screen.dart';

/// Legacy page wrapper exporting KhelafatBranchPlanScreen
class BranchPlanScreen extends StatelessWidget {
  final int? year;
  final int? month;

  const BranchPlanScreen({super.key, this.year, this.month});

  @override
  Widget build(BuildContext context) {
    return KhelafatBranchPlanScreen(year: year, month: month);
  }
}
