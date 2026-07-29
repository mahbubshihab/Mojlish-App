import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';

/// খেলাফত মজলিস — শাখা পরিকল্পনা ফরম (২-ট্যাব: তথ্য পূরণ/লক ও ফরম্যাট প্রিভিউ/ডাউনলোড)
class KhelafatBranchPlanScreen extends StatefulWidget {
  final int? year;
  final int? month;

  const KhelafatBranchPlanScreen({super.key, this.year, this.month});

  @override
  State<KhelafatBranchPlanScreen> createState() => _KhelafatBranchPlanScreenState();
}

class _KhelafatBranchPlanScreenState extends State<KhelafatBranchPlanScreen> {
  final _shakhaNameController = TextEditingController();
  final _manpowerTargetController = TextEditingController();
  final _dawahScheduleController = TextEditingController();
  final _unitReorganizationController = TextEditingController();
  final _baytulmalTargetController = TextEditingController();
  final _safarScheduleController = TextEditingController();
  final _trainingPlanController = TextEditingController();
  final _publicationPlanController = TextEditingController();
  final _commentsController = TextEditingController();

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

  Future<void> _loadSavedPlan() async {
    if (widget.year != null && widget.month != null) {
      final saved = await ReportStorageService.getBranchPlan(widget.year!, widget.month!);
      if (saved != null) {
        _shakhaNameController.text = saved['shakhaName'] ?? '';
        _manpowerTargetController.text = saved['manpowerTarget'] ?? '';
        _dawahScheduleController.text = saved['dawahSchedule'] ?? '';
        _unitReorganizationController.text = saved['unitReorganization'] ?? '';
        _baytulmalTargetController.text = saved['baytulmalTarget'] ?? '';
        _safarScheduleController.text = saved['safarSchedule'] ?? '';
        _trainingPlanController.text = saved['trainingPlan'] ?? '';
        _publicationPlanController.text = saved['publicationPlan'] ?? '';
        _commentsController.text = saved['comments'] ?? '';
        _isLocked = true;
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _savePlan() async {
    if (widget.year != null && widget.month != null) {
      final data = {
        'shakhaName': _shakhaNameController.text,
        'manpowerTarget': _manpowerTargetController.text,
        'dawahSchedule': _dawahScheduleController.text,
        'unitReorganization': _unitReorganizationController.text,
        'baytulmalTarget': _baytulmalTargetController.text,
        'safarSchedule': _safarScheduleController.text,
        'trainingPlan': _trainingPlanController.text,
        'publicationPlan': _publicationPlanController.text,
        'comments': _commentsController.text,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };
      await ReportStorageService.saveBranchPlan(widget.year!, widget.month!, data);
    }

    setState(() => _isLocked = true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('পরিকল্পনাটি সফলভাবে সংরক্ষিত ও লক করা হয়েছে।'),
          backgroundColor: Color(0xFF059669),
        ),
      );
    }
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  Future<void> _exportPdf() async {
    final yearStr = widget.year != null ? _bn(widget.year!) : '';
    final monthStr = widget.month != null ? _monthNames[widget.month! - 1] : '';

    await PdfExportService.printOrDownloadPdf(
      title: 'শাখা পরিকল্পনা ফরম',
      majlisName: 'বাংলাদেশ খেলাফত মজলিস',
      userName: _shakhaNameController.text.isEmpty ? 'শাখা সভাপতি/সম্পাদক' : _shakhaNameController.text,
      period: '$monthStr $yearStr',
      dataFields: {
        'শাখার নাম': _shakhaNameController.text,
        'জনশক্তি বৃদ্ধির লক্ষ্যমাত্রা': _manpowerTargetController.text,
        'দাওয়াত ও গণসংযোগ পরিকল্পনা': _dawahScheduleController.text,
        'শাখা বিস্তার ও পুনর্গঠন': _unitReorganizationController.text,
        'বায়তুলমাল সংগ্রহের লক্ষ্যমাত্রা': _baytulmalTargetController.text,
        'সাংগঠনিক সফর সূচি': _safarScheduleController.text,
        'প্রশিক্ষণ বৈঠক পরিকল্পনা': _trainingPlanController.text,
        'প্রচার ও প্রকাশনা পরিকল্পনা': _publicationPlanController.text,
      },
      comments: _commentsController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final appBarBg = isDark ? const Color(0xFF162032) : Colors.white;
    final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
    final textLight = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    const accentCyan = Color(0xFF06B6D4);

    final monthStr = widget.month != null ? _monthNames[widget.month! - 1] : '';
    final yearStr = widget.year != null ? _bn(widget.year!) : '';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarBg,
          elevation: 1,
          title: Text(
            'শাখা পরিকল্পনা — $monthStr $yearStr',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          bottom: const TabBar(
            indicatorColor: accentCyan,
            indicatorWeight: 3,
            labelColor: accentCyan,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(icon: Icon(Icons.edit_note_rounded), text: '১. তথ্য পূরণ'),
              Tab(icon: Icon(Icons.print_rounded), text: '২. প্রিভিউ ও PDF'),
            ],
          ),
        ),
        body: AmbientBackgroundWidget(
          primaryAccent: accentCyan,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    _buildFormTab(cardBg, textLight, accentCyan),
                    _buildPreviewTab(cardBg, textLight, accentCyan),
                  ],
                ),
        ),
      ),
    );
  }

  // ==========================================
  // TAB 1: FORM ENTRY & EDIT LOCKING
  // ==========================================
  Widget _buildFormTab(Color cardBg, Color textLight, Color accentCyan) {
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
                        ? '🔒 পরিকল্পনাটি লকড অবস্থায় আছে। পরিবর্তন করতে এডিট করুন।'
                        : '📝 তথ্য পূরণ করুন এবং নিচে সংরক্ষণ বাটনে চাপ দিন।',
                    style: TextStyle(
                      color: textLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _buildCard('শাখার বিবরণ', [
            _buildTextField(_shakhaNameController, 'শাখার নাম'),
          ], cardBg, textLight),
          const SizedBox(height: 16),

          _buildCard('মাসিক পরিকল্পনা বিষয়াবলী', [
            _buildTextField(_manpowerTargetController, 'জনশক্তি বৃদ্ধির লক্ষ্যমাত্রা'),
            _buildTextField(_dawahScheduleController, 'দাওয়াত ও গণসংযোগ পরিকল্পনা'),
            _buildTextField(_unitReorganizationController, 'শাখা বিস্তার ও পুনর্গঠন'),
            _buildTextField(_baytulmalTargetController, 'বায়তুলমাল সংগ্রহের লক্ষ্যমাত্রা'),
            _buildTextField(_safarScheduleController, 'সাংগঠনিক সফর সূচি'),
            _buildTextField(_trainingPlanController, 'প্রশিক্ষণ বৈঠক পরিকল্পনা'),
            _buildTextField(_publicationPlanController, 'প্রচার ও প্রকাশনা পরিকল্পনা'),
          ], cardBg, textLight),
          const SizedBox(height: 16),

          _buildCard('বিশেষ মন্তব্য ও নোট', [
            _buildTextField(_commentsController, 'মন্তব্য ও দিকনির্দেশনা', maxLines: 3),
          ], cardBg, textLight),
          const SizedBox(height: 24),

          // Save / Edit Action Bar
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
                    onPressed: _savePlan,
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('সংরক্ষণ করুন (Save)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
  Widget _buildPreviewTab(Color cardBg, Color textLight, Color accentCyan) {
    final monthStr = widget.month != null ? _monthNames[widget.month! - 1] : '';
    final yearStr = widget.year != null ? _bn(widget.year!) : '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Top PDF Download Banner
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

          // Printable Plan Card Preview
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBg.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: accentCyan.withValues(alpha: 0.3)),
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
                        'শাখা পরিকল্পনা ফরম — $monthStr $yearStr',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textLight),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'শাখা: ${_shakhaNameController.text.isEmpty ? "(শাখার নাম প্রদান করুন)" : _shakhaNameController.text}',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: accentCyan),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 30, thickness: 1),

                _buildPreviewRow('জনশক্তি লক্ষ্যমাত্রা', _manpowerTargetController.text, textLight),
                _buildPreviewRow('দাওয়াত ও গণসংযোগ', _dawahScheduleController.text, textLight),
                _buildPreviewRow('শাখা বিস্তার ও পুনর্গঠন', _unitReorganizationController.text, textLight),
                _buildPreviewRow('বায়তুলমাল সংগ্রহের লক্ষ্য', _baytulmalTargetController.text, textLight),
                _buildPreviewRow('সাংগঠনিক সফর সূচি', _safarScheduleController.text, textLight),
                _buildPreviewRow('প্রশিক্ষণ বৈঠক পরিকল্পনা', _trainingPlanController.text, textLight),
                _buildPreviewRow('প্রচার ও প্রকাশনা পরিকল্পনা', _publicationPlanController.text, textLight),

                if (_commentsController.text.isNotEmpty) ...[
                  const Divider(height: 24),
                  Text('বিশেষ নির্দেশনা:', style: TextStyle(fontWeight: FontWeight.bold, color: textLight, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(_commentsController.text, style: TextStyle(color: textLight.withValues(alpha: 0.9), fontSize: 13.5)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPreviewRow(String title, String value, Color textColor) {
    final val = value.trim().isEmpty ? '—' : value.trim();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$title:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, color: textColor.withValues(alpha: 0.75)),
            ),
          ),
          Expanded(
            child: Text(
              val,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children, Color cardBg, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5, color: textColor)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        enabled: !_isLocked,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
          filled: _isLocked,
          fillColor: Colors.black.withValues(alpha: 0.04),
        ),
      ),
    );
  }
}
