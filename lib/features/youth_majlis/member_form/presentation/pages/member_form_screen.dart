import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/widgets/custom_labeled_input_field.dart';
import '../bloc/member_form_bloc.dart';
import '../bloc/member_form_event.dart';
import '../bloc/member_form_state.dart';
import '../../../domain/entities/member_form_entity.dart';

class MemberFormScreen extends StatefulWidget {
  const MemberFormScreen({Key? key}) : super(key: key);

  @override
  State<MemberFormScreen> createState() => _MemberFormScreenState();
}

class _MemberFormScreenState extends State<MemberFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _nidController = TextEditingController();
  final _villageController = TextEditingController();
  final _unionController = TextEditingController();
  final _thanaUpazilaController = TextEditingController();
  final _districtController = TextEditingController();
  final _presentAddressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  
  DateTime? _joinDate;

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _nidController.dispose();
    _villageController.dispose();
    _unionController.dispose();
    _thanaUpazilaController.dispose();
    _districtController.dispose();
    _presentAddressController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_joinDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a join date')),
        );
        return;
      }
      
      final entity = MemberFormEntity(
        name: _nameController.text,
        fatherName: _fatherNameController.text,
        nidNumber: _nidController.text,
        village: _villageController.text,
        unionName: _unionController.text,
        thanaUpazila: _thanaUpazilaController.text,
        district: _districtController.text,
        presentAddress: _presentAddressController.text,
        mobile: _mobileController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
        joinDate: _joinDate!,
      );

      context.read<MemberFormBloc>().add(SubmitMemberForm(entity: entity));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('প্রাথমিক সদস্য ফরম'),
      ),
      body: BlocConsumer<MemberFormBloc, MemberFormState>(
        listener: (context, state) {
          if (state is MemberFormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Form Submitted Successfully!')),
            );
            Navigator.of(context).pop();
          } else if (state is MemberFormFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomLabeledInputField(
                    label: 'নাম',
                    controller: _nameController,
                    validator: (v) => v == null || v.isEmpty ? 'নাম লিখুন' : null,
                  ),
                  CustomLabeledInputField(
                    label: 'পিতা',
                    controller: _fatherNameController,
                    validator: (v) => v == null || v.isEmpty ? 'পিতার নাম লিখুন' : null,
                  ),
                  CustomLabeledInputField(
                    label: 'জাতীয় পরিচয়পত্র নং',
                    controller: _nidController,
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'জাতীয় পরিচয়পত্র নং লিখুন' : null,
                  ),
                  CustomLabeledInputField(
                    label: 'ঠিকানা: গ্রাম',
                    controller: _villageController,
                    validator: (v) => v == null || v.isEmpty ? 'গ্রাম লিখুন' : null,
                  ),
                  CustomLabeledInputField(
                    label: 'ইউনিয়ন',
                    controller: _unionController,
                    validator: (v) => v == null || v.isEmpty ? 'ইউনিয়ন লিখুন' : null,
                  ),
                  CustomLabeledInputField(
                    label: 'থানা ও উপজেলা',
                    controller: _thanaUpazilaController,
                    validator: (v) => v == null || v.isEmpty ? 'থানা/উপজেলা লিখুন' : null,
                  ),
                  CustomLabeledInputField(
                    label: 'জেলা',
                    controller: _districtController,
                    validator: (v) => v == null || v.isEmpty ? 'জেলা লিখুন' : null,
                  ),
                  CustomLabeledInputField(
                    label: 'বর্তমান ঠিকানা',
                    controller: _presentAddressController,
                    validator: (v) => v == null || v.isEmpty ? 'বর্তমান ঠিকানা লিখুন' : null,
                  ),
                  CustomLabeledInputField(
                    label: 'মোবাইল',
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v == null || v.isEmpty ? 'মোবাইল নম্বর লিখুন' : null,
                  ),
                  CustomLabeledInputField(
                    label: 'ইমেইল',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _joinDate == null 
                              ? 'যোগদানের তারিখ: Select Date' 
                              : 'যোগদানের তারিখ: ${_joinDate!.toLocal().toString().split(' ')[0]}',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() {
                              _joinDate = date;
                            });
                          }
                        },
                        child: const Text('Pick Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  const Text(
                    'আমি দৃঢ়ভাবে বিশ্বাস করি যে, ইসলামই আল্লাহর একমাত্র মনোনীত জীবনব্যবস্থা। ইসলামী আদর্শের আলোকে যুবসমাজের নেতৃত্বে একটি কল্যাণমুখী সমাজ গড়ার লক্ষ্যে ইসলামী যুব মজলিসের সাথে একমত হয়ে এ সংগঠনে যোগদান করছি। আমি এ লক্ষ্য অর্জনে যথাসাধ্য চেষ্টা করবো ইনশাআল্লাহ।',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  
                  const SizedBox(height: 32),

                  if (state is MemberFormLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Submit Form'),
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
