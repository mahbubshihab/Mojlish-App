import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/member_form_bloc.dart';

class StudentMemberFormScreen extends StatelessWidget {
  const StudentMemberFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentMemberFormBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('StudentMemberForm Screen')),
        body: Center(child: Text('StudentMemberForm Sub-feature Content')),
      ),
    );
  }
}
