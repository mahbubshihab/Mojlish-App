import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/custom_labeled_input_field.dart';
import '../bloc/personal_report_bloc.dart';
import '../bloc/personal_report_event.dart';
import '../bloc/personal_report_state.dart';
import '../../domain/entities/personal_report.dart';

class PersonalReportPage extends StatefulWidget {
  const PersonalReportPage({Key? key}) : super(key: key);

  @override
  State<PersonalReportPage> createState() => _PersonalReportPageState();
}

class _PersonalReportPageState extends State<PersonalReportPage> {
  final TextEditingController _workerNameController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  
  final TextEditingController _meetingsAttendedController = TextEditingController();
  final TextEditingController _meetingNamesController = TextEditingController();
  final TextEditingController _branchResponsibleCommentsController = TextEditingController();

  List<DailyActivity> _dailyActivities = [];

  @override
  void initState() {
    super.initState();
    // Initialize 31 days
    for (int i = 1; i <= 31; i++) {
      _dailyActivities.add(DailyActivity(
        date: i,
        quranStudySurahAyat: '',
        hadithStudyNumberSubject: '',
        islamicLiteratureNamePage: '',
        jamaatNamazWaqt: '',
        communicationNumberName: '',
        dawatNumberName: '',
        meetingAttendanceNumber: '',
        timeGivenHours: '',
        socialServiceKind: '',
        selfCriticismYesNo: false,
      ));
    }
  }

