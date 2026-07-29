import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/period_plan_bloc.dart';
import '../bloc/period_plan_state.dart';
import '../../data/datasources/period_plan_datasource.dart';
import '../../data/repositories/period_plan_repository_impl.dart';

class PeriodPlanScreen extends StatelessWidget {
  const PeriodPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PeriodPlanBloc>(
      create: (_) => PeriodPlanBloc(
        repository: PeriodPlanRepositoryImpl(
          dataSource: PeriodPlanDataSourceImpl(),
        ),
      ),
      child: const PeriodPlanPage(),
    );
  }
}

class PeriodPlanPage extends StatefulWidget {
  const PeriodPlanPage({super.key});

  @override
  State<PeriodPlanPage> createState() => _PeriodPlanPageState();
}

class _PeriodPlanPageState extends State<PeriodPlanPage> {
  final _branchController = TextEditingController();
  final _monthController = TextEditingController();
  final _sessionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('বার্ষিক/ষান্মাসিক/দ্বি-মাসিক পরিকল্পনা'),
      ),
      body: BlocConsumer<PeriodPlanBloc, PeriodPlanState>(
        listener: (context, state) {
          if (state is PeriodPlanSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('পরিকল্পনা সফলভাবে জমা হয়েছে')),
            );
          } else if (state is PeriodPlanFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          if (state is PeriodPlanLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _branchController,
                  decoration: const InputDecoration(labelText: 'শাখা'),
                ),
                TextField(
                  controller: _monthController,
                  decoration: const InputDecoration(labelText: 'মেয়াদ/মাস'),
                ),
                TextField(
                  controller: _sessionController,
                  decoration: const InputDecoration(labelText: 'সেশন'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // submit action
                  },
                  child: const Text('সংরক্ষণ করুন'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
