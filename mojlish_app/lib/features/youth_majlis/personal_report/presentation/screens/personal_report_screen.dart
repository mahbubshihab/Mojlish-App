import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/personal_report_bloc.dart';

class YouthPersonalReportScreen extends StatelessWidget {
  const YouthPersonalReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => YouthPersonalReportBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('YouthPersonalReport Screen')),
        body: Center(child: Text('YouthPersonalReport Sub-feature Content')),
      ),
    );
  }
}
