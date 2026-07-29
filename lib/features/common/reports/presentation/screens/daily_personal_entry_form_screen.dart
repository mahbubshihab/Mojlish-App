import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/features/common/reports/data/models/daily_personal_entry.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';

class DailyPersonalEntryFormScreen extends StatefulWidget {
  final DateTime initialDate;
  final MajlisType majlisType;

  const DailyPersonalEntryFormScreen({
    super.key,
    required this.initialDate,
    this.majlisType = MajlisType.khelafat,
  });

  @override
  State<DailyPersonalEntryFormScreen> createState() => _DailyPersonalEntryFormScreenState();
}

class _DailyPersonalEntryFormScreenState extends State<DailyPersonalEntryFormScreen> {
  late DateTime _selectedDate;
  bool _isLoading = true;
  bool _isSaving = false;

  // Form Controllers
  final _quranSuraController = TextEditingController();
  final _quranAyahController = TextEditingController();
  final _hadithCountController = TextEditingController();
  final _hadithTopicController = TextEditingController();
  final _islamicLitPagesController = TextEditingController();
  final _islamicLitBookController = TextEditingController();
  final _textbookHoursController = TextEditingController();
  final _jamaatPrayerController = TextEditingController();
  final _selfAnalysisController = TextEditingController();
  final _contactCountController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _dawahMaterialsController = TextEditingController();
  final _meetingNameController = TextEditingController();
  final _orgTimeController = TextEditingController();
  final _memberContactCountController = TextEditingController();
  final _memberContactNameController = TextEditingController();
  final _newspaperTimeController = TextEditingController();
  final _physicalExerciseTimeController = TextEditingController();
  final _familyWelfareTimeController = TextEditingController();
  final _jobBusinessTimeController = TextEditingController();

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _loadEntryForDate();
  }

  @override
  void dispose() {
    _quranSuraController.dispose();
    _quranAyahController.dispose();
    _hadithCountController.dispose();
    _hadithTopicController.dispose();
    _islamicLitPagesController.dispose();
    _islamicLitBookController.dispose();
    _textbookHoursController.dispose();
    _jamaatPrayerController.dispose();
    _selfAnalysisController.dispose();
    _contactCountController.dispose();
    _contactNameController.dispose();
    _dawahMaterialsController.dispose();
    _meetingNameController.dispose();
    _orgTimeController.dispose();
    _memberContactCountController.dispose();
    _memberContactNameController.dispose();
    _newspaperTimeController.dispose();
    _physicalExerciseTimeController.dispose();
    _familyWelfareTimeController.dispose();
    _jobBusinessTimeController.dispose();
    super.dispose();
  }

  String _formatDateKey(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  Future<void> _loadEntryForDate() async {
    setState(() => _isLoading = true);
    final dateKey = _formatDateKey(_selectedDate);
    final entry = await ReportStorageService.getPersonalEntry(dateKey);

    if (entry != null) {
      _quranSuraController.text = entry.quranSura;
      _quranAyahController.text = entry.quranAyah;
      _hadithCountController.text = entry.hadithCount;
      _hadithTopicController.text = entry.hadithTopic;
      _islamicLitPagesController.text = entry.islamicLitPages;
      _islamicLitBookController.text = entry.islamicLitBook;
      _textbookHoursController.text = entry.textbookHours;
      _jamaatPrayerController.text = entry.jamaatPrayer;
      _selfAnalysisController.text = entry.selfAnalysis;
      _contactCountController.text = entry.contactCount;
      _contactNameController.text = entry.contactName;
      _dawahMaterialsController.text = entry.dawahMaterials;
      _meetingNameController.text = entry.meetingName;
      _orgTimeController.text = entry.orgTime;
      _memberContactCountController.text = entry.memberContactCount;
      _memberContactNameController.text = entry.memberContactName;
      _newspaperTimeController.text = entry.newspaperTime;
      _physicalExerciseTimeController.text = entry.physicalExerciseTime;
      _familyWelfareTimeController.text = entry.familyWelfareTime;
      _jobBusinessTimeController.text = entry.jobBusinessTime;
    } else {
      _quranSuraController.clear();
      _quranAyahController.clear();
      _hadithCountController.clear();
      _hadithTopicController.clear();
      _islamicLitPagesController.clear();
      _islamicLitBookController.clear();
      _textbookHoursController.clear();
      _jamaatPrayerController.clear();
      _selfAnalysisController.clear();
      _contactCountController.clear();
      _contactNameController.clear();
      _dawahMaterialsController.clear();
      _meetingNameController.clear();
      _orgTimeController.clear();
      _memberContactCountController.clear();
      _memberContactNameController.clear();
      _newspaperTimeController.clear();
      _physicalExerciseTimeController.clear();
      _familyWelfareTimeController.clear();
      _jobBusinessTimeController.clear();
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      _loadEntryForDate();
    }
  }

  Future<void> _saveEntry() async {
    setState(() => _isSaving = true);
    final dateKey = _formatDateKey(_selectedDate);

    final entry = DailyPersonalEntry(
      date: dateKey,
      quranSura: _quranSuraController.text.trim(),
      quranAyah: _quranAyahController.text.trim(),
      hadithCount: _hadithCountController.text.trim(),
      hadithTopic: _hadithTopicController.text.trim(),
      islamicLitPages: _islamicLitPagesController.text.trim(),
      islamicLitBook: _islamicLitBookController.text.trim(),
      textbookHours: _textbookHoursController.text.trim(),
      jamaatPrayer: _jamaatPrayerController.text.trim(),
      selfAnalysis: _selfAnalysisController.text.trim(),
      contactCount: _contactCountController.text.trim(),
      contactName: _contactNameController.text.trim(),
      dawahMaterials: _dawahMaterialsController.text.trim(),
      meetingName: _meetingNameController.text.trim(),
      orgTime: _orgTimeController.text.trim(),
      memberContactCount: _memberContactCountController.text.trim(),
      memberContactName: _memberContactNameController.text.trim(),
      newspaperTime: _newspaperTimeController.text.trim(),
      physicalExerciseTime: _physicalExerciseTimeController.text.trim(),
      familyWelfareTime: _familyWelfareTimeController.text.trim(),
      jobBusinessTime: _jobBusinessTimeController.text.trim(),
    );

    try {
      await ReportStorageService.savePersonalEntry(entry);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('দৈনিক রিপোর্ট সফলভাবে সংরক্ষিত হয়েছে'),
            backgroundColor: Color(0xFF059669),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('সংরক্ষণে সমস্যা হয়েছে: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = '${_bn(_selectedDate.day)} ${_monthNames[_selectedDate.month - 1]} ${_bn(_selectedDate.year)}';

    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;
        final bg = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
        final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);
        final textTitle = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
        final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF162032) : AppTheme.primaryColor,
            foregroundColor: Colors.white,
            title: Text('দৈনিক রিপোর্ট ফর্ম ($dateStr)'),
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_month_rounded),
                onPressed: _pickDate,
                tooltip: 'তারিখ নির্বাচন করুন',
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Header Card
                          InkWell(
                            onTap: _pickDate,
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: borderColor),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.event_available_rounded, color: AppTheme.primaryColor),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'রিপোর্টের তারিখ: $dateStr',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textTitle),
                                    ),
                                  ),
                                  Text(
                                    'পরিবর্তন করুন',
                                    style: TextStyle(fontSize: 13, color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 1. কুরআন ও হাদিস
                          _buildSectionTitle('📖 কুরআন ও হাদিস অধ্যয়ন', textTitle),
                          _buildCard([
                            _buildField('কুরআন (সূরা নাম)', _quranSuraController, textTitle, textMuted, cardBg, borderColor),
                            _buildField('কুরআন (আয়াত)', _quranAyahController, textTitle, textMuted, cardBg, borderColor),
                            _buildField('হাদিস (সংখ্যা)', _hadithCountController, textTitle, textMuted, cardBg, borderColor, keyboardType: TextInputType.number),
                            _buildField('হাদিস (বিষয়)', _hadithTopicController, textTitle, textMuted, cardBg, borderColor),
                          ], cardBg, borderColor),
                          const SizedBox(height: 20),

                          // 2. সাহিত্য ও পাঠ্যপুস্তক
                          _buildSectionTitle('📚 সাহিত্য ও পাঠ্যপুস্তক অধ্যয়ন', textTitle),
                          _buildCard([
                            _buildField('ইসলামি সাহিত্য (পৃষ্ঠা)', _islamicLitPagesController, textTitle, textMuted, cardBg, borderColor, keyboardType: TextInputType.number),
                            _buildField('ইসলামি সাহিত্য (বইয়ের নাম)', _islamicLitBookController, textTitle, textMuted, cardBg, borderColor),
                            _buildField('পাঠ্যপুস্তক/ক্লাস (ঘণ্টা)', _textbookHoursController, textTitle, textMuted, cardBg, borderColor, keyboardType: TextInputType.number),
                          ], cardBg, borderColor),
                          const SizedBox(height: 20),

                          // 3. সালাত ও আত্মবিচার
                          _buildSectionTitle('🕌 জামায়াতে নামাজ ও আত্মবিচার', textTitle),
                          _buildCard([
                            _buildField('জামাআতে নামায (ওয়াক্ত)', _jamaatPrayerController, textTitle, textMuted, cardBg, borderColor, keyboardType: TextInputType.number),
                            _buildField('আত্মবিচার (হ্যাঁ/না/মন্তব্য)', _selfAnalysisController, textTitle, textMuted, cardBg, borderColor),
                          ], cardBg, borderColor),
                          const SizedBox(height: 20),

                          // 4. দাওয়াতি কাজ
                          _buildSectionTitle('🤝 দাওয়াতি কাজ', textTitle),
                          _buildCard([
                            _buildField('সদস্য/বন্ধু যোগাযোগ (সংখ্যা)', _contactCountController, textTitle, textMuted, cardBg, borderColor, keyboardType: TextInputType.number),
                            _buildField('যোগাযোগের নাম', _contactNameController, textTitle, textMuted, cardBg, borderColor),
                            _buildField('দাওয়াতি উপকরণ বিতরণ (পরিমাণ)', _dawahMaterialsController, textTitle, textMuted, cardBg, borderColor),
                          ], cardBg, borderColor),
                          const SizedBox(height: 20),

                          // 5. সাংগঠনিক কাজ
                          _buildSectionTitle('👥 সাংগঠনিক কাজ', textTitle),
                          _buildCard([
                            _buildField('সভায় যোগদান (নাম)', _meetingNameController, textTitle, textMuted, cardBg, borderColor),
                            _buildField('সাংগঠনিক কাজে সময়দান (ঘণ্টা)', _orgTimeController, textTitle, textMuted, cardBg, borderColor, keyboardType: TextInputType.number),
                            _buildField('কর্মী যোগাযোগ (সংখ্যা)', _memberContactCountController, textTitle, textMuted, cardBg, borderColor, keyboardType: TextInputType.number),
                            _buildField('কর্মী যোগাযোগের নাম', _memberContactNameController, textTitle, textMuted, cardBg, borderColor),
                          ], cardBg, borderColor),
                          const SizedBox(height: 20),

                          // 6. বিবিধ
                          _buildSectionTitle('💼 বিবিধ ও সময়দান', textTitle),
                          _buildCard([
                            _buildField('পত্রিকা পাঠ (মিনিট)', _newspaperTimeController, textTitle, textMuted, cardBg, borderColor, keyboardType: TextInputType.number),
                            _buildField('শরীরচর্চা সময় (মিনিট)', _physicalExerciseTimeController, textTitle, textMuted, cardBg, borderColor, keyboardType: TextInputType.number),
                            _buildField('সামাজিক খেদমত সময় (মিনিট)', _familyWelfareTimeController, textTitle, textMuted, cardBg, borderColor, keyboardType: TextInputType.number),
                            _buildField('চাকুরি/ব্যবসা সময় (ঘণ্টা)', _jobBusinessTimeController, textTitle, textMuted, cardBg, borderColor, keyboardType: TextInputType.number),
                          ], cardBg, borderColor),
                          const SizedBox(height: 28),

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: _isSaving ? null : _saveEntry,
                              icon: const Icon(Icons.check_circle_outline_rounded, size: 22),
                              label: _isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text(
                                      'রিপোর্ট সংরক্ষণ করুন',
                                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                elevation: 3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, Color textTitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textTitle),
      ),
    );
  }

  Widget _buildCard(List<Widget> children, Color cardBg, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    Color textTitle,
    Color textMuted,
    Color cardBg,
    Color borderColor, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: textTitle, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: textMuted, fontSize: 14),
          filled: true,
          fillColor: cardBg,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}
