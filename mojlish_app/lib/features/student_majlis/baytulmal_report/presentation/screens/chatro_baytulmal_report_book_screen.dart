import 'package:flutter/material.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_download_screen.dart';
import 'package:mojlish_app/features/common/reports/presentation/widgets/universal_report_book_widget.dart';
import 'baytulmal_report_screen.dart';

/// ছাত্র মজলিস — বায়তুলমাল রিপোর্ট বই
class ChatroBaytulmalReportBookScreen extends StatelessWidget {
  const ChatroBaytulmalReportBookScreen({super.key});

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
  ];

  @override
  Widget build(BuildContext context) {
    return UniversalReportBookWidget(
      title: 'বায়তুলমাল রিপোর্ট বই',
      cardTitle: 'বায়তুলমাল রিপোর্ট',
      cardSubtitle: 'ছাত্র মজলিসের মাসিক এয়ানত, আয়, ব্যয় ও বায়তুলমাল হিসাব',
      icon: Icons.account_balance_wallet_rounded,
      accentColor: const Color(0xFFD97706),
      onMonthSelected: (year, month) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BaytulmalReportScreen(
              initialMonth: _monthNames[month - 1],
              initialSession: year.toString(),
            ),
          ),
        );
      },
      onDownloadPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReportDownloadScreen(
              majlisType: MajlisType.chatro,
              initialYear: DateTime.now().year,
              initialMonth: DateTime.now().month,
              reportCategory: ReportCategory.baytulmalReport,
            ),
          ),
        );
      },
    );
  }
}
