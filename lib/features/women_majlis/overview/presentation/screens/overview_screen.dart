import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/overview_bloc.dart';

class WomenOverviewScreen extends StatelessWidget {
  const WomenOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WomenOverviewBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('WomenOverview Screen')),
        body: Center(child: Text('WomenOverview Sub-feature Content')),
      ),
    );
  }
}
