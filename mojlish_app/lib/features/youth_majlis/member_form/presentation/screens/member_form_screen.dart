import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/member_form_bloc.dart';
import '../bloc/member_form_event.dart';
import '../bloc/member_form_state.dart';
import 'package:mojlish_app/features/youth_majlis/member_form/domain/entities/member_form_entity.dart';
import 'package:mojlish_app/features/youth_majlis/member_form/data/datasources/member_form_remote_datasource.dart';
import 'package:mojlish_app/features/youth_majlis/member_form/data/repositories/member_form_repository_impl.dart';

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
    return BlocProvider<MemberFormBloc>(
      create: (_) => MemberFormBloc(
        repository: MemberFormRepositoryImpl(
          remoteDataSource: MemberFormRemoteDataSourceImpl(),
        ),
      ),
      child: Builder(
        builder: (context) {
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
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'নাম'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _fatherNameController,
                    decoration: const InputDecoration(labelText: 'পিতা'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nidController,
                    decoration: const InputDecoration(labelText: 'জাতীয় পরিচয়পত্র নং'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _villageController,
                    decoration: const InputDecoration(labelText: 'ঠিকানা: গ্রাম'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _unionController,
                    decoration: const InputDecoration(labelText: 'ইউনিয়ন'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _thanaUpazilaController,
                    decoration: const InputDecoration(labelText: 'থানা ও উপজেলা'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _districtController,
                    decoration: const InputDecoration(labelText: 'জেলা'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _presentAddressController,
                    decoration: const InputDecoration(labelText: 'বর্তমান ঠিকানা'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _mobileController,
                    decoration: const InputDecoration(labelText: 'মোবাইল'),
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'ইমেইল'),
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
        },
      ),
    );
  }
}
