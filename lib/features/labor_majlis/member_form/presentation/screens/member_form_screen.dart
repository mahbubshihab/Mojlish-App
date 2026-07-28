import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/member_form_bloc.dart';

class LaborMemberFormScreen extends StatelessWidget {
  const LaborMemberFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LaborMemberFormBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('LaborMemberForm Screen')),
        body: Center(child: Text('LaborMemberForm Sub-feature Content')),
      ),
    );
  }
}
