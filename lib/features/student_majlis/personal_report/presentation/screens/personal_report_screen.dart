import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/presentation/bloc/personal_report_bloc.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/presentation/bloc/personal_report_event.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/presentation/bloc/personal_report_state.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/domain/entities/personal_report_entity.dart';

class PersonalReportPage extends StatefulWidget {
  const PersonalReportPage({super.key});

  @override
  State<PersonalReportPage> createState() => _PersonalReportPageState();
}

class _PersonalReportPageState extends State<PersonalReportPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Example controller for one of the fields
  final TextEditingController _quranTotalAyatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PersonalReportBloc>().add(const LoadPersonalReport(month: 'January', year: '2026'));
  }

  @override
  void dispose() {
    _quranTotalAyatController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create a dummy report entity for submission
      final report = PersonalReportEntity(
        id: '1',
        month: 'January',
        year: '2026',
        quranTotalAyat: int.tryParse(_quranTotalAyatController.text) ?? 0,
        quranDays: 0,
        quranSurah: '',
        quranAverage: 0,
        darsPreparationTotal: 0,
        darsPreparationSubject: '',
        darsPreparationMemorizedAyat: 0,
        hadithTotal: 0,
        hadithDays: 0,
        hadithBook: '',
        hadithAverage: 0,
        darsPreparationHadithTotal: 0,
        darsPreparationHadithSubject: '',
        darsPreparationHadithMemorized: 0,
        darsPreparationHadithMemorizedSubject: '',
        islamicLiteratureTotalPages: 0,
        islamicLiteratureDays: 0,
        islamicLiteratureAverage: 0,
        islamicLiteratureBookName: '',
        islamicLiteratureNotePages: 0,
        textbookClassAttendanceTotal: 0,
        textbookClassAttendanceHours: 0,
        textbookClassAttendanceDays: 0,
        textbookClassAttendanceAverage: 0,
        jamatNamazTotal: 0,
        selfAssessmentDays: 0,
        friendIncreaseTotal: 0,
        friendIncreaseNames: '',
        primaryMemberIncreaseTotal: 0,
        primaryMemberIncreaseNames: '',
        bookDistributionTotal: 0,
        studentReviewDistributionTotal: 0,
        wellWisherIncreaseTotal: 0,
        wellWisherIncreaseNames: '',
        cardGiftSmsEmailLetterMagazineTotal: 0,
        groupDawahTotal: 0,
        otherDawahMaterials: '',
        workerIncreaseTotal: 0,
        workerIncreaseNames: '',
        meetingAttendanceTotal: 0,
        orgDawahTimeGivenAverageHours: 0,
        baytulmalPaidAmount: 0.0,
        baytulmalPaidDate: '',
        workerCommunicationTotal: 0,
        workerCommunicationNames: '',
        dailyOtherMagazineReadingAverageHours: 0,
        physicalExerciseDays: 0,
        technicalComputerLanguageTimeGivenAverageHours: 0,
        familySocialWorkTimeGivenAverageHours: 0,
        miscellaneousOthers: '',
        promotedToMemberTotal: 0,
        promotedToMemberNames: '',
        promotedToAssociateMemberTotal: 0,
        promotedToAssociateMemberNames: '',
        meetingAdvice: '',
      );

      context.read<PersonalReportBloc>().add(SubmitPersonalReport(report: report));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ব্যক্তিগত মাসিক রিপোর্ট'),
      ),
      body: BlocConsumer<PersonalReportBloc, PersonalReportState>(
        listener: (context, state) {
          if (state is PersonalReportSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report submitted successfully!')),
            );
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
          if (state is PersonalReportLoaded) {
            _quranTotalAyatController.text = state.report.quranTotalAyat.toString();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('অধ্যয়ন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _quranTotalAyatController,
                    decoration: const InputDecoration(
                      labelText: 'কুরআন: মোট আয়াত',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  // Additional form fields for all the entity fields would be added here
                  const Text('(Form continues with other sections...)'),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Submit Report'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
