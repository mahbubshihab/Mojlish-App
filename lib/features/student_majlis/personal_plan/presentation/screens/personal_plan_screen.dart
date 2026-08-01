import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import '../../../../common/widgets/unsaved_changes_guard.dart';
import '../../../../common/services/report_storage_service.dart';
import '../../data/services/student_personal_plan_pdf_service.dart';
import '../../domain/entities/personal_plan_entity.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস — ব্যক্তিগত মাসিক পরিকল্পনা এন্ট্রি স্ক্রিন
class PersonalPlanScreen extends StatefulWidget {
  final String? initialMonth;
  final String? initialYear;

  const PersonalPlanScreen({
    super.key,
    this.initialMonth,
    this.initialYear,
  });

  @override
  State<PersonalPlanScreen> createState() => _PersonalPlanScreenState();
}

class _PersonalPlanScreenState extends State<PersonalPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  bool _isSubmitting = false;
  bool _isLocked = false;
  bool _hasChanges = false;

  TextEditingController _c(String key, [String initialValue = '']) {
    return _controllers.putIfAbsent(
      key,
      () => TextEditingController(text: initialValue),
    );
  }

  @override
  void initState() {
    super.initState();
    _c('month', widget.initialMonth ?? 'মহররম');
    _c('year', widget.initialYear ?? '২০২৬');
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _markChanged() {
    if (!_isLocked && !_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  PersonalPlanEntity _buildEntityFromControllers() {
    return PersonalPlanEntity(
      name: _c('name').text,
      branch: _c('branch').text,
      responsibility: _c('responsibility').text,
      month: _c('month').text,
      year: _c('year').text,

      // Study
      quranAyatCount: _c('quranAyatCount').text,
      quranSuraPara: _c('quranSuraPara').text,
      quranDarasCount: _c('quranDarasCount').text,
      quranDarasTopic: _c('quranDarasTopic').text,
      quranMemorizeAyat: _c('quranMemorizeAyat').text,
      hadithCount: _c('hadithCount').text,
      hadithBookTopic: _c('hadithBookTopic').text,
      hadithDarasCount: _c('hadithDarasCount').text,
      hadithDarasTopic: _c('hadithDarasTopic').text,
      hadithMemorizeCount: _c('hadithMemorizeCount').text,
      hadithMemorizeTopic: _c('hadithMemorizeTopic').text,
      islamicLiteraturePages: _c('islamicLiteraturePages').text,
      islamicLiteratureBookName: _c('islamicLiteratureBookName').text,
      islamicLiteratureBookNotesPage: _c('islamicLiteratureBookNotesPage').text,
      textbookClassAvgHours: _c('textbookClassAvgHours').text,
      textbookClassTime: _c('textbookClassTime').text,

      // Worship
      jamatNamazWaqt: _c('jamatNamazWaqt').text,
      selfEvaluationDays: _c('selfEvaluationDays').text,
      nafalIbadat: _c('nafalIbadat').text,

      // Dawah
      friendTargetContactCount: _c('friendTargetContactCount').text,
      friendTargetContactName: _c('friendTargetContactName').text,
      primaryMemberIncreaseContactCount: _c('primaryMemberIncreaseContactCount').text,
      primaryMemberIncreaseContactName: _c('primaryMemberIncreaseContactName').text,
      bookIntroStickerDistributionCount: _c('bookIntroStickerDistributionCount').text,
      studentReviewDistributionCount: _c('studentReviewDistributionCount').text,
      wellWisherIncreaseContactCount: _c('wellWisherIncreaseContactCount').text,
      wellWisherIncreaseContactName: _c('wellWisherIncreaseContactName').text,
      cardGiftSmsEmailLetterMagazineCount: _c('cardGiftSmsEmailLetterMagazineCount').text,
      groupDawahCount: _c('groupDawahCount').text,
      otherDawahMaterialsDistribution: _c('otherDawahMaterialsDistribution').text,

      // Organizational
      workerStandardUpgradeCount: _c('workerStandardUpgradeCount').text,
      workerStandardUpgradeName: _c('workerStandardUpgradeName').text,
      meetingAttendanceCount: _c('meetingAttendanceCount').text,
      orgDawahTimeAvgHours: _c('orgDawahTimeAvgHours').text,
      baytulmalAmount: _c('baytulmalAmount').text,
      workerContactCount: _c('workerContactCount').text,
      workerNames: _c('workerNames').text,

      // Misc
      dailyOtherNewspaperAvgHours: _c('dailyOtherNewspaperAvgHours').text,
      physicalExerciseDays: _c('physicalExerciseDays').text,
      techLanguageStudyAvgHours: _c('techLanguageStudyAvgHours').text,
      familySocialWorkAvgHours: _c('familySocialWorkAvgHours').text,
      others: _c('others').text,

      // Concerned
      memberLevelUpgradeTargetCount: _c('memberLevelUpgradeTargetCount').text,
      memberLevelUpgradeTargetName: _c('memberLevelUpgradeTargetName').text,
      associateMemberLevelUpgradeTargetCount: _c('associateMemberLevelUpgradeTargetCount').text,
      associateMemberLevelUpgradeTargetName: _c('associateMemberLevelUpgradeTargetName').text,
    );
  }

  void _exportPdf() {
    final plan = _buildEntityFromControllers();
    StudentPersonalPlanPdfService.generateAndPrintPdf(plan, context);
  }

  Future<bool> _saveReport() async {
    if (_formKey.currentState?.validate() ?? true) {
      _formKey.currentState?.save();
      setState(() => _isSubmitting = true);

      final plan = _buildEntityFromControllers();
      final Map<String, dynamic> data = {
        'name': plan.name,
        'branch': plan.branch,
        'responsibility': plan.responsibility,
        'month': plan.month,
        'year': plan.year,
        'quranAyatCount': plan.quranAyatCount,
        'quranSuraPara': plan.quranSuraPara,
        'quranDarasCount': plan.quranDarasCount,
        'quranDarasTopic': plan.quranDarasTopic,
        'quranMemorizeAyat': plan.quranMemorizeAyat,
        'hadithCount': plan.hadithCount,
        'hadithBookTopic': plan.hadithBookTopic,
        'hadithDarasCount': plan.hadithDarasCount,
        'hadithDarasTopic': plan.hadithDarasTopic,
        'hadithMemorizeCount': plan.hadithMemorizeCount,
        'hadithMemorizeTopic': plan.hadithMemorizeTopic,
        'islamicLiteraturePages': plan.islamicLiteraturePages,
        'islamicLiteratureBookName': plan.islamicLiteratureBookName,
        'islamicLiteratureBookNotesPage': plan.islamicLiteratureBookNotesPage,
        'textbookClassAvgHours': plan.textbookClassAvgHours,
        'textbookClassTime': plan.textbookClassTime,
        'jamatNamazWaqt': plan.jamatNamazWaqt,
        'selfEvaluationDays': plan.selfEvaluationDays,
        'nafalIbadat': plan.nafalIbadat,
        'friendTargetContactCount': plan.friendTargetContactCount,
        'friendTargetContactName': plan.friendTargetContactName,
        'primaryMemberIncreaseContactCount': plan.primaryMemberIncreaseContactCount,
        'primaryMemberIncreaseContactName': plan.primaryMemberIncreaseContactName,
        'bookIntroStickerDistributionCount': plan.bookIntroStickerDistributionCount,
        'studentReviewDistributionCount': plan.studentReviewDistributionCount,
        'wellWisherIncreaseContactCount': plan.wellWisherIncreaseContactCount,
        'wellWisherIncreaseContactName': plan.wellWisherIncreaseContactName,
        'cardGiftSmsEmailLetterMagazineCount': plan.cardGiftSmsEmailLetterMagazineCount,
        'groupDawahCount': plan.groupDawahCount,
        'otherDawahMaterialsDistribution': plan.otherDawahMaterialsDistribution,
        'workerStandardUpgradeCount': plan.workerStandardUpgradeCount,
        'workerStandardUpgradeName': plan.workerStandardUpgradeName,
        'meetingAttendanceCount': plan.meetingAttendanceCount,
        'orgDawahTimeAvgHours': plan.orgDawahTimeAvgHours,
        'baytulmalAmount': plan.baytulmalAmount,
        'workerContactCount': plan.workerContactCount,
        'workerNames': plan.workerNames,
        'dailyOtherNewspaperAvgHours': plan.dailyOtherNewspaperAvgHours,
        'physicalExerciseDays': plan.physicalExerciseDays,
        'techLanguageStudyAvgHours': plan.techLanguageStudyAvgHours,
        'familySocialWorkAvgHours': plan.familySocialWorkAvgHours,
        'others': plan.others,
        'memberLevelUpgradeTargetCount': plan.memberLevelUpgradeTargetCount,
        'memberLevelUpgradeTargetName': plan.memberLevelUpgradeTargetName,
        'associateMemberLevelUpgradeTargetCount': plan.associateMemberLevelUpgradeTargetCount,
        'associateMemberLevelUpgradeTargetName': plan.associateMemberLevelUpgradeTargetName,
      };

      await ReportStorageService.saveReport('personal_plan', data);

      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _hasChanges = false;
          _isLocked = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ব্যক্তিগত মাসিক পরিকল্পনা সফলভাবে সংরক্ষণ করা হয়েছে!'),
            backgroundColor: Color(0xFF059669),
          ),
        );
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || themeManager.isDarkMode;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final inputBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    const oceanBlue = Color(0xFF0077B6);

    return UnsavedChangesGuard(
      hasUnsavedChanges: !_isLocked && _hasChanges,
      onSave: () async {
        return await _saveReport();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ব্যক্তিগত মাসিক পরিকল্পনা'),
          centerTitle: true,
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          elevation: 1,
          actions: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf_rounded, color: oceanBlue),
              tooltip: 'PDF ডাউনলোড',
              onPressed: _exportPdf,
            ),
          ],
        ),
        body: AmbientBackgroundWidget(
          child: SafeArea(
            child: Column(
              children: [
                // Sticky Top Dual Action Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border(bottom: BorderSide(color: borderColor, width: 0.8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isSubmitting
                              ? null
                              : (_isLocked
                                  ? () => setState(() => _isLocked = false)
                                  : _saveReport),
                          icon: _isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Icon(_isLocked ? Icons.edit_rounded : Icons.save_rounded, color: Colors.white),
                          label: Text(
                            _isLocked ? 'এডিট করুন' : 'সংরক্ষণ করুন',
                            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isLocked ? const Color(0xFFD97706) : const Color(0xFF059669),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _exportPdf,
                          icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
                          label: const Text(
                            'PDF ডাউনলোড',
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: oceanBlue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Fields Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Header Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: oceanBlue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'ব্যক্তিগত মাসিক পরিকল্পনা',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(flex: 3, child: _buildInput('নাম', _c('name'), inputBg, textColor, borderColor)),
                                    const SizedBox(width: 8),
                                    Expanded(flex: 2, child: _buildInput('শাখা', _c('branch'), inputBg, textColor, borderColor)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(flex: 3, child: _buildInput('দায়িত্ব', _c('responsibility'), inputBg, textColor, borderColor)),
                                    const SizedBox(width: 8),
                                    Expanded(flex: 1, child: _buildInput('মাস', _c('month'), inputBg, textColor, borderColor)),
                                    const SizedBox(width: 8),
                                    Expanded(flex: 1, child: _buildInput('সন', _c('year'), inputBg, textColor, borderColor)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 1. অধ্যয়ন
                          _buildSectionCard(
                            title: '১. অধ্যয়ন',
                            color: oceanBlue,
                            cardBg: cardBg,
                            textColor: textColor,
                            borderColor: borderColor,
                            inputBg: inputBg,
                            children: [
                              Text('কুরআন', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(child: _buildInput('আয়াত সংখ্যা', _c('quranAyatCount'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 2, child: _buildInput('সূরা/পারা', _c('quranSuraPara'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _buildInput('দারস তৈরি (টি)', _c('quranDarasCount'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildInput('দারস বিষয়', _c('quranDarasTopic'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildInput('মুখস্থ (আয়াত)', _c('quranMemorizeAyat'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text('হাদীস', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(child: _buildInput('সংখ্যা (টি)', _c('hadithCount'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 2, child: _buildInput('হাদীস গ্রন্থ/বিষয়', _c('hadithBookTopic'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _buildInput('দারস তৈরি (টি)', _c('hadithDarasCount'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildInput('দারস বিষয়', _c('hadithDarasTopic'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _buildInput('মুখস্থ (টি)', _c('hadithMemorizeCount'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 2, child: _buildInput('মুখস্থ বিষয়', _c('hadithMemorizeTopic'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text('ইসলামী সাহিত্য ও পাঠ্য পুস্তক', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(child: _buildInput('পৃষ্ঠা সংখ্যা', _c('islamicLiteraturePages'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 2, child: _buildInput('বইয়ের নাম', _c('islamicLiteratureBookName'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildInput('বই/আলোচনা নোট (পৃষ্ঠা)', _c('islamicLiteratureBookNotesPage'), inputBg, textColor, borderColor),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _buildInput('পাঠ্যপুস্তক/ক্লাস (গড়ে ঘণ্টা)', _c('textbookClassAvgHours'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildInput('সময় নির্ধারণ', _c('textbookClassTime'), inputBg, textColor, borderColor)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 2. ইবাদত
                          _buildSectionCard(
                            title: '২. ইবাদত',
                            color: const Color(0xFF0D9488),
                            cardBg: cardBg,
                            textColor: textColor,
                            borderColor: borderColor,
                            inputBg: inputBg,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _buildInput('জামাআতে নামায (ওয়াক্ত)', _c('jamatNamazWaqt'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildInput('আত্মবিচার (দিন)', _c('selfEvaluationDays'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildInput('নফল ইবাদত বিবরণ', _c('nafalIbadat'), inputBg, textColor, borderColor),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 3. দাওয়াতি কাজ
                          _buildSectionCard(
                            title: '৩. দাওয়াতি কাজ',
                            color: const Color(0xFF7C3AED),
                            cardBg: cardBg,
                            textColor: textColor,
                            borderColor: borderColor,
                            inputBg: inputBg,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _buildInput('বন্ধু টার্গেট/যোগাযোগ (জন)', _c('friendTargetContactCount'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 2, child: _buildInput('নাম (টার্গেট)', _c('friendTargetContactName'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _buildInput('প্রাথমিক সদস্য বৃদ্ধি (জন)', _c('primaryMemberIncreaseContactCount'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 2, child: _buildInput('নাম (বৃদ্ধি)', _c('primaryMemberIncreaseContactName'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _buildInput('বই/স্টিকার বিতরণ (টি)', _c('bookIntroStickerDistributionCount'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildInput('ছাত্র পরিক্রমা বিতরণ (টি)', _c('studentReviewDistributionCount'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _buildInput('শুভাকাঙ্ক্ষী বৃদ্ধি (জন)', _c('wellWisherIncreaseContactCount'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 2, child: _buildInput('নাম (বৃদ্ধি)', _c('wellWisherIncreaseContactName'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildInput('কার্ড/উপহার/SMS/চিঠি/পত্রিকা (টি)', _c('cardGiftSmsEmailLetterMagazineCount'), inputBg, textColor, borderColor),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _buildInput('গ্রুপ দাওয়াত (বার)', _c('groupDawahCount'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 2, child: _buildInput('অন্যান্য দাওয়াতি উপকরণ', _c('otherDawahMaterialsDistribution'), inputBg, textColor, borderColor)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 4. সাংগঠনিক কাজ
                          _buildSectionCard(
                            title: '৪. সাংগঠনিক কাজ',
                            color: const Color(0xFF059669),
                            cardBg: cardBg,
                            textColor: textColor,
                            borderColor: borderColor,
                            inputBg: inputBg,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _buildInput('কর্মী মানে উন্নীতকরণ (জন)', _c('workerStandardUpgradeCount'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 2, child: _buildInput('নাম', _c('workerStandardUpgradeName'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _buildInput('সভায় যোগদান (টি)', _c('meetingAttendanceCount'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildInput('সংগঠনে সময়দান (গড়ে ঘণ্টা)', _c('orgDawahTimeAvgHours'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _buildInput('বায়তুলমাল প্রদান (টাকা)', _c('baytulmalAmount'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildInput('কর্মী যোগাযোগ (জন)', _c('workerContactCount'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildInput('কর্মী নামসমূহ', _c('workerNames'), inputBg, textColor, borderColor),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 5. বিবিধ
                          _buildSectionCard(
                            title: '৫. বিবিধ',
                            color: const Color(0xFFD97706),
                            cardBg: cardBg,
                            textColor: textColor,
                            borderColor: borderColor,
                            inputBg: inputBg,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _buildInput('পত্রিকা পাঠ (গড়ে ঘণ্টা)', _c('dailyOtherNewspaperAvgHours'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildInput('শরীরচর্চা (দিন)', _c('physicalExerciseDays'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildInput('কারিগরি/কম্পিউটার/ভাষা শিক্ষা (গড়ে ঘণ্টা)', _c('techLanguageStudyAvgHours'), inputBg, textColor, borderColor),
                              const SizedBox(height: 8),
                              _buildInput('পারিবারিক/সামাজিক কাজ (গড়ে ঘণ্টা)', _c('familySocialWorkAvgHours'), inputBg, textColor, borderColor),
                              const SizedBox(height: 8),
                              _buildInput('অন্যান্য', _c('others'), inputBg, textColor, borderColor),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 6. সংশ্লিষ্টদের জন্য
                          _buildSectionCard(
                            title: '৬. সংশ্লিষ্টদের জন্য',
                            color: const Color(0xFFDC2626),
                            cardBg: cardBg,
                            textColor: textColor,
                            borderColor: borderColor,
                            inputBg: inputBg,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _buildInput('সদস্য উন্নীতকরণ টার্গেট (জন)', _c('memberLevelUpgradeTargetCount'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 2, child: _buildInput('নাম', _c('memberLevelUpgradeTargetName'), inputBg, textColor, borderColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _buildInput('সহযোগী সদস্য উন্নীতকরণ (জন)', _c('associateMemberLevelUpgradeTargetCount'), inputBg, textColor, borderColor)),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 2, child: _buildInput('নাম', _c('associateMemberLevelUpgradeTargetName'), inputBg, textColor, borderColor)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Color color,
    required Color cardBg,
    required Color textColor,
    required Color borderColor,
    required Color inputBg,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: themeManager.isDarkMode ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller,
    Color inputBg,
    Color textColor,
    Color borderColor,
  ) {
    return TextField(
      controller: controller,
      enabled: !_isLocked,
      onChanged: (_) => _markChanged(),
      style: TextStyle(fontSize: 13, color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.7)),
        filled: true,
        fillColor: _isLocked ? inputBg.withValues(alpha: 0.5) : inputBg,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0077B6), width: 1.5),
        ),
      ),
    );
  }
}
