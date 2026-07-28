import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/personal_report.dart';
import '../bloc/personal_report_bloc.dart';
import '../bloc/personal_report_event.dart';
import '../bloc/personal_report_state.dart';

class YouthMajlisPersonalReportPage extends StatefulWidget {
  const YouthMajlisPersonalReportPage({Key? key}) : super(key: key);

  @override
  _YouthMajlisPersonalReportPageState createState() => _YouthMajlisPersonalReportPageState();
}

class _YouthMajlisPersonalReportPageState extends State<YouthMajlisPersonalReportPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _memberType = 'কর্মী';
  String _branch = '';
  String _month = '';
  String _year = '';

  int _totalMeetingsAttended = 0;
  String _meetingNames = '';
  String _supervisorComments = '';
  String _branchOfficialName = '';

  final List<YouthMajlisDailyActivity> _dailyActivities = List.generate(
    31,
    (index) => YouthMajlisDailyActivity(
      day: index + 1,
      jamatNamazCount: 0,
      quranSurah: '',
      quranAyat: '',
      hadithCount: 0,
      hadithTopic: '',
      islamicLiteratureName: '',
      islamicLiteraturePageCount: 0,
      workerCommunicationCount: 0,
      workerCommunicationNames: '',
      dawatCount: 0,
      dawatNames: '',
      timeGivenHours: 0.0,
      jobBusinessTimeGivenHours: 0.0,
      selfCriticism: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('মাসিক ব্যক্তিগত তৎপরতার রিপোর্ট'),
      ),
      body: BlocConsumer<YouthMajlisPersonalReportBloc, YouthMajlisPersonalReportState>(
        listener: (context, state) {
          if (state is PersonalReportSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report saved successfully')),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(),
                  const SizedBox(height: 24),
                  const Text('দৈনিক কার্যক্রম (Daily Activities)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildDailyActivitiesTable(),
                  const SizedBox(height: 24),
                  _buildFooterInfo(),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        final report = YouthMajlisPersonalReport(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: _name,
                          memberType: _memberType,
                          branch: _branch,
                          month: _month,
                          year: _year,
                          dailyActivities: _dailyActivities,
                          totalMeetingsAttended: _totalMeetingsAttended,
                          meetingNames: _meetingNames,
                          supervisorComments: _supervisorComments,
                          branchOfficialName: _branchOfficialName,
                          createdAt: DateTime.now(),
                        );
                        context
                            .read<YouthMajlisPersonalReportBloc>()
                            .add(SavePersonalReportEvent(report: report));
                      }
                    },
                    child: const Text('Submit Report'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'নাম (Name)'),
          onSaved: (val) => _name = val ?? '',
        ),
        DropdownButtonFormField<String>(
          value: _memberType,
          items: const [
            DropdownMenuItem(value: 'প্রঃ সদস্য', child: Text('প্রঃ সদস্য')),
            DropdownMenuItem(value: 'কর্মী', child: Text('কর্মী')),
            DropdownMenuItem(value: 'শূরা সদস্য', child: Text('শূরা সদস্য')),
          ],
          onChanged: (val) {
            setState(() {
              _memberType = val ?? 'কর্মী';
            });
          },
          decoration: const InputDecoration(labelText: 'সদস্য ধরণ'),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'শাখা (Branch)'),
          onSaved: (val) => _branch = val ?? '',
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'মাস (Month)'),
                onSaved: (val) => _month = val ?? '',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'সন (Year)'),
                onSaved: (val) => _year = val ?? '',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDailyActivitiesTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('তাং')),
          DataColumn(label: Text('জামাতে নামাজ')),
          DataColumn(label: Text('কোরআন অধ্যয়ন')),
          DataColumn(label: Text('হাদীস অধ্যয়ন')),
          DataColumn(label: Text('ইসলামী সাহিত্য')),
          DataColumn(label: Text('কর্মী যোগাযোগ')),
          DataColumn(label: Text('দাওয়াত কত জন')),
          DataColumn(label: Text('সময় দান')),
          DataColumn(label: Text('চাকুরি/ব্যাবসা সময়')),
          DataColumn(label: Text('আত্ম-সমালোচনা')),
        ],
        rows: List.generate(31, (index) {
          final day = index + 1;
          return DataRow(
            cells: [
              DataCell(Text('$day')),
              DataCell(SizedBox(
                width: 60,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onSaved: (val) {
                    // Update specific field inside _dailyActivities[index]
                    // (Omitted detailed copyWith logic for brevity, assuming immutable copy logic here)
                  },
                ),
              )),
              DataCell(SizedBox(
                width: 100,
                child: TextFormField(
                  decoration: const InputDecoration(hintText: 'সূরা, আয়াত'),
                  onSaved: (val) {},
                ),
              )),
              DataCell(SizedBox(
                width: 100,
                child: TextFormField(
                  decoration: const InputDecoration(hintText: 'সংখ্যা, বিষয়'),
                  onSaved: (val) {},
                ),
              )),
              DataCell(SizedBox(
                width: 100,
                child: TextFormField(
                  decoration: const InputDecoration(hintText: 'পাঠ, নাম পৃষ্ঠা'),
                  onSaved: (val) {},
                ),
              )),
              DataCell(SizedBox(
                width: 100,
                child: TextFormField(
                  decoration: const InputDecoration(hintText: 'সংখ্যা, নাম'),
                  onSaved: (val) {},
                ),
              )),
              DataCell(SizedBox(
                width: 100,
                child: TextFormField(
                  decoration: const InputDecoration(hintText: 'নাম'),
                  onSaved: (val) {},
                ),
              )),
              DataCell(SizedBox(
                width: 60,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onSaved: (val) {},
                ),
              )),
              DataCell(SizedBox(
                width: 60,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onSaved: (val) {},
                ),
              )),
              DataCell(SizedBox(
                width: 60,
                child: DropdownButtonFormField<bool>(
                  value: true,
                  items: const [
                    DropdownMenuItem(value: true, child: Text('হ্যাঁ')),
                    DropdownMenuItem(value: false, child: Text('না')),
                  ],
                  onChanged: (val) {},
                ),
              )),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFooterInfo() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'সভায় যোগদান মোট (টি)'),
                keyboardType: TextInputType.number,
                onSaved: (val) => _totalMeetingsAttended = int.tryParse(val ?? '0') ?? 0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'সভার নাম'),
                onSaved: (val) => _meetingNames = val ?? '',
              ),
            ),
          ],
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'উর্ধ্বতন দায়িত্বশীলের মন্তব্য ও পরামর্শ'),
          maxLines: 2,
          onSaved: (val) => _supervisorComments = val ?? '',
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'শাখা দায়িত্বশীলের নাম'),
          onSaved: (val) => _branchOfficialName = val ?? '',
        ),
      ],
    );
  }
}
