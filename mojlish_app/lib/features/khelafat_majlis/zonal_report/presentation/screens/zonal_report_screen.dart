import 'package:flutter/material.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/data/models/zonal_report_entry.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';

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

  // উপশাখার রিপোর্ট ও পরিকল্পনা প্রাপ্তি
  final _shakhaReportSubCtrl = TextEditingController();
  final _shakhaPlanSubCtrl = TextEditingController();
  final _shakhaBaytulmalSubCtrl = TextEditingController();

  // মন্তব্য ও পরামর্শ
  final _remarksCtrl = TextEditingController();
  final _suggestionsCtrl = TextEditingController();

  // Colors
  final Color _accentGreen = const Color(0xFF10B981);
  final Color _accentPurple = Colors.purple;
  final Color _cardBg = const Color(0xFF1E293B);
  final Color _borderColor = const Color(0xFF334155);
  final Color _textLight = const Color(0xFFF8FAFC);
  final Color _textMuted = const Color(0xFF94A3B8);

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentReport();
  }

  @override
  void dispose() {
    for (var c in [
      _zoneNameCtrl, _sodossoCountCtrl, _sodossoBridhiCtrl, _sodossoGhattiCtrl,
      _sodossoPrarthiCountCtrl, _sodossoPrarthiBridhiCtrl, _sodossoPrarthiGhattiCtrl,
      _distCountCtrl, _distOrgCtrl, _distReorgCtrl, _cityCountCtrl, _cityOrgCtrl,
      _cityReorgCtrl, _upazilaCountCtrl, _upazilaOrgCtrl, _upazilaReorgCtrl,
      _shakhaDaitoshilCountCtrl, _shakhaDaitoshilPresCtrl, _distExecCountCtrl,
      _distExecPresCtrl, _zonalTorbiotCountCtrl, _zonalTorbiotPresCtrl,
      _travelDetailsCtrl, _safarIncomeTakaCtrl, _centralIncomeTakaCtrl,
      _onetimeIncomeTakaCtrl, _safarExpenseTakaCtrl, _communicationExpenseTakaCtrl,
      _officeExpenseTakaCtrl, _otherExpenseTakaCtrl, _shakhaReportSubCtrl,
      _shakhaPlanSubCtrl, _shakhaBaytulmalSubCtrl, _remarksCtrl, _suggestionsCtrl
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
      updatedAt: DateTime.now().millisecondsSinceEpoch,
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
          content: const Text('জোনাল রিপোর্ট সফলভাবে সেভ ও লক করা হয়েছে ✓'),
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

  Future<void> _exportPdf() async {
    final yearStr = _bn(widget.year);
    final monthStr = _monthNames[widget.month - 1];

    await PdfExportService.printOrDownloadPdf(
      title: 'জোনাল রিপোর্ট ফরম',
      majlisName: 'বাংলাদেশ খেলাফত মজলিস',
      userName: _zoneNameCtrl.text.isEmpty ? 'জোন পরিচালক' : _zoneNameCtrl.text,
      period: '$monthStr $yearStr',
      dataFields: {
        'জোনের নাম': _zoneNameCtrl.text,
        'সদস্য সংখ্যা/বৃদ্ধি/ঘাটতি': '${_sodossoCountCtrl.text} / ${_sodossoBridhiCtrl.text} / ${_sodossoGhattiCtrl.text}',
        'সদস্য প্রার্থী সংখ্যা/বৃদ্ধি/ঘাটতি': '${_sodossoPrarthiCountCtrl.text} / ${_sodossoPrarthiBridhiCtrl.text} / ${_sodossoPrarthiGhattiCtrl.text}',
        'জেলা শাখা গঠন/পুনর্গঠন': '${_distCountCtrl.text} / ${_distOrgCtrl.text} / ${_distReorgCtrl.text}',
        'মহানগর শাখা গঠন/পুনর্গঠন': '${_cityCountCtrl.text} / ${_cityOrgCtrl.text} / ${_cityReorgCtrl.text}',
        'উপজেলা/থানা শাখা': '${_upazilaCountCtrl.text} / ${_upazilaOrgCtrl.text} / ${_upazilaReorgCtrl.text}',
        'শাখা দায়িত্বশীল বৈঠক': '${_shakhaDaitoshilCountCtrl.text} (উপস্থিতি: ${_shakhaDaitoshilPresCtrl.text})',
        'জেলা নির্বাহী বৈঠক': '${_distExecCountCtrl.text} (উপস্থিতি: ${_distExecPresCtrl.text})',
        'জোনাল তরবিয়ত বৈঠক': '${_zonalTorbiotCountCtrl.text} (উপস্থিতি: ${_zonalTorbiotPresCtrl.text})',
        'জোন সফর বিবরণী': _travelDetailsCtrl.text,
        'সফর/কেন্দ্রীয়/এককালীন আয়': '${_safarIncomeTakaCtrl.text} / ${_centralIncomeTakaCtrl.text} / ${_onetimeIncomeTakaCtrl.text}',
        'সফর/যোগাযোগ/দফতর ব্যয়': '${_safarExpenseTakaCtrl.text} / ${_communicationExpenseTakaCtrl.text} / ${_officeExpenseTakaCtrl.text}',
        'উপশাখার রিপোর্ট প্রাপ্তি': _shakhaReportSubCtrl.text,
        'উপশাখার পরিকল্পনা প্রাপ্তি': _shakhaPlanSubCtrl.text,
      },
      comments: '${_remarksCtrl.text}\n\nপরামর্শ: ${_suggestionsCtrl.text}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthStr = _monthNames[widget.month - 1];
    final yearStr = _bn(widget.year);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _cardBg,
          elevation: 1,
          title: Text(
            'জোনাল রিপোর্ট — $monthStr $yearStr',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          bottom: TabBar(
            indicatorColor: _accentPurple,
            indicatorWeight: 3,
            labelColor: _accentPurple,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: const [
              Tab(icon: Icon(Icons.edit_note_rounded), text: '১. তথ্য পূরণ'),
              Tab(icon: Icon(Icons.print_rounded), text: '২. প্রিভিউ ও PDF'),
            ],
          ),
        ),
        body: AmbientBackgroundWidget(
          primaryAccent: _accentPurple,
          child: TabBarView(
            children: [
              _buildFormTab(),
              _buildPreviewTab(),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TAB 1: FORM ENTRY & EDIT LOCKING
  // ==========================================
  Widget _buildFormTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
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
                        ? '🔒 জোনাল রিপোর্টটি সংরক্ষিত ও লকড অবস্থায় আছে। পরিবর্তন করতে এডিট বাটনে ক্লিক করুন।'
                        : '📝 তথ্য পূরণ করুন এবং নিচে সংরক্ষণ বাটনে চাপ দিন।',
                    style: TextStyle(
                      color: _textLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _buildSectionCard('১. জোনের নাম', [
            _buildInputField('জোনের নাম', _zoneNameCtrl),
          ]),
          const SizedBox(height: 16),

          _buildSectionCard('২. জনশক্তি সংখ্যা ও পরিবর্তন', [
            _build3ColHeader('শ্রেণী', 'সংখ্যা', 'বৃদ্ধি', 'ঘাটতি'),
            const SizedBox(height: 8),
            _build3ColRow('সদস্য', _sodossoCountCtrl, _sodossoBridhiCtrl, _sodossoGhattiCtrl),
            _build3ColRow('সদস্য প্রার্থী', _sodossoPrarthiCountCtrl, _sodossoPrarthiBridhiCtrl, _sodossoPrarthiGhattiCtrl),
          ]),
          const SizedBox(height: 16),

          _buildSectionCard('৩. সাংগঠনিক স্তর ও শাখা বিস্তার', [
            _build3ColHeader('স্তর', 'সংখ্যা', 'গঠন', 'পুনর্গঠন'),
            const SizedBox(height: 8),
            _build3ColRow('জেলা শাখা', _distCountCtrl, _distOrgCtrl, _distReorgCtrl),
            _build3ColRow('মহানগর শাখা', _cityCountCtrl, _cityOrgCtrl, _cityReorgCtrl),
            _build3ColRow('উপজেলা/থানা শাখা', _upazilaCountCtrl, _upazilaOrgCtrl, _upazilaReorgCtrl),
          ]),
          const SizedBox(height: 16),

          _buildSectionCard('৪. বৈঠক ও প্রশিক্ষণ কর্মসূচি', [
            _build2ColRow('শাখা দায়িত্বশীল বৈঠক (সংখ্যা ও উপস্থিতি)', _shakhaDaitoshilCountCtrl, _shakhaDaitoshilPresCtrl),
            _build2ColRow('জেলা নির্বাহী বৈঠক (সংখ্যা ও উপস্থিতি)', _distExecCountCtrl, _distExecPresCtrl),
            _build2ColRow('জোনাল তরবিয়ত বৈঠক (সংখ্যা ও উপস্থিতি)', _zonalTorbiotCountCtrl, _zonalTorbiotPresCtrl),
          ]),
          const SizedBox(height: 16),

          _buildSectionCard('৫. সফর বিবরণী (জোন থেকে)', [
            _buildInputField('সফরের বিবরণ ও পরিক্রমা', _travelDetailsCtrl, maxLines: 3),
          ]),
          const SizedBox(height: 16),

          _buildSectionCard('৬. আয় ও ব্যয়ের হিসাব (টাকা)', [
            _build2ColRow('সফর আয় ও ব্যয়', _safarIncomeTakaCtrl, _safarExpenseTakaCtrl),
            _build2ColRow('কেন্দ্রীয় আয় ও যোগাযোগ ব্যয়', _centralIncomeTakaCtrl, _communicationExpenseTakaCtrl),
            _build2ColRow('এককালীন আয় ও দফতর ব্যয়', _onetimeIncomeTakaCtrl, _officeExpenseTakaCtrl),
          ]),
          const SizedBox(height: 16),

          _buildSectionCard('৭. উপশাখার রিপোর্ট ও পরিকল্পনা জমা', [
            _buildInputField('রিপোর্ট জমাদানকারী শাখা সংখ্যা', _shakhaReportSubCtrl),
            _buildInputField('পরিকল্পনা জমাদানকারী শাখা সংখ্যা', _shakhaPlanSubCtrl),
          ]),
          const SizedBox(height: 16),

          _buildSectionCard('৮. পর্যবেক্ষণ ও পরামর্শ', [
            _buildInputField('জোনের সার্বিক পর্যবেক্ষণ', _remarksCtrl, maxLines: 2),
            _buildInputField('কেন্দ্রের জন্য পরামর্শ/সুপারিশ', _suggestionsCtrl, maxLines: 2),
          ]),
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
    );
  }

  // ==========================================
  // TAB 2: FORMATTED PREVIEW & PDF DOWNLOAD
  // ==========================================
  Widget _buildPreviewTab() {
    final monthStr = _monthNames[widget.month - 1];
    final yearStr = _bn(widget.year);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Top PDF Download Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _exportPdf,
              icon: const Icon(Icons.picture_as_pdf_rounded, size: 22),
              label: const Text('PDF ডাউনলোড / প্রিন্ট করুন', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Printable Preview Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _cardBg.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _accentPurple.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'বাংলাদেশ খেলাফত মজলিস',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'জোনাল রিপোর্ট — $monthStr $yearStr',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textLight),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'জোন: ${_zoneNameCtrl.text.isEmpty ? "(জোনের নাম প্রদান করুন)" : _zoneNameCtrl.text}',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: _accentPurple),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 30, thickness: 1),

                _buildPreviewRow('সদস্য সংখ্যা/বৃদ্ধি/ঘাটতি', '${_sodossoCountCtrl.text} / ${_sodossoBridhiCtrl.text} / ${_sodossoGhattiCtrl.text}'),
                _buildPreviewRow('সদস্য প্রার্থী সংখ্যা/বৃদ্ধি/ঘাটতি', '${_sodossoPrarthiCountCtrl.text} / ${_sodossoPrarthiBridhiCtrl.text} / ${_sodossoPrarthiGhattiCtrl.text}'),
                _buildPreviewRow('জেলা শাখা গঠন/পুনর্গঠন', '${_distCountCtrl.text} / ${_distOrgCtrl.text} / ${_distReorgCtrl.text}'),
                _buildPreviewRow('মহানগর শাখা গঠন/পুনর্গঠন', '${_cityCountCtrl.text} / ${_cityOrgCtrl.text} / ${_cityReorgCtrl.text}'),
                _buildPreviewRow('উপজেলা/থানা শাখা', '${_upazilaCountCtrl.text} / ${_upazilaOrgCtrl.text} / ${_upazilaReorgCtrl.text}'),
                _buildPreviewRow('শাখা দায়িত্বশীল বৈঠক', '${_shakhaDaitoshilCountCtrl.text} (উপস্থিতি: ${_shakhaDaitoshilPresCtrl.text})'),
                _buildPreviewRow('জেলা নির্বাহী বৈঠক', '${_distExecCountCtrl.text} (উপস্থিতি: ${_distExecPresCtrl.text})'),
                _buildPreviewRow('জোনাল তরবিয়ত বৈঠক', '${_zonalTorbiotCountCtrl.text} (উপস্থিতি: ${_zonalTorbiotPresCtrl.text})'),
                _buildPreviewRow('জোন সফর বিবরণী', _travelDetailsCtrl.text),
                _buildPreviewRow('সফর/কেন্দ্রীয়/এককালীন আয়', '${_safarIncomeTakaCtrl.text} / ${_centralIncomeTakaCtrl.text} / ${_onetimeIncomeTakaCtrl.text}'),
                _buildPreviewRow('সফর/যোগাযোগ/দফতর ব্যয়', '${_safarExpenseTakaCtrl.text} / ${_communicationExpenseTakaCtrl.text} / ${_officeExpenseTakaCtrl.text}'),
                if (_currentEntry != null)
                  _buildPreviewRow('মোট আয় / ব্যয় / স্থিতি', '${_currentEntry!.totalIncome} / ${_currentEntry!.totalExpense} / ${_currentEntry!.balance}'),
                _buildPreviewRow('উপশাখার রিপোর্ট প্রাপ্তি', _shakhaReportSubCtrl.text),
                _buildPreviewRow('উপশাখার পরিকল্পনা প্রাপ্তি', _shakhaPlanSubCtrl.text),

                if (_remarksCtrl.text.isNotEmpty || _suggestionsCtrl.text.isNotEmpty) ...[
                  const Divider(height: 24),
                  Text('পর্যবেক্ষণ ও পরামর্শ:', style: TextStyle(fontWeight: FontWeight.bold, color: _textLight, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('পর্যবেক্ষণ: ${_remarksCtrl.text}', style: TextStyle(color: _textLight.withValues(alpha: 0.9), fontSize: 13.5)),
                  const SizedBox(height: 2),
                  Text('পরামর্শ: ${_suggestionsCtrl.text}', style: TextStyle(color: _textLight.withValues(alpha: 0.9), fontSize: 13.5)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPreviewRow(String title, String value) {
    final val = value.trim().isEmpty ? '—' : value.trim();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 155,
            child: Text(
              '$title:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, color: _textLight.withValues(alpha: 0.75)),
            ),
          ),
          Expanded(
            child: Text(
              val,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: _textLight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5, color: _accentPurple)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        enabled: !_isLocked,
        maxLines: maxLines,
        style: TextStyle(color: _textLight, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: _textMuted),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
          filled: _isLocked,
          fillColor: Colors.black.withValues(alpha: 0.04),
        ),
      ),
    );
  }

  Widget _build3ColHeader(String col1, String col2, String col3, String col4) {
    return Row(
      children: [
        Expanded(flex: 3, child: Text(col1, style: TextStyle(color: _textMuted, fontWeight: FontWeight.bold, fontSize: 13))),
        Expanded(flex: 2, child: Center(child: Text(col2, style: TextStyle(color: _textMuted, fontWeight: FontWeight.bold, fontSize: 13)))),
        Expanded(flex: 2, child: Center(child: Text(col3, style: TextStyle(color: _textMuted, fontWeight: FontWeight.bold, fontSize: 13)))),
        Expanded(flex: 2, child: Center(child: Text(col4, style: TextStyle(color: _textMuted, fontWeight: FontWeight.bold, fontSize: 13)))),
      ],
    );
  }

  Widget _build3ColRow(String title, TextEditingController c1, TextEditingController c2, TextEditingController c3) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(title, style: TextStyle(color: _textLight, fontSize: 13.5))),
          Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: _buildMiniField(c1))),
          Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: _buildMiniField(c2))),
          Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: _buildMiniField(c3))),
        ],
      ),
    );
  }

  Widget _build2ColRow(String title, TextEditingController c1, TextEditingController c2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: _textLight, fontSize: 13.5, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: _buildMiniField(c1)),
              const SizedBox(width: 8),
              Expanded(child: _buildMiniField(c2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniField(TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      enabled: !_isLocked,
      textAlign: TextAlign.center,
      style: TextStyle(color: _textLight, fontSize: 13.5),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        isDense: true,
        filled: _isLocked,
        fillColor: Colors.black.withValues(alpha: 0.04),
      ),
    );
  }
}
