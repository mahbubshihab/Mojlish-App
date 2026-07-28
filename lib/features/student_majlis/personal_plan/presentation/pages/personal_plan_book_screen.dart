import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/personal_plan_remote_data_source.dart';
import '../../data/repositories/personal_plan_repository_impl.dart';
import '../bloc/personal_plan_bloc.dart';
import '../../../common/widgets/staggered_month_grid_book.dart';
import 'personal_plan_page.dart';

class PersonalPlanBookScreen extends StatelessWidget {
  const PersonalPlanBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredMonthGridBook(
      title: 'ব্যক্তিগত পরিকল্পনা বই',
      subtitle: 'বাংলাদেশ ইসলামী ছাত্র মজলিস — ব্যক্তিগত মাসিক পরিকল্পনা বই',
      primaryColor: const Color(0xFF7C3AED),
      onMonthSelected: (String monthName, String year) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => PersonalPlanBloc(
                repository: PersonalPlanRepositoryImpl(
                  remoteDataSource: PersonalPlanRemoteDataSourceImpl(),
                ),
              ),
              child: PersonalPlanPage(
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
