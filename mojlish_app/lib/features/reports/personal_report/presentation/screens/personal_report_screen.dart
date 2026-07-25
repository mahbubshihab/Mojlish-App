import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/models/daily_personal_entry.dart';
import '../../data/models/monthly_comment.dart';
import '../../data/models/monthly_plan.dart';
import '../../../shared/data/services/report_storage_service.dart';
import 'daily_entry_screen.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import '../../../shared/data/services/pdf_generator_service.dart';

/// মাসিক রিপোর্ট স্ক্রিন — কাগজের ফরম অনুযায়ী কলামসমূহ এবং পরিকল্পনা ও মন্তব্য
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

  // Monthly Plan controllers
  final _quranAyahCountCtrl = TextEditingController();
  final _quranSuraParaCtrl = TextEditingController();
  final _quranDarsCountCtrl = TextEditingController();
  final _quranDarsTopicCtrl = TextEditingController();
  final _quranMemorizeAyahCtrl = TextEditingController();

  final _hadithCountCtrl = TextEditingController();
  final _hadithTopicCtrl = TextEditingController();
  final _hadithDarsCountCtrl = TextEditingController();
  final _hadithDarsTopicCtrl = TextEditingController();
  final _hadithMemorizeCountCtrl = TextEditingController();
  final _hadithMemorizeTopicCtrl = TextEditingController();

  final _litPagesCtrl = TextEditingController();
  final _litBookCtrl = TextEditingController();
  final _litNotesCtrl = TextEditingController();

  final _academicHoursCtrl = TextEditingController();

  final _jamaatPrayerWaqtCtrl = TextEditingController();
  final _selfAnalysisDaysCtrl = TextEditingController();
  final _naflPrayerCtrl = TextEditingController();

  final _friendTargetCountCtrl = TextEditingController();
  final _friendTargetNamesCtrl = TextEditingController();
  final _primaryMemberTargetCountCtrl = TextEditingController();
  final _primaryMemberTargetNamesCtrl = TextEditingController();
  final _dawahBookletCountCtrl = TextEditingController();
  final _studentReviewCountCtrl = TextEditingController();
  final _supporterTargetCountCtrl = TextEditingController();
  final _supporterTargetNamesCtrl = TextEditingController();
  final _giftSmsCountCtrl = TextEditingController();
  final _groupDawahCountCtrl = TextEditingController();
  final _otherDawahMaterialsCtrl = TextEditingController();

  final _upgradeWorkerCountCtrl = TextEditingController();
  final _upgradeWorkerNamesCtrl = TextEditingController();
  final _meetingsCountCtrl = TextEditingController();
  final _orgHoursCtrl = TextEditingController();
  final _baytulmalAmountCtrl = TextEditingController();
  final _workerContactsCountCtrl = TextEditingController();
  final _workerContactsNamesCtrl = TextEditingController();

  final _newspaperMinutesCtrl = TextEditingController();
  final _physicalExerciseDaysCtrl = TextEditingController();
  final _technicalSkillHoursCtrl = TextEditingController();
  final _familyTimeHoursCtrl = TextEditingController();
  final _otherNotesCtrl = TextEditingController();

  final _memberUpgradeTargetCountCtrl = TextEditingController();
  final _memberUpgradeTargetNamesCtrl = TextEditingController();
  final _associateUpgradeTargetCountCtrl = TextEditingController();
  final _associateUpgradeTargetNamesCtrl = TextEditingController();

  bool get _isDark => themeManager.isDarkMode;
  Color get _darkBg => _isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
  Color get _cardBg => _isDark ? const Color(0xFF162032) : Colors.white;
  Color get _borderColor => _isDark ? const Color(0xFF2A3F58) : const Color(0xFFCBD5E1);
  Color get _accentGreen => const Color(0xFF10B981);
  Color get _headerBg => _isDark ? const Color(0xFF1A2E44) : const Color(0xFFE2E8F0);
  Color get _textLight => _isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
  Color get _textMuted => _isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color get _missingRed => _isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);

  // Column widths & heights matching the printed form format
  static const double _dateColW = 38.0;
  static const double _cellW = 110.0;
  static const double _cellH = 38.0;
  static const double _headerH = 50.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

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

    // Dispose planning controllers
    for (final ctrl in [
      _quranAyahCountCtrl,
      _quranSuraParaCtrl,
      _quranDarsCountCtrl,
      _quranDarsTopicCtrl,
      _quranMemorizeAyahCtrl,
      _hadithCountCtrl,
      _hadithTopicCtrl,
      _hadithDarsCountCtrl,
      _hadithDarsTopicCtrl,
      _hadithMemorizeCountCtrl,
      _hadithMemorizeTopicCtrl,
      _litPagesCtrl,
      _litBookCtrl,
      _litNotesCtrl,
      _academicHoursCtrl,
      _jamaatPrayerWaqtCtrl,
      _selfAnalysisDaysCtrl,
      _naflPrayerCtrl,
      _friendTargetCountCtrl,
      _friendTargetNamesCtrl,
      _primaryMemberTargetCountCtrl,
      _primaryMemberTargetNamesCtrl,
      _dawahBookletCountCtrl,
      _studentReviewCountCtrl,
      _supporterTargetCountCtrl,
      _supporterTargetNamesCtrl,
      _giftSmsCountCtrl,
      _groupDawahCountCtrl,
      _otherDawahMaterialsCtrl,
      _upgradeWorkerCountCtrl,
      _upgradeWorkerNamesCtrl,
      _meetingsCountCtrl,
      _orgHoursCtrl,
      _baytulmalAmountCtrl,
      _workerContactsCountCtrl,
      _workerContactsNamesCtrl,
      _newspaperMinutesCtrl,
      _physicalExerciseDaysCtrl,
      _technicalSkillHoursCtrl,
      _familyTimeHoursCtrl,
      _otherNotesCtrl,
      _memberUpgradeTargetCountCtrl,
      _memberUpgradeTargetNamesCtrl,
      _associateUpgradeTargetCountCtrl,
      _associateUpgradeTargetNamesCtrl,
    ]) {
      ctrl.dispose();
    }
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
      final plan = await ReportStorageService.getMonthlyPlan(widget.year, widget.month);

      if (mounted) {
        setState(() {
          _entries = filtered;
          _comments = comments;

          // Populate planning values
          if (plan != null) {
            _quranAyahCountCtrl.text = plan.quranAyahCount;
            _quranSuraParaCtrl.text = plan.quranSuraPara;
            _quranDarsCountCtrl.text = plan.quranDarsCount;
            _quranDarsTopicCtrl.text = plan.quranDarsTopic;
            _quranMemorizeAyahCtrl.text = plan.quranMemorizeAyah;
            _hadithCountCtrl.text = plan.hadithCount;
            _hadithTopicCtrl.text = plan.hadithTopic;
            _hadithDarsCountCtrl.text = plan.hadithDarsCount;
            _hadithDarsTopicCtrl.text = plan.hadithDarsTopic;
            _hadithMemorizeCountCtrl.text = plan.hadithMemorizeCount;
            _hadithMemorizeTopicCtrl.text = plan.hadithMemorizeTopic;
            _litPagesCtrl.text = plan.litPages;
            _litBookCtrl.text = plan.litBook;
            _litNotesCtrl.text = plan.litNotes;
            _academicHoursCtrl.text = plan.academicHours;
            _jamaatPrayerWaqtCtrl.text = plan.jamaatPrayerWaqt;
            _selfAnalysisDaysCtrl.text = plan.selfAnalysisDays;
            _naflPrayerCtrl.text = plan.naflPrayer;
            _friendTargetCountCtrl.text = plan.friendTargetCount;
            _friendTargetNamesCtrl.text = plan.friendTargetNames;
            _primaryMemberTargetCountCtrl.text = plan.primaryMemberTargetCount;
            _primaryMemberTargetNamesCtrl.text = plan.primaryMemberTargetNames;
            _dawahBookletCountCtrl.text = plan.dawahBookletCount;
            _studentReviewCountCtrl.text = plan.studentReviewCount;
            _supporterTargetCountCtrl.text = plan.supporterTargetCount;
            _supporterTargetNamesCtrl.text = plan.supporterTargetNames;
            _giftSmsCountCtrl.text = plan.giftSmsCount;
            _groupDawahCountCtrl.text = plan.groupDawahCount;
            _otherDawahMaterialsCtrl.text = plan.otherDawahMaterials;
            _upgradeWorkerCountCtrl.text = plan.upgradeWorkerCount;
            _upgradeWorkerNamesCtrl.text = plan.upgradeWorkerNames;
            _meetingsCountCtrl.text = plan.meetingsCount;
            _orgHoursCtrl.text = plan.orgHours;
            _baytulmalAmountCtrl.text = plan.baytulmalAmount;
            _workerContactsCountCtrl.text = plan.workerContactsCount;
            _workerContactsNamesCtrl.text = plan.workerContactsNames;
            _newspaperMinutesCtrl.text = plan.newspaperMinutes;
            _physicalExerciseDaysCtrl.text = plan.physicalExerciseDays;
            _technicalSkillHoursCtrl.text = plan.technicalSkillHours;
            _familyTimeHoursCtrl.text = plan.familyTimeHours;
            _otherNotesCtrl.text = plan.otherNotes;
            _memberUpgradeTargetCountCtrl.text = plan.memberUpgradeTargetCount;
            _memberUpgradeTargetNamesCtrl.text = plan.memberUpgradeTargetNames;
            _associateUpgradeTargetCountCtrl.text = plan.associateUpgradeTargetCount;
            _associateUpgradeTargetNamesCtrl.text = plan.associateUpgradeTargetNames;
          }
        });
      }
    } catch (_) {}
  }

  Future<void> _savePlan() async {
    final plan = MonthlyPlan(
      year: widget.year,
      month: widget.month,
      quranAyahCount: _quranAyahCountCtrl.text.trim(),
      quranSuraPara: _quranSuraParaCtrl.text.trim(),
      quranDarsCount: _quranDarsCountCtrl.text.trim(),
      quranDarsTopic: _quranDarsTopicCtrl.text.trim(),
      quranMemorizeAyah: _quranMemorizeAyahCtrl.text.trim(),
      hadithCount: _hadithCountCtrl.text.trim(),
      hadithTopic: _hadithTopicCtrl.text.trim(),
      hadithDarsCount: _hadithDarsCountCtrl.text.trim(),
      hadithDarsTopic: _hadithDarsTopicCtrl.text.trim(),
      hadithMemorizeCount: _hadithMemorizeCountCtrl.text.trim(),
      hadithMemorizeTopic: _hadithMemorizeTopicCtrl.text.trim(),
      litPages: _litPagesCtrl.text.trim(),
      litBook: _litBookCtrl.text.trim(),
      litNotes: _litNotesCtrl.text.trim(),
      academicHours: _academicHoursCtrl.text.trim(),
      jamaatPrayerWaqt: _jamaatPrayerWaqtCtrl.text.trim(),
      selfAnalysisDays: _selfAnalysisDaysCtrl.text.trim(),
      naflPrayer: _naflPrayerCtrl.text.trim(),
      friendTargetCount: _friendTargetCountCtrl.text.trim(),
      friendTargetNames: _friendTargetNamesCtrl.text.trim(),
      primaryMemberTargetCount: _primaryMemberTargetCountCtrl.text.trim(),
      primaryMemberTargetNames: _primaryMemberTargetNamesCtrl.text.trim(),
      dawahBookletCount: _dawahBookletCountCtrl.text.trim(),
      studentReviewCount: _studentReviewCountCtrl.text.trim(),
      supporterTargetCount: _supporterTargetCountCtrl.text.trim(),
      supporterTargetNames: _supporterTargetNamesCtrl.text.trim(),
      giftSmsCount: _giftSmsCountCtrl.text.trim(),
      groupDawahCount: _groupDawahCountCtrl.text.trim(),
      otherDawahMaterials: _otherDawahMaterialsCtrl.text.trim(),
      upgradeWorkerCount: _upgradeWorkerCountCtrl.text.trim(),
      upgradeWorkerNames: _upgradeWorkerNamesCtrl.text.trim(),
      meetingsCount: _meetingsCountCtrl.text.trim(),
      orgHours: _orgHoursCtrl.text.trim(),
      baytulmalAmount: _baytulmalAmountCtrl.text.trim(),
      workerContactsCount: _workerContactsCountCtrl.text.trim(),
      workerContactsNames: _workerContactsNamesCtrl.text.trim(),
      newspaperMinutes: _newspaperMinutesCtrl.text.trim(),
      physicalExerciseDays: _physicalExerciseDaysCtrl.text.trim(),
      technicalSkillHours: _technicalSkillHoursCtrl.text.trim(),
      familyTimeHours: _familyTimeHoursCtrl.text.trim(),
      otherNotes: _otherNotesCtrl.text.trim(),
      memberUpgradeTargetCount: _memberUpgradeTargetCountCtrl.text.trim(),
      memberUpgradeTargetNames: _memberUpgradeTargetNamesCtrl.text.trim(),
      associateUpgradeTargetCount: _associateUpgradeTargetCountCtrl.text.trim(),
      associateUpgradeTargetNames: _associateUpgradeTargetNamesCtrl.text.trim(),
    );
    await ReportStorageService.saveMonthlyPlan(plan);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('মাসিক পরিকল্পনা সংরক্ষণ করা হয়েছে ✓', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
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

  String _bnDouble(double n) {
    if (n == 0) return '০';
    final str = n.toStringAsFixed(1);
    if (str.endsWith('.0')) {
      return _bn(n.toInt());
    }
    return str.split('').map((c) {
      if (c == '.') return '.';
      const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
      return digits[int.parse(c)];
    }).join();
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

  // কলামসমূহ কাগজের ফরমের ৩১-দিন গ্রিড অনুযায়ী
  List<_ColGroup> _getColGroups() {
    return [
      _ColGroup('কুরআন অধ্যয়ন\nসূরা (আয়াত)', (DailyPersonalEntry e) {
        if (e.quranSura.isNotEmpty || e.quranAyah.isNotEmpty) {
          return '${e.quranSura} (${e.quranAyah})';
        }
        return e.quranStudy;
      }),
      _ColGroup('হাদীস অধ্যয়ন\nসংখ্যা (বিষয়)', (DailyPersonalEntry e) {
        if (e.hadithCount.isNotEmpty || e.hadithTopic.isNotEmpty) {
          return '${e.hadithCount} (${e.hadithTopic})';
        }
        return e.hadithStudy;
      }),
      _ColGroup('ইসলামী সাহিত্য\nপৃষ্ঠা (বই)', (DailyPersonalEntry e) {
        if (e.islamicLitPages.isNotEmpty || e.islamicLitBook.isNotEmpty) {
          return '${e.islamicLitPages} (${e.islamicLitBook})';
        }
        return e.islamicLiterature;
      }),
      _ColGroup('পাঠ্যপুস্তক\nসময় (ঘণ্টা)', (DailyPersonalEntry e) {
        return e.textbookHours.isNotEmpty ? e.textbookHours : e.textbookStudy;
      }),
      _ColGroup('জামাআতে নামায\nওয়াক্ত', (DailyPersonalEntry e) => e.jamaatPrayer),
      _ColGroup('আত্মবিচার\nহ্যাঁ/না', (DailyPersonalEntry e) => e.selfAnalysis),
      _ColGroup('দাওয়াতি যোগাযোগ\nসংখ্যা (নাম)', (DailyPersonalEntry e) {
        if (e.contactCount.isNotEmpty || e.contactName.isNotEmpty) {
          return '${e.contactCount} (${e.contactName})';
        }
        return e.contact;
      }),
      _ColGroup('উপকরণ বিতরণ\nপরিমাণ', (DailyPersonalEntry e) {
        return e.dawahMaterials.isNotEmpty ? e.dawahMaterials : e.dawah;
      }),
      _ColGroup('সভায় যোগদান\nসভার নাম', (DailyPersonalEntry e) => e.meetingName),
      _ColGroup('সাংগঠনিক সময়\nঘণ্টা', (DailyPersonalEntry e) {
        return e.orgTime.isNotEmpty ? e.orgTime : e.timeService;
      }),
      _ColGroup('কর্মী যোগাযোগ\nসংখ্যা (নাম)', (DailyPersonalEntry e) {
        if (e.memberContactCount.isNotEmpty || e.memberContactName.isNotEmpty) {
          return '${e.memberContactCount} (${e.memberContactName})';
        }
        return '';
      }),
      _ColGroup('বিবিধ\nপত্রিকা/শরীরচর্চা/খেদমত', (DailyPersonalEntry e) {
        final list = <String>[];
        if (e.newspaperTime.isNotEmpty) list.add('প:${e.newspaperTime}মি');
        if (e.physicalExerciseTime.isNotEmpty) list.add('শ:${e.physicalExerciseTime}মি');
        if (e.familyWelfareTime.isNotEmpty) list.add('খ:${e.familyWelfareTime}মি');
        return list.join(', ');
      }),
    ];
  }

  // মাসিক এগ্রিগেশন বা সামারি হিসাব (মোট রো-এর জন্য)
  String _calculateTotalForGroup(int index) {
    int sumInt = 0;
    double sumDouble = 0.0;
    bool isDouble = false;
    bool hasValue = false;

    for (final entry in _entries.values) {
      if (entry.isEmpty) continue;
      hasValue = true;
      try {
        switch (index) {
          case 0: // কুরআন আয়াত
            sumInt += int.parse(entry.quranAyah.replaceAll(RegExp(r'[^0-9]'), ''));
            break;
          case 1: // হাদিস সংখ্যা
            sumInt += int.parse(entry.hadithCount.isEmpty ? entry.hadithStudy.replaceAll(RegExp(r'[^0-9]'), '') : entry.hadithCount.replaceAll(RegExp(r'[^0-9]'), ''));
            break;
          case 2: // সাহিত্য পৃষ্ঠা
            sumInt += int.parse(entry.islamicLitPages.isEmpty ? entry.islamicLiterature.replaceAll(RegExp(r'[^0-9]'), '') : entry.islamicLitPages.replaceAll(RegExp(r'[^0-9]'), ''));
            break;
          case 3: // পাঠ্যপুস্তক ঘণ্টা
            isDouble = true;
            sumDouble += double.parse(entry.textbookHours.isEmpty ? entry.textbookStudy.replaceAll(RegExp(r'[^0-9.]'), '') : entry.textbookHours.replaceAll(RegExp(r'[^0-9.]'), ''));
            break;
          case 4: // জামায়াত ওয়াক্ত
            sumInt += int.parse(entry.jamaatPrayer.replaceAll(RegExp(r'[^0-9]'), ''));
            break;
          case 5: // আত্মবিচার দিন
            if (entry.selfAnalysis == 'হ্যাঁ' || entry.selfAnalysis == 'yes') sumInt += 1;
            break;
          case 6: // দাওয়াত যোগাযোগ
            sumInt += int.parse(entry.contactCount.replaceAll(RegExp(r'[^0-9]'), ''));
            break;
          case 7: // উপকরণ বিতরণ
            sumInt += int.parse(entry.dawahMaterials.isEmpty ? entry.dawah.replaceAll(RegExp(r'[^0-9]'), '') : entry.dawahMaterials.replaceAll(RegExp(r'[^0-9]'), ''));
            break;
          case 9: // সাংগঠনিক সময়
            isDouble = true;
            sumDouble += double.parse(entry.orgTime.isEmpty ? entry.timeService.replaceAll(RegExp(r'[^0-9.]'), '') : entry.orgTime.replaceAll(RegExp(r'[^0-9.]'), ''));
            break;
          case 10: // কর্মী যোগাযোগ
            sumInt += int.parse(entry.memberContactCount.replaceAll(RegExp(r'[^0-9]'), ''));
            break;
        }
      } catch (_) {}
    }

    if (!hasValue) return '-';
    if (isDouble) return _bnDouble(sumDouble);
    if (index == 8 || index == 11) return '-'; // মিটিং বা বিবিধ মোট দরকার নেই
    return _bn(sumInt);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: _darkBg,
          appBar: AppBar(
            backgroundColor: _cardBg,
            iconTheme: IconThemeData(color: _textLight),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: _textLight, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            titleSpacing: 0,
            title: TabBar(
              controller: _tabController,
              indicatorColor: _accentGreen,
              indicatorWeight: 2.5,
              labelColor: _accentGreen,
              unselectedLabelColor: _textMuted,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: const [
                Tab(text: 'রিপোর্ট টেবিল'),
                Tab(text: 'রিপোর্ট সামারি'),
                Tab(text: 'মাসিক পরিকল্পনা'),
                Tab(text: 'মন্তব্য সমূহ'),
              ],
            ),
            elevation: 0,
          ),
          body: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _PersonalBgPainter(isDark: _isDark))),
              TabBarView(
                controller: _tabController,
                children: [
                  _buildReportTab(),
                  _buildSummaryTab(),
                  _buildPlanTab(),
                  _buildCommentsTab(),
                ],
              ),
            ],
          ),
        );
      },
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
        // ১. স্টিকি হেডার রো
        Row(
          children: [
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
                  style: TextStyle(
                    color: _accentGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
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
                          style: TextStyle(
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

        // ২. বডি
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

        // ৩. স্টিকি ফুটার রো (যোগফল দেখায়)
        Row(
          children: [
            Container(
              width: _dateColW,
              height: _cellH,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _headerBg,
                border: Border.all(color: _borderColor, width: 0.5),
              ),
              child: Text(
                'মোট',
                style: TextStyle(color: _accentGreen, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _footerHorController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: totalWidth,
                  child: Row(
                    children: groups.asMap().entries.map((e) {
                      final idx = e.key;
                      final totalVal = _calculateTotalForGroup(idx);
                      return Container(
                        width: _cellW,
                        height: _cellH,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _headerBg,
                          border: Border.all(color: _borderColor, width: 0.5),
                        ),
                        child: Text(
                          totalVal,
                          style: TextStyle(color: _accentGreen, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // ট্যাব ২: মাসিক পরিকল্পনা (Porikolpona Input Form)
  // ==========================================
  Widget _buildPlanTab() {
    final fill = _isDark ? const Color(0xFF0F172A) : Colors.white;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ব্যক্তিগত মাসিক পরিকল্পনা (টার্গেট)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _accentGreen),
          ),
          Text(
            '${_monthNames[widget.month - 1]} ${_bn(widget.year)} সেশনের জন্য আপনার লক্ষ্যগুলো লিখুন।',
            style: TextStyle(fontSize: 12, color: _textMuted),
          ),
          const SizedBox(height: 20),

          // ১. অধ্যয়ন টার্গেট
          _subHeader('১. অধ্যয়ন (Study Targets)'),
          _planField('কুরআন: আয়াত সংখ্যা', _quranAyahCountCtrl, fill, 'যেমন: ২০০'),
          _planField('কুরআন: সূরা/পারা নাম', _quranSuraParaCtrl, fill, 'যেমন: সূরা আল-বাকারা'),
          _planField('কুরআন দারস তৈরি (টি)', _quranDarsCountCtrl, fill, 'যেমন: ২'),
          _planField('কুরআন দারস বিষয়', _quranDarsTopicCtrl, fill, 'যেমন: চরিত্র গঠন'),
          _planField('কুরআন মুখস্থ (আয়াত)', _quranMemorizeAyahCtrl, fill, 'যেমন: ১০ আয়াত'),
          const Divider(height: 32),

          _planField('হাদিস: পঠন সংখ্যা', _hadithCountCtrl, fill, 'যেমন: ৫০'),
          _planField('হাদিস: বিষয়/গ্রন্থ', _hadithTopicCtrl, fill, 'যেমন: রিয়াদুস সালেহীন'),
          _planField('হাদিস দারস তৈরি (টি)', _hadithDarsCountCtrl, fill, 'যেমন: ১'),
          _planField('হাদিস দারস বিষয়', _hadithDarsTopicCtrl, fill, 'যেমন: তাকওয়া'),
          _planField('হাদিস মুখস্থ (টি)', _hadithMemorizeCountCtrl, fill, 'যেমন: ৫টি হাদিস'),
          const Divider(height: 32),

          _planField('দ্বীনি সাহিত্য: পৃষ্ঠা সংখ্যা', _litPagesCtrl, fill, 'যেমন: ৩০০ পৃষ্ঠা'),
          _planField('দ্বীনি সাহিত্য: বইয়ের নাম', _litBookCtrl, fill, 'যেমন: ইসলামী আন্দোলন ও সংগঠন'),
          _planField('আলোচনা/বইয়ের নোট (পৃষ্ঠা)', _litNotesCtrl, fill, 'যেমন: ৫ পৃষ্ঠা'),
          const Divider(height: 32),

          _planField('পাঠ্যপুস্তক/ক্লাস অধ্যয়ন (ঘণ্টা)', _academicHoursCtrl, fill, 'যেমন: ৮০ ঘণ্টা'),
          const SizedBox(height: 20),

          // ২. ইবাদত টার্গেট
          _subHeader('২. ইবাদত (Worship Targets)'),
          _planField('জামাআতে নামায (ওয়াক্ত)', _jamaatPrayerWaqtCtrl, fill, 'যেমন: ১৫০ ওয়াক্ত'),
          _planField('নফল ইবাদত বিবরণ', _naflPrayerCtrl, fill, 'যেমন: তাহাজ্জুদ ও ইশরাক'),
          _planField('আত্মবিচার দিন সংখ্যা', _selfAnalysisDaysCtrl, fill, 'যেমন: ৩০ দিন'),
          const SizedBox(height: 20),

          // ৩. দাওয়াতি কাজ টার্গেট
          _subHeader('৩. দাওয়াতি কাজ (Dawah Targets)'),
          _planField('বন্ধু বৃদ্ধি টার্গেট (জন)', _friendTargetCountCtrl, fill, 'যেমন: ২'),
          _planField('টার্গেট বন্ধুদের নাম', _friendTargetNamesCtrl, fill, 'যেমন: আবির, হাসান'),
          _planField('প্রাথমিক সদস্য বৃদ্ধি টার্গেট (জন)', _primaryMemberTargetCountCtrl, fill, 'যেমন: ৩'),
          _planField('টার্গেট সদস্যের নাম', _primaryMemberTargetNamesCtrl, fill, 'যেমন: তারেক, সাকিব'),
          _planField('বই/পরিচিতি/স্টিকার বিতরণ (টি)', _dawahBookletCountCtrl, fill, 'যেমন: ২০'),
          _planField('ছাত্র পরিক্রমা বিতরণ (টি)', _studentReviewCountCtrl, fill, 'যেমন: ৫'),
          _planField('শুভাকাঙ্ক্ষী যোগাযোগ (জন)', _supporterTargetCountCtrl, fill, 'যেমন: ১০'),
          _planField('টার্গেট শুভাকাঙ্ক্ষীদের নাম', _supporterTargetNamesCtrl, fill, 'যেমন: রফিক সাহেব'),
          _planField('কার্ড/উপহার/SMS বিতরণ (টি)', _giftSmsCountCtrl, fill, 'যেমন: ১৫'),
          _planField('গ্রুপ দাওয়াত (বার)', _groupDawahCountCtrl, fill, 'যেমন: ৪'),
          _planField('অন্যান্য দাওয়াতি উপকরণ', _otherDawahMaterialsCtrl, fill, 'যেমন: দাওয়াতি কার্ড'),
          const SizedBox(height: 20),

          // ৪. সাংগঠনিক কাজ টার্গেট
          _subHeader('৪. সাংগঠনিক কাজ (Organization Targets)'),
          _planField('কর্মী মানে উন্নীতকরণ (জন)', _upgradeWorkerCountCtrl, fill, 'যেমন: ১'),
          _planField('উন্নীতকরণের জন্য নির্ধারিত নাম', _upgradeWorkerNamesCtrl, fill, 'যেমন: ইমরান'),
          _planField('সভায় যোগদান (টি)', _meetingsCountCtrl, fill, 'যেমন: ৪টি সভা'),
          _planField('সাংগঠনিক সময়দান (ঘণ্টা)', _orgHoursCtrl, fill, 'যেমন: ২০ ঘণ্টা'),
          _planField('বায়তুলমাল প্রদান (টাকা)', _baytulmalAmountCtrl, fill, 'যেমন: ৫০০ টাকা'),
          _planField('কর্মী যোগাযোগ (জন)', _workerContactsCountCtrl, fill, 'যেমন: ৮'),
          _planField('যোগাযোগকৃত কর্মীদের নাম', _workerContactsNamesCtrl, fill, 'যেমন: ফাহাদ, রায়হান'),
          const SizedBox(height: 20),

          // ৫. বিবিধ
          _subHeader('৫. বিবিধ টার্গেট (Misc Targets)'),
          _planField('দৈনিক পত্রিকা পাঠ (মিনিট)', _newspaperMinutesCtrl, fill, 'যেমন: ৩০ মিনিট'),
          _planField('শরীরচর্চা (দিন)', _physicalExerciseDaysCtrl, fill, 'যেমন: ২০ দিন'),
          _planField('কারিগরি/কম্পিউটার/ভাষা শিক্ষা (ঘণ্টা)', _technicalSkillHoursCtrl, fill, 'যেমন: ১০ ঘণ্টা'),
          _planField('পারিবারিক/সামাজিক খেদমত (ঘণ্টা)', _familyTimeHoursCtrl, fill, 'যেমন: ১৫ ঘণ্টা'),
          _planField('অন্যান্য কোনো পরিকল্পনা', _otherNotesCtrl, fill, 'অন্যান্য চিন্তা বা নোট...'),
          const SizedBox(height: 20),

          // ৬. সংশ্লিষ্টদের জন্য
          _subHeader('৬. সংশ্লিষ্টদের জন্য টার্গেট (Leader\'s Upgrades)'),
          _planField('সদস্য স্তরে উন্নীতকরণ টার্গেট (জন)', _memberUpgradeTargetCountCtrl, fill, 'যেমন: ১'),
          _planField('সদস্য স্তরে উন্নীতকরণ নাম', _memberUpgradeTargetNamesCtrl, fill, 'যেমন: জামিল'),
          _planField('সহযোগী সদস্য স্তরে উন্নীতকরণ (জন)', _associateUpgradeTargetCountCtrl, fill, 'যেমন: ২'),
          _planField('সহযোগী সদস্য স্তরে উন্নীতকরণ নাম', _associateUpgradeTargetNamesCtrl, fill, 'যেমন: রাসেল, আবিদ'),
          const SizedBox(height: 35),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _savePlan,
                    icon: const Icon(Icons.save, color: Colors.white, size: 18),
                    label: const Text(
                      'পরিকল্পনা সংরক্ষণ',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      _savePlan();
                      final plan = MonthlyPlan(
                        year: widget.year,
                        month: widget.month,
                        quranAyahCount: _quranAyahCountCtrl.text.trim(),
                        quranSuraPara: _quranSuraParaCtrl.text.trim(),
                        quranDarsCount: _quranDarsCountCtrl.text.trim(),
                        quranDarsTopic: _quranDarsTopicCtrl.text.trim(),
                        quranMemorizeAyah: _quranMemorizeAyahCtrl.text.trim(),
                        hadithCount: _hadithCountCtrl.text.trim(),
                        hadithTopic: _hadithTopicCtrl.text.trim(),
                        hadithDarsCount: _hadithDarsCountCtrl.text.trim(),
                        hadithDarsTopic: _hadithDarsTopicCtrl.text.trim(),
                        hadithMemorizeCount: _hadithMemorizeCountCtrl.text.trim(),
                        hadithMemorizeTopic: _hadithMemorizeTopicCtrl.text.trim(),
                        litPages: _litPagesCtrl.text.trim(),
                        litBook: _litBookCtrl.text.trim(),
                        litNotes: _litNotesCtrl.text.trim(),
                        academicHours: _academicHoursCtrl.text.trim(),
                        jamaatPrayerWaqt: _jamaatPrayerWaqtCtrl.text.trim(),
                        selfAnalysisDays: _selfAnalysisDaysCtrl.text.trim(),
                        naflPrayer: _naflPrayerCtrl.text.trim(),
                        friendTargetCount: _friendTargetCountCtrl.text.trim(),
                        friendTargetNames: _friendTargetNamesCtrl.text.trim(),
                        primaryMemberTargetCount: _primaryMemberTargetCountCtrl.text.trim(),
                        primaryMemberTargetNames: _primaryMemberTargetNamesCtrl.text.trim(),
                        dawahBookletCount: _dawahBookletCountCtrl.text.trim(),
                        studentReviewCount: _studentReviewCountCtrl.text.trim(),
                        supporterTargetCount: _supporterTargetCountCtrl.text.trim(),
                        supporterTargetNames: _supporterTargetNamesCtrl.text.trim(),
                        giftSmsCount: _giftSmsCountCtrl.text.trim(),
                        groupDawahCount: _groupDawahCountCtrl.text.trim(),
                        otherDawahMaterials: _otherDawahMaterialsCtrl.text.trim(),
                        upgradeWorkerCount: _upgradeWorkerCountCtrl.text.trim(),
                        upgradeWorkerNames: _upgradeWorkerNamesCtrl.text.trim(),
                        meetingsCount: _meetingsCountCtrl.text.trim(),
                        orgHours: _orgHoursCtrl.text.trim(),
                        baytulmalAmount: _baytulmalAmountCtrl.text.trim(),
                        workerContactsCount: _workerContactsCountCtrl.text.trim(),
                        workerContactsNames: _workerContactsNamesCtrl.text.trim(),
                        newspaperMinutes: _newspaperMinutesCtrl.text.trim(),
                        physicalExerciseDays: _physicalExerciseDaysCtrl.text.trim(),
                        technicalSkillHours: _technicalSkillHoursCtrl.text.trim(),
                        familyTimeHours: _familyTimeHoursCtrl.text.trim(),
                        otherNotes: _otherNotesCtrl.text.trim(),
                        memberUpgradeTargetCount: _memberUpgradeTargetCountCtrl.text.trim(),
                        memberUpgradeTargetNames: _memberUpgradeTargetNamesCtrl.text.trim(),
                        associateUpgradeTargetCount: _associateUpgradeTargetCountCtrl.text.trim(),
                        associateUpgradeTargetNames: _associateUpgradeTargetNamesCtrl.text.trim(),
                      );
                      await PdfGeneratorService.generatePersonalPlanPdf(
                        plan: plan,
                        userName: 'ব্যবহারকারী',
                        branchName: 'শাখা কার্যালয়',
                        year: widget.year,
                        month: widget.month,
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.black, size: 18),
                    label: const Text(
                      'পিডিএফ ডাউনলোড',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFBBF24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    // 1. Calculate aggregates
    int quranDays = 0;
    int quranTotalAyah = 0;
    int hadithDays = 0;
    int hadithTotalCount = 0;
    int litDays = 0;
    int litTotalPages = 0;
    double academicTotalHours = 0.0;
    int jamaatTotalWaqt = 0;
    int selfAnalysisTotalDays = 0;
    int dawahTotalFriends = 0;
    int dawahTotalMaterials = 0;
    int orgMeetings = 0;
    double orgTotalHours = 0.0;
    int orgTotalWorkers = 0;
    int miscNewspaper = 0;
    int miscExercise = 0;
    int miscWelfare = 0;

    for (final entry in _entries.values) {
      if (entry.isEmpty) continue;
      
      // Quran
      if (entry.quranSura.isNotEmpty || entry.quranAyah.isNotEmpty) {
        quranDays++;
        try {
          quranTotalAyah += int.parse(entry.quranAyah.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }

      // Hadith
      final hCount = entry.hadithCount.isEmpty ? entry.hadithStudy : entry.hadithCount;
      if (hCount.isNotEmpty) {
        hadithDays++;
        try {
          hadithTotalCount += int.parse(hCount.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }

      // Lit
      final lPages = entry.islamicLitPages.isEmpty ? entry.islamicLiterature : entry.islamicLitPages;
      if (lPages.isNotEmpty) {
        litDays++;
        try {
          litTotalPages += int.parse(lPages.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }

      // Academic
      final aHours = entry.textbookHours.isEmpty ? entry.textbookStudy : entry.textbookHours;
      if (aHours.isNotEmpty) {
        try {
          academicTotalHours += double.parse(aHours.replaceAll(RegExp(r'[^0-9.]'), ''));
        } catch (_) {}
      }

      // Jamaat
      if (entry.jamaatPrayer.isNotEmpty) {
        try {
          jamaatTotalWaqt += int.parse(entry.jamaatPrayer.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }

      // Self
      if (entry.selfAnalysis == 'হ্যাঁ' || entry.selfAnalysis == 'yes') {
        selfAnalysisTotalDays++;
      }

      // Dawah friends
      if (entry.contactCount.isNotEmpty) {
        try {
          dawahTotalFriends += int.parse(entry.contactCount.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }

      // Dawah materials
      final dMat = entry.dawahMaterials.isEmpty ? entry.dawah : entry.dawahMaterials;
      if (dMat.isNotEmpty) {
        try {
          dawahTotalMaterials += int.parse(dMat.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }

      // Meetings
      if (entry.meetingName.isNotEmpty) {
        orgMeetings++;
      }

      // Org hours
      final oHours = entry.orgTime.isEmpty ? entry.timeService : entry.orgTime;
      if (oHours.isNotEmpty) {
        try {
          orgTotalHours += double.parse(oHours.replaceAll(RegExp(r'[^0-9.]'), ''));
        } catch (_) {}
      }

      // Org workers
      if (entry.memberContactCount.isNotEmpty) {
        try {
          orgTotalWorkers += int.parse(entry.memberContactCount.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }

      // Misc
      if (entry.newspaperTime.isNotEmpty) {
        try {
          miscNewspaper += int.parse(entry.newspaperTime.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }
      if (entry.physicalExerciseTime.isNotEmpty) {
        try {
          miscExercise += int.parse(entry.physicalExerciseTime.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }
      if (entry.familyWelfareTime.isNotEmpty) {
        try {
          miscWelfare += int.parse(entry.familyWelfareTime.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ব্যক্তিগত মাসিক রিপোর্ট সামারি',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _accentGreen),
          ),
          Text(
            'পরিকল্পনা (টার্গেট) বনাম অর্জিত বাস্তবায়ন রিপোর্টের তুলনামূলক চিত্র।',
            style: TextStyle(fontSize: 12, color: _textMuted),
          ),
          const SizedBox(height: 20),

          _buildSummaryCard(
            title: '১. কুরআন অধ্যয়ন',
            icon: Icons.book,
            children: [
              _buildSummaryRow('মোট পঠিত আয়াত', '${_quranAyahCountCtrl.text} টি', '$quranTotalAyah টি'),
              _buildSummaryRow('পঠিত দিন সংখ্যা', '-', '$quranDays দিন'),
              _buildSummaryRow('গড় (আয়াত/দিন)', '-', quranDays > 0 ? '${(quranTotalAyah / quranDays).toStringAsFixed(1)} টি' : '০ টি'),
              _buildSummaryRow('দারস তৈরি', '${_quranDarsCountCtrl.text} টি', '-'),
              _buildSummaryRow('দারস বিষয়', _quranDarsTopicCtrl.text, '-'),
              _buildSummaryRow('মুখস্থ আয়াত', _quranMemorizeAyahCtrl.text, '-'),
            ],
          ),

          _buildSummaryCard(
            title: '২. হাদীস অধ্যয়ন',
            icon: Icons.bookmark,
            children: [
              _buildSummaryRow('মোট পঠিত হাদীস', '${_hadithCountCtrl.text} টি', '$hadithTotalCount টি'),
              _buildSummaryRow('পঠিত দিন সংখ্যা', '-', '$hadithDays দিন'),
              _buildSummaryRow('গড় (হাদীস/দিন)', '-', hadithDays > 0 ? '${(hadithTotalCount / hadithDays).toStringAsFixed(1)} টি' : '০ টি'),
              _buildSummaryRow('দারস তৈরি', '${_hadithDarsCountCtrl.text} টি', '-'),
              _buildSummaryRow('দারস বিষয়', _hadithDarsTopicCtrl.text, '-'),
              _buildSummaryRow('মুখস্থ হাদীস', '${_hadithMemorizeCountCtrl.text} টি', '-'),
            ],
          ),

          _buildSummaryCard(
            title: '৩. দ্বীনি ও সাধারণ সাহিত্য পাঠ',
            icon: Icons.menu_book,
            children: [
              _buildSummaryRow('মোট পৃষ্ঠা পাঠ', '${_litPagesCtrl.text} পৃষ্ঠা', '$litTotalPages পৃষ্ঠা'),
              _buildSummaryRow('পঠিত দিন সংখ্যা', '-', '$litDays দিন'),
              _buildSummaryRow('গড় (পৃষ্ঠা/দিন)', '-', litDays > 0 ? '${(litTotalPages / litDays).toStringAsFixed(1)} পৃষ্ঠা' : '০ পৃষ্ঠা'),
              _buildSummaryRow('বইয়ের নাম', _litBookCtrl.text, '-'),
              _buildSummaryRow('বই/আলোচনা নোট', '${_litNotesCtrl.text} পৃষ্ঠা', '-'),
            ],
          ),

          _buildSummaryCard(
            title: '৪. পাঠ্যপুস্তক অধ্যয়ন',
            icon: Icons.school,
            children: [
              _buildSummaryRow('মোট সময় (ঘণ্টা)', '${_academicHoursCtrl.text} ঘণ্টা', '${_bnDouble(academicTotalHours)} ঘণ্টা'),
            ],
          ),

          _buildSummaryCard(
            title: '৫. সালাত ও আত্মগঠন (ইবাদত)',
            icon: Icons.self_improvement,
            children: [
              _buildSummaryRow('জামাআতে নামাজ (ওয়াক্ত)', '${_jamaatPrayerWaqtCtrl.text} ওয়াক্ত', '$jamaatTotalWaqt ওয়াক্ত'),
              _buildSummaryRow('নফল ইবাদত বিবরণ', _naflPrayerCtrl.text, '-'),
              _buildSummaryRow('আত্মবিচার আদায় (দিন)', '${_selfAnalysisDaysCtrl.text} দিন', '$selfAnalysisTotalDays দিন'),
            ],
          ),

          _buildSummaryCard(
            title: '৬. দাওয়াতি কাজ ও জনসংযোগ',
            icon: Icons.campaign,
            children: [
              _buildSummaryRow('বন্ধু যোগাযোগ (জন)', '${_friendTargetCountCtrl.text} জন', '$dawahTotalFriends জন'),
              _buildSummaryRow('প্রাথমিক সদস্য বৃদ্ধি টার্গেট', '${_primaryMemberTargetCountCtrl.text} জন', '-'),
              _buildSummaryRow('বই/পরিচিতি/স্টিকার বিতরণ', '${_dawahBookletCountCtrl.text} টি', '$dawahTotalMaterials টি'),
              _buildSummaryRow('ছাত্র পরিক্রমা বিতরণ', '${_studentReviewCountCtrl.text} টি', '-'),
              _buildSummaryRow('শুভাকাঙ্ক্ষী যোগাযোগ', '${_supporterTargetCountCtrl.text} জন', '-'),
              _buildSummaryRow('কার্ড/উপহার/SMS বিতরণ', '${_giftSmsCountCtrl.text} টি', '-'),
              _buildSummaryRow('গ্রুপ দাওয়াত', '${_groupDawahCountCtrl.text} বার', '-'),
            ],
          ),

          _buildSummaryCard(
            title: '৭. সাংগঠনিক কাজ',
            icon: Icons.corporate_fare,
            children: [
              _buildSummaryRow('কর্মী মানে উন্নীতকরণ', '${_upgradeWorkerCountCtrl.text} জন', '-'),
              _buildSummaryRow('সভায় যোগদান', '${_meetingsCountCtrl.text} টি', '$orgMeetings টি'),
              _buildSummaryRow('সাংগঠনিক সময়দান', '${_orgHoursCtrl.text} ঘণ্টা', '${_bnDouble(orgTotalHours)} ঘণ্টা'),
              _buildSummaryRow('কর্মী যোগাযোগ', '${_workerContactsCountCtrl.text} জন', '$orgTotalWorkers জন'),
              _buildSummaryRow('বায়তুলমাল টার্গেট/প্রদান', '${_baytulmalAmountCtrl.text} টাকা', '-'),
            ],
          ),

          _buildSummaryCard(
            title: '৮. বিবিধ অর্জন',
            icon: Icons.star,
            children: [
              _buildSummaryRow('দৈনিক পত্রিকা পাঠ (সময়)', '${_newspaperMinutesCtrl.text} মিনিট', '$miscNewspaper মিনিট'),
              _buildSummaryRow('শরীরচর্চা (সময়)', '${_physicalExerciseDaysCtrl.text} দিন', '$miscExercise মিনিট'),
              _buildSummaryRow('পারিবারিক/সামাজিক খেদমত', '${_familyTimeHoursCtrl.text} ঘণ্টা', '$miscWelfare মিনিট'),
              _buildSummaryRow('কারিগরি শিক্ষা সময়', '${_technicalSkillHoursCtrl.text} ঘণ্টা', '-'),
            ],
          ),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _accentGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: _textLight, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String target, String actual) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: _textMuted, fontSize: 12)),
          Row(
            children: [
              Text('পরিকল্পনা: ', style: TextStyle(color: _textMuted, fontSize: 10)),
              Text(target.isEmpty ? '-' : target, style: TextStyle(color: _textLight, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Text('অর্জিত: ', style: TextStyle(color: _textMuted, fontSize: 10)),
              Text(actual, style: TextStyle(color: _accentGreen, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _subHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 12),
      child: Row(
        children: [
          Container(width: 4, height: 16, decoration: BoxDecoration(color: _accentGreen, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF34D399)),
          ),
        ],
      ),
    );
  }

  Widget _planField(String label, TextEditingController ctrl, Color fill, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: _textMuted, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            style: TextStyle(color: _textLight, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF4A5568), fontSize: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _accentGreen, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              filled: true,
              fillColor: fill,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ট্যাব ৩: মন্তব্য তালিকা এবং ফর্ম
  // ==========================================
  Widget _buildCommentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add comment form
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
                Text(
                  'মন্তব্য',
                  style: TextStyle(color: _textMuted, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                _buildCommentField(_commentCtrl, maxLines: 3, hint: 'আপনার মন্তব্য লিখুন...'),
                const SizedBox(height: 14),
                Text(
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
            Text('মন্তব্য সমূহ পড়ুন',
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
      style: TextStyle(color: _textLight, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF4A5568), fontSize: 13),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _accentGreen, width: 1.5),
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
            title: Text('মন্তব্য মুছবেন?', style: TextStyle(color: _textLight)),
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
              style: TextStyle(color: _textLight, fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 6),
            Text(dateStr, style: TextStyle(color: _accentGreen, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Future<void> _saveComment() async {
    final comment = _commentCtrl.text.trim();
    final signature = _signatureCtrl.text.trim();
    if (comment.isEmpty || signature.isEmpty) return;

    final newComment = MonthlyComment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      yearMonth: _monthKey,
      comment: comment,
      signature: signature,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    await ReportStorageService.saveComment(newComment);
    _commentCtrl.clear();
    _signatureCtrl.clear();
    await _loadData();
  }

  Future<void> _deleteComment(String id) async {
    await ReportStorageService.deleteComment(id);
    await _loadData();
  }
}

/// Column configuration
class _ColGroup {
  final String title;
  final String Function(DailyPersonalEntry) extractor;

  _ColGroup(this.title, this.extractor);
}

class _PersonalBgPainter extends CustomPainter {
  final bool isDark;
  _PersonalBgPainter({required this.isDark});

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
  bool shouldRepaint(_PersonalBgPainter _) => false;
}
