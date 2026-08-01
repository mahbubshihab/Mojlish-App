import 'package:flutter/material.dart';
import '../screens/personal_plan_screen.dart';

/// Entry page wrapper for Chatro Majlis Personal Monthly Plan
class PersonalPlanPage extends StatelessWidget {
  final String? initialMonth;
  final String? initialYear;

  const PersonalPlanPage({
    super.key,
    this.initialMonth,
    this.initialYear,
  });

  @override
  Widget build(BuildContext context) {
    return PersonalPlanScreen(
      initialMonth: initialMonth,
      initialYear: initialYear,
    );
  }
}
