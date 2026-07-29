import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/general_plan_bloc.dart';
import '../../domain/entities/general_plan_entity.dart';

class GeneralPlanScreen extends StatefulWidget {
  const GeneralPlanScreen({super.key});

  @override
  State<GeneralPlanScreen> createState() => _GeneralPlanScreenState();
}

class _GeneralPlanScreenState extends State<GeneralPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Example controllers
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _sessionController = TextEditingController();
  
  @override
  void dispose() {
    _branchController.dispose();
    _monthController.dispose();
    _sessionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final plan = GeneralPlanEntity(
        branch: _branchController.text,
        month: _monthController.text,
        session: _sessionController.text,
        friendIncrease: 0,
        primaryMemberIncrease: 0,
        schoolGovt: 0,
        schoolNonGovt: 0,
        college: 0,
        madrasaAlia: 0,
        madrasaQawmi: 0,
        university: 0,
        wellWisherIncrease: 0,
        associateMemberTarget: 0,
        workerIncrease: 0,
        workshopCount: 0,
        educationMeetingCount: 0,
        zakatCollection: 0,
        totalIncome: 0,
        totalExpenditure: 0,
      );
      
      context.read<GeneralPlanBloc>().add(SubmitGeneralPlanEvent(plan: plan));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ছাত্র মজলিস - সাধারণ পরিকল্পনা')),
      body: BlocConsumer<GeneralPlanBloc, GeneralPlanState>(
        listener: (context, state) {
          if (state is GeneralPlanSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('পরিকল্পনা সফলভাবে জমা দেওয়া হয়েছে!')),
            );
          } else if (state is GeneralPlanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is GeneralPlanLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _branchController,
                    decoration: const InputDecoration(labelText: 'শাখা'),
                    validator: (v) => v!.isEmpty ? 'শাখার নাম দিন' : null,
                  ),
                  TextFormField(
                    controller: _monthController,
                    decoration: const InputDecoration(labelText: 'মাস'),
                    validator: (v) => v!.isEmpty ? 'মাস দিন' : null,
                  ),
                  TextFormField(
                    controller: _sessionController,
                    decoration: const InputDecoration(labelText: 'সেশন'),
                    validator: (v) => v!.isEmpty ? 'সেশন দিন' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
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
