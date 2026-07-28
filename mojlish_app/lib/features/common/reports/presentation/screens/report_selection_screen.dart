import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';

import 'report_book_screen.dart';

// Import screens for direct entry
import 'package:mojlish_app/features/student_majlis/member_form/presentation/screens/member_form_screen.dart' as student_member;
import 'package:mojlish_app/features/student_majlis/personal_report/presentation/screens/personal_report_screen.dart' as student_personal;
import 'package:mojlish_app/features/student_majlis/baytulmal_report/presentation/screens/baytulmal_report_screen.dart' as student_baytulmal;

import 'package:mojlish_app/features/youth_majlis/member_form/presentation/screens/member_form_screen.dart' as youth_member;
import 'package:mojlish_app/features/youth_majlis/personal_report/presentation/screens/personal_report_screen.dart' as youth_personal;

import 'package:mojlish_app/features/khelafat_majlis/member_form/presentation/screens/member_form_screen.dart' as khelafat_member;
import 'package:mojlish_app/features/khelafat_majlis/personal_report/presentation/screens/personal_report_screen.dart' as khelafat_personal;
import 'package:mojlish_app/features/khelafat_majlis/branch_report/presentation/screens/branch_report_screen.dart' as khelafat_branch;
import 'package:mojlish_app/features/khelafat_majlis/baytulmal_report/presentation/screens/baytulmal_report_screen.dart' as khelafat_baytulmal;

import 'package:mojlish_app/features/reports/personal_report/presentation/screens/personal_report_screen.dart';
import 'package:mojlish_app/features/reports/personal_report/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/women_majlis/personal_report/presentation/screens/personal_report_screen.dart' as women_personal;
import 'package:mojlish_app/core/services/user_storage_service.dart';

/// Common Central Report & Forms Selection Screen — Shows ONLY Selected Majlis Reports
class ReportSelectionScreen extends StatefulWidget {
  final String? majlisName;

  const ReportSelectionScreen({super.key, this.majlisName});

  @override
  State<ReportSelectionScreen> createState() => _ReportSelectionScreenState();
}

