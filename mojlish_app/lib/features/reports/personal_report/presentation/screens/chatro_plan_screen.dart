import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/features/reports/personal_report/data/models/chatro_monthly_plan.dart';
import '../../../shared/data/services/report_storage_service.dart';
import '../../../shared/data/services/pdf_generator_service.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস — স্বতন্ত্র মাসিক পরিকল্পনা স্ক্রিন
class ChatroPlanScreen extends StatefulWidget {
  final int initialYear;
  final int initialMonth;

  const ChatroPlanScreen({
    super.key,
    required this.initialYear,
    required this.initialMonth,
  });

  @override
  State<ChatroPlanScreen> createState() => _ChatroPlanScreenState();
}

class _ChatroPlanScreenState extends State<ChatroPlanScreen> {
  late int _selectedYear;
  late int _selectedMonth;
  bool _isLoading = true;

  // Controllers for 7 sections
  final _sessionCtrl = TextEditingController();
  final _branchNameCtrl = TextEditingController();

  // ১ম দফা: দাওয়াত
  final _friendTargetCtrl = TextEditingController();
  final _primaryMemberTargetCtrl = TextEditingController();
  final _schoolGovtCountCtrl = TextEditingController();
  final _schoolNonGovtCountCtrl = TextEditingController();
  final _collegeCountCtrl = TextEditingController();
  final _madrasaAliaCountCtrl = TextEditingController();
  final _madrasaQawmiCountCtrl = TextEditingController();
  final _universityCountCtrl = TextEditingController();
  final _wellWisherCountCtrl = TextEditingController();
  final _literatureDistributionCtrl = TextEditingController();
  final _magazineDistributionCtrl = TextEditingController();
  final _posterStickerCountCtrl = TextEditingController();
  final _wallWritingCountCtrl = TextEditingController();
  final _groupDawahCountCtrl = TextEditingController();
  final _debateCompetitionCountCtrl = TextEditingController();
  final _institutionalBranchCountCtrl = TextEditingController();
  final _residentialBranchCountCtrl = TextEditingController();

  // ২য় দফা: সংগঠন
  final _associateCandidateTargetCtrl = TextEditingController();
  final _kormiTargetCtrl = TextEditingController();
  final _associateBranchIncreaseCtrl = TextEditingController();
  final _zonalBranchIncreaseCtrl = TextEditingController();
  final _workerBranchIncreaseCtrl = TextEditingController();
  final _seniorVisitCountCtrl = TextEditingController();

  // ৩য় দফা: সভাসমূহ
  final _executiveMeetingCountCtrl = TextEditingController();
  final _zonalMeetingCountCtrl = TextEditingController();
  final _memberMeetingCountCtrl = TextEditingController();
  final _associateMeetingCountCtrl = TextEditingController();
  final _workerMeetingCountCtrl = TextEditingController();
  final _generalMeetingCountCtrl = TextEditingController();
  final _discussionMeetingCountCtrl = TextEditingController();
  final _baytulmalCollectionTargetCtrl = TextEditingController();

  // ৪র্থ দফা: প্রশিক্ষণ
  final _workshopCountCtrl = TextEditingController();
  final _studyTourCountCtrl = TextEditingController();
  final _groupStudyCountCtrl = TextEditingController();
  final _nightStayCountCtrl = TextEditingController();
  final _zikrMahfilCountCtrl = TextEditingController();
  final _trainingCircleCountCtrl = TextEditingController();
  final _skillCourseCountCtrl = TextEditingController();
  final _quranHadithClassCountCtrl = TextEditingController();
  final _masailaClassCountCtrl = TextEditingController();
  final _openClassCountCtrl = TextEditingController();
  final _libraryBookIncreaseCtrl = TextEditingController();

  // ৫ম দফা: আন্দোলন ও ছাত্রকল্যাণ
  final _zakatCollectionTargetCtrl = TextEditingController();
  final _tuitionHelpCountCtrl = TextEditingController();
  final _hostelHelpCountCtrl = TextEditingController();
  final _coachingClassCountCtrl = TextEditingController();
  final _noteBookDistributionCtrl = TextEditingController();
  final _libraryEstablishmentCtrl = TextEditingController();

