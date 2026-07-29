import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/widgets/pdf_viewer_screen.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/data/models/baytulmal_report_entry.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';

/// খেলাফত মজলিস — বায়তুলমাল রিপোর্ট ফরম (উপরে এডিট/সেভ ও ডাউনলোড বাটন + পৃথক টাইটেল ও ইনপুট ফিল্ড)
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
  final _presidentSigCtrl = TextEditingController();
  final _secretarySigCtrl = TextEditingController();

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
      _presidentSigCtrl, _secretarySigCtrl
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

  Future<void> _save() async {
    setState(() => _isSaving = true);

    final entry = BaytulmalReportEntry(
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
      transportTaka: _transportExpenseCtrl.text,
      communicationTaka: _dawahExpenseCtrl.text,
      prokashnaExpenseTaka: _publicationExpenseCtrl.text,
      dibosPatanTaka: _dayObservanceExpenseCtrl.text,
      appayanTaka: _entertainmentExpenseCtrl.text,
      sovaTaka: _meetingAssemblyCostCtrl.text,
      remarks: _takaInWordsCtrl.text,
    );

    await ReportStorageService.saveBaytulmalReportEntry(entry);
    setState(() {
      _isSaving = false;
      _isLocked = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('বায়তুলমাল রিপোর্ট সেভ ও লক করা হয়েছে ✓'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  void _openPdfViewer() {
    final yearStr = _bn(_selectedYear);
    final monthStr = _monthNames[_selectedMonth - 1];

    final entry = BaytulmalReportEntry(
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

    PdfViewerScreen.open(
      context,
      title: 'বায়তুলমাল রিপোর্ট — $monthStr $yearStr',
      buildPdf: (format) => PdfExportService.generateKhelafatBaytulmalPdfBytes(
        entry: entry,
        incomeInWords: _takaInWordsCtrl.text,
        expenseInWords: _takaInWordsCtrl.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final appBarBg = isDark ? const Color(0xFF162032) : Colors.white;
    final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);
    final textLight = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    const accentAmber = Color(0xFFD97706);

    final monthStr = _monthNames[_selectedMonth - 1];
    final yearStr = _bn(_selectedYear);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 1,
        title: Text(
          'বায়তুলমাল — $monthStr $yearStr',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF0284C7)),
            tooltip: 'PDF প্রিভিউ ও ডাউনলোড',
            onPressed: _openPdfViewer,
          ),
        ],
      ),
      body: AmbientBackgroundWidget(
        primaryAccent: accentAmber,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Action Bar with Save/Edit at the TOP!
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: _isLocked
                                  ? ElevatedButton.icon(
                                      onPressed: () => setState(() => _isLocked = false),
                                      icon: const Icon(Icons.edit_rounded, size: 18),
                                      label: const Text('সম্পাদনা (Edit)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFD97706),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    )
                                  : ElevatedButton.icon(
                                      onPressed: _isSaving ? null : _save,
                                      icon: const Icon(Icons.save_rounded, size: 18),
                                      label: Text(_isSaving ? 'সেভ হচ্ছে...' : 'সংরক্ষণ (Save)', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF059669),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: ElevatedButton.icon(
                                onPressed: _openPdfViewer,
                                icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                                label: const Text('PDF ডাউনলোড', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0284C7),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Lock Status Banner
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: _isLocked
                              ? const Color(0xFF0284C7).withValues(alpha: 0.12)
                              : const Color(0xFF059669).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _isLocked ? const Color(0xFF0284C7) : const Color(0xFF059669),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isLocked ? Icons.lock_rounded : Icons.edit_note_rounded,
                              color: _isLocked ? const Color(0xFF0284C7) : const Color(0xFF059669),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _isLocked
                                    ? '🔒 বায়তুলমাল হিসাব লকড অবস্থায় আছে। পরিবর্তন করতে ওপরে এডিটে চাপুন।'
                                    : '📝 তথ্য পূরণ করুন এবং ওপরে সংরক্ষণ বাটনে চাপ দিন।',
                                style: TextStyle(
                                  color: textLight,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Header card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBg.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'খেলাফত মজলিস — শাখার বায়তুলমাল রিপোর্ট',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5, color: accentAmber),
                            ),
                            const SizedBox(height: 14),
                            _buildSingleInput('শাখার নাম', _branchCtrl, textLight: textLight),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // 1. আয় (Income Card)
                      _buildSectionCard(
                        title: '১. আয় হিসাব (টাকা)',
                        color: const Color(0xFF10B981),
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textLight: textLight,
                        children: [
                          _buildRowInput('নির্বাহী সদস্যদের এয়ানত', _nirbahiIyanatCtrl, 'সংখ্যা', _nirbahiCountCtrl, textLight: textLight),
                          _buildRowInput('অধস্তন শাখা এয়ানত', _subBranchIyanatCtrl, 'সংখ্যা', _subBranchCountCtrl, textLight: textLight),
                          _buildRowInput('সুধী/শুভাকাঙ্ক্ষী এয়ানত', _shudhiIyanatCtrl, 'সংখ্যা', _shudhiCountCtrl, textLight: textLight),
                          _buildSingleInput('সফর আয় (শাখা থেকে)', _safarIncomeCtrl, textLight: textLight),
                          _buildSingleInput('প্রকাশনা আয়', _publicationIncomeCtrl, textLight: textLight),
                          _buildSingleInput('এককালীন আয়', _oneTimeIncomeCtrl, textLight: textLight),
                          _buildSingleInput('বিগত মাসের উদ্বৃত্ত', _previousBalanceCtrl, textLight: textLight),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('সর্বমোট আয়:', style: TextStyle(fontWeight: FontWeight.bold, color: textLight)),
                              Text('৳ ${_bn(_grandTotalIncome.toInt())}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981), fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // 2. ব্যয় (Expense Card)
                      _buildSectionCard(
                        title: '২. ব্যয় হিসাব (টাকা)',
                        color: const Color(0xFFEF4444),
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textLight: textLight,
                        children: [
                          _buildSingleInput('উর্ধ্বতন শাখা এয়ানত', _upperIyanatCtrl, textLight: textLight),
                          _buildSingleInput('অফিস ভাড়া ও বিল', _officeRentCtrl, textLight: textLight),
                          _buildSingleInput('দফতর খরচ', _officeExpenseCtrl, textLight: textLight),
                          _buildSingleInput('যাতায়াত খরচ', _transportExpenseCtrl, textLight: textLight),
                          _buildSingleInput('দাওয়াত ও গণসংযোগ ব্যয়', _dawahExpenseCtrl, textLight: textLight),
                          _buildSingleInput('প্রকাশনা ব্যয়', _publicationExpenseCtrl, textLight: textLight),
                          _buildSingleInput('দিবস পালন', _dayObservanceExpenseCtrl, textLight: textLight),
                          _buildSingleInput('আপ্যায়ন', _entertainmentExpenseCtrl, textLight: textLight),
                          _buildSingleInput('বৈঠক ও সমাবেশ ব্যয়', _meetingAssemblyCostCtrl, textLight: textLight),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('সর্বমোট ব্যয়:', style: TextStyle(fontWeight: FontWeight.bold, color: textLight)),
                              Text('৳ ${_bn(_totalExpense.toInt())}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF4444), fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Net balance card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBg.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _netBalance >= 0 ? const Color(0xFF10B981) : Colors.red),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('অবশিষ্ট জের (উদ্বৃত্ত/ঘাটতি):', style: TextStyle(fontWeight: FontWeight.bold, color: textLight, fontSize: 15)),
                            Text(
                              '৳ ${_bn(_netBalance.toInt())}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: _netBalance >= 0 ? const Color(0xFF10B981) : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Taka in words & signatures
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBg.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          children: [
                            _buildSingleInput('মোট অবশিষ্ট টাকা (কথায়)', _takaInWordsCtrl, textLight: textLight, isTaka: false),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSingleInput('বায়তুলমাল সম্পাদক স্বাক্ষর', _secretarySigCtrl, textLight: textLight, isTaka: false),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildSingleInput('সভাপতি স্বাক্ষর', _presidentSigCtrl, textLight: textLight, isTaka: false),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
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
    required Color borderColor,
    required Color textLight,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5, color: color)),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSingleInput(String label, TextEditingController ctrl, {required Color textLight, bool isTaka = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: textLight),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctrl,
            enabled: !_isLocked,
            keyboardType: isTaka ? TextInputType.number : TextInputType.text,
            onChanged: (_) => setState(() {}),
            style: TextStyle(fontSize: 14, color: textLight),
            decoration: InputDecoration(
              hintText: '$label ইনপুট দিন...',
              hintStyle: TextStyle(color: textLight.withValues(alpha: 0.4), fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              isDense: true,
              suffixText: isTaka ? 'টাকা' : null,
              filled: true,
              fillColor: _isLocked ? Colors.black.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.06),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowInput(String label, TextEditingController takaCtrl, String countLabel, TextEditingController countCtrl, {required Color textLight}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: textLight),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: takaCtrl,
                  enabled: !_isLocked,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(fontSize: 14, color: textLight),
                  decoration: InputDecoration(
                    hintText: 'টাকা...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    isDense: true,
                    suffixText: 'টাকা',
                    filled: true,
                    fillColor: _isLocked ? Colors.black.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  countLabel,
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: textLight),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: countCtrl,
                  enabled: !_isLocked,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 14, color: textLight),
                  decoration: InputDecoration(
                    hintText: 'সংখ্যা...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    isDense: true,
                    filled: true,
                    fillColor: _isLocked ? Colors.black.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
