import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/overview_bloc.dart';

class KhelafatOverviewScreen extends StatelessWidget {
  const KhelafatOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KhelafatOverviewBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('KhelafatOverview Screen')),
        body: Center(child: Text('KhelafatOverview Sub-feature Content')),
      ),
    );
  }
}
