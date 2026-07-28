import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/member_form_bloc.dart';
import '../bloc/member_form_event.dart';
import '../bloc/member_form_state.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';

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

  final String _serialNumber = '24292';

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

  Future<void> _exportFormPdf() async {
    await PdfExportService.printOrDownloadPdf(
      title: 'ছাত্র সদস্য আবেদন ফরম',
      majlisName: 'বাংলাদেশ ইসলামী ছাত্র মজলিস',
      userName: _nameController.text.isEmpty ? 'আবেদনকারী' : _nameController.text,
      period: 'বর্তমান',
      dataFields: {
        'সিরিয়াল নং': _serialNumber,
        'নাম': _nameController.text,
        'পিতার নাম': _fatherNameController.text,
        'শিক্ষা প্রতিষ্ঠান': _eduController.text,
        'রক্তের গ্রুপ': _bloodGroupController.text,
        'শ্রেণি': _classController.text,
        'বিভাগ': _deptController.text,
        'ক্রমিক নং': _rollController.text,
        'বর্তমান ঠিকানা': _presentAddressController.text,
        'মোবাইল': _mobileController.text,
        'স্থায়ী গ্রাম': _villageController.text,
        'ডাকঘর': _postOfficeController.text,
        'থানা': _thanaController.text,
        'জেলা': _districtController.text,
      },
      comments: 'আমি বিশ্বাস করি যে, ইসলাম আল্লাহর মনোনীত দ্বীন বা জীবনব্যবস্থা এবং এর পূর্ণাঙ্গ অনুসরণের মধ্যেই মানব জীবনে ইহকালীন কল্যাণ ও পরকালীন মুক্তি নিহিত। এ উদ্দেশ্যে বাংলাদেশ ইসলামী ছাত্র মজলিস যে কর্মসূচি গ্রহণ করেছে, আমি তার সাথে একমত হয়ে আল্লাহর সন্তুষ্টি অর্জনের জন্যে এ সংগঠনে যোগদান করছি।',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final bgColor = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF1F5F9);
    final cardBg = isDark ? const Color(0xFF162032) : Colors.white;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: cardBg,
          elevation: 1,
          title: const Text('ছাত্র মজলিস — সদস্য ফরম', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          bottom: const TabBar(
            indicatorColor: Color(0xFF059669),
            indicatorWeight: 3,
            labelColor: Color(0xFF059669),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(icon: Icon(Icons.edit_note_rounded), text: '১. তথ্য পূরণ'),
              Tab(icon: Icon(Icons.print_rounded), text: '২. প্রিভিউ ও PDF'),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF0284C7)]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('প্রাথমিক সদস্য ফরম', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                                child: Text('ফরম নং: $_serialNumber', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildSectionTitle('👤 ব্যক্তিগত ও শিক্ষাগত তথ্য'),
                        const SizedBox(height: 10),
                        _buildCardWrapper([
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: 'নাম (Name)', prefixIcon: Icon(Icons.person_outline)),
                            validator: (v) => v!.isEmpty ? 'নাম লিখুন' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _fatherNameController,
                            decoration: const InputDecoration(labelText: "পিতার নাম (Father's Name)", prefixIcon: Icon(Icons.person_2_outlined)),
                            validator: (v) => v!.isEmpty ? 'পিতার নাম লিখুন' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _eduController,
                            decoration: const InputDecoration(labelText: 'শিক্ষা প্রতিষ্ঠান (Educational Institution)', prefixIcon: Icon(Icons.school_outlined)),
                            validator: (v) => v!.isEmpty ? 'শিক্ষা প্রতিষ্ঠান লিখুন' : null,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _classController,
                                  decoration: const InputDecoration(labelText: 'শ্রেণি (Class)'),
                                  validator: (v) => v!.isEmpty ? 'শ্রেণি লিখুন' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _deptController,
                                  decoration: const InputDecoration(labelText: 'বিভাগ (Department)'),
                                  validator: (v) => v!.isEmpty ? 'বিভাগ লিখুন' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _rollController,
                                  decoration: const InputDecoration(labelText: 'ক্রমিক নং (Roll No)'),
                                  validator: (v) => v!.isEmpty ? 'ক্রমিক নং লিখুন' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _bloodGroupController,
                                  decoration: const InputDecoration(labelText: 'রক্তের গ্রুপ (Blood Group)'),
                                  validator: (v) => v!.isEmpty ? 'রক্তের গ্রুপ লিখুন' : null,
                                ),
                              ),
                            ],
                          ),
                        ], cardBg),
                        const SizedBox(height: 20),

                        _buildSectionTitle('🏡 ঠিকানা ও যোগাযোগ'),
                        const SizedBox(height: 10),
                        _buildCardWrapper([
                          TextFormField(
                            controller: _presentAddressController,
                            decoration: const InputDecoration(labelText: 'বর্তমান ঠিকানা (Present Address)', prefixIcon: Icon(Icons.home_outlined)),
                            validator: (v) => v!.isEmpty ? 'বর্তমান ঠিকানা লিখুন' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _mobileController,
                            decoration: const InputDecoration(labelText: 'মোবাইল (Mobile)', prefixIcon: Icon(Icons.phone_android_outlined)),
                            keyboardType: TextInputType.phone,
                            validator: (v) => v!.isEmpty ? 'মোবাইল লিখুন' : null,
                          ),
                          const SizedBox(height: 12),
                          const Text('স্থায়ী ঠিকানা (Permanent Address)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF059669))),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _villageController,
                                  decoration: const InputDecoration(labelText: 'গ্রাম (Village)'),
                                  validator: (v) => v!.isEmpty ? 'গ্রাম লিখুন' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _postOfficeController,
                                  decoration: const InputDecoration(labelText: 'ডাকঘর (Post Office)'),
                                  validator: (v) => v!.isEmpty ? 'ডাকঘর লিখুন' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _thanaController,
                                  decoration: const InputDecoration(labelText: 'থানা/উপজেলা (Thana)'),
                                  validator: (v) => v!.isEmpty ? 'থানা লিখুন' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _districtController,
                                  decoration: const InputDecoration(labelText: 'জেলা (District)'),
                                  validator: (v) => v!.isEmpty ? 'জেলা লিখুন' : null,
                                ),
                              ),
                            ],
                          ),
                        ], cardBg),
                        const SizedBox(height: 20),

                        _buildSectionTitle('📜 অঙ্গীকারনামা'),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            border: Border.all(color: const Color(0xFFF59E0B)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'আমি (${_nameController.text.isEmpty ? "আবেদনকারী" : _nameController.text}) বিশ্বাস করি যে, ইসলাম আল্লাহর মনোনীত দ্বীন বা জীবনব্যবস্থা এবং এর পূর্ণাঙ্গ অনুসরণের মধ্যেই মানব জীবনে ইহকালীন কল্যাণ ও পরকালীন মুক্তি নিহিত। এ উদ্দেশ্যে বাংলাদেশ ইসলামী ছাত্র মজলিস যে কর্মসূচি গ্রহণ করেছে, আমি তার সাথে একমত হয়ে আল্লাহর সন্তুষ্টি অর্জনের জন্যে এ সংগঠনে যোগদান করছি।',
                            textAlign: TextAlign.justify,
                            style: const TextStyle(color: Color(0xFF78350F), fontWeight: FontWeight.bold, fontSize: 13, height: 1.5),
                          ),
                        ),
                        const SizedBox(height: 32),

                        ElevatedButton.icon(
                          onPressed: state is MemberFormLoading ? null : _submit,
                          icon: const Icon(Icons.check_circle_rounded),
                          label: state is MemberFormLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('সংরক্ষণ করুন / জমা দিন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF059669),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Tab 2: Preview
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBrochureCard('বাংলাদেশ ইসলামী ছাত্র মজলিস'),
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
                      elevation: 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
    );
  }

  Widget _buildCardWrapper(List<Widget> children, Color cardBg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildBrochureCard(String majlisName) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(color: Color(0xFF059669), shape: BoxShape.circle),
                child: const Icon(Icons.school_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('বিসমিল্লাহির রাহমানির রাহিম', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(majlisName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                    const Text('কেন্দ্রীয় কার্যালয়: ঢাকা', style: TextStyle(fontSize: 9, color: Colors.grey)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_serialNumber, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 2)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFF059669), borderRadius: BorderRadius.circular(20)),
                    child: const Text('ছাত্র সদস্য ফরম', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 20, thickness: 1.5, color: Colors.black26),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBrochureRow('নাম :', _nameController.text.isEmpty ? '(ইনপুট দিন)' : _nameController.text),
              _buildBrochureRow('পিতা :', _fatherNameController.text.isEmpty ? '(ইনপুট দিন)' : _fatherNameController.text),
              _buildBrochureRow('শিক্ষা প্রতিষ্ঠান :', _eduController.text.isEmpty ? '(ইনপুট দিন)' : _eduController.text),
              _buildBrochureRow('শ্রেণি ও বিভাগ :', '${_classController.text} (${_deptController.text})'),
              _buildBrochureRow('রক্তের গ্রুপ :', _bloodGroupController.text.isEmpty ? '(ইনপুট দিন)' : _bloodGroupController.text),
              _buildBrochureRow('বর্তমান ঠিকানা :', _presentAddressController.text.isEmpty ? '(ইনপুট দিন)' : _presentAddressController.text),
              _buildBrochureRow('মোবাইল :', _mobileController.text.isEmpty ? '(ইনপুট দিন)' : _mobileController.text),
              _buildBrochureRow('স্থায়ী ঠিকানা :', '${_villageController.text}, ${_postOfficeController.text}, ${_thanaController.text}, ${_districtController.text}'),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              border: Border.all(color: Colors.black54, width: 1.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('বিসমিল্লাহির রাহমানির রাহিম', style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(majlisName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                const SizedBox(height: 6),
                Text(
                  'আমি (${_nameController.text.isEmpty ? "..........................." : _nameController.text}) বিশ্বাস করি যে, ইসলাম আল্লাহর মনোনীত দ্বীন বা জীবনব্যবস্থা এবং এর পূর্ণাঙ্গ অনুসরণের মধ্যেই মানব জীবনে ইহকালীন কল্যাণ ও পরকালীন মুক্তি নিহিত। এ উদ্দেশ্যে $majlisName যে কর্মসূচি গ্রহণ করেছে, আমি তার সাথে একমত হয়ে আল্লাহর সন্তুষ্টি অর্জনের জন্যে এ সংগঠনে যোগদান করছি।',
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 11, height: 1.4, color: Colors.black87),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('তারিখ : .....................', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('স্বাক্ষর : ................', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrochureRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black87)),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 2),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid)),
              ),
              child: Text(
                value,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E3A8A)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
