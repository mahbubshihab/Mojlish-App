import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import '../../data/models/daily_personal_entry.dart';
import '../../../shared/data/services/report_storage_service.dart';

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
  final _hadithCountCtrl = TextEditingController();
  final _hadithTopicCtrl = TextEditingController();

  // সাহিত্য
  final _islamicLitPagesCtrl = TextEditingController();
  final _islamicLitBookCtrl = TextEditingController();

  // পাঠ্যপুস্তক
  final _textbookCtrl = TextEditingController();

  // জামায়াতে নামাজ এবং আত্মবিচার
  final _jamaatCtrl = TextEditingController();
  bool _selfAnalysisVal = false;

  // দাওয়াত ও জনসংযোগ
  final _contactCountCtrl = TextEditingController();
  final _contactNameCtrl = TextEditingController();
  final _dawahMaterialsCtrl = TextEditingController();

  // সাংগঠনিক কাজ
  final _meetingNameCtrl = TextEditingController();
  final _orgTimeCtrl = TextEditingController();
  final _memberContactCountCtrl = TextEditingController();
  final _memberContactNameCtrl = TextEditingController();

  // বিবিধ
  final _newspaperTimeCtrl = TextEditingController();
  final _physicalExerciseTimeCtrl = TextEditingController();
  final _familyWelfareTimeCtrl = TextEditingController();

  bool _isSaving = false;
  bool _isLoading = true;
  bool _isLocked = true;
  bool _entryExists = false;

  late String _dateKey;

  @override
  void initState() {
    super.initState();
    final d = widget.date;
    _dateKey = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    _loadExistingEntry();
  }

  @override
  void dispose() {
    for (final ctrl in [
      _quranSuraCtrl,
      _quranAyahCtrl,
      _hadithCountCtrl,
      _hadithTopicCtrl,
      _islamicLitPagesCtrl,
      _islamicLitBookCtrl,
      _textbookCtrl,
      _jamaatCtrl,
      _contactCountCtrl,
      _contactNameCtrl,
      _dawahMaterialsCtrl,
      _meetingNameCtrl,
      _orgTimeCtrl,
      _memberContactCountCtrl,
      _memberContactNameCtrl,
      _newspaperTimeCtrl,
      _physicalExerciseTimeCtrl,
      _familyWelfareTimeCtrl
    ]) {
      ctrl.dispose();
    }
    super.dispose();
  }

  Future<void> _loadExistingEntry() async {
    try {
      final entry = await ReportStorageService.getPersonalEntry(_dateKey);
      if (entry != null && mounted) {
        setState(() {
          _entryExists = true;
          _isLocked = true;
          _quranSuraCtrl.text = entry.quranSura;
          _quranAyahCtrl.text = entry.quranAyah;
          _hadithCountCtrl.text = entry.hadithCount.isEmpty ? entry.hadithStudy : entry.hadithCount;
          _hadithTopicCtrl.text = entry.hadithTopic;
          _islamicLitPagesCtrl.text = entry.islamicLitPages.isEmpty ? entry.islamicLiterature : entry.islamicLitPages;
          _islamicLitBookCtrl.text = entry.islamicLitBook;
          _textbookCtrl.text = entry.textbookHours.isEmpty ? entry.textbookStudy : entry.textbookHours;
          _jamaatCtrl.text = entry.jamaatPrayer;
          _selfAnalysisVal = (entry.selfAnalysis == 'হ্যাঁ' || entry.selfAnalysis == 'yes' || entry.selfAnalysis == '1');
          _contactCountCtrl.text = entry.contactCount;
          _contactNameCtrl.text = entry.contactName;
          _dawahMaterialsCtrl.text = entry.dawahMaterials.isEmpty ? entry.dawah : entry.dawahMaterials;
          _meetingNameCtrl.text = entry.meetingName;
          _orgTimeCtrl.text = entry.orgTime.isEmpty ? entry.timeService : entry.orgTime;
          _memberContactCountCtrl.text = entry.memberContactCount;
          _memberContactNameCtrl.text = entry.memberContactName;
          _newspaperTimeCtrl.text = entry.newspaperTime;
          _physicalExerciseTimeCtrl.text = entry.physicalExerciseTime;
          _familyWelfareTimeCtrl.text = entry.familyWelfareTime;
        });
      } else {
        setState(() {
          _entryExists = false;
          _isLocked = false;
        });
      }
    } catch (_) {} finally {
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
      hadithCount: _hadithCountCtrl.text.trim(),
      hadithTopic: _hadithTopicCtrl.text.trim(),
      islamicLitPages: _islamicLitPagesCtrl.text.trim(),
      islamicLitBook: _islamicLitBookCtrl.text.trim(),
      textbookHours: _textbookCtrl.text.trim(),
      jamaatPrayer: _jamaatCtrl.text.trim(),
      selfAnalysis: _selfAnalysisVal ? 'হ্যাঁ' : 'না',
      contactCount: _contactCountCtrl.text.trim(),
      contactName: _contactNameCtrl.text.trim(),
      dawahMaterials: _dawahMaterialsCtrl.text.trim(),
      meetingName: _meetingNameCtrl.text.trim(),
      orgTime: _orgTimeCtrl.text.trim(),
      memberContactCount: _memberContactCountCtrl.text.trim(),
      memberContactName: _memberContactNameCtrl.text.trim(),
      newspaperTime: _newspaperTimeCtrl.text.trim(),
      physicalExerciseTime: _physicalExerciseTimeCtrl.text.trim(),
      familyWelfareTime: _familyWelfareTimeCtrl.text.trim(),
    );
    await ReportStorageService.savePersonalEntry(entry);
    setState(() {
      _isSaving = false;
      _isLocked = true;
      _entryExists = true;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('রিপোর্ট সেভ করা হয়েছে ✓', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xFF10B981),
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
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;

        // Theme colors
        final bg = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
        final appBarBg = isDark ? const Color(0xFF162032) : Colors.white;
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
        final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);
        final textLight = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
        final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        final inputFill = isDark ? const Color(0xFF0A1628) : const Color(0xFFF1F5F9);
        const accentGreen = Color(0xFF10B981);

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: appBarBg,
            iconTheme: IconThemeData(color: textLight),
            centerTitle: true,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_formattedDate,
                    style: TextStyle(color: textLight, fontSize: 13, fontWeight: FontWeight.bold)),
                Text('দৈনিক রিপোর্ট এন্ট্রি',
                    style: TextStyle(color: textMuted, fontSize: 10)),
              ],
            ),
            actions: [
              if (_entryExists && _isLocked)
                TextButton.icon(
                  icon: const Icon(Icons.edit, color: accentGreen, size: 16),
                  label: const Text('এডিট করুন', style: TextStyle(color: accentGreen, fontSize: 13, fontWeight: FontWeight.bold)),
                  onPressed: () => setState(() => _isLocked = false),
                ),
            ],
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: borderColor, height: 1),
            ),
          ),
          body: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _DailyBgPainter(isDark: isDark))),
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: accentGreen))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // ১. অধ্যয়ন
                          _sectionHeader('১. অধ্যয়ন (Study)', accentGreen),
                          _field('কুরআন: সূরা', 'সূরা লিখুন', _quranSuraCtrl, inputFill, borderColor, textLight, textMuted, accentGreen),
                          _field('কুরআন: আয়াত সংখ্যা', 'আয়াত সংখ্যা', _quranAyahCtrl, inputFill, borderColor, textLight, textMuted, accentGreen, numeric: true),
                          const Divider(height: 24),
                          _field('হাদিস: হাদিস সংখ্যা', 'সংখ্যা', _hadithCountCtrl, inputFill, borderColor, textLight, textMuted, accentGreen, numeric: true),
                          _field('হাদিস: বিষয়/গ্রন্থ', 'বিষয় বা গ্রন্থ নাম', _hadithTopicCtrl, inputFill, borderColor, textLight, textMuted, accentGreen),
                          const Divider(height: 24),
                          _field('ইসলামী সাহিত্য: পৃষ্ঠা সংখ্যা', 'পৃষ্ঠা সংখ্যা', _islamicLitPagesCtrl, inputFill, borderColor, textLight, textMuted, accentGreen, numeric: true),
                          _field('ইসলামী সাহিত্য: বইয়ের নাম', 'বইয়ের নাম', _islamicLitBookCtrl, inputFill, borderColor, textLight, textMuted, accentGreen),
                          const Divider(height: 24),
                          _field('পাঠ্যপুস্তক/ক্লাস অধ্যয়ন (ঘণ্টা)', 'ঘণ্টা', _textbookCtrl, inputFill, borderColor, textLight, textMuted, accentGreen, numeric: true),
                          const SizedBox(height: 16),

                          // ২. ইবাদত
                          _sectionHeader('২. ইবাদত (Worship)', accentGreen),
                          _field('জামাআতে নামায (ওয়াক্ত)', 'ওয়াক্ত সংখ্যা', _jamaatCtrl, inputFill, borderColor, textLight, textMuted, accentGreen, numeric: true),
                          _switchField('আত্মবিচার আদায় করেছেন?', textLight, textMuted, accentGreen),
                          const SizedBox(height: 16),

                          // ৩. দাওয়াতি কাজ
                          _sectionHeader('৩. দাওয়াতি কাজ (Dawah)', accentGreen),
                          _field('দাওয়াতি যোগাযোগ (সংখ্যা)', 'কতজনের সাথে যোগাযোগ', _contactCountCtrl, inputFill, borderColor, textLight, textMuted, accentGreen, numeric: true),
                          _field('যোগাযোগকৃত ব্যক্তির নাম', 'নাম লিখুন (কমা দিয়ে আলাদা করুন)', _contactNameCtrl, inputFill, borderColor, textLight, textMuted, accentGreen),
                          _field('দাওয়াতি উপকরণ বিতরণ (লিফলেট/বই)', 'পরিমাণ সংখ্যা', _dawahMaterialsCtrl, inputFill, borderColor, textLight, textMuted, accentGreen, numeric: true),
                          const SizedBox(height: 16),

                          // ৪. সাংগঠনিক কাজ
                          _sectionHeader('৪. সাংগঠনিক কাজ (Organization)', accentGreen),
                          _field('সভায় যোগদান (সভার নাম)', 'যে সভায় অংশ নিয়েছেন', _meetingNameCtrl, inputFill, borderColor, textLight, textMuted, accentGreen),
                          _field('সাংগঠনিক কাজে সময়দান (ঘণ্টা)', 'সময় ঘণ্টা', _orgTimeCtrl, inputFill, borderColor, textLight, textMuted, accentGreen, numeric: true),
                          _field('কর্মী যোগাযোগ (সংখ্যা)', 'কতজন কর্মীর সাথে যোগাযোগ', _memberContactCountCtrl, inputFill, borderColor, textLight, textMuted, accentGreen, numeric: true),
                          _field('যোগাযোগকৃত কর্মীর নাম', 'নাম লিখুন (কমা দিয়ে আলাদা করুন)', _memberContactNameCtrl, inputFill, borderColor, textLight, textMuted, accentGreen),
                          const SizedBox(height: 16),

                          // ৫. বিবিধ
                          _sectionHeader('৫. বিবিধ (Miscellaneous)', accentGreen),
                          _field('দৈনিক পত্রিকা পাঠ (সময় - মিনিট)', 'মিনিট', _newspaperTimeCtrl, inputFill, borderColor, textLight, textMuted, accentGreen, numeric: true),
                          _field('শরীরচর্চা/কারিগরি শিক্ষা (সময় - মিনিট)', 'মিনিট', _physicalExerciseTimeCtrl, inputFill, borderColor, textLight, textMuted, accentGreen, numeric: true),
                          _field('পারিবারিক/সামাজিক খেদমত (সময় - মিনিট)', 'মিনিট', _familyWelfareTimeCtrl, inputFill, borderColor, textLight, textMuted, accentGreen, numeric: true),
                          const SizedBox(height: 28),

                          if (!_isLocked)
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: _isSaving ? null : _save,
                                icon: _isSaving
                                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Icon(Icons.save, color: Colors.white),
                                label: Text(
                                  _isSaving ? 'সংরক্ষণ হচ্ছে...' : 'রিপোর্ট সংরক্ষণ করুন',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentGreen,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 2,
                                ),
                              ),
                            ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionHeader(String title, Color accentGreen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(color: accentGreen, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF34D399), fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _switchField(String label, Color textLight, Color textMuted, Color accentGreen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: textMuted, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          Switch(
            value: _selfAnalysisVal,
            onChanged: _isLocked
                ? null
                : (val) {
                    setState(() => _selfAnalysisVal = val);
                  },
            activeColor: accentGreen,
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    String hint,
    TextEditingController ctrl,
    Color inputFill,
    Color borderColor,
    Color textLight,
    Color textMuted,
    Color accentGreen, {
    bool numeric = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textMuted,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            keyboardType: numeric ? TextInputType.number : TextInputType.text,
            maxLines: maxLines,
            enabled: !_isLocked,
            style: TextStyle(color: textLight, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF4A5568), fontSize: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: accentGreen, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor.withValues(alpha: 0.5)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              filled: true,
              fillColor: inputFill,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyBgPainter extends CustomPainter {
  final bool isDark;
  _DailyBgPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isDark) {
      final grid = Paint()..color = Colors.grey.withValues(alpha: 0.05)..strokeWidth = 0.5..style = PaintingStyle.stroke;
      for (double x = 0; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
      for (double y = 0; y < size.height; y += 40) canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
      return;
    }

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
