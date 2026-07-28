import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/member_form_bloc.dart';
import '../bloc/member_form_event.dart';
import '../bloc/member_form_state.dart';
import 'package:mojlish_app/features/youth_majlis/member_form/domain/entities/member_form_entity.dart';
import 'package:mojlish_app/features/youth_majlis/member_form/data/datasources/member_form_remote_datasource.dart';
import 'package:mojlish_app/features/youth_majlis/member_form/data/repositories/member_form_repository_impl.dart';
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
  final _nidController = TextEditingController();
  final _villageController = TextEditingController();
  final _unionController = TextEditingController();
  final _thanaUpazilaController = TextEditingController();
  final _districtController = TextEditingController();
  final _presentAddressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  DateTime? _joinDate;
  final String _serialNumber = '24292';

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
      title: 'প্রাথমিক সদস্য ফরম',
      majlisName: 'বাংলাদেশ ইসলামী যুব মজলিস',
      userName: _nameController.text.isEmpty ? 'আবেদনকারী' : _nameController.text,
      period: _joinDate != null ? _joinDate!.toLocal().toString().split(' ')[0] : 'বর্তমান',
      dataFields: {
        'ফরম সিরিয়াল নং': _serialNumber,
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
      comments: 'আমি ইসলামী আদর্শের আলোকে একটি কল্যাণমুখী সমাজ গড়ার লক্ষ্যে বাংলাদেশ ইসলামী যুব মজলিস এর সাথে একমত হয়ে এ সংগঠনে যোগদান করছি। আমি এ লক্ষ্য অর্জনে যথাসাধ্য চেষ্টা করবো ইনশাআল্লাহ।',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final bgColor = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF1F5F9);
    final cardBg = isDark ? const Color(0xFF162032) : Colors.white;

    return BlocProvider<MemberFormBloc>(
      create: (_) => MemberFormBloc(
        repository: MemberFormRepositoryImpl(
          remoteDataSource: MemberFormRemoteDataSourceImpl(),
        ),
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: cardBg,
            elevation: 1,
            title: const Text('যুব মজলিস — সদস্য ফরম', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

                          _buildSectionTitle('👤 ব্যক্তিগত তথ্য'),
                          const SizedBox(height: 10),
                          _buildCardWrapper([
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(labelText: 'আবেদনকারীর নাম', prefixIcon: Icon(Icons.person_outline)),
                              validator: (v) => v!.isEmpty ? 'নাম লিখুন' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _fatherNameController,
                              decoration: const InputDecoration(labelText: 'পিতার নাম', prefixIcon: Icon(Icons.person_2_outlined)),
                              validator: (v) => v!.isEmpty ? 'পিতার নাম লিখুন' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _nidController,
                              decoration: const InputDecoration(labelText: 'জাতীয় পরিচয়পত্র নং', prefixIcon: Icon(Icons.badge_outlined)),
                              validator: (v) => v!.isEmpty ? 'জাতীয় পরিচয়পত্র লিখুন' : null,
                            ),
                          ], cardBg),
                          const SizedBox(height: 20),

                          _buildSectionTitle('🏡 ঠিকানা ও যোগাযোগ'),
                          const SizedBox(height: 10),
                          _buildCardWrapper([
                            TextFormField(
                              controller: _villageController,
                              decoration: const InputDecoration(labelText: 'ঠিকানা: গ্রাম /ওয়ার্ড', prefixIcon: Icon(Icons.home_outlined)),
                              validator: (v) => v!.isEmpty ? 'গ্রামের নাম লিখুন' : null,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _unionController,
                                    decoration: const InputDecoration(labelText: 'ইউনিয়ন'),
                                    validator: (v) => v!.isEmpty ? 'ইউনিয়ন লিখুন' : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _thanaUpazilaController,
                                    decoration: const InputDecoration(labelText: 'থানা ও উপজেলা'),
                                    validator: (v) => v!.isEmpty ? 'থানা/উপজেলা লিখুন' : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _districtController,
                                    decoration: const InputDecoration(labelText: 'জেলা'),
                                    validator: (v) => v!.isEmpty ? 'জেলা লিখুন' : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _presentAddressController,
                                    decoration: const InputDecoration(labelText: 'বর্তমান ঠিকানা'),
                                    validator: (v) => v!.isEmpty ? 'বর্তমান ঠিকানা লিখুন' : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _mobileController,
                              decoration: const InputDecoration(labelText: 'মোবাইল নম্বর', prefixIcon: Icon(Icons.phone_android_outlined)),
                              keyboardType: TextInputType.phone,
                              validator: (v) => v!.isEmpty ? 'মোবাইল নম্বর লিখুন' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(labelText: 'ইমেইল (ঐচ্ছিক)', prefixIcon: Icon(Icons.email_outlined)),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ], cardBg),
                          const SizedBox(height: 20),

                          _buildSectionTitle('📅 যোগদানের তারিখ'),
                          const SizedBox(height: 10),
                          _buildCardWrapper([
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _joinDate == null
                                        ? 'যোগদানের তারিখ: নির্বাচন করুন'
                                        : 'যোগদানের তারিখ: ${_joinDate!.toLocal().toString().split(' ')[0]}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                              'আমি (${_nameController.text.isEmpty ? "আবেদনকারী" : _nameController.text}) দৃঢ়ভাবে বিশ্বাস করি যে, ইসলামই আল্লাহর একমাত্র মনোনীত জীবনব্যবস্থা। ইসলামী আদর্শের আলোকে একটি কল্যাণমুখী সমাজ গড়ার লক্ষ্যে বাংলাদেশ ইসলামী যুব মজলিস এর সাথে একমত হয়ে এ সংগঠনে যোগদান করছি। আমি এ লক্ষ্য অর্জনে যথাসাধ্য চেষ্টা করবো ইনশাআল্লাহ।',
                              textAlign: TextAlign.justify,
                              style: const TextStyle(color: Color(0xFF78350F), fontWeight: FontWeight.bold, fontSize: 13, height: 1.5),
                            ),
                          ),
                          const SizedBox(height: 32),

                          if (state is MemberFormLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            ElevatedButton.icon(
                              onPressed: _submitForm,
                              icon: const Icon(Icons.check_circle_rounded),
                              label: const Text('সংরক্ষণ করুন / জমা দিন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    _buildBrochureCard('বাংলাদেশ ইসলামী যুব মজলিস'),
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
                child: const Icon(Icons.public_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('বিসমিল্লাহির রাহমানির রাহিম', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(majlisName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                    const Text('১৬, বিজয়নগর, (৫ম তলা), পুরানা পল্টন, ঢাকা-১০০০', style: TextStyle(fontSize: 9, color: Colors.grey)),
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
                    child: const Text('প্রাথমিক সদস্য ফরম', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
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
              _buildBrochureRow('জাতীয় পরিচয়পত্র নং :', _nidController.text.isEmpty ? '(ইনপুট দিন)' : _nidController.text),
              _buildBrochureRow('ঠিকানা: গ্রাম :', _villageController.text.isEmpty ? '(ইনপুট দিন)' : _villageController.text),
              _buildBrochureRow('ইউনিয়ন :', _unionController.text.isEmpty ? '(ইনপুট দিন)' : _unionController.text),
              _buildBrochureRow('থানা ও উপজেলা :', _thanaUpazilaController.text.isEmpty ? '(ইনপুট দিন)' : _thanaUpazilaController.text),
              _buildBrochureRow('জেলা :', _districtController.text.isEmpty ? '(ইনপুট দিন)' : _districtController.text),
              _buildBrochureRow('বর্তমান ঠিকানা :', _presentAddressController.text.isEmpty ? '(ইনপুট দিন)' : _presentAddressController.text),
              _buildBrochureRow('মোবাইল :', _mobileController.text.isEmpty ? '(ইনপুট দিন)' : _mobileController.text),
              _buildBrochureRow('ইমেইল :', _emailController.text.isEmpty ? '(N/A)' : _emailController.text),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('যোগদানের তারিখ: ${_joinDate != null ? _joinDate!.toLocal().toString().split(' ')[0] : '...........'}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const Text('স্বাক্ষর: ....................', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
                ],
              ),
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
                  'আমি (${_nameController.text.isEmpty ? "..........................." : _nameController.text})  দৃঢ়ভাবে বিশ্বাস করি যে, ইসলামই আল্লাহর একমাত্র মনোনীত জীবনব্যবস্থা। ইসলামী আদর্শের আলোকে যুবসমাজের নেতৃত্বে একটি কল্যাণমুখী সমাজ গড়ার লক্ষ্যে $majlisName এর সাথে একমত হয়ে এ সংগঠনে যোগদান করছি।\n\nআমি এ লক্ষ্য অর্জনে যথাসাধ্য চেষ্টা করবো ইনশাআল্লাহ।',
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 11, height: 1.4, color: Colors.black87),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('তারিখ : ${_joinDate != null ? _joinDate!.toLocal().toString().split(' ')[0] : '...........'}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    const Text('স্বাক্ষর : ................', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
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
