import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mojlish_app/features/student_majlis/period_plan/presentation/screens/period_plan_screen.dart';
import '../bloc/general_plan_bloc.dart';
import '../../data/datasources/general_plan_remote_datasource.dart';
import '../../data/repositories/general_plan_repository_impl.dart';

class GeneralPlanScreen extends StatelessWidget {
  const GeneralPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GeneralPlanBloc>(
      create: (_) => GeneralPlanBloc(
        repository: GeneralPlanRepositoryImpl(
          remoteDataSource: GeneralPlanRemoteDataSourceImpl(),
        ),
      ),
      child: const PeriodPlanScreen(),
    );
  }
}

