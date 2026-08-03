import 'package:flutter/material.dart';
import '../../../../common/widgets/unsaved_changes_guard.dart';
import '../../../../common/reports/data/services/report_storage_service.dart';
import '../../../../common/reports/presentation/screens/pdf_preview_screen.dart';
import '../../data/services/khelafat_branch_report_pdf_service.dart';

/// খেলাফত মজলিস — শাখার রিপোর্ট ফরম (Full-width edge-to-edge layout)
class BranchReportScreen extends StatefulWidget {
  final dynamic initialReport;
  final int? year;
  final int? month;

  const BranchReportScreen({
    super.key,
    this.initialReport,
    this.year,
    this.month,
  });

  @override
  State<BranchReportScreen> createState() => _BranchReportScreenState();
}

class _BranchReportScreenState extends State<BranchReportScreen> {
  final _formKey = GlobalKey<FormState>();

  // General Info
  final _shakhaNameController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  // 1. জনশক্তি
  final _sodossoCountController = TextEditingController();
  final _sodossoBridhiController = TextEditingController();
  final _sodossoBridhiReasonController = TextEditingController();
  final _sodossoGhattiController = TextEditingController();
  final _sodossoGhattiReasonController = TextEditingController();

  final _sodossoPrarthiCountController = TextEditingController();
  final _sodossoPrarthiBridhiController = TextEditingController();
  final _sodossoPrarthiBridhiReasonController = TextEditingController();
  final _sodossoPrarthiGhattiController = TextEditingController();
  final _sodossoPrarthiGhattiReasonController = TextEditingController();

  final _kormiCountController = TextEditingController();
  final _kormiBridhiController = TextEditingController();
  final _kormiGhattiController = TextEditingController();

  final _primaryMemberCountController = TextEditingController();
  final _primaryMemberBridhiController = TextEditingController();
  final _primaryMemberGhattiController = TextEditingController();

  final _totalManpowerCountController = TextEditingController();

  final _shudhiCountController = TextEditingController();
  final _shudhiBridhiController = TextEditingController();
  final _shudhiGhattiController = TextEditingController();

  // 2. দাওয়াত ও গণসংযোগ
  final _personalDawahCountController = TextEditingController();
  final _personalDawahPresenceController = TextEditingController();
  final _groupDawahCountController = TextEditingController();
  final _groupDawahPresenceController = TextEditingController();
  final _dawahMahfilCountController = TextEditingController();
  final _dawahMahfilPresenceController = TextEditingController();
  final _generalMeetingCountController = TextEditingController();
  final _generalMeetingPresenceController = TextEditingController();
  final _olamaMeetingCountController = TextEditingController();
  final _olamaMeetingPresenceController = TextEditingController();
  final _siratMahfilCountController = TextEditingController();
  final _siratMahfilPresenceController = TextEditingController();
  final _rallyCountController = TextEditingController();
  final _rallyPresenceController = TextEditingController();
  final _introDistCountController = TextEditingController();
  final _introDistEventController = TextEditingController();
  final _leafletDistCountController = TextEditingController();
  final _leafletDistEventController = TextEditingController();
  final _posterCountController = TextEditingController();
  final _posterEventController = TextEditingController();
  final _dayObservanceCountController = TextEditingController();
  final _dayObservanceNameController = TextEditingController();

  // 3. সংগঠন
  final _districtCountController = TextEditingController();
  final _districtOrgController = TextEditingController();
  final _upazilaCountController = TextEditingController();
  final _upazilaOrgController = TextEditingController();
  final _pourashavaCountController = TextEditingController();
  final _unionCountController = TextEditingController();
  final _wardCountController = TextEditingController();
  final _mosqueCountController = TextEditingController();

  // 4. সভাসমূহ
  final _distExecMeetingCountController = TextEditingController();
  final _distExecMeetingPresController = TextEditingController();
  final _distShuraMeetingCountController = TextEditingController();
  final _distShuraMeetingPresController = TextEditingController();
  final _thanaDaitoshilMeetingCountController = TextEditingController();
  final _thanaDaitoshilMeetingPresController = TextEditingController();
  final _kormiMeetingCountController = TextEditingController();
  final _kormiMeetingPresController = TextEditingController();

  // 5. বায়তুলমাল
  final _baytulmalIncomeController = TextEditingController();
  final _baytulmalExpenseController = TextEditingController();
  final _baytulmalQuotaController = TextEditingController();
  final _baytulmalPaidController = TextEditingController();

