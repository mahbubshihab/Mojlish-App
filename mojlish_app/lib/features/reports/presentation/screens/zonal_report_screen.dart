import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/models/zonal_report_entry.dart';
import '../../data/services/report_storage_service.dart';

class ZonalReportScreen extends StatefulWidget {
  final int year;
  final int month;

  const ZonalReportScreen({super.key, required this.year, required this.month});

  @override
  State<ZonalReportScreen> createState() => _ZonalReportScreenState();
}

class _ZonalReportScreenState extends State<ZonalReportScreen> {
  bool _isSaving = false;
  bool _isLocked = true;
  ZonalReportEntry? _currentEntry;

  // Controllers
  final _zoneNameCtrl = TextEditingController();

  // জনশক্তি (Manpower)
  final _sodossoCountCtrl = TextEditingController();
  final _sodossoBridhiCtrl = TextEditingController();
  final _sodossoGhattiCtrl = TextEditingController();
  final _sodossoPrarthiCountCtrl = TextEditingController();
  final _sodossoPrarthiBridhiCtrl = TextEditingController();
  final _sodossoPrarthiGhattiCtrl = TextEditingController();

  // সংগঠন (Organization)
  final _distCountCtrl = TextEditingController();
  final _distOrgCtrl = TextEditingController();
  final _distReorgCtrl = TextEditingController();
  final _cityCountCtrl = TextEditingController();
  final _cityOrgCtrl = TextEditingController();
  final _cityReorgCtrl = TextEditingController();
  final _upazilaCountCtrl = TextEditingController();
  final _upazilaOrgCtrl = TextEditingController();
  final _upazilaReorgCtrl = TextEditingController();

  // সভা/প্রশিক্ষণ (Meeting/Training)
  final _shakhaDaitoshilCountCtrl = TextEditingController();
  final _shakhaDaitoshilPresCtrl = TextEditingController();
  final _distExecCountCtrl = TextEditingController();
  final _distExecPresCtrl = TextEditingController();
  final _zonalTorbiotCountCtrl = TextEditingController();
  final _zonalTorbiotPresCtrl = TextEditingController();

  // সফর (জোন থেকে)
  final _travelDetailsCtrl = TextEditingController();

  // আয়-ব্যয় (Income-Expense summary)
  final _safarIncomeTakaCtrl = TextEditingController();
  final _centralIncomeTakaCtrl = TextEditingController();
  final _onetimeIncomeTakaCtrl = TextEditingController();
  final _safarExpenseTakaCtrl = TextEditingController();
  final _communicationExpenseTakaCtrl = TextEditingController();
  final _officeExpenseTakaCtrl = TextEditingController();
  final _otherExpenseTakaCtrl = TextEditingController();

  // অন্যান্য (Other status counters)
  final _shakhaReportSubCtrl = TextEditingController();
  final _shakhaPlanSubCtrl = TextEditingController();
  final _shakhaBaytulmalSubCtrl = TextEditingController();

  // মন্তব্য ও পরামর্শ
  final _remarksCtrl = TextEditingController();
  final _suggestionsCtrl = TextEditingController();

