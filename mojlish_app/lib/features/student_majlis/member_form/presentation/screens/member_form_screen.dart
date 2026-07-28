import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final _eduController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _classController = TextEditingController();
  final _deptController = TextEditingController();
  final _rollController = TextEditingController();
  final _presentAddressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _villageController = TextEditingController();
  final _postOfficeController = TextEditingController();
  final _thanaController = TextEditingController();
  final _districtController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _eduController.dispose();
    _bloodGroupController.dispose();
    _classController.dispose();
    _deptController.dispose();
    _rollController.dispose();
    _presentAddressController.dispose();
    _mobileController.dispose();
    _villageController.dispose();
    _postOfficeController.dispose();
    _thanaController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<MemberFormBloc>().add(
        SubmitMemberFormEvent(
          name: _nameController.text,
          fatherName: _fatherNameController.text,
          educationalInstitution: _eduController.text,
          bloodGroup: _bloodGroupController.text,
          studentClass: _classController.text,
          department: _deptController.text,
          rollNo: _rollController.text,
          presentAddress: _presentAddressController.text,
          mobile: _mobileController.text,
          permanentVillage: _villageController.text,
          permanentPostOffice: _postOfficeController.text,
          permanentThana: _thanaController.text,
          permanentDistrict: _districtController.text,
        ),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
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
              const SnackBar(content: Text('Form Submitted Successfully')),
            );
            Navigator.pop(context);
          } else if (state is MemberFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
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
                  const Text(
                    'আমি ........................ বিশ্বাস করি যে, ইসলাম আল্লাহর মনোনীত দ্বীন বা জীবনব্যবস্থা এবং এর পূর্ণাঙ্গ অনুসরণের মধ্যেই মানব জীবনে ইহকালীন কল্যাণ ও পরকালীন মুক্তি নিহিত। এ উদ্দেশ্যে বাংলাদেশ ইসলামী ছাত্র মজলিস যে কর্মসূচি গ্রহণ করেছে, আমি তার সাথে একমত হয়ে আল্লাহর সন্তুষ্টি অর্জনের জন্যে এ সংগঠনে যোগদান করছি।',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField('নাম (Name)', _nameController),
                  _buildTextField('পিতার নাম (Father\'s Name)', _fatherNameController),
                  _buildTextField('শিক্ষা প্রতিষ্ঠান (Educational Institution)', _eduController),
                  _buildTextField('রক্তের গ্রুপ (Blood Group)', _bloodGroupController),
                  _buildTextField('শ্রেণি (Class)', _classController),
                  _buildTextField('বিভাগ (Department)', _deptController),
                  _buildTextField('ক্রমিক নং (Roll No)', _rollController),
                  _buildTextField('বর্তমান ঠিকানা (Present Address)', _presentAddressController),
                  _buildTextField('মোবাইল (Mobile)', _mobileController),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('স্থায়ী ঠিকানা (Permanent Address)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  _buildTextField('গ্রাম (Village)', _villageController),
                  _buildTextField('ডাকঘর (Post Office)', _postOfficeController),
                  _buildTextField('থানা/উপজেলা (Thana/Upazila)', _thanaController),
                  _buildTextField('জেলা (District)', _districtController),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: state is MemberFormLoading ? null : _submit,
                    child: state is MemberFormLoading
                        ? const CircularProgressIndicator()
                        : const Text('Submit'),
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
