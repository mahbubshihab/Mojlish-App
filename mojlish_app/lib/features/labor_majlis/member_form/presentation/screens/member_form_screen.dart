import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import '../bloc/member_form_bloc.dart';

class LaborMemberFormScreen extends StatelessWidget {
  const LaborMemberFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LaborMemberFormBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('শ্রমিক মজলিস — সদস্য ফরম', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        body: const AmbientBackgroundWidget(
          primaryAccent: Color(0xFFEC4899),
          child: Center(child: Text('LaborMemberForm Sub-feature Content')),
        ),
      ),
    );
  }
}
