import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';

/// খেলাফত মজলিস — শাখা পরিকল্পনা ফরম
class KhelafatBranchPlanScreen extends StatefulWidget {
  final int? year;
  final int? month;

  const KhelafatBranchPlanScreen({super.key, this.year, this.month});

  @override
  State<KhelafatBranchPlanScreen> createState() => _KhelafatBranchPlanScreenState();
}

class _KhelafatBranchPlanScreenState extends State<KhelafatBranchPlanScreen> {
  final _shakhaNameController = TextEditingController();
  final _targetMemberController = TextEditingController();
  final _targetDawahController = TextEditingController();
  final _targetMeetingController = TextEditingController();
  final _targetBaytulmalController = TextEditingController();
  final _commentsController = TextEditingController();

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
  ];

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
      userName: _shakhaNameController.text.isEmpty ? 'শাখা সভাপতি' : _shakhaNameController.text,
      period: '$monthStr $yearStr',
      dataFields: {
        'শাখার নাম': _shakhaNameController.text,
        'সদস্য সংখ্যা বৃদ্ধির লক্ষ্য': _targetMemberController.text,
        'দাওয়াত ও গণসংযোগ পরিকল্পনা': _targetDawahController.text,
        'সভাসমূহ ও বৈঠক পরিকল্পনা': _targetMeetingController.text,
        'বায়তুলমাল সংগ্রহের লক্ষ্যমাত্রা': _targetBaytulmalController.text,
      },
      comments: _commentsController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final bg = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
    final textLight = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    const accentPurple = Color(0xFFC084FC);

    final titleText = widget.month != null && widget.year != null
        ? 'শাখা পরিকল্পনা - ${_monthNames[widget.month! - 1]} ${_bn(widget.year!)}'
        : 'শাখা পরিকল্পনা ফরম';

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(titleText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, color: accentPurple),
            onPressed: _exportPdf,
            tooltip: 'পিডিএফ ডাউনলোড',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard('শাখার তথ্য', [
              _buildTextField(_shakhaNameController, 'শাখার নাম'),
            ], cardBg, textLight),
            const SizedBox(height: 16),
            _buildCard('সাংগঠনিক ও দাওয়াতী পরিকল্পনা', [
              _buildTextField(_targetMemberController, 'সদস্য সংখ্যা বৃদ্ধির লক্ষ্যমাত্রা'),
              _buildTextField(_targetDawahController, 'দাওয়াতী কার্যক্রমের লক্ষ্যমাত্রা'),
              _buildTextField(_targetMeetingController, 'মাসিক বৈঠক পরিকল্পনা'),
              _buildTextField(_targetBaytulmalController, 'বায়তুলমাল সংগ্রহের লক্ষ্য (টাকা)'),
            ], cardBg, textLight),
            const SizedBox(height: 16),
            _buildCard('বিশেষ মন্তব্য ও পরিকল্পনা', [
              _buildTextField(_commentsController, 'মন্তব্য ও সুপারিশ', maxLines: 3),
            ], cardBg, textLight),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('পরিকল্পনা সংরক্ষণ করা হয়েছে')),
                      );
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('সংরক্ষণ করুন'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _exportPdf,
                    icon: const Icon(Icons.picture_as_pdf_rounded),
                    label: const Text('পিডিএফ ডাউনলোড'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: accentPurple,
                      side: const BorderSide(color: accentPurple),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children, Color cardBg, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
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
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
