import 'package:flutter/material.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/widgets/pdf_viewer_screen.dart';
import 'package:mojlish_app/features/student_majlis/baytulmal_report/data/datasources/baytulmal_report_datasource.dart';
import 'package:mojlish_app/features/student_majlis/baytulmal_report/data/models/baytulmal_report_model.dart';
import 'package:mojlish_app/features/student_majlis/baytulmal_report/data/services/student_baytulmal_pdf_service.dart';
import 'package:mojlish_app/features/student_majlis/baytulmal_report/domain/entities/baytulmal_report_entity.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস — বায়তুলমাল রিপোর্ট স্ক্রিন
/// আধুনিক অ্যাপিয়ারেন্স, অ্যাম্বিয়েন্ট ব্যাকগ্রাউন্ড, ডিজিটাল মেটেরিয়াল ফরম ফিল্ডস ও লাইভ অটো-ক্যালকুলেশন সহ
class BaytulmalReportScreen extends StatefulWidget {
  final String? initialBranch;
  final String? initialMonth;
  final String? initialSession;

  const BaytulmalReportScreen({
    super.key,
    this.initialBranch,
    this.initialMonth,
    this.initialSession,
  });

  @override
  State<BaytulmalReportScreen> createState() => _BaytulmalReportScreenState();
}

