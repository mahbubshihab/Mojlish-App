import 'package:flutter/material.dart';
import '../../../../common/widgets/staggered_month_grid_book.dart';
import 'women_majlis_personal_report_screen.dart';

class WomenMajlisPersonalReportBookScreen extends StatelessWidget {
  const WomenMajlisPersonalReportBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredMonthGridBook(
      title: 'ব্যক্তিগত রিপোর্ট বই (মহিলা মজলিস)',
      subtitle: 'মহিলা মজলিস — মাসিক ব্যক্তিগত তৎপরতার রিপোর্ট বই',
      primaryColor: const Color(0xFFDB2777),
      onMonthSelected: (String monthName, String year) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WomenMajlisPersonalReportScreen(),
          ),
        );
      },
    );
  }
}
