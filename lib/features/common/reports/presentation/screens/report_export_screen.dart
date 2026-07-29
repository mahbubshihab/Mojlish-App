import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';
import 'package:mojlish_app/features/common/reports/data/services/pdf_generator_service.dart';

/// PDF এক্সপোর্ট স্ক্রিন — তারিখ রেঞ্জ সিলেক্ট করে রিপোর্ট এক্সপোর্ট করা যায়
class ReportExportScreen extends StatefulWidget {
  final String reportType; // 'personal' or 'baytulmal'

  const ReportExportScreen({super.key, required this.reportType});

  @override
  State<ReportExportScreen> createState() => _ReportExportScreenState();
}

class _ReportExportScreenState extends State<ReportExportScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _isExporting = false;
  final _userNameCtrl = TextEditingController();
  final _branchCtrl = TextEditingController();

  static const _darkBg = Color(0xFF0D1B2A);
  static const _cardBg = Color(0xFF162032);
  static const _borderColor = Color(0xFF2A3F58);
  static const _accentGreen = Color(0xFF10B981);
  static const _textLight = Color(0xFFE2E8F0);
  static const _textMuted = Color(0xFF94A3B8);

  String get _title => widget.reportType == 'personal'
      ? 'ব্যক্তিগত রিপোর্ট এক্সপোর্ট'
      : 'বায়তুলমাল রিপোর্ট এক্সপোর্ট';

  @override
  void dispose() {
    _userNameCtrl.dispose();
    _branchCtrl.dispose();
    super.dispose();
  }

  void _setQuickRange(String range) {
    final now = DateTime.now();
    setState(() {
      switch (range) {
        case '7':
          _fromDate = now.subtract(const Duration(days: 6));
          _toDate = now;
          break;
        case '10':
          _fromDate = now.subtract(const Duration(days: 9));
          _toDate = now;
          break;
        case 'month':
          _fromDate = DateTime(now.year, now.month, 1);
          _toDate = now;
          break;
        case 'year':
          _fromDate = DateTime(now.year, 1, 1);
          _toDate = now;
          break;
      }
    });
  }

  Future<void> _pickDate(bool isFrom) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? (_fromDate ?? now) : (_toDate ?? now),
      firstDate: DateTime(2020),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _accentGreen,
              onPrimary: Colors.white,
              surface: _cardBg,
              onSurface: _textLight,
            ), dialogTheme: DialogThemeData(backgroundColor: _darkBg),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
          if (_toDate != null && _toDate!.isBefore(picked)) _toDate = picked;
        } else {
          _toDate = picked;
          if (_fromDate != null && _fromDate!.isAfter(picked)) _fromDate = picked;
        }
      });
    }
  }

  Future<void> _exportPdf() async {
    if (_fromDate == null || _toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('অনুগ্রহ করে শুরু এবং শেষের তারিখ সিলেক্ট করুন'), backgroundColor: Colors.orange),
      );
      return;
    }
    setState(() => _isExporting = true);

    try {
      if (widget.reportType == 'personal') {
        final entries = await ReportStorageService.getPersonalEntriesInRange(_fromDate!, _toDate!);
        await PdfGeneratorService.generatePersonalReportPdf(
          entries: entries,
          fromDate: _fromDate!,
          toDate: _toDate!,
          userName: _userNameCtrl.text.trim().isEmpty ? 'অজানা' : _userNameCtrl.text.trim(),
          branchName: _branchCtrl.text.trim().isEmpty ? 'অজানা' : _branchCtrl.text.trim(),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF তৈরি করতে সমস্যা হয়েছে: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  String _formatDate(DateTime? d) {
    if (d == null) return 'সিলেক্ট করুন';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  int get _dayCount {
    if (_fromDate == null || _toDate == null) return 0;
    return _toDate!.difference(_fromDate!).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      appBar: AppBar(
        title: Text(_title, style: const TextStyle(color: _textLight, fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: _cardBg,
        iconTheme: const IconThemeData(color: _textLight),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _ExportBgPainter())),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _accentGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _accentGreen.withValues(alpha: 0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.picture_as_pdf, color: _accentGreen, size: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('রিপোর্ট PDF এক্সপোর্ট', style: TextStyle(color: _textLight, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('তারিখ রেঞ্জ সিলেক্ট করে PDF ডাউনলোড বা শেয়ার করুন',
                            style: TextStyle(color: _textMuted, fontSize: 12)),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 24),

                // User info (only for personal report)
                if (widget.reportType == 'personal') ...[
                  _sectionHeader('ব্যক্তিগত তথ্য'),
                  _field('কর্মীর নাম', 'আপনার নাম লিখুন', _userNameCtrl),
                  _field('শাখার নাম', 'শাখার নাম লিখুন', _branchCtrl),
                  const SizedBox(height: 8),
                ],

                // Quick range buttons
                _sectionHeader('তারিখ পরিসর নির্বাচন'),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  _quickBtn('শেষ ৭ দিন', '7'),
                  _quickBtn('শেষ ১০ দিন', '10'),
                  _quickBtn('এই মাস', 'month'),
                  _quickBtn('এই বছর', 'year'),
                ]),
                const SizedBox(height: 20),

                // Date pickers
                Row(children: [
                  Expanded(child: _datePicker('শুরুর তারিখ', _fromDate, () => _pickDate(true))),
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward, color: _textMuted),
                  const SizedBox(width: 12),
                  Expanded(child: _datePicker('শেষ তারিখ', _toDate, () => _pickDate(false))),
                ]),
                const SizedBox(height: 16),

                // Day count chip
                if (_dayCount > 0)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: _accentGreen.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _accentGreen.withValues(alpha: 0.3)),
                      ),
                      child: Text('মোট $_dayCount দিনের রিপোর্ট',
                          style: const TextStyle(color: _accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                const SizedBox(height: 28),

                // Export button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: (_isExporting || _fromDate == null || _toDate == null) ? null : _exportPdf,
                    icon: _isExporting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.download, color: Colors.white),
                    label: Text(
                      _isExporting ? 'PDF তৈরি হচ্ছে...' : 'PDF তৈরি করুন ও শেয়ার করুন',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentGreen,
                      disabledBackgroundColor: _borderColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Info box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.3)),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Icon(Icons.info_outline, color: Color(0xFF60A5FA), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'PDF তৈরি হওয়ার পর আপনি সরাসরি শেয়ার করতে বা ডাউনলোড করতে পারবেন। যে দিনগুলোর রিপোর্ট ছিল না সেগুলো লাল রঙে "মিসিং" হিসেবে দেখানো হবে।',
                        style: const TextStyle(color: Color(0xFF93C5FD), fontSize: 12),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickBtn(String label, String key) {
    final isSelected = _isRangeSelected(key);
    return GestureDetector(
      onTap: () => _setQuickRange(key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _accentGreen : _cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? _accentGreen : _borderColor),
          boxShadow: isSelected ? [BoxShadow(color: _accentGreen.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))] : [],
        ),
        child: Text(label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : _textLight,
              fontSize: 13,
            )),
      ),
    );
  }

  bool _isRangeSelected(String key) {
    if (_fromDate == null || _toDate == null) return false;
    final now = DateTime.now();
    switch (key) {
      case '7':
        return _dayCount == 7;
      case '10':
        return _dayCount == 10;
      case 'month':
        return _fromDate!.day == 1 && _fromDate!.month == now.month && _fromDate!.year == now.year;
      case 'year':
        return _fromDate!.day == 1 && _fromDate!.month == 1 && _fromDate!.year == now.year;
      default:
        return false;
    }
  }

  Widget _datePicker(String label, DateTime? date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: date != null ? _accentGreen : _borderColor, width: date != null ? 1.5 : 1),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 11, color: _textMuted)),
          const SizedBox(height: 4),
          Row(children: [
            Icon(Icons.calendar_today, size: 16, color: date != null ? _accentGreen : _textMuted),
            const SizedBox(width: 6),
            Expanded(
              child: Text(_formatDate(date),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: date != null ? _textLight : _textMuted,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 12),
      child: Row(children: [
        Container(width: 4, height: 18, decoration: BoxDecoration(color: _accentGreen, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textLight)),
      ]),
    );
  }

  Widget _field(String label, String hint, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(color: _textLight, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: _textMuted, fontSize: 12),
          hintStyle: const TextStyle(color: Color(0xFF4A5568)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _accentGreen, width: 1.5),
          ),
          filled: true,
          fillColor: const Color(0xFF0A1628),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ),
      ),
    );
  }
}

class _ExportBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = const Color(0xFF10B981).withValues(alpha: 0.025)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.05), 130, fill);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.5), 100, fill);

    final grid = Paint()..color = const Color(0xFF10B981).withValues(alpha: 0.012)..strokeWidth = 0.5..style = PaintingStyle.stroke;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final star = Paint()..color = const Color(0xFF1E3A52)..style = PaintingStyle.fill;
    _drawStar(canvas, Offset(size.width * 0.85, size.height * 0.12), 18, star);
    _drawStar(canvas, Offset(size.width * 0.08, size.height * 0.3), 12, star);
  }

  void _drawStar(Canvas canvas, Offset c, double r, Paint p) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final a = i * 45 * pi / 180;
      final rad = i % 2 == 0 ? r : r * 0.45;
      i == 0 ? path.moveTo(c.dx + rad * cos(a), c.dy + rad * sin(a))
             : path.lineTo(c.dx + rad * cos(a), c.dy + rad * sin(a));
    }
    path.close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_ExportBgPainter _) => false;
}
