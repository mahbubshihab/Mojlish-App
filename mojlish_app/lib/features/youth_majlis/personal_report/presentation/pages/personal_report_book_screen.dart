import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/staggered_month_grid_book.dart';
import '../bloc/personal_report_bloc.dart';
import 'personal_report_page.dart';

class YouthPersonalReportBookScreen extends StatelessWidget {
  const YouthPersonalReportBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredMonthGridBook(
      title: 'ব্যক্তিগত রিপোর্ট বই (যুব মজলিস)',
      subtitle: 'ইসলামী যুব মজলিস — মাসিক ব্যক্তিগত তৎপরতার রিপোর্ট বই',
      primaryColor: const Color(0xFF2563EB),
      onMonthSelected: (String monthName, String year) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const YouthMajlisPersonalReportPage(),
          ),
        );
      },
    );
  }
}
