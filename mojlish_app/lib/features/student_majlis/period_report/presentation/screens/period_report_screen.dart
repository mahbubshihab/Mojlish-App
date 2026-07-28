import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import '../bloc/period_report_bloc.dart';
import '../bloc/period_report_event.dart';
import '../bloc/period_report_state.dart';
import '../../data/models/period_report_model.dart';
import '../../data/services/student_period_pdf_service.dart';

class StudentPeriodReportScreen extends StatefulWidget {
  const StudentPeriodReportScreen({super.key});

  @override
  State<StudentPeriodReportScreen> createState() => _StudentPeriodReportScreenState();
}

class _StudentPeriodReportScreenState extends State<StudentPeriodReportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String _periodType = 'দ্বি-মাসিক';
  int _selectedYear = DateTime.now().year;
  String _periodName = 'জানুয়ারী - ফেব্রুয়ারি';

  bool _isLocked = false;

  final List<String> _periodTypes = ['দ্বি-মাসিক', 'ষান্মাসিক', 'বার্ষিক'];
  final List<int> _years = List.generate(7, (index) => 2024 + index);

  final Map<String, List<String>> _periodNamesMap = {
    'দ্বি-মাসিক': [
      'জানুয়ারী - ফেব্রুয়ারি',
      'মার্চ - এপ্রিল',
      'মে - জুন',
      'জুলাই - আগস্ট',
      'সেপ্টেম্বর - অক্টোবর',
      'নভেম্বর - ডিসেম্বর',
    ],
    'ষান্মাসিক': [
      '১ম ষান্মাসিক (জানু - জুন)',
      '২য় ষান্মাসিক (জুলাই - ডিসে)',
    ],
    'বার্ষিক': [
      'পূর্ণ বার্ষিক রিপোর্ট',
    ],
  };

  // Controllers
  final _branchCtrl = TextEditingController();
  final _sessionCtrl = TextEditingController();

  // Manpower Controllers
  final _sodossoCountCtrl = TextEditingController();
  final _sodossoBridhiCtrl = TextEditingController();
  final _sodossoHowCtrl = TextEditingController();
  final _sodossoTargetCtrl = TextEditingController();
  final _sodossoGhattiCtrl = TextEditingController();
  final _sodossoReasonCtrl = TextEditingController();

  final _prarthiCountCtrl = TextEditingController();
  final _prarthiBridhiCtrl = TextEditingController();
  final _prarthiHowCtrl = TextEditingController();
  final _prarthiTargetCtrl = TextEditingController();
  final _prarthiGhattiCtrl = TextEditingController();
  final _prarthiReasonCtrl = TextEditingController();

  final _sohoyogiCountCtrl = TextEditingController();
  final _sohoyogiBridhiCtrl = TextEditingController();
  final _sohoyogiHowCtrl = TextEditingController();
  final _sohoyogiTargetCtrl = TextEditingController();
  final _sohoyogiGhattiCtrl = TextEditingController();
  final _sohoyogiReasonCtrl = TextEditingController();

  final _sohoyogiPrarthiCountCtrl = TextEditingController();
  final _sohoyogiPrarthiBridhiCtrl = TextEditingController();
  final _sohoyogiPrarthiHowCtrl = TextEditingController();
  final _sohoyogiPrarthiTargetCtrl = TextEditingController();
  final _sohoyogiPrarthiGhattiCtrl = TextEditingController();
  final _sohoyogiPrarthiReasonCtrl = TextEditingController();

  final _kormiCountCtrl = TextEditingController();
  final _kormiBridhiCtrl = TextEditingController();
  final _kormiHowCtrl = TextEditingController();
  final _kormiTargetCtrl = TextEditingController();
  final _kormiGhattiCtrl = TextEditingController();
  final _kormiReasonCtrl = TextEditingController();

  // Dawah & Distribution Controllers
  final _primaryMemberDawahCountCtrl = TextEditingController();
  final _primaryMemberDawahBridhiCtrl = TextEditingController();
  final _friendDawahCountCtrl = TextEditingController();
  final _friendDawahBridhiCtrl = TextEditingController();
  final _wellWisherDawahCountCtrl = TextEditingController();
  final _wellWisherDawahBridhiCtrl = TextEditingController();

  final _groupDawahCountCtrl = TextEditingController();
  final _teaCircleCountCtrl = TextEditingController();

  final _primaryBranchCountCtrl = TextEditingController();
  final _primaryBranchBridhiCtrl = TextEditingController();
  final _primaryBranchGhattiCtrl = TextEditingController();

  final _instBranchCountCtrl = TextEditingController();
  final _instBranchBridhiCtrl = TextEditingController();
  final _instBranchGhattiCtrl = TextEditingController();

  final _resBranchCountCtrl = TextEditingController();
  final _resBranchBridhiCtrl = TextEditingController();
  final _resBranchGhattiCtrl = TextEditingController();

  final _literatureCtrl = TextEditingController();
  final _introBookCtrl = TextEditingController();
  final _reviewCtrl = TextEditingController();
  final _teenMagCtrl = TextEditingController();
  final _stickerDiaryCtrl = TextEditingController();
  final _routineFormulaCtrl = TextEditingController();
  final _leafletPosterCtrl = TextEditingController();
  final _cardGiftCtrl = TextEditingController();

  final _newsCountCtrl = TextEditingController();
  final _wallMagCountCtrl = TextEditingController();
  final _wallWritingCountCtrl = TextEditingController();
  final _competitionCountCtrl = TextEditingController();
  final _freshersCountCtrl = TextEditingController();
  final _otherDawahMediaCtrl = TextEditingController();

  // Organization Controllers
  final _publicUnivCtrl = TextEditingController();
  final _privateUnivCtrl = TextEditingController();
  final _medicalCtrl = TextEditingController();
  final _univCollegeCtrl = TextEditingController();
  final _homeoCtrl = TextEditingController();
  final _lawCtrl = TextEditingController();
  final _techInstCtrl = TextEditingController();
  final _govCollegeCtrl = TextEditingController();
  final _nonGovCollegeCtrl = TextEditingController();
  final _kamilCtrl = TextEditingController();
  final _fazilCtrl = TextEditingController();
  final _alimCtrl = TextEditingController();
  final _dakhilCtrl = TextEditingController();
  final _qawmiCtrl = TextEditingController();
  final _govSchoolCtrl = TextEditingController();
  final _nonGovSchoolCtrl = TextEditingController();
  final _zoneThanaCtrl = TextEditingController();
  final _totalBranchCtrl = TextEditingController();
  final _kormiBranchCtrl = TextEditingController();
  final _associateBranchNamesCtrl = TextEditingController();

  // Meetings Controllers
  final _dayittoshilMeetingCountCtrl = TextEditingController();
  final _dayittoshilMeetingPresCtrl = TextEditingController();
  final _dayittoshilMeetingMaxMinCtrl = TextEditingController();

  final _thanaZonalMeetingCountCtrl = TextEditingController();
  final _thanaZonalMeetingPresCtrl = TextEditingController();
  final _thanaZonalMeetingMaxMinCtrl = TextEditingController();

  final _sodossoMeetingCountCtrl = TextEditingController();
  final _sodossoMeetingPresCtrl = TextEditingController();
  final _sodossoMeetingMaxMinCtrl = TextEditingController();

  final _sohoyogiMeetingCountCtrl = TextEditingController();
  final _sohoyogiMeetingPresCtrl = TextEditingController();
  final _sohoyogiMeetingMaxMinCtrl = TextEditingController();

  final _kormiMeetingCountCtrl = TextEditingController();
  final _kormiMeetingPresCtrl = TextEditingController();
  final _kormiMeetingMaxMinCtrl = TextEditingController();

  final _emergencyMeetingCountCtrl = TextEditingController();
  final _emergencyMeetingPresCtrl = TextEditingController();
  final _emergencyMeetingMaxMinCtrl = TextEditingController();

  final _generalMeetingCountCtrl = TextEditingController();
  final _generalMeetingPresCtrl = TextEditingController();
  final _generalMeetingMaxMinCtrl = TextEditingController();

  final _discussionMeetingCountCtrl = TextEditingController();
  final _discussionMeetingPresCtrl = TextEditingController();
  final _discussionMeetingMaxMinCtrl = TextEditingController();

  final _sohoyogiSamabeshCountCtrl = TextEditingController();
  final _sohoyogiSamabeshPresCtrl = TextEditingController();
  final _sohoyogiSamabeshMaxMinCtrl = TextEditingController();

  final _kormiSamabeshCountCtrl = TextEditingController();
  final _kormiSamabeshPresCtrl = TextEditingController();
  final _kormiSamabeshMaxMinCtrl = TextEditingController();

  final _studentSamabeshCountCtrl = TextEditingController();
  final _studentSamabeshPresCtrl = TextEditingController();
  final _studentSamabeshMaxMinCtrl = TextEditingController();

  final _rallyCountCtrl = TextEditingController();
  final _rallyPresCtrl = TextEditingController();
  final _rallyMaxMinCtrl = TextEditingController();

  final _dayObservanceCountCtrl = TextEditingController();
  final _dayObservancePresCtrl = TextEditingController();
  final _dayObservanceMaxMinCtrl = TextEditingController();

  final _otherMeetingsCountCtrl = TextEditingController();
  final _otherMeetingsPresCtrl = TextEditingController();
  final _otherMeetingsMaxMinCtrl = TextEditingController();

  // Training Controllers
  final _skillsDevCountCtrl = TextEditingController();
  final _skillsDevSessCtrl = TextEditingController();
  final _skillsDevPresCtrl = TextEditingController();
  final _skillsDevMaxMinCtrl = TextEditingController();

  final _workshopCountCtrl = TextEditingController();
  final _workshopSessCtrl = TextEditingController();
  final _workshopPresCtrl = TextEditingController();
  final _workshopMaxMinCtrl = TextEditingController();

  final _torbiyatiCountCtrl = TextEditingController();
  final _torbiyatiSessCtrl = TextEditingController();
  final _torbiyatiPresCtrl = TextEditingController();
  final _torbiyatiMaxMinCtrl = TextEditingController();

  final _trainingCircleCountCtrl = TextEditingController();
  final _trainingCircleSessCtrl = TextEditingController();
  final _trainingCirclePresCtrl = TextEditingController();
  final _trainingCircleMaxMinCtrl = TextEditingController();

  final _shikshaSobhaCountCtrl = TextEditingController();
  final _shikshaSobhaSessCtrl = TextEditingController();
  final _shikshaSobhaPresCtrl = TextEditingController();
  final _shikshaSobhaMaxMinCtrl = TextEditingController();

  final _quranClassCountCtrl = TextEditingController();
  final _quranClassSessCtrl = TextEditingController();
  final _quranClassPresCtrl = TextEditingController();
  final _quranClassMaxMinCtrl = TextEditingController();

  final _shabGujariCountCtrl = TextEditingController();
  final _shabGujariSessCtrl = TextEditingController();
  final _shabGujariPresCtrl = TextEditingController();
  final _shabGujariMaxMinCtrl = TextEditingController();

  final _zikrMahfilCountCtrl = TextEditingController();
  final _zikrMahfilSessCtrl = TextEditingController();
  final _zikrMahfilPresCtrl = TextEditingController();
  final _zikrMahfilMaxMinCtrl = TextEditingController();

  final _samostikCountCtrl = TextEditingController();
  final _samostikSessCtrl = TextEditingController();
  final _samostikPresCtrl = TextEditingController();
  final _samostikMaxMinCtrl = TextEditingController();

  final _hadithPathCountCtrl = TextEditingController();
  final _hadithPathSessCtrl = TextEditingController();
  final _hadithPathPresCtrl = TextEditingController();
  final _hadithPathMaxMinCtrl = TextEditingController();

  final _culturalCountCtrl = TextEditingController();
  final _culturalSessCtrl = TextEditingController();
  final _culturalPresCtrl = TextEditingController();
  final _culturalMaxMinCtrl = TextEditingController();

  final _openClassCountCtrl = TextEditingController();
  final _openClassSessCtrl = TextEditingController();
  final _openClassPresCtrl = TextEditingController();
  final _openClassMaxMinCtrl = TextEditingController();

  // Library & Finance Controllers
  final _libCountCtrl = TextEditingController();
  final _libBookCountCtrl = TextEditingController();
  final _libReaderCountCtrl = TextEditingController();
  final _libIssuedBooksCtrl = TextEditingController();
  final _libReadBooksCtrl = TextEditingController();
  final _libIncreaseCtrl = TextEditingController();
  final _libDeficitCtrl = TextEditingController();

  final _totalIncomeCtrl = TextEditingController();
  final _totalExpenseCtrl = TextEditingController();
  final _dueAmountCtrl = TextEditingController();
  final _dueRepaidCtrl = TextEditingController();
  final _seniorEyanatCtrl = TextEditingController();
  final _assignedAmountCtrl = TextEditingController();

  // Publications & Welfare Controllers
  final _pubPurchaseCtrl = TextEditingController();
  final _pubRepaidCtrl = TextEditingController();
  final _pubDueCtrl = TextEditingController();
  final _pubDueRepaidCtrl = TextEditingController();

  final _welfareIncomeCtrl = TextEditingController();
  final _welfareExpenseCtrl = TextEditingController();
  final _lodgingCtrl = TextEditingController();
  final _tuitionCtrl = TextEditingController();
  final _tableBankCtrl = TextEditingController();
  final _questionNoteCtrl = TextEditingController();
  final _zakatCtrl = TextEditingController();
  final _langLibBookBridhiCtrl = TextEditingController();
  final _academicCoachingCtrl = TextEditingController();
  final _freeCoachingCountCtrl = TextEditingController();
  final _freeCoachingPersonsCtrl = TextEditingController();
  final _freeCoachingBridhiCtrl = TextEditingController();
  final _freeCoachingDeficitCtrl = TextEditingController();
  final _stipendCtrl = TextEditingController();
  final _bloodBagsCtrl = TextEditingController();
  final _admissionGuideCtrl = TextEditingController();
  final _admissionHelpPersonsCtrl = TextEditingController();
  final _otherWelfareCtrl = TextEditingController();
  final _tourCtrl = TextEditingController();

  // Communication & Remarks Controllers
  final _circularRecCountCtrl = TextEditingController();
  final _circularRecCopiesCtrl = TextEditingController();
  final _circularSentCountCtrl = TextEditingController();
  final _circularSentCopiesCtrl = TextEditingController();
  final _letterRecCountCtrl = TextEditingController();
  final _letterRecCopiesCtrl = TextEditingController();
  final _letterSentCountCtrl = TextEditingController();
  final _letterSentCopiesCtrl = TextEditingController();

  final _otherOrgCtrl = TextEditingController();
  final _miscCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _populateControllers(StudentPeriodReportModel report) {
    _branchCtrl.text = report.branch;
    _sessionCtrl.text = report.session;

    // Manpower
    _sodossoCountCtrl.text = report.sodosso.presentCount.toString();
    _sodossoBridhiCtrl.text = report.sodosso.increase.toString();
    _sodossoHowCtrl.text = report.sodosso.how;
    _sodossoTargetCtrl.text = report.sodosso.target.toString();
    _sodossoGhattiCtrl.text = report.sodosso.deficit.toString();
    _sodossoReasonCtrl.text = report.sodosso.reason;

    _prarthiCountCtrl.text = report.sodossoPrarthi.presentCount.toString();
    _prarthiBridhiCtrl.text = report.sodossoPrarthi.increase.toString();
    _prarthiHowCtrl.text = report.sodossoPrarthi.how;
    _prarthiTargetCtrl.text = report.sodossoPrarthi.target.toString();
    _prarthiGhattiCtrl.text = report.sodossoPrarthi.deficit.toString();
    _prarthiReasonCtrl.text = report.sodossoPrarthi.reason;

    _sohoyogiCountCtrl.text = report.sohoyogiSodosso.presentCount.toString();
    _sohoyogiBridhiCtrl.text = report.sohoyogiSodosso.increase.toString();
    _sohoyogiHowCtrl.text = report.sohoyogiSodosso.how;
    _sohoyogiTargetCtrl.text = report.sohoyogiSodosso.target.toString();
    _sohoyogiGhattiCtrl.text = report.sohoyogiSodosso.deficit.toString();
    _sohoyogiReasonCtrl.text = report.sohoyogiSodosso.reason;

    _sohoyogiPrarthiCountCtrl.text = report.sohoyogiSodossoPrarthi.presentCount.toString();
    _sohoyogiPrarthiBridhiCtrl.text = report.sohoyogiSodossoPrarthi.increase.toString();
    _sohoyogiPrarthiHowCtrl.text = report.sohoyogiSodossoPrarthi.how;
    _sohoyogiPrarthiTargetCtrl.text = report.sohoyogiSodossoPrarthi.target.toString();
    _sohoyogiPrarthiGhattiCtrl.text = report.sohoyogiSodossoPrarthi.deficit.toString();
    _sohoyogiPrarthiReasonCtrl.text = report.sohoyogiSodossoPrarthi.reason;

    _kormiCountCtrl.text = report.kormi.presentCount.toString();
    _kormiBridhiCtrl.text = report.kormi.increase.toString();
    _kormiHowCtrl.text = report.kormi.how;
    _kormiTargetCtrl.text = report.kormi.target.toString();
    _kormiGhattiCtrl.text = report.kormi.deficit.toString();
    _kormiReasonCtrl.text = report.kormi.reason;

    // Dawah & Distribution
    _primaryMemberDawahCountCtrl.text = report.primaryMemberDawahCount.toString();
    _primaryMemberDawahBridhiCtrl.text = report.primaryMemberDawahIncrease.toString();
    _friendDawahCountCtrl.text = report.friendDawahCount.toString();
    _friendDawahBridhiCtrl.text = report.friendDawahIncrease.toString();
    _wellWisherDawahCountCtrl.text = report.wellWisherDawahCount.toString();
    _wellWisherDawahBridhiCtrl.text = report.wellWisherDawahIncrease.toString();

    _groupDawahCountCtrl.text = report.groupDawahCount.toString();
    _teaCircleCountCtrl.text = report.teaCircleCount.toString();

    _primaryBranchCountCtrl.text = report.primaryBranch.count.toString();
    _primaryBranchBridhiCtrl.text = report.primaryBranch.increase.toString();
    _primaryBranchGhattiCtrl.text = report.primaryBranch.deficit.toString();

    _instBranchCountCtrl.text = report.instBranch.count.toString();
    _instBranchBridhiCtrl.text = report.instBranch.increase.toString();
    _instBranchGhattiCtrl.text = report.instBranch.deficit.toString();

    _resBranchCountCtrl.text = report.residentialBranch.count.toString();
    _resBranchBridhiCtrl.text = report.residentialBranch.increase.toString();
    _resBranchGhattiCtrl.text = report.residentialBranch.deficit.toString();

    _literatureCtrl.text = report.islamicLiterature;
    _introBookCtrl.text = report.introductionBook;
    _reviewCtrl.text = report.studentReview;
    _teenMagCtrl.text = report.teenMagazine;
    _stickerDiaryCtrl.text = report.stickerCardDiary;
    _routineFormulaCtrl.text = report.routineFormula;
    _leafletPosterCtrl.text = report.leafletPosterCalendar;
    _cardGiftCtrl.text = report.invitationCardGift;

    _newsCountCtrl.text = report.newsPublishedCount.toString();
    _wallMagCountCtrl.text = report.wallMagazineCount.toString();
    _wallWritingCountCtrl.text = report.wallWritingCount.toString();
    _competitionCountCtrl.text = report.competitionCount.toString();
    _freshersCountCtrl.text = report.freshersReceptionCount.toString();
    _otherDawahMediaCtrl.text = report.otherDawahMediaDetails;

    // Organization
    _publicUnivCtrl.text = report.publicUniversity.toString();
    _privateUnivCtrl.text = report.privateUniversity.toString();
    _medicalCtrl.text = report.medicalCollege.toString();
    _univCollegeCtrl.text = report.universityCollege.toString();
    _homeoCtrl.text = report.homeoCollege.toString();
    _lawCtrl.text = report.lawCollege.toString();
    _techInstCtrl.text = report.technicalInst.toString();
    _govCollegeCtrl.text = report.govCollege.toString();
    _nonGovCollegeCtrl.text = report.nonGovCollege.toString();
    _kamilCtrl.text = report.kamilMadrasa.toString();
    _fazilCtrl.text = report.fazilMadrasa.toString();
    _alimCtrl.text = report.alimMadrasa.toString();
    _dakhilCtrl.text = report.dakhilMadrasa.toString();
    _qawmiCtrl.text = report.qawmiMadrasa.toString();
    _govSchoolCtrl.text = report.govSchool.toString();
    _nonGovSchoolCtrl.text = report.nonGovSchool.toString();
    _zoneThanaCtrl.text = report.zoneThana.toString();
    _totalBranchCtrl.text = report.totalBranchCount.toString();
    _kormiBranchCtrl.text = report.kormiBranchCount.toString();
    _associateBranchNamesCtrl.text = report.associateMemberBranchNames;

    // Meetings
    _dayittoshilMeetingCountCtrl.text = report.dayittoshilMeeting.count.toString();
    _dayittoshilMeetingPresCtrl.text = report.dayittoshilMeeting.attendance.toString();
    _dayittoshilMeetingMaxMinCtrl.text = report.dayittoshilMeeting.maxMin;

    _thanaZonalMeetingCountCtrl.text = report.thanaZonalMeeting.count.toString();
    _thanaZonalMeetingPresCtrl.text = report.thanaZonalMeeting.attendance.toString();
    _thanaZonalMeetingMaxMinCtrl.text = report.thanaZonalMeeting.maxMin;

    _sodossoMeetingCountCtrl.text = report.sodossoMeeting.count.toString();
    _sodossoMeetingPresCtrl.text = report.sodossoMeeting.attendance.toString();
    _sodossoMeetingMaxMinCtrl.text = report.sodossoMeeting.maxMin;

    _sohoyogiMeetingCountCtrl.text = report.sohoyogiSodossoMeeting.count.toString();
    _sohoyogiMeetingPresCtrl.text = report.sohoyogiSodossoMeeting.attendance.toString();
    _sohoyogiMeetingMaxMinCtrl.text = report.sohoyogiSodossoMeeting.maxMin;

    _kormiMeetingCountCtrl.text = report.kormiMeeting.count.toString();
    _kormiMeetingPresCtrl.text = report.kormiMeeting.attendance.toString();
    _kormiMeetingMaxMinCtrl.text = report.kormiMeeting.maxMin;

    _emergencyMeetingCountCtrl.text = report.emergencyMeeting.count.toString();
    _emergencyMeetingPresCtrl.text = report.emergencyMeeting.attendance.toString();
    _emergencyMeetingMaxMinCtrl.text = report.emergencyMeeting.maxMin;

    _generalMeetingCountCtrl.text = report.generalMeeting.count.toString();
    _generalMeetingPresCtrl.text = report.generalMeeting.attendance.toString();
    _generalMeetingMaxMinCtrl.text = report.generalMeeting.maxMin;

    _discussionMeetingCountCtrl.text = report.discussionMeeting.count.toString();
    _discussionMeetingPresCtrl.text = report.discussionMeeting.attendance.toString();
    _discussionMeetingMaxMinCtrl.text = report.discussionMeeting.maxMin;

    _sohoyogiSamabeshCountCtrl.text = report.sohoyogiSodossoSamabesh.count.toString();
    _sohoyogiSamabeshPresCtrl.text = report.sohoyogiSodossoSamabesh.attendance.toString();
    _sohoyogiSamabeshMaxMinCtrl.text = report.sohoyogiSodossoSamabesh.maxMin;

    _kormiSamabeshCountCtrl.text = report.kormiSamabesh.count.toString();
    _kormiSamabeshPresCtrl.text = report.kormiSamabesh.attendance.toString();
    _kormiSamabeshMaxMinCtrl.text = report.kormiSamabesh.maxMin;

    _studentSamabeshCountCtrl.text = report.studentSamabesh.count.toString();
    _studentSamabeshPresCtrl.text = report.studentSamabesh.attendance.toString();
    _studentSamabeshMaxMinCtrl.text = report.studentSamabesh.maxMin;

    _rallyCountCtrl.text = report.rally.count.toString();
    _rallyPresCtrl.text = report.rally.attendance.toString();
    _rallyMaxMinCtrl.text = report.rally.maxMin;

    _dayObservanceCountCtrl.text = report.dayObservance.count.toString();
    _dayObservancePresCtrl.text = report.dayObservance.attendance.toString();
    _dayObservanceMaxMinCtrl.text = report.dayObservance.maxMin;

    _otherMeetingsCountCtrl.text = report.otherMeetings.count.toString();
    _otherMeetingsPresCtrl.text = report.otherMeetings.attendance.toString();
    _otherMeetingsMaxMinCtrl.text = report.otherMeetings.maxMin;

    // Training
    _skillsDevCountCtrl.text = report.skillsDev.count.toString();
    _skillsDevSessCtrl.text = report.skillsDev.sessionCount.toString();
    _skillsDevPresCtrl.text = report.skillsDev.attendance.toString();
    _skillsDevMaxMinCtrl.text = report.skillsDev.maxMin;

    _workshopCountCtrl.text = report.workshop.count.toString();
    _workshopSessCtrl.text = report.workshop.sessionCount.toString();
    _workshopPresCtrl.text = report.workshop.attendance.toString();
    _workshopMaxMinCtrl.text = report.workshop.maxMin;

    _torbiyatiCountCtrl.text = report.torbiyatiSofor.count.toString();
    _torbiyatiSessCtrl.text = report.torbiyatiSofor.sessionCount.toString();
    _torbiyatiPresCtrl.text = report.torbiyatiSofor.attendance.toString();
    _torbiyatiMaxMinCtrl.text = report.torbiyatiSofor.maxMin;

    _trainingCircleCountCtrl.text = report.trainingCircle.count.toString();
    _trainingCircleSessCtrl.text = report.trainingCircle.sessionCount.toString();
    _trainingCirclePresCtrl.text = report.trainingCircle.attendance.toString();
    _trainingCircleMaxMinCtrl.text = report.trainingCircle.maxMin;

    _shikshaSobhaCountCtrl.text = report.shikshaSobha.count.toString();
    _shikshaSobhaSessCtrl.text = report.shikshaSobha.sessionCount.toString();
    _shikshaSobhaPresCtrl.text = report.shikshaSobha.attendance.toString();
    _shikshaSobhaMaxMinCtrl.text = report.shikshaSobha.maxMin;

    _quranClassCountCtrl.text = report.quranHadithClass.count.toString();
    _quranClassSessCtrl.text = report.quranHadithClass.sessionCount.toString();
    _quranClassPresCtrl.text = report.quranHadithClass.attendance.toString();
    _quranClassMaxMinCtrl.text = report.quranHadithClass.maxMin;

    _shabGujariCountCtrl.text = report.shabGujari.count.toString();
    _shabGujariSessCtrl.text = report.shabGujari.sessionCount.toString();
    _shabGujariPresCtrl.text = report.shabGujari.attendance.toString();
    _shabGujariMaxMinCtrl.text = report.shabGujari.maxMin;

    _zikrMahfilCountCtrl.text = report.zikrMahfil.count.toString();
    _zikrMahfilSessCtrl.text = report.zikrMahfil.sessionCount.toString();
    _zikrMahfilPresCtrl.text = report.zikrMahfil.attendance.toString();
    _zikrMahfilMaxMinCtrl.text = report.zikrMahfil.maxMin;

    _samostikCountCtrl.text = report.samostikOddhayon.count.toString();
    _samostikSessCtrl.text = report.samostikOddhayon.sessionCount.toString();
    _samostikPresCtrl.text = report.samostikOddhayon.attendance.toString();
    _samostikMaxMinCtrl.text = report.samostikOddhayon.maxMin;

    _hadithPathCountCtrl.text = report.hadithPath.count.toString();
    _hadithPathSessCtrl.text = report.hadithPath.sessionCount.toString();
    _hadithPathPresCtrl.text = report.hadithPath.attendance.toString();
    _hadithPathMaxMinCtrl.text = report.hadithPath.maxMin;

    _culturalCountCtrl.text = report.culturalForum.count.toString();
    _culturalSessCtrl.text = report.culturalForum.sessionCount.toString();
    _culturalPresCtrl.text = report.culturalForum.attendance.toString();
    _culturalMaxMinCtrl.text = report.culturalForum.maxMin;

    _openClassCountCtrl.text = report.openClass.count.toString();
    _openClassSessCtrl.text = report.openClass.sessionCount.toString();
    _openClassPresCtrl.text = report.openClass.attendance.toString();
    _openClassMaxMinCtrl.text = report.openClass.maxMin;

    // Library & Finance
    _libCountCtrl.text = report.libraryCount.toString();
    _libBookCountCtrl.text = report.bookCount.toString();
    _libReaderCountCtrl.text = report.readerCount.toString();
    _libIssuedBooksCtrl.text = report.issuedBooks.toString();
    _libReadBooksCtrl.text = report.readBooks.toString();
    _libIncreaseCtrl.text = report.libraryIncrease.toString();
    _libDeficitCtrl.text = report.libraryDeficit.toString();

    _totalIncomeCtrl.text = report.totalIncome.toString();
    _totalExpenseCtrl.text = report.totalExpense.toString();
    _dueAmountCtrl.text = report.dueAmount.toString();
    _dueRepaidCtrl.text = report.dueRepaid.toString();
    _seniorEyanatCtrl.text = report.seniorEyanatPaid.toString();
    _assignedAmountCtrl.text = report.assignedAmount.toString();

    // Publications & Welfare
    _pubPurchaseCtrl.text = report.pubTotalPurchase.toString();
    _pubRepaidCtrl.text = report.pubRepaid.toString();
    _pubDueCtrl.text = report.pubDue.toString();
    _pubDueRepaidCtrl.text = report.pubDueRepaid.toString();

    _welfareIncomeCtrl.text = report.welfareIncome.toString();
    _welfareExpenseCtrl.text = report.welfareExpense.toString();
    _lodgingCtrl.text = report.lodgingCount.toString();
    _tuitionCtrl.text = report.tuitionCount.toString();
    _tableBankCtrl.text = report.tableBankCount.toString();
    _questionNoteCtrl.text = report.questionNoteBiliCount.toString();
    _zakatCtrl.text = report.zakatCollection.toString();
    _langLibBookBridhiCtrl.text = report.languageLibraryBookIncrease.toString();
    _academicCoachingCtrl.text = report.academicCoachingCount.toString();
    _freeCoachingCountCtrl.text = report.freeCoachingAccomodationCount.toString();
    _freeCoachingPersonsCtrl.text = report.freeCoachingPersons.toString();
    _freeCoachingBridhiCtrl.text = report.freeCoachingIncrease.toString();
    _freeCoachingDeficitCtrl.text = report.freeCoachingDeficit.toString();
    _stipendCtrl.text = report.stipendActiveCount.toString();
    _bloodBagsCtrl.text = report.bloodDonationBags.toString();
    _admissionGuideCtrl.text = report.admissionGuideCount.toString();
    _admissionHelpPersonsCtrl.text = report.admissionHelpPersons.toString();
    _otherWelfareCtrl.text = report.otherWelfareDetails;
    _tourCtrl.text = report.tourDetails;

    // Communication & Remarks
    _circularRecCountCtrl.text = report.circularReceived.count.toString();
    _circularRecCopiesCtrl.text = report.circularReceived.copyCount.toString();
    _circularSentCountCtrl.text = report.circularSent.count.toString();
    _circularSentCopiesCtrl.text = report.circularSent.copyCount.toString();
    _letterRecCountCtrl.text = report.letterReceived.count.toString();
    _letterRecCopiesCtrl.text = report.letterReceived.copyCount.toString();
    _letterSentCountCtrl.text = report.letterSent.count.toString();
    _letterSentCopiesCtrl.text = report.letterSent.copyCount.toString();

    _otherOrgCtrl.text = report.otherOrgActivities;
    _miscCtrl.text = report.miscellaneous;
    _remarksCtrl.text = report.remarks;
    _dateCtrl.text = report.presidentSignatureDate;
  }

  StudentPeriodReportModel _buildReportFromFields() {
    int parseInt(String text) => int.tryParse(text.trim()) ?? 0;
    double parseDouble(String text) => double.tryParse(text.trim()) ?? 0.0;

    final keyId = '${_periodType}_${_selectedYear}_${_periodName.replaceAll(' ', '_')}';

    return StudentPeriodReportModel(
      id: keyId,
      branch: _branchCtrl.text,
      periodType: _periodType,
      periodName: _periodName,
      session: _sessionCtrl.text,
      year: _selectedYear,
      sodosso: ManpowerCategoryData(
        presentCount: parseInt(_sodossoCountCtrl.text),
        increase: parseInt(_sodossoBridhiCtrl.text),
        how: _sodossoHowCtrl.text,
        target: parseInt(_sodossoTargetCtrl.text),
        deficit: parseInt(_sodossoGhattiCtrl.text),
        reason: _sodossoReasonCtrl.text,
      ),
      sodossoPrarthi: ManpowerCategoryData(
        presentCount: parseInt(_prarthiCountCtrl.text),
        increase: parseInt(_prarthiBridhiCtrl.text),
        how: _prarthiHowCtrl.text,
        target: parseInt(_prarthiTargetCtrl.text),
        deficit: parseInt(_prarthiGhattiCtrl.text),
        reason: _prarthiReasonCtrl.text,
      ),
      sohoyogiSodosso: ManpowerCategoryData(
        presentCount: parseInt(_sohoyogiCountCtrl.text),
        increase: parseInt(_sohoyogiBridhiCtrl.text),
        how: _sohoyogiHowCtrl.text,
        target: parseInt(_sohoyogiTargetCtrl.text),
        deficit: parseInt(_sohoyogiGhattiCtrl.text),
        reason: _sohoyogiReasonCtrl.text,
      ),
      sohoyogiSodossoPrarthi: ManpowerCategoryData(
        presentCount: parseInt(_sohoyogiPrarthiCountCtrl.text),
        increase: parseInt(_sohoyogiPrarthiBridhiCtrl.text),
        how: _sohoyogiPrarthiHowCtrl.text,
        target: parseInt(_sohoyogiPrarthiTargetCtrl.text),
        deficit: parseInt(_sohoyogiPrarthiGhattiCtrl.text),
        reason: _sohoyogiPrarthiReasonCtrl.text,
      ),
      kormi: ManpowerCategoryData(
        presentCount: parseInt(_kormiCountCtrl.text),
        increase: parseInt(_kormiBridhiCtrl.text),
        how: _kormiHowCtrl.text,
        target: parseInt(_kormiTargetCtrl.text),
        deficit: parseInt(_kormiGhattiCtrl.text),
        reason: _kormiReasonCtrl.text,
      ),
      primaryMemberDawahCount: parseInt(_primaryMemberDawahCountCtrl.text),
      primaryMemberDawahIncrease: parseInt(_primaryMemberDawahBridhiCtrl.text),
      friendDawahCount: parseInt(_friendDawahCountCtrl.text),
      friendDawahIncrease: parseInt(_friendDawahBridhiCtrl.text),
      wellWisherDawahCount: parseInt(_wellWisherDawahCountCtrl.text),
      wellWisherDawahIncrease: parseInt(_wellWisherDawahBridhiCtrl.text),
      groupDawahCount: parseInt(_groupDawahCountCtrl.text),
      teaCircleCount: parseInt(_teaCircleCountCtrl.text),
      primaryBranch: BranchSummaryData(
        count: parseInt(_primaryBranchCountCtrl.text),
        increase: parseInt(_primaryBranchBridhiCtrl.text),
        deficit: parseInt(_primaryBranchGhattiCtrl.text),
      ),
      instBranch: BranchSummaryData(
        count: parseInt(_instBranchCountCtrl.text),
        increase: parseInt(_instBranchBridhiCtrl.text),
        deficit: parseInt(_instBranchGhattiCtrl.text),
      ),
      residentialBranch: BranchSummaryData(
        count: parseInt(_resBranchCountCtrl.text),
        increase: parseInt(_resBranchBridhiCtrl.text),
        deficit: parseInt(_resBranchGhattiCtrl.text),
      ),
      islamicLiterature: _literatureCtrl.text,
      introductionBook: _introBookCtrl.text,
      studentReview: _reviewCtrl.text,
      teenMagazine: _teenMagCtrl.text,
      stickerCardDiary: _stickerDiaryCtrl.text,
      routineFormula: _routineFormulaCtrl.text,
      leafletPosterCalendar: _leafletPosterCtrl.text,
      invitationCardGift: _cardGiftCtrl.text,
      newsPublishedCount: parseInt(_newsCountCtrl.text),
      wallMagazineCount: parseInt(_wallMagCountCtrl.text),
      wallWritingCount: parseInt(_wallWritingCountCtrl.text),
      competitionCount: parseInt(_competitionCountCtrl.text),
      freshersReceptionCount: parseInt(_freshersCountCtrl.text),
      otherDawahMediaDetails: _otherDawahMediaCtrl.text,
      publicUniversity: parseInt(_publicUnivCtrl.text),
      privateUniversity: parseInt(_privateUnivCtrl.text),
      medicalCollege: parseInt(_medicalCtrl.text),
      universityCollege: parseInt(_univCollegeCtrl.text),
      homeoCollege: parseInt(_homeoCtrl.text),
      lawCollege: parseInt(_lawCtrl.text),
      technicalInst: parseInt(_techInstCtrl.text),
      govCollege: parseInt(_govCollegeCtrl.text),
      nonGovCollege: parseInt(_nonGovCollegeCtrl.text),
      kamilMadrasa: parseInt(_kamilCtrl.text),
      fazilMadrasa: parseInt(_fazilCtrl.text),
      alimMadrasa: parseInt(_alimCtrl.text),
      dakhilMadrasa: parseInt(_dakhilCtrl.text),
      qawmiMadrasa: parseInt(_qawmiCtrl.text),
      govSchool: parseInt(_govSchoolCtrl.text),
      nonGovSchool: parseInt(_nonGovSchoolCtrl.text),
      zoneThana: parseInt(_zoneThanaCtrl.text),
      totalBranchCount: parseInt(_totalBranchCtrl.text),
      kormiBranchCount: parseInt(_kormiBranchCtrl.text),
      associateMemberBranchNames: _associateBranchNamesCtrl.text,
      dayittoshilMeeting: MeetingData(
        count: parseInt(_dayittoshilMeetingCountCtrl.text),
        attendance: parseInt(_dayittoshilMeetingPresCtrl.text),
        maxMin: _dayittoshilMeetingMaxMinCtrl.text,
      ),
      thanaZonalMeeting: MeetingData(
        count: parseInt(_thanaZonalMeetingCountCtrl.text),
        attendance: parseInt(_thanaZonalMeetingPresCtrl.text),
        maxMin: _thanaZonalMeetingMaxMinCtrl.text,
      ),
      sodossoMeeting: MeetingData(
        count: parseInt(_sodossoMeetingCountCtrl.text),
        attendance: parseInt(_sodossoMeetingPresCtrl.text),
        maxMin: _sodossoMeetingMaxMinCtrl.text,
      ),
      sohoyogiSodossoMeeting: MeetingData(
        count: parseInt(_sohoyogiMeetingCountCtrl.text),
        attendance: parseInt(_sohoyogiMeetingPresCtrl.text),
        maxMin: _sohoyogiMeetingMaxMinCtrl.text,
      ),
      kormiMeeting: MeetingData(
        count: parseInt(_kormiMeetingCountCtrl.text),
        attendance: parseInt(_kormiMeetingPresCtrl.text),
        maxMin: _kormiMeetingMaxMinCtrl.text,
      ),
      emergencyMeeting: MeetingData(
        count: parseInt(_emergencyMeetingCountCtrl.text),
        attendance: parseInt(_emergencyMeetingPresCtrl.text),
        maxMin: _emergencyMeetingMaxMinCtrl.text,
      ),
      generalMeeting: MeetingData(
        count: parseInt(_generalMeetingCountCtrl.text),
        attendance: parseInt(_generalMeetingPresCtrl.text),
        maxMin: _generalMeetingMaxMinCtrl.text,
      ),
      discussionMeeting: MeetingData(
        count: parseInt(_discussionMeetingCountCtrl.text),
        attendance: parseInt(_discussionMeetingPresCtrl.text),
        maxMin: _discussionMeetingMaxMinCtrl.text,
      ),
      sohoyogiSodossoSamabesh: MeetingData(
        count: parseInt(_sohoyogiSamabeshCountCtrl.text),
        attendance: parseInt(_sohoyogiSamabeshPresCtrl.text),
        maxMin: _sohoyogiSamabeshMaxMinCtrl.text,
      ),
      kormiSamabesh: MeetingData(
        count: parseInt(_kormiSamabeshCountCtrl.text),
        attendance: parseInt(_kormiSamabeshPresCtrl.text),
        maxMin: _kormiSamabeshMaxMinCtrl.text,
      ),
      studentSamabesh: MeetingData(
        count: parseInt(_studentSamabeshCountCtrl.text),
        attendance: parseInt(_studentSamabeshPresCtrl.text),
        maxMin: _studentSamabeshMaxMinCtrl.text,
      ),
      rally: MeetingData(
        count: parseInt(_rallyCountCtrl.text),
        attendance: parseInt(_rallyPresCtrl.text),
        maxMin: _rallyMaxMinCtrl.text,
      ),
      dayObservance: MeetingData(
        count: parseInt(_dayObservanceCountCtrl.text),
        attendance: parseInt(_dayObservancePresCtrl.text),
        maxMin: _dayObservanceMaxMinCtrl.text,
      ),
      otherMeetings: MeetingData(
        count: parseInt(_otherMeetingsCountCtrl.text),
        attendance: parseInt(_otherMeetingsPresCtrl.text),
        maxMin: _otherMeetingsMaxMinCtrl.text,
      ),
      skillsDev: TrainingData(
        count: parseInt(_skillsDevCountCtrl.text),
        sessionCount: parseInt(_skillsDevSessCtrl.text),
        attendance: parseInt(_skillsDevPresCtrl.text),
        maxMin: _skillsDevMaxMinCtrl.text,
      ),
      workshop: TrainingData(
        count: parseInt(_workshopCountCtrl.text),
        sessionCount: parseInt(_workshopSessCtrl.text),
        attendance: parseInt(_workshopPresCtrl.text),
        maxMin: _workshopMaxMinCtrl.text,
      ),
      torbiyatiSofor: TrainingData(
        count: parseInt(_torbiyatiCountCtrl.text),
        sessionCount: parseInt(_torbiyatiSessCtrl.text),
        attendance: parseInt(_torbiyatiPresCtrl.text),
        maxMin: _torbiyatiMaxMinCtrl.text,
      ),
      trainingCircle: TrainingData(
        count: parseInt(_trainingCircleCountCtrl.text),
        sessionCount: parseInt(_trainingCircleSessCtrl.text),
        attendance: parseInt(_trainingCirclePresCtrl.text),
        maxMin: _trainingCircleMaxMinCtrl.text,
      ),
      shikshaSobha: TrainingData(
        count: parseInt(_shikshaSobhaCountCtrl.text),
        sessionCount: parseInt(_shikshaSobhaSessCtrl.text),
        attendance: parseInt(_shikshaSobhaPresCtrl.text),
        maxMin: _shikshaSobhaMaxMinCtrl.text,
      ),
      quranHadithClass: TrainingData(
        count: parseInt(_quranClassCountCtrl.text),
        sessionCount: parseInt(_quranClassSessCtrl.text),
        attendance: parseInt(_quranClassPresCtrl.text),
        maxMin: _quranClassMaxMinCtrl.text,
      ),
      shabGujari: TrainingData(
        count: parseInt(_shabGujariCountCtrl.text),
        sessionCount: parseInt(_shabGujariSessCtrl.text),
        attendance: parseInt(_shabGujariPresCtrl.text),
        maxMin: _shabGujariMaxMinCtrl.text,
      ),
      zikrMahfil: TrainingData(
        count: parseInt(_zikrMahfilCountCtrl.text),
        sessionCount: parseInt(_zikrMahfilSessCtrl.text),
        attendance: parseInt(_zikrMahfilPresCtrl.text),
        maxMin: _zikrMahfilMaxMinCtrl.text,
      ),
      samostikOddhayon: TrainingData(
        count: parseInt(_samostikCountCtrl.text),
        sessionCount: parseInt(_samostikSessCtrl.text),
        attendance: parseInt(_samostikPresCtrl.text),
        maxMin: _samostikMaxMinCtrl.text,
      ),
      hadithPath: TrainingData(
        count: parseInt(_hadithPathCountCtrl.text),
        sessionCount: parseInt(_hadithPathSessCtrl.text),
        attendance: parseInt(_hadithPathPresCtrl.text),
        maxMin: _hadithPathMaxMinCtrl.text,
      ),
      culturalForum: TrainingData(
        count: parseInt(_culturalCountCtrl.text),
        sessionCount: parseInt(_culturalSessCtrl.text),
        attendance: parseInt(_culturalPresCtrl.text),
        maxMin: _culturalMaxMinCtrl.text,
      ),
      openClass: TrainingData(
        count: parseInt(_openClassCountCtrl.text),
        sessionCount: parseInt(_openClassSessCtrl.text),
        attendance: parseInt(_openClassPresCtrl.text),
        maxMin: _openClassMaxMinCtrl.text,
      ),
      libraryCount: parseInt(_libCountCtrl.text),
      bookCount: parseInt(_libBookCountCtrl.text),
      readerCount: parseInt(_libReaderCountCtrl.text),
      issuedBooks: parseInt(_libIssuedBooksCtrl.text),
      readBooks: parseInt(_libReadBooksCtrl.text),
      libraryIncrease: parseInt(_libIncreaseCtrl.text),
      libraryDeficit: parseInt(_libDeficitCtrl.text),
      totalIncome: parseDouble(_totalIncomeCtrl.text),
      totalExpense: parseDouble(_totalExpenseCtrl.text),
      dueAmount: parseDouble(_dueAmountCtrl.text),
      dueRepaid: parseDouble(_dueRepaidCtrl.text),
      seniorEyanatPaid: parseDouble(_seniorEyanatCtrl.text),
      assignedAmount: parseDouble(_assignedAmountCtrl.text),
      pubTotalPurchase: parseDouble(_pubPurchaseCtrl.text),
      pubRepaid: parseDouble(_pubRepaidCtrl.text),
      pubDue: parseDouble(_pubDueCtrl.text),
      pubDueRepaid: parseDouble(_pubDueRepaidCtrl.text),
      welfareIncome: parseDouble(_welfareIncomeCtrl.text),
      welfareExpense: parseDouble(_welfareExpenseCtrl.text),
      lodgingCount: parseInt(_lodgingCtrl.text),
      tuitionCount: parseInt(_tuitionCtrl.text),
      tableBankCount: parseInt(_tableBankCtrl.text),
      questionNoteBiliCount: parseInt(_questionNoteCtrl.text),
      zakatCollection: parseDouble(_zakatCtrl.text),
      languageLibraryBookIncrease: parseInt(_langLibBookBridhiCtrl.text),
      academicCoachingCount: parseInt(_academicCoachingCtrl.text),
      freeCoachingAccomodationCount: parseInt(_freeCoachingCountCtrl.text),
      freeCoachingPersons: parseInt(_freeCoachingPersonsCtrl.text),
      freeCoachingIncrease: parseInt(_freeCoachingBridhiCtrl.text),
      freeCoachingDeficit: parseInt(_freeCoachingDeficitCtrl.text),
      stipendActiveCount: parseInt(_stipendCtrl.text),
      bloodDonationBags: parseInt(_bloodBagsCtrl.text),
      admissionGuideCount: parseInt(_admissionGuideCtrl.text),
      admissionHelpPersons: parseInt(_admissionHelpPersonsCtrl.text),
      otherWelfareDetails: _otherWelfareCtrl.text,
      tourDetails: _tourCtrl.text,
      circularReceived: CommItemData(
        count: parseInt(_circularRecCountCtrl.text),
        copyCount: parseInt(_circularRecCopiesCtrl.text),
      ),
      circularSent: CommItemData(
        count: parseInt(_circularSentCountCtrl.text),
        copyCount: parseInt(_circularSentCopiesCtrl.text),
      ),
      letterReceived: CommItemData(
        count: parseInt(_letterRecCountCtrl.text),
        copyCount: parseInt(_letterRecCopiesCtrl.text),
      ),
      letterSent: CommItemData(
        count: parseInt(_letterSentCountCtrl.text),
        copyCount: parseInt(_letterSentCopiesCtrl.text),
      ),
      otherOrgActivities: _otherOrgCtrl.text,
      miscellaneous: _miscCtrl.text,
      remarks: _remarksCtrl.text,
      presidentSignatureDate: _dateCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final scaffoldBg = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFCBD5E1);
    final accentGreen = const Color(0xFF10B981);

    return BlocProvider(
      create: (_) => StudentPeriodReportBloc()
        ..add(LoadStudentPeriodReport(
          periodType: _periodType,
          year: _selectedYear,
          periodName: _periodName,
        )),
      child: BlocConsumer<StudentPeriodReportBloc, StudentPeriodReportState>(
        listener: (context, state) {
          if (state is StudentPeriodReportLoaded) {
            _populateControllers(state.report);
            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message!), backgroundColor: accentGreen),
              );
            }
          } else if (state is StudentPeriodReportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: scaffoldBg,
            appBar: AppBar(
              backgroundColor: cardBg,
              elevation: 1,
              iconTheme: IconThemeData(color: textColor),
              title: Text(
                'বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট',
                style: TextStyle(color: accentGreen, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              actions: [
                IconButton(
                  icon: Icon(_isLocked ? Icons.lock : Icons.lock_open, color: _isLocked ? Colors.red : accentGreen),
                  tooltip: _isLocked ? 'এডিট লক খোলা' : 'এডিট লক করা',
                  onPressed: () {
                    setState(() {
                      _isLocked = !_isLocked;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.blue),
                  tooltip: 'পিডিএফ প্রিন্ট / শেয়ার',
                  onPressed: () {
                    final currentReport = _buildReportFromFields();
                    StudentPeriodPdfService.generateAndPrintPdf(currentReport);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.save, color: Colors.teal),
                  tooltip: 'সংরক্ষণ করুন',
                  onPressed: state is StudentPeriodReportLoaded && !state.isSaving
                      ? () {
                          final currentReport = _buildReportFromFields();
                          context.read<StudentPeriodReportBloc>().add(SaveStudentPeriodReport(currentReport));
                        }
                      : null,
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Column(
                  children: [
                    // ফিল্টার হেডার Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: Row(
                        children: [
                          // টাইপ ড্রপডাউন
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<String>(
                              initialValue: _periodType,
                              decoration: InputDecoration(
                                labelText: 'টাইপ',
                                labelStyle: TextStyle(fontSize: 12, color: textColor),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                border: const OutlineInputBorder(),
                              ),
                              items: _periodTypes
                                  .map((t) => DropdownMenuItem(value: t, child: Text(t, style: TextStyle(fontSize: 12, color: textColor))))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _periodType = val;
                                    _periodName = _periodNamesMap[val]!.first;
                                  });
                                  context.read<StudentPeriodReportBloc>().add(LoadStudentPeriodReport(
                                        periodType: _periodType,
                                        year: _selectedYear,
                                        periodName: _periodName,
                                      ));
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),

                          // সময়কাল/মাস ড্রপডাউন
                          Expanded(
                            flex: 4,
                            child: DropdownButtonFormField<String>(
                              initialValue: _periodName,
                              decoration: InputDecoration(
                                labelText: 'সময়কাল',
                                labelStyle: TextStyle(fontSize: 12, color: textColor),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                border: const OutlineInputBorder(),
                              ),
                              items: (_periodNamesMap[_periodType] ?? [])
                                  .map((n) => DropdownMenuItem(value: n, child: Text(n, style: TextStyle(fontSize: 11, color: textColor))))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _periodName = val;
                                  });
                                  context.read<StudentPeriodReportBloc>().add(LoadStudentPeriodReport(
                                        periodType: _periodType,
                                        year: _selectedYear,
                                        periodName: _periodName,
                                      ));
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),

                          // বছর ড্রপডাউন
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<int>(
                              initialValue: _selectedYear,
                              decoration: InputDecoration(
                                labelText: 'বছর',
                                labelStyle: TextStyle(fontSize: 12, color: textColor),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                border: const OutlineInputBorder(),
                              ),
                              items: _years
                                  .map((y) => DropdownMenuItem(value: y, child: Text('$y', style: TextStyle(fontSize: 12, color: textColor))))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedYear = val;
                                  });
                                  context.read<StudentPeriodReportBloc>().add(LoadStudentPeriodReport(
                                        periodType: _periodType,
                                        year: _selectedYear,
                                        periodName: _periodName,
                                      ));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tab bar
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: accentGreen,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: accentGreen,
                      tabs: const [
                        Tab(text: '১. জনশক্তি'),
                        Tab(text: '২. দাওয়াত ও বিতরণ'),
                        Tab(text: '৩. সংগঠন'),
                        Tab(text: '৪. সভাসমূহ'),
                        Tab(text: '৫. প্রশিক্ষণ'),
                        Tab(text: '৬-৭. পাঠাগার ও বায়তুলমাল'),
                        Tab(text: '৮-৯. প্রকাশনা ও কল্যাণ'),
                        Tab(text: '১০-১১. যোগাযোগ ও মন্তব্য'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: state is StudentPeriodReportLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildManpowerTab(textColor, cardBg, borderColor),
                      _buildDawahTab(textColor, cardBg, borderColor),
                      _buildOrgTab(textColor, cardBg, borderColor),
                      _buildMeetingsTab(textColor, cardBg, borderColor),
                      _buildTrainingTab(textColor, cardBg, borderColor),
                      _buildLibraryFinanceTab(textColor, cardBg, borderColor),
                      _buildPubWelfareTab(textColor, cardBg, borderColor),
                      _buildCommRemarksTab(textColor, cardBg, borderColor),
                    ],
                  ),
          );
        },
      ),
    );
  }

  // ------------------------------------
  // ১. জনশক্তি ট্যাব
  // ------------------------------------
  Widget _buildManpowerTab(Color textColor, Color cardBg, Color borderColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeaderInfoFields(textColor),
          const SizedBox(height: 16),
          Card(
            color: cardBg,
            shape: RoundedRectangleBorder(side: BorderSide(color: borderColor), borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('জনশক্তি সারণী (Manpower Statistics)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                  const SizedBox(height: 12),
                  _buildManpowerRow('সদস্য', _sodossoCountCtrl, _sodossoBridhiCtrl, _sodossoHowCtrl, _sodossoTargetCtrl, _sodossoGhattiCtrl, _sodossoReasonCtrl, textColor),
                  _buildManpowerRow('সদস্য প্রার্থী', _prarthiCountCtrl, _prarthiBridhiCtrl, _prarthiHowCtrl, _prarthiTargetCtrl, _prarthiGhattiCtrl, _prarthiReasonCtrl, textColor),
                  _buildManpowerRow('সহযোগী সদস্য', _sohoyogiCountCtrl, _sohoyogiBridhiCtrl, _sohoyogiHowCtrl, _sohoyogiTargetCtrl, _sohoyogiGhattiCtrl, _sohoyogiReasonCtrl, textColor),
                  _buildManpowerRow('সহযোগী সদস্য প্রার্থী', _sohoyogiPrarthiCountCtrl, _sohoyogiPrarthiBridhiCtrl, _sohoyogiPrarthiHowCtrl, _sohoyogiPrarthiTargetCtrl, _sohoyogiPrarthiGhattiCtrl, _sohoyogiPrarthiReasonCtrl, textColor),
                  _buildManpowerRow('কর্মী', _kormiCountCtrl, _kormiBridhiCtrl, _kormiHowCtrl, _kormiTargetCtrl, _kormiGhattiCtrl, _kormiReasonCtrl, textColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfoFields(Color textColor) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _branchCtrl,
            enabled: !_isLocked,
            decoration: const InputDecoration(labelText: 'শাখার নাম', border: OutlineInputBorder()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _sessionCtrl,
            enabled: !_isLocked,
            decoration: const InputDecoration(labelText: 'সেশন', border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  Widget _buildManpowerRow(
    String title,
    TextEditingController countCtrl,
    TextEditingController bridhiCtrl,
    TextEditingController howCtrl,
    TextEditingController targetCtrl,
    TextEditingController ghattiCtrl,
    TextEditingController reasonCtrl,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: _numField('সংখ্যা', countCtrl)),
              const SizedBox(width: 6),
              Expanded(child: _numField('বৃদ্ধি', bridhiCtrl)),
              const SizedBox(width: 6),
              Expanded(child: _textField('কিভাবে', howCtrl)),
              const SizedBox(width: 6),
              Expanded(child: _numField('টার্গেট', targetCtrl)),
              const SizedBox(width: 6),
              Expanded(child: _numField('ঘাটতি', ghattiCtrl)),
            ],
          ),
          const SizedBox(height: 6),
          _textField('ঘাটতির কারণ', reasonCtrl),
          const Divider(),
        ],
      ),
    );
  }

  // ------------------------------------
  // ২. দাওয়াত ও বিতরণ ট্যাব
  // ------------------------------------
  Widget _buildDawahTab(Color textColor, Color cardBg, Color borderColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('দাওয়াত ও গণসংযোগ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _numField('প্রাথমিক সদস্য দাওয়াত', _primaryMemberDawahCountCtrl)),
              const SizedBox(width: 8),
              Expanded(child: _numField('বৃদ্ধি', _primaryMemberDawahBridhiCtrl)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _numField('বন্ধু দাওয়াত', _friendDawahCountCtrl)),
              const SizedBox(width: 8),
              Expanded(child: _numField('বৃদ্ধি', _friendDawahBridhiCtrl)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _numField('শুভাকাঙ্ক্ষী দাওয়াত', _wellWisherDawahCountCtrl)),
              const SizedBox(width: 8),
              Expanded(child: _numField('বৃদ্ধি', _wellWisherDawahBridhiCtrl)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _numField('গ্রুপ দাওয়াত', _groupDawahCountCtrl)),
              const SizedBox(width: 8),
              Expanded(child: _numField('চা-চক্র', _teaCircleCountCtrl)),
            ],
          ),
          const SizedBox(height: 16),
          Text('শাখা বিবরণ (প্রাথমিক/প্রাতিষ্ঠানিক/আবাসিক)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
          const SizedBox(height: 8),
          _buildBranchTripleRow('প্রাথমিক শাখা', _primaryBranchCountCtrl, _primaryBranchBridhiCtrl, _primaryBranchGhattiCtrl),
          _buildBranchTripleRow('প্রাতিষ্ঠানিক শাখা', _instBranchCountCtrl, _instBranchBridhiCtrl, _instBranchGhattiCtrl),
          _buildBranchTripleRow('আবাসিক শাখা', _resBranchCountCtrl, _resBranchBridhiCtrl, _resBranchGhattiCtrl),

          const SizedBox(height: 16),
          Text('বিতরণ সামগ্রী (পরিমাণ)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          const SizedBox(height: 8),
          _textField('ইসলামী সাহিত্য', _literatureCtrl),
          const SizedBox(height: 6),
          _textField('পরিচিতি', _introBookCtrl),
          const SizedBox(height: 6),
          _textField('ছাত্র পরিক্রমা/স্টুডেন্টস রিভিউ', _reviewCtrl),
          const SizedBox(height: 6),
          _textField('কিশোর পত্রিকা', _teenMagCtrl),
          const SizedBox(height: 6),
          _textField('স্টিকার/কার্ড/ডায়েরি', _stickerDiaryCtrl),
          const SizedBox(height: 6),
          _textField('ক্লাস/পরীক্ষার রুটিন/সূত্রাবলী', _routineFormulaCtrl),
          const SizedBox(height: 6),
          _textField('লিফলেট/পোস্টার/ক্যালেন্ডার', _leafletPosterCtrl),
          const SizedBox(height: 6),
          _textField('দাওয়াত কার্ড/ঈদ কার্ড/উপহার', _cardGiftCtrl),

          const SizedBox(height: 16),
          Text('মিডিয়া রিলিজ ও অনুষ্ঠানাদি', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _numField('সংবাদ প্রকাশ', _newsCountCtrl)),
              const SizedBox(width: 6),
              Expanded(child: _numField('বার দেয়ালিকা', _wallMagCountCtrl)),
              const SizedBox(width: 6),
              Expanded(child: _numField('দেয়াল লিখন', _wallWritingCountCtrl)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _numField('প্রতিযোগিতা', _competitionCountCtrl)),
              const SizedBox(width: 6),
              Expanded(child: _numField('নবীন বরণ', _freshersCountCtrl)),
            ],
          ),
          const SizedBox(height: 8),
          _textField('অন্যান্য বিস্তারিত', _otherDawahMediaCtrl),
        ],
      ),
    );
  }

  Widget _buildBranchTripleRow(String title, TextEditingController c, TextEditingController b, TextEditingController g) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: _numField('সংখ্যা', c)),
          const SizedBox(width: 4),
          Expanded(child: _numField('বৃদ্ধি', b)),
          const SizedBox(width: 4),
          Expanded(child: _numField('ঘাটতি', g)),
        ],
      ),
    );
  }

  // ------------------------------------
  // ৩. সংগঠন ট্যাব
  // ------------------------------------
  Widget _buildOrgTab(Color textColor, Color cardBg, Color borderColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('সংগঠন (শিক্ষা প্রতিষ্ঠান ও জোন/থানা সংখ্যা)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: _numField('পাবলিক বিশ্ববিদ্যালয়', _publicUnivCtrl)), const SizedBox(width: 8), Expanded(child: _numField('প্রাইভেট বিশ্ববিদ্যালয়', _privateUnivCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('মেডিকেল কলেজ', _medicalCtrl)), const SizedBox(width: 8), Expanded(child: _numField('বিশ্ববিদ্যালয় কলেজ', _univCollegeCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('হোমিও কলেজ', _homeoCtrl)), const SizedBox(width: 8), Expanded(child: _numField('আইন কলেজ', _lawCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('টেকনিক্যাল প্রতিষ্ঠান', _techInstCtrl)), const SizedBox(width: 8), Expanded(child: _numField('জোন/থানা', _zoneThanaCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('সরকারি কলেজ', _govCollegeCtrl)), const SizedBox(width: 8), Expanded(child: _numField('বেসরকারি কলেজ', _nonGovCollegeCtrl))]),
          const SizedBox(height: 12),
          Text('মাদরাসা সমূহ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('কামিল', _kamilCtrl)), const SizedBox(width: 6), Expanded(child: _numField('ফাজিল', _fazilCtrl)), const SizedBox(width: 6), Expanded(child: _numField('আলিম', _alimCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('দাখিল', _dakhilCtrl)), const SizedBox(width: 8), Expanded(child: _numField('কওমী', _qawmiCtrl))]),
          const SizedBox(height: 12),
          Text('স্কুল সমূহ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('সরকারি স্কুল', _govSchoolCtrl)), const SizedBox(width: 8), Expanded(child: _numField('বেসরকারি স্কুল', _nonGovSchoolCtrl))]),
          const SizedBox(height: 16),
          Text('শাখা সামারি', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('মোট শাখা', _totalBranchCtrl)), const SizedBox(width: 8), Expanded(child: _numField('কর্মী শাখা', _kormiBranchCtrl))]),
          const SizedBox(height: 8),
          _textField('সহযোগী সদস্য শাখা (নামসহ)', _associateBranchNamesCtrl),
        ],
      ),
    );
  }

  // ------------------------------------
  // ৪. সভাসমূহ ট্যাব
  // ------------------------------------
  Widget _buildMeetingsTab(Color textColor, Color cardBg, Color borderColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMeetingItem('দায়িত্বশীল সভা', _dayittoshilMeetingCountCtrl, _dayittoshilMeetingPresCtrl, _dayittoshilMeetingMaxMinCtrl, textColor),
          _buildMeetingItem('থানা/জোনাল সভা', _thanaZonalMeetingCountCtrl, _thanaZonalMeetingPresCtrl, _thanaZonalMeetingMaxMinCtrl, textColor),
          _buildMeetingItem('সদস্য সভা', _sodossoMeetingCountCtrl, _sodossoMeetingPresCtrl, _sodossoMeetingMaxMinCtrl, textColor),
          _buildMeetingItem('সহযোগী সদস্য সভা', _sohoyogiMeetingCountCtrl, _sohoyogiMeetingPresCtrl, _sohoyogiMeetingMaxMinCtrl, textColor),
          _buildMeetingItem('কর্মী সভা', _kormiMeetingCountCtrl, _kormiMeetingPresCtrl, _kormiMeetingMaxMinCtrl, textColor),
          _buildMeetingItem('জরুরি সভা', _emergencyMeetingCountCtrl, _emergencyMeetingPresCtrl, _emergencyMeetingMaxMinCtrl, textColor),
          _buildMeetingItem('সাধারণ সভা', _generalMeetingCountCtrl, _generalMeetingPresCtrl, _generalMeetingMaxMinCtrl, textColor),
          _buildMeetingItem('আলোচনা সভা', _discussionMeetingCountCtrl, _discussionMeetingPresCtrl, _discussionMeetingMaxMinCtrl, textColor),
          _buildMeetingItem('সহযোগী সদস্য সমাবেশ', _sohoyogiSamabeshCountCtrl, _sohoyogiSamabeshPresCtrl, _sohoyogiSamabeshMaxMinCtrl, textColor),
          _buildMeetingItem('কর্মী সমাবেশ', _kormiSamabeshCountCtrl, _kormiSamabeshPresCtrl, _kormiSamabeshMaxMinCtrl, textColor),
          _buildMeetingItem('ছাত্র সমাবেশ', _studentSamabeshCountCtrl, _studentSamabeshPresCtrl, _studentSamabeshMaxMinCtrl, textColor),
          _buildMeetingItem('মিছিল', _rallyCountCtrl, _rallyPresCtrl, _rallyMaxMinCtrl, textColor),
          _buildMeetingItem('দিবস পালন', _dayObservanceCountCtrl, _dayObservancePresCtrl, _dayObservanceMaxMinCtrl, textColor),
          _buildMeetingItem('অন্যান্য সভা', _otherMeetingsCountCtrl, _otherMeetingsPresCtrl, _otherMeetingsMaxMinCtrl, textColor),
        ],
      ),
    );
  }

  Widget _buildMeetingItem(String title, TextEditingController countCtrl, TextEditingController presCtrl, TextEditingController maxMinCtrl, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: _numField('সংখ্যা', countCtrl)),
              const SizedBox(width: 6),
              Expanded(child: _numField('উপস্থিতি', presCtrl)),
              const SizedBox(width: 6),
              Expanded(child: _textField('সর্বোচ্চ/সর্বনিম্ন', maxMinCtrl)),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  // ------------------------------------
  // ৫. প্রশিক্ষণ ট্যাব
  // ------------------------------------
  Widget _buildTrainingTab(Color textColor, Color cardBg, Color borderColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTrainingItem('স্কিলস ডেভেলপমেন্ট প্রোগ্রাম', _skillsDevCountCtrl, _skillsDevSessCtrl, _skillsDevPresCtrl, _skillsDevMaxMinCtrl, textColor),
          _buildTrainingItem('কর্মশালা', _workshopCountCtrl, _workshopSessCtrl, _workshopPresCtrl, _workshopMaxMinCtrl, textColor),
          _buildTrainingItem('তরবিয়তি সফর', _torbiyatiCountCtrl, _torbiyatiSessCtrl, _torbiyatiPresCtrl, _torbiyatiMaxMinCtrl, textColor),
          _buildTrainingItem('প্রশিক্ষণ চক্র', _trainingCircleCountCtrl, _trainingCircleSessCtrl, _trainingCirclePresCtrl, _trainingCircleMaxMinCtrl, textColor),
          _buildTrainingItem('শিক্ষা সভা', _shikshaSobhaCountCtrl, _shikshaSobhaSessCtrl, _shikshaSobhaPresCtrl, _shikshaSobhaMaxMinCtrl, textColor),
          _buildTrainingItem('কুরআন ও হাদীস শিক্ষা ক্লাস', _quranClassCountCtrl, _quranClassSessCtrl, _quranClassPresCtrl, _quranClassMaxMinCtrl, textColor),
          _buildTrainingItem('শবগুজারি', _shabGujariCountCtrl, _shabGujariSessCtrl, _shabGujariPresCtrl, _shabGujariMaxMinCtrl, textColor),
          _buildTrainingItem('জিকির মাহফিল', _zikrMahfilCountCtrl, _zikrMahfilSessCtrl, _zikrMahfilPresCtrl, _zikrMahfilMaxMinCtrl, textColor),
          _buildTrainingItem('সামষ্টিক অধ্যয়ন', _samostikCountCtrl, _samostikSessCtrl, _samostikPresCtrl, _samostikMaxMinCtrl, textColor),
          _buildTrainingItem('হাদীস পাঠ', _hadithPathCountCtrl, _hadithPathSessCtrl, _hadithPathPresCtrl, _hadithPathMaxMinCtrl, textColor),
          _buildTrainingItem('স্পীকার্স/সাংস্কৃতিক ফোরাম', _culturalCountCtrl, _culturalSessCtrl, _culturalPresCtrl, _culturalMaxMinCtrl, textColor),
          _buildTrainingItem('উন্মুক্ত ক্লাস', _openClassCountCtrl, _openClassSessCtrl, _openClassPresCtrl, _openClassMaxMinCtrl, textColor),
        ],
      ),
    );
  }

  Widget _buildTrainingItem(String title, TextEditingController countCtrl, TextEditingController sessCtrl, TextEditingController presCtrl, TextEditingController maxMinCtrl, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: _numField('সংখ্যা', countCtrl)),
              const SizedBox(width: 4),
              Expanded(child: _numField('অধिवेशन', sessCtrl)),
              const SizedBox(width: 4),
              Expanded(child: _numField('উপস্থিতি', presCtrl)),
              const SizedBox(width: 4),
              Expanded(child: _textField('সর্বোচ্চ/সর্বনিম্ন', maxMinCtrl)),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  // ------------------------------------
  // ৬-৭. পাঠাগার ও বায়তুলমাল ট্যাব
  // ------------------------------------
  Widget _buildLibraryFinanceTab(Color textColor, Color cardBg, Color borderColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('৬. পাঠাগার', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          const SizedBox(height: 10),
          Row(children: [Expanded(child: _numField('পাঠাগার সংখ্যা', _libCountCtrl)), const SizedBox(width: 8), Expanded(child: _numField('বই সংখ্যা', _libBookCountCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('পাঠক সংখ্যা', _libReaderCountCtrl)), const SizedBox(width: 8), Expanded(child: _numField('ইস্যুকৃত বই', _libIssuedBooksCtrl)), const SizedBox(width: 8), Expanded(child: _numField('পঠিত বই', _libReadBooksCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('বৃদ্ধি', _libIncreaseCtrl)), const SizedBox(width: 8), Expanded(child: _numField('ঘাটতি', _libDeficitCtrl))]),

          const SizedBox(height: 24),
          Text('৭. বায়তুলমাল', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          const SizedBox(height: 10),
          Row(children: [Expanded(child: _numField('মোট আয় (৳)', _totalIncomeCtrl)), const SizedBox(width: 8), Expanded(child: _numField('মোট ব্যয় (৳)', _totalExpenseCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('বকেয়া (৳)', _dueAmountCtrl)), const SizedBox(width: 8), Expanded(child: _numField('বকেয়া পরিশোধ (৳)', _dueRepaidCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('উর্ধ্বতন এয়ানত (৳)', _seniorEyanatCtrl)), const SizedBox(width: 8), Expanded(child: _numField('ধার্যকৃত (৳)', _assignedAmountCtrl))]),
        ],
      ),
    );
  }

  // ------------------------------------
  // ৮-৯. প্রকাশনা ও ছাত্রকল্যাণ ট্যাব
  // ------------------------------------
  Widget _buildPubWelfareTab(Color textColor, Color cardBg, Color borderColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('৮. প্রকাশনা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          const SizedBox(height: 10),
          Row(children: [Expanded(child: _numField('মোট ক্রয় (৳)', _pubPurchaseCtrl)), const SizedBox(width: 8), Expanded(child: _numField('পরিশোধ (৳)', _pubRepaidCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('বকেয়া (৳)', _pubDueCtrl)), const SizedBox(width: 8), Expanded(child: _numField('বকেয়া পরিশোধ (৳)', _pubDueRepaidCtrl))]),

          const SizedBox(height: 24),
          Text('৯. ছাত্রকল্যাণ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          const SizedBox(height: 10),
          Row(children: [Expanded(child: _numField('মোট আয় (৳)', _welfareIncomeCtrl)), const SizedBox(width: 8), Expanded(child: _numField('মোট ব্যয় (৳)', _welfareExpenseCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('লজিং', _lodgingCtrl)), const SizedBox(width: 6), Expanded(child: _numField('টি টিউশনি', _tuitionCtrl)), const SizedBox(width: 6), Expanded(child: _numField('টি টেবিল ব্যাংক', _tableBankCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('নোট বিলি (টি)', _questionNoteCtrl)), const SizedBox(width: 8), Expanded(child: _numField('যাকাত সংগ্রহ (৳)', _zakatCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('ল্যাঙ্গুয়েজ লাইব্রেরি বই বৃদ্ধি', _langLibBookBridhiCtrl)), const SizedBox(width: 8), Expanded(child: _numField('একাডেমিক কোচিং', _academicCoachingCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('ফ্রি কোচিং/আবাসন (টি)', _freeCoachingCountCtrl)), const SizedBox(width: 6), Expanded(child: _numField('জন', _freeCoachingPersonsCtrl)), const SizedBox(width: 6), Expanded(child: _numField('বৃদ্ধি', _freeCoachingBridhiCtrl)), const SizedBox(width: 6), Expanded(child: _numField('ঘাটতি', _freeCoachingDeficitCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('স্টাইপেন্ড চালুকৃত', _stipendCtrl)), const SizedBox(width: 8), Expanded(child: _numField('রক্তদান (ব্যাগ)', _bloodBagsCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('ভর্তি গাইড প্রকাশ/সহযোগিতা', _admissionGuideCtrl)), const SizedBox(width: 8), Expanded(child: _numField('ভর্তিকালীন সহায়তা (জন)', _admissionHelpPersonsCtrl))]),
          const SizedBox(height: 8),
          _textField('অন্যান্য বিবরণ', _otherWelfareCtrl),
          const SizedBox(height: 8),
          _textField('সফর বিবরণ', _tourCtrl),
        ],
      ),
    );
  }

  // ------------------------------------
  // ১০-১১. যোগাযোগ ও মন্তব্য ট্যাব
  // ------------------------------------
  Widget _buildCommRemarksTab(Color textColor, Color cardBg, Color borderColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('১০. যোগাযোগ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          const SizedBox(height: 10),
          Row(children: [Expanded(child: _numField('সার্কুলার প্রাপ্ত', _circularRecCountCtrl)), const SizedBox(width: 8), Expanded(child: _numField('কপি সংখ্যা', _circularRecCopiesCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('সার্কুলার প্রেরিত', _circularSentCountCtrl)), const SizedBox(width: 8), Expanded(child: _numField('কপি সংখ্যা', _circularSentCopiesCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('চিঠি প্রাপ্ত', _letterRecCountCtrl)), const SizedBox(width: 8), Expanded(child: _numField('কপি সংখ্যা', _letterRecCopiesCtrl))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _numField('চিঠি প্রেরিত', _letterSentCountCtrl)), const SizedBox(width: 8), Expanded(child: _numField('কপি সংখ্যা', _letterSentCopiesCtrl))]),

          const SizedBox(height: 24),
          Text('১১. অন্যান্য, বিবিধ ও মন্তব্য', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          const SizedBox(height: 10),
          _textField('অন্যান্য ছাত্র সংগঠনের তৎপরতা (আলাদা কাগজে)', _otherOrgCtrl, maxLines: 2),
          const SizedBox(height: 8),
          _textField('বিবিধ (আলাদা কাগজে)', _miscCtrl, maxLines: 2),
          const SizedBox(height: 8),
          _textField('মন্তব্য (গৃহীত পরিকল্পনার আলোকে, समस्या ও সম্ভাবনা উল্লেখ করে)', _remarksCtrl, maxLines: 4),
          const SizedBox(height: 8),
          _textField('সভাপতির স্বাক্ষরের তারিখ', _dateCtrl),
        ],
      ),
    );
  }

  Widget _numField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      enabled: !_isLocked,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      enabled: !_isLocked,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
