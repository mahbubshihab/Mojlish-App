import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mojlish_app/features/common/widgets/custom_labeled_input_field.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/presentation/bloc/personal_report_bloc.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/presentation/bloc/personal_report_event.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/presentation/bloc/personal_report_state.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/domain/entities/personal_report_entity.dart';

class PersonalReportPage extends StatefulWidget {
  final String? initialMonth;
  final String? initialYear;

  const PersonalReportPage({
    super.key,
    this.initialMonth,
    this.initialYear,
  });

  @override
  State<PersonalReportPage> createState() => _PersonalReportPageState();
}

class _PersonalReportPageState extends State<PersonalReportPage> {
  final _formKey = GlobalKey<FormState>();

  // Study Controllers
  final _quranTotalAyatController = TextEditingController();
  final _quranDaysController = TextEditingController();
  final _quranSurahController = TextEditingController();
  final _quranAverageController = TextEditingController();
  final _darsPrepTotalController = TextEditingController();
  final _darsPrepSubjectController = TextEditingController();
  final _darsPrepMemorizedAyatController = TextEditingController();

  final _hadithTotalController = TextEditingController();
  final _hadithDaysController = TextEditingController();
  final _hadithBookController = TextEditingController();
  final _hadithAverageController = TextEditingController();
  final _darsPrepHadithTotalController = TextEditingController();
  final _darsPrepHadithSubjectController = TextEditingController();
  final _darsPrepHadithMemorizedController = TextEditingController();
  final _darsPrepHadithMemorizedSubjectController = TextEditingController();

  final _literatureTotalPagesController = TextEditingController();
  final _literatureDaysController = TextEditingController();
  final _literatureAverageController = TextEditingController();
  final _literatureBookNameController = TextEditingController();
  final _literatureNotePagesController = TextEditingController();

  final _textbookAttendanceTotalController = TextEditingController();
  final _textbookAttendanceHoursController = TextEditingController();
  final _textbookAttendanceDaysController = TextEditingController();
  final _textbookAttendanceAverageController = TextEditingController();

  // Worship
  final _jamatNamazTotalController = TextEditingController();
  final _selfAssessmentDaysController = TextEditingController();

  // Dawah
  final _friendIncreaseTotalController = TextEditingController();
  final _friendIncreaseNamesController = TextEditingController();
  final _primaryMemberIncreaseTotalController = TextEditingController();
  final _primaryMemberIncreaseNamesController = TextEditingController();
  final _bookDistributionTotalController = TextEditingController();
  final _studentReviewDistributionTotalController = TextEditingController();
  final _wellWisherIncreaseTotalController = TextEditingController();
  final _wellWisherIncreaseNamesController = TextEditingController();
  final _cardGiftSmsEmailLetterMagazineTotalController = TextEditingController();
  final _groupDawahTotalController = TextEditingController();
  final _otherDawahMaterialsController = TextEditingController();

  // Org
  final _workerIncreaseTotalController = TextEditingController();
  final _workerIncreaseNamesController = TextEditingController();
  final _meetingAttendanceTotalController = TextEditingController();
  final _orgDawahTimeGivenAverageHoursController = TextEditingController();
  final _baytulmalPaidAmountController = TextEditingController();
  final _baytulmalPaidDateController = TextEditingController();
  final _workerCommunicationTotalController = TextEditingController();
  final _workerCommunicationNamesController = TextEditingController();

  // Misc
  final _dailyOtherMagazineReadingAverageHoursController = TextEditingController();
  final _physicalExerciseDaysController = TextEditingController();
  final _technicalTimeGivenAverageHoursController = TextEditingController();
  final _familySocialWorkTimeGivenAverageHoursController = TextEditingController();
  final _miscellaneousOthersController = TextEditingController();

