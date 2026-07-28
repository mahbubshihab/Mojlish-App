import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/baytulmal_report_bloc.dart';

class KhelafatBaytulmalReportScreen extends StatelessWidget {
  const KhelafatBaytulmalReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KhelafatBaytulmalReportBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('KhelafatBaytulmalReport Screen')),
        body: Center(child: Text('KhelafatBaytulmalReport Sub-feature Content')),
      ),
    );
  }
}
