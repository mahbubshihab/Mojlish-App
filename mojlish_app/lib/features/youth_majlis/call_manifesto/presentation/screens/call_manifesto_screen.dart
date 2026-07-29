import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/call_manifesto_bloc.dart';
import '../data/datasources/call_manifesto_datasource.dart';
import '../data/repositories/call_manifesto_repository_impl.dart';
import '../pages/call_manifesto_page.dart';

class YouthCallManifestoScreen extends StatelessWidget {
  const YouthCallManifestoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CallManifestoBloc>(
      create: (_) => CallManifestoBloc(
        repository: CallManifestoRepositoryImpl(
          CallManifestoDataSourceImpl(),
        ),
      ),
      child: const CallManifestoPage(),
    );
  }
}