  // Concerned
  final _promotedToMemberTotalController = TextEditingController();
  final _promotedToMemberNamesController = TextEditingController();
  final _promotedToAssociateMemberTotalController = TextEditingController();
  final _promotedToAssociateMemberNamesController = TextEditingController();
  final _meetingAdviceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final m = widget.initialMonth ?? 'জানুয়ারি';
    final y = widget.initialYear ?? '২০২৬';
    context.read<PersonalReportBloc>().add(LoadPersonalReport(month: m, year: y));
  }

  @override
  void dispose() {
    _quranTotalAyatController.dispose();
    _quranDaysController.dispose();
    _quranSurahController.dispose();
    _quranAverageController.dispose();
    _darsPrepTotalController.dispose();
    _darsPrepSubjectController.dispose();
    _darsPrepMemorizedAyatController.dispose();

    _hadithTotalController.dispose();
    _hadithDaysController.dispose();
    _hadithBookController.dispose();
    _hadithAverageController.dispose();
    _darsPrepHadithTotalController.dispose();
    _darsPrepHadithSubjectController.dispose();
    _darsPrepHadithMemorizedController.dispose();
    _darsPrepHadithMemorizedSubjectController.dispose();

    _literatureTotalPagesController.dispose();
    _literatureDaysController.dispose();
    _literatureAverageController.dispose();
    _literatureBookNameController.dispose();
    _literatureNotePagesController.dispose();

    _textbookAttendanceTotalController.dispose();
    _textbookAttendanceHoursController.dispose();
    _textbookAttendanceDaysController.dispose();
    _textbookAttendanceAverageController.dispose();

    _jamatNamazTotalController.dispose();
    _selfAssessmentDaysController.dispose();

    _friendIncreaseTotalController.dispose();
    _friendIncreaseNamesController.dispose();
    _primaryMemberIncreaseTotalController.dispose();
    _primaryMemberIncreaseNamesController.dispose();
    _bookDistributionTotalController.dispose();
    _studentReviewDistributionTotalController.dispose();
    _wellWisherIncreaseTotalController.dispose();
    _wellWisherIncreaseNamesController.dispose();
    _cardGiftSmsEmailLetterMagazineTotalController.dispose();
    _groupDawahTotalController.dispose();
    _otherDawahMaterialsController.dispose();

    _workerIncreaseTotalController.dispose();
    _workerIncreaseNamesController.dispose();
    _meetingAttendanceTotalController.dispose();
    _orgDawahTimeGivenAverageHoursController.dispose();
    _baytulmalPaidAmountController.dispose();
    _baytulmalPaidDateController.dispose();
    _workerCommunicationTotalController.dispose();
    _workerCommunicationNamesController.dispose();

    _dailyOtherMagazineReadingAverageHoursController.dispose();
    _physicalExerciseDaysController.dispose();
    _technicalTimeGivenAverageHoursController.dispose();
    _familySocialWorkTimeGivenAverageHoursController.dispose();
    _miscellaneousOthersController.dispose();

    _promotedToMemberTotalController.dispose();
    _promotedToMemberNamesController.dispose();
    _promotedToAssociateMemberTotalController.dispose();
    _promotedToAssociateMemberNamesController.dispose();
    _meetingAdviceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final report = PersonalReportEntity(
        id: '1',
        month: widget.initialMonth ?? 'জানুয়ারি',
        year: widget.initialYear ?? '২০২৬',
        quranTotalAyat: int.tryParse(_quranTotalAyatController.text) ?? 0,
        quranDays: int.tryParse(_quranDaysController.text) ?? 0,
        quranSurah: _quranSurahController.text,
        quranAverage: int.tryParse(_quranAverageController.text) ?? 0,
        darsPreparationTotal: int.tryParse(_darsPrepTotalController.text) ?? 0,
        darsPreparationSubject: _darsPrepSubjectController.text,
        darsPreparationMemorizedAyat: int.tryParse(_darsPrepMemorizedAyatController.text) ?? 0,
        hadithTotal: int.tryParse(_hadithTotalController.text) ?? 0,
        hadithDays: int.tryParse(_hadithDaysController.text) ?? 0,
        hadithBook: _hadithBookController.text,
        hadithAverage: int.tryParse(_hadithAverageController.text) ?? 0,
        darsPreparationHadithTotal: int.tryParse(_darsPrepHadithTotalController.text) ?? 0,
        darsPreparationHadithSubject: _darsPrepHadithSubjectController.text,
        darsPreparationHadithMemorized: int.tryParse(_darsPrepHadithMemorizedController.text) ?? 0,
        darsPreparationHadithMemorizedSubject: _darsPrepHadithMemorizedSubjectController.text,
        islamicLiteratureTotalPages: int.tryParse(_literatureTotalPagesController.text) ?? 0,
        islamicLiteratureDays: int.tryParse(_literatureDaysController.text) ?? 0,
        islamicLiteratureAverage: int.tryParse(_literatureAverageController.text) ?? 0,
        islamicLiteratureBookName: _literatureBookNameController.text,
        islamicLiteratureNotePages: int.tryParse(_literatureNotePagesController.text) ?? 0,
        textbookClassAttendanceTotal: int.tryParse(_textbookAttendanceTotalController.text) ?? 0,
        textbookClassAttendanceHours: int.tryParse(_textbookAttendanceHoursController.text) ?? 0,
        textbookClassAttendanceDays: int.tryParse(_textbookAttendanceDaysController.text) ?? 0,
        textbookClassAttendanceAverage: int.tryParse(_textbookAttendanceAverageController.text) ?? 0,
        jamatNamazTotal: int.tryParse(_jamatNamazTotalController.text) ?? 0,
        selfAssessmentDays: int.tryParse(_selfAssessmentDaysController.text) ?? 0,
        friendIncreaseTotal: int.tryParse(_friendIncreaseTotalController.text) ?? 0,
        friendIncreaseNames: _friendIncreaseNamesController.text,
        primaryMemberIncreaseTotal: int.tryParse(_primaryMemberIncreaseTotalController.text) ?? 0,
        primaryMemberIncreaseNames: _primaryMemberIncreaseNamesController.text,
        bookDistributionTotal: int.tryParse(_bookDistributionTotalController.text) ?? 0,
        studentReviewDistributionTotal: int.tryParse(_studentReviewDistributionTotalController.text) ?? 0,
        wellWisherIncreaseTotal: int.tryParse(_wellWisherIncreaseTotalController.text) ?? 0,
        wellWisherIncreaseNames: _wellWisherIncreaseNamesController.text,
        cardGiftSmsEmailLetterMagazineTotal: int.tryParse(_cardGiftSmsEmailLetterMagazineTotalController.text) ?? 0,
        groupDawahTotal: int.tryParse(_groupDawahTotalController.text) ?? 0,
        otherDawahMaterials: _otherDawahMaterialsController.text,
        workerIncreaseTotal: int.tryParse(_workerIncreaseTotalController.text) ?? 0,
        workerIncreaseNames: _workerIncreaseNamesController.text,
        meetingAttendanceTotal: int.tryParse(_meetingAttendanceTotalController.text) ?? 0,
        orgDawahTimeGivenAverageHours: int.tryParse(_orgDawahTimeGivenAverageHoursController.text) ?? 0,
        baytulmalPaidAmount: double.tryParse(_baytulmalPaidAmountController.text) ?? 0.0,
        baytulmalPaidDate: _baytulmalPaidDateController.text,
        workerCommunicationTotal: int.tryParse(_workerCommunicationTotalController.text) ?? 0,
        workerCommunicationNames: _workerCommunicationNamesController.text,
        dailyOtherMagazineReadingAverageHours: int.tryParse(_dailyOtherMagazineReadingAverageHoursController.text) ?? 0,
        physicalExerciseDays: int.tryParse(_physicalExerciseDaysController.text) ?? 0,
        technicalComputerLanguageTimeGivenAverageHours: int.tryParse(_technicalTimeGivenAverageHoursController.text) ?? 0,
        familySocialWorkTimeGivenAverageHours: int.tryParse(_familySocialWorkTimeGivenAverageHoursController.text) ?? 0,
        miscellaneousOthers: _miscellaneousOthersController.text,
        promotedToMemberTotal: int.tryParse(_promotedToMemberTotalController.text) ?? 0,
        promotedToMemberNames: _promotedToMemberNamesController.text,
        promotedToAssociateMemberTotal: int.tryParse(_promotedToAssociateMemberTotalController.text) ?? 0,
        promotedToAssociateMemberNames: _promotedToAssociateMemberNamesController.text,
        meetingAdvice: _meetingAdviceController.text,
      );

      context.read<PersonalReportBloc>().add(SubmitPersonalReport(report: report));
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthStr = widget.initialMonth ?? 'জানুয়ারি';
    final yearStr = widget.initialYear ?? '২০২৬';

    return Scaffold(
      appBar: AppBar(
        title: Text('ব্যক্তিগত রিপোর্ট ($monthStr $yearStr)'),
        backgroundColor: const Color(0xFF006A4E),
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<PersonalReportBloc, PersonalReportState>(
        listener: (context, state) {
          if (state is PersonalReportSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('রিপোর্ট সফলভাবে সংরক্ষিত হয়েছে!')),
            );
            Navigator.pop(context);
          } else if (state is PersonalReportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is PersonalReportLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month-Year Filter Badge Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded, color: Color(0xFF059669)),
                            const SizedBox(width: 8),
                            Text(
                              'রিপোর্ট সেশন: $monthStr $yearStr',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF065F46),
                              ),
                            ),
                          ],
                        ),
                        Chip(
                          label: const Text('সক্রিয়', style: TextStyle(color: Colors.white, fontSize: 12)),
                          backgroundColor: const Color(0xFF059669),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 1. Study Section
                  _buildSectionCard(
                    title: '১. অধ্যয়ন (Study)',
                    icon: Icons.menu_book_rounded,
                    color: const Color(0xFF0284C7),
                    children: [
                      const Text('📖 কুরআন পাঠ ও দরস প্রস্তুতি', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'মোট আয়াত', controller: _quranTotalAyatController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'পাঠের দিন', controller: _quranDaysController, keyboardType: TextInputType.number)),
                        ],
                      ),
                      CustomLabeledInputField(label: 'পঠিত সূরা/পারা', controller: _quranSurahController),
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'দৈনিক গড় আয়াত', controller: _quranAverageController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'দরস প্রস্তুতি সংখ্যা', controller: _darsPrepTotalController, keyboardType: TextInputType.number)),
                        ],
                      ),
                      CustomLabeledInputField(label: 'দরস বিষয়', controller: _darsPrepSubjectController),
                      CustomLabeledInputField(label: 'মুখস্থ আয়াত সংখ্যা', controller: _darsPrepMemorizedAyatController, keyboardType: TextInputType.number),

                      const Divider(height: 24),
                      const Text('📚 হাদীস পাঠ ও দরস প্রস্তুতি', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'মোট হাদীস', controller: _hadithTotalController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'পাঠের দিন', controller: _hadithDaysController, keyboardType: TextInputType.number)),
                        ],
                      ),
                      CustomLabeledInputField(label: 'হাদীস কিতাবের নাম', controller: _hadithBookController),
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'দৈনিক গড় হাদীস', controller: _hadithAverageController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'দরস প্রস্তুতি সংখ্যা', controller: _darsPrepHadithTotalController, keyboardType: TextInputType.number)),
                        ],
                      ),
                      CustomLabeledInputField(label: 'দরস বিষয়', controller: _darsPrepHadithSubjectController),
                      CustomLabeledInputField(label: 'মুখস্থ হাদীস সংখ্যা', controller: _darsPrepHadithMemorizedController, keyboardType: TextInputType.number),

                      const Divider(height: 24),
                      const Text('📓 ইসলামী সাহিত্য পাঠ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'মোট পৃষ্ঠা', controller: _literatureTotalPagesController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'পাঠের দিন', controller: _literatureDaysController, keyboardType: TextInputType.number)),
                        ],
                      ),
                      CustomLabeledInputField(label: 'পঠিত বইয়ের নাম', controller: _literatureBookNameController),
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'দৈনিক গড় পৃষ্ঠা', controller: _literatureAverageController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'নোট তৈরির পৃষ্ঠা', controller: _literatureNotePagesController, keyboardType: TextInputType.number)),
                        ],
                      ),

                      const Divider(height: 24),
                      const Text('🏫 পাঠ্যবই ও ক্লাস উপস্থিতি', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'ক্লাস উপস্থিতি (দিন)', controller: _textbookAttendanceDaysController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'পড়াশোনার ঘন্টা', controller: _textbookAttendanceHoursController, keyboardType: TextInputType.number)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 2. Worship Section
                  _buildSectionCard(
                    title: '২. ইবাদত ও আত্মগঠন (Worship & Self-Assessment)',
                    icon: Icons.mosque_rounded,
                    color: const Color(0xFF059669),
                    children: [
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'জামাতে নামায (মোট ওয়াক্ত)', controller: _jamatNamazTotalController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'আত্মসমালোচনা/মুহাসাবা (দিন)', controller: _selfAssessmentDaysController, keyboardType: TextInputType.number)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 3. Dawah Section
                  _buildSectionCard(
                    title: '৩. দাওয়াতী কাজ (Dawah Work)',
                    icon: Icons.campaign_rounded,
                    color: const Color(0xFFD97706),
                    children: [
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'বন্ধু বৃদ্ধি (জন)', controller: _friendIncreaseTotalController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'প্রাথমিক সদস্য বৃদ্ধি (জন)', controller: _primaryMemberIncreaseTotalController, keyboardType: TextInputType.number)),
                        ],
                      ),
                      CustomLabeledInputField(label: 'নতুন বন্ধুদের নামসমূহ', controller: _friendIncreaseNamesController, maxLines: 2),
                      CustomLabeledInputField(label: 'প্রাথমিক সদস্যদের নামসমূহ', controller: _primaryMemberIncreaseNamesController, maxLines: 2),
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'বই বিলি (টি)', controller: _bookDistributionTotalController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'ছাত্রসংবাদ বিতরণ (টি)', controller: _studentReviewDistributionTotalController, keyboardType: TextInputType.number)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'শুভাকাঙ্ক্ষী বৃদ্ধি (জন)', controller: _wellWisherIncreaseTotalController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'কার্ড/উপহার/SMS বিতরণ', controller: _cardGiftSmsEmailLetterMagazineTotalController, keyboardType: TextInputType.number)),
                        ],
                      ),
                      CustomLabeledInputField(label: 'শুভাকাঙ্ক্ষীদের নামসমূহ', controller: _wellWisherIncreaseNamesController, maxLines: 2),
                      CustomLabeledInputField(label: 'দলগত দাওয়াত (সংখ্যা)', controller: _groupDawahTotalController, keyboardType: TextInputType.number),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 4. Organizational Work Section
                  _buildSectionCard(
                    title: '৪. সাংগঠনিক কাজ (Organizational Work)',
                    icon: Icons.groups_rounded,
                    color: const Color(0xFF7C3AED),
                    children: [
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'কর্মী বৃদ্ধি (জন)', controller: _workerIncreaseTotalController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'সভায় যোগদান (টি)', controller: _meetingAttendanceTotalController, keyboardType: TextInputType.number)),
                        ],
                      ),
                      CustomLabeledInputField(label: 'নতুন কর্মীদের নামসমূহ', controller: _workerIncreaseNamesController, maxLines: 2),
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'বায়তুলমাল প্রদান (টাকা)', controller: _baytulmalPaidAmountController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'প্রদানের তারিখ', controller: _baytulmalPaidDateController)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'কর্মী যোগাযোগ (জন)', controller: _workerCommunicationTotalController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'সাংগঠনিক সময় (গড় ঘন্টা)', controller: _orgDawahTimeGivenAverageHoursController, keyboardType: TextInputType.number)),
                        ],
                      ),
                      CustomLabeledInputField(label: 'যোগাযোগকৃত কর্মীদের নামসমূহ', controller: _workerCommunicationNamesController, maxLines: 2),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 5. Miscellaneous Section
                  _buildSectionCard(
                    title: '৫. বিবিধ বিষয়াদি (Miscellaneous)',
                    icon: Icons.category_rounded,
                    color: const Color(0xFF0D9488),
                    children: [
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'পত্রিকা/সাময়িকী পাঠ (ঘন্টা)', controller: _dailyOtherMagazineReadingAverageHoursController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'শারীরিক চর্চা/ব্যায়াম (দিন)', controller: _physicalExerciseDaysController, keyboardType: TextInputType.number)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: CustomLabeledInputField(label: 'কম্পিউটার/কারিগরি (ঘন্টা)', controller: _technicalTimeGivenAverageHoursController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: CustomLabeledInputField(label: 'পারিবারিক/সামাজিক (ঘন্টা)', controller: _familySocialWorkTimeGivenAverageHoursController, keyboardType: TextInputType.number)),
                        ],
                      ),
                      CustomLabeledInputField(label: 'অন্যান্য তথ্য', controller: _miscellaneousOthersController, maxLines: 2),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 6. Supervisor Section
                  _buildSectionCard(
                    title: '৬. সংশ্লিষ্ট দায়িত্বশীলের মন্তব্য ও সিদ্ধান্ত',
                    icon: Icons.rate_review_rounded,
                    color: const Color(0xFFE11D48),
                    children: [
                      CustomLabeledInputField(label: 'সদস্য মানোন্নয়ন (সংখ্যা ও নাম)', controller: _promotedToMemberNamesController, maxLines: 2),
                      CustomLabeledInputField(label: 'সহযোগী সদস্য মানোন্নয়ন', controller: _promotedToAssociateMemberNamesController, maxLines: 2),
                      CustomLabeledInputField(label: 'দায়িত্বশীলের মন্তব্য ও পরামর্শ', controller: _meetingAdviceController, maxLines: 3),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006A4E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.check_circle_rounded),
                      label: const Text(
                        'রিপোর্ট জমা দিন (Submit Report)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}
