import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/period_report_bloc.dart';

class StudentPeriodReportScreen extends StatelessWidget {
  const StudentPeriodReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentPeriodReportBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('StudentPeriodReport Screen')),
        body: Center(child: Text('StudentPeriodReport Sub-feature Content')),
      ),
    );
  }
}
