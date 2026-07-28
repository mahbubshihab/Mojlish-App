import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/personal_report_bloc.dart';

class WomenPersonalReportScreen extends StatelessWidget {
  const WomenPersonalReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WomenPersonalReportBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('WomenPersonalReport Screen')),
        body: Center(child: Text('WomenPersonalReport Sub-feature Content')),
      ),
    );
  }
}
