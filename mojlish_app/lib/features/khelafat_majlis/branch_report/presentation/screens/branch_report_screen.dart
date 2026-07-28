import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/branch_report_bloc.dart';

class KhelafatBranchReportScreen extends StatelessWidget {
  const KhelafatBranchReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KhelafatBranchReportBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('KhelafatBranchReport Screen')),
        body: Center(child: Text('KhelafatBranchReport Sub-feature Content')),
      ),
    );
  }
}
