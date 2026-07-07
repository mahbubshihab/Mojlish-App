import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/models/sanghotonik_report_entry.dart';
import '../../data/services/report_storage_service.dart';

class SanghotonikReportScreen extends StatefulWidget {
  final int year;
  final int month;

  const SanghotonikReportScreen({super.key, required this.year, required this.month});

  @override
  State<SanghotonikReportScreen> createState() => _SanghotonikReportScreenState();
}

class _SanghotonikReportScreenState extends State<SanghotonikReportScreen> {
  bool _isSaving = false;
  bool _isLocked = true;
  SanghotonikReportEntry? _currentEntry;

  // Controllers
  final _branchCtrl = TextEditingController();

  // জনশক্তি (Manpower)
  final _sodossoCountCtrl = TextEditingController();
  final _sodossoBridhiCtrl = TextEditingController();
  final _sodossoGhattiCtrl = TextEditingController();
  final _sodossoPrarthiCountCtrl = TextEditingController();
  final _sodossoPrarthiBridhiCtrl = TextEditingController();
  final _sodossoPrarthiGhattiCtrl = TextEditingController();
  final _kormiCountCtrl = TextEditingController();
  final _kormiBridhiCtrl = TextEditingController();
  final _kormiGhattiCtrl = TextEditingController();
  final _prathmikCountCtrl = TextEditingController();
  final _prathmikBridhiCtrl = TextEditingController();
  final _prathmikGhattiCtrl = TextEditingController();
  final _sudhiCountCtrl = TextEditingController();

  // দাওয়াত ও গণসংযোগ (Dawah & Contact)
  final _dawahPersonalCountCtrl = TextEditingController();
  final _dawahPersonalPresCtrl = TextEditingController();
  final _dawahGroupCountCtrl = TextEditingController();
  final _dawahGroupPresCtrl = TextEditingController();
  final _dawahMahfilCountCtrl = TextEditingController();
  final _dawahMahfilPresCtrl = TextEditingController();
  final _leafletDistCtrl = TextEditingController();
  final _posterPastedCtrl = TextEditingController();

  // সংগঠন (Organization)
  final _adminUnitCountCtrl = TextEditingController();
  final _adminUnitNameCtrl = TextEditingController();
  final _mosqueOrgCountCtrl = TextEditingController();

  // সভাধমূহ (Meetings)
  final _generalMeetingCountCtrl = TextEditingController();
  final _generalMeetingPresCtrl = TextEditingController();
  final _kormiMeetingCountCtrl = TextEditingController();
  final _kormiMeetingPresCtrl = TextEditingController();

  // বায়তুলমাল সংক্ষিপ্ত
  final _totalIncomeCtrl = TextEditingController();
  final _totalExpenseCtrl = TextEditingController();

  // প্রচার, প্রকাশনা ও পাঠাগার
  final _newsReleaseCountCtrl = TextEditingController();
  final _posterPublishedCtrl = TextEditingController();
  final _libBookCountCtrl = TextEditingController();
  final _libBookReadCountCtrl = TextEditingController();

  // সমাজকল্যাণ ও মন্তব্য
  final _socialWelfareTakaCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();

  static const _darkBg = Color(0xFF0D1B2A);
  static const _cardBg = Color(0xFF162032);
  static const _borderColor = Color(0xFF2A3F58);
  static const _accentOrange = Colors.orange;
  static const _accentGreen = Color(0xFF10B981);
  static const _textLight = Color(0xFFE2E8F0);
  static const _textMuted = Color(0xFF94A3B8);



  @override
  void initState() {
    super.initState();
    _loadCurrentReport();
  }

