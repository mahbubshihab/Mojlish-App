import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/call_manifesto_bloc.dart';
import '../bloc/call_manifesto_event.dart';
import '../bloc/call_manifesto_state.dart';

class CallManifestoPage extends StatefulWidget {
  const CallManifestoPage({super.key});

  @override
  State<CallManifestoPage> createState() => _CallManifestoPageState();
}

class _CallManifestoPageState extends State<CallManifestoPage> {
  @override
  void initState() {
    super.initState();
    context.read<CallManifestoBloc>().add(LoadCallManifestosEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Manifesto'),
      ),
      body: BlocBuilder<CallManifestoBloc, CallManifestoState>(
        builder: (context, state) {
          if (state is CallManifestoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CallManifestoLoaded) {
            final manifestos = state.manifestos;
            if (manifestos.isEmpty) {
              return const Center(child: Text('No manifestos found.'));
            }
            return ListView.builder(
              itemCount: manifestos.length,
              itemBuilder: (context, index) {
                final manifesto = manifestos[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (manifesto.imageUrl.isNotEmpty)
                          Image.network(manifesto.imageUrl),
                        const SizedBox(height: 8),
                        Text(
                          manifesto.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(manifesto.content),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is CallManifestoError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Initialize to load manifestos.'));
        },
      ),
    );
  }
}
