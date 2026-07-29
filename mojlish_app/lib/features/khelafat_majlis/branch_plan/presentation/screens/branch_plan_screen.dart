import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/widgets/pdf_viewer_screen.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';

/// খেলাফত মজলিস — শাখা পরিকল্পনা ফরম (উপরে এডিট/সেভ ও ডাউনলোড বাটন + পৃথক টাইটেল ও ইনপুট ফিল্ড)
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

  void _openPdfViewer() {
    final yearStr = widget.year != null ? _bn(widget.year!) : '';
    final monthStr = widget.month != null ? _monthNames[widget.month! - 1] : '';

    PdfViewerScreen.open(
      context,
      title: 'শাখা পরিকল্পনা — $monthStr $yearStr',
      buildPdf: (format) => PdfExportService.generateSingleFormPdfBytes(
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
      ),
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 1,
        title: Text(
          'শাখা পরিকল্পনা — $monthStr $yearStr',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF0284C7)),
            tooltip: 'PDF প্রিভিউ ও ডাউনলোড',
            onPressed: _openPdfViewer,
          ),
        ],
      ),
      body: AmbientBackgroundWidget(
        primaryAccent: accentCyan,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Action Bar with Save/Edit at the TOP!
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: _isLocked
                                ? ElevatedButton.icon(
                                    onPressed: () => setState(() => _isLocked = false),
                                    icon: const Icon(Icons.edit_rounded, size: 18),
                                    label: const Text('সম্পাদনা (Edit)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD97706),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  )
                                : ElevatedButton.icon(
                                    onPressed: _savePlan,
                                    icon: const Icon(Icons.save_rounded, size: 18),
                                    label: const Text('সংরক্ষণ (Save)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF059669),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: ElevatedButton.icon(
                              onPressed: _openPdfViewer,
                              icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                              label: const Text('PDF ডাউনলোড', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0284C7),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Lock Status Banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: _isLocked
                            ? const Color(0xFF0284C7).withValues(alpha: 0.12)
                            : const Color(0xFF059669).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _isLocked ? const Color(0xFF0284C7) : const Color(0xFF059669),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isLocked ? Icons.lock_rounded : Icons.edit_note_rounded,
                            color: _isLocked ? const Color(0xFF0284C7) : const Color(0xFF059669),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _isLocked
                                  ? '🔒 পরিকল্পনাটি লকড অবস্থায় আছে। পরিবর্তন করতে ওপরে এডিটে চাপুন।'
                                  : '📝 তথ্য পূরণ করুন এবং ওপরে সংরক্ষণ বাটনে চাপ দিন।',
                              style: TextStyle(
                                color: textLight,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildCard('শাখার বিবরণ', [
                      _buildTextField(_shakhaNameController, 'শাখার নাম', textLight: textLight),
                    ], cardBg, textLight),
                    const SizedBox(height: 16),

                    _buildCard('মাসিক পরিকল্পনা বিষয়াবলী', [
                      _buildTextField(_manpowerTargetController, 'জনশক্তি বৃদ্ধির লক্ষ্যমাত্রা', textLight: textLight),
                      _buildTextField(_dawahScheduleController, 'দাওয়াত ও গণসংযোগ পরিকল্পনা', textLight: textLight),
                      _buildTextField(_unitReorganizationController, 'শাখা বিস্তার ও পুনর্গঠন', textLight: textLight),
                      _buildTextField(_baytulmalTargetController, 'বায়তুলমাল সংগ্রহের লক্ষ্যমাত্রা', textLight: textLight),
                      _buildTextField(_safarScheduleController, 'সাংগঠনিক সফর সূচি', textLight: textLight),
                      _buildTextField(_trainingPlanController, 'প্রশিক্ষণ বৈঠক পরিকল্পনা', textLight: textLight),
                      _buildTextField(_publicationPlanController, 'প্রচার ও প্রকাশনা পরিকল্পনা', textLight: textLight),
                    ], cardBg, textLight),
                    const SizedBox(height: 16),

                    _buildCard('বিশেষ মন্তব্য ও নোট', [
                      _buildTextField(_commentsController, 'মন্তব্য ও দিকনির্দেশনা', maxLines: 3, textLight: textLight),
                    ], cardBg, textLight),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
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
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, required Color textLight}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: textLight,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            enabled: !_isLocked,
            maxLines: maxLines,
            style: TextStyle(fontSize: 14, color: textLight),
            decoration: InputDecoration(
              hintText: '$label ইনপুট দিন...',
              hintStyle: TextStyle(color: textLight.withValues(alpha: 0.4), fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              filled: true,
              fillColor: _isLocked
                  ? Colors.black.withValues(alpha: 0.05)
                  : Colors.white.withValues(alpha: 0.06),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF059669), width: 1.8),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
