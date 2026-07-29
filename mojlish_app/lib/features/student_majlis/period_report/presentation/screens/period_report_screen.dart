import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/period_report_bloc.dart';
import '../bloc/period_report_event.dart';
import '../bloc/period_report_state.dart';
import '../../data/datasources/period_report_remote_datasource.dart';
import '../../data/repositories/period_report_repository_impl.dart';

class PeriodReportScreen extends StatelessWidget {
  const PeriodReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PeriodReportBloc>(
      create: (_) => PeriodReportBloc(
        repository: PeriodReportRepositoryImpl(
          remoteDataSource: PeriodReportRemoteDataSourceImpl(),
        ),
      ),
      child: const PeriodReportPage(),
    );
  }
}

class PeriodReportPage extends StatefulWidget {
  const PeriodReportPage({super.key});

  @override
  State<PeriodReportPage> createState() => _PeriodReportPageState();
}

class _PeriodReportPageState extends State<PeriodReportPage> {
  final _formKey = GlobalKey<FormState>();
  
  String branch = '';
  String month = '';
  String session = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('মেয়াদী/সেশনাল রিপোর্ট'),
      ),
      body: BlocConsumer<PeriodReportBloc, PeriodReportState>(
        listener: (context, state) {
          if (state is PeriodReportSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('রিপোর্ট সফলভাবে জমা হয়েছে')),
            );
          } else if (state is PeriodReportFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is PeriodReportLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'শাখা'),
                    onSaved: (value) => branch = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'মাস/মেয়াদ'),
                    onSaved: (value) => month = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'সেশন'),
                    onSaved: (value) => session = value ?? '',
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                      }
                    },
                    child: const Text('সংরক্ষণ করুন'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
