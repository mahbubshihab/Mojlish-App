import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/widgets/pdf_viewer_screen.dart';
import 'package:mojlish_app/core/widgets/unsaved_changes_dialog.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';
import 'package:mojlish_app/features/khelafat_majlis/branch_plan/data/services/khelafat_branch_plan_pdf_service.dart';

/// খেলাফত মজলিস — শাখা পরিকল্পনা ফরম (আধুনিক ডিজাইন ও মডুলার সার্ভিস)
class KhelafatBranchPlanScreen extends StatefulWidget {
  final int? year;
  final int? month;

  const KhelafatBranchPlanScreen({super.key, this.year, this.month});

  @override
  State<KhelafatBranchPlanScreen> createState() => _KhelafatBranchPlanScreenState();
}

class _KhelafatBranchPlanScreenState extends State<KhelafatBranchPlanScreen> {
  final _shakhaNameController = TextEditingController();

  // জনশক্তি লক্ষ্যমাত্রা
  final _sodossoTargetCtrl = TextEditingController();
  final _sodossoPrarthiTargetCtrl = TextEditingController();
  final _kormiTargetCtrl = TextEditingController();
  final _primaryMemberTargetCtrl = TextEditingController();
  final _totalManpowerTargetCtrl = TextEditingController();
  final _shudhiTargetCtrl = TextEditingController();

  // দাওয়াত ও গণসংযোগ
  final _personalDawahCtrl = TextEditingController();
  final _groupDawahCtrl = TextEditingController();
  final _dawahMahfilCtrl = TextEditingController();
  final _generalMeetingCtrl = TextEditingController();
  final _olamaMeetingCtrl = TextEditingController();
  final _siratMahfilCtrl = TextEditingController();
  final _rallyCtrl = TextEditingController();

  // বায়তুলমাল
  final _baytulmalTotalIncomeCtrl = TextEditingController();
  final _baytulmalTotalExpenseCtrl = TextEditingController();
  final _baytulmalQuotaCtrl = TextEditingController();

  // মন্তব্য
  final _commentsController = TextEditingController();

