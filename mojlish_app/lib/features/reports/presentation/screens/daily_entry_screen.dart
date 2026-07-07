import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/models/daily_personal_entry.dart';
import '../../data/services/report_storage_service.dart';

/// একটি নির্দিষ্ট তারিখের দৈনিক রিপোর্ট এন্ট্রি ফর্ম
class DailyEntryScreen extends StatefulWidget {
  final DateTime date;

  const DailyEntryScreen({super.key, required this.date});

  @override
  State<DailyEntryScreen> createState() => _DailyEntryScreenState();
}

class _DailyEntryScreenState extends State<DailyEntryScreen> {
  // কুরআন
  final _quranSuraCtrl = TextEditingController();
  final _quranAyahCtrl = TextEditingController();
  // হাদিস
  final _hadithCtrl = TextEditingController();
  // সাহিত্য
  final _islamicLitCtrl = TextEditingController();
  final _otherLitCtrl = TextEditingController();
  // পাঠ্যপুস্তক
  final _textbookCtrl = TextEditingController();
  // জামায়াতে নামাজ
  final _jamaatCtrl = TextEditingController();
  // যোগাযোগ
  final _contactNameCtrl = TextEditingController();
  final _contactCountCtrl = TextEditingController();
  // দাওয়াত
  final _dawahCtrl = TextEditingController();
  // সময় দান
  final _timeServiceCtrl = TextEditingController();
  // সমাজ সেবা
  final _socialServiceCtrl = TextEditingController();

  bool _isSaving = false;
  bool _isLoading = true;

  static const _darkBg = Color(0xFF0D1B2A);
  static const _cardBg = Color(0xFF162032);
  static const _borderColor = Color(0xFF2A3F58);
  static const _accentGreen = Color(0xFF10B981);
  static const _textLight = Color(0xFFE2E8F0);
  static const _textMuted = Color(0xFF94A3B8);

  @override
  void initState() {
    super.initState();
    _loadExistingEntry();
  }

  @override
  void dispose() {
    for (final c in [
      _quranSuraCtrl, _quranAyahCtrl, _hadithCtrl, _islamicLitCtrl,
      _otherLitCtrl, _textbookCtrl, _jamaatCtrl, _contactNameCtrl,
      _contactCountCtrl, _dawahCtrl, _timeServiceCtrl, _socialServiceCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String get _dateKey => ReportStorageService.dateKey(widget.date);

  Future<void> _loadExistingEntry() async {
    try {
      final entry = await ReportStorageService.getPersonalEntry(_dateKey);
      if (entry != null && mounted) {
        setState(() {
          _quranSuraCtrl.text = entry.quranSura.isNotEmpty ? entry.quranSura : entry.quranStudy;
          _quranAyahCtrl.text = entry.quranAyah;
          _hadithCtrl.text = entry.hadithStudy;
          _islamicLitCtrl.text = entry.islamicLiterature;
          _otherLitCtrl.text = entry.otherLiterature;
          _textbookCtrl.text = entry.textbookStudy;
          _jamaatCtrl.text = entry.jamaatPrayer;
          _contactNameCtrl.text = entry.contactName.isNotEmpty ? entry.contactName : entry.contact;
          _contactCountCtrl.text = entry.contactCount;
          _dawahCtrl.text = entry.dawah;
          _timeServiceCtrl.text = entry.timeService.isNotEmpty ? entry.timeService : entry.volunteering;
          _socialServiceCtrl.text = entry.socialService;
        });
      }
    } catch (e) {
      debugPrint('Error loading existing entry: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final entry = DailyPersonalEntry(
      date: _dateKey,
      quranSura: _quranSuraCtrl.text.trim(),
      quranAyah: _quranAyahCtrl.text.trim(),
      hadithStudy: _hadithCtrl.text.trim(),
      islamicLiterature: _islamicLitCtrl.text.trim(),
      otherLiterature: _otherLitCtrl.text.trim(),
      textbookStudy: _textbookCtrl.text.trim(),
      jamaatPrayer: _jamaatCtrl.text.trim(),
      contactName: _contactNameCtrl.text.trim(),
      contactCount: _contactCountCtrl.text.trim(),
      dawah: _dawahCtrl.text.trim(),
      timeService: _timeServiceCtrl.text.trim(),
      socialService: _socialServiceCtrl.text.trim(),
    );
    await ReportStorageService.savePersonalEntry(entry);
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('রিপোর্ট সেভ করা হয়েছে ✓'),
          backgroundColor: _accentGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.pop(context, true); // return true = data changed
    }
  }

  String get _formattedDate {
    const days = ['সোমবার', 'মঙ্গলবার', 'বুধবার', 'বৃহস্পতিবার', 'শুক্রবার', 'শনিবার', 'রবিবার'];
    const months = ['জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন', 'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'];
    final d = widget.date;
    final dayName = days[d.weekday - 1];
    return '$dayName, ${_bn(d.day)} ${months[d.month - 1]} ${_bn(d.year)}';
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      appBar: AppBar(
        backgroundColor: _cardBg,
        iconTheme: const IconThemeData(color: _textLight),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_formattedDate,
                style: const TextStyle(color: _textLight, fontSize: 14, fontWeight: FontWeight.bold)),
            Text('দৈনিক রিপোর্ট এন্ট্রি',
                style: const TextStyle(color: _textMuted, fontSize: 11)),
          ],
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: _borderColor, height: 1),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DailyBgPainter())),
          _isLoading
              ? const Center(child: CircularProgressIndicator(color: _accentGreen))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSection('কুরআন অধ্যয়ন', Icons.menu_book, const Color(0xFF10B981), [
                        _buildRow([
                          _buildField('সূরা (পড়া)', _quranSuraCtrl, hint: 'সূরার নাম/নম্বর'),
                          _buildField('আয়াত', _quranAyahCtrl, hint: 'আয়াত সংখ্যা', numeric: true),
                        ]),
                      ]),

