import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/staggered_month_grid_book.dart';
import '../bloc/personal_report_bloc.dart';
import '../bloc/personal_report_event.dart';
import '../../data/datasources/personal_report_datasource.dart';
import '../../data/repositories/personal_report_repository_impl.dart';
import 'personal_report_page.dart';

class KhelafatPersonalReportBookScreen extends StatelessWidget {
  const KhelafatPersonalReportBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredMonthGridBook(
      title: 'ব্যক্তিগত রিপোর্ট বই (খেলাফত মজলিস)',
      subtitle: 'খেলাফত মজলিস — মাসিক ব্যক্তিগত তৎপরতার রিপোর্ট বই',
      primaryColor: const Color(0xFF1B5E20),
      onMonthSelected: (String monthName, String year) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => PersonalReportBloc(
                repository: PersonalReportRepositoryImpl(
                  dataSource: PersonalReportDataSourceImpl(),
                ),
              )..add(LoadPersonalReportEvent(month: monthName, year: year)),
              child: const PersonalReportPage(),
            ),
          ),
        );
      },
    );
  }
}