  bool _isSaving = false;
  bool _isLocked = false;
  bool _isLoading = true;

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedPlan();
  }

  @override
  void dispose() {
    for (var c in [
      _shakhaNameController, _sodossoTargetCtrl, _sodossoPrarthiTargetCtrl,
      _kormiTargetCtrl, _primaryMemberTargetCtrl, _totalManpowerTargetCtrl,
      _shudhiTargetCtrl, _personalDawahCtrl, _groupDawahCtrl, _dawahMahfilCtrl,
      _generalMeetingCtrl, _olamaMeetingCtrl, _siratMahfilCtrl, _rallyCtrl,
      _baytulmalTotalIncomeCtrl, _baytulmalTotalExpenseCtrl, _baytulmalQuotaCtrl,
      _commentsController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSavedPlan() async {
    if (widget.year != null && widget.month != null) {
      final saved = await ReportStorageService.getBranchPlan(widget.year!, widget.month!);
      if (saved != null && mounted) {
        setState(() {
          _shakhaNameController.text = saved['shakhaName'] ?? '';
          _sodossoTargetCtrl.text = saved['sodossoTarget'] ?? '';
          _sodossoPrarthiTargetCtrl.text = saved['sodossoPrarthiTarget'] ?? '';
          _kormiTargetCtrl.text = saved['kormiTarget'] ?? '';
          _primaryMemberTargetCtrl.text = saved['primaryMemberTarget'] ?? '';
          _totalManpowerTargetCtrl.text = saved['totalManpowerTarget'] ?? '';
          _shudhiTargetCtrl.text = saved['shudhiTarget'] ?? '';
          _personalDawahCtrl.text = saved['personalDawahCount'] ?? '';
          _groupDawahCtrl.text = saved['groupDawahCount'] ?? '';
          _dawahMahfilCtrl.text = saved['dawahMahfilCount'] ?? '';
          _generalMeetingCtrl.text = saved['generalMeetingCount'] ?? '';
          _olamaMeetingCtrl.text = saved['olamaMeetingCount'] ?? '';
          _siratMahfilCtrl.text = saved['siratMahfilCount'] ?? '';
          _rallyCtrl.text = saved['rallyCount'] ?? '';
          _baytulmalTotalIncomeCtrl.text = saved['baytulmalTotalIncome'] ?? '';
          _baytulmalTotalExpenseCtrl.text = saved['baytulmalTotalExpense'] ?? '';
          _baytulmalQuotaCtrl.text = saved['baytulmalQuota'] ?? '';
          _commentsController.text = saved['comments'] ?? '';
          _isLocked = true;
        });
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Map<String, dynamic> _collectData() {
    return {
      'shakhaName': _shakhaNameController.text.trim(),
      'sodossoTarget': _sodossoTargetCtrl.text.trim(),
      'sodossoPrarthiTarget': _sodossoPrarthiTargetCtrl.text.trim(),
      'kormiTarget': _kormiTargetCtrl.text.trim(),
      'primaryMemberTarget': _primaryMemberTargetCtrl.text.trim(),
      'totalManpowerTarget': _totalManpowerTargetCtrl.text.trim(),
      'shudhiTarget': _shudhiTargetCtrl.text.trim(),
      'personalDawahCount': _personalDawahCtrl.text.trim(),
      'groupDawahCount': _groupDawahCtrl.text.trim(),
      'dawahMahfilCount': _dawahMahfilCtrl.text.trim(),
      'generalMeetingCount': _generalMeetingCtrl.text.trim(),
      'olamaMeetingCount': _olamaMeetingCtrl.text.trim(),
      'siratMahfilCount': _siratMahfilCtrl.text.trim(),
      'rallyCount': _rallyCtrl.text.trim(),
      'baytulmalTotalIncome': _baytulmalTotalIncomeCtrl.text.trim(),
      'baytulmalTotalExpense': _baytulmalTotalExpenseCtrl.text.trim(),
      'baytulmalQuota': _baytulmalQuotaCtrl.text.trim(),
      'comments': _commentsController.text.trim(),
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  Future<void> _savePlan() async {
    setState(() => _isSaving = true);
    if (widget.year != null && widget.month != null) {
      await ReportStorageService.saveBranchPlan(widget.year!, widget.month!, _collectData());
    }

    setState(() {
      _isSaving = false;
      _isLocked = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('শাখা পরিকল্পনাটি সফলভাবে সংরক্ষিত হয়েছে!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  void _openPdfViewer() {
    final yearStr = widget.year != null ? _bn(widget.year!) : '';
    final monthStr = widget.month != null ? _monthNames[widget.month! - 1] : '';

    PdfViewerScreen.open(
      context,
      title: 'শাখা পরিকল্পনা — $monthStr $yearStr',
      buildPdf: (format) => KhelafatBranchPlanPdfService.generatePdfBytes(
        shakhaName: _shakhaNameController.text,
        month: monthStr,
        year: yearStr,
        data: _collectData(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final appBarBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textLight = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    const accentCyan = Color(0xFF06B6D4);
    const accentEmerald = Color(0xFF10B981);
    const accentBlue = Color(0xFF0284C7);

    final monthStr = widget.month != null ? _monthNames[widget.month! - 1] : '';
    final yearStr = widget.year != null ? _bn(widget.year!) : '';

    return UnsavedChangesGuard(
      hasUnsavedChanges: !_isLocked,
      onSave: () async {
        await _savePlan();
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
          'শাখা পরিকল্পনা — $monthStr $yearStr',
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
          ? const Center(child: CircularProgressIndicator(color: accentCyan))
          : AmbientBackgroundWidget(
              primaryAccent: accentCyan,
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
                                  _savePlan();
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

                  // 1. শাখা তথ্য
                  _buildSectionCard(
                    title: 'শাখার পরিকল্পনা ফরম',
                    icon: Icons.assignment_turned_in_rounded,
                    color: accentCyan,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _buildInputField(
                        controller: _shakhaNameController,
                        label: 'শাখার নাম',
                        hint: 'যেমন: মিরপুর শাখা...',
                        icon: Icons.business_rounded,
                        isDark: isDark,
                        accentColor: accentCyan,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 2. জনশক্তি বৃদ্ধি (Target)
                  _buildSectionCard(
                    title: '১. জনশক্তি বৃদ্ধি (লক্ষ্যমাত্রা)',
                    icon: Icons.groups_rounded,
                    color: accentCyan,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _buildInputField(controller: _sodossoTargetCtrl, label: 'সদস্য (মানে উন্নীতকরণ)', hint: '০', icon: Icons.person_add_rounded, suffix: 'জন', isDark: isDark, accentColor: accentCyan),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _sodossoPrarthiTargetCtrl, label: 'সদস্য প্রার্থী (মানে উন্নীতকরণ)', hint: '০', icon: Icons.person_outline_rounded, suffix: 'জন', isDark: isDark, accentColor: accentCyan),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _kormiTargetCtrl, label: 'কর্মী বৃদ্ধি', hint: '০', icon: Icons.engineering_rounded, suffix: 'জন', isDark: isDark, accentColor: accentCyan),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _primaryMemberTargetCtrl, label: 'প্রাথমিক সদস্য বৃদ্ধি', hint: '০', icon: Icons.how_to_reg_rounded, suffix: 'জন', isDark: isDark, accentColor: accentCyan),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _totalManpowerTargetCtrl, label: 'মোট জনশক্তি লক্ষ্যমাত্রা', hint: '০', icon: Icons.group_add_rounded, suffix: 'জন', isDark: isDark, accentColor: accentCyan),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _shudhiTargetCtrl, label: 'সুধী / শুভাকাঙ্ক্ষী বৃদ্ধি', hint: '০', icon: Icons.favorite_rounded, suffix: 'জন', isDark: isDark, accentColor: accentCyan),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 3. দাওয়াত ও গণসংযোগ
                  _buildSectionCard(
                    title: '২. দাওয়াত ও গণসংযোগ কর্মসূচি',
                    icon: Icons.campaign_rounded,
                    color: accentCyan,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _buildInputField(controller: _personalDawahCtrl, label: 'ব্যক্তিগত দাওয়াত দান (সংখ্যা)', hint: '০', icon: Icons.record_voice_over_rounded, suffix: 'টি', isDark: isDark, accentColor: accentCyan),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _groupDawahCtrl, label: 'গ্রুপ দাওয়াত (সংখ্যা)', hint: '০', icon: Icons.diversity_3_rounded, suffix: 'টি', isDark: isDark, accentColor: accentCyan),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _dawahMahfilCtrl, label: 'দাওয়াতি মাহফিল / সভা', hint: '০', icon: Icons.event_seat_rounded, suffix: 'টি', isDark: isDark, accentColor: accentCyan),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _generalMeetingCtrl, label: 'আলোচনা সভা / সাধারণ সভা', hint: '০', icon: Icons.forum_rounded, suffix: 'টি', isDark: isDark, accentColor: accentCyan),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _olamaMeetingCtrl, label: 'ওলামা / সুধী সমাবেশ', hint: '০', icon: Icons.psychology_rounded, suffix: 'টি', isDark: isDark, accentColor: accentCyan),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _siratMahfilCtrl, label: 'ওয়াজ / সিরাত মাহফিল', hint: '০', icon: Icons.mosque_rounded, suffix: 'টি', isDark: isDark, accentColor: accentCyan),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _rallyCtrl, label: 'মিছিল / মানবন্ধন / জনসভা', hint: '০', icon: Icons.flag_rounded, suffix: 'টি', isDark: isDark, accentColor: accentCyan),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 4. বায়তুলমাল (লক্ষ্যমাত্রা)
                  _buildSectionCard(
                    title: '৩. বায়তুলমাল (লক্ষ্যমাত্রা)',
                    icon: Icons.account_balance_wallet_rounded,
                    color: accentEmerald,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _buildInputField(controller: _baytulmalTotalIncomeCtrl, label: 'মোট আয় লক্ষ্যমাত্রা', hint: '০', icon: Icons.add_circle_outline_rounded, suffix: '৳', isDark: isDark, accentColor: accentEmerald),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _baytulmalTotalExpenseCtrl, label: 'মোট ব্যয় বাজেট', hint: '০', icon: Icons.remove_circle_outline_rounded, suffix: '৳', isDark: isDark, accentColor: const Color(0xFFEF4444)),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _baytulmalQuotaCtrl, label: 'উর্ধ্বতন কোটা (ধার্যকৃত)', hint: '০', icon: Icons.unfold_more_rounded, suffix: '৳', isDark: isDark, accentColor: accentEmerald),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 5. মন্তব্য ও অন্যান্য পরিকল্পনা
                  _buildSectionCard(
                    title: '৪. মন্তব্য ও বিশেষ নোট',
                    icon: Icons.note_alt_rounded,
                    color: accentCyan,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _buildInputField(controller: _commentsController, label: 'মন্তব্য ও পরিকল্পনা দ্রষ্টব্য', hint: 'বিবরণ লিখুন...', icon: Icons.comment_rounded, isDark: isDark, accentColor: accentCyan, maxLines: 3),
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
