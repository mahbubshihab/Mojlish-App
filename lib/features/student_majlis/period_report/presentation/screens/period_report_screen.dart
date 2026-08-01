import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/period_report_remote_datasource.dart';
import '../../data/repositories/period_report_repository_impl.dart';
import '../bloc/period_report_bloc.dart';
import '../pages/period_report_page.dart';
export '../pages/period_report_page.dart';

/// Screen alias for PeriodReportPage
class PeriodReportScreen extends StatelessWidget {
  final String? initialMonth;
  final String? initialSession;

  const PeriodReportScreen({
    super.key,
    this.initialMonth,
    this.initialSession,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PeriodReportBloc(
        repository: PeriodReportRepositoryImpl(
          remoteDataSource: PeriodReportRemoteDataSourceImpl(),
        ),
      ),
      child: PeriodReportPage(
        initialMonth: initialMonth,
        initialSession: initialSession,
      ),
    );
  }
}

