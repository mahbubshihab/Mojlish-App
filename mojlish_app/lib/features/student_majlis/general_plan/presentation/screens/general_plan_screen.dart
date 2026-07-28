import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/general_plan_bloc.dart';

class StudentGeneralPlanScreen extends StatelessWidget {
  const StudentGeneralPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentGeneralPlanBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('StudentGeneralPlan Screen')),
        body: Center(child: Text('StudentGeneralPlan Sub-feature Content')),
      ),
    );
  }
}
