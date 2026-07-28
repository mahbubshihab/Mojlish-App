import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/call_manifesto_bloc.dart';

class YouthCallManifestoScreen extends StatelessWidget {
  const YouthCallManifestoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => YouthCallManifestoBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('YouthCallManifesto Screen')),
        body: Center(child: Text('YouthCallManifesto Sub-feature Content')),
      ),
    );
  }
}