class _BaytulmalReportScreenState extends State<BaytulmalReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _datasource = StudentBaytulmalReportDatasourceImpl();
  bool _isLoading = false;
  bool _isSaving = false;

  // Header Controllers
  final _branchCtrl = TextEditingController();
  final _monthCtrl = TextEditingController();
  final _sessionCtrl = TextEditingController();

  // Income Controllers
  final _jonoshoktiIyanotCtrl = TextEditingController();
  final _shakhaIyanotCtrl = TextEditingController();
  final _shuvakangkhiIyanotCtrl = TextEditingController();
  final _ekkalinAyCtrl = TextEditingController();
  final _bigotoUdbrittoCtrl = TextEditingController();
  final _motAyInWordsCtrl = TextEditingController();

  // Expense Controllers
  final _urdhotonIyanotCtrl = TextEditingController();
  final _urdhotonSoforCtrl = TextEditingController();
  final _officeCtrl = TextEditingController();
  final _jatayatCtrl = TextEditingController();
  final _jogajogCtrl = TextEditingController();
  final _procharCtrl = TextEditingController();
  final _bigotoGhattiCtrl = TextEditingController();
  final _motBayInWordsCtrl = TextEditingController();

  // Signature Controller
  final _presidentSignatureCtrl = TextEditingController();

  static const List<String> _monthsList = [
    'জানুয়ারি',
    'ফেব্রুয়ারি',
    'মার্চ',
    'এপ্রিল',
    'মে',
    'জুন',
    'জুলাই',
    'আগস্ট',
    'সেপ্টেম্বর',
    'অক্টোবর',
    'নভেম্বর',
    'ডিসেম্বর',
  ];

  @override
  void initState() {
    super.initState();
    _branchCtrl.text = widget.initialBranch ?? '';
    _monthCtrl.text = widget.initialMonth ?? _monthsList[DateTime.now().month - 1];
    _sessionCtrl.text = widget.initialSession ?? '${DateTime.now().year}';
    _loadSavedData();
  }

  @override
  void dispose() {
    for (var ctrl in [
      _branchCtrl,
      _monthCtrl,
      _sessionCtrl,
      _jonoshoktiIyanotCtrl,
      _shakhaIyanotCtrl,
      _shuvakangkhiIyanotCtrl,
      _ekkalinAyCtrl,
      _bigotoUdbrittoCtrl,
      _motAyInWordsCtrl,
      _urdhotonIyanotCtrl,
      _urdhotonSoforCtrl,
      _officeCtrl,
      _jatayatCtrl,
      _jogajogCtrl,
      _procharCtrl,
      _bigotoGhattiCtrl,
      _motBayInWordsCtrl,
      _presidentSignatureCtrl,
    ]) {
      ctrl.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    setState(() => _isLoading = true);
    try {
      final year = int.tryParse(_sessionCtrl.text) ?? DateTime.now().year;
      final monthIdx = _monthsList.indexOf(_monthCtrl.text) + 1;
      final savedModel = await _datasource.fetchReport(
        year,
        monthIdx > 0 ? monthIdx : DateTime.now().month,
      );

      if (savedModel != null && mounted) {
        _branchCtrl.text = savedModel.branch;
        _monthCtrl.text = savedModel.month;
        _sessionCtrl.text = savedModel.session;

        _jonoshoktiIyanotCtrl.text = _fmtNum(savedModel.jonoshoktiIyanot);
        _shakhaIyanotCtrl.text = _fmtNum(savedModel.shakhaIyanot);
        _shuvakangkhiIyanotCtrl.text = _fmtNum(savedModel.shuvakangkhiIyanot);
        _ekkalinAyCtrl.text = _fmtNum(savedModel.ekkalinAy);
        _bigotoUdbrittoCtrl.text = _fmtNum(savedModel.bigotoSeshonMasherUdbritto);
        _motAyInWordsCtrl.text = savedModel.motAyInWords;

        _urdhotonIyanotCtrl.text = _fmtNum(savedModel.urdhotonIyanotPorishodh);
        _urdhotonSoforCtrl.text = _fmtNum(savedModel.urdhotonSofor);
        _officeCtrl.text = _fmtNum(savedModel.office);
        _jatayatCtrl.text = _fmtNum(savedModel.jatayat);
        _jogajogCtrl.text = _fmtNum(savedModel.jogajog);
        _procharCtrl.text = _fmtNum(savedModel.prochar);
        _bigotoGhattiCtrl.text = _fmtNum(savedModel.bigotoSeshonMasherGhatti);
        _motBayInWordsCtrl.text = savedModel.motBayInWords;

        _presidentSignatureCtrl.text = savedModel.presidentSignature;
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _fmtNum(double n) => n > 0 ? (n % 1 == 0 ? n.toInt().toString() : n.toString()) : '';
  double _parse(TextEditingController ctrl) => double.tryParse(ctrl.text.replaceAll(',', '')) ?? 0.0;

  // Live Calculated Properties
  double get _totalIncome =>
      _parse(_jonoshoktiIyanotCtrl) +
      _parse(_shakhaIyanotCtrl) +
      _parse(_shuvakangkhiIyanotCtrl) +
      _parse(_ekkalinAyCtrl);

  double get _grandTotalIncome => _totalIncome + _parse(_bigotoUdbrittoCtrl);

  double get _totalExpense =>
      _parse(_urdhotonIyanotCtrl) +
      _parse(_urdhotonSoforCtrl) +
      _parse(_officeCtrl) +
      _parse(_jatayatCtrl) +
      _parse(_jogajogCtrl) +
      _parse(_procharCtrl);

  double get _grandTotalExpense => _totalExpense + _parse(_bigotoGhattiCtrl);

  double get _netBalance => _grandTotalIncome - _grandTotalExpense;

  BaytulmalReportEntity _buildEntity() {
    return BaytulmalReportEntity(
      branch: _branchCtrl.text,
      month: _monthCtrl.text,
      session: _sessionCtrl.text,
      jonoshoktiIyanot: _parse(_jonoshoktiIyanotCtrl),
      shakhaIyanot: _parse(_shakhaIyanotCtrl),
      shuvakangkhiIyanot: _parse(_shuvakangkhiIyanotCtrl),
      ekkalinAy: _parse(_ekkalinAyCtrl),
      motAy: _totalIncome,
      bigotoSeshonMasherUdbritto: _parse(_bigotoUdbrittoCtrl),
      sorbomotAy: _grandTotalIncome,
      motAyInWords: _motAyInWordsCtrl.text,
      urdhotonIyanotPorishodh: _parse(_urdhotonIyanotCtrl),
      urdhotonSofor: _parse(_urdhotonSoforCtrl),
      office: _parse(_officeCtrl),
      jatayat: _parse(_jatayatCtrl),
      jogajog: _parse(_jogajogCtrl),
      prochar: _parse(_procharCtrl),
      motBay: _totalExpense,
      bigotoSeshonMasherGhatti: _parse(_bigotoGhattiCtrl),
      sorbomotBay: _grandTotalExpense,
      udbrittoBaGhatti: _netBalance,
      motBayInWords: _motBayInWordsCtrl.text,
      presidentSignature: _presidentSignatureCtrl.text,
    );
  }

  Future<void> _saveReport() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final entity = _buildEntity();
      final model = BaytulmalReportModel(
        branch: entity.branch,
        month: entity.month,
        session: entity.session,
        jonoshoktiIyanot: entity.jonoshoktiIyanot,
        shakhaIyanot: entity.shakhaIyanot,
        shuvakangkhiIyanot: entity.shuvakangkhiIyanot,
        ekkalinAy: entity.ekkalinAy,
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
        motBay: entity.motBay,
        bigotoSeshonMasherGhatti: entity.bigotoSeshonMasherGhatti,
        sorbomotBay: entity.sorbomotBay,
        udbrittoBaGhatti: entity.udbrittoBaGhatti,
        motBayInWords: entity.motBayInWords,
        presidentSignature: entity.presidentSignature,
      );

      await _datasource.saveReport(model);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('বায়তুলমাল রিপোর্ট সফলভাবে সংরক্ষিত হয়েছে'),
            backgroundColor: Color(0xFF0284C7),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('সংরক্ষণে ব্যর্থতা: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _openPdfViewer() {
    final entity = _buildEntity();
    PdfViewerScreen.open(
      context,
      title: 'বায়তুলমাল রিপোর্ট — বাংলাদেশ ইসলামী ছাত্র মজলিস',
      fileName:
          'chatro_baytulmal_report_${entity.branch.isEmpty ? "shakha" : entity.branch}_${entity.month}.pdf',
      buildPdf: (format) => StudentBaytulmalPdfService.generatePdfBytes(report: entity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'বাংলাদেশ ইসলামী ছাত্র মজলিস',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'বায়তুলমাল রিপোর্ট ফরম',
              style: TextStyle(fontSize: 11, color: Color(0xFF38BDF8)),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 2,
        actions: [
          IconButton(
            onPressed: _openPdfViewer,
            icon: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF38BDF8)),
            tooltip: 'পিডিএফ দেখুন ও প্রিন্ট',
          ),
          IconButton(
            onPressed: _isSaving ? null : _saveReport,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.save_rounded, color: Color(0xFF34D399)),
            tooltip: 'সংরক্ষণ করুন',
          ),
        ],
      ),
      body: AmbientBackgroundWidget(
        primaryAccent: const Color(0xFF0284C7),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF0284C7)),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeaderBanner(),
                      const SizedBox(height: 16),
                      _buildGeneralInfoSection(),
                      const SizedBox(height: 16),
                      _buildIncomeSection(),
                      const SizedBox(height: 16),
                      _buildExpenseSection(),
                      const SizedBox(height: 16),
                      _buildSignatureSection(),
                      const SizedBox(height: 24),
                      _buildBottomActionButtons(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'বায়তুলমাল রিপোর্ট (ছাত্র মজলিস)',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'শাখার মাসিক আয়-ব্যয় ও বায়তুলমাল হিসাব ফরম',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFE0F2FE),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralInfoSection() {
    return _buildCardWrapper(
      title: 'সাধারণ তথ্য',
      icon: Icons.info_outline_rounded,
      accentColor: const Color(0xFF0284C7),
      child: Column(
        children: [
          _buildTextField(
            controller: _branchCtrl,
            label: 'শাখার নাম',
            hint: 'যেমন: ঢাকা বিশ্ববিদ্যালয় শাখা',
            icon: Icons.account_tree_rounded,
            validator: (v) => (v == null || v.isEmpty) ? 'শাখার নাম লিখুন' : null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'মাস',
                  value: _monthsList.contains(_monthCtrl.text) ? _monthCtrl.text : _monthsList[0],
                  items: _monthsList,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _monthCtrl.text = val);
                      _loadSavedData();
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _sessionCtrl,
                  label: 'সেশন / বছর',
                  hint: 'যেমন: ২০২৬',
                  icon: Icons.calendar_today_rounded,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeSection() {
    return _buildCardWrapper(
      title: 'আয় (Income)',
      icon: Icons.arrow_downward_rounded,
      accentColor: const Color(0xFF10B981),
      child: Column(
        children: [
          _buildNumberInput(
            controller: _jonoshoktiIyanotCtrl,
            label: '১ । জনশক্তি এয়ানত (সদস্য/সহযোগী সদস্য/কর্মী)',
          ),
          const SizedBox(height: 10),
          _buildNumberInput(
            controller: _shakhaIyanotCtrl,
            label: '২ । শাখা এয়ানত',
          ),
          const SizedBox(height: 10),
          _buildNumberInput(
            controller: _shuvakangkhiIyanotCtrl,
            label: '৩ । শুভাকাঙ্ক্ষী এয়ানত',
          ),
          const SizedBox(height: 10),
          _buildNumberInput(
            controller: _ekkalinAyCtrl,
            label: '৪ । এককালীন আয় (বিস্তারিত আলাদা কাগজে)',
          ),
          const SizedBox(height: 10),
          _buildNumberInput(
            controller: _bigotoUdbrittoCtrl,
            label: 'বিগত সেশন/মাসের উদ্বৃত্ত',
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _motAyInWordsCtrl,
            label: 'আয় কথায়',
            hint: 'যেমন: পাঁচ হাজার টাকা মাত্র',
            icon: Icons.short_text_rounded,
          ),
          const SizedBox(height: 14),
          // Live Computed Totals
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF064E3B).withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                _buildSummaryRowText('মোট আয়:', '৳ ${_totalIncome.toStringAsFixed(0)}'),
                const SizedBox(height: 4),
                _buildSummaryRowText('বিগত উদ্বৃত্ত:', '৳ ${_parse(_bigotoUdbrittoCtrl).toStringAsFixed(0)}'),
                const Divider(color: Color(0xFF10B981), height: 12),
                _buildSummaryRowText(
                  'সর্বমোট আয়:',
                  '৳ ${_grandTotalIncome.toStringAsFixed(0)}',
                  isBold: true,
                  valueColor: const Color(0xFF34D399),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseSection() {
    return _buildCardWrapper(
      title: 'ব্যয় (Expense)',
      icon: Icons.arrow_upward_rounded,
      accentColor: const Color(0xFFF43F5E),
      child: Column(
        children: [
          _buildNumberInput(
            controller: _urdhotonIyanotCtrl,
            label: '১ । ঊর্ধ্বতন এয়ানত পরিশোধ',
          ),
          const SizedBox(height: 10),
          _buildNumberInput(
            controller: _urdhotonSoforCtrl,
            label: '২ । ঊর্ধ্বতন সফর',
          ),
          const SizedBox(height: 10),
          _buildNumberInput(
            controller: _officeCtrl,
            label: '৩ । অফিস',
          ),
          const SizedBox(height: 10),
          _buildNumberInput(
            controller: _jatayatCtrl,
            label: '৪ । যাতায়াত',
          ),
          const SizedBox(height: 10),
          _buildNumberInput(
            controller: _jogajogCtrl,
            label: '৫ । যোগাযোগ',
          ),
          const SizedBox(height: 10),
          _buildNumberInput(
            controller: _procharCtrl,
            label: '৬ । প্রচার',
          ),
          const SizedBox(height: 10),
          _buildNumberInput(
            controller: _bigotoGhattiCtrl,
            label: 'বিগত সেশন/মাসের ঘাটতি',
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _motBayInWordsCtrl,
            label: 'ব্যয় কথায়',
            hint: 'যেমন: চার হাজার টাকা মাত্র',
            icon: Icons.short_text_rounded,
          ),
          const SizedBox(height: 14),
          // Live Computed Totals
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF881337).withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFF43F5E).withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                _buildSummaryRowText('মোট ব্যয়:', '৳ ${_totalExpense.toStringAsFixed(0)}'),
                const SizedBox(height: 4),
                _buildSummaryRowText('বিগত ঘাটতি:', '৳ ${_parse(_bigotoGhattiCtrl).toStringAsFixed(0)}'),
                const SizedBox(height: 4),
                _buildSummaryRowText('সর্বমোট ব্যয়:', '৳ ${_grandTotalExpense.toStringAsFixed(0)}', isBold: true),
                const Divider(color: Color(0xFFF43F5E), height: 12),
                _buildSummaryRowText(
                  _netBalance >= 0 ? 'উদ্বৃত্ত:' : 'ঘাটতি:',
                  '৳ ${_netBalance.abs().toStringAsFixed(0)}',
                  isBold: true,
                  valueColor: _netBalance >= 0 ? const Color(0xFF34D399) : const Color(0xFFFB7185),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureSection() {
    return _buildCardWrapper(
      title: 'দায়িত্বশীল এর তথ্য',
      icon: Icons.draw_rounded,
      accentColor: const Color(0xFF8B5CF6),
      child: _buildTextField(
        controller: _presidentSignatureCtrl,
        label: 'সভাপতির নাম / স্বাক্ষর',
        hint: 'যেমন: মোঃ আব্দুল্লাহ',
        icon: Icons.edit_note_rounded,
      ),
    );
  }

  Widget _buildBottomActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 3,
            ),
            icon: const Icon(Icons.save_rounded, size: 20),
            label: const Text(
              'সংরক্ষণ করুন',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _openPdfViewer,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 3,
            ),
            icon: const Icon(Icons.picture_as_pdf_rounded, size: 20),
            label: const Text(
              'পিডিএফ এক্সপোর্ট',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardWrapper({
    required String title,
    required IconData icon,
    required Color accentColor,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: accentColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildNumberInput({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: (_) => setState(() {}),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        filled: true,
        fillColor: const Color(0xFF0F172A),
        prefixIcon: const Icon(Icons.attach_money_rounded, color: Color(0xFF64748B), size: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 12),
        labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        filled: true,
        fillColor: const Color(0xFF0F172A),
        prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ))
          .toList(),
      onChanged: onChanged,
      dropdownColor: const Color(0xFF1E293B),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        filled: true,
        fillColor: const Color(0xFF0F172A),
        prefixIcon: const Icon(Icons.date_range_rounded, color: Color(0xFF64748B), size: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildSummaryRowText(
    String label,
    String value, {
    bool isBold = false,
    Color valueColor = Colors.white,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: const Color(0xFFCBD5E1),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
