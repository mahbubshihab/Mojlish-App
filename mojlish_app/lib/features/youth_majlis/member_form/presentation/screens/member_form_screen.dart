import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/widgets/pdf_viewer_screen.dart';
import 'package:mojlish_app/core/widgets/unsaved_changes_dialog.dart';
import '../bloc/member_form_bloc.dart';
import '../bloc/member_form_event.dart';
import '../bloc/member_form_state.dart';
import '../../domain/entities/member_form_entity.dart';
import '../../data/datasources/member_form_remote_datasource.dart';
import '../../data/repositories/member_form_repository_impl.dart';
import '../../data/services/jubo_member_form_pdf_service.dart';

typedef YouthMemberFormScreen = MemberFormScreen;

class MemberFormScreen extends StatefulWidget {
  const MemberFormScreen({super.key});

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
    if (_formKey.currentState!.validate()) {
      final entity = MemberFormEntity(
        name: _nameController.text.trim(),
        fatherName: _fatherNameController.text.trim(),
        nidNumber: _nidController.text.trim(),
        village: _villageController.text.trim(),
        unionName: _unionController.text.trim(),
        thanaUpazila: _thanaUpazilaController.text.trim(),
        district: _districtController.text.trim(),
        presentAddress: _presentAddressController.text.trim(),
        mobile: _mobileController.text.trim(),
        email: _emailController.text.trim(),
        joinDate: _joinDate ?? DateTime.now(),
      );
      context.read<MemberFormBloc>().add(SubmitMemberForm(entity: entity));
    }
  }

  void _openPdfViewer() {
    final joinDateStr = _joinDate != null ? '${_joinDate!.day}/${_joinDate!.month}/${_joinDate!.year}' : '';
    PdfViewerScreen.open(
      context,
      title: 'ইসলামী যুব মজলিস — প্রাথমিক সদস্য ফরম',
      buildPdf: (format) => JuboMemberFormPdfService.generatePdfBytes(
        name: _nameController.text,
        fatherName: _fatherNameController.text,
        nidNo: _nidController.text,
        village: _villageController.text,
        unionName: _unionController.text,
        thana: _thanaUpazilaController.text,
        district: _districtController.text,
        presentAddress: _presentAddressController.text,
        mobile: _mobileController.text,
        email: _emailController.text,
        dateStr: joinDateStr,
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
            primaryAccent: accentPink,
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
                } else if (state is MemberFormFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ত্রুটি: ${state.errorMessage}')),
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
                                  onTap: isSubmitting ? null : _submitForm,
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
                            controller: _nidController,
                            label: 'জাতীয় পরিচয়পত্র নং',
                            hint: 'NID নম্বর লিখুন',
                            icon: Icons.badge_outlined,
                            isDark: isDark,
                            accentColor: accentPink,
                          ),
                          const SizedBox(height: 12),
                          _buildInputField(
                            controller: _villageController,
                            label: 'ঠিকানা (গ্রাম)',
                            hint: 'গ্রামের নাম...',
                            icon: Icons.home_work_rounded,
                            isDark: isDark,
                            accentColor: accentPink,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  controller: _unionController,
                                  label: 'ইউনিয়ন',
                                  hint: 'ইউনিয়নের নাম',
                                  icon: Icons.holiday_village_rounded,
                                  isDark: isDark,
                                  accentColor: accentPink,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInputField(
                                  controller: _thanaUpazilaController,
                                  label: 'থানা ও উপজেলা',
                                  hint: 'উপজেলার নাম',
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
                          const SizedBox(height: 12),
                          _buildInputField(
                            controller: _presentAddressController,
                            label: 'বর্তমান ঠিকানা',
                            hint: 'বাসা/রোড, এলাকা...',
                            icon: Icons.home_rounded,
                            isDark: isDark,
                            accentColor: accentPink,
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
                            controller: _emailController,
                            label: 'ইমেইল',
                            hint: 'example@domain.com',
                            icon: Icons.email_rounded,
                            isDark: isDark,
                            accentColor: accentPink,
                            keyboardType: TextInputType.emailAddress,
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
                              'আমি দৃঢ়ভাবে বিশ্বাস করি যে, ইসলামই আল্লাহর একমাত্র মনোনীত জীবনব্যবস্থা। ইসলামী আদর্শের আলোকে যুবসমাজের নেতৃত্বে একটি কল্যাণমুখী সমাজ গড়ার লক্ষ্যে ইসলামী যুব মজলিসের সাথে একমত হয়ে এ সংগঠনে যোগদান করছি। আমি এ লক্ষ্য অর্জনে যথাসাধ্য চেষ্টা করবো ইনশাআল্লাহ।',
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
