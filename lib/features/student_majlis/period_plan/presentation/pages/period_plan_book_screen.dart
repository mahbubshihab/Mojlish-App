import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/period_plan_datasource.dart';
import '../../data/repositories/period_plan_repository_impl.dart';
import '../bloc/period_plan_bloc.dart';
import '../../../../common/widgets/staggered_month_grid_book.dart';
import 'period_plan_page.dart';

class PeriodPlanBookScreen extends StatelessWidget {
  const PeriodPlanBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StaggeredMonthGridBook(
      title: 'পর্যায়ভিত্তিক পরিকল্পনা বই',
      subtitle: 'বাংলাদেশ ইসলামী ছাত্র মজলিস — পর্যায়ভিত্তিক পরিকল্পনা (মেয়াদী)',
      primaryColor: const Color(0xFF2563EB),
      onMonthSelected: (String monthName, String year) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => PeriodPlanBloc(
                repository: PeriodPlanRepositoryImpl(
                  dataSource: PeriodPlanDataSourceImpl(),
                ),
              ),
              child: PeriodPlanPage(
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
