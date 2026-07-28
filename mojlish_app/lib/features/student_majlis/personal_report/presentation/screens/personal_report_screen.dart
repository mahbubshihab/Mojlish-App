import 'package:flutter/material.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_book_screen.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';

class StudentPersonalReportScreen extends StatelessWidget {
  const StudentPersonalReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReportBookScreen(majlisType: MajlisType.chatro);
  }
}
