import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/models/daily_personal_entry.dart';
import '../../data/models/monthly_comment.dart';
import '../../data/services/report_storage_service.dart';
import 'daily_entry_screen.dart';

/// মাসিক রিপোর্ট স্ক্রিন — কাগজের ফরম অনুযায়ী কলামসমূহ
class PersonalReportScreen extends StatefulWidget {
  final int year;
  final int month;

  const PersonalReportScreen({super.key, required this.year, required this.month});

  @override
  State<PersonalReportScreen> createState() => _PersonalReportScreenState();
}

class _PersonalReportScreenState extends State<PersonalReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, DailyPersonalEntry> _entries = {};
  List<MonthlyComment> _comments = [];

  // Linked scroll controllers for sticky row/column layout
  late ScrollController _dateVerController;
  late ScrollController _dataVerController;
  late ScrollController _headerHorController;
  late ScrollController _dataHorController;
  late ScrollController _footerHorController;

  bool _isSyncingVer = false;
  bool _isSyncingHor = false;

  // Comment form
  final _commentCtrl = TextEditingController();
  final _signatureCtrl = TextEditingController();

  static const _darkBg = Color(0xFF0D1B2A);
  static const _cardBg = Color(0xFF162032);
  static const _borderColor = Color(0xFF2A3F58);
  static const _accentGreen = Color(0xFF10B981);
  static const _headerBg = Color(0xFF1A2E44);
  static const _textLight = Color(0xFFE2E8F0);
  static const _textMuted = Color(0xFF94A3B8);
  static const _missingRed = Color(0xFF7F1D1D);

  // Column widths & heights matching the printed form format
  static const double _dateColW = 38.0;
  static const double _cellW = 110.0;
  static const double _cellH = 38.0;
  static const double _headerH = 50.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _dateVerController = ScrollController();
    _dataVerController = ScrollController();
    _headerHorController = ScrollController();
    _dataHorController = ScrollController();
    _footerHorController = ScrollController();

    // Link vertical scroll controllers
    _dateVerController.addListener(() {
      if (!_isSyncingVer && _dataVerController.hasClients) {
        _isSyncingVer = true;
        _dataVerController.jumpTo(_dateVerController.offset);
        _isSyncingVer = false;
      }
    });

    _dataVerController.addListener(() {
      if (!_isSyncingVer && _dateVerController.hasClients) {
        _isSyncingVer = true;
        _dateVerController.jumpTo(_dataVerController.offset);
        _isSyncingVer = false;
      }
    });

    // Link horizontal scroll controllers
    _headerHorController.addListener(() {
      if (!_isSyncingHor) {
        _isSyncingHor = true;
        if (_dataHorController.hasClients) _dataHorController.jumpTo(_headerHorController.offset);
        if (_footerHorController.hasClients) _footerHorController.jumpTo(_headerHorController.offset);
        _isSyncingHor = false;
      }
    });

    _dataHorController.addListener(() {
      if (!_isSyncingHor) {
        _isSyncingHor = true;
        if (_headerHorController.hasClients) _headerHorController.jumpTo(_dataHorController.offset);
        if (_footerHorController.hasClients) _footerHorController.jumpTo(_headerHorController.offset);
        _isSyncingHor = false;
      }
    });

    _footerHorController.addListener(() {
      if (!_isSyncingHor) {
        _isSyncingHor = true;
        if (_headerHorController.hasClients) _headerHorController.jumpTo(_footerHorController.offset);
        if (_dataHorController.hasClients) _dataHorController.jumpTo(_footerHorController.offset);
        _isSyncingHor = false;
      }
    });

    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dateVerController.dispose();
    _dataVerController.dispose();
    _headerHorController.dispose();
    _dataHorController.dispose();
    _footerHorController.dispose();
    _commentCtrl.dispose();
    _signatureCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final all = await ReportStorageService.getAllPersonalEntries();
      final filtered = <String, DailyPersonalEntry>{};
      for (final e in all.entries) {
        try {
          final d = DateTime.parse(e.key);
          if (d.year == widget.year && d.month == widget.month) {
            filtered[e.key] = e.value;
          }
        } catch (_) {}
      }
      final comments = await ReportStorageService.getCommentsForMonth(widget.year, widget.month);
      if (mounted) {
        setState(() {
          _entries = filtered;
          _comments = comments;
        });
      }
    } catch (_) {}
  }

  int get _daysInMonth => DateTime(widget.year, widget.month + 1, 0).day;

  String get _monthKey =>
      '${widget.year}-${widget.month.toString().padLeft(2, '0')}';

  String _dayKey(int day) =>
      '${widget.year}-${widget.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
  ];

  static const _weekdayNames = [
    'সোমবার', 'মঙ্গলবার', 'বুধবার', 'বৃহস্পতিবার', 'শুক্রবার', 'শনিবার', 'রবিবার',
  ];

  Future<void> _openEntry(int day) async {
    final date = DateTime(widget.year, widget.month, day);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DailyEntryScreen(date: date)),
    );
    if (result == true) _loadData();
  }

  Future<void> _saveComment() async {
    final txt = _commentCtrl.text.trim();
    final sig = _signatureCtrl.text.trim();
    if (txt.isEmpty) return;

    final comment = MonthlyComment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      yearMonth: _monthKey,
      comment: txt,
      signature: sig,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    await ReportStorageService.saveComment(comment);
    _commentCtrl.clear();
    _signatureCtrl.clear();
    await _loadData();
  }

  Future<void> _deleteComment(String id) async {
    await ReportStorageService.deleteComment(id);
    await _loadData();
  }

  // ৯টি মূল কলাম কাগজের ফরম অনুযায়ী
  List<_ColGroup> _getColGroups() {
    return [
      _ColGroup('কোরআন অধ্যয়ন\nসুরা, আয়াত', (DailyPersonalEntry e) {
        if (e.quranStudy.isNotEmpty) return e.quranStudy;
        if (e.quranSura.isNotEmpty || e.quranAyah.isNotEmpty) {
          return '${e.quranSura} (${e.quranAyah})';
        }
        return '';
      }),
      _ColGroup('হাদীস অধ্যয়ন\nসংখ্যা, বিষয়', (DailyPersonalEntry e) => e.hadithStudy),
      _ColGroup('ইসলামী সাহিত্য পাঠ\nনাম, পৃষ্ঠা', (DailyPersonalEntry e) {
        if (e.islamicLiterature.isNotEmpty) return e.islamicLiterature;
        return e.otherLiterature;
      }),
      _ColGroup('জামায়াতে নামাজ\nকত ওয়াক্ত', (DailyPersonalEntry e) => e.jamaatPrayer),
      _ColGroup('যোগাযোগ\nসংখ্যা, নাম', (DailyPersonalEntry e) {
        if (e.contact.isNotEmpty) return e.contact;
        if (e.contactName.isNotEmpty || e.contactCount.isNotEmpty) {
          return '${e.contactName} (${e.contactCount})';
        }
        return '';
      }),
      _ColGroup('দাওয়াত কত জন\nনাম', (DailyPersonalEntry e) => e.dawah),
      _ColGroup('সময় দান\nকত ঘণ্টা', (DailyPersonalEntry e) {
        if (e.timeService.isNotEmpty) return e.timeService;
        return e.volunteering;
      }),
      _ColGroup('সমাজ সেবা\nকি ধরনের', (DailyPersonalEntry e) => e.socialService),
      _ColGroup('আত্ম-সমালোচনা\nহ্যাঁ/না', (DailyPersonalEntry e) => e.remarks),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      appBar: AppBar(
        backgroundColor: _cardBg,
        iconTheme: const IconThemeData(color: _textLight),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _textLight, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: TabBar(
          controller: _tabController,
          indicatorColor: _accentGreen,
          indicatorWeight: 2.5,
          labelColor: _accentGreen,
          unselectedLabelColor: _textMuted,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          tabs: const [
            Tab(text: 'রিপোর্ট'),
            Tab(text: 'মন্তব্য'),
          ],
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _PersonalBgPainter())),
          TabBarView(
            controller: _tabController,
            children: [
              _buildReportTab(),
              _buildCommentsTab(),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================
  // ট্যাব ১: রিপোর্ট টেবিল (Sticky Header/Footer Layout)
  // ===========================
  Widget _buildReportTab() {
    final groups = _getColGroups();
    final double totalWidth = groups.length * _cellW;

    return Column(
      children: [
        // ১. স্টিকি হেডার রো (Corner Cell + Horizontal Header Data Columns)
        Row(
          children: [
            // কর্নারের ফাঁকা ঘরে বর্তমান মাস ও বছরটি উলম্বভাবে (rotated)
            Container(
              width: _dateColW,
              height: _headerH,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _headerBg,
                border: Border.all(color: _borderColor, width: 0.5),
              ),
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  '${_monthNames[widget.month - 1]} ${_bn(widget.year)}',
                  style: const TextStyle(
                    color: _accentGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            // স্ক্রোলযোগ্য হেডারসমূহ (কোরআন অধ্যয়ন, হাদীস অধ্যয়ন ইত্যাদি)
            Expanded(
              child: SingleChildScrollView(
                controller: _headerHorController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: totalWidth,
                  child: Row(
                    children: groups.map((g) {
                      return Container(
                        width: _cellW,
                        height: _headerH,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _headerBg,
                          border: Border.all(color: _borderColor, width: 0.5),
                        ),
                        child: Text(
                          g.title,
                          style: const TextStyle(
                            color: _textLight,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),

        // ২. স্ক্রোলযোগ্য বডি (বামপাশে তারিখ কলাম ও ডানপাশে ডাটা রো)
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // তারিখের রো (বামপাশে ফিক্সড)
              SizedBox(
                width: _dateColW,
                child: ListView.builder(
                  controller: _dateVerController,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _daysInMonth,
                  itemBuilder: (context, i) {
                    final day = i + 1;
                    final key = _dayKey(day);
                    final entry = _entries[key];
                    final isToday = widget.year == DateTime.now().year &&
                        widget.month == DateTime.now().month &&
                        day == DateTime.now().day;
                    final isMissing = !DateTime(widget.year, widget.month, day).isAfter(DateTime.now()) &&
                        (entry == null || entry.isEmpty);

                    return GestureDetector(
                      onTap: () => _openEntry(day),
                      child: Container(
                        width: _dateColW,
                        height: _cellH,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isToday
                              ? _accentGreen.withValues(alpha: 0.2)
                              : isMissing
                                  ? _missingRed.withValues(alpha: 0.15)
                                  : (i % 2 == 0 ? _darkBg : _cardBg),
                          border: Border.all(color: _borderColor, width: 0.5),
                        ),
                        child: Text(
                          _bn(day),
                          style: TextStyle(
                            color: isToday ? _accentGreen : isMissing ? Colors.red.shade300 : _textLight,
                            fontSize: 13,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ডাটা রো (ডানপাশে স্ক্রোলযোগ্য)
              Expanded(
                child: SingleChildScrollView(
                  controller: _dataHorController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: totalWidth,
                    child: ListView.builder(
                      controller: _dataVerController,
                      physics: const ClampingScrollPhysics(),
                      itemCount: _daysInMonth,
                      itemBuilder: (context, i) {
                        final day = i + 1;
                        final key = _dayKey(day);
                        final entry = _entries[key];
                        final isToday = widget.year == DateTime.now().year &&
                            widget.month == DateTime.now().month &&
                            day == DateTime.now().day;
                        final isMissing = !DateTime(widget.year, widget.month, day).isAfter(DateTime.now()) &&
                            (entry == null || entry.isEmpty);

                        return GestureDetector(
                          onTap: () => _openEntry(day),
                          child: Row(
                            children: groups.map((g) {
                              final value = entry != null ? g.extractor(entry) : '';
                              return Container(
                                width: _cellW,
                                height: _cellH,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? _accentGreen.withValues(alpha: 0.08)
                                      : isMissing
                                          ? _missingRed.withValues(alpha: 0.1)
                                          : (i % 2 == 0 ? _darkBg : _cardBg),
                                  border: Border.all(color: _borderColor, width: 0.5),
                                ),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: isMissing ? Colors.red.shade300 : _textLight,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ৩. স্টিকি ফুটার রো (বামপাশে "মোট" লেবেল + ডানপাশে ফুটার রো)
        Row(
          children: [
            // বামপাশে "মোট" লেবেল
            Container(
              width: _dateColW,
              height: _cellH,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _headerBg,
                border: Border.all(color: _borderColor, width: 0.5),
              ),
              child: const Text(
                'মোট',
                style: TextStyle(color: _accentGreen, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            // ডানপাশে ফুটার রো
            Expanded(
              child: SingleChildScrollView(
                controller: _footerHorController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: totalWidth,
                  child: Row(
                    children: groups.map((_) => Container(
                      width: _cellW,
                      height: _cellH,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _headerBg,
                        border: Border.all(color: _borderColor, width: 0.5),
                      ),
                      child: const Text('', style: TextStyle(color: _textLight, fontSize: 12)),
                    )).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================
  // ট্যাব ২: মন্তব্য
  // ===========================
  Widget _buildCommentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'মন্তব্য',
                  style: TextStyle(color: _textMuted, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                _buildCommentField(_commentCtrl, maxLines: 3, hint: 'আপনার মন্তব্য লিখুন...'),
                const SizedBox(height: 14),
                const Text(
                  'সাক্ষর',
                  style: TextStyle(color: _textMuted, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                _buildCommentField(_signatureCtrl, hint: 'আপনার নাম/স্বাক্ষর লিখুন...'),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _commentCtrl.clear();
                        _signatureCtrl.clear();
                      },
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _saveComment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      ),
                      child: const Text('Update',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Comments list
          if (_comments.isNotEmpty) ...[
            const Text('মন্তব্য সমূহ পড়ুন',
                style: TextStyle(color: _textLight, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            ..._comments.map((c) => _buildCommentBubble(c)),
          ] else
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  'এখনো কোনো মন্তব্য নেই',
                  style: TextStyle(color: _textMuted, fontSize: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentField(TextEditingController ctrl, {int maxLines = 1, String hint = ''}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: const TextStyle(color: _textLight, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF4A5568), fontSize: 13),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _accentGreen, width: 1.5),
        ),
        filled: true,
        fillColor: const Color(0xFF0A1628),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        isDense: true,
      ),
    );
  }

  Widget _buildCommentBubble(MonthlyComment c) {
    final dt = c.dateTime;
    final weekday = _weekdayNames[dt.weekday - 1];
    final dateStr = '$weekday, ${_bn(dt.day)} ${_monthNames[dt.month - 1]} ${_bn(dt.year)}';

    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: _cardBg,
            title: const Text('মন্তব্য মুছবেন?', style: TextStyle(color: _textLight)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('না')),
              TextButton(
                onPressed: () { Navigator.pop(context); _deleteComment(c.id); },
                child: const Text('হ্যাঁ, মুছুন', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2D3D),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${c.signature}: ${c.comment}',
              style: const TextStyle(color: _textLight, fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 6),
            Text(dateStr, style: const TextStyle(color: _accentGreen, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

/// Column configuration
class _ColGroup {
  final String title;
  final String Function(DailyPersonalEntry) extractor;

  _ColGroup(this.title, this.extractor);
}

class _PersonalBgPainter extends CustomPainter {
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
  bool shouldRepaint(_PersonalBgPainter _) => false;
}