  // ৬ষ্ঠ দফা: সামাজিক খেদমত
  final _treePlantationCountCtrl = TextEditingController();
  final _bloodDonationBagsCtrl = TextEditingController();
  final _quranTeachingCountCtrl = TextEditingController();
  final _socialWelfareNotesCtrl = TextEditingController();

  // ৭ম দফা: বাজেট
  final _totalEstimatedIncomeCtrl = TextEditingController();
  final _totalEstimatedExpenseCtrl = TextEditingController();

  static const _months = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
  ];

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear;
    _selectedMonth = widget.initialMonth;
    _loadPlan();
  }

  Future<void> _loadPlan() async {
    setState(() => _isLoading = true);
    final plan = await ReportStorageService.getChatroMonthlyPlan(_selectedYear, _selectedMonth);
    if (plan != null) {
      _sessionCtrl.text = plan.session;
      _branchNameCtrl.text = plan.branchName;
      _friendTargetCtrl.text = plan.friendTarget;
      _primaryMemberTargetCtrl.text = plan.primaryMemberTarget;
      _schoolGovtCountCtrl.text = plan.schoolGovtCount;
      _schoolNonGovtCountCtrl.text = plan.schoolNonGovtCount;
      _collegeCountCtrl.text = plan.collegeCount;
      _madrasaAliaCountCtrl.text = plan.madrasaAliaCount;
      _madrasaQawmiCountCtrl.text = plan.madrasaQawmiCount;
      _universityCountCtrl.text = plan.universityCount;
      _wellWisherCountCtrl.text = plan.wellWisherCount;
      _literatureDistributionCtrl.text = plan.literatureDistribution;
      _magazineDistributionCtrl.text = plan.magazineDistribution;
      _posterStickerCountCtrl.text = plan.posterStickerCount;
      _wallWritingCountCtrl.text = plan.wallWritingCount;
      _groupDawahCountCtrl.text = plan.groupDawahCount;
      _debateCompetitionCountCtrl.text = plan.debateCompetitionCount;
      _institutionalBranchCountCtrl.text = plan.institutionalBranchCount;
      _residentialBranchCountCtrl.text = plan.residentialBranchCount;
      _associateCandidateTargetCtrl.text = plan.associateCandidateTarget;
      _kormiTargetCtrl.text = plan.kormiTarget;
      _associateBranchIncreaseCtrl.text = plan.associateBranchIncrease;
      _zonalBranchIncreaseCtrl.text = plan.zonalBranchIncrease;
      _workerBranchIncreaseCtrl.text = plan.workerBranchIncrease;
      _seniorVisitCountCtrl.text = plan.seniorVisitCount;
      _executiveMeetingCountCtrl.text = plan.executiveMeetingCount;
      _zonalMeetingCountCtrl.text = plan.zonalMeetingCount;
      _memberMeetingCountCtrl.text = plan.memberMeetingCount;
      _associateMeetingCountCtrl.text = plan.associateMeetingCount;
      _workerMeetingCountCtrl.text = plan.workerMeetingCount;
      _generalMeetingCountCtrl.text = plan.generalMeetingCount;
      _discussionMeetingCountCtrl.text = plan.discussionMeetingCount;
      _baytulmalCollectionTargetCtrl.text = plan.baytulmalCollectionTarget;
      _workshopCountCtrl.text = plan.workshopCount;
      _studyTourCountCtrl.text = plan.studyTourCount;
      _groupStudyCountCtrl.text = plan.groupStudyCount;
      _nightStayCountCtrl.text = plan.nightStayCount;
      _zikrMahfilCountCtrl.text = plan.zikrMahfilCount;
      _trainingCircleCountCtrl.text = plan.trainingCircleCount;
      _skillCourseCountCtrl.text = plan.skillCourseCount;
      _quranHadithClassCountCtrl.text = plan.quranHadithClassCount;
      _masailaClassCountCtrl.text = plan.masailaClassCount;
      _openClassCountCtrl.text = plan.openClassCount;
      _libraryBookIncreaseCtrl.text = plan.libraryBookIncrease;
      _zakatCollectionTargetCtrl.text = plan.zakatCollectionTarget;
      _tuitionHelpCountCtrl.text = plan.tuitionHelpCount;
      _hostelHelpCountCtrl.text = plan.hostelHelpCount;
      _coachingClassCountCtrl.text = plan.coachingClassCount;
      _noteBookDistributionCtrl.text = plan.noteBookDistribution;
      _libraryEstablishmentCtrl.text = plan.libraryEstablishment;
      _treePlantationCountCtrl.text = plan.treePlantationCount;
      _bloodDonationBagsCtrl.text = plan.bloodDonationBags;
      _quranTeachingCountCtrl.text = plan.quranTeachingCount;
      _socialWelfareNotesCtrl.text = plan.socialWelfareNotes;
      _totalEstimatedIncomeCtrl.text = plan.totalEstimatedIncome;
      _totalEstimatedExpenseCtrl.text = plan.totalEstimatedExpense;
    } else {
      _clearForm();
    }
    setState(() => _isLoading = false);
  }

  void _clearForm() {
    for (final ctrl in [
      _sessionCtrl, _branchNameCtrl, _friendTargetCtrl, _primaryMemberTargetCtrl,
      _schoolGovtCountCtrl, _schoolNonGovtCountCtrl, _collegeCountCtrl, _madrasaAliaCountCtrl,
      _madrasaQawmiCountCtrl, _universityCountCtrl, _wellWisherCountCtrl, _literatureDistributionCtrl,
      _magazineDistributionCtrl, _posterStickerCountCtrl, _wallWritingCountCtrl, _groupDawahCountCtrl,
      _debateCompetitionCountCtrl, _institutionalBranchCountCtrl, _residentialBranchCountCtrl,
      _associateCandidateTargetCtrl, _kormiTargetCtrl, _associateBranchIncreaseCtrl, _zonalBranchIncreaseCtrl,
      _workerBranchIncreaseCtrl, _seniorVisitCountCtrl, _executiveMeetingCountCtrl, _zonalMeetingCountCtrl,
      _memberMeetingCountCtrl, _associateMeetingCountCtrl, _workerMeetingCountCtrl, _generalMeetingCountCtrl,
      _discussionMeetingCountCtrl, _baytulmalCollectionTargetCtrl, _workshopCountCtrl, _studyTourCountCtrl,
      _groupStudyCountCtrl, _nightStayCountCtrl, _zikrMahfilCountCtrl, _trainingCircleCountCtrl,
      _skillCourseCountCtrl, _quranHadithClassCountCtrl, _masailaClassCountCtrl, _openClassCountCtrl,
      _libraryBookIncreaseCtrl, _zakatCollectionTargetCtrl, _tuitionHelpCountCtrl, _hostelHelpCountCtrl,
      _coachingClassCountCtrl, _noteBookDistributionCtrl, _libraryEstablishmentCtrl, _treePlantationCountCtrl,
      _bloodDonationBagsCtrl, _quranTeachingCountCtrl, _socialWelfareNotesCtrl, _totalEstimatedIncomeCtrl,
      _totalEstimatedExpenseCtrl
    ]) {
      ctrl.clear();
    }
  }

  Future<void> _savePlan() async {
    final plan = ChatroMonthlyPlan(
      year: _selectedYear,
      month: _selectedMonth,
      session: _sessionCtrl.text,
      branchName: _branchNameCtrl.text,
      friendTarget: _friendTargetCtrl.text,
      primaryMemberTarget: _primaryMemberTargetCtrl.text,
      schoolGovtCount: _schoolGovtCountCtrl.text,
      schoolNonGovtCount: _schoolNonGovtCountCtrl.text,
      collegeCount: _collegeCountCtrl.text,
      madrasaAliaCount: _madrasaAliaCountCtrl.text,
      madrasaQawmiCount: _madrasaQawmiCountCtrl.text,
      universityCount: _universityCountCtrl.text,
      wellWisherCount: _wellWisherCountCtrl.text,
      literatureDistribution: _literatureDistributionCtrl.text,
      magazineDistribution: _magazineDistributionCtrl.text,
      posterStickerCount: _posterStickerCountCtrl.text,
      wallWritingCount: _wallWritingCountCtrl.text,
      groupDawahCount: _groupDawahCountCtrl.text,
      debateCompetitionCount: _debateCompetitionCountCtrl.text,
      institutionalBranchCount: _institutionalBranchCountCtrl.text,
      residentialBranchCount: _residentialBranchCountCtrl.text,
      associateCandidateTarget: _associateCandidateTargetCtrl.text,
      kormiTarget: _kormiTargetCtrl.text,
      associateBranchIncrease: _associateBranchIncreaseCtrl.text,
      zonalBranchIncrease: _zonalBranchIncreaseCtrl.text,
      workerBranchIncrease: _workerBranchIncreaseCtrl.text,
      seniorVisitCount: _seniorVisitCountCtrl.text,
      executiveMeetingCount: _executiveMeetingCountCtrl.text,
      zonalMeetingCount: _zonalMeetingCountCtrl.text,
      memberMeetingCount: _memberMeetingCountCtrl.text,
      associateMeetingCount: _associateMeetingCountCtrl.text,
      workerMeetingCount: _workerMeetingCountCtrl.text,
      generalMeetingCount: _generalMeetingCountCtrl.text,
      discussionMeetingCount: _discussionMeetingCountCtrl.text,
      baytulmalCollectionTarget: _baytulmalCollectionTargetCtrl.text,
      workshopCount: _workshopCountCtrl.text,
      studyTourCount: _studyTourCountCtrl.text,
      groupStudyCount: _groupStudyCountCtrl.text,
      nightStayCount: _nightStayCountCtrl.text,
      zikrMahfilCount: _zikrMahfilCountCtrl.text,
      trainingCircleCount: _trainingCircleCountCtrl.text,
      skillCourseCount: _skillCourseCountCtrl.text,
      quranHadithClassCount: _quranHadithClassCountCtrl.text,
      masailaClassCount: _masailaClassCountCtrl.text,
      openClassCount: _openClassCountCtrl.text,
      libraryBookIncrease: _libraryBookIncreaseCtrl.text,
      zakatCollectionTarget: _zakatCollectionTargetCtrl.text,
      tuitionHelpCount: _tuitionHelpCountCtrl.text,
      hostelHelpCount: _hostelHelpCountCtrl.text,
      coachingClassCount: _coachingClassCountCtrl.text,
      noteBookDistribution: _noteBookDistributionCtrl.text,
      libraryEstablishment: _libraryEstablishmentCtrl.text,
      treePlantationCount: _treePlantationCountCtrl.text,
      bloodDonationBags: _bloodDonationBagsCtrl.text,
      quranTeachingCount: _quranTeachingCountCtrl.text,
      socialWelfareNotes: _socialWelfareNotesCtrl.text,
      totalEstimatedIncome: _totalEstimatedIncomeCtrl.text,
      totalEstimatedExpense: _totalEstimatedExpenseCtrl.text,
    );

    await ReportStorageService.saveChatroMonthlyPlan(plan);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ছাত্র মজলিস মাসিক পরিকল্পনা সফলভাবে সংরক্ষিত হয়েছে!'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;
        final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
        final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? Colors.white : AppTheme.textDark;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'মাসিক পরিকল্পনা রিপোর্ট (${_months[_selectedMonth - 1]} $_selectedYear)',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade400),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => themeManager.toggleTheme(),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Year & Month Bar
                      _buildMonthYearBar(isDark, cardBg, textColor),
                      const SizedBox(height: 16),

                      // Section 1: ১ম দফা: দাওয়াত
                      _buildSectionCard(
                        title: 'প্রথম দফা : দাওয়াত',
                        icon: Icons.campaign_outlined,
                        color: Colors.blue,
                        isDark: isDark,
                        cardBg: cardBg,
                        children: [
                          _field('বন্ধু বৃদ্ধি (জন)', _friendTargetCtrl, isDark),
                          _field('প্রাথমিক সদস্য বৃদ্ধি (জন)', _primaryMemberTargetCtrl, isDark),
                          Row(
                            children: [
                              Expanded(child: _field('স্কুল সরকারি', _schoolGovtCountCtrl, isDark)),
                              const SizedBox(width: 8),
                              Expanded(child: _field('স্কুল বেসরকারি', _schoolNonGovtCountCtrl, isDark)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: _field('কলেজ', _collegeCountCtrl, isDark)),
                              const SizedBox(width: 8),
                              Expanded(child: _field('বিশ্ববিদ্যালয়', _universityCountCtrl, isDark)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: _field('মাদ্রাসা আলিয়া', _madrasaAliaCountCtrl, isDark)),
                              const SizedBox(width: 8),
                              Expanded(child: _field('মাদ্রাসা কওমী', _madrasaQawmiCountCtrl, isDark)),
                            ],
                          ),
                          _field('শুভাকাঙ্ক্ষী বৃদ্ধি/যোগাযোগ (জন)', _wellWisherCountCtrl, isDark),
                          _field('পরিচিতি / ইসলামী সাহিত্য বিতরণ (টি)', _literatureDistributionCtrl, isDark),
                          _field('ছাত্র পরিক্রমা / কিশোর পত্রিকা (টি)', _magazineDistributionCtrl, isDark),
                          _field('লিফলেট / স্টিকার / পোস্টার (টি)', _posterStickerCountCtrl, isDark),
                          _field('দেয়াল লিখন / নবীন বরণ (টি)', _wallWritingCountCtrl, isDark),
                          _field('গ্রুপ দাওয়াত / চা চক্র (টি)', _groupDawahCountCtrl, isDark),
                          _field('বক্তৃতা / বিতর্ক প্রতিযোগিতা (টি)', _debateCompetitionCountCtrl, isDark),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Section 2: ২য় দফা: সংগঠন
                      _buildSectionCard(
                        title: 'দ্বিতীয় দফা : সংগঠন',
                        icon: Icons.groups_outlined,
                        color: const Color(0xFF10B981),
                        isDark: isDark,
                        cardBg: cardBg,
                        children: [
                          _field('সহযোগী সদস্য প্রার্থী টার্গেট (জন/নাম)', _associateCandidateTargetCtrl, isDark),
                          _field('কর্মী বৃদ্ধি টার্গেট (জন)', _kormiTargetCtrl, isDark),
                          _field('সহযোগী সদস্য শাখা বৃদ্ধি (টি/নাম)', _associateBranchIncreaseCtrl, isDark),
                          _field('থানা / জোন শাখা বৃদ্ধি (টি/নাম)', _zonalBranchIncreaseCtrl, isDark),
                          _field('কর্মী শাখা বৃদ্ধি (টি)', _workerBranchIncreaseCtrl, isDark),
                          _field('ঊর্ধ্বতন সফর আনা হবে (টি/তারিখ)', _seniorVisitCountCtrl, isDark),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Section 3: ৩য় দফা: সভাসমূহ
                      _buildSectionCard(
                        title: 'সভাসমূহ',
                        icon: Icons.event_note_outlined,
                        color: Colors.purple,
                        isDark: isDark,
                        cardBg: cardBg,
                        children: [
                          _field('দায়িত্বশীল সভা (টি, তারিখ ও সময়)', _executiveMeetingCountCtrl, isDark),
                          _field('জোনাল দায়িত্বশীল সভা (টি, তারিখ ও সময়)', _zonalMeetingCountCtrl, isDark),
                          _field('সদস্য সভা (টি, তারিখ ও সময়)', _memberMeetingCountCtrl, isDark),
                          _field('সহযোগী সদস্য সভা (টি, তারিখ ও সময়)', _associateMeetingCountCtrl, isDark),
                          _field('কর্মী সভা (টি, তারিখ ও সময়)', _workerMeetingCountCtrl, isDark),
                          _field('সাধারণ সভা (টি, তারিখ ও সময়)', _generalMeetingCountCtrl, isDark),
                          _field('আলোচনা সভা (টি, তারিখ ও সময়)', _discussionMeetingCountCtrl, isDark),
                          _field('বায়তুলমাল সংগ্রহ করা হবে (টাকা)', _baytulmalCollectionTargetCtrl, isDark),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Section 4: ৪র্থ দফা: প্রশিক্ষণ
                      _buildSectionCard(
                        title: 'তৃতীয় দফা : প্রশিক্ষণ',
                        icon: Icons.school_outlined,
                        color: Colors.amber.shade800,
                        isDark: isDark,
                        cardBg: cardBg,
                        children: [
                          _field('কর্মশালা (টি/তারিখ)', _workshopCountCtrl, isDark),
                          _field('শিক্ষা সফর (টি/তারিখ)', _studyTourCountCtrl, isDark),
                          _field('সমষ্টিগত অধ্যয়ন (অধিবেশন)', _groupStudyCountCtrl, isDark),
                          _field('শবগুজারী (টি/তারিখ)', _nightStayCountCtrl, isDark),
                          _field('জিকির মাহফিল (টি/তারিখ)', _zikrMahfilCountCtrl, isDark),
                          _field('প্রশিক্ষণ চক্র (অধিবেশন/তারিখ)', _trainingCircleCountCtrl, isDark),
                          _field('স্কিলস ডেভেলপমেন্ট কোর্স (টি)', _skillCourseCountCtrl, isDark),
                          _field('কুরআন ও হাদিস শিক্ষা ক্লাস (টি)', _quranHadithClassCountCtrl, isDark),
                          _field('পাঠাগার বৃদ্ধি (বই)', _libraryBookIncreaseCtrl, isDark),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Section 5: ৫ম দফা: আন্দোলন ও ছাত্রকল্যাণ
                      _buildSectionCard(
                        title: 'চতুর্থ দফা : আন্দোলন ও ছাত্রকল্যাণ',
                        icon: Icons.front_hand_outlined,
                        color: Colors.indigo,
                        isDark: isDark,
                        cardBg: cardBg,
                        children: [
                          _field('যাকাত সংগ্রহ টার্গেট (টাকা)', _zakatCollectionTargetCtrl, isDark),
                          _field('লজিং / টিউশনি সংগ্রহ (টি)', _tuitionHelpCountCtrl, isDark),
                          _field('আবাসন ব্যবস্থা করা হবে (জন)', _hostelHelpCountCtrl, isDark),
                          _field('একাডেমিক / ভর্তি কোচিং (টি)', _coachingClassCountCtrl, isDark),
                          _field('প্রশ্নপত্র / সাজেশন বিতরণ (টি)', _noteBookDistributionCtrl, isDark),
                          _field('লাইব্রেরী প্রতিষ্ঠা (টি)', _libraryEstablishmentCtrl, isDark),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Section 6: সামাজিক খেদমত
                      _buildSectionCard(
                        title: 'সামাজিক খেদমত',
                        icon: Icons.volunteer_activism_outlined,
                        color: Colors.teal,
                        isDark: isDark,
                        cardBg: cardBg,
                        children: [
                          _field('গাছ লাগানো হবে (টি)', _treePlantationCountCtrl, isDark),
                          _field('রক্তদান করা হবে (ব্যাগ)', _bloodDonationBagsCtrl, isDark),
                          _field('সাধারণ মানুষের জন্য কুরআন শিক্ষা (জন)', _quranTeachingCountCtrl, isDark),
                          _field('অন্যান্য সামাজিক খেদমত কার্যক্রম', _socialWelfareNotesCtrl, isDark),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Section 7: বায়তুলমাল বাজেট
                      _buildSectionCard(
                        title: 'বায়তুলমাল বাজেট',
                        icon: Icons.account_balance_outlined,
                        color: Colors.orange,
                        isDark: isDark,
                        cardBg: cardBg,
                        children: [
                          _field('মোট সম্ভাব্য আয় (টাকা)', _totalEstimatedIncomeCtrl, isDark),
                          _field('মোট সম্ভাব্য ব্যয় (টাকা)', _totalEstimatedExpenseCtrl, isDark),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _savePlan,
                          icon: const Icon(Icons.save_rounded, color: Colors.white),
                          label: const Text(
                            'পরিকল্পনা সংরক্ষণ করুন',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildMonthYearBar(bool isDark, Color cardBg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: _selectedMonth,
                dropdownColor: cardBg,
                underline: const SizedBox(),
                items: List.generate(12, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text(_months[index], style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                  );
                }),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedMonth = val);
                    _loadPlan();
                  }
                },
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() => _selectedYear--);
                  _loadPlan();
                },
              ),
              Text('$_selectedYear', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() => _selectedYear++);
                  _loadPlan();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool isDark,
    required Color cardBg,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.textDark,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700, fontSize: 13),
          filled: true,
          fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
