import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/widgets/pdf_viewer_screen.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import '../bloc/member_form_bloc.dart';
import '../bloc/member_form_event.dart';
import '../bloc/member_form_state.dart';

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

  String _serialNumber = '০০১';

  @override
  void initState() {
    super.initState();
    _serialNumber = (100 + (DateTime.now().millisecondsSinceEpoch % 899)).toString();
  }

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
      context.read<MemberFormBloc>().add(
            SubmitMemberFormEvent(
              name: _nameController.text,
              fatherName: _fatherNameController.text,
              educationalQualification: _educationalQualificationController.text,
              age: _ageController.text,
              profession: _professionController.text,
              presentAddress: _presentAddressController.text,
              mobile: _mobileController.text,
              permanentAddress: _permanentAddressController.text,
            ),
          );
    }
  }

  void _openPdfViewer() {
    PdfViewerScreen.open(
      context,
      title: 'খেলাফত মজলিস — প্রাথমিক সদস্য ফরম',
      buildPdf: (format) => PdfExportService.generateSingleFormPdfBytes(
        title: 'প্রাথমিক সদস্য ফরম',
        majlisName: 'বাংলাদেশ খেলাফত মজলিস',
        userName: _nameController.text.isEmpty ? 'সদস্য' : _nameController.text,
        period: 'ফরম নং: $_serialNumber',
        dataFields: {
          'ক্রমিক নং': _serialNumber,
          'নাম': _nameController.text,
          'পিতা': _fatherNameController.text,
          'শিক্ষাগত যোগ্যতা': _educationalQualificationController.text,
          'বয়স ও পেশা': '${_ageController.text} (${_professionController.text})',
          'বর্তমান ঠিকানা': _presentAddressController.text,
          'মোবাইল': _mobileController.text,
          'স্থায়ী ঠিকানা': _permanentAddressController.text,
        },
        comments: 'ইসলামই আল্লাহর একমাত্র মনোনীত জীবনব্যবস্থা। ইসলামী আদর্শের আলোকে যুবসমাজের নেতৃত্বে একটি কল্যাণমুখী সমাজ গড়ার লক্ষ্যে ইসলামী খেলাফত মজলিসের সাথে একমত হয়ে এ সংগঠনে যোগদান করছি।',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final bgColor = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF1F5F9);
    final cardBg = isDark ? const Color(0xFF162032) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 1,
        title: const Text('খেলাফত মজলিস — সদস্য ফরম', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF0284C7)),
            tooltip: 'PDF প্রিভিউ ও ডাউনলোড',
            onPressed: _openPdfViewer,
          ),
        ],
      ),
      body: AmbientBackgroundWidget(
        primaryAccent: const Color(0xFFEC4899),
        child: BlocConsumer<MemberFormBloc, MemberFormState>(
          listener: (context, state) {
            if (state is MemberFormSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ফরম সফলভাবে জমা দেওয়া হয়েছে!')),
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
                    // Top Action Bar
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _openPdfViewer,
                            icon: const Icon(Icons.picture_as_pdf_rounded, size: 20),
                            label: const Text('PDF প্রিভিউ ও ডাউনলোড', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0284C7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF0284C7)]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('প্রাথমিক সদস্য তথ্য', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('ফরম নং: $_serialNumber', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildCardWrapper([
                      _buildSectionTitle('ব্যক্তিগত তথ্য'),
                      const SizedBox(height: 12),
                      _buildTextField(_nameController, 'নাম', 'আপনার পূর্ণ নাম লিখুন', Icons.person),
                      _buildTextField(_fatherNameController, 'পিতার নাম', 'পিতার নাম লিখুন', Icons.person_outline),
                      _buildTextField(_educationalQualificationController, 'শিক্ষাগত যোগ্যতা', 'যেমন: বি.এ, কামিল ইত্যাদি', Icons.school),
                      Row(
                        children: [
                          Expanded(child: _buildTextField(_ageController, 'বয়স', 'যেমন: ২৫', Icons.cake, isNumber: true)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildTextField(_professionController, 'পেশা', 'যেমন: ব্যবসা/চাকরি', Icons.work)),
                        ],
                      ),
                    ], cardBg),
                    const SizedBox(height: 16),

                    _buildCardWrapper([
                      _buildSectionTitle('যোগাযোগের ঠিকানা'),
                      const SizedBox(height: 12),
                      _buildTextField(_presentAddressController, 'বর্তমান ঠিকানা', 'গ্রাম/মহল্লা, ডাকঘর, থানা, জেলা', Icons.location_on),
                      _buildTextField(_mobileController, 'মোবাইল নম্বর', '০১৭XXXXXXXX', Icons.phone, isNumber: true),
                      _buildTextField(_permanentAddressController, 'স্থায়ী ঠিকানা', 'গ্রাম/মহল্লা, ডাকঘর, থানা, জেলা', Icons.home),
                    ], cardBg),
                    const SizedBox(height: 24),

                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: state is MemberFormLoading ? null : _submitForm,
                        icon: state is MemberFormLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.send_rounded),
                        label: Text(
                          state is MemberFormLoading ? 'জমা দেওয়া হচ্ছে...' : 'ফরম সংরক্ষণ করুন',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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

  Widget _buildTextField(TextEditingController controller, String label, String hint, IconData icon, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label দেওয়া আবশ্যক';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF059669), size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          isDense: true,
        ),
      ),
    );
  }
}