class _ReportSelectionScreenState extends State<ReportSelectionScreen> {
  String activeMajlis = 'খেলাফত মজলিস';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMajlis();
  }

  Future<void> _loadMajlis() async {
    if (widget.majlisName != null && widget.majlisName!.isNotEmpty) {
      setState(() {
        activeMajlis = widget.majlisName!;
        _isLoading = false;
      });
    } else {
      final saved = await UserStorageService.getSelectedMajlis();
      if (mounted) {
        setState(() {
          activeMajlis = saved;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;
        final bgColor = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
        final textColor = isDark ? Colors.white : AppTheme.textDark;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF162032) : Colors.white,
            elevation: 0,
            title: Text(
              '$activeMajlis — রিপোর্ট কেন্দ্র',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                onPressed: () => themeManager.toggleTheme(),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF059669), Color(0xFF047857)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$activeMajlis — রিপোর্ট বই ও ফরম',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'ফরম নির্বাচন করুন। ভেতরের প্রিভিউ সেকশন থেকে PDF ডাউনলোড করতে পারবেন।',
                            style: TextStyle(fontSize: 13, color: Color(0xFFA7F3D0)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Report & Form Cards according to selected Majlis
                    if (activeMajlis == 'খেলাফত মজলিস') ...[
                      _buildReportItem(
                        context,
                        title: 'ব্যক্তিগত রিপোর্ট বই',
                        subtitle: '৩১ দিনের দৈনন্দিন তৎপরতা ও আমলের রিপোর্ট',
                        icon: Icons.person_outline_rounded,
                        color: const Color(0xFFDC2626),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PersonalReportScreen(
                              year: DateTime.now().year,
                              month: DateTime.now().month,
                              majlisType: MajlisType.khelafat,
                            ),
                          ),
                        ),
                      ),
                      _buildReportItem(
                        context,
                        title: 'প্রাথমিক সদস্য ফরম',
                        subtitle: 'সদস্য আবেদনের জন্য বিস্তারিত তথ্য ফরম',
                        icon: Icons.badge_outlined,
                        color: const Color(0xFF0284C7),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const khelafat_member.MemberFormScreen()),
                        ),
                      ),
                      _buildReportItem(
                        context,
                        title: 'শাখা সাংগঠনিক রিপোর্ট',
                        subtitle: 'মাসিক সাংগঠনিক সভা ও তৎপরতার রিপোর্ট',
                        icon: Icons.assessment_outlined,
                        color: const Color(0xFF059669),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const khelafat_branch.BranchReportScreen()),
                        ),
                      ),
                      _buildReportItem(
                        context,
                        title: 'বায়তুলমাল রিপোর্ট',
                        subtitle: 'মাসিক আয়-ব্যয় ও শাখা তহবিল হিসাব',
                        icon: Icons.account_balance_wallet_outlined,
                        color: const Color(0xFF16A34A),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const khelafat_baytulmal.BaytulmalReportPage()),
                        ),
                      ),
                    ] else if (activeMajlis == 'ছাত্র মজলিস') ...[
                      _buildReportItem(
                        context,
                        title: 'ছাত্র সদস্য ফরম',
                        subtitle: 'প্রাথমিক সদস্য আবেদন ফরম',
                        icon: Icons.badge_outlined,
                        color: const Color(0xFF0284C7),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const student_member.MemberFormScreen()),
                        ),
                      ),
                      _buildReportItem(
                        context,
                        title: 'ব্যক্তিগত রিপোর্ট বই',
                        subtitle: 'দৈনিক ইবাদত ও দাওয়াতি কাজের হিসাব',
                        icon: Icons.person_outline_rounded,
                        color: const Color(0xFFDC2626),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PersonalReportScreen(
                              year: DateTime.now().year,
                              month: DateTime.now().month,
                              majlisType: MajlisType.chatro,
                            ),
                          ),
                        ),
                      ),
                      _buildReportItem(
                        context,
                        title: 'বায়তুলমাল রিপোর্ট',
                        subtitle: 'ছাত্র বায়তুলমাল তহবিল রিপোর্ট',
                        icon: Icons.account_balance_wallet_outlined,
                        color: const Color(0xFF16A34A),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const student_baytulmal.BaytulmalReportPage()),
                        ),
                      ),
                    ] else if (activeMajlis == 'যুব মজলিস') ...[
                      _buildReportItem(
                        context,
                        title: 'যুব সদস্য ফরম',
                        subtitle: 'সদস্য আবেদনপত্র',
                        icon: Icons.badge_outlined,
                        color: const Color(0xFF0284C7),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const youth_member.MemberFormScreen()),
                        ),
                      ),
                      _buildReportItem(
                        context,
                        title: 'ব্যক্তিগত রিপোর্ট',
                        subtitle: 'যুব সমাজের দৈনন্দিন তৎপরতার হিসাব',
                        icon: Icons.person_outline_rounded,
                        color: const Color(0xFFDC2626),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PersonalReportScreen(
                              year: DateTime.now().year,
                              month: DateTime.now().month,
                              majlisType: MajlisType.jubo,
                            ),
                          ),
                        ),
                      ),
                    ] else if (activeMajlis == 'মহিলা মজলিস') ...[
                      _buildReportItem(
                        context,
                        title: 'ব্যক্তিগত রিপোর্ট বই',
                        subtitle: 'মহিলা মজলিসের দৈনন্দিন ট্র্যাকিং রিপোর্ট',
                        icon: Icons.person_outline_rounded,
                        color: const Color(0xFFE11D48),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PersonalReportScreen(
                              year: DateTime.now().year,
                              month: DateTime.now().month,
                              majlisType: MajlisType.mohila,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      _buildReportItem(
                        context,
                        title: 'সাধারণ রিপোর্ট বই',
                        subtitle: 'সংগঠনের সার্বিক তৎপরতার সাধারণ রিপোর্ট',
                        icon: Icons.assessment_outlined,
                        color: const Color(0xFF0284C7),
                        cardBg: cardBg,
                        textColor: textColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ReportBookScreen(majlisName: activeMajlis, reportType: 'General')),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _exportPdf({required String title, required String majlis}) {
    PdfExportService.printOrDownloadPdf(
      title: title,
      majlisName: majlis,
      userName: 'মিজানুর রহমান',
      period: 'চলতি মাস',
      dataFields: {
        'মজলিস': majlis,
        'স্ট্যাটাস': 'সম্পূর্ণ',
        'তারিখ': DateTime.now().toString().split(' ')[0],
      },
      comments: 'উক্ত রিপোর্টটি সিস্টেম থেকে পিডিএফ এক্সপোর্ট করা হয়েছে।',
    );
  }

  Widget _buildReportItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color cardBg,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Card(
      color: cardBg,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
                        const SizedBox(height: 2),
                        Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.description_outlined, size: 16),
                  label: const Text('ফরম পূরণ ও বিবরণ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


