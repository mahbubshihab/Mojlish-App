import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/features/common/reports/data/models/baytulmal_report_entry.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';

/// বায়তুলমাল ও আর্থিক হিসাব স্ক্রিন (খেলাফত মজলিস) — Baytulmal Report Form matching demo form image
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

  late int _selectedYear;
  late int _selectedMonth;

  final _branchCtrl = TextEditingController();

  // আয় (Income)
  final _nirbahiIyanatCtrl = TextEditingController(text: '0');
  final _nirbahiCountCtrl = TextEditingController(text: '0');
  final _subBranchIyanatCtrl = TextEditingController(text: '0');
  final _subBranchCountCtrl = TextEditingController(text: '0');
  final _shudhiIyanatCtrl = TextEditingController(text: '0');
  final _shudhiCountCtrl = TextEditingController(text: '0');
  final _safarIncomeCtrl = TextEditingController(text: '0');
  final _publicationIncomeCtrl = TextEditingController(text: '0');
  final _oneTimeIncomeCtrl = TextEditingController(text: '0');
  final _previousBalanceCtrl = TextEditingController(text: '0');

  // ব্যয় (Expenses)
  final _upperIyanatPayCtrl = TextEditingController(text: '0');
  final _upperIyanatTargetCtrl = TextEditingController(text: '0');
  final _officeRentBillCtrl = TextEditingController(text: '0');
  final _officeCostCtrl = TextEditingController(text: '0');
  final _safarCostCtrl = TextEditingController(text: '0');
  final _transportCostCtrl = TextEditingController(text: '0');
  final _dawahCostCtrl = TextEditingController(text: '0');
  final _publicationCostCtrl = TextEditingController(text: '0');
  final _dayObservanceCostCtrl = TextEditingController(text: '0');
  final _entertainmentCostCtrl = TextEditingController(text: '0');
  final _meetingAssemblyCostCtrl = TextEditingController(text: '0');

  final _remarksCtrl = TextEditingController();
  final _secretarySignatureCtrl = TextEditingController();
  final _presidentSignatureCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = widget.year ?? now.year;
    _selectedMonth = widget.month ?? now.month;
  }

  double get _totalMonthlyIncome {
    return (double.tryParse(_nirbahiIyanatCtrl.text) ?? 0) +
        (double.tryParse(_subBranchIyanatCtrl.text) ?? 0) +
        (double.tryParse(_shudhiIyanatCtrl.text) ?? 0) +
        (double.tryParse(_safarIncomeCtrl.text) ?? 0) +
        (double.tryParse(_publicationIncomeCtrl.text) ?? 0) +
        (double.tryParse(_oneTimeIncomeCtrl.text) ?? 0);
  }

  double get _grandTotalIncome => _totalMonthlyIncome + (double.tryParse(_previousBalanceCtrl.text) ?? 0);

  double get _totalExpense {
    return (double.tryParse(_upperIyanatPayCtrl.text) ?? 0) +
        (double.tryParse(_officeRentBillCtrl.text) ?? 0) +
        (double.tryParse(_officeCostCtrl.text) ?? 0) +
        (double.tryParse(_safarCostCtrl.text) ?? 0) +
        (double.tryParse(_transportCostCtrl.text) ?? 0) +
        (double.tryParse(_dawahCostCtrl.text) ?? 0) +
        (double.tryParse(_publicationCostCtrl.text) ?? 0) +
        (double.tryParse(_dayObservanceCostCtrl.text) ?? 0) +
        (double.tryParse(_entertainmentCostCtrl.text) ?? 0) +
        (double.tryParse(_meetingAssemblyCostCtrl.text) ?? 0);
  }

  double get _netBalance => _grandTotalIncome - _totalExpense;

  String _bn(num n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.tryParse(c) ?? 0] ?? c).join();
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
      safarIncome: _safarIncomeCtrl.text,
      safarIncomeTaka: _safarIncomeCtrl.text,
      prokashnaIncome: _publicationIncomeCtrl.text,
      prokashnaIncomeTaka: _publicationIncomeCtrl.text,
      onetimeIncome: _oneTimeIncomeCtrl.text,
      onetimeIncomeTaka: _oneTimeIncomeCtrl.text,
      previousBalance: _previousBalanceCtrl.text,
      upwardAyanat: _upperIyanatTargetCtrl.text,
      upwardAyanatTaka: _upperIyanatPayCtrl.text,
      officeRent: _officeRentBillCtrl.text,
      officeRentTaka: _officeRentBillCtrl.text,
      officeCost: _officeCostCtrl.text,
      officeCostTaka: _officeCostCtrl.text,
      safarExpense: _safarCostCtrl.text,
      safarExpenseTaka: _safarCostCtrl.text,
      transport: _transportCostCtrl.text,
      transportTaka: _transportCostCtrl.text,
      communication: _dawahCostCtrl.text,
      communicationTaka: _dawahCostCtrl.text,
      prochar: _publicationCostCtrl.text,
      procharTaka: _publicationCostCtrl.text,
      prokashnaExpense: _publicationCostCtrl.text,
      prokashnaExpenseTaka: _publicationCostCtrl.text,
      dibosPalan: _dayObservanceCostCtrl.text,
      dibosPatanTaka: _dayObservanceCostCtrl.text,
      appayan: _entertainmentCostCtrl.text,
      appayanTaka: _entertainmentCostCtrl.text,
      sova: _meetingAssemblyCostCtrl.text,
      sovaTaka: _meetingAssemblyCostCtrl.text,
      remarks: _remarksCtrl.text,
    );

    // Save to memory storage & SharedPreferences
    await ReportStorageService.saveBaytulmalReportEntry(entry);

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('বায়তুলমাল রিপোর্ট সংরক্ষিত হয়েছে ✓', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
        final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);
        final textLight = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
        final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        const accentAmber = Color(0xFFD97706);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF162032) : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: textLight, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'শাখার বায়তুলমাল রিপোর্ট ফরম',
              style: TextStyle(color: accentAmber, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Icon(_isSaving ? Icons.sync : Icons.save_rounded, color: accentAmber),
                onPressed: _isSaving ? null : _save,
              ),
            ],
          ),
          body: AmbientBackgroundWidget(
            primaryAccent: accentAmber,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          const Text(
                            'খেলাফত মজলিস — শাখার বায়তুলমাল রিপোর্ট',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5, color: accentAmber),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _branchCtrl,
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

                    // 1. আয় (Income Table Card)
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

                    // 2. ব্যয় (Expense Table Card)
                    _buildSectionCard(
                      title: '২. ব্যয় হিসাব (টাকা)',
                      color: const Color(0xFFEF4444),
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textLight: textLight,
                      children: [
                        _buildRowInput('ঊর্ধ্বতন এয়ানত পরিশোধ', _upperIyanatPayCtrl, 'ধার্যকৃত', _upperIyanatTargetCtrl),
                        _buildSingleInput('অফিস ভাড়া ও বিল', _officeRentBillCtrl),
                        _buildSingleInput('অফিস খরচ', _officeCostCtrl),
                        _buildSingleInput('সফর খরচ', _safarCostCtrl),
                        _buildSingleInput('যোগাযোগ ও পরিবহন', _transportCostCtrl),
                        _buildSingleInput('দাওয়াত ও প্রোগ্রাম খরচ', _dawahCostCtrl),
                        _buildSingleInput('প্রকাশনা ও প্রচারণা', _publicationCostCtrl),
                        _buildSingleInput('দিবস পালন খরচ', _dayObservanceCostCtrl),
                        _buildSingleInput('আপ্যায়ন', _entertainmentCostCtrl),
                        _buildSingleInput('সভা / সমাবেশ খরচ', _meetingAssemblyCostCtrl),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('মোট ব্যয়:', style: TextStyle(fontWeight: FontWeight.bold, color: textLight)),
                            Text('৳ ${_bn(_totalExpense.toInt())}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF4444), fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // 3. নেট ব্যালেন্স (Net Balance Summary)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: accentAmber.withValues(alpha: 0.4)),
                        boxShadow: [
                          BoxShadow(color: accentAmber.withValues(alpha: 0.1), blurRadius: 10),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('অবশিষ্ট উদ্বৃত্ত / (ঘাটতি):',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: textLight, fontSize: 15)),
                              Text(
                                '৳ ${_bn(_netBalance.toInt())}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: _netBalance >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Signatures Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('দায়িত্বশীলদের স্বাক্ষর', style: TextStyle(fontWeight: FontWeight.bold, color: textLight)),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _secretarySignatureCtrl,
                            decoration: InputDecoration(
                              labelText: 'বায়তুলমাল সম্পাদক স্বাক্ষর/নাম',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _presidentSignatureCtrl,
                            decoration: InputDecoration(
                              labelText: 'সভাপতি স্বাক্ষর/নাম',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _save,
                        icon: const Icon(Icons.check_circle_outline_rounded),
                        label: const Text('সংরক্ষণ করুন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentAmber,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
      },
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
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRowInput(String label1, TextEditingController ctrl1, String label2, TextEditingController ctrl2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: ctrl1,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: label1,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: ctrl2,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: label2,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleInput(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          isDense: true,
        ),
      ),
    );
  }
}
