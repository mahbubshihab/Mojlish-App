import 'package:flutter/material.dart';
import '../../../../common/widgets/unsaved_changes_guard.dart';
import '../../../../common/reports/data/services/report_storage_service.dart';
import '../../../../common/reports/data/models/zonal_report_entry.dart';
import '../../../../common/reports/presentation/screens/pdf_preview_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/zonal_report/data/services/khelafat_zonal_pdf_service.dart';

/// খেলাফত মজলিস — জোনাল রিপোর্ট ফরম (Full-width edge-to-edge design)
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
  bool _isLoading = false;
  bool _hasChanges = false;

  // Controllers
  final _zoneNameCtrl = TextEditingController();

  // জনশক্তি
  final _sodossoCountCtrl = TextEditingController();
  final _sodossoBridhiCtrl = TextEditingController();
  final _sodossoGhattiCtrl = TextEditingController();
  final _sodossoPrarthiCountCtrl = TextEditingController();
  final _sodossoPrarthiBridhiCtrl = TextEditingController();
  final _sodossoPrarthiGhattiCtrl = TextEditingController();

  // সংগঠন
  final _distCountCtrl = TextEditingController();
  final _distOrgCtrl = TextEditingController();
  final _distReorgCtrl = TextEditingController();
  final _cityCountCtrl = TextEditingController();
  final _cityOrgCtrl = TextEditingController();
  final _cityReorgCtrl = TextEditingController();
  final _upazilaCountCtrl = TextEditingController();
  final _upazilaOrgCtrl = TextEditingController();
  final _upazilaReorgCtrl = TextEditingController();

  // সভা/প্রশিক্ষণ
  final _shakhaDaitoshilCountCtrl = TextEditingController();
  final _shakhaDaitoshilPresCtrl = TextEditingController();
  final _distExecCountCtrl = TextEditingController();
  final _distExecPresCtrl = TextEditingController();
  final _zonalTorbiotCountCtrl = TextEditingController();
  final _zonalTorbiotPresCtrl = TextEditingController();

  // সফর (জোন থেকে)
  final _travelDetailsCtrl = TextEditingController();

  // আয়-ব্যয়
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

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
  ];

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() => _isLoading = true);
    final entry = await ReportStorageService.getZonalEntry(widget.year, widget.month);
    if (entry != null && mounted) {
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
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
        _hasChanges = false;
      });
    }
  }

  ZonalReportEntry _buildCurrentEntry() {
    return ZonalReportEntry(
      month: widget.month.toString().padLeft(2, '0'),
      year: widget.year.toString(),
      zoneName: _zoneNameCtrl.text,
      sodossoCount: _sodossoCountCtrl.text,
      sodossoBridhi: _sodossoBridhiCtrl.text,
      sodossoGhatti: _sodossoGhattiCtrl.text,
      sodossoPrarthiCount: _sodossoPrarthiCountCtrl.text,
      sodossoPrarthiBridhi: _sodossoPrarthiBridhiCtrl.text,
      sodossoPrarthiGhatti: _sodossoPrarthiGhattiCtrl.text,
      districtCount: _distCountCtrl.text,
      districtOrg: _distOrgCtrl.text,
      districtReorg: _distReorgCtrl.text,
      cityCount: _cityCountCtrl.text,
      cityOrg: _cityOrgCtrl.text,
      cityReorg: _cityReorgCtrl.text,
      upazilaThanaCount: _upazilaCountCtrl.text,
      upazilaThanaOrg: _upazilaOrgCtrl.text,
      upazilaThanaReorg: _upazilaReorgCtrl.text,
      shakhaDaitoshilCount: _shakhaDaitoshilCountCtrl.text,
      shakhaDaitoshilPresence: _shakhaDaitoshilPresCtrl.text,
      districtExecCount: _distExecCountCtrl.text,
      districtExecPresence: _distExecPresCtrl.text,
      zonalTorbiotCount: _zonalTorbiotCountCtrl.text,
      zonalTorbiotPresence: _zonalTorbiotPresCtrl.text,
      travelDetails: _travelDetailsCtrl.text,
      safarIncomeTaka: _safarIncomeTakaCtrl.text,
      centralIncomeTaka: _centralIncomeTakaCtrl.text,
      onetimeIncomeTaka: _onetimeIncomeTakaCtrl.text,
      safarExpenseTaka: _safarExpenseTakaCtrl.text,
      communicationExpenseTaka: _communicationExpenseTakaCtrl.text,
      officeExpenseTaka: _officeExpenseTakaCtrl.text,
      otherExpenseTaka: _otherExpenseTakaCtrl.text,
      shakhaReportSubmitted: _shakhaReportSubCtrl.text,
      shakhaPlanSubmitted: _shakhaPlanSubCtrl.text,
      shakhaBaytulmalSubmitted: _shakhaBaytulmalSubCtrl.text,
      remarks: _remarksCtrl.text,
      suggestions: _suggestionsCtrl.text,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
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

  String _bn(num n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) {
      final val = int.tryParse(c);
      return val != null ? digits[val] : c;
    }).join();
  }

  Future<bool> _saveReport() async {
    setState(() => _isSaving = true);
    final entry = _buildCurrentEntry();
    await ReportStorageService.saveZonalEntry(entry);
    if (mounted) {
      setState(() {
        _isSaving = false;
        _hasChanges = false;
        _isLocked = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('জোনাল তথ্য সফলভাবে সংরক্ষিত হয়েছে!'),
          backgroundColor: Color(0xFF1B5E20),
        ),
      );
    }
    return true;
  }

  void _openPdfViewer() async {
    final entry = _buildCurrentEntry();
    final pdfBytes = await KhelafatZonalPdfService.generatePdfBytes(entry: entry);
    if (mounted) {
      await PdfPreviewScreen.open(
        context,
        pdfBytes,
        'জোনাল রিপোর্ট — ${_monthNames[widget.month - 1]} ${_bn(widget.year)}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final appBarBg = isDark ? const Color(0xFF1E293B) : const Color(0xFF1B5E20);

    final monthStr = _monthNames[widget.month - 1];
    final yearStr = _bn(widget.year);

    return UnsavedChangesGuard(
      hasUnsavedChanges: !_isLocked && _hasChanges,
      onSave: () async {
        return await _saveReport();
      },
      child: Scaffold(
        backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'জোনাল রিপোর্ট — $monthStr $yearStr',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
                              onTap: _isSaving
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
                                  _isSaving
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Zone Name Banner
                        _buildSectionHeader(
                          context,
                          title: 'জোনাল তথ্য',
                          icon: Icons.map_rounded,
                          badge: 'মৌলিক',
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: _buildInputField('জোনের নাম', _zoneNameCtrl, hintText: 'যেমন: ঢাকা পূর্ব জোন...', isDark: isDark),
                  ),

                  const SizedBox(height: 8),

                  // 2. Manpower
                  _buildSectionHeader(
                    context,
                    title: '১. জনশক্তি',
                    icon: Icons.groups_rounded,
                    badge: 'জনশক্তি',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSubHeader('ক. সদস্য', isDark),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: _buildInputField('সদস্য সংখ্যা', _sodossoCountCtrl, isNumber: true, isDark: isDark)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInputField('সদস্য বৃদ্ধি', _sodossoBridhiCtrl, isNumber: true, isDark: isDark)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildInputField('সদস্য ঘাটতি', _sodossoGhattiCtrl, isNumber: true, isDark: isDark),

                        const SizedBox(height: 16),
                        _buildSubHeader('খ. সদস্য প্রার্থী', isDark),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: _buildInputField('প্রার্থী সংখ্যা', _sodossoPrarthiCountCtrl, isNumber: true, isDark: isDark)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInputField('প্রার্থী বৃদ্ধি', _sodossoPrarthiBridhiCtrl, isNumber: true, isDark: isDark)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildInputField('প্রার্থী ঘাটতি', _sodossoPrarthiGhattiCtrl, isNumber: true, isDark: isDark),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 3. Organization
                  _buildSectionHeader(
                    context,
                    title: '২. সংগঠন',
                    icon: Icons.account_tree_rounded,
                    badge: 'অধস্তন শাখা',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSubHeader('জেলা শাখা', isDark),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: _buildInputField('জেলা সংখ্যা', _distCountCtrl, isNumber: true, isDark: isDark)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInputField('গঠিত জেলা', _distOrgCtrl, isNumber: true, isDark: isDark)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildInputField('পুনর্গঠিত জেলা', _distReorgCtrl, isNumber: true, isDark: isDark),

                        const SizedBox(height: 16),
                        _buildSubHeader('মহানগরী শাখা', isDark),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: _buildInputField('মহানগরী সংখ্যা', _cityCountCtrl, isNumber: true, isDark: isDark)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInputField('গঠিত মহানগরী', _cityOrgCtrl, isNumber: true, isDark: isDark)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildInputField('পুনর্গঠিত মহানগরী', _cityReorgCtrl, isNumber: true, isDark: isDark),

                        const SizedBox(height: 16),
                        _buildSubHeader('উপজেলা / থানা শাখা', isDark),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: _buildInputField('উপজেলা/থানা সংখ্যা', _upazilaCountCtrl, isNumber: true, isDark: isDark)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInputField('গঠিত থানা', _upazilaOrgCtrl, isNumber: true, isDark: isDark)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildInputField('পুনর্গঠিত থানা', _upazilaReorgCtrl, isNumber: true, isDark: isDark),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 4. Meetings & Training
                  _buildSectionHeader(
                    context,
                    title: '৩. সভা ও প্রশিক্ষণ',
                    icon: Icons.event_note_rounded,
                    badge: 'কর্মসূচি',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildInputField('শাখা দায়িত্বশীল বৈঠক (টি)', _shakhaDaitoshilCountCtrl, isNumber: true, isDark: isDark)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInputField('উপস্থিতি (জন)', _shakhaDaitoshilPresCtrl, isNumber: true, isDark: isDark)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _buildInputField('জেলা নির্বাহী বৈঠক (টি)', _distExecCountCtrl, isNumber: true, isDark: isDark)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInputField('উপস্থিতি (জন)', _distExecPresCtrl, isNumber: true, isDark: isDark)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _buildInputField('জোনাল তরবিয়ত বৈঠক (টি)', _zonalTorbiotCountCtrl, isNumber: true, isDark: isDark)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInputField('উপস্থিতি (জন)', _zonalTorbiotPresCtrl, isNumber: true, isDark: isDark)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 5. Travel
                  _buildSectionHeader(
                    context,
                    title: '৪. সফর (জোন থেকে)',
                    icon: Icons.card_travel_rounded,
                    badge: 'সফর বিবরণ',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: _buildInputField(
                      'সফর বিবরণী (তারিখ, শাখা ও কর্মসূচি)',
                      _travelDetailsCtrl,
                      hintText: 'সফর বিবরণ ইনপুট দিন...',
                      maxLines: 3,
                      isDark: isDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 6. Income & Expenditure
                  _buildSectionHeader(
                    context,
                    title: '৫. আয়-ব্যয় (টাকা)',
                    icon: Icons.account_balance_wallet_rounded,
                    badge: 'অর্থনৈতিক',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildInputField('সফর আয় (টাকা)', _safarIncomeTakaCtrl, isNumber: true, isDark: isDark)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInputField('কেন্দ্র থেকে আয় (টাকা)', _centralIncomeTakaCtrl, isNumber: true, isDark: isDark)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _buildInputField('এককালীন আয় (টাকা)', _onetimeIncomeTakaCtrl, isNumber: true, isDark: isDark)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInputField('সফর ব্যয় (টাকা)', _safarExpenseTakaCtrl, isNumber: true, isDark: isDark)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _buildInputField('যোগাযোগ ব্যয় (টাকা)', _communicationExpenseTakaCtrl, isNumber: true, isDark: isDark)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInputField('অফিস ব্যয় (টাকা)', _officeExpenseTakaCtrl, isNumber: true, isDark: isDark)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildInputField('অন্যান্য ব্যয় (টাকা)', _otherExpenseTakaCtrl, isNumber: true, isDark: isDark),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 7. Sub-branch receipts
                  _buildSectionHeader(
                    context,
                    title: '৬. উপশাখার রিপোর্ট ও জমা প্রাপ্তি',
                    icon: Icons.folder_shared_rounded,
                    badge: 'রিপোর্ট প্রাপ্তি',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildInputField('শাখা রিপোর্ট জমা (টি)', _shakhaReportSubCtrl, isNumber: true, isDark: isDark)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInputField('শাখা পরিকল্পনা জমা (টি)', _shakhaPlanSubCtrl, isNumber: true, isDark: isDark)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildInputField('শাখা বায়তুলমাল জমা (টি)', _shakhaBaytulmalSubCtrl, isNumber: true, isDark: isDark),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 8. Remarks & Suggestions
                  _buildSectionHeader(
                    context,
                    title: '৭. মন্তব্য ও পরামর্শ',
                    icon: Icons.rate_review_rounded,
                    badge: 'মতামত',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Column(
                      children: [
                        _buildInputField('মন্তব্য', _remarksCtrl, hintText: 'মন্তব্য লিখুন...', maxLines: 2, isDark: isDark),
                        const SizedBox(height: 10),
                        _buildInputField('পরামর্শ', _suggestionsCtrl, hintText: 'পরামর্শ লিখুন...', maxLines: 2, isDark: isDark),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Save Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : () {
                          if (_isLocked) {
                            setState(() => _isLocked = false);
                          } else {
                            _saveReport();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B5E20),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: Icon(_isLocked ? Icons.edit_note_rounded : Icons.check_circle_rounded),
                        label: Text(
                          _isLocked ? 'তথ্য সম্পাদন করুন' : 'সংরক্ষণ করুন',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
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

  Widget _buildSubHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
    String? hintText,
    int maxLines = 1,
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
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
          readOnly: _isLocked,
          onChanged: (_) {
            if (!_isLocked && !_hasChanges) {
              setState(() => _hasChanges = true);
            } else {
              setState(() {});
            }
          },
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
