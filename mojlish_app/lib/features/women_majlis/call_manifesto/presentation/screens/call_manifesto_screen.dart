import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WomenCallManifestoScreen extends StatelessWidget {
  const WomenCallManifestoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WomenCallManifestoBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('WomenCallManifesto Screen')),
        body: Center(child: Text('WomenCallManifesto Sub-feature Content')),
      ),
    );
  }
}
