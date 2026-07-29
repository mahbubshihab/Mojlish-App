import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';

/// খেলাফত মজলিস — শাখা সাংগঠনিক রিপোর্ট ফরম (২-ট্যাব: তথ্য পূরণ/লক ও ফরম্যাট প্রিভিউ/ডাউনলোড)
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

  Future<void> _exportPdf() async {
    final yearStr = widget.year != null ? _bn(widget.year!) : '';
    final monthStr = widget.month != null ? _monthNames[widget.month! - 1] : '';

    await PdfExportService.printOrDownloadPdf(
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarBg,
          elevation: 1,
          title: Text(
            'শাখা রিপোর্ট — $monthStr $yearStr',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          bottom: const TabBar(
            indicatorColor: accentPurple,
            indicatorWeight: 3,
            labelColor: accentPurple,
            tabs: [
              Tab(icon: Icon(Icons.edit_note_rounded, size: 26)),
              Tab(icon: Icon(Icons.picture_as_pdf_rounded, size: 26)),
            ],
          ),
        ),
        body: AmbientBackgroundWidget(
          primaryAccent: accentPurple,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    _buildFormTab(cardBg, textLight, accentPurple),
                    _buildPreviewTab(cardBg, textLight, accentPurple),
                  ],
                ),
        ),
      ),
    );
  }

  // ==========================================
  // TAB 1: FORM ENTRY & EDIT LOCKING
  // ==========================================
  Widget _buildFormTab(Color cardBg, Color textLight, Color accentPurple) {
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
                        ? '🔒 রিপোর্টটি লকড অবস্থায় আছে। পরিবর্তন করতে এডিট করুন।'
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

          _buildCard('সাংগঠনিক রিপোর্ট তথ্য', [
            _buildTextField(_manpowerController, 'জনশক্তি বিবরণী'),
            _buildTextField(_dawahController, 'দাওয়াত ও গণসংযোগ'),
            _buildTextField(_organizationController, 'সংগঠন'),
            _buildTextField(_meetingsController, 'সভাসমূহ'),
            _buildTextField(_baytulmalController, 'বায়তুলমাল'),
            _buildTextField(_tourController, 'সফর'),
            _buildTextField(_trainingController, 'প্রশিক্ষণ'),
            _buildTextField(_officeController, 'দফতর'),
            _buildTextField(_publicityController, 'প্রচার'),
            _buildTextField(_libraryController, 'পাঠাগার'),
            _buildTextField(_welfareController, 'সমাজকল্যাণ'),
          ], cardBg, textLight),
          const SizedBox(height: 16),

          _buildCard('মন্তব্য (সমস্যা ও সম্ভাবনা)', [
            _buildTextField(_commentsController, 'মন্তব্য ও সুপারিশ', maxLines: 3),
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
                    onPressed: _saveReport,
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
  // TAB 2: EXACT WHITE A4 PDF PREVIEW & DOWNLOAD
  // ==========================================
  Widget _buildPreviewTab(Color cardBg, Color textLight, Color accentPurple) {
    final monthStr = widget.month != null ? _monthNames[widget.month! - 1] : '';
    final yearStr = widget.year != null ? _bn(widget.year!) : '';
    const paperTextColor = Color(0xFF0F172A);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 1. Exact A4 White Paper PDF Preview Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
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
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'শাখা সাংগঠনিক রিপোর্ট — $monthStr $yearStr',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: paperTextColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'শাখা: ${_shakhaNameController.text.isEmpty ? "(শাখার নাম প্রদান করুন)" : _shakhaNameController.text}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0284C7)),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 32, thickness: 1.5, color: Colors.grey),

                _buildPreviewRow('শাখার নাম', _shakhaNameController.text, paperTextColor),
                _buildPreviewRow('জনশক্তি বিবরণী', _manpowerController.text, paperTextColor),
                _buildPreviewRow('দাওয়াত ও গণসংযোগ', _dawahController.text, paperTextColor),
                _buildPreviewRow('সংগঠন ও শাখা বিস্তার', _organizationController.text, paperTextColor),
                _buildPreviewRow('সভাসমূহ ও মিটিং', _meetingsController.text, paperTextColor),
                _buildPreviewRow('বায়তুলমাল ও তহবিল', _baytulmalController.text, paperTextColor),
                _buildPreviewRow('সফর সংখ্যা', _tourController.text, paperTextColor),
                _buildPreviewRow('প্রশিক্ষণ কর্মসূচি', _trainingController.text, paperTextColor),
                _buildPreviewRow('দফতর সম্পাদক রিপোর্ট', _officeController.text, paperTextColor),
                _buildPreviewRow('প্রচার ও প্রকাশনা', _publicityController.text, paperTextColor),
                _buildPreviewRow('পাঠাগার বিবরণী', _libraryController.text, paperTextColor),
                _buildPreviewRow('সমাজকল্যাণ মূলক কাজ', _welfareController.text, paperTextColor),

                if (_commentsController.text.isNotEmpty) ...[
                  const Divider(height: 24, thickness: 1, color: Colors.grey),
                  const Text('মন্তব্য ও সুপারিশ:', style: TextStyle(fontWeight: FontWeight.bold, color: paperTextColor, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(_commentsController.text, style: const TextStyle(color: paperTextColor, fontSize: 13.5)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Download Button Placed BELOW the PDF Preview Card
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _exportPdf,
              icon: const Icon(Icons.picture_as_pdf_rounded, size: 24),
              label: const Text('PDF ডাউনলোড / প্রিন্ট করুন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 4,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPreviewRow(String title, String value, Color textColor) {
    final val = value.trim().isEmpty ? '—' : value.trim();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 145,
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
