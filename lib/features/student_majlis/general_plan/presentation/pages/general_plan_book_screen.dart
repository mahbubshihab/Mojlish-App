import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/general_plan_remote_datasource.dart';
import '../../data/repositories/general_plan_repository_impl.dart';
import '../bloc/general_plan_bloc.dart';
import '../../../common/widgets/staggered_month_grid_book.dart';
import 'general_plan_screen.dart';

class GeneralPlanBookScreen extends StatelessWidget {
  const GeneralPlanBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredMonthGridBook(
      title: 'সাধারণ পরিকল্পনা বই',
      subtitle: 'বাংলাদেশ ইসলামী ছাত্র মজলিস — সাধারণ পরিকল্পনা',
      primaryColor: const Color(0xFF0D9488),
      onMonthSelected: (String monthName, String year) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => GeneralPlanBloc(
                repository: GeneralPlanRepositoryImpl(
                  remoteDataSource: GeneralPlanRemoteDataSourceImpl(),
                ),
              ),
              child: GeneralPlanScreen(
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
