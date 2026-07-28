import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/member.dart';
import '../bloc/member_form_bloc.dart';
import '../bloc/member_form_event.dart';
import '../bloc/member_form_state.dart';

class MemberFormScreen extends StatefulWidget {
  const MemberFormScreen({Key? key}) : super(key: key);

  @override
  State<MemberFormScreen> createState() => _MemberFormScreenState();
}

class _MemberFormScreenState extends State<MemberFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _educationalQualificationController = TextEditingController();
  final _ageController = TextEditingController();
  final _professionController = TextEditingController();
  final _presentAddressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _permanentAddressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _educationalQualificationController.dispose();
    _ageController.dispose();
    _professionController.dispose();
    _presentAddressController.dispose();
    _mobileController.dispose();
    _permanentAddressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final member = KhelafatMajlisMember(
        name: _nameController.text,
        fatherName: _fatherNameController.text,
        educationalQualification: _educationalQualificationController.text,
        age: _ageController.text,
        profession: _professionController.text,
        presentAddress: _presentAddressController.text,
        mobile: _mobileController.text,
        permanentAddress: _permanentAddressController.text,
        date: DateTime.now(),
      );

      context.read<MemberFormBloc>().add(SubmitMemberForm(member));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('প্রাথমিক সদস্য ফরম')),
      body: BlocConsumer<MemberFormBloc, MemberFormState>(
        listener: (context, state) {
          if (state is MemberFormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Form submitted successfully!')),
            );
            Navigator.pop(context);
          } else if (state is MemberFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'নাম'),
                    validator: (value) => value!.isEmpty ? 'নাম লিখুন' : null,
                  ),
                  TextFormField(
                    controller: _fatherNameController,
                    decoration: const InputDecoration(labelText: 'পিতার নাম'),
                    validator: (value) => value!.isEmpty ? 'পিতার নাম লিখুন' : null,
                  ),
                  TextFormField(
                    controller: _educationalQualificationController,
                    decoration: const InputDecoration(labelText: 'শিক্ষাগত যোগ্যতা'),
                    validator: (value) => value!.isEmpty ? 'শিক্ষাগত যোগ্যতা লিখুন' : null,
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'বয়স'),
                    validator: (value) => value!.isEmpty ? 'বয়স লিখুন' : null,
                  ),
                  TextFormField(
                    controller: _professionController,
                    decoration: const InputDecoration(labelText: 'পেশা'),
                    validator: (value) => value!.isEmpty ? 'পেশা লিখুন' : null,
                  ),
                  TextFormField(
                    controller: _presentAddressController,
                    decoration: const InputDecoration(labelText: 'বর্তমান ঠিকানা'),
                    validator: (value) => value!.isEmpty ? 'বর্তমান ঠিকানা লিখুন' : null,
                  ),
                  TextFormField(
                    controller: _mobileController,
                    decoration: const InputDecoration(labelText: 'মোবাইল'),
                    validator: (value) => value!.isEmpty ? 'মোবাইল নম্বর লিখুন' : null,
                  ),
                  TextFormField(
                    controller: _permanentAddressController,
                    decoration: const InputDecoration(labelText: 'স্থায়ী ঠিকানা'),
                    validator: (value) => value!.isEmpty ? 'স্থায়ী ঠিকানা লিখুন' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: state is MemberFormLoading ? null : _submitForm,
                    child: state is MemberFormLoading 
                        ? const CircularProgressIndicator()
                        : const Text('সংরক্ষণ করুন'),
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
