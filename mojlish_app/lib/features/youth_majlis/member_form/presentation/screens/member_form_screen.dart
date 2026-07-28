import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/member_form_bloc.dart';

class YouthMemberFormScreen extends StatelessWidget {
  const YouthMemberFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => YouthMemberFormBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('YouthMemberForm Screen')),
        body: Center(child: Text('YouthMemberForm Sub-feature Content')),
      ),
    );
  }
}
