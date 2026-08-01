import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import '../bloc/member_form_bloc.dart';
import '../bloc/member_form_event.dart';
import '../bloc/member_form_state.dart';
import '../../data/datasources/member_form_remote_datasource.dart';
import '../../data/repositories/member_form_repository_impl.dart';
import '../../data/services/student_member_form_pdf_service.dart';
import 'package:mojlish_app/core/widgets/custom_labeled_input_field.dart';

typedef ChatroMemberFormScreen = MemberFormScreen;

class MemberFormScreen extends StatefulWidget {
  const MemberFormScreen({super.key});

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
    await StudentMemberFormPdfService.printOrDownloadPdf(
      name: _nameController.text,
      fatherName: _fatherNameController.text,
      eduInstitution: _eduController.text,
      bloodGroup: _bloodGroupController.text,
      studentClass: _classController.text,
      department: _deptController.text,
      rollNo: _rollController.text,
      presentAddress: _presentAddressController.text,
      mobile: _mobileController.text,
      village: _villageController.text,
      postOffice: _postOfficeController.text,
      thana: _thanaController.text,
      district: _districtController.text,
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
            title: const Text(
              'বাংলাদেশ ইসলামী ছাত্র মজলিস — সদস্য ফরম',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            bottom: const TabBar(
              indicatorColor: Color(0xFF0284C7),
              indicatorWeight: 3,
              labelColor: Color(0xFF0284C7),
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: [
                Tab(icon: Icon(Icons.edit_note_rounded), text: '১. তথ্য পূরণ'),
                Tab(icon: Icon(Icons.print_rounded), text: '২. প্রিভিউ ও PDF'),
              ],
            ),
          ),
          body: AmbientBackgroundWidget(
            primaryAccent: const Color(0xFF0284C7),
            child: TabBarView(
              children: [
                // Tab 1: Edit Form
                BlocConsumer<MemberFormBloc, MemberFormState>(
                  listener: (context, state) {
                    if (state is MemberFormSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ফরম সফলভাবে সংরক্ষিত হয়েছে')),
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
                                gradient: const LinearGradient(colors: [Color(0xFF0284C7), Color(0xFF0369A1)]),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'প্রাথমিক সদস্য ফরম',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'ফরম নং: $_serialNumber',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            _buildSectionTitle('👤 ব্যক্তিগত ও শিক্ষাগত তথ্য'),
                            const SizedBox(height: 10),
                            _buildCardWrapper([
                              CustomLabeledInputField(
                                controller: _nameController,
                                label: 'নাম (Name)',
                                prefixIcon: const Icon(Icons.person_outline),
                                validator: (v) => v!.isEmpty ? 'নাম লিখুন' : null,
                              ),
                              const SizedBox(height: 12),
                              CustomLabeledInputField(
                                controller: _fatherNameController,
                                label: "পিতার নাম (Father's Name)",
                                prefixIcon: const Icon(Icons.person_2_outlined),
                                validator: (v) => v!.isEmpty ? 'পিতার নাম লিখুন' : null,
                              ),
                              const SizedBox(height: 12),
                              CustomLabeledInputField(
                                controller: _eduController,
                                label: 'শিক্ষা প্রতিষ্ঠান (Educational Institution)',
                                prefixIcon: const Icon(Icons.school_outlined),
                                validator: (v) => v!.isEmpty ? 'শিক্ষা প্রতিষ্ঠান লিখুন' : null,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomLabeledInputField(
                                      controller: _classController,
                                      label: 'শ্রেণি (Class)',
                                      validator: (v) => v!.isEmpty ? 'শ্রেণি লিখুন' : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomLabeledInputField(
                                      controller: _deptController,
                                      label: 'বিভাগ (Department)',
                                      validator: (v) => v!.isEmpty ? 'বিভাগ লিখুন' : null,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomLabeledInputField(
                                      controller: _rollController,
                                      label: 'ক্রমিক নং (Roll No)',
                                      validator: (v) => v!.isEmpty ? 'ক্রমিক নং লিখুন' : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomLabeledInputField(
                                      controller: _bloodGroupController,
                                      label: 'রক্তের গ্রুপ (Blood Group)',
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
                              CustomLabeledInputField(
                                controller: _presentAddressController,
                                label: 'বর্তমান ঠিকানা (Present Address)',
                                prefixIcon: const Icon(Icons.home_outlined),
                                validator: (v) => v!.isEmpty ? 'বর্তমান ঠিকানা লিখুন' : null,
                              ),
                              const SizedBox(height: 12),
                              CustomLabeledInputField(
                                controller: _mobileController,
                                label: 'মোবাইল (Mobile)',
                                prefixIcon: const Icon(Icons.phone_android_outlined),
                                keyboardType: TextInputType.phone,
                                validator: (v) => v!.isEmpty ? 'মোবাইল লিখুন' : null,
                              ),
                              const SizedBox(height: 12),
                              const Text('স্থায়ী ঠিকানা (Permanent Address)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0284C7))),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomLabeledInputField(
                                      controller: _villageController,
                                      label: 'গ্রাম (Village)',
                                      validator: (v) => v!.isEmpty ? 'গ্রাম লিখুন' : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomLabeledInputField(
                                      controller: _postOfficeController,
                                      label: 'ডাকঘর (Post Office)',
                                      validator: (v) => v!.isEmpty ? 'ডাকঘর লিখুন' : null,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomLabeledInputField(
                                      controller: _thanaController,
                                      label: 'থানা/উপজেলা (Thana)',
                                      validator: (v) => v!.isEmpty ? 'থানা লিখুন' : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomLabeledInputField(
                                      controller: _districtController,
                                      label: 'জেলা (District)',
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
                                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFFEF3C7),
                                border: Border.all(color: const Color(0xFFF59E0B)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'আমি (${_nameController.text.isEmpty ? "আবেদনকারী" : _nameController.text}) বিশ্বাস করি যে, ইসলাম আল্লাহর মনোনীত দ্বীন বা জীবনব্যবস্থা এবং এর পূর্ণাঙ্গ অনুসরণের মধ্যেই মানব জীবনে ইহকালীন কল্যাণ ও পরকালীন মুক্তি নিহিত। এ উদ্দেশ্যে বাংলাদেশ ইসলামী ছাত্র মজলিস যে কর্মসূচি গ্রহণ করেছে, আমি তার সাথে একমত হয়ে আল্লাহর সন্তুষ্টি অর্জনের জন্যে এ সংগঠনে যোগদান করছি।',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: isDark ? const Color(0xFFFCD34D) : const Color(0xFF78350F),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  height: 1.5,
                                ),
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
                                backgroundColor: const Color(0xFF0284C7),
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

                // Tab 2: Preview & Export PDF
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
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
    );
  }

  Widget _buildCardWrapper(List<Widget> children, Color cardBg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
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
        border: Border.all(color: Colors.cyan.shade700, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // PART 1: Top Pledge Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF0284C7), width: 1),
            ),
            child: Column(
              children: [
                const Text('বিসমিল্লাহির রাহমানির রাহিম', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(MajlisAssets.chatroLogo, width: 28, height: 28, errorBuilder: (context, error, stackTrace) => const Icon(Icons.school_rounded, color: Color(0xFF0284C7), size: 28)),
                    const SizedBox(width: 8),
                    Text(majlisName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
                  ],
                ),
                const SizedBox(height: 2),
                const Text('www.chhatra-majlis.org.bd', style: TextStyle(fontSize: 10, color: Color(0xFF0284C7), fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  color: const Color(0xFF0284C7),
                  child: const Center(
                    child: Text('প্রাথমিক সদস্য ফরম', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'আমি ${_nameController.text.isEmpty ? "............................................................" : _nameController.text} বিশ্বাস করি যে,',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'ইসলাম আল্লাহর মনোনীত দ্বীন বা জীবনব্যবস্থা এবং এর পূর্ণাঙ্গ অনুসরণের মধ্যেই মানব জীবনে ইহকালীন কল্যাণ ও পরকালীন মুক্তি নিহিত। এ উদ্দেশ্যে বাংলাদেশ ইসলামী ছাত্র মজলিস যে কর্মসূচি গ্রহণ করেছে, আমি তার সাথে একমত হয়ে আল্লাহর সন্তুষ্টি অর্জনের জন্যে এ সংগঠনে যোগদান করছি।',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 11.5, height: 1.4, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('তারিখ : .....................', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text('স্বাক্ষর : .....................', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // PART 2: Bottom Personal Info Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF0284C7), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(MajlisAssets.chatroLogo, width: 28, height: 28, errorBuilder: (context, error, stackTrace) => const Icon(Icons.school_rounded, color: Color(0xFF0284C7), size: 28)),
                    const SizedBox(width: 8),
                    Text(majlisName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
                  ],
                ),
                const SizedBox(height: 12),
                _buildBrochureRow('নাম :', _nameController.text.isEmpty ? '....................................................................................................' : _nameController.text),
                _buildBrochureRow('পিতার নাম :', _fatherNameController.text.isEmpty ? '....................................................................................................' : _fatherNameController.text),
                Row(
                  children: [
                    Expanded(child: _buildBrochureRow('শিক্ষা প্রতিষ্ঠান :', _eduController.text.isEmpty ? '................................................' : _eduController.text)),
                    const SizedBox(width: 8),
                    _buildBrochureRow('রক্তের গ্রুপ :', _bloodGroupController.text.isEmpty ? '....................' : _bloodGroupController.text),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildBrochureRow('শ্রেণি :', _classController.text.isEmpty ? '....................' : _classController.text)),
                    Expanded(child: _buildBrochureRow('বিভাগ :', _deptController.text.isEmpty ? '....................' : _deptController.text)),
                    _buildBrochureRow('ক্রমিক নং :', _rollController.text.isEmpty ? '....................' : _rollController.text),
                  ],
                ),
                _buildBrochureRow('বর্তমান ঠিকানা :', _presentAddressController.text.isEmpty ? '....................................................................................................' : _presentAddressController.text),
                _buildBrochureRow('মোবাইল :', _mobileController.text.isEmpty ? '....................................................................................................' : _mobileController.text),
                Row(
                  children: [
                    Expanded(child: _buildBrochureRow('স্থায়ী ঠিকানা : গ্রাম :', _villageController.text.isEmpty ? '........................................' : _villageController.text)),
                    const SizedBox(width: 8),
                    _buildBrochureRow('ডাকঘর :', _postOfficeController.text.isEmpty ? '........................................' : _postOfficeController.text),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildBrochureRow('থানা/উপজেলা :', _thanaController.text.isEmpty ? '........................................' : _thanaController.text)),
                    const SizedBox(width: 8),
                    _buildBrochureRow('জেলা :', _districtController.text.isEmpty ? '........................................' : _districtController.text),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('তারিখ : .....................', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text('স্বাক্ষর : .....................', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
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
