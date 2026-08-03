import 'package:flutter/material.dart';
import '../../../../common/widgets/unsaved_changes_guard.dart';
import '../../../../common/reports/data/services/report_storage_service.dart';
import '../../../../common/reports/data/models/baytulmal_report_entry.dart';
import '../../../../common/reports/presentation/screens/pdf_preview_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/baytulmal_report/data/services/khelafat_baytulmal_pdf_service.dart';

class BaytulmalReportPage extends StatefulWidget {
  const BaytulmalReportPage({super.key});

  @override
  State<BaytulmalReportPage> createState() => _BaytulmalReportPageState();
}

class _BaytulmalReportPageState extends State<BaytulmalReportPage> {
  final _formKey = GlobalKey<FormState>();
  bool _hasChanges = false;
  bool _isSubmitting = false;
  bool _isLocked = false;
  bool _isLoading = false;

  final _branchController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  final _nirbahiSodossoIyanatController = TextEditingController();
  final _nirbahiSodossoSonkkhaController = TextEditingController();
  final _odhostonShakhaIyanatController = TextEditingController();
  final _shakhaSonkkhaController = TextEditingController();
  final _shudhiIyanatController = TextEditingController();
  final _shudhiSonkkhaController = TextEditingController();
  final _soforAayController = TextEditingController();
  final _prokashonaAayController = TextEditingController();
  final _ekkalinAayController = TextEditingController();
  final _motAayController = TextEditingController();
  final _bigotoMashUdbrittoController = TextEditingController();
  final _sorbomotAayController = TextEditingController();
  final _kothayAayController = TextEditingController();

  final _urdhotonIyanatPorishodhController = TextEditingController();
  final _mashikDharjokritoController = TextEditingController();
  final _officeVaraOBillController = TextEditingController();
  final _officeKhorochController = TextEditingController();
  final _soforBbayController = TextEditingController();
  final _jatayatController = TextEditingController();
  final _jogajogController = TextEditingController();
  final _procharController = TextEditingController();
  final _prokashonaBbayController = TextEditingController();
  final _diboshPalonController = TextEditingController();
  final _diboshNamController = TextEditingController();
  final _appayonController = TextEditingController();
  final _shobhaShomabeshController = TextEditingController();
  final _motBbayController = TextEditingController();
  final _udbrittoGhattiController = TextEditingController();
  final _kothayBbayController = TextEditingController();