  static const _darkBg = Color(0xFF0D1B2A);
  static const _cardBg = Color(0xFF162032);
  static const _borderColor = Color(0xFF2A3F58);
  static const _accentPurple = Colors.purple;
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
      _zoneNameCtrl, _sodossoCountCtrl, _sodossoBridhiCtrl, _sodossoGhattiCtrl,
      _sodossoPrarthiCountCtrl, _sodossoPrarthiBridhiCtrl, _sodossoPrarthiGhattiCtrl,
      _distCountCtrl, _distOrgCtrl, _distReorgCtrl, _cityCountCtrl, _cityOrgCtrl,
      _cityReorgCtrl, _upazilaCountCtrl, _upazilaOrgCtrl, _upazilaReorgCtrl,
      _shakhaDaitoshilCountCtrl, _shakhaDaitoshilPresCtrl,
      _distExecCountCtrl, _distExecPresCtrl, _zonalTorbiotCountCtrl, _zonalTorbiotPresCtrl,
      _travelDetailsCtrl, _safarIncomeTakaCtrl, _centralIncomeTakaCtrl, _onetimeIncomeTakaCtrl,
      _safarExpenseTakaCtrl, _communicationExpenseTakaCtrl, _officeExpenseTakaCtrl,
      _otherExpenseTakaCtrl, _shakhaReportSubCtrl, _shakhaPlanSubCtrl,
      _shakhaBaytulmalSubCtrl, _remarksCtrl, _suggestionsCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadCurrentReport() async {
    try {
      final entry = await ReportStorageService.getZonalEntry(widget.year, widget.month);
      if (entry != null && mounted) {
        setState(() {
          _isLocked = true;
          _currentEntry = entry;
          _zoneNameCtrl.text = entry.zoneName;
          _sodossoCountCtrl.text = entry.sodossoCount;
          _sodossoBridhiCtrl.text = entry.sodossoBridhi;
          _sodossoGhattiCtrl.text = entry.sodossoGhatti;
          _sodossoPrarthiCountCtrl.text = entry.sodossoPrarthiCount;
          _sodossoPrarthiBridhiCtrl.text = entry.sodossoPrarthiBridhi;
          _sodossoPrarthiGhattiCtrl.text = entry.sodossoPrarthiGhatti;
          _distCountCtrl.text = entry.districtCount;
          _distOrgCtrl.text = entry.districtOrg;
          _distReorgCtrl.text = entry.districtReorg;
          _cityCountCtrl.text = entry.cityCount;
          _cityOrgCtrl.text = entry.cityOrg;
          _cityReorgCtrl.text = entry.cityReorg;
          _upazilaCountCtrl.text = entry.upazilaThanaCount;
          _upazilaOrgCtrl.text = entry.upazilaThanaOrg;
          _upazilaReorgCtrl.text = entry.upazilaThanaReorg;
          _shakhaDaitoshilCountCtrl.text = entry.shakhaDaitoshilCount;
          _shakhaDaitoshilPresCtrl.text = entry.shakhaDaitoshilPresence;
          _distExecCountCtrl.text = entry.districtExecCount;
          _distExecPresCtrl.text = entry.districtExecPresence;
          _zonalTorbiotCountCtrl.text = entry.zonalTorbiotCount;
          _zonalTorbiotPresCtrl.text = entry.zonalTorbiotPresence;
          _travelDetailsCtrl.text = entry.travelDetails;
          _safarIncomeTakaCtrl.text = entry.safarIncomeTaka;
          _centralIncomeTakaCtrl.text = entry.centralIncomeTaka;
          _onetimeIncomeTakaCtrl.text = entry.onetimeIncomeTaka;
          _safarExpenseTakaCtrl.text = entry.safarExpenseTaka;
          _communicationExpenseTakaCtrl.text = entry.communicationExpenseTaka;
          _officeExpenseTakaCtrl.text = entry.officeExpenseTaka;
          _otherExpenseTakaCtrl.text = entry.otherExpenseTaka;
          _shakhaReportSubCtrl.text = entry.shakhaReportSubmitted;
          _shakhaPlanSubCtrl.text = entry.shakhaPlanSubmitted;
          _shakhaBaytulmalSubCtrl.text = entry.shakhaBaytulmalSubmitted;
          _remarksCtrl.text = entry.remarks;
          _suggestionsCtrl.text = entry.suggestions;
        });
      } else {
        setState(() {
          _isLocked = false;
          _currentEntry = null;
        });
      }
    } catch (_) {}
  }

