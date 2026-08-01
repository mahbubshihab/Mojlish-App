import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/widgets/pdf_viewer_screen.dart';
import 'package:mojlish_app/core/widgets/unsaved_changes_dialog.dart';
import '../bloc/member_form_bloc.dart';
import '../bloc/member_form_event.dart';
import '../bloc/member_form_state.dart';
import '../../data/datasources/member_form_remote_datasource.dart';
import '../../data/repositories/member_form_repository_impl.dart';
import '../../data/services/student_member_form_pdf_service.dart';

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

  void _openPdfViewer() {
    PdfViewerScreen.open(
      context,
      title: 'ছাত্র মজলিস — প্রাথমিক সদস্য ফরম',
      buildPdf: (format) => StudentMemberFormPdfService.generatePdfBytes(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final appBarBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textLight = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    const accentPink = Color(0xFFEC4899);
    const accentBlue = Color(0xFF0284C7);
    const accentEmerald = Color(0xFF10B981);

    return BlocProvider<MemberFormBloc>(
      create: (_) => MemberFormBloc(
        repository: MemberFormRepositoryImpl(
          remoteDataSource: MemberFormRemoteDataSourceImpl(),
        ),
      ),
      child: UnsavedChangesGuard(
        hasUnsavedChanges: _nameController.text.isNotEmpty || _mobileController.text.isNotEmpty,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: textLight, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'প্রাথমিক সদস্য ফরম',
              style: TextStyle(color: textLight, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: accentBlue.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: accentBlue, size: 20),
                ),
                onPressed: _openPdfViewer,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: AmbientBackgroundWidget(
            primaryAccent: accentBlue,
            child: BlocConsumer<MemberFormBloc, MemberFormState>(
              listener: (context, state) {
                if (state is MemberFormSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('সদস্য ফরম সফলভাবে জমা দেওয়া হয়েছে!'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                  Navigator.pop(context);
                } else if (state is MemberFormError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ত্রুটি: ${state.message}')),
                  );
                }
              },
              builder: (context, state) {
                final isSubmitting = state is MemberFormLoading;

                return Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Top Action Buttons Row
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFDB2777), Color(0xFFEC4899)],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: accentPink.withValues(alpha: 0.25),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: isSubmitting ? null : _submit,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      isSubmitting
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                            )
                                          : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'ফরম জমা দিন',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: accentBlue.withValues(alpha: 0.25),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: _openPdfViewer,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.file_download_outlined, color: Colors.white, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'PDF প্রিভিউ',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Reg Box Banner
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: accentPink.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: accentPink.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.badge_rounded, color: accentPink, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'প্রাথমিক সদস্য ফরম',
                              style: TextStyle(color: textLight, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const Spacer(),
                            const Icon(Icons.auto_awesome, color: accentPink, size: 18),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Personal Information Section Card
                      _buildSectionCard(
                        title: 'ব্যক্তিগত তথ্যাবলী',
                        icon: Icons.person_rounded,
                        color: accentPink,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textLight: textLight,
                        children: [
                          _buildInputField(
                            controller: _nameController,
                            label: 'নাম',
                            hint: 'আপনার পূর্ণ নাম লিখুন',
                            icon: Icons.person_outline_rounded,
                            isDark: isDark,
                            accentColor: accentPink,
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'নাম প্রদান করুন' : null,
                          ),
                          const SizedBox(height: 12),
                          _buildInputField(
                            controller: _fatherNameController,
                            label: 'পিতার নাম',
                            hint: 'পিতার নাম লিখুন',
                            icon: Icons.family_restroom_rounded,
                            isDark: isDark,
                            accentColor: accentPink,
                          ),
                          const SizedBox(height: 12),
                          _buildInputField(
                            controller: _eduController,
                            label: 'শিক্ষা প্রতিষ্ঠান',
                            hint: 'প্রতিষ্ঠানের নাম লিখুন',
                            icon: Icons.school_rounded,
                            isDark: isDark,
                            accentColor: accentPink,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  controller: _classController,
                                  label: 'শ্রেণি / বর্ষ',
                                  hint: 'যেমন: একাদশ',
                                  icon: Icons.menu_book_rounded,
                                  isDark: isDark,
                                  accentColor: accentPink,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInputField(
                                  controller: _deptController,
                                  label: 'বিভাগ',
                                  hint: 'যেমন: বিজ্ঞান',
                                  icon: Icons.category_rounded,
                                  isDark: isDark,
                                  accentColor: accentPink,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  controller: _rollController,
                                  label: 'রোল / ক্রমিক নং',
                                  hint: '১০১',
                                  icon: Icons.numbers_rounded,
                                  isDark: isDark,
                                  accentColor: accentPink,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInputField(
                                  controller: _bloodGroupController,
                                  label: 'রক্তের গ্রুপ',
                                  hint: 'B+',
                                  icon: Icons.bloodtype_rounded,
                                  isDark: isDark,
                                  accentColor: accentPink,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInputField(
                            controller: _mobileController,
                            label: 'মোবাইল নম্বর',
                            hint: '০১৭................',
                            icon: Icons.phone_android_rounded,
                            isDark: isDark,
                            accentColor: accentPink,
                            keyboardType: TextInputType.phone,
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'মোবাইল নম্বর প্রদান করুন' : null,
                          ),
                          const SizedBox(height: 12),
                          _buildInputField(
                            controller: _presentAddressController,
                            label: 'বর্তমান ঠিকানা',
                            hint: 'বাসা/রোড, থানা, জেলা...',
                            icon: Icons.home_rounded,
                            isDark: isDark,
                            accentColor: accentPink,
                          ),
                          const SizedBox(height: 12),
                          _buildInputField(
                            controller: _villageController,
                            label: 'স্থায়ী ঠিকানা (গ্রাম)',
                            hint: 'গ্রামের নাম...',
                            icon: Icons.place_rounded,
                            isDark: isDark,
                            accentColor: accentPink,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  controller: _postOfficeController,
                                  label: 'ডাকঘর',
                                  hint: 'ডাকঘরের নাম',
                                  icon: Icons.markunread_mailbox_rounded,
                                  isDark: isDark,
                                  accentColor: accentPink,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInputField(
                                  controller: _thanaController,
                                  label: 'থানা',
                                  hint: 'থানার নাম',
                                  icon: Icons.location_city_rounded,
                                  isDark: isDark,
                                  accentColor: accentPink,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInputField(
                            controller: _districtController,
                            label: 'জেলা',
                            hint: 'জেলার নাম',
                            icon: Icons.map_rounded,
                            isDark: isDark,
                            accentColor: accentPink,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Oath Section Card
                      _buildSectionCard(
                        title: 'শপথ ও অঙ্গীকারনামা',
                        icon: Icons.check_circle_outline_rounded,
                        color: accentEmerald,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textLight: textLight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.5) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                            ),
                            child: Text(
                              'আমি দৃঢ়ভাবে বিশ্বাস করি যে, ইসলামই মানুষের জন্য এক মাত্র জীবন ব্যবস্থা। জীবনের সর্বক্ষেত্রে ইসলামের বিধান প্রতিপালন ও আল-কুরআনের নির্দেশিত পথে জীবন পরিচালনার মাধ্যমে আল্লহ তা\'য়ালার সন্তুষ্টি লাভই আমার জীবনের মূল উদ্দেশ্য।',
                              style: TextStyle(
                                color: textLight,
                                fontSize: 13,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Color cardBg,
    required Color borderColor,
    required Color textLight,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: textLight, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    required Color accentColor,
    String? suffix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              fontSize: 13,
            ),
            prefixIcon: Icon(icon, color: accentColor, size: 18),
            suffixText: suffix,
            suffixStyle: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.7) : const Color(0xFFF1F5F9),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accentColor, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }
}
