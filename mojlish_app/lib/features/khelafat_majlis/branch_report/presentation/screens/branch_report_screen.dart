import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/widgets/pdf_viewer_screen.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';

/// খেলাফত মজলিস — শাখা সাংগঠনিক রিপোর্ট ফরম (উপরে এডিট/সেভ ও ডাউনলোড বাটন + পৃথক টাইটেল ও ইনপুট ফিল্ড)
class BranchReportScreen extends StatefulWidget {
  final int? year;
  final int? month;

  const BranchReportScreen({super.key, this.year, this.month});

  @override
  State<BranchReportScreen> createState() => _BranchReportScreenState();
}

class _BranchReportScreenState extends State<BranchReportScreen> {
  final _shakhaNameController = TextEditingController();
  final _manpowerController = TextEditingController();
  final _dawahController = TextEditingController();
  final _organizationController = TextEditingController();
  final _meetingsController = TextEditingController();
  final _baytulmalController = TextEditingController();
  final _tourController = TextEditingController();
  final _trainingController = TextEditingController();
  final _officeController = TextEditingController();
  final _publicityController = TextEditingController();
  final _libraryController = TextEditingController();
  final _welfareController = TextEditingController();
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
    _loadSavedReport();
  }

  Future<void> _loadSavedReport() async {
    if (widget.year != null && widget.month != null) {
      final saved = await ReportStorageService.getBranchReport(widget.year!, widget.month!);
      if (saved != null) {
        _shakhaNameController.text = saved['shakhaName'] ?? '';
        _manpowerController.text = saved['manpower'] ?? '';
        _dawahController.text = saved['dawah'] ?? '';
        _organizationController.text = saved['organization'] ?? '';
        _meetingsController.text = saved['meetings'] ?? '';
        _baytulmalController.text = saved['baytulmal'] ?? '';
        _tourController.text = saved['tour'] ?? '';
        _trainingController.text = saved['training'] ?? '';
        _officeController.text = saved['office'] ?? '';
        _publicityController.text = saved['publicity'] ?? '';
        _libraryController.text = saved['library'] ?? '';
        _welfareController.text = saved['welfare'] ?? '';
        _commentsController.text = saved['comments'] ?? '';
        _isLocked = true;
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveReport() async {
    if (widget.year != null && widget.month != null) {
      final data = {
        'shakhaName': _shakhaNameController.text,
        'manpower': _manpowerController.text,
        'dawah': _dawahController.text,
        'organization': _organizationController.text,
        'meetings': _meetingsController.text,
        'baytulmal': _baytulmalController.text,
        'tour': _tourController.text,
        'training': _trainingController.text,
        'office': _officeController.text,
        'publicity': _publicityController.text,
        'library': _libraryController.text,
        'welfare': _welfareController.text,
        'comments': _commentsController.text,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };
      await ReportStorageService.saveBranchReport(widget.year!, widget.month!, data);
    }

    setState(() => _isLocked = true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('রিপোর্টটি সফলভাবে সংরক্ষিত ও লক করা হয়েছে।'),
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
      title: 'শাখা সাংগঠনিক রিপোর্ট — $monthStr $yearStr',
      buildPdf: (format) => PdfExportService.generateSingleFormPdfBytes(
        title: 'শাখা সাংগঠনিক রিপোর্ট ফরম',
        majlisName: 'বাংলাদেশ খেলাফত মজলিস',
        userName: _shakhaNameController.text.isEmpty ? 'শাখা সম্পাদক' : _shakhaNameController.text,
        period: '$monthStr $yearStr',
        dataFields: {
          'শাখার নাম': _shakhaNameController.text,
          'জনশক্তি বিবরণী': _manpowerController.text,
          'দাওয়াত ও গণসংযোগ': _dawahController.text,
          'সংগঠন ও শাখা গঠন': _organizationController.text,
          'সভাসমূহ ও প্রোগ্রাম': _meetingsController.text,
          'বায়তুলমাল সংগ্রহ ও মোট ব্যয়': _baytulmalController.text,
          'সফর সংখ্যা': _tourController.text,
          'প্রশিক্ষণ বৈঠক': _trainingController.text,
          'দফতর সম্পাদক রিপোর্ট': _officeController.text,
          'প্রচার ও প্রকাশনা': _publicityController.text,
          'পাঠাগার ও বই সংখ্যা': _libraryController.text,
          'সমাজকল্যাণ কার্যক্রম': _welfareController.text,
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
    const accentPurple = Color(0xFFC084FC);

    final monthStr = widget.month != null ? _monthNames[widget.month! - 1] : '';
    final yearStr = widget.year != null ? _bn(widget.year!) : '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 1,
        title: Text(
          'শাখা রিপোর্ট — $monthStr $yearStr',
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
        primaryAccent: accentPurple,
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
                                    onPressed: _saveReport,
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
                                  ? '🔒 রিপোর্টটি লকড অবস্থায় আছে। পরিবর্তন করতে ওপরে এডিটে চাপুন।'
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

                    _buildCard('সাংগঠনিক রিপোর্ট তথ্য', [
                      _buildTextField(_manpowerController, 'জনশক্তি বিবরণী', textLight: textLight),
                      _buildTextField(_dawahController, 'দাওয়াত ও গণসংযোগ', textLight: textLight),
                      _buildTextField(_organizationController, 'সংগঠন', textLight: textLight),
                      _buildTextField(_meetingsController, 'সভাসমূহ', textLight: textLight),
                      _buildTextField(_baytulmalController, 'বায়তুলমাল', textLight: textLight),
                      _buildTextField(_tourController, 'সফর', textLight: textLight),
                      _buildTextField(_trainingController, 'প্রশিক্ষণ', textLight: textLight),
                      _buildTextField(_officeController, 'দফতর', textLight: textLight),
                      _buildTextField(_publicityController, 'প্রচার', textLight: textLight),
                      _buildTextField(_libraryController, 'পাঠাগার', textLight: textLight),
                      _buildTextField(_welfareController, 'সমাজকল্যাণ', textLight: textLight),
                    ], cardBg, textLight),
                    const SizedBox(height: 16),

                    _buildCard('মন্তব্য (সমস্যা ও সম্ভাবনা)', [
                      _buildTextField(_commentsController, 'মন্তব্য ও সুপারিশ', maxLines: 3, textLight: textLight),
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
