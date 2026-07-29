import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/widgets/pdf_viewer_screen.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/data/models/baytulmal_report_entry.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';

/// খেলাফত মজলিস — বায়তুলমাল রিপোর্ট ফরম (সিঙ্গেল স্ক্রিন ফরম + ফুলস্ক্রিন জুমড PDF প্রিভিউ/ডাউনলোড)
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

    PdfViewerScreen.open(
      context,
      title: 'বায়তুলমাল রিপোর্ট — $monthStr $yearStr',
      buildPdf: (format) => PdfExportService.generateSingleFormPdfBytes(
        title: 'শাখার বায়তুলমাল রিপোর্ট ফরম',
        majlisName: 'বাংলাদেশ খেলাফত মজলিস',
        userName: _branchCtrl.text.isEmpty ? 'বায়তুলমাল সম্পাদক' : _branchCtrl.text,
        period: '$monthStr $yearStr',
        dataFields: {
          'শাখার নাম': _branchCtrl.text,
          'সর্বমোট আয়': '৳ ${_bn(_grandTotalIncome.toInt())}',
          'সর্বমোট ব্যয়': '৳ ${_bn(_totalExpense.toInt())}',
          'অবশিষ্ট জের (উদ্বৃত্ত)': '৳ ${_bn(_netBalance.toInt())}',
          'কথায় (মোট টাকা)': _takaInWordsCtrl.text,
          'বায়তুলমাল সম্পাদক স্বাক্ষর': _secretarySigCtrl.text,
          'সভাপতি স্বাক্ষর': _presidentSigCtrl.text,
        },
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
                      // Lock Status Banner
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isLocked
                              ? const Color(0xFF0284C7).withValues(alpha: 0.12)
                              : const Color(0xFF059669).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _isLocked ? const Color(0xFF0284C7) : const Color(0xFF059669),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isLocked ? Icons.lock_rounded : Icons.edit_note_rounded,
                              color: _isLocked ? const Color(0xFF0284C7) : const Color(0xFF059669),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _isLocked
                                    ? '🔒 বায়তুলমাল হিসাব সংরক্ষিত ও লকড অবস্থায় আছে।'
                                    : '📝 তথ্য পূরণ করুন এবং নিচে সংরক্ষণ বাটনে চাপ দিন।',
                                style: TextStyle(
                                  color: textLight,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Top Action Bar
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _openPdfViewer,
                              icon: const Icon(Icons.picture_as_pdf_rounded, size: 20),
                              label: const Text('PDF প্রিভিউ ও ডাউনলোড', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0284C7),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
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
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _branchCtrl,
                              enabled: !_isLocked,
                              decoration: InputDecoration(
                                labelText: 'শাখার নাম',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                isDense: true,
                              ),
                            ),
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
                          _buildRowInput('নির্বাহী সদস্যদের এয়ানত', _nirbahiIyanatCtrl, 'সংখ্যা', _nirbahiCountCtrl),
                          _buildRowInput('অধস্তন শাখা এয়ানত', _subBranchIyanatCtrl, 'সংখ্যা', _subBranchCountCtrl),
                          _buildRowInput('সুধী/শুভাকাঙ্ক্ষী এয়ানত', _shudhiIyanatCtrl, 'সংখ্যা', _shudhiCountCtrl),
                          _buildSingleInput('সফর আয় (শাখা থেকে)', _safarIncomeCtrl),
                          _buildSingleInput('প্রকাশনা আয়', _publicationIncomeCtrl),
                          _buildSingleInput('এককালীন আয়', _oneTimeIncomeCtrl),
                          _buildSingleInput('বিগত মাসের উদ্বৃত্ত', _previousBalanceCtrl),
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
                          _buildSingleInput('উর্ধ্বতন শাখা এয়ানত', _upperIyanatCtrl),
                          _buildSingleInput('অফিস ভাড়া ও বিল', _officeRentCtrl),
                          _buildSingleInput('দফতর খরচ', _officeExpenseCtrl),
                          _buildSingleInput('যাতায়াত খরচ', _transportExpenseCtrl),
                          _buildSingleInput('দাওয়াত ও গণসংযোগ ব্যয়', _dawahExpenseCtrl),
                          _buildSingleInput('প্রকাশনা ব্যয়', _publicationExpenseCtrl),
                          _buildSingleInput('দিবস পালন', _dayObservanceExpenseCtrl),
                          _buildSingleInput('আপ্যায়ন', _entertainmentExpenseCtrl),
                          _buildSingleInput('বৈঠক ও সমাবেশ ব্যয়', _meetingAssemblyCostCtrl),
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
                            TextFormField(
                              controller: _takaInWordsCtrl,
                              enabled: !_isLocked,
                              decoration: InputDecoration(
                                labelText: 'মোট অবশিষ্ট টাকা (কথায়)',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                isDense: true,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _secretarySigCtrl,
                                    enabled: !_isLocked,
                                    decoration: InputDecoration(
                                      labelText: 'বায়তুলমাল সম্পাদক স্বাক্ষর',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _presidentSigCtrl,
                                    enabled: !_isLocked,
                                    decoration: InputDecoration(
                                      labelText: 'সভাপতি স্বাক্ষর',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Save / Edit Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: _isLocked
                            ? ElevatedButton.icon(
                                onPressed: () => setState(() => _isLocked = false),
                                icon: const Icon(Icons.edit_rounded),
                                label: const Text('সম্পাদনা করুন (Edit)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD97706),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              )
                            : ElevatedButton.icon(
                                onPressed: _isSaving ? null : _save,
                                icon: const Icon(Icons.save_rounded),
                                label: Text(_isSaving ? 'সংরক্ষণ হচ্ছে...' : 'সংরক্ষণ করুন (Save)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF059669),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
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
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSingleInput(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: ctrl,
        enabled: !_isLocked,
        keyboardType: TextInputType.number,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
          suffixText: 'টাকা',
        ),
      ),
    );
  }

  Widget _buildRowInput(String label, TextEditingController takaCtrl, String countLabel, TextEditingController countCtrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: takaCtrl,
              enabled: !_isLocked,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
                suffixText: 'টাকা',
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: countCtrl,
              enabled: !_isLocked,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: countLabel,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
