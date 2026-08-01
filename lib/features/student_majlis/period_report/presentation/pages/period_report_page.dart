import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import '../../../../common/widgets/unsaved_changes_guard.dart';
import '../../../../common/services/report_storage_service.dart';
import '../../data/services/student_period_pdf_service.dart';
import '../../domain/entities/period_report.dart';
import '../bloc/period_report_bloc.dart';
import '../bloc/period_report_event.dart';
import '../bloc/period_report_state.dart';

class PeriodReportPage extends StatefulWidget {
  final String? initialMonth;
  final String? initialSession;

  const PeriodReportPage({
    super.key,
    this.initialMonth,
    this.initialSession,
  });

  @override
  State<PeriodReportPage> createState() => _PeriodReportPageState();
}

class _PeriodReportPageState extends State<PeriodReportPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _branchController;
  late final TextEditingController _monthController;
  late final TextEditingController _sessionController;

  final Map<String, TextEditingController> _controllers = {};

  bool _isSubmitting = false;
  bool _isLocked = false;
  bool _hasChanges = false;

  TextEditingController _c(String key, [String defaultText = '']) {
    return _controllers.putIfAbsent(key, () => TextEditingController(text: defaultText));
  }

  @override
  void initState() {
    super.initState();
    _branchController = TextEditingController(text: 'কেন্দ্রীয়');
    _monthController = TextEditingController(text: widget.initialMonth ?? 'মহররম-সফর');
    _sessionController = TextEditingController(text: widget.initialSession ?? '২০২৬');
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

  void _markChanged() {
    if (!_isLocked && !_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  Map<String, String> _collectFormData() {
    final Map<String, String> data = {
      'branch': _branchController.text,
      'month': _monthController.text,
      'session': _sessionController.text,
    };
    for (var entry in _controllers.entries) {
      data[entry.key] = entry.value.text;
    }
    return data;
  }

  void _exportPdf() {
    final formData = _collectFormData();
    StudentPeriodPdfService.generateAndPrintPdf(
      branch: _branchController.text,
      month: _monthController.text,
      session: _sessionController.text,
      formData: formData,
      context: context,
    );
  }

  Future<bool> _saveReport() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() => _isSubmitting = true);

      final formData = _collectFormData();
      await ReportStorageService.savePeriodReport(formData);

      final report = PeriodReport(
        id: DateTime.now().toString(),
        branch: _branchController.text,
        month: _monthController.text,
        session: _sessionController.text,
        manpower: const Manpower(),
        dawah: const Dawah(),
        organization: const Organization(),
        meetings: const Meetings(),
        training: const Training(),
        library: const Library(),
        baytulmal: const Baytulmal(),
      );

      if (mounted) {
        try {
          context.read<PeriodReportBloc>().add(SubmitPeriodReportEvent(report: report));
        } catch (_) {}

        setState(() {
          _isSubmitting = false;
          _hasChanges = false;
          _isLocked = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('পর্যায়ভিত্তিক রিপোর্ট সফলভাবে সংরক্ষণ করা হয়েছে!'),
            backgroundColor: Color(0xFF059669),
          ),
        );
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || themeManager.isDarkMode;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final inputBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    const oceanCyan = Color(0xFF0077B6);

    return UnsavedChangesGuard(
      hasUnsavedChanges: !_isLocked && _hasChanges,
      onSave: () async {
        return await _saveReport();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf_rounded, color: oceanCyan),
              tooltip: 'PDF এক্সপোর্ট',
              onPressed: _exportPdf,
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: AmbientBackgroundWidget(
          child: SafeArea(
            child: Column(
              children: [
                // 📌 Sticky Top Action Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF10B981)]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: _isSubmitting
                                  ? null
                                  : () {
                                      if (_isLocked) {
                                        setState(() => _isLocked = false);
                                      } else {
                                        _saveReport();
                                      }
                                    },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _isSubmitting
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                        )
                                      : Icon(_isLocked ? Icons.edit_note_rounded : Icons.save_rounded, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isLocked ? 'এডিট করুন' : 'সংরক্ষণ করুন',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
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
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF0077B6), Color(0xFF0284C7)]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: _exportPdf,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.file_download_outlined, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'PDF ডাউনলোড',
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
                ),

                // 📜 Form Content
                Expanded(
                  child: BlocListener<PeriodReportBloc, PeriodReportState>(
                    listener: (context, state) {
                      if (state is PeriodReportSuccess) {
                        setState(() {
                          _isSubmitting = false;
                          _hasChanges = false;
                          _isLocked = true;
                        });
                      } else if (state is PeriodReportFailure) {
                        setState(() => _isSubmitting = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('ব্যর্থ হয়েছে: ${state.message}')),
                        );
                      }
                    },
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Banner Card
                            _buildHeaderCard(cardBg, textColor, inputBg, borderColor, oceanCyan),
                            const SizedBox(height: 16),

                            // ১. জনশক্তি
                            _buildManpowerSection(cardBg, textColor, inputBg, borderColor, oceanCyan),
                            const SizedBox(height: 16),

                            // ২. দাওয়াত ও বিতরণ
                            _buildDawahSection(cardBg, textColor, inputBg, borderColor, oceanCyan),
                            const SizedBox(height: 16),

                            // ৩. সংগঠন ও জনশক্তির শ্রেণিবিন্যাস
                            _buildOrgSection(cardBg, textColor, inputBg, borderColor, oceanCyan),
                            const SizedBox(height: 16),

                            // ৪. সভাসমূহ
                            _buildMeetingsSection(cardBg, textColor, inputBg, borderColor, oceanCyan),
                            const SizedBox(height: 16),

                            // ৫. প্রশিক্ষণ
                            _buildTrainingSection(cardBg, textColor, inputBg, borderColor, oceanCyan),
                            const SizedBox(height: 16),

                            // ৬. পাঠাগার
                            _buildLibrarySection(cardBg, textColor, inputBg, borderColor, oceanCyan),
                            const SizedBox(height: 16),

                            // ৭. বায়তুলমাল ও প্রকাশনা
                            _buildBaytulmalSection(cardBg, textColor, inputBg, borderColor, oceanCyan),
                            const SizedBox(height: 16),

                            // ৮. ছাত্রকল্যাণ
                            _buildWelfareSection(cardBg, textColor, inputBg, borderColor, oceanCyan),
                            const SizedBox(height: 16),

                            // ৯. মন্তব্য
                            _buildRemarksSection(cardBg, textColor, inputBg, borderColor, oceanCyan),
                            const SizedBox(height: 32),
                          ],
                        ),
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

  Widget _buildHeaderCard(Color cardBg, Color textColor, Color inputBg, Color borderColor, Color oceanCyan) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            'বাংলাদেশ ইসলামী ছাত্র মজলিস',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: oceanCyan,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট ফরম',
            style: TextStyle(
              fontSize: 13,
              color: textColor.withValues(alpha: 0.7),
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
    );
  }

  Widget _buildManpowerSection(Color cardBg, Color textColor, Color inputBg, Color borderColor, Color oceanCyan) {
    return _buildSectionCard(
      title: '১. জনশক্তি (Manpower)',
      color: oceanCyan,
      cardBg: cardBg,
      textColor: textColor,
      borderColor: borderColor,
      children: [
        _buildManpowerRow('সদস্য', 'mp_member', inputBg, textColor, borderColor),
        const SizedBox(height: 10),
        _buildManpowerRow('সদস্য প্রার্থী', 'mp_cand_member', inputBg, textColor, borderColor),
        const SizedBox(height: 10),
        _buildManpowerRow('সহযোগী সদস্য', 'mp_assoc_member', inputBg, textColor, borderColor),
        const SizedBox(height: 10),
        _buildManpowerRow('সহযোগী সদস্য প্রার্থী', 'mp_cand_assoc_member', inputBg, textColor, borderColor),
        const SizedBox(height: 10),
        _buildManpowerRow('কর্মী', 'mp_worker', inputBg, textColor, borderColor),
        const SizedBox(height: 10),
        _buildManpowerRow('মোট', 'mp_total', inputBg, textColor, borderColor),
      ],
    );
  }

  Widget _buildManpowerRow(String label, String prefix, Color inputBg, Color textColor, Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(child: _buildInput('সংখ্যা', _c('${prefix}_count'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('বৃদ্ধি', _c('${prefix}_growth'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('কীভাবে', _c('${prefix}_how'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(child: _buildInput('টার্গেট', _c('${prefix}_target'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('ঘাটতি', _c('${prefix}_shortage'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('কারণ', _c('${prefix}_reason'), inputBg, textColor, borderColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildDawahSection(Color cardBg, Color textColor, Color inputBg, Color borderColor, Color oceanCyan) {
    return _buildSectionCard(
      title: '২. দাওয়াত ও বিতরণ (Dawah & Literature)',
      color: oceanCyan,
      cardBg: cardBg,
      textColor: textColor,
      borderColor: borderColor,
      children: [
        Text('দাওয়াত বৃদ্ধি:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('প্রাথমিক সদস্য (সংখ্যা)', _c('dw_primary_count'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('বৃদ্ধি', _c('dw_primary_growth'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('বন্ধু (সংখ্যা)', _c('dw_friend_count'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('বৃদ্ধি', _c('dw_friend_growth'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('শুভাকাঙ্ক্ষী (সংখ্যা)', _c('dw_wellwisher_count'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('বৃদ্ধি', _c('dw_wellwisher_growth'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 12),
        Text('বিতরণ (পরিমাণ):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('ইসলামী সাহিত্য', _c('dist_sahitya'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('স্টিকার/ভিউকার্ড/ডায়েরি', _c('dist_sticker'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('পরিচিতি', _c('dist_porichiti'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('রুটিন/সূত্রাবলী', _c('dist_routine'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('ছাত্র পরিক্রমা', _c('dist_porikroma'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('লিফলেট/পোস্টার', _c('dist_leaflet'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('কিশোর পত্রিকা', _c('dist_kishore'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('দাওয়াত/ঈদ কার্ড', _c('dist_card'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 12),
        Text('অতিরিক্ত দাওয়াতি তথ্য:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('গ্রুপ দাওয়াত', _c('dw_group_dawa'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('চা-চক্র', _c('dw_cha_chokro'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('প্রাথমিক শাখা প্রাতিষ্ঠানিক', _c('dw_pri_shakha_inst'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('বৃদ্ধি', _c('dw_pri_shakha_inst_growth'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('ঘাটতি', _c('dw_pri_shakha_inst_shortage'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('প্রাথমিক শাখা আবাসিক', _c('dw_pri_shakha_res'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('বৃদ্ধি', _c('dw_pri_shakha_res_growth'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('ঘাটতি', _c('dw_pri_shakha_res_shortage'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('সংবাদ মিডিয়া (বার)', _c('dw_news_media'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('দেয়ালিকা প্রকাশ (টি)', _c('dw_deyalika'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('প্রতিযোগিতা', _c('dw_competition'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('নবীন বরণ', _c('dw_nobin_boron'), inputBg, textColor, borderColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildOrgSection(Color cardBg, Color textColor, Color inputBg, Color borderColor, Color oceanCyan) {
    return _buildSectionCard(
      title: '৩. সংগঠন ও জনশক্তির শ্রেণিবিন্যাস',
      color: oceanCyan,
      cardBg: cardBg,
      textColor: textColor,
      borderColor: borderColor,
      children: [
        Row(
          children: [
            Expanded(child: _buildInput('পাবলিক বিশ্ববিদ্যালয়', _c('org_public_uni'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('প্রাইভেট বিশ্ববিদ্যালয়', _c('org_private_uni'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('মেডিকেল কলেজ', _c('org_med_college'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('বিশ্ববিদ্যালয় কলেজ', _c('org_uni_college'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('হোমিও কলেজ', _c('org_homoeo_college'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('আইন কলেজ', _c('org_law_college'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('টেকনিক্যাল প্রতিষ্ঠান', _c('org_tech_inst'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('কলেজ সরকারি', _c('org_college_govt'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('কলেজ বেসরকারি', _c('org_college_non_govt'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('মাদ্রাসা কামিল', _c('org_madrasa_kamil'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('ফাজিল', _c('org_madrasa_fazil'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('আলিম', _c('org_madrasa_alim'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('মাদ্রাসা দাখিল', _c('org_madrasa_dakhil'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('কওমী', _c('org_madrasa_qawmi'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('স্কুল সরকারি', _c('org_school_govt'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('স্কুল বেসরকারি', _c('org_school_non_govt'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('জোন/থানা', _c('org_zone_thana'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 12),
        Text('সংগঠন সারসংক্ষেপ:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('মোট শাখা', _c('org_total_shakha'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('কর্মী শাখা', _c('org_kormi_shakha'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('প্রাতিষ্ঠানিক বৃদ্ধি', _c('org_inst_growth'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('ঘাটতি', _c('org_inst_shortage'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('আবাসিক বৃদ্ধি', _c('org_res_growth'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('ঘাটতি', _c('org_res_shortage'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        _buildInput('সহযোগী সদস্য শাখা নামসমূহ', _c('org_assoc_shakha_names'), inputBg, textColor, borderColor),
      ],
    );
  }

  Widget _buildMeetingsSection(Color cardBg, Color textColor, Color inputBg, Color borderColor, Color oceanCyan) {
    return _buildSectionCard(
      title: '৪. সভাসমূহ (Meetings)',
      color: oceanCyan,
      cardBg: cardBg,
      textColor: textColor,
      borderColor: borderColor,
      children: [
        _buildTripleMeetingInput('দায়িত্বশীল সভা', 'meet_daitoshil', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildTripleMeetingInput('থানা/জোনাল সভা', 'meet_thana_daitoshil', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildTripleMeetingInput('সদস্য সভা', 'meet_member', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildTripleMeetingInput('সহযোগী সদস্য সভা', 'meet_assoc_member', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildTripleMeetingInput('কর্মী সভা', 'meet_worker', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildTripleMeetingInput('জরুরি সভা', 'meet_urgent', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildTripleMeetingInput('সাধারণ সভা', 'meet_general', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildTripleMeetingInput('আলোচনা সভা', 'meet_discussion', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildTripleMeetingInput('সহযোগী সদস্য সমাবেশ', 'meet_assoc_samabesh', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildTripleMeetingInput('কর্মী সমাবেশ', 'meet_worker_samabesh', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildTripleMeetingInput('ছাত্র সমাবেশ', 'meet_student_samabesh', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildTripleMeetingInput('মিছিল', 'meet_rally', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildTripleMeetingInput('দিবস পালন', 'meet_day_observance', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildTripleMeetingInput('অন্যান্য সভা', 'meet_other', inputBg, textColor, borderColor),
      ],
    );
  }

  Widget _buildTripleMeetingInput(String label, String prefix, Color inputBg, Color textColor, Color borderColor) {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildInput(label, _c('${prefix}_count'), inputBg, textColor, borderColor)),
        const SizedBox(width: 4),
        Expanded(flex: 2, child: _buildInput('উপস্থিতি', _c('${prefix}_pres'), inputBg, textColor, borderColor)),
        const SizedBox(width: 4),
        Expanded(flex: 3, child: _buildInput('সর্বোচ্চ/সর্বনিম্ন', _c('${prefix}_max_min'), inputBg, textColor, borderColor)),
      ],
    );
  }

  Widget _buildTrainingSection(Color cardBg, Color textColor, Color inputBg, Color borderColor, Color oceanCyan) {
    return _buildSectionCard(
      title: '৫. প্রশিক্ষণ (Training)',
      color: oceanCyan,
      cardBg: cardBg,
      textColor: textColor,
      borderColor: borderColor,
      children: [
        _buildQuadTrainingInput('স্কিলস ডেভেলপমেন্ট', 'train_skills', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildQuadTrainingInput('কর্মশালা', 'train_workshop', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildQuadTrainingInput('তরবিয়াতি সফর', 'train_tarbiyath', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildQuadTrainingInput('প্রশিক্ষণ চক্র', 'train_cycle', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildQuadTrainingInput('শিক্ষা সভা', 'train_education', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildQuadTrainingInput('কুরআন ও হাদীস ক্লাস', 'train_quran_hadith', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildQuadTrainingInput('শবগুজারি', 'train_shobgujari', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildQuadTrainingInput('জিকির মাহফিল', 'train_zikir', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildQuadTrainingInput('সমষ্টিগত অধ্যয়ন', 'train_group_study', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildQuadTrainingInput('হাদীস পাঠ', 'train_hadith_path', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildQuadTrainingInput('স্পীকার্স ফোরাম', 'train_speakers', inputBg, textColor, borderColor),
        const SizedBox(height: 6),
        _buildQuadTrainingInput('উন্মুক্ত ক্লাস', 'train_open_class', inputBg, textColor, borderColor),
      ],
    );
  }

  Widget _buildQuadTrainingInput(String label, String prefix, Color inputBg, Color textColor, Color borderColor) {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildInput(label, _c('${prefix}_count'), inputBg, textColor, borderColor)),
        const SizedBox(width: 4),
        Expanded(flex: 2, child: _buildInput('অধিবেশন', _c('${prefix}_session'), inputBg, textColor, borderColor)),
        const SizedBox(width: 4),
        Expanded(flex: 2, child: _buildInput('উপস্থিতি', _c('${prefix}_pres'), inputBg, textColor, borderColor)),
        const SizedBox(width: 4),
        Expanded(flex: 3, child: _buildInput('সর্বোচ্চ/সর্বনিম্ন', _c('${prefix}_max_min'), inputBg, textColor, borderColor)),
      ],
    );
  }

  Widget _buildLibrarySection(Color cardBg, Color textColor, Color inputBg, Color borderColor, Color oceanCyan) {
    return _buildSectionCard(
      title: '৬. পাঠাগার (Library)',
      color: oceanCyan,
      cardBg: cardBg,
      textColor: textColor,
      borderColor: borderColor,
      children: [
        Row(
          children: [
            Expanded(child: _buildInput('শাখা পাঠাগার বৃদ্ধি', _c('lib_shakha_growth'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('ঘাটতি', _c('lib_shakha_shortage'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('বই বৃদ্ধি', _c('lib_book_growth'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('ঘাটতি', _c('lib_book_shortage'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('পাঠক সংখ্যা', _c('lib_reader_count'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('ইস্যুকৃত বই', _c('lib_issued_books'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('পঠিত বই', _c('lib_read_books'), inputBg, textColor, borderColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildBaytulmalSection(Color cardBg, Color textColor, Color inputBg, Color borderColor, Color oceanCyan) {
    return _buildSectionCard(
      title: '৭. বায়তুলমাল ও প্রকাশনা (Baytulmal & Publications)',
      color: oceanCyan,
      cardBg: cardBg,
      textColor: textColor,
      borderColor: borderColor,
      children: [
        Text('বায়তুলমাল:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('বকেয়া', _c('bm_due'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('বকেয়া পরিশোধ', _c('bm_due_paid'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('মোট আয়', _c('bm_total_income'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('মোট ব্যয়', _c('bm_total_expense'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('উর্ধ্বতন ইয়ানত পরিশোধ', _c('bm_senior_paid'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('ধারকৃত', _c('bm_borrowed'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 12),
        Text('প্রকাশনা:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('মোট ক্রয়', _c('pub_total_buy'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('পরিশোধ', _c('pub_paid'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('বকেয়া', _c('pub_due'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('বকেয়া পরিশোধ', _c('pub_due_paid'), inputBg, textColor, borderColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildWelfareSection(Color cardBg, Color textColor, Color inputBg, Color borderColor, Color oceanCyan) {
    return _buildSectionCard(
      title: '৮. ছাত্রকল্যাণ (Student Welfare)',
      color: oceanCyan,
      cardBg: cardBg,
      textColor: textColor,
      borderColor: borderColor,
      children: [
        Row(
          children: [
            Expanded(child: _buildInput('মোট আয়', _c('sw_total_income'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('মোট ব্যয়', _c('sw_total_expense'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('লজিং (টি)', _c('sw_lodging'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('টিউশনি (টি)', _c('sw_tuition'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('টেবিল/কলসি ব্যাংক', _c('sw_table_bank'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('প্রশ্নপত্র/নোট বিলি', _c('sw_notes_dist'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('যাকাত সংগ্রহ', _c('sw_zakat_collected'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('লাইব্রেরি বই বৃদ্ধি', _c('sw_lang_lib_books'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('ঘাটতি', _c('sw_lang_lib_shortage'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('কোচিং (টি)', _c('sw_coaching'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('ফ্রি কোচিং/আবাসন', _c('sw_free_coaching'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('ছাত্র বৃদ্ধি', _c('sw_free_coaching_people_growth'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('ঘাটতি', _c('sw_free_coaching_shortage'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('স্টাইপেন্ড', _c('sw_stipend_count'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('রক্তদান (ব্যাগ)', _c('sw_blood_bags'), inputBg, textColor, borderColor)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInput('ভর্তি গাইড প্রকাশ', _c('sw_guide_pub'), inputBg, textColor, borderColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildInput('ভর্তিকালীন সাহায্য', _c('sw_admission_help'), inputBg, textColor, borderColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildRemarksSection(Color cardBg, Color textColor, Color inputBg, Color borderColor, Color oceanCyan) {
    return _buildSectionCard(
      title: '৯. মন্তব্য (Remarks)',
      color: oceanCyan,
      cardBg: cardBg,
      textColor: textColor,
      borderColor: borderColor,
      children: [
        TextFormField(
          controller: _c('remarks'),
          readOnly: _isLocked,
          maxLines: 3,
          onChanged: (_) => _markChanged(),
          style: TextStyle(color: textColor, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'গৃহীত পরিকল্পনার আলোকে, সমস্যা ও সম্ভাবনা উল্লেখ করে মন্তব্য লিখুন...',
            hintStyle: TextStyle(color: textColor.withValues(alpha: 0.4), fontSize: 12),
            filled: true,
            fillColor: inputBg,
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: oceanCyan)),
          ),
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
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
    return TextFormField(
      controller: controller,
      readOnly: _isLocked,
      onChanged: (_) => _markChanged(),
      style: TextStyle(color: textColor, fontSize: 12),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor.withValues(alpha: 0.6), fontSize: 11),
        filled: true,
        fillColor: inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF0077B6))),
      ),
    );
  }
}
