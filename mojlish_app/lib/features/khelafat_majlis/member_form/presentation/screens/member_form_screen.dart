import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/widgets/pdf_viewer_screen.dart';
import '../bloc/member_form_bloc.dart';
import '../bloc/member_form_event.dart';
import '../bloc/member_form_state.dart';
import '../../domain/entities/member.dart';
import '../../data/datasources/member_remote_datasource.dart';
import '../../data/repositories/member_repository_impl.dart';
import '../../data/services/khelafat_member_form_pdf_service.dart';

/// খেলাফত মজলিস — প্রাথমিক সদস্য ফরম (আধুনিক ডিজাইন ও মডুলার সার্ভিস)
class MemberFormScreen extends StatelessWidget {
  const MemberFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MemberFormBloc>(
      create: (_) => MemberFormBloc(
        repository: KhelafatMajlisMemberRepositoryImpl(
          MemberRemoteDataSourceImpl(),
        ),
      ),
      child: const _MemberFormScreenContent(),
    );
  }
}

class _MemberFormScreenContent extends StatefulWidget {
  const _MemberFormScreenContent();

  @override
  State<_MemberFormScreenContent> createState() => _MemberFormScreenContentState();
}

class _MemberFormScreenContentState extends State<_MemberFormScreenContent> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _educationalQualificationController = TextEditingController();
  final _ageController = TextEditingController();
  final _professionController = TextEditingController();
  final _presentAddressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _permanentAddressController = TextEditingController();

  String _serialNumber = '০৩৮';

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
      final member = KhelafatMajlisMember(
        name: _nameController.text.trim(),
        fatherName: _fatherNameController.text.trim(),
        educationalQualification: _educationalQualificationController.text.trim(),
        age: _ageController.text.trim(),
        profession: _professionController.text.trim(),
        presentAddress: _presentAddressController.text.trim(),
        mobile: _mobileController.text.trim(),
        permanentAddress: _permanentAddressController.text.trim(),
        date: DateTime.now(),
      );
      context.read<MemberFormBloc>().add(SubmitMemberForm(member));
    }
  }

  void _openPdfViewer() {
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';

    PdfViewerScreen.open(
      context,
      title: 'খেলাফত মজলিস — প্রাথমিক সদস্য ফরম',
      buildPdf: (format) => KhelafatMemberFormPdfService.generatePdfBytes(
        regNo: _serialNumber,
        name: _nameController.text,
        fatherName: _fatherNameController.text,
        educationalQualification: _educationalQualificationController.text,
        age: _ageController.text,
        profession: _professionController.text,
        presentAddress: _presentAddressController.text,
        mobile: _mobileController.text,
        permanentAddress: _permanentAddressController.text,
        dateStr: dateStr,
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
    const accentEmerald = Color(0xFF10B981);
    const accentBlue = Color(0xFF0284C7);

    return Scaffold(
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
                  // Top Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF059669), Color(0xFF10B981)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: accentEmerald.withValues(alpha: 0.25),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.badge_rounded, color: accentPink, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'প্রাথমিক সদস্য ফরম',
                              style: TextStyle(color: textLight, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: accentPink,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'নিবন্ধন নং: $_serialNumber',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
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
                        controller: _educationalQualificationController,
                        label: 'শিক্ষাগত যোগ্যতা',
                        hint: 'যেমন: কামিল / বিএ / মাস্টার্স...',
                        icon: Icons.school_rounded,
                        isDark: isDark,
                        accentColor: accentPink,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              controller: _ageController,
                              label: 'বয়স',
                              hint: '২৫',
                              icon: Icons.cake_rounded,
                              suffix: 'বছর',
                              isDark: isDark,
                              accentColor: accentPink,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInputField(
                              controller: _professionController,
                              label: 'পেশা',
                              hint: 'যেমন: ব্যবসা / শিক্ষকতা',
                              icon: Icons.work_rounded,
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
                        controller: _permanentAddressController,
                        label: 'স্থায়ী ঠিকানা',
                        hint: 'গ্রাম, ডাকঘর, থানা, জেলা...',
                        icon: Icons.location_on_rounded,
                        isDark: isDark,
                        accentColor: accentPink,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Pledge & Declaration Card
                  _buildSectionCard(
                    title: 'শপথ ও অঙ্গীকারনামা',
                    icon: Icons.verified_user_rounded,
                    color: accentEmerald,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Text(
                          'বিশ্বাস করি যে কুরআন, সুন্নাহ ও খেলাফতে রাশেদার অনুসরণের মধ্যেই ইহকালীন কল্যাণ ও পরকালীন মুক্তি নিহিত। এ দেশে খেলাফত প্রতিষ্ঠার লক্ষ্যে খেলাফত মজলিসের গৃহীত কর্মসূচীর সাথে একমত হয়ে একমাত্র আল্লাহর সন্তুষ্টির জন্যই এ সংগঠনে যোগদান করছি। আমি এর যাবতীয় কর্মকাণ্ডে সম্ভাব্য সহযোগিতা করতে সচেষ্ট থাকবো, ইনশাআল্লাহ।',
                          style: TextStyle(
                            color: textLight,
                            fontSize: 13,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(9)),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(color: textLight, fontWeight: FontWeight.bold, fontSize: 14.5)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? suffix,
    required bool isDark,
    required Color accentColor,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final fieldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final fieldBorder = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    final textColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: TextStyle(color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155), fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 5),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: (_) => setState(() {}),
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 13.5),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 12.5),
            prefixIcon: Icon(icon, color: accentColor, size: 17),
            suffixIcon: suffix != null
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(suffix, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 12.5)),
                  )
                : null,
            filled: true,
            fillColor: fieldBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: fieldBorder)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: accentColor, width: 1.8)),
          ),
        ),
      ],
    );
  }
}
