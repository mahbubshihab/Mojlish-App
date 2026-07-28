import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/member_form_bloc.dart';

class KhelafatMemberFormScreen extends StatelessWidget {
  const KhelafatMemberFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KhelafatMemberFormBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('KhelafatMemberForm Screen')),
        body: Center(child: Text('KhelafatMemberForm Sub-feature Content')),
      ),
    );
  }
}
