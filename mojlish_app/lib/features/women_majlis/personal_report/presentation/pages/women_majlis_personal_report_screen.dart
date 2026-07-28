import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/women_majlis_personal_report_bloc.dart';
import '../bloc/women_majlis_personal_report_event.dart';
import '../bloc/women_majlis_personal_report_state.dart';
import '../../data/datasources/women_majlis_personal_report_remote_data_source.dart';
import '../../data/repositories/women_majlis_personal_report_repository_impl.dart';

class WomenMajlisPersonalReportScreen extends StatelessWidget {
  const WomenMajlisPersonalReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WomenMajlisPersonalReportBloc(
        repository: WomenMajlisPersonalReportRepositoryImpl(
          remoteDataSource: WomenMajlisPersonalReportRemoteDataSourceImpl(),
        ),
      )..add(LoadWomenMajlisPersonalReport()),
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
          TextFormField(
            initialValue: state.report.workerName,
            decoration: const InputDecoration(labelText: 'কর্মীর নাম'),
          ),
          TextFormField(
            initialValue: state.report.branch,
            decoration: const InputDecoration(labelText: 'শাখা'),
          ),
          TextFormField(
            initialValue: state.report.month,
            decoration: const InputDecoration(labelText: 'মাস'),
          ),
          TextFormField(
            initialValue: state.report.year,
            decoration: const InputDecoration(labelText: 'সন'),
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
          TextFormField(
            initialValue: state.report.meetingsAttendedThisMonth.toString(),
            decoration: const InputDecoration(labelText: 'এ মাসে সভায় যোগদান (টি)'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            initialValue: state.report.meetingName,
            decoration: const InputDecoration(labelText: 'সভার নাম'),
          ),
          TextFormField(
            initialValue: state.report.branchResponsibleComment,
            decoration: const InputDecoration(labelText: 'শাখা দায়িত্বশীলের মন্তব্য ও পরামর্শ'),
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
