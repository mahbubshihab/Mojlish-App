import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/widgets/pdf_viewer_screen.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';
import 'package:mojlish_app/features/khelafat_majlis/branch_report/data/services/khelafat_branch_report_pdf_service.dart';

/// খেলাফত মজলিস — শাখা সাংগঠনিক রিপোর্ট ফরম (আধুনিক ডিজাইন ও মডুলার সার্ভিস)
class BranchReportScreen extends StatefulWidget {
  final int? year;
  final int? month;

  const BranchReportScreen({super.key, this.year, this.month});

  @override
  State<BranchReportScreen> createState() => _BranchReportScreenState();
}

class _BranchReportScreenState extends State<BranchReportScreen> {
  final _shakhaNameController = TextEditingController();
  final _sodossoCountCtrl = TextEditingController();
  final _sodossoBridhiCtrl = TextEditingController();
  final _sodossoGhattiCtrl = TextEditingController();
  final _sodossoPrarthiCountCtrl = TextEditingController();
  final _sodossoPrarthiBridhiCtrl = TextEditingController();
  final _sodossoPrarthiGhattiCtrl = TextEditingController();
  final _kormiCountCtrl = TextEditingController();
  final _kormiBridhiCtrl = TextEditingController();
  final _kormiGhattiCtrl = TextEditingController();
  final _primaryMemberCountCtrl = TextEditingController();
  final _shudhiCountCtrl = TextEditingController();

  final _personalDawahCtrl = TextEditingController();
  final _groupDawahCtrl = TextEditingController();
  final _dawahMahfilCtrl = TextEditingController();
  final _generalMeetingCtrl = TextEditingController();
  final _olamaMeetingCtrl = TextEditingController();
  final _siratMahfilCtrl = TextEditingController();
  final _rallyCtrl = TextEditingController();

