import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/period_plan_bloc.dart';

class StudentPeriodPlanScreen extends StatelessWidget {
  const StudentPeriodPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentPeriodPlanBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('StudentPeriodPlan Screen')),
        body: Center(child: Text('StudentPeriodPlan Sub-feature Content')),
      ),
    );
  }
}
