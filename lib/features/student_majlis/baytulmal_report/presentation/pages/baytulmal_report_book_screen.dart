import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/baytulmal_report_remote_datasource.dart';
import '../../data/repositories/baytulmal_report_repository_impl.dart';
import '../bloc/baytulmal_report_bloc.dart';
import '../../../common/widgets/staggered_month_grid_book.dart';
import 'baytulmal_report_page.dart';

class BaytulmalReportBookScreen extends StatelessWidget {
  const BaytulmalReportBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredMonthGridBook(
      title: 'বায়তুলমাল রিপোর্ট বই',
      subtitle: 'বাংলাদেশ ইসলামী ছাত্র মজলিস — বায়তুলমাল হিসাব ও রিপোর্ট',
      primaryColor: const Color(0xFF006A4E),
      onMonthSelected: (String monthName, String year) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => BaytulmalReportBloc(
                repository: BaytulmalReportRepositoryImpl(
                  remoteDataSource: BaytulmalReportRemoteDataSourceImpl(),
                ),
              ),
              child: BaytulmalReportPage(
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
