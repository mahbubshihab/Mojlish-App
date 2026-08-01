import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/period_report_remote_datasource.dart';
import '../../data/repositories/period_report_repository_impl.dart';
import 'bloc/period_report_bloc.dart';
import '../../../../common/widgets/staggered_month_grid_book.dart';
import 'period_report_page.dart';

class PeriodReportBookScreen extends StatelessWidget {
  const PeriodReportBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredMonthGridBook(
      title: 'পর্যায়ভিত্তিক রিপোর্ট বই',
      subtitle: 'বাংলাদেশ ইসলামী ছাত্র মজলিস — পর্যায়ভিত্তিক রিপোর্ট (মেয়াদী)',
      primaryColor: const Color(0xFF0284C7),
      onMonthSelected: (String monthName, String year) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => PeriodReportBloc(
                repository: PeriodReportRepositoryImpl(
                  remoteDataSource: PeriodReportRemoteDataSourceImpl(),
                ),
              ),
              child: PeriodReportPage(
                initialMonth: monthName,
                initialSession: year,
              ),
            ),
          ),
        );
      },
    );
  }
}
