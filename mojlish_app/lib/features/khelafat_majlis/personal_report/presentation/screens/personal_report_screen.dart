import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/personal_report_bloc.dart';

class KhelafatPersonalReportScreen extends StatelessWidget {
  const KhelafatPersonalReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KhelafatPersonalReportBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('KhelafatPersonalReport Screen')),
        body: Center(child: Text('KhelafatPersonalReport Sub-feature Content')),
      ),
    );
  }
}
