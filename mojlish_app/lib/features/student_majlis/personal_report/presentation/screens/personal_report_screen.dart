import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/personal_report_bloc.dart';

class StudentPersonalReportScreen extends StatelessWidget {
  const StudentPersonalReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentPersonalReportBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('StudentPersonalReport Screen')),
        body: Center(child: Text('StudentPersonalReport Sub-feature Content')),
      ),
    );
  }
}
