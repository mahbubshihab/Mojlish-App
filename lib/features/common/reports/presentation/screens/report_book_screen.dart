import 'package:flutter/material.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/report_download_screen.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/personal_report_table_screen.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/daily_entry_screen.dart';
import 'package:mojlish_app/features/common/reports/presentation/widgets/universal_report_book_widget.dart';

/// ব্যক্তিগত রিপোর্ট বই — বছর/মাস নেভিগেশন ও কাস্টম মাল্টি-মান্থ A4 PDF ডাউনলোড
class ReportBookScreen extends StatelessWidget {
  final MajlisType majlisType;

  const ReportBookScreen({super.key, this.majlisType = MajlisType.khelafat});

  String _getMajlisTitle() {
    switch (majlisType) {
      case MajlisType.khelafat:
        return 'খেলাফত মজলিস — ব্যক্তিগত রিপোর্ট বই';
      case MajlisType.chatro:
        return 'ছাত্র মজলিস — ব্যক্তিগত রিপোর্ট বই';
      case MajlisType.jubo:
        return 'যুব মজলিস — ব্যক্তিগত রিপোর্ট বই';
      case MajlisType.sromik:
        return 'শ্রমিক মজলিস — ব্যক্তিগত রিপোর্ট বই';
      case MajlisType.mohila:
        return 'মহিলা মজলিস — ব্যক্তিগত রিপোর্ট বই';
    }
  }

  Color _getMajlisColor() {
    switch (majlisType) {
      case MajlisType.khelafat:
        return const Color(0xFF10B981);
      case MajlisType.chatro:
        return const Color(0xFF006A4E);
      case MajlisType.jubo:
        return const Color(0xFF2563EB);
      case MajlisType.sromik:
        return const Color(0xFFD97706);
      case MajlisType.mohila:
        return const Color(0xFFDB2777);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getMajlisColor();

    return UniversalReportBookWidget(
      title: 'ব্যক্তিগত রিপোর্ট বই',
      cardTitle: 'ব্যক্তিগত রিপোর্ট',
      cardSubtitle: '${_getMajlisTitle()} (দৈনন্দিন আমল, ইবাদত ও দাওয়াতী তৎপরতার খতিয়ান)',
      icon: Icons.person_outline_rounded,
      accentColor: accentColor,
      onMonthSelected: (year, month) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PersonalReportTableScreen(
              year: year,
              month: month,
              majlisType: majlisType,
            ),
          ),
        );
      },
      onDownloadPressed: () {
        final now = DateTime.now();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReportDownloadScreen(
              majlisType: majlisType,
              initialYear: now.year,
              initialMonth: now.month,
            ),
          ),
        );
      },
      onTodayPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DailyEntryScreen(
              date: DateTime.now(),
              majlisType: majlisType,
            ),
          ),
        );
      },
    );
  }
}
