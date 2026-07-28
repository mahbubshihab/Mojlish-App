import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/personal_plan_bloc.dart';

class StudentPersonalPlanScreen extends StatelessWidget {
  const StudentPersonalPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentPersonalPlanBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('StudentPersonalPlan Screen')),
        body: Center(child: Text('StudentPersonalPlan Sub-feature Content')),
      ),
    );
  }
}
