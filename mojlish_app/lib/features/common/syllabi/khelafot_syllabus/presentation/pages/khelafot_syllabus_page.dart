import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/khelafot_syllabus_bloc.dart';
import '../bloc/khelafot_syllabus_event.dart';
import '../bloc/khelafot_syllabus_state.dart';
// import '../../../../../../core/di/injection_container.dart'; 

class KhelafotSyllabusPage extends StatelessWidget {
  const KhelafotSyllabusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Note: Assuming sl<KhelafotSyllabusBloc>() is provided elsewhere or 
    // BlocProvider is injected higher up. Using BlocBuilder here.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khelafat Majlis Syllabus'),
      ),
      body: BlocBuilder<KhelafotSyllabusBloc, KhelafotSyllabusState>(
        builder: (context, state) {
          if (state is KhelafotSyllabusLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is KhelafotSyllabusLoaded) {
            return ListView.builder(
              itemCount: state.syllabi.length,
              itemBuilder: (context, index) {
                final syllabus = state.syllabi[index];
                return ListTile(
                  title: Text(syllabus.title),
                  subtitle: Text(syllabus.description),
                );
              },
            );
          } else if (state is KhelafotSyllabusError) {
            return Center(child: Text(state.message));
          }
          // Default initial state
          return const Center(child: Text('Press refresh to load'));
        },
      ),
    );
  }
}