                      _buildSection('হাদিস অধ্যয়ন', Icons.book, const Color(0xFF0EA5E9), [
                        _buildField('বিষয় ও সংখ্যা', _hadithCtrl, hint: 'যা পড়েছেন তার বিস্তারিত'),
                      ]),

                      _buildSection('সাহিত্য অধ্যয়ন', Icons.library_books, const Color(0xFF8B5CF6), [
                        _buildRow([
                          _buildField('ইসলামি', _islamicLitCtrl, hint: 'ইসলামি সাহিত্য'),
                          _buildField('অন্যান্য', _otherLitCtrl, hint: 'অন্যান্য'),
                        ]),
                      ]),

                      _buildSection('পাঠ্যপুস্তক অধ্যয়ন', Icons.school, const Color(0xFFF59E0B), [
                        _buildField('বিষয় ও বিস্তারিত', _textbookCtrl, hint: 'কোন বই, কত পৃষ্ঠা'),
                      ]),

                      _buildSection('জামায়াতে নামাজ', Icons.mosque, const Color(0xFFEC4899), [
                        _buildField('কত ওয়াক্ত (সর্বোচ্চ ৫)', _jamaatCtrl,
                            hint: '০ থেকে ৫', numeric: true),
                      ]),

                      _buildSection('যোগাযোগ', Icons.phone, const Color(0xFF10B981), [
                        _buildRow([
                          _buildField('নাম / বিস্তারিত', _contactNameCtrl, hint: 'যার সাথে যোগাযোগ'),
                          _buildField('সংখ্যা', _contactCountCtrl, hint: 'মোট জন', numeric: true),
                        ]),
                      ]),

                      _buildSection('দাওয়াত', Icons.people, const Color(0xFFEF4444), [
                        _buildField('কত জনকে দাওয়াত', _dawahCtrl,
                            hint: 'সংখ্যা লিখুন', numeric: true),
                      ]),

                      _buildSection('সময় দান', Icons.volunteer_activism, const Color(0xFF0EA5E9), [
                        _buildField('কত ঘণ্টা / কি কাজে', _timeServiceCtrl, hint: 'বিস্তারিত'),
                      ]),

                      _buildSection('সমাজ সেবা', Icons.handshake, const Color(0xFF059669), [
                        _buildField('কি কাজ করা হয়েছে', _socialServiceCtrl,
                            hint: 'বিস্তারিত বিবরণ', maxLines: 2),
                      ]),

                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _isSaving ? null : _save,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 18, height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.save, color: Colors.white),
                          label: Text(
                            _isSaving ? 'সেভ হচ্ছে...' : 'সেভ করুন',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accentGreen,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Color color, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
            ]),
          ),
          Divider(color: _borderColor, height: 1),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Row(
      children: children
          .expand((w) => [Expanded(child: w), const SizedBox(width: 10)])
          .take(children.length * 2 - 1)
          .toList(),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, {
    String hint = '',
    bool numeric = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: numeric ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        style: const TextStyle(color: _textLight, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: _textMuted, fontSize: 12),
          hintStyle: const TextStyle(color: Color(0xFF4A5568), fontSize: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _accentGreen, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          filled: true,
          fillColor: const Color(0xFF0A1628),
          isDense: true,
        ),
      ),
    );
  }
}

class _DailyBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = const Color(0xFF10B981).withValues(alpha: 0.025)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.05), 130, fill);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.5), 100, fill);

    final grid = Paint()..color = const Color(0xFF10B981).withValues(alpha: 0.012)..strokeWidth = 0.5..style = PaintingStyle.stroke;
    for (double x = 0; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    for (double y = 0; y < size.height; y += 40) canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);

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
  bool shouldRepaint(_DailyBgPainter _) => false;
}
