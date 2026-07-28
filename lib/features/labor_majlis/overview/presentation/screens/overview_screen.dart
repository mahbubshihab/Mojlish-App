import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/overview_bloc.dart';

class LaborOverviewScreen extends StatelessWidget {
  const LaborOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LaborOverviewBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('LaborOverview Screen')),
        body: Center(child: Text('LaborOverview Sub-feature Content')),
      ),
    );
  }
}
