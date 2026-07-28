import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/overview_bloc.dart';

class YouthOverviewScreen extends StatelessWidget {
  const YouthOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => YouthOverviewBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('YouthOverview Screen')),
        body: Center(child: Text('YouthOverview Sub-feature Content')),
      ),
    );
  }
}
