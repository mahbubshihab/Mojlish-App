import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/branch_plan_bloc.dart';

class KhelafatBranchPlanScreen extends StatelessWidget {
  const KhelafatBranchPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KhelafatBranchPlanBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('KhelafatBranchPlan Screen')),
        body: Center(child: Text('KhelafatBranchPlan Sub-feature Content')),
      ),
    );
  }
}
