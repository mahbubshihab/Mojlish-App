import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/features/common/reports/personal_report/data/models/chatro_monthly_plan.dart';
import 'package:mojlish_app/features/common/reports/shared/data/services/pdf_generator_service.dart';
import '../bloc/period_plan_bloc.dart';
import '../bloc/period_plan_event.dart';
import '../bloc/period_plan_state.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস — বার্ষিক/ষাণ্মাসিক/দ্বি-মাসিক/মাসিক পরিকল্পনা স্ক্রিন
class StudentPeriodPlanScreen extends StatefulWidget {
  final int? initialYear;
  final int? initialMonth;

  const StudentPeriodPlanScreen({
    super.key,
    this.initialYear,
    this.initialMonth,
  });

  @override
  State<StudentPeriodPlanScreen> createState() => _StudentPeriodPlanScreenState();
}

class _StudentPeriodPlanScreenState extends State<StudentPeriodPlanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _selectedYear;
  late int _selectedMonth;
  String _selectedPlanType = 'মাসিক';

  // Form Controllers
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
  final _literatureDist1Ctrl = TextEditingController();
  final _literatureDist2Ctrl = TextEditingController();
  final _magazineDist1Ctrl = TextEditingController();
  final _magazineDist2Ctrl = TextEditingController();
  final _posterSticker1Ctrl = TextEditingController();
  final _posterSticker2Ctrl = TextEditingController();
  final _posterSticker3Ctrl = TextEditingController();
  final _wallWriting1Ctrl = TextEditingController();
  final _wallWriting2Ctrl = TextEditingController();
  final _wallWriting3Ctrl = TextEditingController();
  final _groupDawah1Ctrl = TextEditingController();
  final _groupDawah2Ctrl = TextEditingController();
  final _groupDawah3Ctrl = TextEditingController();
  final _debateComp1Ctrl = TextEditingController();
  final _debateComp2Ctrl = TextEditingController();
  final _debateComp3Ctrl = TextEditingController();
  final _otherDawahCtrl = TextEditingController();
  final _workIncreaseInstCtrl = TextEditingController();
  final _workIncreaseResCtrl = TextEditingController();
  final _workIncreaseNameCtrl = TextEditingController();
  final _primaryBranchIncreaseInstCtrl = TextEditingController();
  final _primaryBranchIncreaseResCtrl = TextEditingController();
  final _primaryBranchIncreaseNameCtrl = TextEditingController();

  // ২য় দফা: সংগঠন
  final _associateCandidateTargetCtrl = TextEditingController();
  final _associateCandidateNamesCtrl = TextEditingController();
  final _kormiTargetCtrl = TextEditingController();
  final _kormiSchoolGovtCtrl = TextEditingController();
  final _kormiSchoolNonGovtCtrl = TextEditingController();
  final _kormiCollegeCtrl = TextEditingController();
  final _kormiMadrasaAliaCtrl = TextEditingController();
  final _kormiMadrasaQawmiCtrl = TextEditingController();
  final _kormiUniversityCtrl = TextEditingController();
  final _associateBranchIncreaseCtrl = TextEditingController();
  final _associateBranchNamesCtrl = TextEditingController();
  final _zonalBranchIncreaseCtrl = TextEditingController();
  final _zonalBranchNamesCtrl = TextEditingController();
  final _workerBranchIncreaseCtrl = TextEditingController();
  final _workerBranchInstCtrl = TextEditingController();
  final _workerBranchResCtrl = TextEditingController();
  final _workerBranchNamesCtrl = TextEditingController();
  final _seniorVisitCountCtrl = TextEditingController();
  final _seniorVisitDateCtrl = TextEditingController();

  // সভাসমূহ (Meetings)
  final _execMeetingCountCtrl = TextEditingController();
  final _execMeetingDateTimeCtrl = TextEditingController();
  final _zonalMeetingCountCtrl = TextEditingController();
  final _zonalMeetingDateTimeCtrl = TextEditingController();
  final _memberMeetingCountCtrl = TextEditingController();
  final _memberMeetingDateTimeCtrl = TextEditingController();
  final _assocMeetingCountCtrl = TextEditingController();
  final _assocMeetingDateTimeCtrl = TextEditingController();
  final _workerMeetingCountCtrl = TextEditingController();
  final _workerMeetingDateTimeCtrl = TextEditingController();
  final _generalMeetingCountCtrl = TextEditingController();
  final _generalMeetingDateTimeCtrl = TextEditingController();
  final _discussionMeetingCountCtrl = TextEditingController();
  final _discussionMeetingDateTimeCtrl = TextEditingController();
  final _otherMeetingsCtrl = TextEditingController();
  final _baytulmalCollectionTargetCtrl = TextEditingController();

  // ৩য় দফা: প্রশিক্ষণ
  final _workshopCountCtrl = TextEditingController();
  final _workshopDateCtrl = TextEditingController();
  final _workshopTimeCtrl = TextEditingController();
  final _workshopVenueCtrl = TextEditingController();

  final _studyTourCountCtrl = TextEditingController();
  final _studyTourDateCtrl = TextEditingController();
  final _studyTourTimeCtrl = TextEditingController();
  final _studyTourVenueCtrl = TextEditingController();

  final _groupStudyCountCtrl = TextEditingController();
  final _groupStudySessionsCtrl = TextEditingController();

  final _shabguzariCountCtrl = TextEditingController();
  final _shabguzariDateCtrl = TextEditingController();
  final _shabguzariTimeCtrl = TextEditingController();
  final _shabguzariVenueCtrl = TextEditingController();

  final _zikrMahfilCountCtrl = TextEditingController();
  final _zikrMahfilDateCtrl = TextEditingController();
  final _zikrMahfilTimeCtrl = TextEditingController();
  final _zikrMahfilVenueCtrl = TextEditingController();

  final _trainingCircleCountCtrl = TextEditingController();
  final _trainingCircleSessionsCtrl = TextEditingController();
  final _trainingCircleDateCtrl = TextEditingController();

  final _skillCourseCountCtrl = TextEditingController();
  final _skillCourseSessionsCtrl = TextEditingController();
  final _skillCourseDateCtrl = TextEditingController();

  final _tarbiayatiTourCountCtrl = TextEditingController();
  final _tarbiayatiTourDateCtrl = TextEditingController();
  final _tarbiayatiTourTimeCtrl = TextEditingController();
  final _tarbiayatiTourVenueCtrl = TextEditingController();

  final _quranHadithClassCountCtrl = TextEditingController();
  final _quranHadithClassSessionsCtrl = TextEditingController();

  final _masailaClassCountCtrl = TextEditingController();
  final _masailaClassSessionsCtrl = TextEditingController();

  final _openClassCountCtrl = TextEditingController();
  final _openClassSessionsCtrl = TextEditingController();

  final _culturalForumCountCtrl = TextEditingController();
  final _culturalForumSessionsCtrl = TextEditingController();

  final _libraryIncreaseCountCtrl = TextEditingController();
  final _libraryBookIncreaseCtrl = TextEditingController();

  // ৪র্থ দফা: আন্দোলন ও ছাত্রকল্যাণ
  final _zakatCollectionTargetCtrl = TextEditingController();
  final _tableBankIncreaseCtrl = TextEditingController();
  final _tuitionHelp1Ctrl = TextEditingController();
  final _tuitionHelp2Ctrl = TextEditingController();
  final _stipendStartedCtrl = TextEditingController();
  final _hostelHelpCountCtrl = TextEditingController();
  final _freeCoachingCountCtrl = TextEditingController();
  final _coachingClass1Ctrl = TextEditingController();
  final _coachingClass2Ctrl = TextEditingController();
  final _noteBookDist1Ctrl = TextEditingController();
  final _noteBookDist2Ctrl = TextEditingController();
  final _noteBookDist3Ctrl = TextEditingController();
  final _libraryEstablishmentCtrl = TextEditingController();
  final _libraryEstBookIncreaseCtrl = TextEditingController();
  final _admissionGuide1Ctrl = TextEditingController();
  final _admissionGuide2Ctrl = TextEditingController();
  final _admissionHelpStudentCountCtrl = TextEditingController();

  // সামাজিক খেদমত
  final _treePlantationCountCtrl = TextEditingController();
  final _bloodDonationBagsCtrl = TextEditingController();
  final _quranTeachingPublicCtrl = TextEditingController();
  final _antiAddictionAwarenessCtrl = TextEditingController();
  final _khedmateKholokMotivationCtrl = TextEditingController();
  final _publicOpinionAgainstOppressionCtrl = TextEditingController();
  final _bloodDonationProgramCtrl = TextEditingController();
  final _khelafatMajlisAssistanceCtrl = TextEditingController();
  final _cleanlinessCampaignCtrl = TextEditingController();
  final _dawahToMahramsCtrl = TextEditingController();
  final _disasterReliefCtrl = TextEditingController();
  final _freeHealthCareProgramCtrl = TextEditingController();

  // বায়তুলমাল বাজেট
  final _incomeManpowerIyanatCtrl = TextEditingController();
  final _incomeBranchIyanatCtrl = TextEditingController();
  final _incomeWellWisherIyanatCtrl = TextEditingController();
  final _incomeOneTimeCtrl = TextEditingController();
  final _incomeCustom5Ctrl = TextEditingController();
  final _incomeCustom6Ctrl = TextEditingController();

  final _expenseUpperIyanatCtrl = TextEditingController();
  final _expenseUpperTourCtrl = TextEditingController();
  final _expenseOfficeCtrl = TextEditingController();
  final _expenseTravelCtrl = TextEditingController();
  final _expenseCommunicationCtrl = TextEditingController();
  final _expensePublicityCtrl = TextEditingController();

  final _totalIncomeCtrl = TextEditingController();
  final _totalExpenseCtrl = TextEditingController();

  static const _planTypes = ['মাসিক', 'দ্বি-মাসিক', 'ষাণ্মাসিক', 'বার্ষিক'];
  static const _months = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    final now = DateTime.now();
    _selectedYear = widget.initialYear ?? now.year;
    _selectedMonth = widget.initialMonth ?? now.month;

    // Attach budget calculation listeners
    for (final ctrl in [
      _incomeManpowerIyanatCtrl, _incomeBranchIyanatCtrl, _incomeWellWisherIyanatCtrl,
      _incomeOneTimeCtrl, _incomeCustom5Ctrl, _incomeCustom6Ctrl
    ]) {
      ctrl.addListener(_calculateTotals);
    }
    for (final ctrl in [
      _expenseUpperIyanatCtrl, _expenseUpperTourCtrl, _expenseOfficeCtrl,
      _expenseTravelCtrl, _expenseCommunicationCtrl, _expensePublicityCtrl
    ]) {
      ctrl.addListener(_calculateTotals);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _calculateTotals() {
    double totalInc = 0;
    for (final ctrl in [
      _incomeManpowerIyanatCtrl, _incomeBranchIyanatCtrl, _incomeWellWisherIyanatCtrl,
      _incomeOneTimeCtrl, _incomeCustom5Ctrl, _incomeCustom6Ctrl
    ]) {
      if (ctrl.text.isNotEmpty) {
        totalInc += double.tryParse(ctrl.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      }
    }

    double totalExp = 0;
    for (final ctrl in [
      _expenseUpperIyanatCtrl, _expenseUpperTourCtrl, _expenseOfficeCtrl,
      _expenseTravelCtrl, _expenseCommunicationCtrl, _expensePublicityCtrl
    ]) {
      if (ctrl.text.isNotEmpty) {
        totalExp += double.tryParse(ctrl.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      }
    }

    _totalIncomeCtrl.text = totalInc > 0 ? totalInc.toStringAsFixed(0) : '';
    _totalExpenseCtrl.text = totalExp > 0 ? totalExp.toStringAsFixed(0) : '';
  }

  void _populateForm(ChatroMonthlyPlan? plan) {
    if (plan == null) {
      _clearAllFields();
      return;
    }

    _selectedPlanType = plan.planType.isNotEmpty ? plan.planType : 'মাসিক';
    _sessionCtrl.text = plan.session;
    _branchNameCtrl.text = plan.branchName;

    // ১ম দফা
    _friendTargetCtrl.text = plan.friendTarget;
    _primaryMemberTargetCtrl.text = plan.primaryMemberTarget;
    _schoolGovtCountCtrl.text = plan.schoolGovtCount;
    _schoolNonGovtCountCtrl.text = plan.schoolNonGovtCount;
    _collegeCountCtrl.text = plan.collegeCount;
    _madrasaAliaCountCtrl.text = plan.madrasaAliaCount;
    _madrasaQawmiCountCtrl.text = plan.madrasaQawmiCount;
    _universityCountCtrl.text = plan.universityCount;
    _wellWisherCountCtrl.text = plan.wellWisherCount;
    _literatureDist1Ctrl.text = plan.literatureDistribution1;
    _literatureDist2Ctrl.text = plan.literatureDistribution2;
    _magazineDist1Ctrl.text = plan.magazineDistribution1;
    _magazineDist2Ctrl.text = plan.magazineDistribution2;
    _posterSticker1Ctrl.text = plan.posterStickerCount1;
    _posterSticker2Ctrl.text = plan.posterStickerCount2;
    _posterSticker3Ctrl.text = plan.posterStickerCount3;
    _wallWriting1Ctrl.text = plan.wallWritingCount1;
    _wallWriting2Ctrl.text = plan.wallWritingCount2;
    _wallWriting3Ctrl.text = plan.wallWritingCount3;
    _groupDawah1Ctrl.text = plan.groupDawahCount1;
    _groupDawah2Ctrl.text = plan.groupDawahCount2;
    _groupDawah3Ctrl.text = plan.groupDawahCount3;
    _debateComp1Ctrl.text = plan.debateCompetitionCount1;
    _debateComp2Ctrl.text = plan.debateCompetitionCount2;
    _debateComp3Ctrl.text = plan.debateCompetitionCount3;
    _otherDawahCtrl.text = plan.otherDawahActivities;
    _workIncreaseInstCtrl.text = plan.workIncreaseInst;
    _workIncreaseResCtrl.text = plan.workIncreaseRes;
    _workIncreaseNameCtrl.text = plan.workIncreaseName;
    _primaryBranchIncreaseInstCtrl.text = plan.primaryBranchIncreaseInst;
    _primaryBranchIncreaseResCtrl.text = plan.primaryBranchIncreaseRes;
    _primaryBranchIncreaseNameCtrl.text = plan.primaryBranchIncreaseName;

    // ২য় দফা
    _associateCandidateTargetCtrl.text = plan.associateCandidateTarget;
    _associateCandidateNamesCtrl.text = plan.associateCandidateNames;
    _kormiTargetCtrl.text = plan.kormiTarget;
    _kormiSchoolGovtCtrl.text = plan.kormiSchoolGovt;
    _kormiSchoolNonGovtCtrl.text = plan.kormiSchoolNonGovt;
    _kormiCollegeCtrl.text = plan.kormiCollege;
    _kormiMadrasaAliaCtrl.text = plan.kormiMadrasaAlia;
    _kormiMadrasaQawmiCtrl.text = plan.kormiMadrasaQawmi;
    _kormiUniversityCtrl.text = plan.kormiUniversity;
    _associateBranchIncreaseCtrl.text = plan.associateBranchIncrease;
    _associateBranchNamesCtrl.text = plan.associateBranchNames;
    _zonalBranchIncreaseCtrl.text = plan.zonalBranchIncrease;
    _zonalBranchNamesCtrl.text = plan.zonalBranchNames;
    _workerBranchIncreaseCtrl.text = plan.workerBranchIncrease;
    _workerBranchInstCtrl.text = plan.workerBranchInst;
    _workerBranchResCtrl.text = plan.workerBranchRes;
    _workerBranchNamesCtrl.text = plan.workerBranchNames;
    _seniorVisitCountCtrl.text = plan.seniorVisitCount;
    _seniorVisitDateCtrl.text = plan.seniorVisitDate;

    // সভাসমূহ
    _execMeetingCountCtrl.text = plan.executiveMeetingCount;
    _execMeetingDateTimeCtrl.text = plan.executiveMeetingDateTime;
    _zonalMeetingCountCtrl.text = plan.zonalMeetingCount;
    _zonalMeetingDateTimeCtrl.text = plan.zonalMeetingDateTime;
    _memberMeetingCountCtrl.text = plan.memberMeetingCount;
    _memberMeetingDateTimeCtrl.text = plan.memberMeetingDateTime;
    _assocMeetingCountCtrl.text = plan.associateMeetingCount;
    _assocMeetingDateTimeCtrl.text = plan.associateMeetingDateTime;
    _workerMeetingCountCtrl.text = plan.workerMeetingCount;
    _workerMeetingDateTimeCtrl.text = plan.workerMeetingDateTime;
    _generalMeetingCountCtrl.text = plan.generalMeetingCount;
    _generalMeetingDateTimeCtrl.text = plan.generalMeetingDateTime;
    _discussionMeetingCountCtrl.text = plan.discussionMeetingCount;
    _discussionMeetingDateTimeCtrl.text = plan.discussionMeetingDateTime;
    _otherMeetingsCtrl.text = plan.otherMeetings;
    _baytulmalCollectionTargetCtrl.text = plan.baytulmalCollectionTarget;

    // ৩য় দফা
    _workshopCountCtrl.text = plan.workshopCount;
    _workshopDateCtrl.text = plan.workshopDate;
    _workshopTimeCtrl.text = plan.workshopTime;
    _workshopVenueCtrl.text = plan.workshopVenue;
    _studyTourCountCtrl.text = plan.studyTourCount;
    _studyTourDateCtrl.text = plan.studyTourDate;
    _studyTourTimeCtrl.text = plan.studyTourTime;
    _studyTourVenueCtrl.text = plan.studyTourVenue;
    _groupStudyCountCtrl.text = plan.groupStudyCount;
    _groupStudySessionsCtrl.text = plan.groupStudySessions;
    _shabguzariCountCtrl.text = plan.shabguzariCount;
    _shabguzariDateCtrl.text = plan.shabguzariDate;
    _shabguzariTimeCtrl.text = plan.shabguzariTime;
    _shabguzariVenueCtrl.text = plan.shabguzariVenue;
    _zikrMahfilCountCtrl.text = plan.zikrMahfilCount;
    _zikrMahfilDateCtrl.text = plan.zikrMahfilDate;
    _zikrMahfilTimeCtrl.text = plan.zikrMahfilTime;
    _zikrMahfilVenueCtrl.text = plan.zikrMahfilVenue;
    _trainingCircleCountCtrl.text = plan.trainingCircleCount;
    _trainingCircleSessionsCtrl.text = plan.trainingCircleSessions;
    _trainingCircleDateCtrl.text = plan.trainingCircleDate;
    _skillCourseCountCtrl.text = plan.skillCourseCount;
    _skillCourseSessionsCtrl.text = plan.skillCourseSessions;
    _skillCourseDateCtrl.text = plan.skillCourseDate;
    _tarbiayatiTourCountCtrl.text = plan.tarbiayatiTourCount;
    _tarbiayatiTourDateCtrl.text = plan.tarbiayatiTourDate;
    _tarbiayatiTourTimeCtrl.text = plan.tarbiayatiTourTime;
    _tarbiayatiTourVenueCtrl.text = plan.tarbiayatiTourVenue;
    _quranHadithClassCountCtrl.text = plan.quranHadithClassCount;
    _quranHadithClassSessionsCtrl.text = plan.quranHadithClassSessions;
    _masailaClassCountCtrl.text = plan.masailaClassCount;
    _masailaClassSessionsCtrl.text = plan.masailaClassSessions;
    _openClassCountCtrl.text = plan.openClassCount;
    _openClassSessionsCtrl.text = plan.openClassSessions;
    _culturalForumCountCtrl.text = plan.culturalForumCount;
    _culturalForumSessionsCtrl.text = plan.culturalForumSessions;
    _libraryIncreaseCountCtrl.text = plan.libraryIncreaseCount;
    _libraryBookIncreaseCtrl.text = plan.libraryBookIncrease;

    // ৪র্থ দফা
    _zakatCollectionTargetCtrl.text = plan.zakatCollectionTarget;
    _tableBankIncreaseCtrl.text = plan.tableBankIncrease;
    _tuitionHelp1Ctrl.text = plan.tuitionHelpCount1;
    _tuitionHelp2Ctrl.text = plan.tuitionHelpCount2;
    _stipendStartedCtrl.text = plan.stipendStartedCount;
    _hostelHelpCountCtrl.text = plan.hostelHelpCount;
    _freeCoachingCountCtrl.text = plan.freeCoachingCount;
    _coachingClass1Ctrl.text = plan.coachingClassCount1;
    _coachingClass2Ctrl.text = plan.coachingClassCount2;
    _noteBookDist1Ctrl.text = plan.noteBookDistribution1;
    _noteBookDist2Ctrl.text = plan.noteBookDistribution2;
    _noteBookDist3Ctrl.text = plan.noteBookDistribution3;
    _libraryEstablishmentCtrl.text = plan.libraryEstablishment;
    _libraryEstBookIncreaseCtrl.text = plan.libraryEstBookIncrease;
    _admissionGuide1Ctrl.text = plan.admissionGuideCount1;
    _admissionGuide2Ctrl.text = plan.admissionGuideCount2;
    _admissionHelpStudentCountCtrl.text = plan.admissionHelpStudentCount;

    _treePlantationCountCtrl.text = plan.treePlantationCount;
    _bloodDonationBagsCtrl.text = plan.bloodDonationBags;
    _quranTeachingPublicCtrl.text = plan.quranTeachingPublic;
    _antiAddictionAwarenessCtrl.text = plan.antiAddictionAwareness;
    _khedmateKholokMotivationCtrl.text = plan.khedmateKholokMotivation;
    _publicOpinionAgainstOppressionCtrl.text = plan.publicOpinionAgainstOppression;
    _bloodDonationProgramCtrl.text = plan.bloodDonationProgram;
    _khelafatMajlisAssistanceCtrl.text = plan.khelafatMajlisAssistance;
    _cleanlinessCampaignCtrl.text = plan.cleanlinessCampaign;
    _dawahToMahramsCtrl.text = plan.dawahToMahrams;
    _disasterReliefCtrl.text = plan.disasterRelief;
    _freeHealthCareProgramCtrl.text = plan.freeHealthCareProgram;

    // বায়তুলমাল
    _incomeManpowerIyanatCtrl.text = plan.incomeManpowerIyanat;
    _incomeBranchIyanatCtrl.text = plan.incomeBranchIyanat;
    _incomeWellWisherIyanatCtrl.text = plan.incomeWellWisherIyanat;
    _incomeOneTimeCtrl.text = plan.incomeOneTime;
    _incomeCustom5Ctrl.text = plan.incomeCustom5;
    _incomeCustom6Ctrl.text = plan.incomeCustom6;

    _expenseUpperIyanatCtrl.text = plan.expenseUpperIyanat;
    _expenseUpperTourCtrl.text = plan.expenseUpperTour;
    _expenseOfficeCtrl.text = plan.expenseOffice;
    _expenseTravelCtrl.text = plan.expenseTravel;
    _expenseCommunicationCtrl.text = plan.expenseCommunication;
    _expensePublicityCtrl.text = plan.expensePublicity;

    _totalIncomeCtrl.text = plan.totalEstimatedIncome;
    _totalExpenseCtrl.text = plan.totalEstimatedExpense;
  }

  void _clearAllFields() {
    for (final ctrl in [
      _sessionCtrl, _branchNameCtrl, _friendTargetCtrl, _primaryMemberTargetCtrl,
      _schoolGovtCountCtrl, _schoolNonGovtCountCtrl, _collegeCountCtrl, _madrasaAliaCountCtrl,
      _madrasaQawmiCountCtrl, _universityCountCtrl, _wellWisherCountCtrl, _literatureDist1Ctrl,
      _literatureDist2Ctrl, _magazineDist1Ctrl, _magazineDist2Ctrl, _posterSticker1Ctrl,
      _posterSticker2Ctrl, _posterSticker3Ctrl, _wallWriting1Ctrl, _wallWriting2Ctrl,
      _wallWriting3Ctrl, _groupDawah1Ctrl, _groupDawah2Ctrl, _groupDawah3Ctrl,
      _debateComp1Ctrl, _debateComp2Ctrl, _debateComp3Ctrl, _otherDawahCtrl,
      _workIncreaseInstCtrl, _workIncreaseResCtrl, _workIncreaseNameCtrl,
      _primaryBranchIncreaseInstCtrl, _primaryBranchIncreaseResCtrl, _primaryBranchIncreaseNameCtrl,
      _associateCandidateTargetCtrl, _associateCandidateNamesCtrl, _kormiTargetCtrl,
      _kormiSchoolGovtCtrl, _kormiSchoolNonGovtCtrl, _kormiCollegeCtrl, _kormiMadrasaAliaCtrl,
      _kormiMadrasaQawmiCtrl, _kormiUniversityCtrl, _associateBranchIncreaseCtrl,
      _associateBranchNamesCtrl, _zonalBranchIncreaseCtrl, _zonalBranchNamesCtrl,
      _workerBranchIncreaseCtrl, _workerBranchInstCtrl, _workerBranchResCtrl,
      _workerBranchNamesCtrl, _seniorVisitCountCtrl, _seniorVisitDateCtrl,
      _execMeetingCountCtrl, _execMeetingDateTimeCtrl, _zonalMeetingCountCtrl,
      _zonalMeetingDateTimeCtrl, _memberMeetingCountCtrl, _memberMeetingDateTimeCtrl,
      _assocMeetingCountCtrl, _assocMeetingDateTimeCtrl, _workerMeetingCountCtrl,
      _workerMeetingDateTimeCtrl, _generalMeetingCountCtrl, _generalMeetingDateTimeCtrl,
      _discussionMeetingCountCtrl, _discussionMeetingDateTimeCtrl, _otherMeetingsCtrl,
      _baytulmalCollectionTargetCtrl, _workshopCountCtrl, _workshopDateCtrl,
      _workshopTimeCtrl, _workshopVenueCtrl, _studyTourCountCtrl, _studyTourDateCtrl,
      _studyTourTimeCtrl, _studyTourVenueCtrl, _groupStudyCountCtrl, _groupStudySessionsCtrl,
      _shabguzariCountCtrl, _shabguzariDateCtrl, _shabguzariTimeCtrl, _shabguzariVenueCtrl,
      _zikrMahfilCountCtrl, _zikrMahfilDateCtrl, _zikrMahfilTimeCtrl, _zikrMahfilVenueCtrl,
      _trainingCircleCountCtrl, _trainingCircleSessionsCtrl, _trainingCircleDateCtrl,
      _skillCourseCountCtrl, _skillCourseSessionsCtrl, _skillCourseDateCtrl,
      _tarbiayatiTourCountCtrl, _tarbiayatiTourDateCtrl, _tarbiayatiTourTimeCtrl,
      _tarbiayatiTourVenueCtrl, _quranHadithClassCountCtrl, _quranHadithClassSessionsCtrl,
      _masailaClassCountCtrl, _masailaClassSessionsCtrl, _openClassCountCtrl,
      _openClassSessionsCtrl, _culturalForumCountCtrl, _culturalForumSessionsCtrl,
      _libraryIncreaseCountCtrl, _libraryBookIncreaseCtrl, _zakatCollectionTargetCtrl,
      _tableBankIncreaseCtrl, _tuitionHelp1Ctrl, _tuitionHelp2Ctrl, _stipendStartedCtrl,
      _hostelHelpCountCtrl, _freeCoachingCountCtrl, _coachingClass1Ctrl, _coachingClass2Ctrl,
      _noteBookDist1Ctrl, _noteBookDist2Ctrl, _noteBookDist3Ctrl, _libraryEstablishmentCtrl,
      _libraryEstBookIncreaseCtrl, _admissionGuide1Ctrl, _admissionGuide2Ctrl,
      _admissionHelpStudentCountCtrl, _treePlantationCountCtrl, _bloodDonationBagsCtrl,
      _quranTeachingPublicCtrl, _antiAddictionAwarenessCtrl, _khedmateKholokMotivationCtrl,
      _publicOpinionAgainstOppressionCtrl, _bloodDonationProgramCtrl, _khelafatMajlisAssistanceCtrl,
      _cleanlinessCampaignCtrl, _dawahToMahramsCtrl, _disasterReliefCtrl,
      _freeHealthCareProgramCtrl, _incomeManpowerIyanatCtrl, _incomeBranchIyanatCtrl,
      _incomeWellWisherIyanatCtrl, _incomeOneTimeCtrl, _incomeCustom5Ctrl,
      _incomeCustom6Ctrl, _expenseUpperIyanatCtrl, _expenseUpperTourCtrl,
      _expenseOfficeCtrl, _expenseTravelCtrl, _expenseCommunicationCtrl, _expensePublicityCtrl,
      _totalIncomeCtrl, _totalExpenseCtrl
    ]) {
      ctrl.clear();
    }
  }

  ChatroMonthlyPlan _buildPlanFromForm() {
    return ChatroMonthlyPlan(
      planType: _selectedPlanType,
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
      literatureDistribution1: _literatureDist1Ctrl.text,
      literatureDistribution2: _literatureDist2Ctrl.text,
      magazineDistribution1: _magazineDist1Ctrl.text,
      magazineDistribution2: _magazineDist2Ctrl.text,
      posterStickerCount1: _posterSticker1Ctrl.text,
      posterStickerCount2: _posterSticker2Ctrl.text,
      posterStickerCount3: _posterSticker3Ctrl.text,
      wallWritingCount1: _wallWriting1Ctrl.text,
      wallWritingCount2: _wallWriting2Ctrl.text,
      wallWritingCount3: _wallWriting3Ctrl.text,
      groupDawahCount1: _groupDawah1Ctrl.text,
      groupDawahCount2: _groupDawah2Ctrl.text,
      groupDawahCount3: _groupDawah3Ctrl.text,
      debateCompetitionCount1: _debateComp1Ctrl.text,
      debateCompetitionCount2: _debateComp2Ctrl.text,
      debateCompetitionCount3: _debateComp3Ctrl.text,
      otherDawahActivities: _otherDawahCtrl.text,
      workIncreaseInst: _workIncreaseInstCtrl.text,
      workIncreaseRes: _workIncreaseResCtrl.text,
      workIncreaseName: _workIncreaseNameCtrl.text,
      primaryBranchIncreaseInst: _primaryBranchIncreaseInstCtrl.text,
      primaryBranchIncreaseRes: _primaryBranchIncreaseResCtrl.text,
      primaryBranchIncreaseName: _primaryBranchIncreaseNameCtrl.text,
      associateCandidateTarget: _associateCandidateTargetCtrl.text,
      associateCandidateNames: _associateCandidateNamesCtrl.text,
      kormiTarget: _kormiTargetCtrl.text,
      kormiSchoolGovt: _kormiSchoolGovtCtrl.text,
      kormiSchoolNonGovt: _kormiSchoolNonGovtCtrl.text,
      kormiCollege: _kormiCollegeCtrl.text,
      kormiMadrasaAlia: _kormiMadrasaAliaCtrl.text,
      kormiMadrasaQawmi: _kormiMadrasaQawmiCtrl.text,
      kormiUniversity: _kormiUniversityCtrl.text,
      associateBranchIncrease: _associateBranchIncreaseCtrl.text,
      associateBranchNames: _associateBranchNamesCtrl.text,
      zonalBranchIncrease: _zonalBranchIncreaseCtrl.text,
      zonalBranchNames: _zonalBranchNamesCtrl.text,
      workerBranchIncrease: _workerBranchIncreaseCtrl.text,
      workerBranchInst: _workerBranchInstCtrl.text,
      workerBranchRes: _workerBranchResCtrl.text,
      workerBranchNames: _workerBranchNamesCtrl.text,
      seniorVisitCount: _seniorVisitCountCtrl.text,
      seniorVisitDate: _seniorVisitDateCtrl.text,
      executiveMeetingCount: _execMeetingCountCtrl.text,
      executiveMeetingDateTime: _execMeetingDateTimeCtrl.text,
      zonalMeetingCount: _zonalMeetingCountCtrl.text,
      zonalMeetingDateTime: _zonalMeetingDateTimeCtrl.text,
      memberMeetingCount: _memberMeetingCountCtrl.text,
      memberMeetingDateTime: _memberMeetingDateTimeCtrl.text,
      associateMeetingCount: _assocMeetingCountCtrl.text,
      associateMeetingDateTime: _assocMeetingDateTimeCtrl.text,
      workerMeetingCount: _workerMeetingCountCtrl.text,
      workerMeetingDateTime: _workerMeetingDateTimeCtrl.text,
      generalMeetingCount: _generalMeetingCountCtrl.text,
      generalMeetingDateTime: _generalMeetingDateTimeCtrl.text,
      discussionMeetingCount: _discussionMeetingCountCtrl.text,
      discussionMeetingDateTime: _discussionMeetingDateTimeCtrl.text,
      otherMeetings: _otherMeetingsCtrl.text,
      baytulmalCollectionTarget: _baytulmalCollectionTargetCtrl.text,
      workshopCount: _workshopCountCtrl.text,
      workshopDate: _workshopDateCtrl.text,
      workshopTime: _workshopTimeCtrl.text,
      workshopVenue: _workshopVenueCtrl.text,
      studyTourCount: _studyTourCountCtrl.text,
      studyTourDate: _studyTourDateCtrl.text,
      studyTourTime: _studyTourTimeCtrl.text,
      studyTourVenue: _studyTourVenueCtrl.text,
      groupStudyCount: _groupStudyCountCtrl.text,
      groupStudySessions: _groupStudySessionsCtrl.text,
      shabguzariCount: _shabguzariCountCtrl.text,
      shabguzariDate: _shabguzariDateCtrl.text,
      shabguzariTime: _shabguzariTimeCtrl.text,
      shabguzariVenue: _shabguzariVenueCtrl.text,
      zikrMahfilCount: _zikrMahfilCountCtrl.text,
      zikrMahfilDate: _zikrMahfilDateCtrl.text,
      zikrMahfilTime: _zikrMahfilTimeCtrl.text,
      zikrMahfilVenue: _zikrMahfilVenueCtrl.text,
      trainingCircleCount: _trainingCircleCountCtrl.text,
      trainingCircleSessions: _trainingCircleSessionsCtrl.text,
      trainingCircleDate: _trainingCircleDateCtrl.text,
      skillCourseCount: _skillCourseCountCtrl.text,
      skillCourseSessions: _skillCourseSessionsCtrl.text,
      skillCourseDate: _skillCourseDateCtrl.text,
      tarbiayatiTourCount: _tarbiayatiTourCountCtrl.text,
      tarbiayatiTourDate: _tarbiayatiTourDateCtrl.text,
      tarbiayatiTourTime: _tarbiayatiTourTimeCtrl.text,
      tarbiayatiTourVenue: _tarbiayatiTourVenueCtrl.text,
      quranHadithClassCount: _quranHadithClassCountCtrl.text,
      quranHadithClassSessions: _quranHadithClassSessionsCtrl.text,
      masailaClassCount: _masailaClassCountCtrl.text,
      masailaClassSessions: _masailaClassSessionsCtrl.text,
      openClassCount: _openClassCountCtrl.text,
      openClassSessions: _openClassSessionsCtrl.text,
      culturalForumCount: _culturalForumCountCtrl.text,
      culturalForumSessions: _culturalForumSessionsCtrl.text,
      libraryIncreaseCount: _libraryIncreaseCountCtrl.text,
      libraryBookIncrease: _libraryBookIncreaseCtrl.text,
      zakatCollectionTarget: _zakatCollectionTargetCtrl.text,
      tableBankIncrease: _tableBankIncreaseCtrl.text,
      tuitionHelpCount1: _tuitionHelp1Ctrl.text,
      tuitionHelpCount2: _tuitionHelp2Ctrl.text,
      stipendStartedCount: _stipendStartedCtrl.text,
      hostelHelpCount: _hostelHelpCountCtrl.text,
      freeCoachingCount: _freeCoachingCountCtrl.text,
      coachingClassCount1: _coachingClass1Ctrl.text,
      coachingClassCount2: _coachingClass2Ctrl.text,
      noteBookDistribution1: _noteBookDist1Ctrl.text,
      noteBookDistribution2: _noteBookDist2Ctrl.text,
      noteBookDistribution3: _noteBookDist3Ctrl.text,
      libraryEstablishment: _libraryEstablishmentCtrl.text,
      libraryEstBookIncrease: _libraryEstBookIncreaseCtrl.text,
      admissionGuideCount1: _admissionGuide1Ctrl.text,
      admissionGuideCount2: _admissionGuide2Ctrl.text,
      admissionHelpStudentCount: _admissionHelpStudentCountCtrl.text,
      treePlantationCount: _treePlantationCountCtrl.text,
      bloodDonationBags: _bloodDonationBagsCtrl.text,
      quranTeachingPublic: _quranTeachingPublicCtrl.text,
      antiAddictionAwareness: _antiAddictionAwarenessCtrl.text,
      khedmateKholokMotivation: _khedmateKholokMotivationCtrl.text,
      publicOpinionAgainstOppression: _publicOpinionAgainstOppressionCtrl.text,
      bloodDonationProgram: _bloodDonationProgramCtrl.text,
      khelafatMajlisAssistance: _khelafatMajlisAssistanceCtrl.text,
      cleanlinessCampaign: _cleanlinessCampaignCtrl.text,
      dawahToMahrams: _dawahToMahramsCtrl.text,
      disasterRelief: _disasterReliefCtrl.text,
      freeHealthCareProgram: _freeHealthCareProgramCtrl.text,
      incomeManpowerIyanat: _incomeManpowerIyanatCtrl.text,
      incomeBranchIyanat: _incomeBranchIyanatCtrl.text,
      incomeWellWisherIyanat: _incomeWellWisherIyanatCtrl.text,
      incomeOneTime: _incomeOneTimeCtrl.text,
      incomeCustom5: _incomeCustom5Ctrl.text,
      incomeCustom6: _incomeCustom6Ctrl.text,
      expenseUpperIyanat: _expenseUpperIyanatCtrl.text,
      expenseUpperTour: _expenseUpperTourCtrl.text,
      expenseOffice: _expenseOfficeCtrl.text,
      expenseTravel: _expenseTravelCtrl.text,
      expenseCommunication: _expenseCommunicationCtrl.text,
      expensePublicity: _expensePublicityCtrl.text,
      totalEstimatedIncome: _totalIncomeCtrl.text,
      totalEstimatedExpense: _totalExpenseCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentPeriodPlanBloc()
        ..add(FetchStudentPeriodPlan(year: _selectedYear, month: _selectedMonth)),
      child: AnimatedBuilder(
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
              centerTitle: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF059669)),
                  ),
                  Text(
                    '$_selectedPlanType পরিকল্পনা (${_months[_selectedMonth - 1]} $_selectedYear)',
                    style: TextStyle(fontSize: 12, color: Colors.blue.shade400),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent),
                  tooltip: 'PDF ডাউনলোড',
                  onPressed: () {
                    final plan = _buildPlanFromForm();
                    PdfGeneratorService.generateChatroPeriodPlanPdf(plan);
                  },
                ),
                IconButton(
                  icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                  onPressed: () => themeManager.toggleTheme(),
                ),
                const SizedBox(width: 4),
              ],
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: const Color(0xFF059669),
                labelColor: const Color(0xFF059669),
                unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                tabs: const [
                  Tab(icon: Icon(Icons.campaign_outlined, size: 20), text: '১ম দফা: দাওয়াত'),
                  Tab(icon: Icon(Icons.groups_outlined, size: 20), text: '২য় দফা: সংগঠন'),
                  Tab(icon: Icon(Icons.school_outlined, size: 20), text: '৩য় দফা: প্রশিক্ষণ'),
                  Tab(icon: Icon(Icons.front_hand_outlined, size: 20), text: '৪র্থ দফা: আন্দোলন'),
                  Tab(icon: Icon(Icons.account_balance_outlined, size: 20), text: 'বায়তুলমাল বাজেট'),
                ],
              ),
            ),
            body: BlocConsumer<StudentPeriodPlanBloc, StudentPeriodPlanState>(
              listener: (context, state) {
                if (state is StudentPeriodPlanSaved) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ছাত্র মজলিস পর্যায়ক্রমিক পরিকল্পনা সফলভাবে সংরক্ষিত হয়েছে!'),
                      backgroundColor: Color(0xFF059669),
                    ),
                  );
                } else if (state is StudentPeriodPlanError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is StudentPeriodPlanLoaded && state.plan != null) {
                  _populateForm(state.plan);
                }
              },
              builder: (context, state) {
                if (state is StudentPeriodPlanLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    // Header Bar (Plan Type, Year, Month, Branch, Session)
                    _buildHeaderBar(context, isDark, cardBg, textColor),

                    // Tab View Pages
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildDawahTab(isDark, cardBg),
                          _buildSonghotonTab(isDark, cardBg),
                          _buildProshikkhonTab(isDark, cardBg),
                          _buildAndolonTab(isDark, cardBg),
                          _buildBaytulmalTab(isDark, cardBg),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Builder(
                builder: (blocContext) => SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final plan = _buildPlanFromForm();
                      BlocProvider.of<StudentPeriodPlanBloc>(blocContext)
                          .add(SaveStudentPeriodPlan(plan: plan));
                    },
                    icon: const Icon(Icons.save_rounded, color: Colors.white),
                    label: const Text(
                      'পরিকল্পনা সংরক্ষণ করুন',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderBar(BuildContext context, bool isDark, Color cardBg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(bottom: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Plan Type Dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedPlanType,
                      isExpanded: true,
                      dropdownColor: cardBg,
                      items: _planTypes.map((t) => DropdownMenuItem(value: t, child: Text(t, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedPlanType = val);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Month Dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedMonth,
                      isExpanded: true,
                      dropdownColor: cardBg,
                      items: List.generate(12, (i) => DropdownMenuItem(value: i + 1, child: Text(_months[i], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)))),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedMonth = val);
                          BlocProvider.of<StudentPeriodPlanBloc>(context).add(FetchStudentPeriodPlan(year: _selectedYear, month: val));
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Year Selector
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() => _selectedYear--);
                      BlocProvider.of<StudentPeriodPlanBloc>(context).add(FetchStudentPeriodPlan(year: _selectedYear, month: _selectedMonth));
                    },
                    child: const Icon(Icons.chevron_left, size: 22),
                  ),
                  Text('$_selectedYear', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                  InkWell(
                    onTap: () {
                      setState(() => _selectedYear++);
                      BlocProvider.of<StudentPeriodPlanBloc>(context).add(FetchStudentPeriodPlan(year: _selectedYear, month: _selectedMonth));
                    },
                    child: const Icon(Icons.chevron_right, size: 22),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _subField('শাখা', _branchNameCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('সেশন', _sessionCtrl, isDark)),
            ],
          ),
        ],
      ),
    );
  }

  // Tab 1: দাওয়াত
  Widget _buildDawahTab(bool isDark, Color cardBg) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _cardGroup('জনশক্তি বৃদ্ধি লক্ষ্যমাত্রা', isDark, cardBg, Colors.blue, [
            _subField('বন্ধু বৃদ্ধি (জন)', _friendTargetCtrl, isDark),
            _subField('প্রাথমিক সদস্য বৃদ্ধি (জন)', _primaryMemberTargetCtrl, isDark),
            Row(children: [
              Expanded(child: _subField('স্কুল: সরকারি (জন)', _schoolGovtCountCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('স্কুল: বেসরকারি (জন)', _schoolNonGovtCountCtrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('কলেজ (জন)', _collegeCountCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('বিশ্ববিদ্যালয় (জন)', _universityCountCtrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('মাদ্রাসা: আলিয়া (জন)', _madrasaAliaCountCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('মাদ্রাসা: কওমী (জন)', _madrasaQawmiCountCtrl, isDark)),
            ]),
            _subField('শুভাকাঙ্ক্ষী বৃদ্ধি / যোগাযোগ (জন)', _wellWisherCountCtrl, isDark),
          ]),
          const SizedBox(height: 12),
          _cardGroup('দাওয়াতি সামগ্রী বিতরণ ও প্রচার', isDark, cardBg, Colors.indigo, [
            Row(children: [
              Expanded(child: _subField('পরিচিতি / ইসলামী সাহিত্য (১)', _literatureDist1Ctrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('পরিচিতি / ইসলামী সাহিত্য (২)', _literatureDist2Ctrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('ছাত্র পরিক্রমা / কিশোর পত্রিকা (১)', _magazineDist1Ctrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('ছাত্র পরিক্রমা / কিশোর পত্রিকা (২)', _magazineDist2Ctrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('লিফলেট / স্টিকার (১)', _posterSticker1Ctrl, isDark)),
              const SizedBox(width: 6),
              Expanded(child: _subField('পোস্টার (২)', _posterSticker2Ctrl, isDark)),
              const SizedBox(width: 6),
              Expanded(child: _subField('অন্যান্য (৩)', _posterSticker3Ctrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('দেয়াল লিখন (১)', _wallWriting1Ctrl, isDark)),
              const SizedBox(width: 6),
              Expanded(child: _subField('দেয়ালিকা (২)', _wallWriting2Ctrl, isDark)),
              const SizedBox(width: 6),
              Expanded(child: _subField('নবীন বরণ (৩)', _wallWriting3Ctrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('গ্রুপ দাওয়াত (১)', _groupDawah1Ctrl, isDark)),
              const SizedBox(width: 6),
              Expanded(child: _subField('চা চক্র (২)', _groupDawah2Ctrl, isDark)),
              const SizedBox(width: 6),
              Expanded(child: _subField('উন্মুক্ত আসর (৩)', _groupDawah3Ctrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('বক্তৃতা (১)', _debateComp1Ctrl, isDark)),
              const SizedBox(width: 6),
              Expanded(child: _subField('বিতর্ক (২)', _debateComp2Ctrl, isDark)),
              const SizedBox(width: 6),
              Expanded(child: _subField('সাধারণ জ্ঞান (৩)', _debateComp3Ctrl, isDark)),
            ]),
            _subField('অন্যান্য দাওয়াতি কার্যক্রম', _otherDawahCtrl, isDark),
          ]),
          const SizedBox(height: 12),
          _cardGroup('কাজ ও শাখা বৃদ্ধি', isDark, cardBg, Colors.teal, [
            Row(children: [
              Expanded(child: _subField('কাজ বৃদ্ধি: প্রাতিষ্ঠানিক (টি)', _workIncreaseInstCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('কাজ বৃদ্ধি: আবাসিক (টি)', _workIncreaseResCtrl, isDark)),
            ]),
            _subField('কাজ বৃদ্ধির নামসমূহ', _workIncreaseNameCtrl, isDark),
            Row(children: [
              Expanded(child: _subField('প্রাথমিক শাখা: প্রাতিষ্ঠানিক (টি)', _primaryBranchIncreaseInstCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('প্রাথমিক শাখা: আবাসিক (টি)', _primaryBranchIncreaseResCtrl, isDark)),
            ]),
            _subField('প্রাথমিক শাখা বৃদ্ধির নামসমূহ', _primaryBranchIncreaseNameCtrl, isDark),
          ]),
        ],
      ),
    );
  }

  // Tab 2: সংগঠন
  Widget _buildSonghotonTab(bool isDark, Color cardBg) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _cardGroup('সংগঠনিক বৃদ্ধি', isDark, cardBg, const Color(0xFF059669), [
            Row(children: [
              Expanded(child: _subField('সহযোগী সদস্য প্রার্থী টার্গেট (জন)', _associateCandidateTargetCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('কর্মী বৃদ্ধি টার্গেট (জন)', _kormiTargetCtrl, isDark)),
            ]),
            _subField('সহযোগী সদস্য প্রার্থীর নামসমূহ', _associateCandidateNamesCtrl, isDark),
            Row(children: [
              Expanded(child: _subField('কর্মী বৃদ্ধি: স্কুল সরকারি', _kormiSchoolGovtCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('কর্মী বৃদ্ধি: স্কুল বেসরকারি', _kormiSchoolNonGovtCtrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('কর্মী বৃদ্ধি: কলেজ', _kormiCollegeCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('কর্মী বৃদ্ধি: বিশ্ববিদ্যালয়', _kormiUniversityCtrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('কর্মী বৃদ্ধি: মাদ্রাসা আলিয়া', _kormiMadrasaAliaCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('কর্মী বৃদ্ধি: মাদ্রাসা কওমী', _kormiMadrasaQawmiCtrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('সহযোগী শাখা বৃদ্ধি (টি)', _associateBranchIncreaseCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('থানা/জোন শাখা বৃদ্ধি (টি)', _zonalBranchIncreaseCtrl, isDark)),
            ]),
            _subField('সহযোগী ও জোন শাখা বৃদ্ধির নামসমূহ', _associateBranchNamesCtrl, isDark),
            Row(children: [
              Expanded(child: _subField('কর্মী শাখা বৃদ্ধি (টি)', _workerBranchIncreaseCtrl, isDark)),
              const SizedBox(width: 6),
              Expanded(child: _subField('প্রাতিষ্ঠানিক (টি)', _workerBranchInstCtrl, isDark)),
              const SizedBox(width: 6),
              Expanded(child: _subField('আবাসিক (টি)', _workerBranchResCtrl, isDark)),
            ]),
            _subField('কর্মী শাখা বৃদ্ধির নামসমূহ', _workerBranchNamesCtrl, isDark),
            Row(children: [
              Expanded(child: _subField('ঊর্ধ্বতন সফর আনা হবে (টি)', _seniorVisitCountCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('ঊর্ধ্বতন সফরের তারিখ', _seniorVisitDateCtrl, isDark)),
            ]),
          ]),
          const SizedBox(height: 12),
          _cardGroup('সভাসমূহ', isDark, cardBg, Colors.purple, [
            _meetingRow('দায়িত্বশীল সভা', _execMeetingCountCtrl, _execMeetingDateTimeCtrl, isDark),
            _meetingRow('জোনাল দায়িত্বশীল সভা', _zonalMeetingCountCtrl, _zonalMeetingDateTimeCtrl, isDark),
            _meetingRow('সদস্য সভা', _memberMeetingCountCtrl, _memberMeetingDateTimeCtrl, isDark),
            _meetingRow('সহযোগী সদস্য সভা', _assocMeetingCountCtrl, _assocMeetingDateTimeCtrl, isDark),
            _meetingRow('কর্মী সভা', _workerMeetingCountCtrl, _workerMeetingDateTimeCtrl, isDark),
            _meetingRow('সাধারণ সভা', _generalMeetingCountCtrl, _generalMeetingDateTimeCtrl, isDark),
            _meetingRow('আলোচনা সভা', _discussionMeetingCountCtrl, _discussionMeetingDateTimeCtrl, isDark),
            _subField('অন্যান্য সভাসমূহ', _otherMeetingsCtrl, isDark),
            _subField('বায়তুলমাল সংগ্রহ করা হবে (টাকা)', _baytulmalCollectionTargetCtrl, isDark),
          ]),
        ],
      ),
    );
  }

  // Tab 3: প্রশিক্ষণ
  Widget _buildProshikkhonTab(bool isDark, Color cardBg) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _cardGroup('প্রশিক্ষণ ও শিক্ষা সফর', isDark, cardBg, Colors.amber.shade800, [
            _eventFullRow('কর্মশালা', _workshopCountCtrl, _workshopDateCtrl, _workshopTimeCtrl, _workshopVenueCtrl, isDark),
            _eventFullRow('শিক্ষা সফর', _studyTourCountCtrl, _studyTourDateCtrl, _studyTourTimeCtrl, _studyTourVenueCtrl, isDark),
            _eventFullRow('শবগুজারী', _shabguzariCountCtrl, _shabguzariDateCtrl, _shabguzariTimeCtrl, _shabguzariVenueCtrl, isDark),
            _eventFullRow('জিকির মাহফিল', _zikrMahfilCountCtrl, _zikrMahfilDateCtrl, _zikrMahfilTimeCtrl, _zikrMahfilVenueCtrl, isDark),
            _eventFullRow('তারবিয়তি সফর', _tarbiayatiTourCountCtrl, _tarbiayatiTourDateCtrl, _tarbiayatiTourTimeCtrl, _tarbiayatiTourVenueCtrl, isDark),
          ]),
          const SizedBox(height: 12),
          _cardGroup('পাঠচক্র ও কোর্সসমূহ', isDark, cardBg, Colors.orange.shade800, [
            _sessionRow('সামষ্টিক অধ্যয়ন', _groupStudyCountCtrl, _groupStudySessionsCtrl, isDark),
            _sessionRow('প্রশিক্ষণ চক্র', _trainingCircleCountCtrl, _trainingCircleSessionsCtrl, isDark),
            _sessionRow('স্কিলস ডেভেলপমেন্ট কোর্স', _skillCourseCountCtrl, _skillCourseSessionsCtrl, isDark),
            _sessionRow('কুরআন ও হাদিস শিক্ষা ক্লাস', _quranHadithClassCountCtrl, _quranHadithClassSessionsCtrl, isDark),
            _sessionRow('মাসআলা-মাসায়েল শিক্ষা ক্লাস', _masailaClassCountCtrl, _masailaClassSessionsCtrl, isDark),
            _sessionRow('উন্মুক্ত ক্লাস', _openClassCountCtrl, _openClassSessionsCtrl, isDark),
            _sessionRow('স্পীকার্স / সাংস্কৃতিক ফোরাম', _culturalForumCountCtrl, _culturalForumSessionsCtrl, isDark),
            Row(children: [
              Expanded(child: _subField('পাঠাগার বৃদ্ধি (টি)', _libraryIncreaseCountCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('বই বৃদ্ধি (টি)', _libraryBookIncreaseCtrl, isDark)),
            ]),
          ]),
        ],
      ),
    );
  }

  // Tab 4: আন্দোলন ও ছাত্রকল্যাণ
  Widget _buildAndolonTab(bool isDark, Color cardBg) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _cardGroup('ছাত্রকল্যাণ', isDark, cardBg, Colors.indigo, [
            Row(children: [
              Expanded(child: _subField('যাকাত সংগ্রহ (টাকা)', _zakatCollectionTargetCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('টেবিল ব্যাংক / কলসি (টি)', _tableBankIncreaseCtrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('লজিং / টিউশনি (টি)', _tuitionHelp1Ctrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('স্টাইপেন্ড বা বৃত্তি চালু (টি)', _stipendStartedCtrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('আবাসন ব্যবস্থা (জন ছাত্র)', _hostelHelpCountCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('ফ্রি কোচিং (টি)', _freeCoachingCountCtrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('একাডেমিক/ভর্তি কোচিং (১)', _coachingClass1Ctrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('একাডেমিক/ভর্তি কোচিং (২)', _coachingClass2Ctrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('প্রশ্নপত্র বিলি (১)', _noteBookDist1Ctrl, isDark)),
              const SizedBox(width: 6),
              Expanded(child: _subField('সাজেশন (২)', _noteBookDist2Ctrl, isDark)),
              const SizedBox(width: 6),
              Expanded(child: _subField('নোট বিতরণ (৩)', _noteBookDist3Ctrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('লাইব্রেরি প্রতিষ্ঠা (টি)', _libraryEstablishmentCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('লাইব্রেরিতে বই বৃদ্ধি (টি)', _libraryEstBookIncreaseCtrl, isDark)),
            ]),
            Row(children: [
              Expanded(child: _subField('ভর্তি গাইড প্রকাশ (টি)', _admissionGuide1Ctrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('ভর্তি সহযোগিতা (জন)', _admissionHelpStudentCountCtrl, isDark)),
            ]),
          ]),
          const SizedBox(height: 12),
          _cardGroup('সামাজিক খেদমত', isDark, cardBg, Colors.teal, [
            Row(children: [
              Expanded(child: _subField('গাছ লাগানো হবে (টি)', _treePlantationCountCtrl, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _subField('রক্তদান করা হবে (ব্যাগ)', _bloodDonationBagsCtrl, isDark)),
            ]),
            _subField('সাধারণ মানুষের জন্য কুরআন তেলাওয়াত শিক্ষা', _quranTeachingPublicCtrl, isDark),
            _subField('মাদক, অশ্লীলতা ও পর্ণোগ্রাফী রোধ সচেতনতা', _antiAddictionAwarenessCtrl, isDark),
            _subField('খেদমতে খলকে উদ্বুদ্ধকরণ', _khedmateKholokMotivationCtrl, isDark),
            _subField('সকল অন্যায়ের বিরুদ্ধে জনমত গঠন', _publicOpinionAgainstOppressionCtrl, isDark),
            _subField('রক্তদান ও ফ্রি স্বাস্থ্যসেবা কর্মসূচি', _bloodDonationProgramCtrl, isDark),
            _subField('খেলাফত মজলিসের কাজে সহযোগিতা', _khelafatMajlisAssistanceCtrl, isDark),
            _subField('পরিষ্কার-পরিচ্ছন্নতা কার্যক্রম', _cleanlinessCampaignCtrl, isDark),
            _subField('মহররমা আত্মীয়দের মাঝে দাওয়াতি কাজ', _dawahToMahramsCtrl, isDark),
            _subField('দুর্যোগময় মুহূর্তে অসহায় মানুষের পাশে দাঁড়ানো', _disasterReliefCtrl, isDark),
          ]),
        ],
      ),
    );
  }

  // Tab 5: বায়তুলমাল বাজেট
  Widget _buildBaytulmalTab(bool isDark, Color cardBg) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _cardGroup('সম্ভাব্য আয়', isDark, cardBg, Colors.teal.shade700, [
            _subField('১. জনশক্তি ইয়ানত (টাকা)', _incomeManpowerIyanatCtrl, isDark, isNumber: true),
            _subField('২. শাখা ইয়ানত (টাকা)', _incomeBranchIyanatCtrl, isDark, isNumber: true),
            _subField('৩. শুভাকাঙ্ক্ষী ইয়ানত (টাকা)', _incomeWellWisherIyanatCtrl, isDark, isNumber: true),
            _subField('৪. এককালীন আয় (টাকা)', _incomeOneTimeCtrl, isDark, isNumber: true),
            _subField('৫. অন্যান্য আয় ১ (টাকা)', _incomeCustom5Ctrl, isDark, isNumber: true),
            _subField('৬. অন্যান্য আয় ২ (টাকা)', _incomeCustom6Ctrl, isDark, isNumber: true),
            const Divider(),
            _subField('মোট সম্ভাব্য আয় (টাকা)', _totalIncomeCtrl, isDark, readOnly: true),
          ]),
          const SizedBox(height: 12),
          _cardGroup('সম্ভাব্য ব্যয়', isDark, cardBg, Colors.red.shade700, [
            _subField('১. ঊর্ধ্বতন ইয়ানত পরিশোধ (টাকা)', _expenseUpperIyanatCtrl, isDark, isNumber: true),
            _subField('২. ঊর্ধ্বতন সফর (টাকা)', _expenseUpperTourCtrl, isDark, isNumber: true),
            _subField('৩. অফিস ব্যয় (টাকা)', _expenseOfficeCtrl, isDark, isNumber: true),
            _subField('৪. যাতায়াত (টাকা)', _expenseTravelCtrl, isDark, isNumber: true),
            _subField('৫. যোগাযোগ (টাকা)', _expenseCommunicationCtrl, isDark, isNumber: true),
            _subField('৬. প্রচার (টাকা)', _expensePublicityCtrl, isDark, isNumber: true),
            const Divider(),
            _subField('মোট সম্ভাব্য ব্যয় (টাকা)', _totalExpenseCtrl, isDark, readOnly: true),
          ]),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _cardGroup(String title, bool isDark, Color cardBg, Color color, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 16, color: color),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.textDark)),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _subField(String label, TextEditingController ctrl, bool isDark, {bool isNumber = false, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: ctrl,
        readOnly: readOnly,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700, fontSize: 12),
          filled: true,
          fillColor: readOnly
              ? (isDark ? const Color(0xFF1E3A52) : const Color(0xFFE2E8F0))
              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _meetingRow(String name, TextEditingController countCtrl, TextEditingController dtCtrl, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87))),
          const SizedBox(width: 6),
          Expanded(flex: 2, child: _subField('সংখ্যা (টি)', countCtrl, isDark)),
          const SizedBox(width: 6),
          Expanded(flex: 3, child: _subField('তারিখ ও সময়', dtCtrl, isDark)),
        ],
      ),
    );
  }

  Widget _sessionRow(String name, TextEditingController countCtrl, TextEditingController sessCtrl, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87))),
          const SizedBox(width: 6),
          Expanded(flex: 2, child: _subField('সংখ্যা (টি)', countCtrl, isDark)),
          const SizedBox(width: 6),
          Expanded(flex: 2, child: _subField('অধিবেশন (টি)', sessCtrl, isDark)),
        ],
      ),
    );
  }

  Widget _eventFullRow(String name, TextEditingController countCtrl, TextEditingController dateCtrl, TextEditingController timeCtrl, TextEditingController venueCtrl, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: _subField('সংখ্যা (টি)', countCtrl, isDark)),
              const SizedBox(width: 6),
              Expanded(child: _subField('তারিখ', dateCtrl, isDark)),
              const SizedBox(width: 6),
              Expanded(child: _subField('সময়', timeCtrl, isDark)),
            ],
          ),
          _subField('স্থান', venueCtrl, isDark),
        ],
      ),
    );
  }
}