  ZonalReportEntry _buildEntry() {
    return ZonalReportEntry(
      month: widget.month.toString().padLeft(2, '0'),
      year: widget.year.toString(),
      zoneName: _zoneNameCtrl.text.trim(),
      sodossoCount: _sodossoCountCtrl.text.trim(),
      sodossoBridhi: _sodossoBridhiCtrl.text.trim(),
      sodossoGhatti: _sodossoGhattiCtrl.text.trim(),
      sodossoPrarthiCount: _sodossoPrarthiCountCtrl.text.trim(),
      sodossoPrarthiBridhi: _sodossoPrarthiBridhiCtrl.text.trim(),
      sodossoPrarthiGhatti: _sodossoPrarthiGhattiCtrl.text.trim(),
      districtCount: _distCountCtrl.text.trim(),
      districtOrg: _distOrgCtrl.text.trim(),
      districtReorg: _distReorgCtrl.text.trim(),
      cityCount: _cityCountCtrl.text.trim(),
      cityOrg: _cityOrgCtrl.text.trim(),
      cityReorg: _cityReorgCtrl.text.trim(),
      upazilaThanaCount: _upazilaCountCtrl.text.trim(),
      upazilaThanaOrg: _upazilaOrgCtrl.text.trim(),
      upazilaThanaReorg: _upazilaReorgCtrl.text.trim(),
      shakhaDaitoshilCount: _shakhaDaitoshilCountCtrl.text.trim(),
      shakhaDaitoshilPresence: _shakhaDaitoshilPresCtrl.text.trim(),
      districtExecCount: _distExecCountCtrl.text.trim(),
      districtExecPresence: _distExecPresCtrl.text.trim(),
      zonalTorbiotCount: _zonalTorbiotCountCtrl.text.trim(),
      zonalTorbiotPresence: _zonalTorbiotPresCtrl.text.trim(),
      travelDetails: _travelDetailsCtrl.text.trim(),
      safarIncomeTaka: _safarIncomeTakaCtrl.text.trim(),
      centralIncomeTaka: _centralIncomeTakaCtrl.text.trim(),
      onetimeIncomeTaka: _onetimeIncomeTakaCtrl.text.trim(),
      safarExpenseTaka: _safarExpenseTakaCtrl.text.trim(),
      communicationExpenseTaka: _communicationExpenseTakaCtrl.text.trim(),
      officeExpenseTaka: _officeExpenseTakaCtrl.text.trim(),
      otherExpenseTaka: _otherExpenseTakaCtrl.text.trim(),
      shakhaReportSubmitted: _shakhaReportSubCtrl.text.trim(),
      shakhaPlanSubmitted: _shakhaPlanSubCtrl.text.trim(),
      shakhaBaytulmalSubmitted: _shakhaBaytulmalSubCtrl.text.trim(),
      remarks: _remarksCtrl.text.trim(),
      suggestions: _suggestionsCtrl.text.trim(),
    );
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final entry = _buildEntry();
    await ReportStorageService.saveZonalEntry(entry);
    await _loadCurrentReport();
    setState(() {
      _isSaving = false;
      _isLocked = true;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('জোনাল রিপোর্ট সেভ করা হয়েছে ✓'),
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
        title: const Text('শাখা জোনাল রিপোর্ট',
            style: TextStyle(color: _textLight, fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        backgroundColor: _cardBg,
        iconTheme: const IconThemeData(color: _textLight),
        elevation: 0,
        actions: [
          if (_currentEntry != null && _isLocked)
            TextButton.icon(
              icon: const Icon(Icons.edit, color: _accentPurple, size: 16),
              label: const Text('এডিট করুন', style: TextStyle(color: _accentPurple, fontSize: 13, fontWeight: FontWeight.bold)),
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
                    color: _accentPurple.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _accentPurple.withValues(alpha: 0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.map, color: _accentPurple, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${monthNames[widget.month - 1]} ${_bn(widget.year)} মাসের রিপোর্ট',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _accentPurple)),
                        Text(_currentEntry != null ? 'সর্বশেষ সেভ করা আছে' : 'এখনো সেভ করা হয়নি',
                            style: TextStyle(fontSize: 12, color: _currentEntry != null ? const Color(0xFF10B981) : const Color(0xFFF59E0B))),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),

                // Zone
                _sectionHeader('জোনের তথ্য'),
                _field('জোনের নাম', 'জোনের নাম লিখুন', _zoneNameCtrl),
                const SizedBox(height: 20),

                // জনশক্তি
                _manpowerSection(),
                const SizedBox(height: 20),

                // সংগঠন
                _organizationSection(),
                const SizedBox(height: 20),

                // সভা/প্রশিক্ষণ
                _meetingsSection(),
                const SizedBox(height: 20),

                // সফর
                _sectionHeader('সফর (জোন থেকে)'),
                _field('সফর বিবরণী ও লক্ষ্য', 'তারিখ, শাখার নাম, উপলক্ষ ও মেহমান...', _travelDetailsCtrl, maxLines: 3),
                const SizedBox(height: 20),

                // আয়-ব্যয়
                _incomeExpenseSection(),
                const SizedBox(height: 20),

                // জমা রিপোর্ট
                _submissionCountersSection(),
                const SizedBox(height: 20),

                // মন্তব্য ও পরামর্শ
                _sectionHeader('মন্তব্য ও পরামর্শ'),
                _field('মন্তব্য', 'কোনো বিশেষ তথ্য...', _remarksCtrl, maxLines: 2),
                _field('পরামর্শ', 'কেন্দ্রীয় কার্যকরী কমিটির নিকট পরামর্শ...', _suggestionsCtrl, maxLines: 2),
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
                        backgroundColor: _accentPurple,
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
        const Text('জনশক্তি', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _accentPurple)),
        const SizedBox(height: 14),
        _threeColRow('সদস্য', _sodossoCountCtrl, 'বৃদ্ধি', _sodossoBridhiCtrl, 'ঘাটতি', _sodossoGhattiCtrl),
        _threeColRow('সদস্য প্রার্থী', _sodossoPrarthiCountCtrl, 'বৃদ্ধি', _sodossoPrarthiBridhiCtrl, 'ঘাটতি', _sodossoPrarthiGhattiCtrl),
      ]),
    );
  }

  Widget _organizationSection() {
    return Container(
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor)),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('সংগঠন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _accentPurple)),
        const SizedBox(height: 14),
        _threeColRow('জেলা', _distCountCtrl, 'সংগঠন', _distOrgCtrl, 'পুনর্গঠন', _distReorgCtrl),
        _threeColRow('মহানগরী', _cityCountCtrl, 'সংগঠন', _cityOrgCtrl, 'পুনর্গঠন', _cityReorgCtrl),
        _threeColRow('উপজেলা / থানা', _upazilaCountCtrl, 'সংগঠন', _upazilaOrgCtrl, 'পুনর্গঠন', _upazilaReorgCtrl),
      ]),
    );
  }

  Widget _meetingsSection() {
    return Container(
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor)),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('সভা / প্রশিক্ষণ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _accentPurple)),
        const SizedBox(height: 14),
        _twoColRow('শাখা দায়িত্বশীল বৈঠক (সংখ্যা)', _shakhaDaitoshilCountCtrl, 'উপস্থিতি (গড়)', _shakhaDaitoshilPresCtrl),
        _twoColRow('জেলা নির্বাহী বৈঠক (সংখ্যা)', _distExecCountCtrl, 'উপস্থিতি (গড়)', _distExecPresCtrl),
        _twoColRow('জোনাল তরবিয়তী মজলিস (সংখ্যা)', _zonalTorbiotCountCtrl, 'উপস্থিতি (গড়)', _zonalTorbiotPresCtrl),
      ]),
    );
  }

  Widget _incomeExpenseSection() {
    return Container(
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor)),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('আয়-ব্যয় সংক্ষেপ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _accentPurple)),
        const SizedBox(height: 14),
        _twoColRow('সফর আয় (৳)', _safarIncomeTakaCtrl, 'কেন্দ্র থেকে বরাদ্দ (৳)', _centralIncomeTakaCtrl),
        _field('এককালীন আয় (৳)', 'পরিমাণ টাকা', _onetimeIncomeTakaCtrl),
        const Divider(color: _borderColor),
        _twoColRow('সফর ব্যয় (৳)', _safarExpenseTakaCtrl, 'যোগাযোগ ব্যয় (৳)', _communicationExpenseTakaCtrl),
        _twoColRow('অফিস ব্যয় (৳)', _officeExpenseTakaCtrl, 'অন্যান্য ব্যয় (৳)', _otherExpenseTakaCtrl),
      ]),
    );
  }

  Widget _submissionCountersSection() {
    return Container(
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor)),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('জমা তথ্য বিবরণী', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _accentPurple)),
        const SizedBox(height: 14),
        _field('শাখা রিপোর্ট জমা হয়েছে (টি)', 'টি', _shakhaReportSubCtrl),
        _field('শাখার পরিকল্পনা জমা হয়েছে (টি)', 'টি', _shakhaPlanSubCtrl),
        _field('শাখার বায়তুলমাল জমা হয়েছে (টি)', 'টি', _shakhaBaytulmalSubCtrl),
      ]),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(width: 4, height: 20, decoration: BoxDecoration(color: _accentPurple, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFD8B4FE))),
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
                borderSide: const BorderSide(color: _accentPurple, width: 1.5),
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
          borderSide: const BorderSide(color: _accentPurple),
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
    final fill = Paint()..color = Colors.purple.withValues(alpha: 0.025)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.05), 130, fill);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.5), 100, fill);

    final grid = Paint()..color = Colors.purple.withValues(alpha: 0.012)..strokeWidth = 0.5..style = PaintingStyle.stroke;
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
