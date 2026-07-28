import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/branch_plan_bloc.dart';
import '../bloc/branch_plan_event.dart';
import '../bloc/branch_plan_state.dart';

class BranchPlanScreen extends StatelessWidget {
  BranchPlanScreen({super.key});

  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('শাখার পরিকল্পনা ফরম'), // Branch Plan Form
      ),
      body: BlocConsumer<BranchPlanBloc, BranchPlanState>(
        listener: (context, state) {
          if (state is BranchPlanSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('পরিকল্পনা সফলভাবে জমা দেওয়া হয়েছে')),
            );
          } else if (state is BranchPlanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ত্রুটি: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is BranchPlanLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'খেলাফত মজলিস',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _branchNameController,
                        decoration: const InputDecoration(labelText: 'শাখা'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _monthController,
                        decoration: const InputDecoration(labelText: 'মাস'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _yearController,
                        decoration: const InputDecoration(labelText: 'সন'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('জনশক্তি (Manpower)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                // Add your form fields here based on the sections in the image...
                
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<BranchPlanBloc>().add(
                      SubmitBranchPlanEvent(
                        branchName: _branchNameController.text,
                        month: _monthController.text,
                        year: _yearController.text,
                      ),
                    );
                  },
                  child: const Text('জমা দিন (Submit)'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
