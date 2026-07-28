import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/member_form_bloc.dart';
import '../bloc/member_form_event.dart';
import '../bloc/member_form_state.dart';
import 'package:mojlish_app/features/youth_majlis/member_form/domain/entities/member_form_entity.dart';
import 'package:mojlish_app/features/youth_majlis/member_form/data/datasources/member_form_remote_datasource.dart';
import 'package:mojlish_app/features/youth_majlis/member_form/data/repositories/member_form_repository_impl.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';

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
          const SnackBar(content: Text('অনুগ্রহ করে যোগদানের তারিখ নির্বাচন করুন')),
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

  Future<void> _exportFormPdf() async {
    await PdfExportService.printOrDownloadPdf(
      title: 'যুব সদস্য আবেদন ফরম',
      majlisName: 'বাংলাদেশ ইসলামী যুব মজলিস',
      userName: _nameController.text.isEmpty ? 'আবেদনকারী' : _nameController.text,
      period: _joinDate != null ? _joinDate!.toLocal().toString().split(' ')[0] : 'বর্তমান',
      dataFields: {
        'আবেদনকারীর নাম': _nameController.text,
        'পিতার নাম': _fatherNameController.text,
        'জাতীয় পরিচয়পত্র নম্বর': _nidController.text,
        'ঠিকানা (গ্রাম/ওয়ার্ড)': _villageController.text,
        'ইউনিয়ন': _unionController.text,
        'থানা / উপজেলা': _thanaUpazilaController.text,
        'জেলা': _districtController.text,
        'বর্তমান ঠিকানা': _presentAddressController.text,
        'মোবাইল নম্বর': _mobileController.text,
        'ইমেইল ঠিকানা': _emailController.text,
        'যোগদানের তারিখ': _joinDate != null ? _joinDate!.toLocal().toString().split(' ')[0] : 'N/A',
      },
      comments: 'আমি ইসলামী আদর্শের আলোকে একটি কল্যাণমুখী সমাজ গড়ার লক্ষ্যে ইসলামী যুব মজলিসে যোগদানের অঙ্গীকার করছি।',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MemberFormBloc>(
      create: (_) => MemberFormBloc(
        repository: MemberFormRepositoryImpl(
          remoteDataSource: MemberFormRemoteDataSourceImpl(),
        ),
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('যুব সদস্য আবেদন ফরম'),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.edit_note_rounded), text: 'সম্পাদনা (Edit)'),
                Tab(icon: Icon(Icons.preview_rounded), text: 'প্রিভিউ ও PDF'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Tab 1: Edit Form
              BlocConsumer<MemberFormBloc, MemberFormState>(
                listener: (context, state) {
                  if (state is MemberFormSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('সদস্য ফরম সফলভাবে জমা দেওয়া হয়েছে!')),
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
                            validator: (v) => v!.isEmpty ? 'নাম লিখুন' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _fatherNameController,
                            decoration: const InputDecoration(labelText: 'পিতার নাম'),
                            validator: (v) => v!.isEmpty ? 'পিতার নাম লিখুন' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _nidController,
                            decoration: const InputDecoration(labelText: 'জাতীয় পরিচয়পত্র নং'),
                            validator: (v) => v!.isEmpty ? 'জাতীয় পরিচয়পত্র লিখুন' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _villageController,
                            decoration: const InputDecoration(labelText: 'ঠিকানা: গ্রাম/ওয়ার্ড'),
                            validator: (v) => v!.isEmpty ? 'গ্রামের নাম লিখুন' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _unionController,
                            decoration: const InputDecoration(labelText: 'ইউনিয়ন'),
                            validator: (v) => v!.isEmpty ? 'ইউনিয়ন লিখুন' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _thanaUpazilaController,
                            decoration: const InputDecoration(labelText: 'থানা ও উপজেলা'),
                            validator: (v) => v!.isEmpty ? 'থানা/উপজেলা লিখুন' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _districtController,
                            decoration: const InputDecoration(labelText: 'জেলা'),
                            validator: (v) => v!.isEmpty ? 'জেলা লিখুন' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _presentAddressController,
                            decoration: const InputDecoration(labelText: 'বর্তমান ঠিকানা'),
                            validator: (v) => v!.isEmpty ? 'বর্তমান ঠিকানা লিখুন' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _mobileController,
                            decoration: const InputDecoration(labelText: 'মোবাইল নম্বর'),
                            keyboardType: TextInputType.phone,
                            validator: (v) => v!.isEmpty ? 'মোবাইল নম্বর লিখুন' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: 'ইমেইল (ঐচ্ছিক)'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _joinDate == null
                                      ? 'যোগদানের তারিখ: নির্বাচন করুন'
                                      : 'যোগদানের তারিখ: ${_joinDate!.toLocal().toString().split(' ')[0]}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              ElevatedButton.icon(
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
                                icon: const Icon(Icons.calendar_today_rounded, size: 16),
                                label: const Text('তারিখ বাছুন'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'আমি দৃঢ়ভাবে বিশ্বাস করি যে, ইসলামই আল্লাহর একমাত্র মনোনীত জীবনব্যবস্থা। ইসলামী আদর্শের আলোকে যুবসমাজের নেতৃত্বে একটি কল্যাণমুখী সমাজ গড়ার লক্ষ্যে ইসলামী যুব মজলিসের সাথে একমত হয়ে এ সংগঠনে যোগদান করছি। আমি এ লক্ষ্য অর্জনে যথাসাধ্য চেষ্টা করবো ইনশাআল্লাহ।',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.5),
                          ),
                          const SizedBox(height: 32),
                          if (state is MemberFormLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            ElevatedButton.icon(
                              onPressed: _submitForm,
                              icon: const Icon(Icons.save_rounded),
                              label: const Text('সংরক্ষণ করুন / জমা দিন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: const Color(0xFF059669),
                                foregroundColor: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Tab 2: Preview & PDF Download Section
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'সদস্য আবেদন ফরম প্রিভিউ',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(20)),
                                  child: const Text('খসড়া', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            _buildPreviewRow('নাম:', _nameController.text.isEmpty ? '(ইনপুট দিন)' : _nameController.text),
                            _buildPreviewRow('পিতার নাম:', _fatherNameController.text.isEmpty ? '(ইনপুট দিন)' : _fatherNameController.text),
                            _buildPreviewRow('জাতীয় পরিচয়পত্র:', _nidController.text.isEmpty ? '(ইনপুট দিন)' : _nidController.text),
                            _buildPreviewRow('গ্রাম/ওয়ার্ড:', _villageController.text.isEmpty ? '(ইনপুট দিন)' : _villageController.text),
                            _buildPreviewRow('ইউনিয়ন:', _unionController.text.isEmpty ? '(ইনপুট দিন)' : _unionController.text),
                            _buildPreviewRow('থানা/উপজেলা:', _thanaUpazilaController.text.isEmpty ? '(ইনপুট দিন)' : _thanaUpazilaController.text),
                            _buildPreviewRow('জেলা:', _districtController.text.isEmpty ? '(ইনপুট দিন)' : _districtController.text),
                            _buildPreviewRow('বর্তমান ঠিকানা:', _presentAddressController.text.isEmpty ? '(ইনপুট দিন)' : _presentAddressController.text),
                            _buildPreviewRow('মোবাইল:', _mobileController.text.isEmpty ? '(ইনপুট দিন)' : _mobileController.text),
                            _buildPreviewRow('ইমেইল:', _emailController.text.isEmpty ? '(N/A)' : _emailController.text),
                            _buildPreviewRow('যোগদানের তারিখ:', _joinDate != null ? _joinDate!.toLocal().toString().split(' ')[0] : '(অনির্ধারিত)'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _exportFormPdf,
                      icon: const Icon(Icons.picture_as_pdf_rounded, size: 22),
                      label: const Text('📥 PDF ডাউনলোড / প্রিন্ট করুন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
