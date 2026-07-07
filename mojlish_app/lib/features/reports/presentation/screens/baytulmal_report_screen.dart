import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/models/baytulmal_report_entry.dart';
import '../../data/services/report_storage_service.dart';
import '../../data/services/pdf_generator_service.dart';

class BaytulmalReportScreen extends StatefulWidget {
  final int year;
  final int month;

  const BaytulmalReportScreen({super.key, required this.year, required this.month});

  @override
  State<BaytulmalReportScreen> createState() => _BaytulmalReportScreenState();
}

class _BaytulmalReportScreenState extends State<BaytulmalReportScreen> {
  bool _isSaving = false;
  bool _isExporting = false;
  bool _isLocked = true;
  BaytulmalReportEntry? _currentEntry;

  // Branch info
  final _branchCtrl = TextEditingController();

  // আয় controllers
  final _execMemberCountCtrl = TextEditingController();
  final _execMemberTakaCtrl = TextEditingController();
  final _subBranchCountCtrl = TextEditingController();
  final _subBranchTakaCtrl = TextEditingController();
  final _suhridCountCtrl = TextEditingController();
  final _suhridTakaCtrl = TextEditingController();
  final _safarIncomeTakaCtrl = TextEditingController();
  final _prokashnaIncomeTakaCtrl = TextEditingController();
  final _onetimeIncomeTakaCtrl = TextEditingController();
  final _previousBalanceCtrl = TextEditingController();

  // ব্যয় controllers
  final _upwardAyanatCtrl = TextEditingController();
  final _upwardAyanatTakaCtrl = TextEditingController();
  final _officeRentTakaCtrl = TextEditingController();
  final _officeCostTakaCtrl = TextEditingController();
  final _safarExpenseTakaCtrl = TextEditingController();
  final _transportTakaCtrl = TextEditingController();
  final _communicationTakaCtrl = TextEditingController();
  final _procharTakaCtrl = TextEditingController();
  final _prokashnaExpenseTakaCtrl = TextEditingController();
  final _dibosNameCtrl = TextEditingController();
  final _dibosTakaCtrl = TextEditingController();
  final _appayanTakaCtrl = TextEditingController();
  final _sovaTakaCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();

