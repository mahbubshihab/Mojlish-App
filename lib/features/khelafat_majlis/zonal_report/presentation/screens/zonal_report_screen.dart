import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/widgets/pdf_viewer_screen.dart';
import 'package:mojlish_app/core/widgets/unsaved_changes_dialog.dart';
import 'package:mojlish_app/features/common/reports/data/models/zonal_report_entry.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';
import 'package:mojlish_app/features/khelafat_majlis/zonal_report/data/services/khelafat_zonal_pdf_service.dart';

/// খেলাফত মজলিস — জোনাল রিপোর্ট ফরম (আধুনিক ডিজাইন ও মডুলার ফিচার সার্ভিস)
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
  bool _isLoading = true;

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
      }
    } catch (_) {}
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  String _bn(num n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) {
      final val = int.tryParse(c);
      return val != null ? digits[val] : c;
    }).join();
  }

  ZonalReportEntry _buildCurrentEntry() {
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

  Future<void> _saveReport() async {
    setState(() => _isSaving = true);
    final entry = _buildCurrentEntry();
    await ReportStorageService.saveZonalEntry(entry);
    if (mounted) {
      setState(() {
        _isSaving = false;
        _isLocked = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('জোনাল তথ্য সফলভাবে সংরক্ষিত হয়েছে!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  void _openPdfViewer() {
    final yearStr = _bn(widget.year);
    final monthStr = _monthNames[widget.month - 1];
    final entry = _buildCurrentEntry();

    PdfViewerScreen.open(
      context,
      title: 'জোনাল রিপোর্ট — $monthStr $yearStr',
      buildPdf: (format) => KhelafatZonalPdfService.generatePdfBytes(entry: entry),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final appBarBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textLight = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    const accentPurple = Color(0xFF8B5CF6);
    const accentEmerald = Color(0xFF10B981);
    const accentBlue = Color(0xFF0284C7);

    final monthStr = _monthNames[widget.month - 1];
    final yearStr = _bn(widget.year);

    return UnsavedChangesGuard(
      hasUnsavedChanges: !_isLocked,
      onSave: () async {
        await _saveReport();
        return true;
      },
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textLight, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'জোনাল রিপোর্ট — $monthStr $yearStr',
          style: TextStyle(color: textLight, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentBlue.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.picture_as_pdf_rounded, color: accentBlue, size: 20),
            ),
            onPressed: _openPdfViewer,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: accentPurple))
          : AmbientBackgroundWidget(
              primaryAccent: accentPurple,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Top Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF059669), Color(0xFF10B981)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: accentEmerald.withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: _isSaving ? null : () {
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
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                        )
                                      : Icon(_isLocked ? Icons.edit_note_rounded : Icons.save_rounded, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isLocked ? 'সম্পাদনা করুন' : 'সংরক্ষণ করুন',
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
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: accentBlue.withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
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
                  const SizedBox(height: 16),

                  // জোনের নাম
                  _buildSectionCard(
                    title: 'জোনাল রিপোর্ট ফরম',
                    icon: Icons.map_rounded,
                    color: accentPurple,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _buildInputField(
                        controller: _zoneNameCtrl,
                        label: 'জোনের নাম',
                        hint: 'যেমন: ঢাকা পূর্ব জোন...',
                        icon: Icons.location_city_rounded,
                        isDark: isDark,
                        accentColor: accentPurple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // জনশক্তি (Manpower)
                  _buildSectionCard(
                    title: '১. জনশক্তি',
                    icon: Icons.groups_rounded,
                    color: accentPurple,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _build3ColRow('সদস্য (সংখ্যা / বৃদ্ধি / ঘাটতি)', _sodossoCountCtrl, _sodossoBridhiCtrl, _sodossoGhattiCtrl, isDark),
                      const SizedBox(height: 12),
                      _build3ColRow('সদস্য প্রার্থী (সংখ্যা / বৃদ্ধি / ঘাটতি)', _sodossoPrarthiCountCtrl, _sodossoPrarthiBridhiCtrl, _sodossoPrarthiGhattiCtrl, isDark),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // সংগঠন (Organization)
                  _buildSectionCard(
                    title: '২. সংগঠন',
                    icon: Icons.account_tree_rounded,
                    color: accentPurple,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _build3ColRow('জেলা (সংখ্যা / গঠন / পুনর্গঠন)', _distCountCtrl, _distOrgCtrl, _distReorgCtrl, isDark),
                      const SizedBox(height: 12),
                      _build3ColRow('মহানগরী (সংখ্যা / গঠন / পুনর্গঠন)', _cityCountCtrl, _cityOrgCtrl, _cityReorgCtrl, isDark),
                      const SizedBox(height: 12),
                      _build3ColRow('উপজেলা/থানা (সংখ্যা / গঠন / পুনর্গঠন)', _upazilaCountCtrl, _upazilaOrgCtrl, _upazilaReorgCtrl, isDark),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // সভা/প্রশিক্ষণ (Meeting/Training)
                  _buildSectionCard(
                    title: '৩. সভা/প্রশিক্ষণ',
                    icon: Icons.event_note_rounded,
                    color: accentPurple,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _build2ColRow('শাখা দায়িত্বশীল বৈঠক (সংখ্যা ও উপস্থিতি)', _shakhaDaitoshilCountCtrl, _shakhaDaitoshilPresCtrl, isDark),
                      const SizedBox(height: 12),
                      _build2ColRow('জেলা নির্বাহী বৈঠক (সংখ্যা ও উপস্থিতি)', _distExecCountCtrl, _distExecPresCtrl, isDark),
                      const SizedBox(height: 12),
                      _build2ColRow('জোনাল তরবিয়ত বৈঠক (সংখ্যা ও উপস্থিতি)', _zonalTorbiotCountCtrl, _zonalTorbiotPresCtrl, isDark),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // সফর (জোন থেকে)
                  _buildSectionCard(
                    title: '৪. সফর (জোন থেকে)',
                    icon: Icons.card_travel_rounded,
                    color: accentPurple,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _buildInputField(
                        controller: _travelDetailsCtrl,
                        label: 'সফর বিবরণী (তারিখ, শাখা ও কর্মসূচি)',
                        hint: 'সফর বিবরণ ইনপুট দিন...',
                        icon: Icons.edit_location_alt_rounded,
                        isDark: isDark,
                        accentColor: accentPurple,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // আয়-ব্যয় (Income-Expense)
                  _buildSectionCard(
                    title: '৫. আয়-ব্যয় (টাকা)',
                    icon: Icons.account_balance_wallet_rounded,
                    color: accentEmerald,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _buildInputField(controller: _safarIncomeTakaCtrl, label: 'সফর আয় (শাখা থেকে)', hint: '০', icon: Icons.attach_money_rounded, suffix: '৳', isDark: isDark, accentColor: accentEmerald),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _centralIncomeTakaCtrl, label: 'কেন্দ্র থেকে আয়', hint: '০', icon: Icons.savings_rounded, suffix: '৳', isDark: isDark, accentColor: accentEmerald),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _onetimeIncomeTakaCtrl, label: 'এককালীন আয়', hint: '০', icon: Icons.account_balance_rounded, suffix: '৳', isDark: isDark, accentColor: accentEmerald),
                      const Divider(height: 20),
                      _buildInputField(controller: _safarExpenseTakaCtrl, label: 'সফর ব্যয়', hint: '০', icon: Icons.flight_takeoff_rounded, suffix: '৳', isDark: isDark, accentColor: const Color(0xFFEF4444)),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _communicationExpenseTakaCtrl, label: 'যোগাযোগ ব্যয়', hint: '০', icon: Icons.phone_android_rounded, suffix: '৳', isDark: isDark, accentColor: const Color(0xFFEF4444)),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _officeExpenseTakaCtrl, label: 'অফিস ব্যয়', hint: '০', icon: Icons.desk_rounded, suffix: '৳', isDark: isDark, accentColor: const Color(0xFFEF4444)),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _otherExpenseTakaCtrl, label: 'অন্যান্য ব্যয়', hint: '০', icon: Icons.receipt_long_rounded, suffix: '৳', isDark: isDark, accentColor: const Color(0xFFEF4444)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // উপশাখার রিপোর্ট প্রাপ্তি
                  _buildSectionCard(
                    title: '৬. উপশাখার রিপোর্ট ও জমা প্রাপ্তি',
                    icon: Icons.folder_shared_rounded,
                    color: accentPurple,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _buildInputField(controller: _shakhaReportSubCtrl, label: 'শাখা রিপোর্ট জমা হয়েছে (টি)', hint: '০', icon: Icons.file_present_rounded, suffix: 'টি', isDark: isDark, accentColor: accentPurple),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _shakhaPlanSubCtrl, label: 'শাখা পরিকল্পনা জমা হয়েছে (টি)', hint: '০', icon: Icons.assignment_turned_in_rounded, suffix: 'টি', isDark: isDark, accentColor: accentPurple),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _shakhaBaytulmalSubCtrl, label: 'শাখা বায়তুলমাল জমা হয়েছে (টি)', hint: '০', icon: Icons.monetization_on_rounded, suffix: 'টি', isDark: isDark, accentColor: accentPurple),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // মন্তব্য ও পরামর্শ
                  _buildSectionCard(
                    title: '৭. মন্তব্য ও পরামর্শ',
                    icon: Icons.rate_review_rounded,
                    color: accentPurple,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _buildInputField(controller: _remarksCtrl, label: 'মন্তব্য', hint: 'মন্তব্য লিখুন...', icon: Icons.comment_rounded, isDark: isDark, accentColor: accentPurple, maxLines: 2),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _suggestionsCtrl, label: 'পরামর্শ', hint: 'পরামর্শ লিখুন...', icon: Icons.lightbulb_outline_rounded, isDark: isDark, accentColor: accentPurple, maxLines: 2),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
        ),
      );
    }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Color cardBg,
    required Color borderColor,
    required Color textLight,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(9)),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(color: textLight, fontWeight: FontWeight.bold, fontSize: 14.5)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _build2ColRow(String label, TextEditingController c1, TextEditingController c2, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155), fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInputField(controller: c1, label: '', hint: 'সংখ্যা', icon: Icons.tag, suffix: 'টি', isDark: isDark, accentColor: const Color(0xFF8B5CF6))),
            const SizedBox(width: 8),
            Expanded(child: _buildInputField(controller: c2, label: '', hint: 'উপস্থিতি', icon: Icons.people_alt, suffix: 'জন', isDark: isDark, accentColor: const Color(0xFF8B5CF6))),
          ],
        ),
      ],
    );
  }

  Widget _build3ColRow(String label, TextEditingController c1, TextEditingController c2, TextEditingController c3, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155), fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInputField(controller: c1, label: '', hint: 'সংখ্যা', icon: Icons.numbers, isDark: isDark, accentColor: const Color(0xFF8B5CF6))),
            const SizedBox(width: 6),
            Expanded(child: _buildInputField(controller: c2, label: '', hint: 'বৃদ্ধি/গঠন', icon: Icons.trending_up, isDark: isDark, accentColor: const Color(0xFF10B981))),
            const SizedBox(width: 6),
            Expanded(child: _buildInputField(controller: c3, label: '', hint: 'ঘাটতি/পুনর্গঠন', icon: Icons.trending_down, isDark: isDark, accentColor: const Color(0xFFEF4444))),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? suffix,
    required bool isDark,
    required Color accentColor,
    int maxLines = 1,
  }) {
    final fieldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final fieldBorder = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    final textColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: TextStyle(color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155), fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 5),
        ],
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          readOnly: _isLocked,
          onChanged: (_) => setState(() {}),
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 13.5),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 12.5),
            prefixIcon: Icon(icon, color: accentColor, size: 17),
            suffixIcon: suffix != null
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(suffix, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 12.5)),
                  )
                : null,
            filled: true,
            fillColor: fieldBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: fieldBorder)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: accentColor, width: 1.8)),
          ),
        ),
      ],
    );
  }
}
