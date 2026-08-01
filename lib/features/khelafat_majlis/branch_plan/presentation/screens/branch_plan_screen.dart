import 'package:flutter/material.dart';
import '../../../../common/widgets/unsaved_changes_guard.dart';
import '../../../../common/services/report_storage_service.dart';

/// খেলাফত মজলিস — শাখা পরিকল্পনা ফরম (Full-width edge-to-edge layout)
class KhelafatBranchPlanScreen extends StatefulWidget {
  final dynamic initialPlan;
  final int? year;
  final int? month;

  const KhelafatBranchPlanScreen({
    super.key,
    this.initialPlan,
    this.year,
    this.month,
  });

  @override
  State<KhelafatBranchPlanScreen> createState() => _KhelafatBranchPlanScreenState();
}

class _KhelafatBranchPlanScreenState extends State<KhelafatBranchPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  bool _isLocked = false;
  bool _isLoading = false;
  bool _hasChanges = false;

  // 1. General & Header
  final _shakhaNameCtrl = TextEditingController();
  final _monthCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();

  // 2. Manpower Targets
  final _sodossoTargetCtrl = TextEditingController();
  final _sodossoNamesCtrl = TextEditingController();
  final _sodossoPrarthiTargetCtrl = TextEditingController();
  final _sodossoPrarthiNamesCtrl = TextEditingController();
  final _kormiTargetCtrl = TextEditingController();
  final _kormiNamesCtrl = TextEditingController();
  final _primaryMemberTargetCtrl = TextEditingController();
  final _primaryMemberNamesCtrl = TextEditingController();
  final _totalManpowerTargetCtrl = TextEditingController();
  final _shudhiTargetCtrl = TextEditingController();
  final _shudhiNamesCtrl = TextEditingController();

  // 3. Dawah & Contact Plan
  final _personalDawahTargetCtrl = TextEditingController();
  final _groupDawahTargetCtrl = TextEditingController();
  final _dawahMahfilTargetCtrl = TextEditingController();
  final _generalMeetingTargetCtrl = TextEditingController();
  final _olamaMeetingTargetCtrl = TextEditingController();
  final _siratMahfilTargetCtrl = TextEditingController();
  final _rallyTargetCtrl = TextEditingController();
  final _introDistTargetCtrl = TextEditingController();
  final _leafletDistTargetCtrl = TextEditingController();
  final _posterTargetCtrl = TextEditingController();
  final _dayObservanceTargetCtrl = TextEditingController();

  // 4. Organization Units Plan
  final _districtTargetCtrl = TextEditingController();
  final _upazilaTargetCtrl = TextEditingController();
  final _pourashavaTargetCtrl = TextEditingController();
  final _unionTargetCtrl = TextEditingController();
  final _wardTargetCtrl = TextEditingController();
  final _mosqueTargetCtrl = TextEditingController();

  // 5. Meetings Plan
  final _distExecMeetingTargetCtrl = TextEditingController();
  final _distShuraMeetingTargetCtrl = TextEditingController();
  final _thanaDaitoshilMeetingTargetCtrl = TextEditingController();
  final _thanaExecMeetingTargetCtrl = TextEditingController();
  final _unionMeetingTargetCtrl = TextEditingController();
  final _wardMeetingTargetCtrl = TextEditingController();
  final _kormiMeetingTargetCtrl = TextEditingController();
  final _kormiConferenceTargetCtrl = TextEditingController();

  // 6. Baytulmal Plan
  final _baytulmalIncomeTargetCtrl = TextEditingController();
  final _baytulmalExpenseTargetCtrl = TextEditingController();
  final _baytulmalQuotaTargetCtrl = TextEditingController();
  final _shudhiBaytulmalTargetCtrl = TextEditingController();

  // 7. Travel Plan
  final _upperSafarTargetCtrl = TextEditingController();
  final _localSafarTargetCtrl = TextEditingController();

  // 8. Training Plan
  final _torbiotMajlisTargetCtrl = TextEditingController();
  final _torbiotMeetingTargetCtrl = TextEditingController();
  final _torbiotSafarTargetCtrl = TextEditingController();
  final _sodossoMeetingTargetCtrl = TextEditingController();
  final _shobgujariTargetCtrl = TextEditingController();
  final _samostikPathTargetCtrl = TextEditingController();
  final _quranEducTargetCtrl = TextEditingController();
  final _hadithPathTargetCtrl = TextEditingController();
  final _familyTalimTargetCtrl = TextEditingController();

  // 9. Department, Publicity, Library & Welfare Plan
  final _circularRecCtrl = TextEditingController();
  final _pressReleaseCtrl = TextEditingController();
  final _libraryTargetCtrl = TextEditingController();
  final _socialWelfareTargetCtrl = TextEditingController();
  final _commentsController = TextEditingController();

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.month != null && widget.month! >= 1 && widget.month! <= 12) {
      _monthCtrl.text = _monthNames[widget.month! - 1];
    }
    if (widget.year != null) {
      _yearCtrl.text = widget.year.toString();
    }
  }

  @override
  void dispose() {
    for (var c in [
      _shakhaNameCtrl, _monthCtrl, _yearCtrl,
      _sodossoTargetCtrl, _sodossoNamesCtrl, _sodossoPrarthiTargetCtrl, _sodossoPrarthiNamesCtrl,
      _kormiTargetCtrl, _kormiNamesCtrl, _primaryMemberTargetCtrl, _primaryMemberNamesCtrl,
      _totalManpowerTargetCtrl, _shudhiTargetCtrl, _shudhiNamesCtrl,
      _personalDawahTargetCtrl, _groupDawahTargetCtrl, _dawahMahfilTargetCtrl,
      _generalMeetingTargetCtrl, _olamaMeetingTargetCtrl, _siratMahfilTargetCtrl,
      _rallyTargetCtrl, _introDistTargetCtrl, _leafletDistTargetCtrl, _posterTargetCtrl, _dayObservanceTargetCtrl,
      _districtTargetCtrl, _upazilaTargetCtrl, _pourashavaTargetCtrl, _unionTargetCtrl, _wardTargetCtrl, _mosqueTargetCtrl,
      _distExecMeetingTargetCtrl, _distShuraMeetingTargetCtrl, _thanaDaitoshilMeetingTargetCtrl,
      _thanaExecMeetingTargetCtrl, _unionMeetingTargetCtrl, _wardMeetingTargetCtrl,
      _kormiMeetingTargetCtrl, _kormiConferenceTargetCtrl,
      _baytulmalIncomeTargetCtrl, _baytulmalExpenseTargetCtrl, _baytulmalQuotaTargetCtrl, _shudhiBaytulmalTargetCtrl,
      _upperSafarTargetCtrl, _localSafarTargetCtrl,
      _torbiotMajlisTargetCtrl, _torbiotMeetingTargetCtrl, _torbiotSafarTargetCtrl,
      _sodossoMeetingTargetCtrl, _shobgujariTargetCtrl, _samostikPathTargetCtrl,
      _quranEducTargetCtrl, _hadithPathTargetCtrl, _familyTalimTargetCtrl,
      _circularRecCtrl, _pressReleaseCtrl, _libraryTargetCtrl, _socialWelfareTargetCtrl, _commentsController
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String _bn(num n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) {
      final val = int.tryParse(c);
      return val != null ? digits[val] : c;
    }).join();
  }

  Future<bool> _savePlan() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      await Future.delayed(const Duration(milliseconds: 500));
      await ReportStorageService.saveBranchPlan({
        'shakhaName': _shakhaNameCtrl.text,
        'month': _monthCtrl.text,
        'year': _yearCtrl.text,
      });
      if (mounted) {
        setState(() {
          _isSaving = false;
          _hasChanges = false;
          _isLocked = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('পরিকল্পনা সফলভাবে সংরক্ষণ করা হয়েছে!'),
            backgroundColor: Color(0xFF1B5E20),
          ),
        );
      }
      return true;
    }
    return false;
  }

  void _openPdfViewer() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF ডাউনলোড প্রস্তুত করা হচ্ছে...'),
        backgroundColor: Color(0xFF0284C7),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final appBarBg = isDark ? const Color(0xFF1E293B) : const Color(0xFF1B5E20);

    final monthStr = widget.month != null ? _monthNames[widget.month! - 1] : '';
    final yearStr = widget.year != null ? _bn(widget.year!) : '';

    return UnsavedChangesGuard(
      hasUnsavedChanges: !_isLocked && _hasChanges,
      onSave: () async {
        return await _savePlan();
      },
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(
          backgroundColor: appBarBg,
          elevation: 0,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'শাখা পরিকল্পনা — $monthStr $yearStr',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B5E20)))
          : Column(
              children: [
                // Top Action Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isSaving ? null : () {
                            if (_isLocked) {
                              setState(() => _isLocked = false);
                            } else {
                              _savePlan();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: _isSaving
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Icon(_isLocked ? Icons.edit_note_rounded : Icons.save_rounded),
                          label: Text(_isLocked ? 'এডিট করুন' : 'সংরক্ষণ করুন'),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. General Info Banner
                          _buildSectionHeader(
                            context,
                            title: 'সাধারণ তথ্য',
                            icon: Icons.info_outline_rounded,
                            badge: 'মৌলিক',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Column(
                              children: [
                                _buildInputField(controller: _shakhaNameCtrl, label: 'শাখার নাম', hint: 'যেমন: ঢাকা মহানগরী শাখা...', icon: Icons.location_city_rounded, isDark: isDark),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _monthCtrl, label: 'মাস', hint: 'যেমন: জানুয়ারি', icon: Icons.calendar_month_rounded, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _yearCtrl, label: 'সন / বছর', hint: 'যেমন: ২০২৬', icon: Icons.numbers_rounded, isNumber: true, isDark: isDark)),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // 2. Manpower Targets Banner
                          _buildSectionHeader(
                            context,
                            title: '১. জনশক্তি লক্ষ্যমাত্রা',
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
                                    Expanded(child: _buildInputField(controller: _sodossoTargetCtrl, label: 'লক্ষ্যমাত্রা (জন)', hint: '০', icon: Icons.track_changes_rounded, suffix: 'জন', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _sodossoNamesCtrl, label: 'সম্ভাব্য নামসমূহ', hint: 'নাম লিখুন...', icon: Icons.badge_rounded, isDark: isDark)),
                                  ],
                                ),

                                const SizedBox(height: 16),
                                _buildSubHeader('খ. সদস্য প্রার্থী', isDark),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _sodossoPrarthiTargetCtrl, label: 'লক্ষ্যমাত্রা (জন)', hint: '০', icon: Icons.track_changes_rounded, suffix: 'জন', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _sodossoPrarthiNamesCtrl, label: 'সম্ভাব্য নামসমূহ', hint: 'নাম লিখুন...', icon: Icons.badge_rounded, isDark: isDark)),
                                  ],
                                ),

                                const SizedBox(height: 16),
                                _buildSubHeader('গ. কর্মী ও প্রাথমিক সদস্য', isDark),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _kormiTargetCtrl, label: 'কর্মী লক্ষ্যমাত্রা', hint: '০', icon: Icons.track_changes_rounded, suffix: 'জন', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _kormiNamesCtrl, label: 'কর্মী নামসমূহ', hint: 'নাম লিখুন...', icon: Icons.badge_rounded, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _primaryMemberTargetCtrl, label: 'প্রাথমিক সদস্য লক্ষ্য', hint: '০', icon: Icons.track_changes_rounded, suffix: 'জন', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _primaryMemberNamesCtrl, label: 'সম্ভাব্য নামসমূহ', hint: 'নাম লিখুন...', icon: Icons.badge_rounded, isDark: isDark)),
                                  ],
                                ),

                                const SizedBox(height: 16),
                                _buildSubHeader('ঘ. মোট জনশক্তি ও সুধী', isDark),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _totalManpowerTargetCtrl, label: 'মোট জনশক্তি লক্ষ্য', hint: '০', icon: Icons.groups_rounded, suffix: 'জন', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _shudhiTargetCtrl, label: 'সুধী লক্ষ্যমাত্রা', hint: '০', icon: Icons.person_add_alt_1_rounded, suffix: 'জন', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _buildInputField(controller: _shudhiNamesCtrl, label: 'সুধী সম্ভাব্য নামসমূহ', hint: 'নাম লিখুন...', icon: Icons.badge_rounded, isDark: isDark),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // 3. Dawah Plan Banner
                          _buildSectionHeader(
                            context,
                            title: '২. দাওয়াত ও গণসংযোগ পরিকল্পনা',
                            icon: Icons.campaign_rounded,
                            badge: 'কার্যক্রম',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _personalDawahTargetCtrl, label: 'ব্যক্তিগত দাওয়াত (জন)', hint: '০', icon: Icons.person_rounded, suffix: 'জন', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _groupDawahTargetCtrl, label: 'গ্রুপ দাওয়াত (টি)', hint: '০', icon: Icons.group_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _dawahMahfilTargetCtrl, label: 'দাওয়াতী মাহফিল (টি)', hint: '০', icon: Icons.event_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _generalMeetingTargetCtrl, label: 'সাধারণ সভা (টি)', hint: '০', icon: Icons.meeting_room_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _olamaMeetingTargetCtrl, label: 'ওলামা সমাবেশ (টি)', hint: '০', icon: Icons.school_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _siratMahfilTargetCtrl, label: 'সিরাত মাহফিল (টি)', hint: '০', icon: Icons.auto_stories_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _rallyTargetCtrl, label: 'র‍্যালি / মিছিল (টি)', hint: '০', icon: Icons.flag_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _introDistTargetCtrl, label: 'পরিচিতি বিতরণ (টি)', hint: '০', icon: Icons.contact_page_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _leafletDistTargetCtrl, label: 'লিফলেট বিতরণ (টি)', hint: '০', icon: Icons.description_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _posterTargetCtrl, label: 'পোস্টার সাটানো (টি)', hint: '০', icon: Icons.photo_size_select_actual_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _buildInputField(controller: _dayObservanceTargetCtrl, label: 'দিবস পালন (টি)', hint: '০', icon: Icons.today_rounded, suffix: 'টি', isNumber: true, isDark: isDark),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // 4. Organization Units Plan Banner
                          _buildSectionHeader(
                            context,
                            title: '৩. সংগঠন সম্প্রসারণ পরিকল্পনা',
                            icon: Icons.account_tree_rounded,
                            badge: 'অধস্তন শাখা',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _districtTargetCtrl, label: 'জেলা শাখা গঠন (টি)', hint: '০', icon: Icons.map_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _upazilaTargetCtrl, label: 'উপজেলা/থানা শাখা (টি)', hint: '০', icon: Icons.holiday_village_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _pourashavaTargetCtrl, label: 'পৌরসভা শাখা (টি)', hint: '০', icon: Icons.location_city_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _unionTargetCtrl, label: 'ইউনিয়ন শাখা (টি)', hint: '০', icon: Icons.home_work_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _wardTargetCtrl, label: 'ওয়ার্ড শাখা (টি)', hint: '০', icon: Icons.domain_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _mosqueTargetCtrl, label: 'মসজিদ কমিটি (টি)', hint: '০', icon: Icons.mosque_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // 5. Meetings Plan Banner
                          _buildSectionHeader(
                            context,
                            title: '৪. সভাসমূহ পরিকল্পনা',
                            icon: Icons.meeting_room_rounded,
                            badge: 'বৈঠকসমূহ',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _distExecMeetingTargetCtrl, label: 'জেলা নির্বাহী সভা (টি)', hint: '০', icon: Icons.gavel_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _distShuraMeetingTargetCtrl, label: 'জেলা শূরা সভা (টি)', hint: '০', icon: Icons.groups_2_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _thanaDaitoshilMeetingTargetCtrl, label: 'থানা দায়িত্বশীল বৈঠক (টি)', hint: '০', icon: Icons.assignment_ind_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _thanaExecMeetingTargetCtrl, label: 'থানা নির্বাহী সভা (টি)', hint: '০', icon: Icons.balance_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _unionMeetingTargetCtrl, label: 'ইউনিয়ন সভা (টি)', hint: '০', icon: Icons.storefront_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _wardMeetingTargetCtrl, label: 'ওয়ার্ড সভা (টি)', hint: '০', icon: Icons.house_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _kormiMeetingTargetCtrl, label: 'কর্মী বৈঠক (টি)', hint: '০', icon: Icons.people_outline_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _kormiConferenceTargetCtrl, label: 'কর্মী সম্মেলন (টি)', hint: '০', icon: Icons.diversity_3_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // 6. Baytulmal Plan Banner
                          _buildSectionHeader(
                            context,
                            title: '৫. বায়তুলমাল লক্ষ্যমাত্রা',
                            icon: Icons.account_balance_wallet_rounded,
                            badge: 'অর্থনৈতিক',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _baytulmalIncomeTargetCtrl, label: 'বায়তুলমাল আয় (টাকা)', hint: '০', icon: Icons.payments_rounded, suffix: '৳', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _baytulmalExpenseTargetCtrl, label: 'বায়তুলমাল ব্যয় (টাকা)', hint: '০', icon: Icons.receipt_long_rounded, suffix: '৳', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _baytulmalQuotaTargetCtrl, label: 'কেন্দ্রীয় কোটা (টাকা)', hint: '০', icon: Icons.account_balance_rounded, suffix: '৳', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _shudhiBaytulmalTargetCtrl, label: 'সুধী আয় লক্ষ্য (টাকা)', hint: '০', icon: Icons.savings_rounded, suffix: '৳', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // 7. Travel Plan Banner
                          _buildSectionHeader(
                            context,
                            title: '৬. সফর পরিকল্পনা',
                            icon: Icons.directions_bus_rounded,
                            badge: 'সফর',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Expanded(child: _buildInputField(controller: _upperSafarTargetCtrl, label: 'উর্ধ্বতন সফর (টি)', hint: '০', icon: Icons.flight_takeoff_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildInputField(controller: _localSafarTargetCtrl, label: 'স্থানীয় সফর (টি)', hint: '০', icon: Icons.commute_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // 8. Training Plan Banner
                          _buildSectionHeader(
                            context,
                            title: '৭. প্রশিক্ষণ পরিকল্পনা',
                            icon: Icons.school_rounded,
                            badge: 'তরবিয়ত',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _torbiotMajlisTargetCtrl, label: 'তরবিয়তী মজলিস (টি)', hint: '০', icon: Icons.menu_book_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _torbiotMeetingTargetCtrl, label: 'তরবিয়তী বৈঠক (টি)', hint: '০', icon: Icons.co_present_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _torbiotSafarTargetCtrl, label: 'তরবিয়তী সফর (টি)', hint: '০', icon: Icons.explore_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _sodossoMeetingTargetCtrl, label: 'সদস্য বৈঠক (টি)', hint: '০', icon: Icons.badge_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _shobgujariTargetCtrl, label: 'শবগুজারি (টি)', hint: '০', icon: Icons.bedtime_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _samostikPathTargetCtrl, label: 'সামষ্টিক পাঠ (টি)', hint: '০', icon: Icons.chrome_reader_mode_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _quranEducTargetCtrl, label: 'কুরআন শিক্ষা (টি)', hint: '০', icon: Icons.menu_book_sharp, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _hadithPathTargetCtrl, label: 'হাদীস পাঠ (টি)', hint: '০', icon: Icons.import_contacts_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _buildInputField(controller: _familyTalimTargetCtrl, label: 'পারিবারিক তালিম (টি)', hint: '০', icon: Icons.family_restroom_rounded, suffix: 'টি', isNumber: true, isDark: isDark),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // 9. Department & Others Plan Banner
                          _buildSectionHeader(
                            context,
                            title: '৮. দফতর, প্রচার, প্রকাশনা ও অন্যান্য',
                            icon: Icons.design_services_rounded,
                            badge: 'অন্যান্য',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _circularRecCtrl, label: 'সার্কুলার গ্রহণ (টি)', hint: '০', icon: Icons.mark_email_read_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _pressReleaseCtrl, label: 'প্রেস বিজ্ঞপ্তি (টি)', hint: '০', icon: Icons.newspaper_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField(controller: _libraryTargetCtrl, label: 'পাঠাগার বই লক্ষ্য', hint: '০', icon: Icons.collections_bookmark_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildInputField(controller: _socialWelfareTargetCtrl, label: 'সমাজকল্যাণ কাজ', hint: '০', icon: Icons.volunteer_activism_rounded, suffix: 'টি', isNumber: true, isDark: isDark)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _buildInputField(
                                  controller: _commentsController,
                                  label: 'মন্তব্য ও সুপারিশ',
                                  hint: 'বিবরণ লিখুন...',
                                  icon: Icons.comment_rounded,
                                  isDark: isDark,
                                  maxLines: 3,
                                ),
                              ],
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

  Widget _buildSectionHeader(
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? suffix,
    bool isNumber = false,
    required bool isDark,
    int maxLines = 1,
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
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
          readOnly: _isLocked,
          onChanged: (_) {
            if (!_isLocked && !_hasChanges) {
              setState(() => _hasChanges = true);
            } else {
              setState(() {});
            }
          },
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: hint,
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
