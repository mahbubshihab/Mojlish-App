import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/widgets/pdf_viewer_screen.dart';
import 'package:mojlish_app/core/widgets/unsaved_changes_dialog.dart';
import '../../data/services/women_member_form_pdf_service.dart';

/// বাংলাদেশ ইসলামী মহিলা মজলিস — প্রাথমিক সদস্যা ফরম (প্রিমিয়াম UI ইনপুট ও PDF প্রভিউ স্ক্রিন)
class WomenMemberFormScreen extends StatefulWidget {
  const WomenMemberFormScreen({super.key});

  @override
  State<WomenMemberFormScreen> createState() => _WomenMemberFormScreenState();
}

class _WomenMemberFormScreenState extends State<WomenMemberFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _fatherOrHusbandNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _eduController = TextEditingController();
  final _ageController = TextEditingController();
  final _professionController = TextEditingController();
  final _presentAddressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _permanentAddressController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _fatherOrHusbandNameController.dispose();
    _motherNameController.dispose();
    _eduController.dispose();
    _ageController.dispose();
    _professionController.dispose();
    _presentAddressController.dispose();
    _mobileController.dispose();
    _permanentAddressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('সদস্যা ফরম সফলভাবে তথ্য সংরক্ষিত হয়েছে!'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        }
      });
    }
  }

  void _openPdfViewer() {
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';

    PdfViewerScreen.open(
      context,
      title: 'মহিলা মজলিস — প্রাথমিক সদস্যা ফরম',
      buildPdf: (format) => WomenMemberFormPdfService.generatePdfBytes(
        name: _nameController.text.trim(),
        fatherOrHusbandName: _fatherOrHusbandNameController.text.trim(),
        motherName: _motherNameController.text.trim(),
        educationalQualification: _eduController.text.trim(),
        age: _ageController.text.trim(),
        profession: _professionController.text.trim(),
        presentAddress: _presentAddressController.text.trim(),
        mobile: _mobileController.text.trim(),
        permanentAddress: _permanentAddressController.text.trim(),
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
    const accentMagenta = Color(0xFFEC4899);
    const accentBlue = Color(0xFF0284C7);
    const accentEmerald = Color(0xFF10B981);

    return UnsavedChangesGuard(
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
            'প্রাথমিক সদস্যা ফরম',
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
          primaryAccent: accentMagenta,
          child: Form(
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
                              color: accentMagenta.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: _isSubmitting ? null : _submitForm,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _isSubmitting
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
                    color: accentMagenta.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: accentMagenta.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.badge_rounded, color: accentMagenta, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'প্রাথমিক সদস্যা ফরম',
                        style: TextStyle(color: textLight, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const Spacer(),
                      const Icon(Icons.auto_awesome, color: accentMagenta, size: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Personal Information Section Card
                _buildSectionCard(
                  title: 'ব্যক্তিগত তথ্যাবলী',
                  icon: Icons.person_rounded,
                  color: accentMagenta,
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
                      accentColor: accentMagenta,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'নাম প্রদান করুন' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      controller: _fatherOrHusbandNameController,
                      label: 'পিতা/স্বামীর নাম',
                      hint: 'পিতা বা স্বামীর নাম লিখুন',
                      icon: Icons.people_outline_rounded,
                      isDark: isDark,
                      accentColor: accentMagenta,
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      controller: _motherNameController,
                      label: 'মাতার নাম',
                      hint: 'মাতার নাম লিখুন',
                      icon: Icons.face_rounded,
                      isDark: isDark,
                      accentColor: accentMagenta,
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      controller: _eduController,
                      label: 'শিক্ষাগত যোগ্যতা',
                      hint: 'যেমন: কামিল / বিএ / মাস্টার্স...',
                      icon: Icons.school_rounded,
                      isDark: isDark,
                      accentColor: accentMagenta,
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
                            accentColor: accentMagenta,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInputField(
                            controller: _professionController,
                            label: 'পেশা',
                            hint: 'যেমন: গৃহিনী / শিক্ষকতা',
                            icon: Icons.work_rounded,
                            isDark: isDark,
                            accentColor: accentMagenta,
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
                      accentColor: accentMagenta,
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
                      accentColor: accentMagenta,
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      controller: _permanentAddressController,
                      label: 'স্থায়ী ঠিকানা',
                      hint: 'গ্রাম, ডাকঘর, থানা, জেলা...',
                      icon: Icons.place_rounded,
                      isDark: isDark,
                      accentColor: accentMagenta,
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
                        'আমি বিশ্বাস করি যে কুরআন, সুন্নাহ ও খেলাফতে রাশেদার অনুসরণের মধ্যেই ইহকালীন কল্যাণ ও পরকালীন মুক্তি নিহিত। এ দেশে খেলাফত রাষ্ট্রব্যবস্থা প্রতিষ্ঠার লক্ষ্যে বাংলাদেশ ইসলামী মহিলা মজলিস গৃহীত কর্মসূচীর সাথে একমত হয়ে একমাত্র আল্লাহর সন্তুষ্টির জন্যই এ সংগঠনে যোগদান করছি। আমি এর যাবতীয় কর্মতৎপরতায় সম্ভাব্য সহযোগিতা করতে সচেষ্ট থাকবো, ইনশাআল্লাহ।',
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
