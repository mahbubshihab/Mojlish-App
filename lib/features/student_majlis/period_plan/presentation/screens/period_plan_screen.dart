import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/features/common/widgets/unsaved_changes_guard.dart';
import 'package:mojlish_app/features/common/services/report_storage_service.dart';
import '../../data/services/student_period_plan_pdf_service.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস — বার্ষিক/ষান্মাসিক/দ্বি-মাসিক পর্যায়ভিত্তিক পরিকল্পনা এন্ট্রি স্ক্রিন (২ পৃষ্ঠা সম্পূর্ণ)
class PeriodPlanScreen extends StatefulWidget {
  final String? initialBranch;
  final String? initialMonth;
  final String? initialSession;

  const PeriodPlanScreen({
    super.key,
    this.initialBranch,
    this.initialMonth,
    this.initialSession,
  });

  @override
  State<PeriodPlanScreen> createState() => _PeriodPlanScreenState();
}

class _PeriodPlanScreenState extends State<PeriodPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _branchController;
  late final TextEditingController _monthController;
  late final TextEditingController _sessionController;

  bool _hasChanges = false;
  bool _isLoading = true;

  // Form Controllers Map
  final Map<String, TextEditingController> _controllers = {};

  TextEditingController _c(String key) {
    return _controllers.putIfAbsent(key, () {
      final controller = TextEditingController();
      controller.addListener(_markChanged);
      return controller;
    });
  }

  void _markChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  @override
  void initState() {
    super.initState();
    _branchController = TextEditingController(text: widget.initialBranch ?? 'কেন্দ্রীয়');
    _monthController = TextEditingController(text: widget.initialMonth ?? 'মহররম-সফর');
    _sessionController = TextEditingController(text: widget.initialSession ?? '২০২৬');

    _branchController.addListener(_markChanged);
    _monthController.addListener(_markChanged);
    _sessionController.addListener(_markChanged);
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('report_storage_student_period_plan');
      if (savedData != null && savedData.isNotEmpty) {
        final Map<String, dynamic> map = jsonDecode(savedData);
        if (map.containsKey('branch') && widget.initialBranch == null) {
          _branchController.text = map['branch'] ?? '';
        }
        if (map.containsKey('month') && widget.initialMonth == null) {
          _monthController.text = map['month'] ?? '';
        }
        if (map.containsKey('session') && widget.initialSession == null) {
          _sessionController.text = map['session'] ?? '';
        }

        map.forEach((key, value) {
          if (key != 'branch' && key != 'month' && key != 'session') {
            _c(key).text = value?.toString() ?? '';
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading period plan: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasChanges = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _branchController.dispose();
    _monthController.dispose();
    _sessionController.dispose();
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<bool> _saveReport() async {
    final Map<String, String> formData = {};
    for (var entry in _controllers.entries) {
      formData[entry.key] = entry.value.text;
    }
    formData['branch'] = _branchController.text;
    formData['month'] = _monthController.text;
    formData['session'] = _sessionController.text;

    await ReportStorageService.saveReport('student_period_plan', formData);

    if (mounted) {
      setState(() => _hasChanges = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('পরিকল্পনা সফলভাবে সংরক্ষণ করা হয়েছে'),
          backgroundColor: Color(0xFF059669),
        ),
      );
    }
    return true;
  }

  void _exportPdf() {
    final Map<String, String> formData = {};
    for (var entry in _controllers.entries) {
      formData[entry.key] = entry.value.text;
    }

    StudentPeriodPlanPdfService.generateAndPrintPdf(
      branch: _branchController.text,
      month: _monthController.text,
      session: _sessionController.text,
      formData: formData,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final inputBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    const primaryAccent = Color(0xFF0077B6);

    return UnsavedChangesGuard(
      hasUnsavedChanges: _hasChanges,
      onSave: _saveReport,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'বার্ষিক/ষান্মাসিক/দ্বি-মাসিক পরিকল্পনা',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          elevation: 1,
          actions: [
            IconButton(
              icon: const Icon(Icons.save_rounded, color: Color(0xFF059669)),
              tooltip: 'সংরক্ষণ করুন',
              onPressed: _saveReport,
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf_rounded, color: primaryAccent),
              tooltip: 'PDF ডাউনলোড',
              onPressed: _exportPdf,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : AmbientBackgroundWidget(
                child: SafeArea(
                  child: Column(
                    children: [
                      // Sticky Top Bar with Actions
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: cardBg,
                          border: Border(bottom: BorderSide(color: borderColor)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF059669),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: _saveReport,
                                icon: const Icon(Icons.save_rounded, size: 18),
                                label: const Text(
                                  'সংরক্ষণ করুন',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: _exportPdf,
                                icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                                label: const Text(
                                  'PDF ডাউনলোড',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Form Content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top Header & Metadata Card
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: borderColor),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'বিসমিল্লাহির রাহমানির রাহীম',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: primaryAccent,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: primaryAccent,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: primaryAccent,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          'বার্ষিক/ষান্মাসিক/দ্বি-মাসিক পরিকল্পনা',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                        children: [
                                          Expanded(child: _buildInput('শাখা', _branchController, inputBg, textColor, borderColor)),
                                          const SizedBox(width: 8),
                                          Expanded(child: _buildInput('মাস/মেয়াদ', _monthController, inputBg, textColor, borderColor)),
                                          const SizedBox(width: 8),
                                          Expanded(child: _buildInput('সেশন', _sessionController, inputBg, textColor, borderColor)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // PAGE 1 SECTIONS
                                // 1. Dawah Section
                                _buildSectionCard(
                                  title: 'প্রথম দফা : দাওয়াত (পৃষ্ঠা ১)',
                                  color: primaryAccent,
                                  cardBg: cardBg,
                                  textColor: textColor,
                                  borderColor: borderColor,
                                  inputBg: inputBg,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('বন্ধু বৃদ্ধি (জন)', _c('dawa_bondhu'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('প্রাথমিক সদস্য বৃদ্ধি (জন)', _c('dawa_primary_member'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Text('প্রাথমিক সদস্য বৃদ্ধি উপ-খাত:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryAccent)),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('ক. স্কুল : সরকারি (জন)', _c('dawa_school_govt'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('বেসরকারি (জন)', _c('dawa_school_non_govt'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('খ. কলেজ (জন)', _c('dawa_college'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('গ. মাদ্রাসা : আলিয়া (জন)', _c('dawa_madrasa_alia'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('কওমী (জন)', _c('dawa_madrasa_qawmi'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('ঘ. বিশ্ববিদ্যালয় (জন)', _c('dawa_university'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInput('শুভানুধ্যায়ী বৃদ্ধি / যোগাযোগ (জন)', _c('dawa_shuvakangkhi'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('♦ পরিচিতি বিতরণ (টি)', _c('dawa_sahitya_1'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('ইসলামী সাহিত্য বিতরণ (টি)', _c('dawa_sahitya_2'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('♦ ছাত্র পরিক্রমা (টি)', _c('dawa_patrika_1'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('কিশোর পত্রিকা (টি)', _c('dawa_patrika_2'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('♦ লিফলেট (টি)', _c('dawa_leaflet_1'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('স্টিকার (টি)', _c('dawa_leaflet_2'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('পোস্টার (টি)', _c('dawa_leaflet_3'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('♦ দেয়াল লিখন (টি)', _c('dawa_deyal_1'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('দেয়ালিকা প্রকাশ (টি)', _c('dawa_deyal_2'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('নবীন বরণ (টি)', _c('dawa_deyal_3'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('♦ গ্রুপ দাওয়াত (টি)', _c('dawa_group_1'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('চা চক্র (টি)', _c('dawa_group_2'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('উন্মুক্ত আসর (টি)', _c('dawa_group_3'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('♦ বক্তৃতা (টি)', _c('dawa_boktita_1'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('বিতর্ক (টি)', _c('dawa_boktita_2'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('সাধারণ জ্ঞান (টি)', _c('dawa_boktita_3'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInput('♦ অন্যান্য দাওয়াতি কার্যক্রম', _c('dawa_other'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('কাজ বৃদ্ধি : প্রাতিষ্ঠানিক (টি)', _c('dawa_work_inst'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('আবাসিক (টি)', _c('dawa_work_res'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInput('কাজ বৃদ্ধি : নাম', _c('dawa_work_names'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('প্রাথমিক শাখা বৃদ্ধি : প্রাতিষ্ঠানিক (টি)', _c('dawa_branch_inst'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('আবাসিক (টি)', _c('dawa_branch_res'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInput('প্রাথমিক শাখা বৃদ্ধি : নাম', _c('dawa_branch_names'), inputBg, textColor, borderColor),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // 2. Organization Section
                                _buildSectionCard(
                                  title: 'দ্বিতীয় দফা : সংগঠন',
                                  color: primaryAccent,
                                  cardBg: cardBg,
                                  textColor: textColor,
                                  borderColor: borderColor,
                                  inputBg: inputBg,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('সহযোগী সদস্য প্রার্থী টার্গেট (জন)', _c('org_assoc_candidate_target'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('নাম :', _c('org_assoc_candidate_names'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInput('কর্মী বৃদ্ধি (জন)', _c('org_worker_growth'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    const Text('কর্মী বৃদ্ধি উপ-খাত:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryAccent)),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('ক. স্কুল : সরকারি (জন)', _c('org_school_govt'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('বেসরকারি (জন)', _c('org_school_non_govt'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('খ. কলেজ (জন)', _c('org_college'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('গ. মাদ্রাসা : আলিয়া (জন)', _c('org_madrasa_alia'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('কওমী (জন)', _c('org_madrasa_qawmi'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('ঘ. বিশ্ববিদ্যালয় (জন)', _c('org_university'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('সহযোগী সদস্য শাখা বৃদ্ধি (টি)', _c('org_assoc_branch_growth'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('নাম :', _c('org_assoc_branch_names'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('থানা / জোন শাখা বৃদ্ধি (টি)', _c('org_thana_zone_branch_growth'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('নাম :', _c('org_thana_zone_branch_names'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('কর্মী শাখা বৃদ্ধি (টি)', _c('org_worker_branch_growth'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('প্রাতিষ্ঠানিক (টি)', _c('org_worker_branch_inst'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('আবাসিক (টি)', _c('org_worker_branch_res'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInput('কর্মী শাখা : নাম', _c('org_worker_branch_names'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('ঊর্ধ্বতন সফর আনা হবে (টি)', _c('org_senior_visit_count'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('তারিখ :', _c('org_senior_visit_date'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // 3. Meetings Section
                                _buildSectionCard(
                                  title: 'সভাসমূহ',
                                  color: primaryAccent,
                                  cardBg: cardBg,
                                  textColor: textColor,
                                  borderColor: borderColor,
                                  inputBg: inputBg,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('দায়িত্বশীল সভা (টি)', _c('meet_daitoshil_count'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('তারিখ ও সময় :', _c('meet_daitoshil_date_time'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('জোনাল দায়িত্বশীল সভা (টি)', _c('meet_zonal_daitoshil_count'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('তারিখ ও সময় :', _c('meet_zonal_daitoshil_date_time'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('সদস্য সভা (টি)', _c('meet_member_count'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('তারিখ ও সময় :', _c('meet_member_date_time'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('সহযোগী সদস্য সভা (টি)', _c('meet_assoc_member_count'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('তারিখ ও সময় :', _c('meet_assoc_member_date_time'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('কর্মী সভা (টি)', _c('meet_worker_count'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('তারিখ ও সময় :', _c('meet_worker_date_time'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('সাধারণ সভা (টি)', _c('meet_general_count'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('তারিখ ও সময় :', _c('meet_general_date_time'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('আলোচনা সভা (টি)', _c('meet_discussion_count'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('তারিখ ও সময় :', _c('meet_discussion_date_time'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInput('অন্যান্য সভাসমূহ', _c('meet_other'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    _buildInput('বায়তুলমাল সংগ্রহ করা হবে (টাকা)', _c('meet_baytulmal_target'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 6),
                                    Text(
                                      '(প্রতি মাসের আয়-ব্যয়ের বিস্তারিত বাজেট আলাদা কাগজে থাকবে।)',
                                      style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: textColor.withValues(alpha: 0.7)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // PAGE 2 SECTIONS
                                const Divider(thickness: 2, color: primaryAccent),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: primaryAccent.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'পৃষ্ঠা ২ এর পরিকল্পনাসমূহ',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryAccent),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // 4. Training Section (তৃতীয় দফা : প্রশিক্ষণ)
                                _buildSectionCard(
                                  title: 'তৃতীয় দফা : প্রশিক্ষণ (পৃষ্ঠা ২)',
                                  color: primaryAccent,
                                  cardBg: cardBg,
                                  textColor: textColor,
                                  borderColor: borderColor,
                                  inputBg: inputBg,
                                  children: [
                                    _buildTrainingBlock('কর্মশালা', 'train_kormoshala', inputBg, textColor, borderColor),
                                    const SizedBox(height: 10),
                                    _buildTrainingBlock('শিক্ষা সভা', 'train_shikkha_soba', inputBg, textColor, borderColor),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('সামষ্টিক অধ্যয়ন : সংখ্যা (টি)', _c('train_shamoshtik_count'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('অধিবেশন (টি)', _c('train_shamoshtik_session'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    _buildTrainingBlock('শবগুজারি', 'train_shobgujari', inputBg, textColor, borderColor),
                                    const SizedBox(height: 10),
                                    _buildTrainingBlock('জিকির মাহফিল', 'train_jikir', inputBg, textColor, borderColor),
                                    const SizedBox(height: 10),
                                    _buildCourseBlock('প্রশিক্ষণ চক্র', 'train_chokro', inputBg, textColor, borderColor),
                                    const SizedBox(height: 10),
                                    _buildCourseBlock('স্কিলস ডেভেলপমেন্ট কোর্স', 'train_skills', inputBg, textColor, borderColor),
                                    const SizedBox(height: 10),
                                    _buildTrainingBlock('তরবিয়তী সফর', 'train_torbiyoti', inputBg, textColor, borderColor),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('কুরআন ও হাদিস শিক্ষা ক্লাস (টি)', _c('train_quran_hadis_count'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('অধিবেশন (টি)', _c('train_quran_hadis_session'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('মাসআলা-মাসায়েল শিক্ষা ক্লাস (টি)', _c('train_masala_count'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('অধিবেশন (টি)', _c('train_masala_session'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('উন্মুক্ত ক্লাস (টি)', _c('train_unmukto_count'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('অধিবেশন (টি)', _c('train_unmukto_session'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('স্পীকার্স / সাংস্কৃতিক ফোরাম (টি)', _c('train_speakers_cultural_count'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('অধিবেশন (টি)', _c('train_speakers_cultural_session'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('পাঠাগার বৃদ্ধি (টি)', _c('train_pathagar_growth'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('বই বৃদ্ধি (টি)', _c('train_pathagar_book_growth'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // 5. Movement Section (চতুর্থ দফা : আন্দোলন - ছাত্রকল্যাণ)
                                _buildSectionCard(
                                  title: 'চতুর্থ দফা : আন্দোলন (ছাত্রকল্যাণ)',
                                  color: primaryAccent,
                                  cardBg: cardBg,
                                  textColor: textColor,
                                  borderColor: borderColor,
                                  inputBg: inputBg,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('যাকাত সংগ্রহ করা হবে (টাকা)', _c('mov_zakat_target'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('টেবিল ব্যাংক / কলসি বৃদ্ধি (টি)', _c('mov_table_bank_growth'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('লজিং সংগ্রহ (টি)', _c('mov_lodging'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('টিউশনি সংগ্রহ (টি)', _c('mov_tuition'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('স্টাইপেন্ড বা বৃত্তি চালু (টি)', _c('mov_stipend'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('আবাসনের ব্যবস্থা (জন ছাত্রের)', _c('mov_housing'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('ফ্রি কোচিং (টি)', _c('mov_free_coaching'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInput('একাডেমিক / ভর্তি কোচিং (টি)', _c('mov_academic_coaching'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('প্রশ্নপত্র বিলি (টি)', _c('mov_question'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('সাজেশন বিলি (টি)', _c('mov_suggesion'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('নোট বিলি (টি)', _c('mov_note'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('ল্যাঙ্গুয়েজ লাইব্রেরি প্রতিষ্ঠা (টি)', _c('mov_lang_lib'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('বই বৃদ্ধি (টি)', _c('mov_lang_lib_books'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('ভর্তি গাইড প্রকাশ (টি)', _c('mov_guide_pub'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('সহযোগিতা (টি)', _c('mov_guide_help'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('ভর্তিকালীন সহযোগিতা (জন)', _c('mov_admission_help_students'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '(ছাত্রকল্যাণের আয়-ব্যয়ের বাজেট আলাদা কাগজে সংরক্ষণ করতে হবে)',
                                      style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: textColor.withValues(alpha: 0.7)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // 6. Social Welfare Section (সামাজিক খেদমত)
                                _buildSectionCard(
                                  title: 'সামাজিক খেদমত (১২ টি খাত)',
                                  color: primaryAccent,
                                  cardBg: cardBg,
                                  textColor: textColor,
                                  borderColor: borderColor,
                                  inputBg: inputBg,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('গাছ লাগানো হবে (টি)', _c('social_tree_count'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('রক্তদান করা হবে (ব্যাগ)', _c('social_blood_count'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInput('কুরআন শিক্ষা ব্যবস্থা (লক্ষ্যমাত্রা/বিবরণ)', _c('social_quran_edu'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    _buildInput('মাদক-অশ্লীলতা বিরোধী জনসচেতনতা (বিবরণ)', _c('social_anti_drug'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    _buildInput('খেদমতে খালক উদ্বুদ্ধকরণ (বিবরণ)', _c('social_khedmat_khalk'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    _buildInput('অন্যায়-জুলুমের বিরুদ্ধে জনমত (বিবরণ)', _c('social_against_oppression'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    _buildInput('অন্নবস্ত্রদান কর্মসূচি (বিবরণ)', _c('social_food_cloth'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    _buildInput('খেলাফত মজলিসের কাজে সহযোগিতা (বিবরণ)', _c('social_khelafot_help'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    _buildInput('পরিষ্কার-পরিচ্ছন্নতা কার্যক্রম (বিবরণ)', _c('social_cleanliness'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    _buildInput('মোহররমা আত্মীয়দের মাঝে দাওয়াত (বিবরণ)', _c('social_relative_dawah'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    _buildInput('দুর্যোগে পাশে দাঁড়ানো (বিবরণ)', _c('social_disaster_help'), inputBg, textColor, borderColor),
                                    const SizedBox(height: 8),
                                    _buildInput('ফ্রি চিকিৎসা সেবা কর্মসূচি (বিবরণ)', _c('social_free_medical'), inputBg, textColor, borderColor),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // 7. Baytulmal Budget Table Section (বায়তুলমাল বাজেট)
                                _buildSectionCard(
                                  title: 'বায়তুলমাল বাজেট (আয় ও ব্যয় টেবিল)',
                                  color: primaryAccent,
                                  cardBg: cardBg,
                                  textColor: textColor,
                                  borderColor: borderColor,
                                  inputBg: inputBg,
                                  children: [
                                    Text('আয়ের উৎস (টাকা):', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryAccent)),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('০১. জনশক্তি ইয়ানত', _c('budget_inc_1'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('০২. শাখা ইয়ানত', _c('budget_inc_2'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('০৩. শুভাকাঙ্ক্ষী ইয়ানত', _c('budget_inc_3'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('০৪. এককালীন আয়', _c('budget_inc_4'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('০৫. খাতের নাম', _c('budget_inc_src_5'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('টাকা', _c('budget_inc_5'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('০৬. খাতের নাম', _c('budget_inc_src_6'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('টাকা', _c('budget_inc_6'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('০৭. খাতের নাম', _c('budget_inc_src_7'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('টাকা', _c('budget_inc_7'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInput('মোট আয় (টাকা)', _c('budget_inc_total'), inputBg, textColor, borderColor),

                                    const SizedBox(height: 16),
                                    const Divider(),
                                    const SizedBox(height: 8),

                                    Text('ব্যয়ের খাত (টাকা):', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryAccent)),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('০১. ঊর্ধ্বতন ইয়ানত পরিশোধ', _c('budget_exp_1'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('০২. ঊর্ধ্বতন সফর', _c('budget_exp_2'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('০৩. অফিস', _c('budget_exp_3'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('০৪. যাতায়াত', _c('budget_exp_4'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('০৫. যোগাযোগ', _c('budget_exp_5'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('০৬. প্রচার', _c('budget_exp_6'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildInput('০৭. খাতের নাম', _c('budget_exp_head_7'), inputBg, textColor, borderColor)),
                                        const SizedBox(width: 8),
                                        Expanded(child: _buildInput('টাকা', _c('budget_exp_7'), inputBg, textColor, borderColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInput('মোট ব্যয় (টাকা)', _c('budget_exp_total'), inputBg, textColor, borderColor),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // Footer Link Display
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: primaryAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'www.chhatra-majlis.org.bd',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTrainingBlock(
    String title,
    String prefix,
    Color inputBg,
    Color textColor,
    Color borderColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0077B6))),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(child: _buildInput('সংখ্যা (টি)', _c('${prefix}_count'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('তারিখ', _c('${prefix}_date'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('সময়', _c('${prefix}_time'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('স্থান', _c('${prefix}_place'), inputBg, textColor, borderColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildCourseBlock(
    String title,
    String prefix,
    Color inputBg,
    Color textColor,
    Color borderColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0077B6))),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(child: _buildInput('সংখ্যা (টি)', _c('${prefix}_count'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('অধিবেশন (টি)', _c('${prefix}_session'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('তারিখ', _c('${prefix}_date'), inputBg, textColor, borderColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Color color,
    required Color cardBg,
    required Color textColor,
    required Color borderColor,
    required Color inputBg,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: themeManager.isDarkMode ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller,
    Color inputBg,
    Color textColor,
    Color borderColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 5),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor.withValues(alpha: 0.85),
            ),
          ),
        ),
        TextField(
          controller: controller,
          style: TextStyle(fontSize: 13, color: textColor),
          decoration: InputDecoration(
            hintText: 'এখানে লিখুন...',
            hintStyle: TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.4)),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: inputBg,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF0077B6), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
