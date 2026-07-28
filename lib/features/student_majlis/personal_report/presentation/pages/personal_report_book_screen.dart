import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/personal_report_remote_data_source.dart';
import '../../data/repositories/personal_report_repository_impl.dart';
import '../bloc/personal_report_bloc.dart';
import '../../../common/widgets/staggered_month_grid_book.dart';
import 'personal_report_page.dart';

class PersonalReportBookScreen extends StatelessWidget {
  const PersonalReportBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredMonthGridBook(
      title: 'ব্যক্তিগত রিপোর্ট বই',
      subtitle: 'বাংলাদেশ ইসলামী ছাত্র মজলিস — ব্যক্তিগত তৎপরতার রিপোর্ট বই',
      primaryColor: const Color(0xFF059669),
      onMonthSelected: (String monthName, String year) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => PersonalReportBloc(
                repository: PersonalReportRepositoryImpl(
                  remoteDataSource: PersonalReportRemoteDataSourceImpl(),
                ),
              ),
              child: PersonalReportPage(
                initialMonth: monthName,
                initialYear: year,
              ),
            ),
          ),
        );
      },
    );
  }
}
