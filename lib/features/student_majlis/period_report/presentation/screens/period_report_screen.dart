import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import '../../data/services/student_period_pdf_service.dart';
import '../../data/services/student_period_storage_service.dart';
import '../../data/models/period_report_model.dart';

class PeriodReportScreen extends StatefulWidget {
  const PeriodReportScreen({super.key});

  @override
  State<PeriodReportScreen> createState() => _PeriodReportScreenState();
}

class _PeriodReportScreenState extends State<PeriodReportScreen> {
  final _branchController = TextEditingController(text: 'কেন্দ্রীয়');
  final _monthController = TextEditingController(text: 'মহররম-সফর');
  final _sessionController = TextEditingController(text: '২০২৬');

  final Map<String, TextEditingController> _controllers = {};
  bool _isLoading = true;

  TextEditingController _c(String key) {
    return _controllers.putIfAbsent(key, () => TextEditingController());
  }

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    try {
      final report = await StudentPeriodStorageService.getReport(
        periodType: 'report',
        year: DateTime.now().year,
        periodName: _monthController.text,
      );
      if (mounted) {
        setState(() {
          if (report.branch.isNotEmpty) _branchController.text = report.branch;
          if (report.month.isNotEmpty) _monthController.text = report.month;
          if (report.session.isNotEmpty) _sessionController.text = report.session;

          _c('mp_member_count').text = report.manpower.members == 0 ? '' : '${report.manpower.members}';
          _c('mp_cand_member_count').text = report.manpower.candidateMembers == 0 ? '' : '${report.manpower.candidateMembers}';
          _c('mp_assoc_member_count').text = report.manpower.associateMembers == 0 ? '' : '${report.manpower.associateMembers}';
          _c('mp_cand_assoc_member_count').text = report.manpower.candidateAssociateMembers == 0 ? '' : '${report.manpower.candidateAssociateMembers}';
          _c('mp_worker_count').text = report.manpower.workers == 0 ? '' : '${report.manpower.workers}';
          _c('dw_primary_count').text = report.dawah.primaryMembers == 0 ? '' : '${report.dawah.primaryMembers}';
          _c('dw_friend_count').text = report.dawah.friends == 0 ? '' : '${report.dawah.friends}';
          _c('dw_wellwisher_count').text = report.dawah.wellWishers == 0 ? '' : '${report.dawah.wellWishers}';
          _c('org_public_uni').text = report.organization.publicUniversities == 0 ? '' : '${report.organization.publicUniversities}';
          _c('org_private_uni').text = report.organization.privateUniversities == 0 ? '' : '${report.organization.privateUniversities}';
          _c('org_college_govt').text = report.organization.colleges == 0 ? '' : '${report.organization.colleges}';
          _c('org_madrasa_kamil').text = report.organization.madrasas == 0 ? '' : '${report.organization.madrasas}';
          _c('org_school_govt').text = report.organization.schools == 0 ? '' : '${report.organization.schools}';
          _c('meet_daitoshil_count').text = report.meetings.responsibleMeetings == 0 ? '' : '${report.meetings.responsibleMeetings}';
          _c('meet_member_count').text = report.meetings.memberMeetings == 0 ? '' : '${report.meetings.memberMeetings}';
          _c('meet_general_count').text = report.meetings.generalMeetings == 0 ? '' : '${report.meetings.generalMeetings}';
          _c('train_skills_count').text = report.training.skillsDevelopment == 0 ? '' : '${report.training.skillsDevelopment}';
          _c('train_workshop_count').text = report.training.workshops == 0 ? '' : '${report.training.workshops}';
          _c('train_education_count').text = report.training.educationMeetings == 0 ? '' : '${report.training.educationMeetings}';
          _c('lib_book_growth').text = report.library.totalBooks == 0 ? '' : '${report.library.totalBooks}';
          _c('lib_reader_count').text = report.library.totalReaders == 0 ? '' : '${report.library.totalReaders}';
          _c('bm_total_income').text = report.baytulmal.totalIncome == 0.0 ? '' : '${report.baytulmal.totalIncome}';
          _c('bm_total_expense').text = report.baytulmal.totalExpense == 0.0 ? '' : '${report.baytulmal.totalExpense}';
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _branchController.dispose();
    _monthController.dispose();
    _sessionController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Map<String, String> _collectFormData() {
    final Map<String, String> data = {};
    for (var entry in _controllers.entries) {
      data[entry.key] = entry.value.text.trim();
    }
    data['branch'] = _branchController.text.trim();
    data['month'] = _monthController.text.trim();
    data['session'] = _sessionController.text.trim();
    return data;
  }

  Future<void> _saveData() async {
    final formData = _collectFormData();
    final model = PeriodReportModel(
      id: 'report_${DateTime.now().year}_${_monthController.text.replaceAll(' ', '_')}',
      branch: _branchController.text,
      month: _monthController.text,
      session: _sessionController.text,
      manpower: ManpowerModel(
        members: int.tryParse(formData['mp_member_count'] ?? '') ?? 0,
        candidateMembers: int.tryParse(formData['mp_cand_member_count'] ?? '') ?? 0,
        associateMembers: int.tryParse(formData['mp_assoc_member_count'] ?? '') ?? 0,
        candidateAssociateMembers: int.tryParse(formData['mp_cand_assoc_member_count'] ?? '') ?? 0,
        workers: int.tryParse(formData['mp_worker_count'] ?? '') ?? 0,
      ),
      dawah: DawahModel(
        primaryMembers: int.tryParse(formData['dw_primary_count'] ?? '') ?? 0,
        friends: int.tryParse(formData['dw_friend_count'] ?? '') ?? 0,
        wellWishers: int.tryParse(formData['dw_wellwisher_count'] ?? '') ?? 0,
      ),
      organization: OrganizationModel(
        publicUniversities: int.tryParse(formData['org_public_uni'] ?? '') ?? 0,
        privateUniversities: int.tryParse(formData['org_private_uni'] ?? '') ?? 0,
        colleges: int.tryParse(formData['org_college_govt'] ?? '') ?? 0,
        madrasas: int.tryParse(formData['org_madrasa_kamil'] ?? '') ?? 0,
        schools: int.tryParse(formData['org_school_govt'] ?? '') ?? 0,
      ),
      meetings: MeetingsModel(
        responsibleMeetings: int.tryParse(formData['meet_daitoshil_count'] ?? '') ?? 0,
        memberMeetings: int.tryParse(formData['meet_member_count'] ?? '') ?? 0,
        generalMeetings: int.tryParse(formData['meet_general_count'] ?? '') ?? 0,
      ),
      training: TrainingModel(
        skillsDevelopment: int.tryParse(formData['train_skills_count'] ?? '') ?? 0,
        workshops: int.tryParse(formData['train_workshop_count'] ?? '') ?? 0,
        educationMeetings: int.tryParse(formData['train_education_count'] ?? '') ?? 0,
      ),
      library: LibraryModel(
        totalBooks: int.tryParse(formData['lib_book_growth'] ?? '') ?? 0,
        totalReaders: int.tryParse(formData['lib_reader_count'] ?? '') ?? 0,
      ),
      baytulmal: BaytulmalModel(
        totalIncome: double.tryParse(formData['bm_total_income'] ?? '') ?? 0.0,
        totalExpense: double.tryParse(formData['bm_total_expense'] ?? '') ?? 0.0,
      ),
    );

    await StudentPeriodStorageService.saveReport(model);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('রিপোর্ট সফলভাবে সংরক্ষণ করা হয়েছে')),
      );
    }
  }

  void _exportPdf() {
    final formData = _collectFormData();
    StudentPeriodPdfService.generateAndPrintPdf(
      branch: _branchController.text,
      month: _monthController.text,
      session: _sessionController.text,
      formData: formData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final inputBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF2563EB)),
            tooltip: 'PDF এক্সপোর্ট',
            onPressed: _exportPdf,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: AmbientBackgroundWidget(
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Header Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
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
                                color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E40AF),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'বার্ষিক / ষান্মাসিক / দ্বি-মাসিক রিপোর্ট ফরম (২ পৃষ্ঠা)',
                              style: TextStyle(
                                fontSize: 13,
                                color: textColor.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 12),
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

                      // ১. জনশক্তি বিবরণী (Manpower)
                      _buildSectionCard(
                        title: '১. জনশক্তি বিবরণী',
                        color: const Color(0xFF2563EB),
                        cardBg: cardBg,
                        textColor: textColor,
                        borderColor: borderColor,
                        children: [
                          _buildSubsectionHeader('সদস্য', textColor),
                          Row(
                            children: [
                              Expanded(child: _buildInput('সংখ্যা', _c('mp_member_count'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('বৃদ্ধি', _c('mp_member_growth'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('কিভাবে', _c('mp_member_how'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildInput('টার্গেট', _c('mp_member_target'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('ঘাটতি', _c('mp_member_shortage'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('কারণ', _c('mp_member_reason'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 10),

                          _buildSubsectionHeader('সদস্য প্রার্থী', textColor),
                          Row(
                            children: [
                              Expanded(child: _buildInput('সংখ্যা', _c('mp_cand_member_count'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('বৃদ্ধি', _c('mp_cand_member_growth'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('টার্গেট', _c('mp_cand_member_target'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('ঘাটতি', _c('mp_cand_member_shortage'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 10),

                          _buildSubsectionHeader('সহযোগী সদস্য & কর্মী', textColor),
                          Row(
                            children: [
                              Expanded(child: _buildInput('সহযোগী সদস্য', _c('mp_assoc_member_count'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('সহযোগী প্রার্থী', _c('mp_cand_assoc_member_count'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('কর্মী সংখ্যা', _c('mp_worker_count'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildInput('মোট জনশক্তি', _c('mp_total_count'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('মোট বৃদ্ধি', _c('mp_total_growth'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('মোট ঘাটতি', _c('mp_total_shortage'), inputBg, textColor, borderColor)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ২. দাওয়াত ও অন্যান্য (Dawah & Literature)
                      _buildSectionCard(
                        title: '২. দাওয়াত ও অন্যান্য',
                        color: const Color(0xFF0D9488),
                        cardBg: cardBg,
                        textColor: textColor,
                        borderColor: borderColor,
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildInput('প্রাথমিক সদস্য (সংখ্যা)', _c('dw_primary_count'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('বন্ধু (সংখ্যা)', _c('dw_friend_count'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('শুভাকাঙ্ক্ষী (সংখ্যা)', _c('dw_wellwisher_count'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildSubsectionHeader('বিতরণকৃত প্রকাশনা/সামগ্রী', textColor),
                          Row(
                            children: [
                              Expanded(child: _buildInput('ইসলামী সাহিত্য', _c('dist_sahitya'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('স্টিকার/ডায়েরি', _c('dist_sticker'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildInput('পরিচিতি', _c('dist_porichiti'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('ক্লাস/পরীক্ষার রুটিন', _c('dist_routine'), inputBg, textColor, borderColor)),
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
                          const SizedBox(height: 10),
                          _buildSubsectionHeader('দাওয়াতি উদ্যোগ ও শাখা বিস্তার', textColor),
                          Row(
                            children: [
                              Expanded(child: _buildInput('গ্রুপ দাওয়াত (টি)', _c('dw_group_dawa'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('চা-চক্র (টি)', _c('dw_cha_chokro'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildInput('প্রাথমিক শাখা প্রাতিষ্ঠানিক (টি)', _c('dw_pri_shakha_inst'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('বৃদ্ধি', _c('dw_pri_shakha_inst_growth'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('ঘাটতি', _c('dw_pri_shakha_inst_shortage'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildInput('সংবাদ প্রকাশিত (বার)', _c('dw_news_media'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('দেয়ালিকা প্রকাশ (টি)', _c('dw_deyalika'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildInput('বক্তৃতা/বিতর্ক প্রতিযোগিতা', _c('dw_competition'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('নবীন বরণ (টি)', _c('dw_nobin_boron'), inputBg, textColor, borderColor)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ৩. সংগঠন (Organization Table)
                      _buildSectionCard(
                        title: '৩. সংগঠন ও শিক্ষা প্রতিষ্ঠান',
                        color: const Color(0xFF7C3AED),
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
                              Expanded(child: _buildInput('কলেজ সরকারি (টি)', _c('org_college_govt'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('কলেজ বেসরকারি (টি)', _c('org_college_non_govt'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildInput('মাদ্রাসা কামিল/আলিম (টি)', _c('org_madrasa_kamil'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('মাদ্রাসা কওমী (টি)', _c('org_madrasa_qawmi'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildInput('স্কুল সরকারি/বেসরকারি (টি)', _c('org_school_govt'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('জোন/থানা সংখ্যা (টি)', _c('org_zone_thana'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildInput('মোট শাখা (টি)', _c('org_total_shakha'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('কর্মী শাখা (টি)', _c('org_kormi_shakha'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          _buildInput('সহযোগী সদস্য শাখা (নামসহ)', _c('org_assoc_shakha_names'), inputBg, textColor, borderColor),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ৪. সভাসমূহ (Meetings)
                      _buildSectionCard(
                        title: '৪. সভাসমূহ (পৃষ্ঠা ২)',
                        color: const Color(0xFF059669),
                        cardBg: cardBg,
                        textColor: textColor,
                        borderColor: borderColor,
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildInput('দায়িত্বশীল সভা (টি)', _c('meet_daitoshil_count'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('উপস্থিতি', _c('meet_daitoshil_pres'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildInput('সদস্য সভা (টি)', _c('meet_member_count'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('উপস্থিতি', _c('meet_member_pres'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildInput('কর্মী সভা (টি)', _c('meet_worker_count'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('সাধারণ সভা (টি)', _c('meet_general_count'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildInput('আলোচনা সভা (টি)', _c('meet_discussion_count'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('মিছিল/সমাবেশ (টি)', _c('meet_rally_count'), inputBg, textColor, borderColor)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ৫. প্রশিক্ষণ (Training)
                      _buildSectionCard(
                        title: '৫. প্রশিক্ষণ কর্মসূচি',
                        color: const Color(0xFFD97706),
                        cardBg: cardBg,
                        textColor: textColor,
                        borderColor: borderColor,
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildInput('স্কিলস ডেভেলপমেন্ট (টি)', _c('train_skills_count'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('কর্মশালা (টি)', _c('train_workshop_count'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildInput('তরবিয়াতি সফর (টি)', _c('train_tarbiyath_count'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('শিক্ষা সভা (টি)', _c('train_education_count'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _buildInput('কুরআন-হাদীস ক্লাস (টি)', _c('train_quran_hadith_count'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('শবগুজারি/জিকির (টি)', _c('train_shobgujari_count'), inputBg, textColor, borderColor)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ৬. পাঠাগার, বায়তুলমাল ও ছাত্রকল্যাণ
                      _buildSectionCard(
                        title: '৬. পাঠাগার, বায়তুলমাল ও ছাত্রকল্যাণ',
                        color: const Color(0xFFDC2626),
                        cardBg: cardBg,
                        textColor: textColor,
                        borderColor: borderColor,
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildInput('পাঠাগার বই বৃদ্ধি', _c('lib_book_growth'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('পাঠক সংখ্যা', _c('lib_reader_count'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('পঠিত বই', _c('lib_read_books'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(child: _buildInput('বায়তুলমাল মোট আয় (টাকা)', _c('bm_total_income'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('বায়তুলমাল মোট ব্যয় (টাকা)', _c('bm_total_expense'), inputBg, textColor, borderColor)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(child: _buildInput('লজিং ব্যবস্থা (টি)', _c('sw_lodging'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('টিউশনি (টি)', _c('sw_tuition'), inputBg, textColor, borderColor)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildInput('রক্ত দান (ব্যাগ)', _c('sw_blood_bags'), inputBg, textColor, borderColor)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ৭. মন্তব্য & পরামর্শ
                      _buildSectionCard(
                        title: '৭. মন্তব্য (সমস্যা ও সম্ভাবনা)',
                        color: const Color(0xFF4F46E5),
                        cardBg: cardBg,
                        textColor: textColor,
                        borderColor: borderColor,
                        children: [
                          TextField(
                            controller: _c('remarks'),
                            maxLines: 4,
                            style: TextStyle(fontSize: 13, color: textColor),
                            decoration: InputDecoration(
                              hintText: 'গৃহীত পরিকল্পনার আলোকে সমস্যা ও সম্ভাবনা সংক্ষেপে উল্লেখ করুন...',
                              hintStyle: TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.5)),
                              filled: true,
                              fillColor: inputBg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: borderColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Bottom Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF059669), Color(0xFF10B981)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: _saveData,
                                icon: const Icon(Icons.save_rounded, color: Colors.white),
                                label: const Text('সংরক্ষণ করুন', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: _exportPdf,
                              icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
                              label: const Text('PDF এক্সপোর্ট', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSubsectionHeader(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: color.withValues(alpha: 0.85),
        ),
      ),
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
                height: 18,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
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
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 13, color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.7)),
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
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
      ),
    );
  }
}