  void _saveReport() {
    final report = PersonalReport(
      workerName: _workerNameController.text,
      branch: _branchController.text,
      month: _monthController.text,
      year: _yearController.text,
      dailyActivities: _dailyActivities,
      meetingsAttendedThisMonth: _meetingsAttendedController.text,
      meetingNames: _meetingNamesController.text,
      branchResponsibleComments: _branchResponsibleCommentsController.text,
    );

    context.read<PersonalReportBloc>().add(SavePersonalReportEvent(report: report));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ব্যক্তিগত তৎপরতার রিপোর্ট'),
      ),
      body: BlocConsumer<PersonalReportBloc, PersonalReportState>(
        listener: (context, state) {
          if (state is PersonalReportSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report Saved Successfully')),
            );
          } else if (state is PersonalReportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is PersonalReportLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderFields(),
                const SizedBox(height: 20),
                _buildActivitiesTable(),
                const SizedBox(height: 20),
                _buildFooterFields(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveReport,
                  child: const Text('Save Report'),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderFields() {
    return Column(
      children: [
        CustomLabeledInputField(
          label: 'কর্মীর নাম',
          controller: _workerNameController,
        ),
        CustomLabeledInputField(
          label: 'শাখা',
          controller: _branchController,
        ),
        Row(
          children: [
            Expanded(
              child: CustomLabeledInputField(
                label: 'মাস',
                controller: _monthController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomLabeledInputField(
                label: 'সন',
                controller: _yearController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivitiesTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('তারিখ')),
          DataColumn(label: Text('কোরআন অধ্যয়ন\n(সূরা, আয়াত)')),
          DataColumn(label: Text('হাদীস অধ্যয়ন\n(সংখ্যা, বিষয়)')),
          DataColumn(label: Text('ইসলামী সাহিত্য পাঠ\n(নাম, পৃষ্ঠা)')),
          DataColumn(label: Text('জামাতে নামাজ\n(কত ওয়াক্ত)')),
          DataColumn(label: Text('যোগাযোগ\n(সংখ্যা, নাম)')),
          DataColumn(label: Text('দাওয়াত কত জন\n(নাম)')),
          DataColumn(label: Text('সভা/বৈঠকে\nযোগদান সংখ্যা')),
          DataColumn(label: Text('সময় দান\n(কত ঘন্টা)')),
          DataColumn(label: Text('সমাজ সেবা\n(কি ধরনের)')),
          DataColumn(label: Text('আত্ম-সমালোচনা\n(হ্যাঁ/না)')),
        ],
        rows: _dailyActivities.map((activity) {
          int index = _dailyActivities.indexOf(activity);
          return DataRow(cells: [
            DataCell(Text(activity.date.toString())),
            DataCell(TextFormField(
              initialValue: activity.quranStudySurahAyat,
              onChanged: (val) => _dailyActivities[index] = _dailyActivities[index].copyWith(quranStudySurahAyat: val),
            )),
            DataCell(TextFormField(
              initialValue: activity.hadithStudyNumberSubject,
              onChanged: (val) => _dailyActivities[index] = _dailyActivities[index].copyWith(hadithStudyNumberSubject: val),
            )),
            DataCell(TextFormField(
              initialValue: activity.islamicLiteratureNamePage,
              onChanged: (val) => _dailyActivities[index] = _dailyActivities[index].copyWith(islamicLiteratureNamePage: val),
            )),
            DataCell(TextFormField(
              initialValue: activity.jamaatNamazWaqt,
              onChanged: (val) => _dailyActivities[index] = _dailyActivities[index].copyWith(jamaatNamazWaqt: val),
            )),
            DataCell(TextFormField(
              initialValue: activity.communicationNumberName,
              onChanged: (val) => _dailyActivities[index] = _dailyActivities[index].copyWith(communicationNumberName: val),
            )),
            DataCell(TextFormField(
              initialValue: activity.dawatNumberName,
              onChanged: (val) => _dailyActivities[index] = _dailyActivities[index].copyWith(dawatNumberName: val),
            )),
            DataCell(TextFormField(
              initialValue: activity.meetingAttendanceNumber,
              onChanged: (val) => _dailyActivities[index] = _dailyActivities[index].copyWith(meetingAttendanceNumber: val),
            )),
            DataCell(TextFormField(
              initialValue: activity.timeGivenHours,
              onChanged: (val) => _dailyActivities[index] = _dailyActivities[index].copyWith(timeGivenHours: val),
            )),
            DataCell(TextFormField(
              initialValue: activity.socialServiceKind,
              onChanged: (val) => _dailyActivities[index] = _dailyActivities[index].copyWith(socialServiceKind: val),
            )),
            DataCell(Switch(
              value: activity.selfCriticismYesNo,
              onChanged: (val) {
                setState(() {
                  _dailyActivities[index] = _dailyActivities[index].copyWith(selfCriticismYesNo: val);
                });
              },
            )),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildFooterFields() {
    return Column(
      children: [
        Row(
          children: [
            const Text('এ মাসে সভায় যোগদান '),
            Expanded(
              child: TextField(
                controller: _meetingsAttendedController,
                decoration: const InputDecoration(isDense: true),
              ),
            ),
            const Text(' টি, সভার নাম: '),
            Expanded(
              flex: 2,
              child: TextField(
                controller: _meetingNamesController,
                decoration: const InputDecoration(isDense: true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomLabeledInputField(
          label: 'শাখা দায়িত্বশীলের মন্তব্য ও পরামর্শ',
          controller: _branchResponsibleCommentsController,
          maxLines: 3,
        ),
      ],
    );
  }
}

extension DailyActivityCopyWith on DailyActivity {
  DailyActivity copyWith({
    int? date,
    String? quranStudySurahAyat,
    String? hadithStudyNumberSubject,
    String? islamicLiteratureNamePage,
    String? jamaatNamazWaqt,
    String? communicationNumberName,
    String? dawatNumberName,
    String? meetingAttendanceNumber,
    String? timeGivenHours,
    String? socialServiceKind,
    bool? selfCriticismYesNo,
  }) {
    return DailyActivity(
      date: date ?? this.date,
      quranStudySurahAyat: quranStudySurahAyat ?? this.quranStudySurahAyat,
      hadithStudyNumberSubject: hadithStudyNumberSubject ?? this.hadithStudyNumberSubject,
      islamicLiteratureNamePage: islamicLiteratureNamePage ?? this.islamicLiteratureNamePage,
      jamaatNamazWaqt: jamaatNamazWaqt ?? this.jamaatNamazWaqt,
      communicationNumberName: communicationNumberName ?? this.communicationNumberName,
      dawatNumberName: dawatNumberName ?? this.dawatNumberName,
      meetingAttendanceNumber: meetingAttendanceNumber ?? this.meetingAttendanceNumber,
      timeGivenHours: timeGivenHours ?? this.timeGivenHours,
      socialServiceKind: socialServiceKind ?? this.socialServiceKind,
      selfCriticismYesNo: selfCriticismYesNo ?? this.selfCriticismYesNo,
    );
  }
}
