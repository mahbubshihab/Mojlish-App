import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/personal_report_bloc.dart';

class LaborPersonalReportScreen extends StatelessWidget {
  const LaborPersonalReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LaborPersonalReportBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('LaborPersonalReport Screen')),
        body: Center(child: Text('LaborPersonalReport Sub-feature Content')),
      ),
    );
  }
}
