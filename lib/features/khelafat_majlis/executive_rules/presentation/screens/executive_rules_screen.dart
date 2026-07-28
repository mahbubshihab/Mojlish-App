import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/executive_rules_bloc.dart';

class KhelafatExecutiveRulesScreen extends StatelessWidget {
  const KhelafatExecutiveRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KhelafatExecutiveRulesBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('KhelafatExecutiveRules Screen')),
        body: Center(child: Text('KhelafatExecutiveRules Sub-feature Content')),
      ),
    );
  }
}
