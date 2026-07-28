import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/period_report.dart';
import '../bloc/period_report_bloc.dart';
import '../bloc/period_report_event.dart';
import '../bloc/period_report_state.dart';

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
        title: const Text('Period Report'),
      ),
      body: BlocConsumer<PeriodReportBloc, PeriodReportState>(
        listener: (context, state) {
          if (state is PeriodReportSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report submitted successfully!')),
            );
            Navigator.of(context).pop();
          } else if (state is PeriodReportFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed: ${state.message}')),
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
              child: ListView(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Branch Name'),
                    onSaved: (value) => branch = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Month'),
                    onSaved: (value) => month = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Session'),
                    onSaved: (value) => session = value ?? '',
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.save();
                      
                      final report = PeriodReport(
                        id: DateTime.now().toString(),
                        branch: branch,
                        month: month,
                        session: session,
                        manpower: const Manpower(),
                        dawah: const Dawah(),
                        organization: const Organization(),
                        meetings: const Meetings(),
                        training: const Training(),
                        library: const Library(),
                        baytulmal: const Baytulmal(),
                      );
                      
                      context.read<PeriodReportBloc>().add(SubmitPeriodReportEvent(report: report));
                    },
                    child: const Text('Submit Report'),
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
