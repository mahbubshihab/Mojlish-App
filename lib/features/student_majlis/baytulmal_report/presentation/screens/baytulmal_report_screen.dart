import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/features/common/widgets/unsaved_changes_guard.dart';
import 'package:mojlish_app/features/common/services/report_storage_service.dart';
import 'package:mojlish_app/features/student_majlis/baytulmal_report/domain/entities/baytulmal_report_entity.dart';
import 'package:mojlish_app/features/student_majlis/baytulmal_report/data/models/baytulmal_report_model.dart';
import 'package:mojlish_app/features/student_majlis/baytulmal_report/data/services/student_baytulmal_pdf_service.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস — বায়তুলমাল রিপোর্ট এন্ট্রি স্ক্রিন
class BaytulmalReportScreen extends StatefulWidget {
  final String? initialMonth;
  final String? initialSession;

  const BaytulmalReportScreen({
    super.key,
    this.initialMonth,
    this.initialSession,
  });

  @override
  State<BaytulmalReportScreen> createState() => _BaytulmalReportScreenState();
}

class _BaytulmalReportScreenState extends State<BaytulmalReportScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _hasChanges = false;
  bool _isLoading = true;

  // Header Controllers
  final _branchController = TextEditingController(text: 'কেন্দ্রীয়');
  final _monthController = TextEditingController();
  final _sessionController = TextEditingController();

  // Fixed Income Controllers
  final _jonoshoktiTakaCtrl = TextEditingController();
  final _jonoshoktiPaisaCtrl = TextEditingController();
  final _shakhaTakaCtrl = TextEditingController();
  final _shakhaPaisaCtrl = TextEditingController();
  final _shuvakangkhiTakaCtrl = TextEditingController();
  final _shuvakangkhiPaisaCtrl = TextEditingController();
  final _ekkalinTakaCtrl = TextEditingController();
  final _ekkalinPaisaCtrl = TextEditingController();

  // 4 Dynamic Income Rows
  final List<TextEditingController> _customIncomeTitleCtrls =
      List.generate(4, (_) => TextEditingController());
  final List<TextEditingController> _customIncomeTakaCtrls =
      List.generate(4, (_) => TextEditingController());
  final List<TextEditingController> _customIncomePaisaCtrls =
      List.generate(4, (_) => TextEditingController());

  // Income Summary Controllers & States
  final _motAyInWordsController = TextEditingController();
  final _bigotoUdbrittoTakaCtrl = TextEditingController();
  final _bigotoUdbrittoPaisaCtrl = TextEditingController();

  // Fixed Expense Controllers
  final _urdhotonIyanotTakaCtrl = TextEditingController();
  final _urdhotonIyanotPaisaCtrl = TextEditingController();
  final _urdhotonSoforTakaCtrl = TextEditingController();
  final _urdhotonSoforPaisaCtrl = TextEditingController();
  final _officeTakaCtrl = TextEditingController();
  final _officePaisaCtrl = TextEditingController();
  final _jatayatTakaCtrl = TextEditingController();
  final _jatayatPaisaCtrl = TextEditingController();
  final _jogajogTakaCtrl = TextEditingController();
  final _jogajogPaisaCtrl = TextEditingController();
  final _procharTakaCtrl = TextEditingController();
  final _procharPaisaCtrl = TextEditingController();

  // 3 Dynamic Expense Rows
  final List<TextEditingController> _customExpenseTitleCtrls =
      List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> _customExpenseTakaCtrls =
      List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> _customExpensePaisaCtrls =
      List.generate(3, (_) => TextEditingController());

  // Expense Summary Controllers & States
  final _motBayInWordsController = TextEditingController();
  final _bigotoGhattiTakaCtrl = TextEditingController();
  final _bigotoGhattiPaisaCtrl = TextEditingController();
  final _presidentSignatureController = TextEditingController();

  // Live Auto-Calculated Totals
  double _motAy = 0;
  double _sorbomotAy = 0;
  double _motBay = 0;
  double _sorbomotBay = 0;
  double _udbrittoBaGhatti = 0;

  @override
  void initState() {
    super.initState();
    _monthController.text = widget.initialMonth ?? 'মহররম';
    _sessionController.text = widget.initialSession ?? '২০২৬';

    _attachListeners();
    _loadSavedData();
  }

  void _attachListeners() {
    void addL(TextEditingController c) {
      c.addListener(_onFieldChanged);
    }

    addL(_branchController);
    addL(_monthController);
    addL(_sessionController);

    addL(_jonoshoktiTakaCtrl);
    addL(_jonoshoktiPaisaCtrl);
    addL(_shakhaTakaCtrl);
    addL(_shakhaPaisaCtrl);
    addL(_shuvakangkhiTakaCtrl);
    addL(_shuvakangkhiPaisaCtrl);
    addL(_ekkalinTakaCtrl);
    addL(_ekkalinPaisaCtrl);

    for (int i = 0; i < 4; i++) {
      addL(_customIncomeTitleCtrls[i]);
      addL(_customIncomeTakaCtrls[i]);
      addL(_customIncomePaisaCtrls[i]);
    }

    addL(_motAyInWordsController);
    addL(_bigotoUdbrittoTakaCtrl);
    addL(_bigotoUdbrittoPaisaCtrl);

    addL(_urdhotonIyanotTakaCtrl);
    addL(_urdhotonIyanotPaisaCtrl);
    addL(_urdhotonSoforTakaCtrl);
    addL(_urdhotonSoforPaisaCtrl);
    addL(_officeTakaCtrl);
    addL(_officePaisaCtrl);
    addL(_jatayatTakaCtrl);
    addL(_jatayatPaisaCtrl);
    addL(_jogajogTakaCtrl);
    addL(_jogajogPaisaCtrl);
    addL(_procharTakaCtrl);
    addL(_procharPaisaCtrl);

    for (int i = 0; i < 3; i++) {
      addL(_customExpenseTitleCtrls[i]);
      addL(_customExpenseTakaCtrls[i]);
      addL(_customExpensePaisaCtrls[i]);
    }

    addL(_motBayInWordsController);
    addL(_bigotoGhattiTakaCtrl);
    addL(_bigotoGhattiPaisaCtrl);
    addL(_presidentSignatureController);
  }

  void _onFieldChanged() {
    _calculateTotals();
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  void _calculateTotals() {
    // Income calculation
    double incomeSum = _getAmount(_jonoshoktiTakaCtrl, _jonoshoktiPaisaCtrl) +
        _getAmount(_shakhaTakaCtrl, _shakhaPaisaCtrl) +
        _getAmount(_shuvakangkhiTakaCtrl, _shuvakangkhiPaisaCtrl) +
        _getAmount(_ekkalinTakaCtrl, _ekkalinPaisaCtrl);

    for (int i = 0; i < 4; i++) {
      incomeSum += _getAmount(_customIncomeTakaCtrls[i], _customIncomePaisaCtrls[i]);
    }

    double udbritto = _getAmount(_bigotoUdbrittoTakaCtrl, _bigotoUdbrittoPaisaCtrl);
    double totalIncome = incomeSum + udbritto;

    // Expense calculation
    double expenseSum = _getAmount(_urdhotonIyanotTakaCtrl, _urdhotonIyanotPaisaCtrl) +
        _getAmount(_urdhotonSoforTakaCtrl, _urdhotonSoforPaisaCtrl) +
        _getAmount(_officeTakaCtrl, _officePaisaCtrl) +
        _getAmount(_jatayatTakaCtrl, _jatayatPaisaCtrl) +
        _getAmount(_jogajogTakaCtrl, _jogajogPaisaCtrl) +
        _getAmount(_procharTakaCtrl, _procharPaisaCtrl);

    for (int i = 0; i < 3; i++) {
      expenseSum += _getAmount(_customExpenseTakaCtrls[i], _customExpensePaisaCtrls[i]);
    }

    double ghatti = _getAmount(_bigotoGhattiTakaCtrl, _bigotoGhattiPaisaCtrl);
    double totalExpense = expenseSum + ghatti;

    double balance = totalIncome - totalExpense;

    setState(() {
      _motAy = incomeSum;
      _sorbomotAy = totalIncome;
      _motBay = expenseSum;
      _sorbomotBay = totalExpense;
      _udbrittoBaGhatti = balance;
    });
  }

  double _getAmount(TextEditingController takaCtrl, TextEditingController paisaCtrl) {
    String takaStr = takaCtrl.text.trim();
    String paisaStr = paisaCtrl.text.trim();
    if (takaStr.isEmpty && paisaStr.isEmpty) return 0.0;

    String toEng(String str) {
      const bangla = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
      const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      for (int i = 0; i < 10; i++) {
        str = str.replaceAll(bangla[i], english[i]);
      }
      return str;
    }

    double taka = double.tryParse(toEng(takaStr)) ?? 0.0;
    double paisa = double.tryParse(toEng(paisaStr)) ?? 0.0;
    return taka + (paisa / 100.0);
  }

  void _setAmountToControllers(
      double amount, TextEditingController takaCtrl, TextEditingController paisaCtrl) {
    if (amount > 0) {
      final taka = amount.truncate();
      final paisa = ((amount - taka) * 100).round();
      takaCtrl.text = taka.toString();
      if (paisa > 0) {
        paisaCtrl.text = paisa.toString().padLeft(2, '0');
      }
    }
  }

  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJson = prefs.getString('report_storage_baytulmal_report') ??
          prefs.getString('report_storage_student_baytulmal_report');

      if (savedJson != null && savedJson.isNotEmpty) {
        final map = jsonDecode(savedJson) as Map<String, dynamic>;
        final model = BaytulmalReportModel.fromJson(map);

        _branchController.text = model.branch;
        if (model.month.isNotEmpty) _monthController.text = model.month;
        if (model.session.isNotEmpty) _sessionController.text = model.session;

        _setAmountToControllers(model.jonoshoktiIyanot, _jonoshoktiTakaCtrl, _jonoshoktiPaisaCtrl);
        _setAmountToControllers(model.shakhaIyanot, _shakhaTakaCtrl, _shakhaPaisaCtrl);
        _setAmountToControllers(model.shuvakangkhiIyanot, _shuvakangkhiTakaCtrl, _shuvakangkhiPaisaCtrl);
        _setAmountToControllers(model.ekkalinAy, _ekkalinTakaCtrl, _ekkalinPaisaCtrl);

        for (int i = 0; i < model.customIncomes.length && i < 4; i++) {
          _customIncomeTitleCtrls[i].text = model.customIncomes[i].title;
          _setAmountToControllers(model.customIncomes[i].amount,
              _customIncomeTakaCtrls[i], _customIncomePaisaCtrls[i]);
        }

        _motAyInWordsController.text = model.motAyInWords;
        _setAmountToControllers(
            model.bigotoSeshonMasherUdbritto, _bigotoUdbrittoTakaCtrl, _bigotoUdbrittoPaisaCtrl);

        _setAmountToControllers(model.urdhotonIyanotPorishodh,
            _urdhotonIyanotTakaCtrl, _urdhotonIyanotPaisaCtrl);
        _setAmountToControllers(
            model.urdhotonSofor, _urdhotonSoforTakaCtrl, _urdhotonSoforPaisaCtrl);
        _setAmountToControllers(model.office, _officeTakaCtrl, _officePaisaCtrl);
        _setAmountToControllers(model.jatayat, _jatayatTakaCtrl, _jatayatPaisaCtrl);
        _setAmountToControllers(model.jogajog, _jogajogTakaCtrl, _jogajogPaisaCtrl);
        _setAmountToControllers(model.prochar, _procharTakaCtrl, _procharPaisaCtrl);

        for (int i = 0; i < model.customExpenses.length && i < 3; i++) {
          _customExpenseTitleCtrls[i].text = model.customExpenses[i].title;
          _setAmountToControllers(model.customExpenses[i].amount,
              _customExpenseTakaCtrls[i], _customExpensePaisaCtrls[i]);
        }

        _motBayInWordsController.text = model.motBayInWords;
        _setAmountToControllers(
            model.bigotoSeshonMasherGhatti, _bigotoGhattiTakaCtrl, _bigotoGhattiPaisaCtrl);

        _presidentSignatureController.text = model.presidentSignature;
      }
    } catch (e) {
      debugPrint('Error loading baytulmal report: $e');
    } finally {
      _calculateTotals();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasChanges = false;
        });
      }
    }
  }

  BaytulmalReportEntity _buildEntityFromForm() {
    final double jonoshokti = _getAmount(_jonoshoktiTakaCtrl, _jonoshoktiPaisaCtrl);
    final double shakha = _getAmount(_shakhaTakaCtrl, _shakhaPaisaCtrl);
    final double shuvakangkhi = _getAmount(_shuvakangkhiTakaCtrl, _shuvakangkhiPaisaCtrl);
    final double ekkalin = _getAmount(_ekkalinTakaCtrl, _ekkalinPaisaCtrl);

    final List<BaytulmalItemEntity> customIncomes = [];
    for (int i = 0; i < 4; i++) {
      final title = _customIncomeTitleCtrls[i].text.trim();
      final amt = _getAmount(_customIncomeTakaCtrls[i], _customIncomePaisaCtrls[i]);
      if (title.isNotEmpty || amt > 0) {
        customIncomes.add(BaytulmalItemEntity(title: title, amount: amt));
      }
    }

    final double bigotoUdbritto = _getAmount(_bigotoUdbrittoTakaCtrl, _bigotoUdbrittoPaisaCtrl);

    final double urdhotonIyanot = _getAmount(_urdhotonIyanotTakaCtrl, _urdhotonIyanotPaisaCtrl);
    final double urdhotonSofor = _getAmount(_urdhotonSoforTakaCtrl, _urdhotonSoforPaisaCtrl);
    final double office = _getAmount(_officeTakaCtrl, _officePaisaCtrl);
    final double jatayat = _getAmount(_jatayatTakaCtrl, _jatayatPaisaCtrl);
    final double jogajog = _getAmount(_jogajogTakaCtrl, _jogajogPaisaCtrl);
    final double prochar = _getAmount(_procharTakaCtrl, _procharPaisaCtrl);

    final List<BaytulmalItemEntity> customExpenses = [];
    for (int i = 0; i < 3; i++) {
      final title = _customExpenseTitleCtrls[i].text.trim();
      final amt = _getAmount(_customExpenseTakaCtrls[i], _customExpensePaisaCtrls[i]);
      if (title.isNotEmpty || amt > 0) {
        customExpenses.add(BaytulmalItemEntity(title: title, amount: amt));
      }
    }

    final double bigotoGhatti = _getAmount(_bigotoGhattiTakaCtrl, _bigotoGhattiPaisaCtrl);

    return BaytulmalReportEntity(
      branch: _branchController.text,
      month: _monthController.text,
      session: _sessionController.text,
      jonoshoktiIyanot: jonoshokti,
      shakhaIyanot: shakha,
      shuvakangkhiIyanot: shuvakangkhi,
      ekkalinAy: ekkalin,
      customIncomes: customIncomes,
      motAy: _motAy,
      bigotoSeshonMasherUdbritto: bigotoUdbritto,
      sorbomotAy: _sorbomotAy,
      motAyInWords: _motAyInWordsController.text,
      urdhotonIyanotPorishodh: urdhotonIyanot,
      urdhotonSofor: urdhotonSofor,
      office: office,
      jatayat: jatayat,
      jogajog: jogajog,
      prochar: prochar,
      customExpenses: customExpenses,
      motBay: _motBay,
      bigotoSeshonMasherGhatti: bigotoGhatti,
      sorbomotBay: _sorbomotBay,
      udbrittoBaGhatti: _udbrittoBaGhatti,
      motBayInWords: _motBayInWordsController.text,
      presidentSignature: _presidentSignatureController.text,
    );
  }

  Future<bool> _saveReport() async {
    final entity = _buildEntityFromForm();
    final model = BaytulmalReportModel(
      branch: entity.branch,
      month: entity.month,
      session: entity.session,
      jonoshoktiIyanot: entity.jonoshoktiIyanot,
      shakhaIyanot: entity.shakhaIyanot,
      shuvakangkhiIyanot: entity.shuvakangkhiIyanot,
      ekkalinAy: entity.ekkalinAy,
      customIncomes: entity.customIncomes,
      motAy: entity.motAy,
      bigotoSeshonMasherUdbritto: entity.bigotoSeshonMasherUdbritto,
      sorbomotAy: entity.sorbomotAy,
      motAyInWords: entity.motAyInWords,
      urdhotonIyanotPorishodh: entity.urdhotonIyanotPorishodh,
      urdhotonSofor: entity.urdhotonSofor,
      office: entity.office,
      jatayat: entity.jatayat,
      jogajog: entity.jogajog,
      prochar: entity.prochar,
      customExpenses: entity.customExpenses,
      motBay: entity.motBay,
      bigotoSeshonMasherGhatti: entity.bigotoSeshonMasherGhatti,
      sorbomotBay: entity.sorbomotBay,
      udbrittoBaGhatti: entity.udbrittoBaGhatti,
      motBayInWords: entity.motBayInWords,
      presidentSignature: entity.presidentSignature,
    );

    await ReportStorageService.saveBaytulmalReport(model.toJson());

    if (mounted) {
      setState(() => _hasChanges = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('বায়তুলমাল রিপোর্ট সফলভাবে সংরক্ষণ করা হয়েছে'),
          backgroundColor: Color(0xFF059669),
        ),
      );
    }
    return true;
  }

  void _exportPdf() {
    final entity = _buildEntityFromForm();
    StudentBaytulmalPdfService.generateAndSharePdf(entity, context: context);
  }

  @override
  void dispose() {
    _branchController.dispose();
    _monthController.dispose();
    _sessionController.dispose();

    _jonoshoktiTakaCtrl.dispose();
    _jonoshoktiPaisaCtrl.dispose();
    _shakhaTakaCtrl.dispose();
    _shakhaPaisaCtrl.dispose();
    _shuvakangkhiTakaCtrl.dispose();
    _shuvakangkhiPaisaCtrl.dispose();
    _ekkalinTakaCtrl.dispose();
    _ekkalinPaisaCtrl.dispose();

    for (var c in _customIncomeTitleCtrls) {
      c.dispose();
    }
    for (var c in _customIncomeTakaCtrls) {
      c.dispose();
    }
    for (var c in _customIncomePaisaCtrls) {
      c.dispose();
    }

    _motAyInWordsController.dispose();
    _bigotoUdbrittoTakaCtrl.dispose();
    _bigotoUdbrittoPaisaCtrl.dispose();

    _urdhotonIyanotTakaCtrl.dispose();
    _urdhotonIyanotPaisaCtrl.dispose();
    _urdhotonSoforTakaCtrl.dispose();
    _urdhotonSoforPaisaCtrl.dispose();
    _officeTakaCtrl.dispose();
    _officePaisaCtrl.dispose();
    _jatayatTakaCtrl.dispose();
    _jatayatPaisaCtrl.dispose();
    _jogajogTakaCtrl.dispose();
    _jogajogPaisaCtrl.dispose();
    _procharTakaCtrl.dispose();
    _procharPaisaCtrl.dispose();

    for (var c in _customExpenseTitleCtrls) {
      c.dispose();
    }
    for (var c in _customExpenseTakaCtrls) {
      c.dispose();
    }
    for (var c in _customExpensePaisaCtrls) {
      c.dispose();
    }

    _motBayInWordsController.dispose();
    _bigotoGhattiTakaCtrl.dispose();
    _bigotoGhattiPaisaCtrl.dispose();
    _presidentSignatureController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final inputBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    const primaryAmber = Color(0xFFD97706);

    return UnsavedChangesGuard(
      hasUnsavedChanges: _hasChanges,
      onSave: _saveReport,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'বায়তুলমাল রিপোর্ট',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          elevation: 1,
          actions: [
            IconButton(
              icon: const Icon(Icons.save_rounded, color: Color(0xFF059669)),
              tooltip: 'সংরক্ষণ করুন',
              onPressed: _saveReport,
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf_rounded, color: primaryAmber),
              tooltip: 'PDF ডাউনলোড',
              onPressed: _exportPdf,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: primaryAmber))
            : AmbientBackgroundWidget(
                child: SafeArea(
                  child: Column(
                    children: [
                      // 📌 Sticky Top Action Bar
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: cardBg,
                          border: Border(bottom: BorderSide(color: borderColor)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF059669),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: _saveReport,
                                icon: const Icon(Icons.save_rounded, size: 18),
                                label: const Text(
                                  'সংরক্ষণ করুন',
                                  style:
                                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryAmber,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: _exportPdf,
                                icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                                label: const Text(
                                  'PDF ডাউনলোড',
                                  style:
                                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 📜 Form Content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Header Card
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: borderColor),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: isDark ? 0.2 : 0.04),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'বিসমিল্লাহির রাহমানির রাহীম',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: primaryAmber,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            MajlisAssets.chatroLogo,
                                            width: 32,
                                            height: 32,
                                            errorBuilder: (_, _, _) => const SizedBox(),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: primaryAmber,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: primaryAmber,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          'বায়তুলমাল রিপোর্ট',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildInput('শাখা', _branchController,
                                                inputBg, textColor, borderColor, primaryAmber),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: _buildInput('মাস', _monthController,
                                                inputBg, textColor, borderColor, primaryAmber),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: _buildInput('সেশন', _sessionController,
                                                inputBg, textColor, borderColor, primaryAmber),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // 2. Income Section ("আয়")
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: borderColor),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: isDark ? 0.2 : 0.04),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Income Title Bar
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: primaryAmber,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          'আয়',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 14),

                                      // Column Headers
                                      _buildTableHeader(textColor, primaryAmber),
                                      const SizedBox(height: 6),

                                      // 4 Fixed Income Rows
                                      _buildTableRow(
                                        label:
                                            '১ । জনশক্তি ইয়ানত (সদস্য/সহযোগী সদস্য/কর্মী)',
                                        takaController: _jonoshoktiTakaCtrl,
                                        paisaController: _jonoshoktiPaisaCtrl,
                                        inputBg: inputBg,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                      ),
                                      _buildTableRow(
                                        label: '২ । শাখা ইয়ানত',
                                        takaController: _shakhaTakaCtrl,
                                        paisaController: _shakhaPaisaCtrl,
                                        inputBg: inputBg,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                      ),
                                      _buildTableRow(
                                        label: '৩ । শুভাকাঙ্ক্ষী ইয়ানত',
                                        takaController: _shuvakangkhiTakaCtrl,
                                        paisaController: _shuvakangkhiPaisaCtrl,
                                        inputBg: inputBg,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                      ),
                                      _buildTableRow(
                                        label:
                                            '৪ । এককালীন আয় (বিস্তারিত আলাদা কাগজে)',
                                        takaController: _ekkalinTakaCtrl,
                                        paisaController: _ekkalinPaisaCtrl,
                                        inputBg: inputBg,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                      ),

                                      const Divider(height: 16),
                                      Text(
                                        'অন্যান্য আয়ের খাত (ঐচ্ছিক/ফাঁকা):',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: primaryAmber),
                                      ),
                                      const SizedBox(height: 6),

                                      // 4 Dynamic Income Rows
                                      for (int i = 0; i < 4; i++)
                                        _buildTableRow(
                                          label: '',
                                          labelHint: 'আয়ের খাত ${i + 5}...',
                                          titleController: _customIncomeTitleCtrls[i],
                                          takaController: _customIncomeTakaCtrls[i],
                                          paisaController: _customIncomePaisaCtrls[i],
                                          inputBg: inputBg,
                                          textColor: textColor,
                                          borderColor: borderColor,
                                          accentColor: primaryAmber,
                                        ),

                                      const SizedBox(height: 16),
                                      const Divider(),
                                      const SizedBox(height: 8),

                                      // Income Summary Box
                                      _buildInput('কথায় (আয়ের বিবরণ)',
                                          _motAyInWordsController, inputBg, textColor, borderColor, primaryAmber),
                                      const SizedBox(height: 12),

                                      _buildSummaryDisplayRow(
                                        label: 'মোট আয়',
                                        amount: _motAy,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                      ),
                                      const SizedBox(height: 6),
                                      _buildTableRow(
                                        label: 'বিগত সেশন/মাসের উদ্বৃত্ত',
                                        takaController: _bigotoUdbrittoTakaCtrl,
                                        paisaController: _bigotoUdbrittoPaisaCtrl,
                                        inputBg: inputBg,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                      ),
                                      const SizedBox(height: 6),
                                      _buildSummaryDisplayRow(
                                        label: 'সর্বমোট আয়',
                                        amount: _sorbomotAy,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                        isBold: true,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // 3. Expense Section ("ব্যয়")
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: borderColor),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: isDark ? 0.2 : 0.04),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Expense Title Bar
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: primaryAmber,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          'ব্যয়',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 14),

                                      // Column Headers
                                      _buildTableHeader(textColor, primaryAmber),
                                      const SizedBox(height: 6),

                                      // 6 Fixed Expense Rows
                                      _buildTableRow(
                                        label: '১ । ঊর্ধ্বতন ইয়ানত পরিশোধ',
                                        takaController: _urdhotonIyanotTakaCtrl,
                                        paisaController: _urdhotonIyanotPaisaCtrl,
                                        inputBg: inputBg,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                      ),
                                      _buildTableRow(
                                        label: '২ । ঊর্ধ্বতন সফর',
                                        takaController: _urdhotonSoforTakaCtrl,
                                        paisaController: _urdhotonSoforPaisaCtrl,
                                        inputBg: inputBg,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                      ),
                                      _buildTableRow(
                                        label: '৩ । অফিস',
                                        takaController: _officeTakaCtrl,
                                        paisaController: _officePaisaCtrl,
                                        inputBg: inputBg,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                      ),
                                      _buildTableRow(
                                        label: '৪ । যাতায়াত',
                                        takaController: _jatayatTakaCtrl,
                                        paisaController: _jatayatPaisaCtrl,
                                        inputBg: inputBg,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                      ),
                                      _buildTableRow(
                                        label: '৫ । যোগাযোগ',
                                        takaController: _jogajogTakaCtrl,
                                        paisaController: _jogajogPaisaCtrl,
                                        inputBg: inputBg,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                      ),
                                      _buildTableRow(
                                        label: '৬ । প্রচার',
                                        takaController: _procharTakaCtrl,
                                        paisaController: _procharPaisaCtrl,
                                        inputBg: inputBg,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                      ),

                                      const Divider(height: 16),
                                      Text(
                                        'অন্যান্য ব্যয়ের খাত (ঐচ্ছিক/ফাঁকা):',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: primaryAmber),
                                      ),
                                      const SizedBox(height: 6),

                                      // 3 Dynamic Expense Rows
                                      for (int i = 0; i < 3; i++)
                                        _buildTableRow(
                                          label: '',
                                          labelHint: 'ব্যয়ের খাত ${i + 7}...',
                                          titleController: _customExpenseTitleCtrls[i],
                                          takaController: _customExpenseTakaCtrls[i],
                                          paisaController: _customExpensePaisaCtrls[i],
                                          inputBg: inputBg,
                                          textColor: textColor,
                                          borderColor: borderColor,
                                          accentColor: primaryAmber,
                                        ),

                                      const SizedBox(height: 16),
                                      const Divider(),
                                      const SizedBox(height: 8),

                                      // Expense Summary Box
                                      _buildInput('কথায় (ব্যয়ের বিবরণ)',
                                          _motBayInWordsController, inputBg, textColor, borderColor, primaryAmber),
                                      const SizedBox(height: 4),
                                      Text(
                                        '(ঘাটতি তালিকার বিস্তারিত আলাদা কাগজে)',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontStyle: FontStyle.italic,
                                            color: textColor.withValues(alpha: 0.6)),
                                      ),
                                      const SizedBox(height: 12),

                                      _buildSummaryDisplayRow(
                                        label: 'মোট ব্যয়',
                                        amount: _motBay,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                      ),
                                      const SizedBox(height: 6),
                                      _buildTableRow(
                                        label: 'বিগত সেশন/মাসের ঘাটতি',
                                        takaController: _bigotoGhattiTakaCtrl,
                                        paisaController: _bigotoGhattiPaisaCtrl,
                                        inputBg: inputBg,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                      ),
                                      const SizedBox(height: 6),
                                      _buildSummaryDisplayRow(
                                        label: 'সর্বমোট ব্যয়',
                                        amount: _sorbomotBay,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                        isBold: true,
                                      ),
                                      const SizedBox(height: 6),
                                      _buildSummaryDisplayRow(
                                        label: 'সর্বমোট আয়',
                                        amount: _sorbomotAy,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                        isBold: true,
                                      ),
                                      const SizedBox(height: 6),
                                      _buildSummaryDisplayRow(
                                        label: 'উদ্বৃত্ত/ঘাটতি',
                                        amount: _udbrittoBaGhatti,
                                        textColor: textColor,
                                        borderColor: borderColor,
                                        accentColor: primaryAmber,
                                        isBold: true,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // 4. Signature Section
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: _buildInput(
                                      'সভাপতির স্বাক্ষর',
                                      _presidentSignatureController,
                                      inputBg,
                                      textColor,
                                      borderColor,
                                      primaryAmber),
                                ),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTableHeader(Color textColor, Color accentColor) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            'বিবরণ / খাত',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: accentColor),
          ),
        ),
        SizedBox(
          width: 90,
          child: Text(
            'টাকা',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: accentColor),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 60,
          child: Text(
            'পয়সা',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: accentColor),
          ),
        ),
      ],
    );
  }

  Widget _buildTableRow({
    required String label,
    String? labelHint,
    TextEditingController? titleController,
    required TextEditingController takaController,
    required TextEditingController paisaController,
    required Color inputBg,
    required Color textColor,
    required Color borderColor,
    required Color accentColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: titleController != null
                ? TextField(
                    controller: titleController,
                    style: TextStyle(fontSize: 13, color: textColor),
                    decoration: InputDecoration(
                      hintText: labelHint ?? 'খাতের নাম...',
                      hintStyle:
                          TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.4)),
                      isDense: true,
                      filled: true,
                      fillColor: inputBg,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                        borderSide: BorderSide(color: accentColor, width: 1.5),
                      ),
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textColor.withValues(alpha: 0.9),
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: TextField(
              controller: takaController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
              decoration: InputDecoration(
                hintText: 'টাকা',
                hintStyle:
                    TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.4)),
                isDense: true,
                filled: true,
                fillColor: inputBg,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                  borderSide: BorderSide(color: accentColor, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 60,
            child: TextField(
              controller: paisaController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
              decoration: InputDecoration(
                hintText: 'পয়সা',
                hintStyle:
                    TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.4)),
                isDense: true,
                filled: true,
                fillColor: inputBg,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
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
                  borderSide: BorderSide(color: accentColor, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryDisplayRow({
    required String label,
    required double amount,
    required Color textColor,
    required Color borderColor,
    required Color accentColor,
    bool isBold = false,
  }) {
    final (takaStr, paisaStr) = _formatAmountDisplay(amount);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isBold ? 13 : 12.5,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: isBold ? accentColor : textColor,
              ),
            ),
          ),
          Container(
            width: 90,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: isBold ? accentColor.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: isBold ? accentColor : borderColor),
            ),
            alignment: Alignment.center,
            child: Text(
              takaStr,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: isBold ? accentColor : textColor,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            decoration: BoxDecoration(
              color: isBold ? accentColor.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: isBold ? accentColor : borderColor),
            ),
            alignment: Alignment.center,
            child: Text(
              paisaStr,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: isBold ? accentColor : textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  (String, String) _formatAmountDisplay(double amount) {
    if (amount == 0) return ('০', '০০');
    final isNeg = amount < 0;
    final absVal = amount.abs();
    final taka = absVal.truncate();
    final paisa = ((absVal - taka) * 100).round();

    String toBan(int num) {
      const eng = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      const ban = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
      String s = num.toString();
      for (int i = 0; i < 10; i++) {
        s = s.replaceAll(eng[i], ban[i]);
      }
      return s;
    }

    String takaStr = (isNeg ? '-' : '') + toBan(taka);
    String paisaStr = toBan(paisa).padLeft(2, '০');
    return (takaStr, paisaStr);
  }

  Widget _buildInput(
    String label,
    TextEditingController controller,
    Color inputBg,
    Color textColor,
    Color borderColor,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor.withValues(alpha: 0.85),
            ),
          ),
        ),
        TextField(
          controller: controller,
          style: TextStyle(fontSize: 13, color: textColor),
          decoration: InputDecoration(
            hintText: 'এখানে লিখুন...',
            hintStyle:
                TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.4)),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: inputBg,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: accentColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