  final _baytulmalIncomeCtrl = TextEditingController();
  final _baytulmalExpenseCtrl = TextEditingController();
  final _baytulmalQuotaCtrl = TextEditingController();
  final _baytulmalPaidCtrl = TextEditingController();

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
    _loadSavedReport();
  }

  @override
  void dispose() {
    for (var c in [
      _shakhaNameController, _sodossoCountCtrl, _sodossoBridhiCtrl, _sodossoGhattiCtrl,
      _sodossoPrarthiCountCtrl, _sodossoPrarthiBridhiCtrl, _sodossoPrarthiGhattiCtrl,
      _kormiCountCtrl, _kormiBridhiCtrl, _kormiGhattiCtrl, _primaryMemberCountCtrl,
      _shudhiCountCtrl, _personalDawahCtrl, _groupDawahCtrl, _dawahMahfilCtrl,
      _generalMeetingCtrl, _olamaMeetingCtrl, _siratMahfilCtrl, _rallyCtrl,
      _baytulmalIncomeCtrl, _baytulmalExpenseCtrl, _baytulmalQuotaCtrl,
      _baytulmalPaidCtrl, _commentsController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSavedReport() async {
    if (widget.year != null && widget.month != null) {
      final saved = await ReportStorageService.getBranchReport(widget.year!, widget.month!);
      if (saved != null && mounted) {
        setState(() {
          _shakhaNameController.text = saved['shakhaName'] ?? '';
          _sodossoCountCtrl.text = saved['sodossoCount'] ?? '';
          _sodossoBridhiCtrl.text = saved['sodossoBridhi'] ?? '';
          _sodossoGhattiCtrl.text = saved['sodossoGhatti'] ?? '';
          _sodossoPrarthiCountCtrl.text = saved['sodossoPrarthiCount'] ?? '';
          _sodossoPrarthiBridhiCtrl.text = saved['sodossoPrarthiBridhi'] ?? '';
          _sodossoPrarthiGhattiCtrl.text = saved['sodossoPrarthiGhatti'] ?? '';
          _kormiCountCtrl.text = saved['kormiCount'] ?? '';
          _kormiBridhiCtrl.text = saved['kormiBridhi'] ?? '';
          _kormiGhattiCtrl.text = saved['kormiGhatti'] ?? '';
          _primaryMemberCountCtrl.text = saved['primaryMemberCount'] ?? '';
          _shudhiCountCtrl.text = saved['shudhiCount'] ?? '';
          _personalDawahCtrl.text = saved['personalDawahCount'] ?? '';
          _groupDawahCtrl.text = saved['groupDawahCount'] ?? '';
          _dawahMahfilCtrl.text = saved['dawahMahfilCount'] ?? '';
          _generalMeetingCtrl.text = saved['generalMeetingCount'] ?? '';
          _olamaMeetingCtrl.text = saved['olamaMeetingCount'] ?? '';
          _siratMahfilCtrl.text = saved['siratMahfilCount'] ?? '';
          _rallyCtrl.text = saved['rallyCount'] ?? '';
          _baytulmalIncomeCtrl.text = saved['baytulmalIncome'] ?? '';
          _baytulmalExpenseCtrl.text = saved['baytulmalExpense'] ?? '';
          _baytulmalQuotaCtrl.text = saved['baytulmalQuota'] ?? '';
          _baytulmalPaidCtrl.text = saved['baytulmalPaid'] ?? '';
          _commentsController.text = saved['remarks'] ?? '';
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
      'sodossoCount': _sodossoCountCtrl.text.trim(),
      'sodossoBridhi': _sodossoBridhiCtrl.text.trim(),
      'sodossoGhatti': _sodossoGhattiCtrl.text.trim(),
      'sodossoPrarthiCount': _sodossoPrarthiCountCtrl.text.trim(),
      'sodossoPrarthiBridhi': _sodossoPrarthiBridhiCtrl.text.trim(),
      'sodossoPrarthiGhatti': _sodossoPrarthiGhattiCtrl.text.trim(),
      'kormiCount': _kormiCountCtrl.text.trim(),
      'kormiBridhi': _kormiBridhiCtrl.text.trim(),
      'kormiGhatti': _kormiGhattiCtrl.text.trim(),
      'primaryMemberCount': _primaryMemberCountCtrl.text.trim(),
      'shudhiCount': _shudhiCountCtrl.text.trim(),
      'personalDawahCount': _personalDawahCtrl.text.trim(),
      'groupDawahCount': _groupDawahCtrl.text.trim(),
      'dawahMahfilCount': _dawahMahfilCtrl.text.trim(),
      'generalMeetingCount': _generalMeetingCtrl.text.trim(),
      'olamaMeetingCount': _olamaMeetingCtrl.text.trim(),
      'siratMahfilCount': _siratMahfilCtrl.text.trim(),
      'rallyCount': _rallyCtrl.text.trim(),
      'baytulmalIncome': _baytulmalIncomeCtrl.text.trim(),
      'baytulmalExpense': _baytulmalExpenseCtrl.text.trim(),
      'baytulmalQuota': _baytulmalQuotaCtrl.text.trim(),
      'baytulmalPaid': _baytulmalPaidCtrl.text.trim(),
      'remarks': _commentsController.text.trim(),
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  Future<void> _saveReport() async {
    setState(() => _isSaving = true);
    if (widget.year != null && widget.month != null) {
      await ReportStorageService.saveBranchReport(widget.year!, widget.month!, _collectData());
    }

    setState(() {
      _isSaving = false;
      _isLocked = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('শাখা রিপোর্টটি সফলভাবে সংরক্ষিত হয়েছে!'),
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
      title: 'শাখা সাংগঠনিক রিপোর্ট — $monthStr $yearStr',
      buildPdf: (format) => KhelafatBranchReportPdfService.generatePdfBytes(
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
    const accentIndigo = Color(0xFF6366F1);
    const accentEmerald = Color(0xFF10B981);
    const accentBlue = Color(0xFF0284C7);

    final monthStr = widget.month != null ? _monthNames[widget.month! - 1] : '';
    final yearStr = widget.year != null ? _bn(widget.year!) : '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textLight, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'শাখা রিপোর্ট — $monthStr $yearStr',
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
          ? const Center(child: CircularProgressIndicator(color: accentIndigo))
          : AmbientBackgroundWidget(
              primaryAccent: accentIndigo,
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

                  // 1. শাখা তথ্য
                  _buildSectionCard(
                    title: 'শাখার রিপোর্ট ফরম',
                    icon: Icons.account_balance_rounded,
                    color: accentIndigo,
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
                        accentColor: accentIndigo,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 2. জনশক্তি
                  _buildSectionCard(
                    title: '১. জনশক্তি',
                    icon: Icons.groups_rounded,
                    color: accentIndigo,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _build3ColRow('সদস্য (সংখ্যা / বৃদ্ধি / ঘাটতি)', _sodossoCountCtrl, _sodossoBridhiCtrl, _sodossoGhattiCtrl, isDark),
                      const SizedBox(height: 12),
                      _build3ColRow('সদস্য প্রার্থী (সংখ্যা / বৃদ্ধি / ঘাটতি)', _sodossoPrarthiCountCtrl, _sodossoPrarthiBridhiCtrl, _sodossoPrarthiGhattiCtrl, isDark),
                      const SizedBox(height: 12),
                      _build3ColRow('কর্মী (সংখ্যা / বৃদ্ধি / ঘাটতি)', _kormiCountCtrl, _kormiBridhiCtrl, _kormiGhattiCtrl, isDark),
                      const SizedBox(height: 12),
                      _buildInputField(controller: _primaryMemberCountCtrl, label: 'প্রাথমিক সদস্য সংখ্যা', hint: '০', icon: Icons.person_add_rounded, suffix: 'জন', isDark: isDark, accentColor: accentIndigo),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _shudhiCountCtrl, label: 'সুধী / শুভাকাঙ্ক্ষী সংখ্যা', hint: '০', icon: Icons.favorite_rounded, suffix: 'জন', isDark: isDark, accentColor: accentIndigo),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 3. দাওয়াত ও গণসংযোগ
                  _buildSectionCard(
                    title: '২. দাওয়াত ও গণসংযোগ',
                    icon: Icons.campaign_rounded,
                    color: accentIndigo,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _buildInputField(controller: _personalDawahCtrl, label: 'ব্যক্তিগত দাওয়াত দান (সংখ্যা)', hint: '০', icon: Icons.record_voice_over_rounded, suffix: 'টি', isDark: isDark, accentColor: accentIndigo),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _groupDawahCtrl, label: 'গ্রুপ দাওয়াত (সংখ্যা)', hint: '০', icon: Icons.diversity_3_rounded, suffix: 'টি', isDark: isDark, accentColor: accentIndigo),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _dawahMahfilCtrl, label: 'দাওয়াতি মাহফিল / সভা', hint: '০', icon: Icons.event_seat_rounded, suffix: 'টি', isDark: isDark, accentColor: accentIndigo),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _generalMeetingCtrl, label: 'আলোচনা সভা / সাধারণ সভা', hint: '০', icon: Icons.forum_rounded, suffix: 'টি', isDark: isDark, accentColor: accentIndigo),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _olamaMeetingCtrl, label: 'ওলামা / সুধী সমাবেশ', hint: '০', icon: Icons.psychology_rounded, suffix: 'টি', isDark: isDark, accentColor: accentIndigo),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _siratMahfilCtrl, label: 'ওয়াজ / সিরাত মাহফিল', hint: '০', icon: Icons.mosque_rounded, suffix: 'টি', isDark: isDark, accentColor: accentIndigo),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _rallyCtrl, label: 'মিছিল / মানবন্ধন / জনসভা', hint: '০', icon: Icons.flag_rounded, suffix: 'টি', isDark: isDark, accentColor: accentIndigo),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 4. বায়তুলমাল
                  _buildSectionCard(
                    title: '৩. বায়তুলমাল হিসাব',
                    icon: Icons.account_balance_wallet_rounded,
                    color: accentEmerald,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _buildInputField(controller: _baytulmalIncomeCtrl, label: 'মোট আয়', hint: '০', icon: Icons.add_circle_outline_rounded, suffix: '৳', isDark: isDark, accentColor: accentEmerald),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _baytulmalExpenseCtrl, label: 'মোট ব্যয়', hint: '০', icon: Icons.remove_circle_outline_rounded, suffix: '৳', isDark: isDark, accentColor: const Color(0xFFEF4444)),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _baytulmalQuotaCtrl, label: 'উর্ধ্বতন কোটা', hint: '০', icon: Icons.unfold_more_rounded, suffix: '৳', isDark: isDark, accentColor: accentEmerald),
                      const SizedBox(height: 10),
                      _buildInputField(controller: _baytulmalPaidCtrl, label: 'উর্ধ্বতন পরিশোধ', hint: '০', icon: Icons.check_circle_outline_rounded, suffix: '৳', isDark: isDark, accentColor: accentEmerald),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 5. মন্তব্য
                  _buildSectionCard(
                    title: '৪. মন্তব্য (সমস্যা ও সম্ভাবনা উল্লেখসহ)',
                    icon: Icons.note_alt_rounded,
                    color: accentIndigo,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textLight: textLight,
                    children: [
                      _buildInputField(controller: _commentsController, label: 'মন্তব্য বিবরণী', hint: 'বিবরণ লিখুন...', icon: Icons.comment_rounded, isDark: isDark, accentColor: accentIndigo, maxLines: 3),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
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

  Widget _build3ColRow(String label, TextEditingController c1, TextEditingController c2, TextEditingController c3, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155), fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildInputField(controller: c1, label: '', hint: 'সংখ্যা', icon: Icons.numbers, isDark: isDark, accentColor: const Color(0xFF6366F1))),
            const SizedBox(width: 6),
            Expanded(child: _buildInputField(controller: c2, label: '', hint: 'বৃদ্ধি', icon: Icons.trending_up, isDark: isDark, accentColor: const Color(0xFF10B981))),
            const SizedBox(width: 6),
            Expanded(child: _buildInputField(controller: c3, label: '', hint: 'ঘাটতি', icon: Icons.trending_down, isDark: isDark, accentColor: const Color(0xFFEF4444))),
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
