import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/widgets/pdf_viewer_screen.dart';
import 'package:mojlish_app/features/common/reports/data/models/baytulmal_report_entry.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';
import 'package:mojlish_app/features/khelafat_majlis/baytulmal_report/data/services/khelafat_baytulmal_pdf_service.dart';

/// খেলাফত মজলিস — বায়তুলমাল রিপোর্ট ফরম (আধুনিক ডিজাইন ও ফিচারের নিজস্ব সেবা)
class BaytulmalReportScreen extends StatefulWidget {
  final int? year;
  final int? month;

  const BaytulmalReportScreen({super.key, this.year, this.month});

  @override
  State<BaytulmalReportScreen> createState() => _BaytulmalReportScreenState();
}

class _BaytulmalReportScreenState extends State<BaytulmalReportScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  bool _isLocked = false;
  bool _isLoading = true;

  late int _selectedYear;
  late int _selectedMonth;

  final _branchCtrl = TextEditingController();
  final _nirbahiCountCtrl = TextEditingController();
  final _nirbahiIyanatCtrl = TextEditingController();
  final _subBranchCountCtrl = TextEditingController();
  final _subBranchIyanatCtrl = TextEditingController();
  final _shudhiCountCtrl = TextEditingController();
  final _shudhiIyanatCtrl = TextEditingController();
  final _safarIncomeCtrl = TextEditingController();
  final _publicationIncomeCtrl = TextEditingController();
  final _oneTimeIncomeCtrl = TextEditingController();
  final _previousBalanceCtrl = TextEditingController();

  final _upperIyanatCtrl = TextEditingController();
  final _officeRentCtrl = TextEditingController();
  final _officeExpenseCtrl = TextEditingController();
  final _transportExpenseCtrl = TextEditingController();
  final _dawahExpenseCtrl = TextEditingController();
  final _publicationExpenseCtrl = TextEditingController();
  final _dayObservanceExpenseCtrl = TextEditingController();
  final _entertainmentExpenseCtrl = TextEditingController();
  final _meetingAssemblyCostCtrl = TextEditingController();

  final _takaInWordsCtrl = TextEditingController();

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = widget.year ?? now.year;
    _selectedMonth = widget.month ?? now.month;
    _loadReport();
  }

  @override
  void dispose() {
    for (var c in [
      _branchCtrl, _nirbahiCountCtrl, _nirbahiIyanatCtrl, _subBranchCountCtrl,
      _subBranchIyanatCtrl, _shudhiCountCtrl, _shudhiIyanatCtrl, _safarIncomeCtrl,
      _publicationIncomeCtrl, _oneTimeIncomeCtrl, _previousBalanceCtrl,
      _upperIyanatCtrl, _officeRentCtrl, _officeExpenseCtrl, _transportExpenseCtrl,
      _dawahExpenseCtrl, _publicationExpenseCtrl, _dayObservanceExpenseCtrl,
      _entertainmentExpenseCtrl, _meetingAssemblyCostCtrl, _takaInWordsCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadReport() async {
    final entry = await ReportStorageService.getBaytulmalReportEntry(
      _selectedYear.toString(),
      _selectedMonth.toString().padLeft(2, '0'),
    );
    if (entry != null && mounted) {
      setState(() {
        _branchCtrl.text = entry.branchName;
        _nirbahiCountCtrl.text = entry.executiveMemberAyanat;
        _nirbahiIyanatCtrl.text = entry.executiveMemberAyanatTaka;
        _subBranchCountCtrl.text = entry.subBranchAyanat;
        _subBranchIyanatCtrl.text = entry.subBranchAyanatTaka;
        _shudhiCountCtrl.text = entry.suhridAyanat;
        _shudhiIyanatCtrl.text = entry.suhridAyanatTaka;
        _safarIncomeCtrl.text = entry.safarIncomeTaka;
        _publicationIncomeCtrl.text = entry.prokashnaIncomeTaka;
        _oneTimeIncomeCtrl.text = entry.onetimeIncomeTaka;
        _previousBalanceCtrl.text = entry.previousBalance;
        _upperIyanatCtrl.text = entry.upwardAyanatTaka;
        _officeRentCtrl.text = entry.officeRentTaka;
        _officeExpenseCtrl.text = entry.officeCostTaka;
        _transportExpenseCtrl.text = entry.transportTaka;
        _dawahExpenseCtrl.text = entry.communicationTaka;
        _publicationExpenseCtrl.text = entry.prokashnaExpenseTaka;
        _dayObservanceExpenseCtrl.text = entry.dibosPatanTaka;
        _entertainmentExpenseCtrl.text = entry.appayanTaka;
        _meetingAssemblyCostCtrl.text = entry.sovaTaka;
        _takaInWordsCtrl.text = entry.remarks;
        _isLocked = true;
      });
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  double get _grandTotalIncome {
    return (double.tryParse(_nirbahiIyanatCtrl.text) ?? 0) +
        (double.tryParse(_subBranchIyanatCtrl.text) ?? 0) +
        (double.tryParse(_shudhiIyanatCtrl.text) ?? 0) +
        (double.tryParse(_safarIncomeCtrl.text) ?? 0) +
        (double.tryParse(_publicationIncomeCtrl.text) ?? 0) +
        (double.tryParse(_oneTimeIncomeCtrl.text) ?? 0) +
        (double.tryParse(_previousBalanceCtrl.text) ?? 0);
  }

  double get _totalExpense {
    return (double.tryParse(_upperIyanatCtrl.text) ?? 0) +
        (double.tryParse(_officeRentCtrl.text) ?? 0) +
        (double.tryParse(_officeExpenseCtrl.text) ?? 0) +
        (double.tryParse(_transportExpenseCtrl.text) ?? 0) +
        (double.tryParse(_dawahExpenseCtrl.text) ?? 0) +
        (double.tryParse(_publicationExpenseCtrl.text) ?? 0) +
        (double.tryParse(_dayObservanceExpenseCtrl.text) ?? 0) +
        (double.tryParse(_entertainmentExpenseCtrl.text) ?? 0) +
        (double.tryParse(_meetingAssemblyCostCtrl.text) ?? 0);
  }

  double get _netBalance => _grandTotalIncome - _totalExpense;

  String _bn(num n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) {
      final val = int.tryParse(c);
      return val != null ? digits[val] : c;
    }).join();
  }

  BaytulmalReportEntry _buildCurrentEntry() {
    return BaytulmalReportEntry(
      year: _selectedYear.toString(),
      month: _selectedMonth.toString().padLeft(2, '0'),
      branchName: _branchCtrl.text.trim(),
      executiveMemberAyanat: _nirbahiCountCtrl.text,
      executiveMemberAyanatTaka: _nirbahiIyanatCtrl.text,
      subBranchAyanat: _subBranchCountCtrl.text,
      subBranchAyanatTaka: _subBranchIyanatCtrl.text,
      suhridAyanat: _shudhiCountCtrl.text,
      suhridAyanatTaka: _shudhiIyanatCtrl.text,
      safarIncomeTaka: _safarIncomeCtrl.text,
      prokashnaIncomeTaka: _publicationIncomeCtrl.text,
      onetimeIncomeTaka: _oneTimeIncomeCtrl.text,
      previousBalance: _previousBalanceCtrl.text,
      upwardAyanatTaka: _upperIyanatCtrl.text,
      officeRentTaka: _officeRentCtrl.text,
      officeCostTaka: _officeExpenseCtrl.text,
      safarExpenseTaka: _transportExpenseCtrl.text,
      transportTaka: _transportExpenseCtrl.text,
      communicationTaka: _dawahExpenseCtrl.text,
      prokashnaExpenseTaka: _publicationExpenseCtrl.text,
      dibosPatanTaka: _dayObservanceExpenseCtrl.text,
      appayanTaka: _entertainmentExpenseCtrl.text,
      sovaTaka: _meetingAssemblyCostCtrl.text,
      remarks: _takaInWordsCtrl.text,
    );
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final entry = _buildCurrentEntry();
    await ReportStorageService.saveBaytulmalReportEntry(entry);
    setState(() {
      _isSaving = false;
      _isLocked = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('বায়তুলমাল তথ্য সফলভাবে সংরক্ষিত হয়েছে!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  void _openPdfViewer() {
    final yearStr = _bn(_selectedYear);
    final monthStr = _monthNames[_selectedMonth - 1];
    final entry = _buildCurrentEntry();

    PdfViewerScreen.open(
      context,
      title: 'বায়তুলমাল রিপোর্ট — $monthStr $yearStr',
      buildPdf: (format) => KhelafatBaytulmalPdfService.generatePdfBytes(
        entry: entry,
        incomeInWords: _takaInWordsCtrl.text,
        expenseInWords: _takaInWordsCtrl.text,
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
    const accentAmber = Color(0xFFD97706);
    const accentEmerald = Color(0xFF10B981);
    const accentBlue = Color(0xFF0284C7);

    final monthStr = _monthNames[_selectedMonth - 1];
    final yearStr = _bn(_selectedYear);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textLight, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'বায়তুলমাল — $monthStr $yearStr',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: accentAmber))
          : AmbientBackgroundWidget(
              primaryAccent: accentAmber,
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  children: [
                    // Top Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF059669), Color(0xFF10B981)],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: accentEmerald.withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: _isSaving ? null : _save,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _isSaving
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                          )
                                        : Icon(_isLocked ? Icons.edit_note_rounded : Icons.save_rounded, color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isLocked ? 'সম্পাদনা করুন' : 'সংরক্ষণ করুন',
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
                    const SizedBox(height: 14),

                    // Info Notice Banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: accentAmber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: accentAmber.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded, color: accentAmber, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'তথ্য সঠিকভার পূরণ করে সংরক্ষণ বাটনে চাপ দিন।',
                              style: TextStyle(color: textLight, fontSize: 12.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 1. শাখা তথ্য কার্ড
                    _buildSectionHeader(
                      title: 'খেলাফত মজলিস — বায়তুলমাল ফরম',
                      icon: Icons.account_balance_rounded,
                      color: accentAmber,
                      textLight: textLight,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            controller: _branchCtrl,
                            label: 'শাখার নাম',
                            hint: 'শাখার নাম ইনপুট দিন...',
                            icon: Icons.business_rounded,
                            isDark: isDark,
                            accentColor: accentAmber,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 2. আয় হিসাব সেকশন
                    _buildSectionHeader(
                      title: '১. আয় হিসাব (টাকা)',
                      icon: Icons.add_chart_rounded,
                      color: accentEmerald,
                      textLight: textLight,
                      trailingBadge: 'মোট আয়: ৳ ${_bn(_grandTotalIncome.toInt())}',
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: accentEmerald.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          _buildDualRow(
                            label: 'নির্বাহী সদস্যদের ইয়ানত',
                            takaCtrl: _nirbahiIyanatCtrl,
                            countCtrl: _nirbahiCountCtrl,
                            countSuffix: 'জন',
                            isDark: isDark,
                            accentColor: accentEmerald,
                          ),
                          const SizedBox(height: 14),
                          _buildDualRow(
                            label: 'অধস্তন শাখা ইয়ানত',
                            takaCtrl: _subBranchIyanatCtrl,
                            countCtrl: _subBranchCountCtrl,
                            countSuffix: 'টি',
                            isDark: isDark,
                            accentColor: accentEmerald,
                          ),
                          const SizedBox(height: 14),
                          _buildDualRow(
                            label: 'সুধী/শুভাকাঙ্ক্ষী ইয়ানত',
                            takaCtrl: _shudhiIyanatCtrl,
                            countCtrl: _shudhiCountCtrl,
                            countSuffix: 'জন',
                            isDark: isDark,
                            accentColor: accentEmerald,
                          ),
                          const SizedBox(height: 14),
                          _buildSingleRow(
                            label: 'সফর আয় (শাখা থেকে)',
                            ctrl: _safarIncomeCtrl,
                            hint: 'সফর আয় ইনপুট দিন...',
                            icon: Icons.card_travel_rounded,
                            isDark: isDark,
                            accentColor: accentEmerald,
                          ),
                          const SizedBox(height: 14),
                          _buildSingleRow(
                            label: 'প্রকাশনা আয়',
                            ctrl: _publicationIncomeCtrl,
                            hint: 'প্রকাশনা আয় ইনপুট দিন...',
                            icon: Icons.menu_book_rounded,
                            isDark: isDark,
                            accentColor: accentEmerald,
                          ),
                          const SizedBox(height: 14),
                          _buildSingleRow(
                            label: 'এককালীন আয়',
                            ctrl: _oneTimeIncomeCtrl,
                            hint: 'এককালীন আয় ইনপুট দিন...',
                            icon: Icons.savings_rounded,
                            isDark: isDark,
                            accentColor: accentEmerald,
                          ),
                          const SizedBox(height: 14),
                          _buildSingleRow(
                            label: 'বিগত মাস / সেশনের উদ্বৃত্ত (জের)',
                            ctrl: _previousBalanceCtrl,
                            hint: 'বিগত উদ্বৃত্ত ইনপুট দিন...',
                            icon: Icons.history_rounded,
                            isDark: isDark,
                            accentColor: accentEmerald,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3. ব্যয় হিসাব সেকশন
                    _buildSectionHeader(
                      title: '২. ব্যয় হিসাব (টাকা)',
                      icon: Icons.remove_circle_outline_rounded,
                      color: const Color(0xFFEF4444),
                      textLight: textLight,
                      trailingBadge: 'মোট ব্যয়: ৳ ${_bn(_totalExpense.toInt())}',
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          _buildSingleRow(
                            label: 'উর্ধ্বতন ইয়ানত পরিশোধ (মাসিক)',
                            ctrl: _upperIyanatCtrl,
                            hint: 'উর্ধ্বতন ইয়ানত পরিমাণ...',
                            icon: Icons.arrow_upward_rounded,
                            isDark: isDark,
                            accentColor: const Color(0xFFEF4444),
                          ),
                          const SizedBox(height: 14),
                          _buildSingleRow(
                            label: 'অফিস ভাড়া ও বিল',
                            ctrl: _officeRentCtrl,
                            hint: 'ভাড়া ও ইলেকট্রিক বিল...',
                            icon: Icons.home_work_rounded,
                            isDark: isDark,
                            accentColor: const Color(0xFFEF4444),
                          ),
                          const SizedBox(height: 14),
                          _buildSingleRow(
                            label: 'অফিস খরচ',
                            ctrl: _officeExpenseCtrl,
                            hint: 'দৈনন্দিন অফিস খরচ...',
                            icon: Icons.desk_rounded,
                            isDark: isDark,
                            accentColor: const Color(0xFFEF4444),
                          ),
                          const SizedBox(height: 14),
                          _buildSingleRow(
                            label: 'সফর খরচ',
                            ctrl: _transportExpenseCtrl,
                            hint: 'সফর ব্যয় ইনপুট দিন...',
                            icon: Icons.flight_takeoff_rounded,
                            isDark: isDark,
                            accentColor: const Color(0xFFEF4444),
                          ),
                          const SizedBox(height: 14),
                          _buildSingleRow(
                            label: 'যোগাযোগ ও মিডিয়া ব্যয়',
                            ctrl: _dawahExpenseCtrl,
                            hint: 'মোবাইল ও নেট বিল...',
                            icon: Icons.phone_android_rounded,
                            isDark: isDark,
                            accentColor: const Color(0xFFEF4444),
                          ),
                          const SizedBox(height: 14),
                          _buildSingleRow(
                            label: 'প্রকাশনা ব্যয়',
                            ctrl: _publicationExpenseCtrl,
                            hint: 'বই ও পোস্টার মুদ্রণ খরচ...',
                            icon: Icons.print_rounded,
                            isDark: isDark,
                            accentColor: const Color(0xFFEF4444),
                          ),
                          const SizedBox(height: 14),
                          _buildSingleRow(
                            label: 'দিবস পালন ব্যয়',
                            ctrl: _dayObservanceExpenseCtrl,
                            hint: 'জাতীয় ও প্রাতিষ্ঠানিক দিবস খরচ...',
                            icon: Icons.flag_rounded,
                            isDark: isDark,
                            accentColor: const Color(0xFFEF4444),
                          ),
                          const SizedBox(height: 14),
                          _buildSingleRow(
                            label: 'আপ্যায়ন খরচ',
                            ctrl: _entertainmentExpenseCtrl,
                            hint: 'নাস্তা ও অতিথি আপ্যায়ন...',
                            icon: Icons.coffee_rounded,
                            isDark: isDark,
                            accentColor: const Color(0xFFEF4444),
                          ),
                          const SizedBox(height: 14),
                          _buildSingleRow(
                            label: 'সভা/সমাবেশ বাস্তবায়ন খরচ',
                            ctrl: _meetingAssemblyCostCtrl,
                            hint: 'সম্মেলন ও সভা খরচ...',
                            icon: Icons.groups_rounded,
                            isDark: isDark,
                            accentColor: const Color(0xFFEF4444),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 4. হিসাবের সারসংক্ষেপ ও কথায় লেখা
                    _buildSectionHeader(
                      title: '৩. হিসাবের সারসংক্ষেপ',
                      icon: Icons.analytics_rounded,
                      color: accentAmber,
                      textLight: textLight,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow('সর্বমোট আয়', '৳ ${_bn(_grandTotalIncome.toInt())}', accentEmerald),
                          const Divider(height: 16),
                          _buildSummaryRow('সর্বমোট ব্যয়', '৳ ${_bn(_totalExpense.toInt())}', const Color(0xFFEF4444)),
                          const Divider(height: 16),
                          _buildSummaryRow('অবশিষ্ট জের (উদ্বৃত্ত / ঘাটতি)', '৳ ${_bn(_netBalance.toInt())}', _netBalance >= 0 ? accentEmerald : const Color(0xFFEF4444)),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _takaInWordsCtrl,
                            label: 'কথায় (সর্বমোট টাকা)',
                            hint: 'যেমন: পাঁচ হাজার টাকা মাত্র...',
                            icon: Icons.font_download_rounded,
                            isDark: isDark,
                            accentColor: accentAmber,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color color,
    required Color textLight,
    String? trailingBadge,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(color: textLight, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        if (trailingBadge != null) ...[
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Text(
              trailingBadge,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDualRow({
    required String label,
    required TextEditingController takaCtrl,
    required TextEditingController countCtrl,
    required String countSuffix,
    required bool isDark,
    required Color accentColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildInputField(
                controller: takaCtrl,
                hint: 'টাকা...',
                suffixText: '৳',
                icon: Icons.payments_rounded,
                isDark: isDark,
                accentColor: accentColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: _buildInputField(
                controller: countCtrl,
                hint: 'সংখ্যা...',
                suffixText: countSuffix,
                icon: Icons.people_outline_rounded,
                isDark: isDark,
                accentColor: accentColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSingleRow({
    required String label,
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    required bool isDark,
    required Color accentColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
          ),
        ),
        const SizedBox(height: 6),
        _buildInputField(
          controller: ctrl,
          hint: hint,
          suffixText: '৳',
          icon: icon,
          isDark: isDark,
          accentColor: accentColor,
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required String suffixText,
    required IconData icon,
    required bool isDark,
    required Color accentColor,
  }) {
    final fieldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final fieldBorder = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    final textColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: (_) => setState(() {}),
      style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 13),
        prefixIcon: Icon(icon, color: accentColor.withValues(alpha: 0.8), size: 18),
        suffixIcon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            suffixText,
            style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        filled: true,
        fillColor: fieldBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 1.8),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    required Color accentColor,
  }) {
    final fieldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final fieldBorder = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    final textColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          onChanged: (_) => setState(() {}),
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 13),
            prefixIcon: Icon(icon, color: accentColor, size: 18),
            filled: true,
            fillColor: fieldBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accentColor, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String title, String val, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        Text(
          val,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
