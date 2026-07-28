import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/period_plan_bloc.dart';
import '../bloc/period_plan_event.dart';
import '../bloc/period_plan_state.dart';

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
              const SnackBar(content: Text('Plan submitted successfully')),
            );
          } else if (state is PeriodPlanFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _branchController,
                  decoration: const InputDecoration(labelText: 'শাখা'),
                ),
                TextField(
                  controller: _monthController,
                  decoration: const InputDecoration(labelText: 'মাস'),
                ),
                TextField(
                  controller: _sessionController,
                  decoration: const InputDecoration(labelText: 'সেশন'),
                ),
                const SizedBox(height: 24),
                // Other sections go here...
                const Text('প্রথম দফা : দাওয়াত', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                const Text('দ্বিতীয় দফা : সংগঠন', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                const Text('তৃতীয় দফা : প্রশিক্ষণ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                const Text('চতুর্থ দফা : আন্দোলন', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                const Text('সামাজিক খেদমত', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                const Text('বায়তুলমাল বাজেট', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 24),
                if (state is PeriodPlanLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: () {
                      context.read<PeriodPlanBloc>().add(
                        SubmitPeriodPlanEvent(
                          branch: _branchController.text,
                          month: _monthController.text,
                          session: _sessionController.text,
                        ),
                      );
                    },
                    child: const Text('Submit'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
