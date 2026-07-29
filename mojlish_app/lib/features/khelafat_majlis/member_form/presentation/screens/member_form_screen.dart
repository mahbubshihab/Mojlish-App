import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/member.dart';
import '../bloc/member_form_bloc.dart';
import '../bloc/member_form_event.dart';
import '../bloc/member_form_state.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';

class MemberFormScreen extends StatefulWidget {
  const MemberFormScreen({super.key});

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

  final String _serialNumber = '24292';

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

  Future<void> _exportFormPdf() async {
    await PdfExportService.printOrDownloadPdf(
      title: 'প্রাথমিক সদস্য ফরম',
      majlisName: 'খেলাফত মজলিস',
      userName: _nameController.text.isEmpty ? 'আবেদনকারী' : _nameController.text,
      period: 'বর্তমান',
      dataFields: {
        'সিরিয়াল নং': _serialNumber,
        'নাম': _nameController.text,
        'পিতার নাম': _fatherNameController.text,
        'শিক্ষাগত যোগ্যতা': _educationalQualificationController.text,
        'বয়স': _ageController.text,
        'পেশা': _professionController.text,
        'বর্তমান ঠিকানা': _presentAddressController.text,
        'মোবাইল': _mobileController.text,
        'স্থায়ী ঠিকানা': _permanentAddressController.text,
      },
      comments: 'আমি ইসলামী খেলাফত প্রতিষ্ঠার লক্ষ্যে খেলাফত মজলিসের লক্ষ্য ও উদ্দেশ্য মেনে নিয়ে প্রাথমিক সদস্য ফরম পূরণ করছি।',
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
          title: const Text('খেলাফত মজলিস — সদস্য ফরম', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
        body: AmbientBackgroundWidget(
          primaryAccent: const Color(0xFFEC4899),
          child: TabBarView(
            children: [
            // Tab 1: Edit Form
            BlocConsumer<MemberFormBloc, MemberFormState>(
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
                                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
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
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _educationalQualificationController,
                                  decoration: const InputDecoration(labelText: 'শিক্ষাগত যোগ্যতা'),
                                  validator: (v) => v!.isEmpty ? 'শিক্ষাগত যোগ্যতা লিখুন' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _ageController,
                                  decoration: const InputDecoration(labelText: 'বয়স'),
                                  validator: (v) => v!.isEmpty ? 'বয়স লিখুন' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _professionController,
                            decoration: const InputDecoration(labelText: 'পেশা', prefixIcon: Icon(Icons.work_outline)),
                            validator: (v) => v!.isEmpty ? 'পেশা লিখুন' : null,
                          ),
                        ], cardBg),
                        const SizedBox(height: 20),

                        _buildSectionTitle('🏡 ঠিকানা ও যোগাযোগ'),
                        const SizedBox(height: 10),
                        _buildCardWrapper([
                          TextFormField(
                            controller: _presentAddressController,
                            decoration: const InputDecoration(labelText: 'বর্তমান ঠিকানা', prefixIcon: Icon(Icons.home_outlined)),
                            validator: (v) => v!.isEmpty ? 'বর্তমান ঠিকানা লিখুন' : null,
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
                            controller: _permanentAddressController,
                            decoration: const InputDecoration(labelText: 'স্থায়ী ঠিকানা', prefixIcon: Icon(Icons.location_city_outlined)),
                            validator: (v) => v!.isEmpty ? 'স্থায়ী ঠিকানা লিখুন' : null,
                          ),
                        ], cardBg),
                        const SizedBox(height: 32),

                        ElevatedButton.icon(
                          onPressed: state is MemberFormLoading ? null : _submitForm,
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
                  _buildBrochureCard('খেলাফত মজলিস'),
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
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
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
                child: const Icon(Icons.star_rounded, color: Colors.white, size: 28),
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
              _buildBrochureRow('শিক্ষাগত যোগ্যতা :', _educationalQualificationController.text.isEmpty ? '(ইনপুট দিন)' : _educationalQualificationController.text),
              _buildBrochureRow('বয়স ও পেশা :', '${_ageController.text} (${_professionController.text})'),
              _buildBrochureRow('বর্তমান ঠিকানা :', _presentAddressController.text.isEmpty ? '(ইনপুট দিন)' : _presentAddressController.text),
              _buildBrochureRow('মোবাইল :', _mobileController.text.isEmpty ? '(ইনপুট দিন)' : _mobileController.text),
              _buildBrochureRow('স্থায়ী ঠিকানা :', _permanentAddressController.text.isEmpty ? '(ইনপুট দিন)' : _permanentAddressController.text),
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
                  'আমি (${_nameController.text.isEmpty ? "..........................." : _nameController.text}) ইসলামী খেলাফত প্রতিষ্ঠার লক্ষ্যে $majlisName এর লক্ষ্য ও উদ্দেশ্য মেনে নিয়ে প্রাথমিক সদস্য ফরম পূরণ করছি।',
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
