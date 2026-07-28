import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/baytulmal_report_bloc.dart';

class StudentBaytulmalReportScreen extends StatelessWidget {
  const StudentBaytulmalReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentBaytulmalReportBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('StudentBaytulmalReport Screen')),
        body: Center(child: Text('StudentBaytulmalReport Sub-feature Content')),
      ),
    );
  }
}