  @override
  void dispose() {
    for (final c in [
      _branchCtrl, _sodossoCountCtrl, _sodossoBridhiCtrl, _sodossoGhattiCtrl,
      _sodossoPrarthiCountCtrl, _sodossoPrarthiBridhiCtrl, _sodossoPrarthiGhattiCtrl,
      _kormiCountCtrl, _kormiBridhiCtrl, _kormiGhattiCtrl,
      _prathmikCountCtrl, _prathmikBridhiCtrl, _prathmikGhattiCtrl, _sudhiCountCtrl,
      _dawahPersonalCountCtrl, _dawahPersonalPresCtrl, _dawahGroupCountCtrl,
      _dawahGroupPresCtrl, _dawahMahfilCountCtrl, _dawahMahfilPresCtrl,
      _leafletDistCtrl, _posterPastedCtrl, _adminUnitCountCtrl, _adminUnitNameCtrl,
      _mosqueOrgCountCtrl, _generalMeetingCountCtrl, _generalMeetingPresCtrl,
      _kormiMeetingCountCtrl, _kormiMeetingPresCtrl, _totalIncomeCtrl,
      _totalExpenseCtrl, _newsReleaseCountCtrl, _posterPublishedCtrl,
      _libBookCountCtrl, _libBookReadCountCtrl, _socialWelfareTakaCtrl, _remarksCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadCurrentReport() async {
    try {
      final entry = await ReportStorageService.getSanghotonikEntry(widget.year, widget.month);
      if (entry != null && mounted) {
        setState(() {
          _isLocked = true;
          _currentEntry = entry;
          _branchCtrl.text = entry.branchName;
          _sodossoCountCtrl.text = entry.sodossoCount;
          _sodossoBridhiCtrl.text = entry.sodossoBridhi;
          _sodossoGhattiCtrl.text = entry.sodossoGhatti;
          _sodossoPrarthiCountCtrl.text = entry.sodossoPrarthiCount;
          _sodossoPrarthiBridhiCtrl.text = entry.sodossoPrarthiBridhi;
          _sodossoPrarthiGhattiCtrl.text = entry.sodossoPrarthiGhatti;
          _kormiCountCtrl.text = entry.kormiCount;
          _kormiBridhiCtrl.text = entry.kormiBridhi;
          _kormiGhattiCtrl.text = entry.kormiGhatti;
          _prathmikCountCtrl.text = entry.prathmikSodossoCount;
          _prathmikBridhiCtrl.text = entry.prathmikSodossoBridhi;
          _prathmikGhattiCtrl.text = entry.prathmikSodossoGhatti;
          _sudhiCountCtrl.text = entry.sudhiCount;
          _dawahPersonalCountCtrl.text = entry.dawahPersonalCount;
          _dawahPersonalPresCtrl.text = entry.dawahPersonalPresence;
          _dawahGroupCountCtrl.text = entry.dawahGroupCount;
          _dawahGroupPresCtrl.text = entry.dawahGroupPresence;
          _dawahMahfilCountCtrl.text = entry.dawahMahfilCount;
          _dawahMahfilPresCtrl.text = entry.dawahMahfilPresence;
          _leafletDistCtrl.text = entry.leafletDistributed;
          _posterPastedCtrl.text = entry.posterPasted;
          _adminUnitCountCtrl.text = entry.administrativeUnitCount;
          _adminUnitNameCtrl.text = entry.administrativeUnitName;
          _mosqueOrgCountCtrl.text = entry.mosqueOrganizationCount;
          _generalMeetingCountCtrl.text = entry.generalMeetingCount;
          _generalMeetingPresCtrl.text = entry.generalMeetingPresence;
          _kormiMeetingCountCtrl.text = entry.kormiMeetingCount;
          _kormiMeetingPresCtrl.text = entry.kormiMeetingPresence;
          _totalIncomeCtrl.text = entry.totalIncome;
          _totalExpenseCtrl.text = entry.totalExpense;
          _newsReleaseCountCtrl.text = entry.newsReleaseCount;
          _posterPublishedCtrl.text = entry.posterPublished;
          _libBookCountCtrl.text = entry.libraryBookCount;
          _libBookReadCountCtrl.text = entry.libraryBookReadCount;
          _socialWelfareTakaCtrl.text = entry.socialWelfareTaka;
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

  SanghotonikReportEntry _buildEntry() {
    return SanghotonikReportEntry(
      month: widget.month.toString().padLeft(2, '0'),
      year: widget.year.toString(),
      branchName: _branchCtrl.text.trim(),
      sodossoCount: _sodossoCountCtrl.text.trim(),
      sodossoBridhi: _sodossoBridhiCtrl.text.trim(),
      sodossoGhatti: _sodossoGhattiCtrl.text.trim(),
      sodossoPrarthiCount: _sodossoPrarthiCountCtrl.text.trim(),
      sodossoPrarthiBridhi: _sodossoPrarthiBridhiCtrl.text.trim(),
      sodossoPrarthiGhatti: _sodossoPrarthiGhattiCtrl.text.trim(),
      kormiCount: _kormiCountCtrl.text.trim(),
      kormiBridhi: _kormiBridhiCtrl.text.trim(),
      kormiGhatti: _kormiGhattiCtrl.text.trim(),
      prathmikSodossoCount: _prathmikCountCtrl.text.trim(),
      prathmikSodossoBridhi: _prathmikBridhiCtrl.text.trim(),
      prathmikSodossoGhatti: _prathmikGhattiCtrl.text.trim(),
      sudhiCount: _sudhiCountCtrl.text.trim(),
      dawahPersonalCount: _dawahPersonalCountCtrl.text.trim(),
      dawahPersonalPresence: _dawahPersonalPresCtrl.text.trim(),
      dawahGroupCount: _dawahGroupCountCtrl.text.trim(),
      dawahGroupPresence: _dawahGroupPresCtrl.text.trim(),
      dawahMahfilCount: _dawahMahfilCountCtrl.text.trim(),
      dawahMahfilPresence: _dawahMahfilPresCtrl.text.trim(),
      leafletDistributed: _leafletDistCtrl.text.trim(),
      posterPasted: _posterPastedCtrl.text.trim(),
      administrativeUnitCount: _adminUnitCountCtrl.text.trim(),
      administrativeUnitName: _adminUnitNameCtrl.text.trim(),
      mosqueOrganizationCount: _mosqueOrgCountCtrl.text.trim(),
      generalMeetingCount: _generalMeetingCountCtrl.text.trim(),
      generalMeetingPresence: _generalMeetingPresCtrl.text.trim(),
      kormiMeetingCount: _kormiMeetingCountCtrl.text.trim(),
      kormiMeetingPresence: _kormiMeetingPresCtrl.text.trim(),
      totalIncome: _totalIncomeCtrl.text.trim(),
      totalExpense: _totalExpenseCtrl.text.trim(),
      newsReleaseCount: _newsReleaseCountCtrl.text.trim(),
      posterPublished: _posterPublishedCtrl.text.trim(),
      libraryBookCount: _libBookCountCtrl.text.trim(),
      libraryBookReadCount: _libBookReadCountCtrl.text.trim(),
      socialWelfareTaka: _socialWelfareTakaCtrl.text.trim(),
      remarks: _remarksCtrl.text.trim(),
    );
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final entry = _buildEntry();
    await ReportStorageService.saveSanghotonikEntry(entry);
    await _loadCurrentReport();
    setState(() {
      _isSaving = false;
      _isLocked = true;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('সাংগঠনিক রিপোর্ট সেভ করা হয়েছে ✓'),
          backgroundColor: _accentGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  @override
  Widget build(BuildContext context) {
    const monthNames = [
      'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
      'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
    ];
    return Scaffold(
      backgroundColor: _darkBg,
      appBar: AppBar(
        title: const Text('শাখা সাংগঠনিক রিপোর্ট',
            style: TextStyle(color: _textLight, fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        backgroundColor: _cardBg,
        iconTheme: const IconThemeData(color: _textLight),
        elevation: 0,
        actions: [
          if (_currentEntry != null && _isLocked)
            TextButton.icon(
              icon: const Icon(Icons.edit, color: _accentOrange, size: 16),
              label: const Text('এডিট করুন', style: TextStyle(color: _accentOrange, fontSize: 13, fontWeight: FontWeight.bold)),
              onPressed: () => setState(() => _isLocked = false),
            ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _BgPainter())),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _accentOrange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _accentOrange.withValues(alpha: 0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.group_work, color: _accentOrange, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${monthNames[widget.month - 1]} ${_bn(widget.year)} মাসের রিপোর্ট',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _accentOrange)),
                        Text(_currentEntry != null ? 'সর্বশেষ সেভ করা আছে' : 'এখনো সেভ করা হয়নি',
                            style: TextStyle(fontSize: 12, color: _currentEntry != null ? const Color(0xFF10B981) : const Color(0xFFF59E0B))),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),

                // Branch
                _sectionHeader('শাখার তথ্য'),
                _field('শাখার নাম', 'শাখার নাম লিখুন', _branchCtrl),
                const SizedBox(height: 20),

                // জনশক্তি (Manpower)
                _manpowerSection(),
                const SizedBox(height: 20),

                // দাওয়াত
                _dawahSection(),
                const SizedBox(height: 20),

                // সংগঠন
                _organizationSection(),
                const SizedBox(height: 20),

                // সভাসমূহ
                _meetingsSection(),
                const SizedBox(height: 20),

                // অন্যান্য
                _miscSection(),
                const SizedBox(height: 20),

                // মন্তব্য
                _sectionHeader('মন্তব্য'),
                _field('মন্তব্য (সমস্যা ও সম্ভাবনা)', 'কোনো বিশেষ তথ্য...', _remarksCtrl, maxLines: 3),
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
                        backgroundColor: _accentOrange,
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

  Widget _manpowerSection() {
    return Container(
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor)),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('জনশক্তি', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _accentOrange)),
        const SizedBox(height: 14),
        _threeColRow('সদস্য সংখ্যা', _sodossoCountCtrl, 'বৃদ্ধি', _sodossoBridhiCtrl, 'ঘাটতি', _sodossoGhattiCtrl),
        _threeColRow('সদস্য প্রার্থী', _sodossoPrarthiCountCtrl, 'বৃদ্ধি', _sodossoPrarthiBridhiCtrl, 'ঘাটতি', _sodossoPrarthiGhattiCtrl),
        _threeColRow('কর্মী সংখ্যা', _kormiCountCtrl, 'বৃদ্ধি', _kormiBridhiCtrl, 'ঘাটতি', _kormiGhattiCtrl),
        _threeColRow('প্রাথমিক সদস্য', _prathmikCountCtrl, 'বৃদ্ধি', _prathmikBridhiCtrl, 'ঘাটতি', _prathmikGhattiCtrl),
        _field('সুধী / শুভাকাঙ্ক্ষী সংখ্যা', 'সংখ্যা', _sudhiCountCtrl),
      ]),
    );
  }

  Widget _dawahSection() {
    return Container(
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor)),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('দাওয়াত ও গণসংযোগ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _accentOrange)),
        const SizedBox(height: 14),
        _twoColRow('ব্যক্তিগত দাওয়াত দান (সংখ্যা)', _dawahPersonalCountCtrl, 'উপস্থিতি (গড়)', _dawahPersonalPresCtrl),
        _twoColRow('গ্রুপ দাওয়াত (সংখ্যা)', _dawahGroupCountCtrl, 'উপস্থিতি (গড়)', _dawahGroupPresCtrl),
        _twoColRow('দাওয়াতী মাহফিল / সভা', _dawahMahfilCountCtrl, 'উপস্থিতি (গড়)', _dawahMahfilPresCtrl),
        _twoColRow('পরিচিতি/লিফলেট বিতরণ', _leafletDistCtrl, 'পোস্টার pasted', _posterPastedCtrl),
      ]),
    );
  }

  Widget _organizationSection() {
    return Container(
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor)),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('সংগঠন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _accentOrange)),
        const SizedBox(height: 14),
        _twoColRow('প্রশাসনিক ইউনিট (সংখ্যা)', _adminUnitCountCtrl, 'সংগঠন বা নাম', _adminUnitNameCtrl),
        _field('মসজিদ ভিত্তিক সংগঠন (সংখ্যা)', 'সংখ্যা', _mosqueOrgCountCtrl),
      ]),
    );
  }

  Widget _meetingsSection() {
    return Container(
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor)),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('সভাসমূহ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _accentOrange)),
        const SizedBox(height: 14),
        _twoColRow('সাধারণ সভা (সংখ্যা)', _generalMeetingCountCtrl, 'উপস্থিতি (গড়)', _generalMeetingPresCtrl),
        _twoColRow('কর্মী সভা / সমাবেশ', _kormiMeetingCountCtrl, 'উপস্থিতি (গড়)', _kormiMeetingPresCtrl),
      ]),
    );
  }

  Widget _miscSection() {
    return Container(
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor)),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('বায়তুলমাল, প্রচার ও লাইব্রেরি', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _accentOrange)),
        const SizedBox(height: 14),
        _twoColRow('বায়তুলমাল মোট আয় (৳)', _totalIncomeCtrl, 'মোট ব্যয় (৳)', _totalExpenseCtrl),
        _twoColRow('সংবাদ বিজ্ঞপ্তি (সংখ্যা)', _newsReleaseCountCtrl, 'পোস্টার প্রকাশিত', _posterPublishedCtrl),
        _twoColRow('লাইব্রেরিতে বই সংখ্যা', _libBookCountCtrl, 'পঠিত বই সংখ্যা', _libBookReadCountCtrl),
        _field('সমাজকল্যাণ অনুদান বিতরণ (৳)', 'পরিমাণ টাকা', _socialWelfareTakaCtrl),
      ]),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(width: 4, height: 20, decoration: BoxDecoration(color: _accentOrange, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFDBA74))),
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
                borderSide: const BorderSide(color: _accentOrange, width: 1.5),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label2, style: const TextStyle(color: _textMuted, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                _miniField(ctrl2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _threeColRow(String sectionLabel, TextEditingController ctrl1, String label2, TextEditingController ctrl2, String label3, TextEditingController ctrl3) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sectionLabel, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('সংখ্যা', style: TextStyle(color: _textMuted, fontSize: 11)),
                    const SizedBox(height: 4),
                    _miniField(ctrl1),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label2, style: const TextStyle(color: _textMuted, fontSize: 11)),
                    const SizedBox(height: 4),
                    _miniField(ctrl2),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label3, style: const TextStyle(color: _textMuted, fontSize: 11)),
                    const SizedBox(height: 4),
                    _miniField(ctrl3),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniField(TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      enabled: !_isLocked,
      style: const TextStyle(fontSize: 13, color: _textLight),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _accentOrange),
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

class _BgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = Colors.orange.withValues(alpha: 0.025)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.05), 130, fill);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.5), 100, fill);

    final grid = Paint()..color = Colors.orange.withValues(alpha: 0.012)..strokeWidth = 0.5..style = PaintingStyle.stroke;
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
  bool shouldRepaint(_BgPainter _) => false;
}