  final _reportDateController = TextEditingController();
  final _baytulmalSompodokShakkhorController = TextEditingController();
  final _sobhapotiShakkhorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _yearController.text = now.year.toString();
    _monthController.text = now.month.toString().padLeft(2, '0');
    _loadCurrentReport();
  }

  Future<void> _loadCurrentReport() async {
    setState(() => _isLoading = true);
    final year = _yearController.text.trim().isEmpty ? DateTime.now().year.toString() : _yearController.text.trim();
    final month = _monthController.text.trim().isEmpty ? DateTime.now().month.toString().padLeft(2, '0') : _monthController.text.trim();
    final entry = await ReportStorageService.getBaytulmalReportEntry(year, month);
    if (entry != null && mounted) {
      _branchController.text = entry.branchName;
      _monthController.text = entry.month;
      _yearController.text = entry.year;
      _nirbahiSodossoSonkkhaController.text = entry.executiveMemberAyanat;
      _nirbahiSodossoIyanatController.text = entry.executiveMemberAyanatTaka;
      _shakhaSonkkhaController.text = entry.subBranchAyanat;
      _odhostonShakhaIyanatController.text = entry.subBranchAyanatTaka;
      _shudhiSonkkhaController.text = entry.suhridAyanat;
      _shudhiIyanatController.text = entry.suhridAyanatTaka;
      _soforAayController.text = entry.safarIncomeTaka;
      _prokashonaAayController.text = entry.prokashnaIncomeTaka;
      _ekkalinAayController.text = entry.onetimeIncomeTaka;
      _bigotoMashUdbrittoController.text = entry.previousBalance;
      _kothayAayController.text = entry.kothayAay;
      _urdhotonIyanatPorishodhController.text = entry.upwardAyanatTaka;
      _mashikDharjokritoController.text = entry.upwardAyanat;
      _officeVaraOBillController.text = entry.officeRentTaka;
      _officeKhorochController.text = entry.officeCostTaka;
      _soforBbayController.text = entry.safarExpenseTaka;
      _jatayatController.text = entry.transportTaka;
      _jogajogController.text = entry.communicationTaka;
      _procharController.text = entry.procharTaka;
      _prokashonaBbayController.text = entry.prokashnaExpenseTaka;
      _diboshPalonController.text = entry.dibosPatanTaka;
      _diboshNamController.text = entry.dibosPalan;
      _appayonController.text = entry.appayanTaka;
      _shobhaShomabeshController.text = entry.sovaTaka;
      _kothayBbayController.text = entry.kothayBbay;
      _reportDateController.text = entry.reportDate;
      _baytulmalSompodokShakkhorController.text = entry.baytulmalSecretary;
      _sobhapotiShakkhorController.text = entry.president;
      _recalculateTotals();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
        _hasChanges = false;
      });
    }
  }

  void _recalculateTotals() {
    double parse(String s) => double.tryParse(s.replaceAll(',', '')) ?? 0.0;
    double directIncome = parse(_nirbahiSodossoIyanatController.text) +
        parse(_odhostonShakhaIyanatController.text) +
        parse(_shudhiIyanatController.text) +
        parse(_soforAayController.text) +
        parse(_prokashonaAayController.text) +
        parse(_ekkalinAayController.text);
    double prevBal = parse(_bigotoMashUdbrittoController.text);
    double grandIncome = directIncome + prevBal;

    double totalExp = parse(_urdhotonIyanatPorishodhController.text) +
        parse(_officeVaraOBillController.text) +
        parse(_officeKhorochController.text) +
        parse(_soforBbayController.text) +
        parse(_jatayatController.text) +
        parse(_jogajogController.text) +
        parse(_procharController.text) +
        parse(_prokashonaBbayController.text) +
        parse(_diboshPalonController.text) +
        parse(_appayonController.text) +
        parse(_shobhaShomabeshController.text);

    double bal = grandIncome - totalExp;

    _motAayController.text = directIncome > 0 ? directIncome.toStringAsFixed(0) : '';
    _sorbomotAayController.text = grandIncome > 0 ? grandIncome.toStringAsFixed(0) : '';
    _motBbayController.text = totalExp > 0 ? totalExp.toStringAsFixed(0) : '';
    _udbrittoGhattiController.text = bal != 0 ? bal.toStringAsFixed(0) : '';
  }

  BaytulmalReportEntry _buildCurrentEntry() {
    return BaytulmalReportEntry(
      month: _monthController.text.trim(),
      year: _yearController.text.trim(),
      branchName: _branchController.text,
      executiveMemberAyanat: _nirbahiSodossoSonkkhaController.text,
      executiveMemberAyanatTaka: _nirbahiSodossoIyanatController.text,
      subBranchAyanat: _shakhaSonkkhaController.text,
      subBranchAyanatTaka: _odhostonShakhaIyanatController.text,
      suhridAyanat: _shudhiSonkkhaController.text,
      suhridAyanatTaka: _shudhiIyanatController.text,
      safarIncomeTaka: _soforAayController.text,
      prokashnaIncomeTaka: _prokashonaAayController.text,
      onetimeIncomeTaka: _ekkalinAayController.text,
      previousBalance: _bigotoMashUdbrittoController.text,
      kothayAay: _kothayAayController.text,
      upwardAyanatTaka: _urdhotonIyanatPorishodhController.text,
      upwardAyanat: _mashikDharjokritoController.text,
      officeRentTaka: _officeVaraOBillController.text,
      officeCostTaka: _officeKhorochController.text,
      safarExpenseTaka: _soforBbayController.text,
      transportTaka: _jatayatController.text,
      communicationTaka: _jogajogController.text,
      procharTaka: _procharController.text,
      prokashnaExpenseTaka: _prokashonaBbayController.text,
      dibosPatanTaka: _diboshPalonController.text,
      dibosPalan: _diboshNamController.text,
      appayanTaka: _appayonController.text,
      sovaTaka: _shobhaShomabeshController.text,
      kothayBbay: _kothayBbayController.text,
      reportDate: _reportDateController.text,
      baytulmalSecretary: _baytulmalSompodokShakkhorController.text,
      president: _sobhapotiShakkhorController.text,
    );
  }

  @override
  void dispose() {
    _branchController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _nirbahiSodossoIyanatController.dispose();
    _nirbahiSodossoSonkkhaController.dispose();
    _odhostonShakhaIyanatController.dispose();
    _shakhaSonkkhaController.dispose();
    _shudhiIyanatController.dispose();
    _shudhiSonkkhaController.dispose();
    _soforAayController.dispose();
    _prokashonaAayController.dispose();
    _ekkalinAayController.dispose();
    _motAayController.dispose();
    _bigotoMashUdbrittoController.dispose();
    _sorbomotAayController.dispose();
    _kothayAayController.dispose();
    _urdhotonIyanatPorishodhController.dispose();
    _mashikDharjokritoController.dispose();
    _officeVaraOBillController.dispose();
    _officeKhorochController.dispose();
    _soforBbayController.dispose();
    _jatayatController.dispose();
    _jogajogController.dispose();
    _procharController.dispose();
    _prokashonaBbayController.dispose();
    _diboshPalonController.dispose();
    _diboshNamController.dispose();
    _appayonController.dispose();
    _shobhaShomabeshController.dispose();
    _motBbayController.dispose();
    _udbrittoGhattiController.dispose();
    _kothayBbayController.dispose();
    _reportDateController.dispose();
    _baytulmalSompodokShakkhorController.dispose();
    _sobhapotiShakkhorController.dispose();
    super.dispose();
  }

  void _openPdfViewer() async {
    _recalculateTotals();
    final entry = _buildCurrentEntry();
    final pdfBytes = await KhelafatBaytulmalPdfService.generatePdfBytes(
      entry: entry,
      incomeInWords: _kothayAayController.text,
      expenseInWords: _kothayBbayController.text,
    );
    if (mounted) {
      await PdfPreviewScreen.open(
        context,
        pdfBytes,
        'বায়তুলমাল রিপোর্ট — ${_monthController.text} ${_yearController.text}',
      );
    }
  }

  Future<bool> _saveReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      _recalculateTotals();
      final entry = _buildCurrentEntry();
      await ReportStorageService.saveBaytulmalReportEntry(entry);
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _hasChanges = false;
          _isLocked = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('বায়তুলমাল রিপোর্ট সফলভাবে জমা দেওয়া হয়েছে!'),
            backgroundColor: Color(0xFF1B5E20),
          ),
        );
      }
      return true;
    }
    return false;
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
          title: const Text('বায়তুলমাল রিপোর্ট'),
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
                    // General Info
                    _buildSectionHeader(
                      context,
                      title: 'সাধারণ তথ্য',
                      icon: Icons.info_outline_rounded,
                      badge: 'মাসিক হিসাব',
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  children: [
                    _buildInputField('শাখা', _branchController, isDark: isDark),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('মাস', _monthController, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('সন / বছর', _yearController, isNumber: true, isDark: isDark)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Income Section
              _buildSectionHeader(
                context,
                title: 'আয় খাতসমূহ',
                icon: Icons.arrow_downward_rounded,
                badge: 'প্রাপ্তি',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildInputField('নির্বাহী সদস্য সংখ্যা', _nirbahiSodossoSonkkhaController, isNumber: true, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('নির্বাহী সদস্য এয়ানত (টাকা)', _nirbahiSodossoIyanatController, isNumber: true, isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('অধস্তন শাখা সংখ্যা', _shakhaSonkkhaController, isNumber: true, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('অধস্তন শাখা এয়ানত (টাকা)', _odhostonShakhaIyanatController, isNumber: true, isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('শুভাকাঙ্ক্ষী সংখ্যা', _shudhiSonkkhaController, isNumber: true, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('সুধী/শুভাকাঙ্ক্ষী এয়ানত', _shudhiIyanatController, isNumber: true, isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('সফর আয় (টাকা)', _soforAayController, isNumber: true, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('প্রকাশনা আয় (টাকা)', _prokashonaAayController, isNumber: true, isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('এককালীন আয় (টাকা)', _ekkalinAayController, isNumber: true, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('মোট আয় (টাকা)', _motAayController, isNumber: true, isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('বিগত মাসের উদ্বৃত্ত', _bigotoMashUdbrittoController, isNumber: true, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('সর্বমোট আয় (টাকা)', _sorbomotAayController, isNumber: true, isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildInputField('কথায় (আয়)', _kothayAayController, hintText: 'যেমন: দশ হাজার টাকা মাত্র', isDark: isDark),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Expense Section
              _buildSectionHeader(
                context,
                title: 'ব্যয় খাতসমূহ',
                icon: Icons.arrow_upward_rounded,
                badge: 'প্রদান',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildInputField('ঊর্ধ্বতন এয়ানত পরিশোধ', _urdhotonIyanatPorishodhController, isNumber: true, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('মাসিক ধার্যকৃত (টাকা)', _mashikDharjokritoController, isNumber: true, isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('অফিস ভাড়া ও বিল', _officeVaraOBillController, isNumber: true, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('অফিস খরচ (টাকা)', _officeKhorochController, isNumber: true, isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('সফর ব্যয় (টাকা)', _soforBbayController, isNumber: true, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('যাতায়াত (টাকা)', _jatayatController, isNumber: true, isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('যোগাযোগ (টাকা)', _jogajogController, isNumber: true, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('প্রচার খরচ (টাকা)', _procharController, isNumber: true, isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('প্রকাশনা ব্যয় (টাকা)', _prokashonaBbayController, isNumber: true, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('আপ্যায়ন খরচ (টাকা)', _appayonController, isNumber: true, isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('দিবস পালন (টাকা)', _diboshPalonController, isNumber: true, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('দিবসের নাম', _diboshNamController, hintText: 'দিবসের নাম লিখুন', isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('সভা/সমাবেশ বাস্তবায়ন', _shobhaShomabeshController, isNumber: true, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('মোট ব্যয় (টাকা)', _motBbayController, isNumber: true, isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('উদ্বৃত্ত/ঘাটতি (টাকা)', _udbrittoGhattiController, isNumber: true, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('কথায় (ব্যয়)', _kothayBbayController, hintText: 'কথায় লিখুন', isDark: isDark)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Signature Section
              _buildSectionHeader(
                context,
                title: 'স্বাক্ষর ও সত্যায়ন',
                icon: Icons.draw_rounded,
                badge: 'অনুমোদন',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  children: [
                    _buildInputField('তারিখ', _reportDateController, hintText: 'যেমন: ১৫/০১/২০২৬', isDark: isDark),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('বায়তুলমাল সম্পাদক', _baytulmalSompodokShakkhorController, hintText: 'স্বাক্ষর / নাম', isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('সভাপতি', _sobhapotiShakkhorController, hintText: 'স্বাক্ষর / নাম', isDark: isDark)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Submit Button
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
                    child: const Text(
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

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
    String? hintText,
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
