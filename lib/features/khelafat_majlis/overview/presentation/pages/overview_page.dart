import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/overview_bloc.dart';
import '../bloc/overview_event.dart';
import '../bloc/overview_state.dart';
import '../../data/datasources/overview_remote_data_source.dart';
import '../../data/repositories/overview_repository_impl.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OverviewBloc(
        repository: OverviewRepositoryImpl(
          remoteDataSource: OverviewRemoteDataSourceImpl(),
        ),
      )..add(LoadOverviewEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('পরিচিতি (Overview)'),
        ),
        body: BlocBuilder<OverviewBloc, OverviewState>(
          builder: (context, state) {
            if (state is OverviewLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OverviewError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is OverviewLoaded) {
              final overview = state.overview;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      overview.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      overview.description,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'মৌল কর্মসূচি',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 8),
                    ...overview.basicPrograms.map((program) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(program),
                        )),
                    const SizedBox(height: 24),
                    const Text(
                      'সদস্যপদ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 8),
                    ...overview.membershipConditions.map((condition) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(condition),
                        )),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
