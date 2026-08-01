import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/personal_plan_bloc.dart';
import '../bloc/personal_plan_event.dart';
import '../bloc/personal_plan_state.dart';
import '../../domain/entities/personal_plan_entity.dart';

class PersonalPlanPage extends StatefulWidget {
  final String? initialMonth;
  final String? initialYear;

  const PersonalPlanPage({
    super.key,
    this.initialMonth,
    this.initialYear,
  });

  @override
  State<PersonalPlanPage> createState() => _PersonalPlanPageState();
}

class _PersonalPlanPageState extends State<PersonalPlanPage> {
  final _formKey = GlobalKey<FormState>();

  // Use controllers or a Map to hold form values.
  // For brevity, using a few controllers as example.
  final nameController = TextEditingController();
  final branchController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialMonth != null) {
      monthController.text = widget.initialMonth!;
    }
    if (widget.initialYear != null) {
      yearController.text = widget.initialYear!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ব্যক্তিগত মাসিক পরিকল্পনা')),
      body: BlocConsumer<PersonalPlanBloc, PersonalPlanState>(
        listener: (context, state) {
          if (state is PersonalPlanSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Plan submitted successfully')),
            );
          } else if (state is PersonalPlanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is PersonalPlanLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'নাম'),
                  ),
                  TextFormField(
                    controller: branchController,
                    decoration: const InputDecoration(labelText: 'শাখা'),
                  ),
                  TextFormField(
                    controller: monthController,
                    decoration: const InputDecoration(labelText: 'মাস'),
                  ),
                  TextFormField(
                    controller: yearController,
                    decoration: const InputDecoration(labelText: 'সন'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final plan = PersonalPlanEntity(
                          name: nameController.text,
                          branch: branchController.text,
                          month: monthController.text,
                          year: yearController.text,
                          // ... set other fields
                        );
                        context.read<PersonalPlanBloc>().add(SubmitPersonalPlanEvent(plan));
                      }
                    },
                    child: const Text('জমা দিন'),
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