  // 6. সফর
  final _upperSafarCountController = TextEditingController();
  final _upperSafarDetailsController = TextEditingController();
  final _localSafarCountController = TextEditingController();
  final _localSafarDetailsController = TextEditingController();

  // 7. প্রশিক্ষণ
  final _torbiotMajlisCountController = TextEditingController();
  final _torbiotMajlisPresController = TextEditingController();
  final _torbiotMeetingCountController = TextEditingController();
  final _torbiotMeetingPresController = TextEditingController();
  final _shobgujariCountController = TextEditingController();
  final _shobgujariPresController = TextEditingController();
  final _familyTalimCountController = TextEditingController();
  final _familyTalimPresController = TextEditingController();

  // 8. দফতর, প্রচার ও প্রকাশনা
  final _circularRecCountController = TextEditingController();
  final _circularSendCountController = TextEditingController();
  final _pressReleaseCountController = TextEditingController();
  final _statementCountController = TextEditingController();

  // 9. পাঠাগার ও সমাজকল্যাণ
  final _bookCountController = TextEditingController();
  final _readerCountController = TextEditingController();
  final _medServiceController = TextEditingController();
  final _reliefSupportController = TextEditingController();

  final _commentsController = TextEditingController();

  bool _isSubmitting = false;
  bool _isLocked = false;
  bool _isLoading = false;
  bool _hasChanges = false;

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.month != null && widget.month! >= 1 && widget.month! <= 12) {
      _monthController.text = _monthNames[widget.month! - 1];
    }
    if (widget.year != null) {
      _yearController.text = widget.year.toString();
    }
    _loadSavedReport();
  }

  int _monthIndexFromName(String monthName) {
    final idx = _monthNames.indexOf(monthName.trim());
    return idx != -1 ? idx + 1 : DateTime.now().month;
  }

  Map<String, dynamic> _collectData() {
    return {
      'shakhaName': _shakhaNameController.text,
      'month': _monthController.text,
      'year': _yearController.text,
      'sodossoCount': _sodossoCountController.text,
      'sodossoBridhi': _sodossoBridhiController.text,
      'sodossoBridhiReason': _sodossoBridhiReasonController.text,
      'sodossoGhatti': _sodossoGhattiController.text,
      'sodossoGhattiReason': _sodossoGhattiReasonController.text,
      'sodossoPrarthiCount': _sodossoPrarthiCountController.text,
      'sodossoPrarthiBridhi': _sodossoPrarthiBridhiController.text,
      'sodossoPrarthiBridhiReason': _sodossoPrarthiBridhiReasonController.text,
      'sodossoPrarthiGhatti': _sodossoPrarthiGhattiController.text,
      'sodossoPrarthiGhattiReason': _sodossoPrarthiGhattiReasonController.text,
      'kormiCount': _kormiCountController.text,
      'kormiBridhi': _kormiBridhiController.text,
      'kormiGhatti': _kormiGhattiController.text,
      'primaryMemberCount': _primaryMemberCountController.text,
      'primaryMemberBridhi': _primaryMemberBridhiController.text,
      'primaryMemberGhatti': _primaryMemberGhattiController.text,
      'totalManpowerCount': _totalManpowerCountController.text,
      'shudhiCount': _shudhiCountController.text,
      'shudhiBridhi': _shudhiBridhiController.text,
      'shudhiGhatti': _shudhiGhattiController.text,
      'personalDawahCount': _personalDawahCountController.text,
      'personalDawahPresence': _personalDawahPresenceController.text,
      'groupDawahCount': _groupDawahCountController.text,
      'groupDawahPresence': _groupDawahPresenceController.text,
      'dawahMahfilCount': _dawahMahfilCountController.text,
      'dawahMahfilPresence': _dawahMahfilPresenceController.text,
      'generalMeetingCount': _generalMeetingCountController.text,
      'generalMeetingPresence': _generalMeetingPresenceController.text,
      'olamaMeetingCount': _olamaMeetingCountController.text,
      'olamaMeetingPresence': _olamaMeetingPresenceController.text,
      'siratMahfilCount': _siratMahfilCountController.text,
      'siratMahfilPresence': _siratMahfilPresenceController.text,
      'rallyCount': _rallyCountController.text,
      'rallyPresence': _rallyPresenceController.text,
      'introDistCount': _introDistCountController.text,
      'introDistEvent': _introDistEventController.text,
      'leafletDistCount': _leafletDistCountController.text,
      'leafletDistEvent': _leafletDistEventController.text,
      'posterCount': _posterCountController.text,
      'posterEvent': _posterEventController.text,
      'dayObservanceCount': _dayObservanceCountController.text,
      'dayObservanceName': _dayObservanceNameController.text,
      'districtCount': _districtCountController.text,
      'districtOrg': _districtOrgController.text,
      'upazilaCount': _upazilaCountController.text,
      'upazilaOrg': _upazilaOrgController.text,
      'pourashavaCount': _pourashavaCountController.text,
      'unionCount': _unionCountController.text,
      'wardCount': _wardCountController.text,
      'mosqueCount': _mosqueCountController.text,
      'distExecMeetingCount': _distExecMeetingCountController.text,
      'distExecMeetingPres': _distExecMeetingPresController.text,
      'distShuraMeetingCount': _distShuraMeetingCountController.text,
      'distShuraMeetingPres': _distShuraMeetingPresController.text,
      'thanaDaitoshilMeetingCount': _thanaDaitoshilMeetingCountController.text,
      'thanaDaitoshilMeetingPres': _thanaDaitoshilMeetingPresController.text,
      'kormiMeetingCount': _kormiMeetingCountController.text,
      'kormiMeetingPres': _kormiMeetingPresController.text,
      'baytulmalIncome': _baytulmalIncomeController.text,
      'baytulmalExpense': _baytulmalExpenseController.text,
      'baytulmalQuota': _baytulmalQuotaController.text,
      'baytulmalPaid': _baytulmalPaidController.text,
      'upperSafarCount': _upperSafarCountController.text,
      'upperSafarDetails': _upperSafarDetailsController.text,
      'localSafarCount': _localSafarCountController.text,
      'localSafarDetails': _localSafarDetailsController.text,
      'torbiotMajlisCount': _torbiotMajlisCountController.text,
      'torbiotMajlisPres': _torbiotMajlisPresController.text,
      'torbiotMeetingCount': _torbiotMeetingCountController.text,
      'torbiotMeetingPres': _torbiotMeetingPresController.text,
      'shobgujariCount': _shobgujariCountController.text,
      'shobgujariPres': _shobgujariPresController.text,
      'familyTalimCount': _familyTalimCountController.text,
      'familyTalimPres': _familyTalimPresController.text,
      'circularRecCount': _circularRecCountController.text,
      'circularSendCount': _circularSendCountController.text,
      'pressReleaseCount': _pressReleaseCountController.text,
      'statementCount': _statementCountController.text,
      'bookCount': _bookCountController.text,
      'readerCount': _readerCountController.text,
      'medService': _medServiceController.text,
      'reliefSupport': _reliefSupportController.text,
      'comments': _commentsController.text,
    };
  }

  Future<void> _loadSavedReport() async {
    final year = widget.year ?? int.tryParse(_yearController.text) ?? DateTime.now().year;
    final month = widget.month ?? _monthIndexFromName(_monthController.text);

    setState(() => _isLoading = true);
    final savedData = await ReportStorageService.getBranchReport(year, month);
    final data = savedData ?? (widget.initialReport is Map<String, dynamic> ? widget.initialReport as Map<String, dynamic> : null);

    if (data != null && mounted) {
      setState(() {
        if (data['shakhaName'] != null) _shakhaNameController.text = data['shakhaName'].toString();
        if (data['month'] != null) _monthController.text = data['month'].toString();
        if (data['year'] != null) _yearController.text = data['year'].toString();
        _sodossoCountController.text = data['sodossoCount']?.toString() ?? '';
        _sodossoBridhiController.text = data['sodossoBridhi']?.toString() ?? '';
        _sodossoBridhiReasonController.text = data['sodossoBridhiReason']?.toString() ?? '';
        _sodossoGhattiController.text = data['sodossoGhatti']?.toString() ?? '';
        _sodossoGhattiReasonController.text = data['sodossoGhattiReason']?.toString() ?? '';
        _sodossoPrarthiCountController.text = data['sodossoPrarthiCount']?.toString() ?? '';
        _sodossoPrarthiBridhiController.text = data['sodossoPrarthiBridhi']?.toString() ?? '';
        _sodossoPrarthiBridhiReasonController.text = data['sodossoPrarthiBridhiReason']?.toString() ?? '';
        _sodossoPrarthiGhattiController.text = data['sodossoPrarthiGhatti']?.toString() ?? '';
        _sodossoPrarthiGhattiReasonController.text = data['sodossoPrarthiGhattiReason']?.toString() ?? '';
        _kormiCountController.text = data['kormiCount']?.toString() ?? '';
        _kormiBridhiController.text = data['kormiBridhi']?.toString() ?? '';
        _kormiGhattiController.text = data['kormiGhatti']?.toString() ?? '';
        _primaryMemberCountController.text = data['primaryMemberCount']?.toString() ?? '';
        _primaryMemberBridhiController.text = data['primaryMemberBridhi']?.toString() ?? '';
        _primaryMemberGhattiController.text = data['primaryMemberGhatti']?.toString() ?? '';
        _totalManpowerCountController.text = data['totalManpowerCount']?.toString() ?? '';
        _shudhiCountController.text = data['shudhiCount']?.toString() ?? '';
        _shudhiBridhiController.text = data['shudhiBridhi']?.toString() ?? '';
        _shudhiGhattiController.text = data['shudhiGhatti']?.toString() ?? '';
        _personalDawahCountController.text = data['personalDawahCount']?.toString() ?? '';
        _personalDawahPresenceController.text = data['personalDawahPresence']?.toString() ?? '';
        _groupDawahCountController.text = data['groupDawahCount']?.toString() ?? '';
        _groupDawahPresenceController.text = data['groupDawahPresence']?.toString() ?? '';
        _dawahMahfilCountController.text = data['dawahMahfilCount']?.toString() ?? '';
        _dawahMahfilPresenceController.text = data['dawahMahfilPresence']?.toString() ?? '';
        _generalMeetingCountController.text = data['generalMeetingCount']?.toString() ?? '';
        _generalMeetingPresenceController.text = data['generalMeetingPresence']?.toString() ?? '';
        _olamaMeetingCountController.text = data['olamaMeetingCount']?.toString() ?? '';
        _olamaMeetingPresenceController.text = data['olamaMeetingPresence']?.toString() ?? '';
        _siratMahfilCountController.text = data['siratMahfilCount']?.toString() ?? '';
        _siratMahfilPresenceController.text = data['siratMahfilPresence']?.toString() ?? '';
        _rallyCountController.text = data['rallyCount']?.toString() ?? '';
        _rallyPresenceController.text = data['rallyPresence']?.toString() ?? '';
        _introDistCountController.text = data['introDistCount']?.toString() ?? '';
        _introDistEventController.text = data['introDistEvent']?.toString() ?? '';
        _leafletDistCountController.text = data['leafletDistCount']?.toString() ?? '';
        _leafletDistEventController.text = data['leafletDistEvent']?.toString() ?? '';
        _posterCountController.text = data['posterCount']?.toString() ?? '';
        _posterEventController.text = data['posterEvent']?.toString() ?? '';
        _dayObservanceCountController.text = data['dayObservanceCount']?.toString() ?? '';
        _dayObservanceNameController.text = data['dayObservanceName']?.toString() ?? '';
        _districtCountController.text = data['districtCount']?.toString() ?? '';
        _districtOrgController.text = data['districtOrg']?.toString() ?? '';
        _upazilaCountController.text = data['upazilaCount']?.toString() ?? '';
        _upazilaOrgController.text = data['upazilaOrg']?.toString() ?? '';
        _pourashavaCountController.text = data['pourashavaCount']?.toString() ?? '';
        _unionCountController.text = data['unionCount']?.toString() ?? '';
        _wardCountController.text = data['wardCount']?.toString() ?? '';
        _mosqueCountController.text = data['mosqueCount']?.toString() ?? '';
        _distExecMeetingCountController.text = data['distExecMeetingCount']?.toString() ?? '';
        _distExecMeetingPresController.text = data['distExecMeetingPres']?.toString() ?? '';
        _distShuraMeetingCountController.text = data['distShuraMeetingCount']?.toString() ?? '';
        _distShuraMeetingPresController.text = data['distShuraMeetingPres']?.toString() ?? '';
        _thanaDaitoshilMeetingCountController.text = data['thanaDaitoshilMeetingCount']?.toString() ?? '';
        _thanaDaitoshilMeetingPresController.text = data['thanaDaitoshilMeetingPres']?.toString() ?? '';
        _kormiMeetingCountController.text = data['kormiMeetingCount']?.toString() ?? '';
        _kormiMeetingPresController.text = data['kormiMeetingPres']?.toString() ?? '';
        _baytulmalIncomeController.text = data['baytulmalIncome']?.toString() ?? '';
        _baytulmalExpenseController.text = data['baytulmalExpense']?.toString() ?? '';
        _baytulmalQuotaController.text = data['baytulmalQuota']?.toString() ?? '';
        _baytulmalPaidController.text = data['baytulmalPaid']?.toString() ?? '';
        _upperSafarCountController.text = data['upperSafarCount']?.toString() ?? '';
        _upperSafarDetailsController.text = data['upperSafarDetails']?.toString() ?? '';
        _localSafarCountController.text = data['localSafarCount']?.toString() ?? '';
        _localSafarDetailsController.text = data['localSafarDetails']?.toString() ?? '';
        _torbiotMajlisCountController.text = data['torbiotMajlisCount']?.toString() ?? '';
        _torbiotMajlisPresController.text = data['torbiotMajlisPres']?.toString() ?? '';
        _torbiotMeetingCountController.text = data['torbiotMeetingCount']?.toString() ?? '';
        _torbiotMeetingPresController.text = data['torbiotMeetingPres']?.toString() ?? '';
        _shobgujariCountController.text = data['shobgujariCount']?.toString() ?? '';
        _shobgujariPresController.text = data['shobgujariPres']?.toString() ?? '';
        _familyTalimCountController.text = data['familyTalimCount']?.toString() ?? '';
        _familyTalimPresController.text = data['familyTalimPres']?.toString() ?? '';
        _circularRecCountController.text = data['circularRecCount']?.toString() ?? '';
        _circularSendCountController.text = data['circularSendCount']?.toString() ?? '';
        _pressReleaseCountController.text = data['pressReleaseCount']?.toString() ?? '';
        _statementCountController.text = data['statementCount']?.toString() ?? '';
        _bookCountController.text = data['bookCount']?.toString() ?? '';
        _readerCountController.text = data['readerCount']?.toString() ?? '';
        _medServiceController.text = data['medService']?.toString() ?? '';
        _reliefSupportController.text = data['reliefSupport']?.toString() ?? '';
        _commentsController.text = data['comments']?.toString() ?? '';
        _hasChanges = false;
      });
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _saveReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      final year = widget.year ?? int.tryParse(_yearController.text) ?? DateTime.now().year;
      final month = widget.month ?? _monthIndexFromName(_monthController.text);
      final data = _collectData();
      await ReportStorageService.saveBranchReport(year, month, data);
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _hasChanges = false;
          _isLocked = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('শাখার রিপোর্ট সফলভাবে জমা দেওয়া হয়েছে!'),
            backgroundColor: Color(0xFF1B5E20),
          ),
        );
      }
      return true;
    }
    return false;
  }

  void _openPdfViewer() async {
    final pdfBytes = await KhelafatBranchReportPdfService.generatePdfBytes(
      _collectData(),
      shakhaName: _shakhaNameController.text,
      month: _monthController.text,
      year: _yearController.text,
    );
    if (mounted) {
      await PdfPreviewScreen.open(
        context,
        pdfBytes,
        'শাখার রিপোর্ট — ${_monthController.text} ${_yearController.text}',
      );
    }
  }

  @override
  void dispose() {
    _shakhaNameController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _sodossoCountController.dispose();
    _sodossoBridhiController.dispose();
    _sodossoBridhiReasonController.dispose();
    _sodossoGhattiController.dispose();
    _sodossoGhattiReasonController.dispose();
    _sodossoPrarthiCountController.dispose();
    _sodossoPrarthiBridhiController.dispose();
    _sodossoPrarthiBridhiReasonController.dispose();
    _sodossoPrarthiGhattiController.dispose();
    _sodossoPrarthiGhattiReasonController.dispose();
    _kormiCountController.dispose();
    _kormiBridhiController.dispose();
    _kormiGhattiController.dispose();
    _primaryMemberCountController.dispose();
    _primaryMemberBridhiController.dispose();
    _primaryMemberGhattiController.dispose();
    _totalManpowerCountController.dispose();
    _shudhiCountController.dispose();
    _shudhiBridhiController.dispose();
    _shudhiGhattiController.dispose();
    _personalDawahCountController.dispose();
    _personalDawahPresenceController.dispose();
    _groupDawahCountController.dispose();
    _groupDawahPresenceController.dispose();
    _dawahMahfilCountController.dispose();
    _dawahMahfilPresenceController.dispose();
    _generalMeetingCountController.dispose();
    _generalMeetingPresenceController.dispose();
    _olamaMeetingCountController.dispose();
    _olamaMeetingPresenceController.dispose();
    _siratMahfilCountController.dispose();
    _siratMahfilPresenceController.dispose();
    _rallyCountController.dispose();
    _rallyPresenceController.dispose();
    _introDistCountController.dispose();
    _introDistEventController.dispose();
    _leafletDistCountController.dispose();
    _leafletDistEventController.dispose();
    _posterCountController.dispose();
    _posterEventController.dispose();
    _dayObservanceCountController.dispose();
    _dayObservanceNameController.dispose();
    _districtCountController.dispose();
    _districtOrgController.dispose();
    _upazilaCountController.dispose();
    _upazilaOrgController.dispose();
    _pourashavaCountController.dispose();
    _unionCountController.dispose();
    _wardCountController.dispose();
    _mosqueCountController.dispose();
    _distExecMeetingCountController.dispose();
    _distExecMeetingPresController.dispose();
    _distShuraMeetingCountController.dispose();
    _distShuraMeetingPresController.dispose();
    _thanaDaitoshilMeetingCountController.dispose();
    _thanaDaitoshilMeetingPresController.dispose();
    _kormiMeetingCountController.dispose();
    _kormiMeetingPresController.dispose();
    _baytulmalIncomeController.dispose();
    _baytulmalExpenseController.dispose();
    _baytulmalQuotaController.dispose();
    _baytulmalPaidController.dispose();
    _upperSafarCountController.dispose();
    _upperSafarDetailsController.dispose();
    _localSafarCountController.dispose();
    _localSafarDetailsController.dispose();
    _torbiotMajlisCountController.dispose();
    _torbiotMajlisPresController.dispose();
    _torbiotMeetingCountController.dispose();
    _torbiotMeetingPresController.dispose();
    _shobgujariCountController.dispose();
    _shobgujariPresController.dispose();
    _familyTalimCountController.dispose();
    _familyTalimPresController.dispose();
    _circularRecCountController.dispose();
    _circularSendCountController.dispose();
    _pressReleaseCountController.dispose();
    _statementCountController.dispose();
    _bookCountController.dispose();
    _readerCountController.dispose();
    _medServiceController.dispose();
    _reliefSupportController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final appBarBg = isDark ? const Color(0xFF1E293B) : const Color(0xFF1B5E20);

    return UnsavedChangesGuard(
      hasUnsavedChanges: !_isLocked && _hasChanges,
      onSave: () async {
        return await _saveReport();
      },
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(
          title: const Text('শাখার রিপোর্ট ফরম'),
          backgroundColor: appBarBg,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B5E20)))
            : Column(
                children: [
                  // 📌 Sticky Top Action Bar (Does NOT scroll!)
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                              gradient: const LinearGradient(colors: [Color(0xFF0284C7), Color(0xFF38BDF8)]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: _openPdfViewer,
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

                  // 📜 Form Content (Scrolls under the sticky top bar)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // General Info Banner
                            _buildSectionBanner(
                              context,
                              title: 'সাধারণ তথ্য',
                              icon: Icons.info_outline_rounded,
                              badge: 'মৌলিক তথ্য',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Column(
                                children: [
                                  _buildInputField('শাখার নাম', _shakhaNameController, hintText: 'যেমন: ঢাকা মহানগরী শাখা...', isDark: isDark),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('মাস', _monthController, hintText: 'যেমন: জানুয়ারি', isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('সন / বছর', _yearController, hintText: 'যেমন: ২০২৬', isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 1. Manpower
                            _buildSectionBanner(
                              context,
                              title: '১. জনশক্তি',
                              icon: Icons.groups_rounded,
                              badge: 'জনশক্তি',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSubHeader('ক. সদস্য', isDark),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('বর্তমান সংখ্যা', _sodossoCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('বৃদ্ধি', _sodossoBridhiController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('ঘাটতি', _sodossoGhattiController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('ঘাটতির কারণ', _sodossoGhattiReasonController, hintText: 'কারণ লিখুন', isDark: isDark)),
                                    ],
                                  ),

                                  const SizedBox(height: 16),
                                  _buildSubHeader('খ. সদস্য প্রার্থী', isDark),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('বর্তমান সংখ্যা', _sodossoPrarthiCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('বৃদ্ধি', _sodossoPrarthiBridhiController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('ঘাটতি', _sodossoPrarthiGhattiController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('ঘাটতির কারণ', _sodossoPrarthiGhattiReasonController, hintText: 'কারণ লিখুন', isDark: isDark)),
                                    ],
                                  ),

                                  const SizedBox(height: 16),
                                  _buildSubHeader('গ. কর্মী ও প্রাথমিক সদস্য', isDark),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('কর্মী সংখ্যা', _kormiCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('কর্মী বৃদ্ধি', _kormiBridhiController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('প্রাথমিক সদস্য সংখ্যা', _primaryMemberCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('প্রাথমিক সদস্য বৃদ্ধি', _primaryMemberBridhiController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),

                                  const SizedBox(height: 16),
                                  _buildSubHeader('ঘ. মোট জনশক্তি ও সুধী', isDark),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('মোট জনশক্তি', _totalManpowerCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('সুধী সংখ্যা', _shudhiCountController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('সুধী বৃদ্ধি', _shudhiBridhiController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('সুধী ঘাটতি', _shudhiGhattiController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 2. Dawah
                            _buildSectionBanner(
                              context,
                              title: '২. দাওয়াত ও গণসংযোগ',
                              icon: Icons.campaign_rounded,
                              badge: 'কার্যক্রম',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('ব্যক্তিগত দাওয়াত (জন)', _personalDawahCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('উপস্থিতি (জন)', _personalDawahPresenceController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('গ্রুপ দাওয়াত (টি)', _groupDawahCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('উপস্থিতি (জন)', _groupDawahPresenceController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('দাওয়াতী মাহফিল (টি)', _dawahMahfilCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('উপস্থিতি (জন)', _dawahMahfilPresenceController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('সাধারণ সভা (টি)', _generalMeetingCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('উপস্থিতি (জন)', _generalMeetingPresenceController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('ওলামা সমাবেশ (টি)', _olamaMeetingCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('উপস্থিতি (জন)', _olamaMeetingPresenceController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('সিরাত মাহফিল (টি)', _siratMahfilCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('উপস্থিতি (জন)', _siratMahfilPresenceController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('র‍্যালি / মিছিল (টি)', _rallyCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('উপস্থিতি (জন)', _rallyPresenceController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('পরিচিতি বিতরণ (টি)', _introDistCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('অনুষ্ঠান সংখ্যা', _introDistEventController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('লিফলেট বিতরণ (টি)', _leafletDistCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('অনুষ্ঠান সংখ্যা', _leafletDistEventController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('পোস্টার সাটানো (টি)', _posterCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('দিবস পালন (টি)', _dayObservanceCountController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 3. Organization
                            _buildSectionBanner(
                              context,
                              title: '৩. সংগঠন',
                              icon: Icons.account_tree_rounded,
                              badge: 'অধস্তন শাখা',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('জেলা শাখা (টি)', _districtCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('সংগঠিত সংখ্যা', _districtOrgController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('উপজেলা/থানা শাখা (টি)', _upazilaCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('সংগঠিত সংখ্যা', _upazilaOrgController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('পৌরসভা শাখা (টি)', _pourashavaCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('ইউনিয়ন শাখা (টি)', _unionCountController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('ওয়ার্ড শাখা (টি)', _wardCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('মসজিদ কমিটি (টি)', _mosqueCountController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 4. Meetings
                            _buildSectionBanner(
                              context,
                              title: '৪. সভাসমূহ',
                              icon: Icons.meeting_room_rounded,
                              badge: 'বৈঠকসমূহ',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('জেলা নির্বাহী সভা (টি)', _distExecMeetingCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('উপস্থিতি (জন)', _distExecMeetingPresController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('জেলা শূরা সভা (টি)', _distShuraMeetingCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('উপস্থিতি (জন)', _distShuraMeetingPresController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('থানা দায়িত্বশীল বৈঠক (টি)', _thanaDaitoshilMeetingCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('উপস্থিতি (জন)', _thanaDaitoshilMeetingPresController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('কর্মী বৈঠক (টি)', _kormiMeetingCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('উপস্থিতি (জন)', _kormiMeetingPresController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 5. Baytulmal
                            _buildSectionBanner(
                              context,
                              title: '৫. বায়তুলমাল',
                              icon: Icons.account_balance_wallet_rounded,
                              badge: 'হিসাব',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('মোট আয় (টাকা)', _baytulmalIncomeController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('মোট ব্যয় (টাকা)', _baytulmalExpenseController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('কেন্দ্রীয় কোটা', _baytulmalQuotaController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('পরিশোধিত কোটা', _baytulmalPaidController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 6. Tour
                            _buildSectionBanner(
                              context,
                              title: '৬. সফর',
                              icon: Icons.directions_bus_rounded,
                              badge: 'সফর বিবরণ',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('উর্ধ্বতন সফর (টি)', _upperSafarCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('বিবরণ', _upperSafarDetailsController, hintText: 'বিবরণ লিখুন', isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('স্থানীয় সফর (টি)', _localSafarCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('বিবরণ', _localSafarDetailsController, hintText: 'বিবরণ লিখুন', isDark: isDark)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 7. Training
                            _buildSectionBanner(
                              context,
                              title: '৭. প্রশিক্ষণ',
                              icon: Icons.school_rounded,
                              badge: 'তরবিয়ত',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('তরবিয়তী মজলিস (টি)', _torbiotMajlisCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('উপস্থিতি (জন)', _torbiotMajlisPresController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('তরবিয়তী বৈঠক (টি)', _torbiotMeetingCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('উপস্থিতি (জন)', _torbiotMeetingPresController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('শবগুজারি (টি)', _shobgujariCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('উপস্থিতি (জন)', _shobgujariPresController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('পারিবারিক তালিম (টি)', _familyTalimCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('উপস্থিতি (জন)', _familyTalimPresController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 8. Dept & Media
                            _buildSectionBanner(
                              context,
                              title: '৮. দফতর, প্রচার ও প্রকাশনা',
                              icon: Icons.design_services_rounded,
                              badge: 'অন্যান্য',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('সার্কুলার গ্রহণ (টি)', _circularRecCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('সার্কুলার প্রেরণ (টি)', _circularSendCountController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('প্রেস বিজ্ঞপ্তি (টি)', _pressReleaseCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('বিবৃতি (টি)', _statementCountController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 9. Library & Welfare
                            _buildSectionBanner(
                              context,
                              title: '৯. পাঠাগার ও সমাজকল্যাণ',
                              icon: Icons.local_library_rounded,
                              badge: 'সমাজকল্যাণ',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('পাঠাগার বই সংখ্যা', _bookCountController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('পাঠক সংখ্যা', _readerCountController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _buildInputField('চিকিৎসা সেবা (জন)', _medServiceController, isNumber: true, isDark: isDark)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildInputField('ত্রাণ সহায়তা (জন)', _reliefSupportController, isNumber: true, isDark: isDark)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Comments
                            _buildSectionBanner(
                              context,
                              title: 'মন্তব্য ও পরামর্শ',
                              icon: Icons.rate_review_rounded,
                              badge: 'মতামত',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: _buildInputField(
                                'মন্তব্য (সমস্যা ও সম্ভাবনা উল্লেখসহ)',
                                _commentsController,
                                hintText: 'এখানে বিবরণ লিখুন...',
                                maxLines: 4,
                                isDark: isDark,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Submit Button Container
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isSubmitting ? null : _saveReport,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1B5E20),
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                        )
                                      : const Text(
                                          'জমা দিন',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSectionBanner(
    BuildContext context, {
    required String title,
    required IconData icon,
    String? badge,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    const primaryColor = Color(0xFF1B5E20);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: headerBg,
        border: Border(
          top: BorderSide(color: borderColor, width: 1),
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
    String? hintText,
    int maxLines = 1,
    required bool isDark,
  }) {
    final fieldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    const focusColor = Color(0xFF1B5E20);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: _isLocked,
          onChanged: (val) {
            if (!_isLocked && !_hasChanges) {
              setState(() => _hasChanges = true);
            }
          },
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: hintText ?? 'এখানে লিখুন',
            hintStyle: TextStyle(
              fontSize: 13,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
            filled: true,
            fillColor: fieldBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: focusColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
