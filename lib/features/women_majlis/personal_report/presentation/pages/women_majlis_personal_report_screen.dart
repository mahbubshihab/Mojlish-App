import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/widgets/custom_labeled_input_field.dart';
import '../bloc/women_majlis_personal_report_bloc.dart';
import '../bloc/women_majlis_personal_report_event.dart';
import '../bloc/women_majlis_personal_report_state.dart';
import '../../../../core/di/injection_container.dart';

class WomenMajlisPersonalReportScreen extends StatelessWidget {
  const WomenMajlisPersonalReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WomenMajlisPersonalReportBloc>()..add(LoadWomenMajlisPersonalReport()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('মহিলা মজলিস ব্যক্তিগত রিপোর্ট'),
        ),
        body: BlocConsumer<WomenMajlisPersonalReportBloc, WomenMajlisPersonalReportState>(
          listener: (context, state) {
            if (state is WomenMajlisPersonalReportSaved) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report saved successfully')),
              );
            } else if (state is WomenMajlisPersonalReportError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is WomenMajlisPersonalReportLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WomenMajlisPersonalReportLoaded) {
              return _buildForm(context, state);
            }
            return const Center(child: Text('Press refresh to load'));
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, WomenMajlisPersonalReportLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomLabeledInputField(
            label: 'কর্মীর নাম',
            initialValue: state.report.workerName,
          ),
          CustomLabeledInputField(
            label: 'শাখা',
            initialValue: state.report.branch,
          ),
          CustomLabeledInputField(
            label: 'মাস',
            initialValue: state.report.month,
          ),
          CustomLabeledInputField(
            label: 'সন',
            initialValue: state.report.year,
          ),
          const SizedBox(height: 20),
          const Text('দৈনিক রিপোর্ট', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('তারিখ')),
                DataColumn(label: Text('কোরআন অধ্যয়ন')),
                DataColumn(label: Text('হাদীস অধ্যয়ন')),
                DataColumn(label: Text('ইসলামী সাহিত্য পাঠ')),
                DataColumn(label: Text('যোগাযোগ')),
                DataColumn(label: Text('দাওয়াত')),
                DataColumn(label: Text('সভায় যোগদান')),
                DataColumn(label: Text('সময় দান (ঘন্টা)')),
                DataColumn(label: Text('সমাজ সেবা')),
                DataColumn(label: Text('আত্ম সমালোচনা')),
              ],
              rows: state.report.dailyEntries.map((entry) {
                return DataRow(cells: [
                  DataCell(Text(entry.date.toString())),
                  DataCell(Text(entry.quranStudy)),
                  DataCell(Text(entry.hadithStudy)),
                  DataCell(Text(entry.islamicLiteratureReading)),
                  DataCell(Text(entry.contact)),
                  DataCell(Text(entry.dawah)),
                  DataCell(Text(entry.meetingAttendance)),
                  DataCell(Text(entry.timeGivenHours.toString())),
                  DataCell(Text(entry.socialService)),
                  DataCell(Text(entry.selfCriticism ? 'হ্যাঁ' : 'না')),
                ]);
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          CustomLabeledInputField(
            label: 'এ মাসে সভায় যোগদান (টি)',
            initialValue: state.report.meetingsAttendedThisMonth.toString(),
            keyboardType: TextInputType.number,
          ),
          CustomLabeledInputField(
            label: 'সভার নাম',
            initialValue: state.report.meetingName,
          ),
          CustomLabeledInputField(
            label: 'শাখা দায়িত্বশীলের মন্তব্য ও পরামর্শ',
            initialValue: state.report.branchResponsibleComment,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
            },
            child: const Text('Save Report'),
          ),
        ],
      ),
    );
  }
}
