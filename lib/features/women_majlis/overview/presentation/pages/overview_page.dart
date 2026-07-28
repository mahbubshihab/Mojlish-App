import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/overview_bloc.dart';
import '../bloc/overview_event.dart';
import '../bloc/overview_state.dart';
import '../../data/datasources/overview_remote_data_source.dart';
import '../../data/repositories/overview_repository_impl.dart';

class WomenMajlisOverviewPage extends StatelessWidget {
  const WomenMajlisOverviewPage({super.key});

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
          title: const Text('মহিলা মজলিস পরিচিতি'),
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
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
                    Center(
                      child: Text(
                        overview.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      overview.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('লক্ষ্য ও উদ্দেশ্য'),
                    ...overview.aimsAndObjectives.map((item) => _buildListItem(item)),
                    const SizedBox(height: 24),
                    _buildSectionTitle('কর্মসূচী (৫ দফা)'),
                    ...overview.programs.map((item) => _buildListItem(item)),
                    const SizedBox(height: 24),
                    _buildSectionTitle('জনশক্তির স্তর'),
                    ...overview.manpowerTiers.map((item) => _buildListItem(item)),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
