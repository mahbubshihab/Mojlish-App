import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import '../../data/services/student_period_plan_pdf_service.dart';

class PeriodPlanScreen extends StatefulWidget {
  const PeriodPlanScreen({super.key});

  @override
  State<PeriodPlanScreen> createState() => _PeriodPlanScreenState();
}

class _PeriodPlanScreenState extends State<PeriodPlanScreen> {
  final _branchController = TextEditingController(text: 'কেন্দ্রীয়');
  final _monthController = TextEditingController(text: 'মহররম-সফর');
  final _sessionController = TextEditingController(text: '২০২৬');

  // Form Controllers Map
  final Map<String, TextEditingController> _controllers = {};

  TextEditingController _c(String key) {
    return _controllers.putIfAbsent(key, () => TextEditingController());
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
        title: const Text('বার্ষিক/ষান্মাসিক/দ্বি-মাসিক পরিকল্পনা'),
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
          child: SingleChildScrollView(
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
                        'পরিকল্পনা প্রণয়ন ফরম',
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

                // 1. Dawah Section
                _buildSectionCard(
                  title: 'প্রথম দফা : দাওয়াত',
                  color: const Color(0xFF2563EB),
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('স্কুল সরকারি (জন)', _c('dawa_school_govt'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('স্কুল বেসরকারি (জন)', _c('dawa_school_non_govt'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('কলেজ (জন)', _c('dawa_college'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('মাদ্রাসা আলিয়া (জন)', _c('dawa_madrasa_alia'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('কওমী (জন)', _c('dawa_madrasa_qawmi'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('বিশ্ববিদ্যালয় (জন)', _c('dawa_university'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('শুভাকাঙ্ক্ষী বৃদ্ধি (জন)', _c('dawa_shuvakangkhi_growth'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('শুভাকাঙ্ক্ষী যোগাযোগ (জন)', _c('dawa_shuvakangkhi_contact'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('ইসলামী সাহিত্য (টি)', _c('dawa_sahitya'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('ছাত্র পরিক্রমা (টি)', _c('dawa_patrika'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('লিফলেট (টি)', _c('dawa_leaflet'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('স্টিকার (টি)', _c('dawa_stiker'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('পোস্টার (টি)', _c('dawa_poster'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('দেয়াল লিখন (টি)', _c('dawa_deyal_likhon'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('দেয়ালিকা প্রকাশ (টি)', _c('dawa_deyalika'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('নবীন বরণ (টি)', _c('dawa_nobin_boron'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('গ্রুপ দাওয়াত (টি)', _c('dawa_group_dawa'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('চা চক্র (টি)', _c('dawa_cha_chokro'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('উন্মুক্ত আসর (টি)', _c('dawa_onmukto_asor'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('বক্তৃতা (টি)', _c('dawa_boktita'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('বিতর্ক (টি)', _c('dawa_bitorko'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('সাধারণ জ্ঞান (টি)', _c('dawa_giyan_proti'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildInput('অন্যান্য দাওয়াতি কার্যক্রম', _c('dawa_other'), inputBg, textColor, borderColor),
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
                  color: const Color(0xFF0D9488),
                  cardBg: cardBg,
                  textColor: textColor,
                  borderColor: borderColor,
                  inputBg: inputBg,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildInput('সহযোগী প্রার্থী টার্গেট (জন)', _c('org_candidate_target'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('কর্মী বৃদ্ধি (জন)', _c('org_worker_growth'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildInput('সহযোগী প্রার্থী নাম', _c('org_candidate_names'), inputBg, textColor, borderColor),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('স্কুল সরকারি (জন)', _c('org_school_govt'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('স্কুল বেসরকারি (জন)', _c('org_school_non_govt'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('কলেজ (জন)', _c('org_college'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('মাদ্রাসা আলিয়া (জন)', _c('org_madrasa_alia'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('কওমী (জন)', _c('org_madrasa_qawmi'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('বিশ্ববিদ্যালয় (জন)', _c('org_university'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('সহযোগী সদস্য শাখা বৃদ্ধি (টি)', _c('org_assoc_branch_growth'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('নাম', _c('org_assoc_branch_names'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('থানা/জোন শাখা বৃদ্ধি (টি)', _c('org_zone_branch_growth'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('নাম', _c('org_zone_branch_names'), inputBg, textColor, borderColor)),
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
                    _buildInput('কর্মী শাখা নাম', _c('org_worker_branch_names'), inputBg, textColor, borderColor),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('ঊর্ধ্বতন সফর আনা হবে (টি)', _c('org_senior_visit'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('তারিখ', _c('org_senior_visit_date'), inputBg, textColor, borderColor)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 3. Meetings Section
                _buildSectionCard(
                  title: 'সভাসমূহ',
                  color: const Color(0xFF7C3AED),
                  cardBg: cardBg,
                  textColor: textColor,
                  borderColor: borderColor,
                  inputBg: inputBg,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildInput('দায়িত্বশীল সভা (টি)', _c('meet_daitoshil'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('তারিখ ও সময়', _c('meet_daitoshil_date_time'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('জোনাল সভা (টি)', _c('meet_zonal'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('তারিখ ও সময়', _c('meet_zonal_date_time'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('সদস্য সভা (টি)', _c('meet_member'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('তারিখ ও সময়', _c('meet_member_date_time'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('সহযোগী সদস্য সভা (টি)', _c('meet_assoc_member'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('তারিখ ও সময়', _c('meet_assoc_member_date_time'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('কর্মী সভা (টি)', _c('meet_worker'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('তারিখ ও সময়', _c('meet_worker_date_time'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('সাধারণ সভা (টি)', _c('meet_general'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('তারিখ ও সময়', _c('meet_general_date_time'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('আলোচনা সভা (টি)', _c('meet_discussion'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('তারিখ ও সময়', _c('meet_discussion_date_time'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildInput('অন্যান্য সভাসমূহ', _c('meet_other'), inputBg, textColor, borderColor),
                    const SizedBox(height: 8),
                    _buildInput('বায়তুলমাল সংগ্রহ টার্গেট (টাকা)', _c('meet_baytulmal_target'), inputBg, textColor, borderColor),
                  ],
                ),
                const SizedBox(height: 16),

                // 4. Training Section
                _buildSectionCard(
                  title: 'তৃতীয় দফা : প্রশিক্ষণ',
                  color: const Color(0xFF059669),
                  cardBg: cardBg,
                  textColor: textColor,
                  borderColor: borderColor,
                  inputBg: inputBg,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildInput('কর্মশালা (টি)', _c('train_workshop'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('তারিখ', _c('train_workshop_date'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('সময়', _c('train_workshop_time'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('স্থান', _c('train_workshop_place'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('শিক্ষা সভা (টি)', _c('train_edu_meeting'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('তারিখ', _c('train_edu_meeting_date'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('সময়', _c('train_edu_meeting_time'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('স্থান', _c('train_edu_meeting_place'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('সমষ্টিগত অধ্যয়ন (টি)', _c('train_group_study_count'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('অধিবেশন (টি)', _c('train_group_study_session'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('শবগুজারী (টি)', _c('train_shobgujari'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('তারিখ', _c('train_shobgujari_date'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('সময়', _c('train_shobgujari_time'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('স্থান', _c('train_shobgujari_place'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('জিকির মাহফিল (টি)', _c('train_zikir'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('তারিখ', _c('train_zikir_date'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('সময়', _c('train_zikir_time'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('স্থান', _c('train_zikir_place'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('প্রশিক্ষণ চক্র (টি)', _c('train_cycle_count'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('অধিবেশন (টি)', _c('train_cycle_session'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('তারিখ', _c('train_cycle_date'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('স্কিলস কোর্স (টি)', _c('train_skills_course_count'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('অধিবেশন (টি)', _c('train_skills_course_session'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('তারিখ', _c('train_skills_course_date'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('তারবিয়াতি সফর (টি)', _c('train_tarbiyati_tour'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('তারিখ', _c('train_tarbiyati_tour_date'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('সময়', _c('train_tarbiyati_tour_time'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('স্থান', _c('train_tarbiyati_tour_place'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('কুরআন ও হাদিস ক্লাস (টি)', _c('train_quran_hadith_count'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('অধিবেশন (টি)', _c('train_quran_hadith_session'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('মাসআলা-মাসায়েল ক্লাস (টি)', _c('train_masala_count'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('অধিবেশন (টি)', _c('train_masala_session'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('উন্মুক্ত ক্লাস (টি)', _c('train_open_class_count'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('অধিবেশন (টি)', _c('train_open_class_session'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('স্পীকার্স ফোরাম (টি)', _c('train_speakers_count'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('অধিবেশন (টি)', _c('train_speakers_session'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('পাঠাগার বৃদ্ধি (টি)', _c('train_library_growth'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('বই বৃদ্ধি (টি)', _c('train_book_growth'), inputBg, textColor, borderColor)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 5. Movement Section
                _buildSectionCard(
                  title: 'চতুর্থ দফা : আন্দোলন ও ছাত্রকল্যাণ',
                  color: const Color(0xFFDC2626),
                  cardBg: cardBg,
                  textColor: textColor,
                  borderColor: borderColor,
                  inputBg: inputBg,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildInput('যাকাত সংগ্রহ (টাকা)', _c('welfare_zakat'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('টেবিল ব্যাংক/কলসি বৃদ্ধি (টি)', _c('welfare_table_bank'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('লজিং (টি)', _c('welfare_lodging'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('টিউশনি (টি)', _c('welfare_tuition'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('বৃত্তি চালু (টি)', _c('welfare_stipend'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('আবাসন (জন ছাত্রের)', _c('welfare_accommodation'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('ফ্রি কোচিং (টি)', _c('welfare_free_coaching'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildInput('একাডেমিক/ভর্তি কোচিং (টি)', _c('welfare_coaching'), inputBg, textColor, borderColor),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('প্রশ্নপত্র (টি)', _c('welfare_question_paper'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('সাজেশন (টি)', _c('welfare_suggestion'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('নোট বিলি (টি)', _c('welfare_note'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('লাইভ লাইব্রেরী (টি)', _c('welfare_live_library'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('বই বৃদ্ধি (টি)', _c('welfare_live_library_book'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('ভর্তি গাইড প্রকাশ (টি)', _c('welfare_admission_guide'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('সহযোগিতা (টি)', _c('welfare_admission_help'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('সাহায্যপ্রাপ্ত ছাত্র (জন)', _c('welfare_admission_student_help'), inputBg, textColor, borderColor)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 6. Social Service Section
                _buildSectionCard(
                  title: 'সামাজিক খেদমত',
                  color: const Color(0xFFD97706),
                  cardBg: cardBg,
                  textColor: textColor,
                  borderColor: borderColor,
                  inputBg: inputBg,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildInput('গাছ লাগানো (টি)', _c('social_tree'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('রক্তদান (ব্যাগ)', _c('social_blood'), inputBg, textColor, borderColor)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 7. Baytulmal Budget Section
                _buildSectionCard(
                  title: 'বায়তুলমাল বাজেট',
                  color: const Color(0xFF4F46E5),
                  cardBg: cardBg,
                  textColor: textColor,
                  borderColor: borderColor,
                  inputBg: inputBg,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildInput('জনশক্তি ইয়ানত (টাকা)', _c('inc_1'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('ঊর্ধ্বতন এয়ানত (টাকা)', _c('exp_1'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('শাখা ইয়ানত (টাকা)', _c('inc_2'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('ঊর্ধ্বতন সফর (টাকা)', _c('exp_2'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('শুভাকাঙ্ক্ষী ইয়ানত (টাকা)', _c('inc_3'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('অফিস খরচ (টাকা)', _c('exp_3'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('এককালীন আয় (টাকা)', _c('inc_4'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('যাতায়াত (টাকা)', _c('exp_4'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('অন্যান্য আয় (টাকা)', _c('inc_5'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('যোগাযোগ (টাকা)', _c('exp_5'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('অতিরিক্ত আয় (টাকা)', _c('inc_6'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('প্রচার (টাকা)', _c('exp_6'), inputBg, textColor, borderColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('মোট আয় (টাকা)', _c('inc_total'), inputBg, textColor, borderColor)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('মোট ব্যয় (টাকা)', _c('exp_total'), inputBg, textColor, borderColor)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons
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
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('পরিকল্পনা সফলভাবে সংরক্ষণ করা হয়েছে')),
                            );
                          },
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
                        label: const Text('PDF প্রিন্ট', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