  static const _darkBg = Color(0xFF0D1B2A);
  static const _cardBg = Color(0xFF162032);
  static const _borderColor = Color(0xFF2A3F58);
  static const _accentGreen = Color(0xFF10B981);
  static const _textLight = Color(0xFFE2E8F0);
  static const _textMuted = Color(0xFF94A3B8);

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentReport();
  }

  @override
  void dispose() {
    _branchCtrl.dispose();
    _execMemberCountCtrl.dispose();
    _execMemberTakaCtrl.dispose();
    _subBranchCountCtrl.dispose();
    _subBranchTakaCtrl.dispose();
    _suhridCountCtrl.dispose();
    _suhridTakaCtrl.dispose();
    _safarIncomeTakaCtrl.dispose();
    _prokashnaIncomeTakaCtrl.dispose();
    _onetimeIncomeTakaCtrl.dispose();
    _previousBalanceCtrl.dispose();
    _upwardAyanatCtrl.dispose();
    _upwardAyanatTakaCtrl.dispose();
    _officeRentTakaCtrl.dispose();
    _officeCostTakaCtrl.dispose();
    _safarExpenseTakaCtrl.dispose();
    _transportTakaCtrl.dispose();
    _communicationTakaCtrl.dispose();
    _procharTakaCtrl.dispose();
    _prokashnaExpenseTakaCtrl.dispose();
    _dibosNameCtrl.dispose();
    _dibosTakaCtrl.dispose();
    _appayanTakaCtrl.dispose();
    _sovaTakaCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentReport() async {
    try {
      final entry = await ReportStorageService.getBaytulmalEntry(widget.year, widget.month);
      if (entry != null && mounted) {
        setState(() {
          _isLocked = true;
          _currentEntry = entry;
          _branchCtrl.text = entry.branchName;
          _execMemberCountCtrl.text = entry.executiveMemberAyanat;
          _execMemberTakaCtrl.text = entry.executiveMemberAyanatTaka;
          _subBranchCountCtrl.text = entry.subBranchAyanat;
          _subBranchTakaCtrl.text = entry.subBranchAyanatTaka;
          _suhridCountCtrl.text = entry.suhridAyanat;
          _suhridTakaCtrl.text = entry.suhridAyanatTaka;
          _safarIncomeTakaCtrl.text = entry.safarIncomeTaka;
          _prokashnaIncomeTakaCtrl.text = entry.prokashnaIncomeTaka;
          _onetimeIncomeTakaCtrl.text = entry.onetimeIncomeTaka;
          _previousBalanceCtrl.text = entry.previousBalance;
          _upwardAyanatCtrl.text = entry.upwardAyanat;
          _upwardAyanatTakaCtrl.text = entry.upwardAyanatTaka;
          _officeRentTakaCtrl.text = entry.officeRentTaka;
          _officeCostTakaCtrl.text = entry.officeCostTaka;
          _safarExpenseTakaCtrl.text = entry.safarExpenseTaka;
          _transportTakaCtrl.text = entry.transportTaka;
          _communicationTakaCtrl.text = entry.communicationTaka;
          _procharTakaCtrl.text = entry.procharTaka;
          _prokashnaExpenseTakaCtrl.text = entry.prokashnaExpenseTaka;
          _dibosNameCtrl.text = entry.dibosPalan;
          _dibosTakaCtrl.text = entry.dibosPatanTaka;
          _appayanTakaCtrl.text = entry.appayanTaka;
          _sovaTakaCtrl.text = entry.sovaTaka;
          _remarksCtrl.text = entry.remarks;
        });
      } else {
        setState(() {
          _isLocked = false;
          _currentEntry = null;
        });
      }
    } catch (_) {}
  }

  BaytulmalReportEntry _buildEntry() {
    return BaytulmalReportEntry(
      month: widget.month.toString().padLeft(2, '0'),
      year: widget.year.toString(),
      branchName: _branchCtrl.text.trim(),
      executiveMemberAyanat: _execMemberCountCtrl.text.trim(),
      executiveMemberAyanatTaka: _execMemberTakaCtrl.text.trim(),
      subBranchAyanat: _subBranchCountCtrl.text.trim(),
      subBranchAyanatTaka: _subBranchTakaCtrl.text.trim(),
      suhridAyanat: _suhridCountCtrl.text.trim(),
      suhridAyanatTaka: _suhridTakaCtrl.text.trim(),
      safarIncomeTaka: _safarIncomeTakaCtrl.text.trim(),
      prokashnaIncomeTaka: _prokashnaIncomeTakaCtrl.text.trim(),
      onetimeIncomeTaka: _onetimeIncomeTakaCtrl.text.trim(),
      previousBalance: _previousBalanceCtrl.text.trim(),
      upwardAyanat: _upwardAyanatCtrl.text.trim(),
      upwardAyanatTaka: _upwardAyanatTakaCtrl.text.trim(),
      officeRentTaka: _officeRentTakaCtrl.text.trim(),
      officeCostTaka: _officeCostTakaCtrl.text.trim(),
      safarExpenseTaka: _safarExpenseTakaCtrl.text.trim(),
      transportTaka: _transportTakaCtrl.text.trim(),
      communicationTaka: _communicationTakaCtrl.text.trim(),
      procharTaka: _procharTakaCtrl.text.trim(),
      prokashnaExpenseTaka: _prokashnaExpenseTakaCtrl.text.trim(),
      dibosPalan: _dibosNameCtrl.text.trim(),
      dibosPatanTaka: _dibosTakaCtrl.text.trim(),
      appayanTaka: _appayanTakaCtrl.text.trim(),
      sovaTaka: _sovaTakaCtrl.text.trim(),
      remarks: _remarksCtrl.text.trim(),
    );
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final entry = _buildEntry();
    await ReportStorageService.saveBaytulmalEntry(entry);
    await _loadCurrentReport();
    setState(() {
      _isSaving = false;
      _isLocked = true;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('বায়তুলমাল রিপোর্ট সেভ করা হয়েছে ✓'),
          backgroundColor: _accentGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _exportPdf() async {
    setState(() => _isExporting = true);
    final entry = _buildEntry();
    try {
      await PdfGeneratorService.generateBaytulmalReportPdf(entry: entry);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF তৈরি করতে সমস্যা হয়েছে: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      appBar: AppBar(
        title: const Text('শাখা বায়তুলমাল রিপোর্ট',
            style: TextStyle(color: _textLight, fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        backgroundColor: _cardBg,
        iconTheme: const IconThemeData(color: _textLight),
        elevation: 0,
        actions: [
          if (_currentEntry != null && _isLocked)
            TextButton.icon(
              icon: const Icon(Icons.edit, color: _accentGreen, size: 16),
              label: const Text('এডিট করুন', style: TextStyle(color: _accentGreen, fontSize: 13, fontWeight: FontWeight.bold)),
              onPressed: () => setState(() => _isLocked = false),
            ),
          IconButton(
            icon: _isExporting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.picture_as_pdf, color: Color(0xFFEF4444)),
            tooltip: 'PDF এক্সপোর্ট',
            onPressed: _isExporting ? null : _exportPdf,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _BaytulmalBgPainter())),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0EA5E9).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF0EA5E9).withValues(alpha: 0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.account_balance_wallet, color: Color(0xFF0EA5E9), size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${_monthNames[widget.month - 1]} ${_bn(widget.year)} মাসের রিপোর্ট',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF38BDF8))),
                        Text(_currentEntry != null ? 'সর্বশেষ সেভ করা আছে' : 'এখনো সেভ করা হয়নি',
                            style: TextStyle(fontSize: 12, color: _currentEntry != null ? const Color(0xFF10B981) : const Color(0xFFF59E0B))),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),

                // Branch name
                _sectionHeader('শাখার তথ্য'),
                _field('শাখার নাম', 'শাখার নাম লিখুন', _branchCtrl),
                const SizedBox(height: 20),

                // আয় সেকশন
                _incomeSection(),
                const SizedBox(height: 20),

                // ব্যয় সেকশন
                _expenseSection(),
                const SizedBox(height: 20),

                // Summary
                if (_currentEntry != null || true) _buildSummary(),
                const SizedBox(height: 12),

                // মন্তব্য
                _sectionHeader('মন্তব্য'),
                _field('মন্তব্য', 'কোনো বিশেষ তথ্য বা মন্তব্য...', _remarksCtrl, maxLines: 3),
                const SizedBox(height: 24),

                // Save button
                if (!_isLocked) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _save,
                      icon: _isSaving
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.save, color: Colors.white),
                      label: Text(_isSaving ? 'সেভ হচ্ছে...' : 'রিপোর্ট সেভ করুন',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0EA5E9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _incomeSection() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 4, height: 20, decoration: BoxDecoration(color: _accentGreen, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 10),
          const Text('আয়', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _accentGreen)),
        ]),
        const SizedBox(height: 16),
        _twoColRow('নির্বাহী সদস্যের এয়ানত (জন)', _execMemberCountCtrl, 'টাকা', _execMemberTakaCtrl),
        _twoColRow('অধতন শাখা এয়ানত (শাখা টি)', _subBranchCountCtrl, 'টাকা', _subBranchTakaCtrl),
        _twoColRow('সুহৃদ/ভক্তাক্ষী এয়ানত (জন)', _suhridCountCtrl, 'টাকা', _suhridTakaCtrl),
        _oneTakaRow('সফর আয়', _safarIncomeTakaCtrl),
        _oneTakaRow('প্রকাশনা আয়', _prokashnaIncomeTakaCtrl),
        _oneTakaRow('এককালীন আয়', _onetimeIncomeTakaCtrl),
        _oneTakaRow('বিগত মাসের উদ্বৃত্ত', _previousBalanceCtrl),
      ]),
    );
  }

  Widget _expenseSection() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 4, height: 20, decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 10),
          const Text('ব্যয়', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
        ]),
        const SizedBox(height: 16),
        _twoColRow('উর্ধতন এয়ানত পরিশোধ (ধার্যকৃত: ৳)', _upwardAyanatCtrl, 'টাকা', _upwardAyanatTakaCtrl),
        _oneTakaRow('অফিস ভাড়া ও বিল', _officeRentTakaCtrl),
        _oneTakaRow('অফিস খরচ', _officeCostTakaCtrl),
        _oneTakaRow('সফর', _safarExpenseTakaCtrl),
        _oneTakaRow('যাতায়াত', _transportTakaCtrl),
        _oneTakaRow('যোগাযোগ', _communicationTakaCtrl),
        _oneTakaRow('প্রচার', _procharTakaCtrl),
        _oneTakaRow('প্রকাশনা', _prokashnaExpenseTakaCtrl),
        _twoColRow('দিবস পালন (নাম)', _dibosNameCtrl, 'টাকা', _dibosTakaCtrl),
        _oneTakaRow('আপ্যায়ন', _appayanTakaCtrl),
        _oneTakaRow('সভা/সমাবেশ বাস্তবায়ন', _sovaTakaCtrl),
      ]),
    );
  }

  Widget _buildSummary() {
    final entry = _buildEntry();
    final income = entry.totalIncome;
    final expense = entry.totalExpense;
    final balance = entry.balance;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: balance >= 0 ? const Color(0xFF064E3B) : const Color(0xFF7F1D1D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: balance >= 0 ? _accentGreen : const Color(0xFFEF4444), width: 0.5),
      ),
      child: Column(children: [
        _summaryRow('মোট আয়:', '৳ ${income.toStringAsFixed(2)}', _accentGreen),
        _summaryRow('মোট ব্যয়:', '৳ ${expense.toStringAsFixed(2)}', const Color(0xFFEF4444)),
        Divider(color: balance >= 0 ? _accentGreen.withValues(alpha: 0.3) : const Color(0xFFEF4444).withValues(alpha: 0.3)),
        _summaryRow(
          balance >= 0 ? 'উদ্বৃত্ত:' : 'ঘাটতি:',
          '৳ ${balance.abs().toStringAsFixed(2)}',
          balance >= 0 ? _accentGreen : const Color(0xFFEF4444),
          bold: true,
        ),
      ]),
    );
  }

  Widget _summaryRow(String label, String value, Color color, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: 14, color: color)),
        Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: 14, color: color)),
      ]),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(width: 4, height: 20, decoration: BoxDecoration(color: const Color(0xFF0EA5E9), borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
      ]),
    );
  }

  Widget _field(String label, String hint, TextEditingController ctrl, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: _textMuted, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            enabled: !_isLocked,
            style: const TextStyle(color: _textLight, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF4A5568), fontSize: 13),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF0EA5E9), width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _borderColor.withValues(alpha: 0.5)),
              ),
              filled: true,
              fillColor: const Color(0xFF0A1628),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _twoColRow(String label1, TextEditingController ctrl1, String label2, TextEditingController ctrl2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label1, style: const TextStyle(color: _textMuted, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                _miniField(ctrl1),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label2, style: const TextStyle(color: _textMuted, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                _miniField(ctrl2, keyboardType: TextInputType.number),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _oneTakaRow(String label, TextEditingController takaCtrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('টাকা', style: TextStyle(color: _textMuted, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                _miniField(takaCtrl, keyboardType: TextInputType.number),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniField(TextEditingController ctrl, {TextInputType keyboardType = TextInputType.text, String hint = ''}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      enabled: !_isLocked,
      style: const TextStyle(fontSize: 13, color: _textLight),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF4A5568), fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0EA5E9)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _borderColor.withValues(alpha: 0.4)),
        ),
        filled: true,
        fillColor: const Color(0xFF0A1628),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        isDense: true,
      ),
    );
  }
}

class _BaytulmalBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = const Color(0xFF10B981).withValues(alpha: 0.025)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.05), 130, fill);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.5), 100, fill);

    final grid = Paint()..color = const Color(0xFF10B981).withValues(alpha: 0.012)..strokeWidth = 0.5..style = PaintingStyle.stroke;
    for (double x = 0; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    for (double y = 0; y < size.height; y += 40) canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);

    final star = Paint()..color = const Color(0xFF1E3A52)..style = PaintingStyle.fill;
    _drawStar(canvas, Offset(size.width * 0.85, size.height * 0.12), 18, star);
    _drawStar(canvas, Offset(size.width * 0.08, size.height * 0.3), 12, star);
  }

  void _drawStar(Canvas canvas, Offset c, double r, Paint p) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final a = i * 45 * pi / 180;
      final rad = i % 2 == 0 ? r : r * 0.45;
      i == 0 ? path.moveTo(c.dx + rad * cos(a), c.dy + rad * sin(a))
             : path.lineTo(c.dx + rad * cos(a), c.dy + rad * sin(a));
    }
    path.close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_BaytulmalBgPainter _) => false;
}
