import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:bijoy_helper/bijoy_helper.dart';
import '../models/daily_personal_entry.dart';
import '../models/baytulmal_report_entry.dart';
import '../models/monthly_plan.dart';
import 'report_storage_service.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/pdf_preview_screen.dart';

String b(String text) {
  if (text.isEmpty || text == '-') return text;
  return text.replaceAll('_', '.').replaceAll('✓', '√').toBijoy;
}

/// PDF জেনারেটর সার্ভিস — রিপোর্ট থেকে PDF তৈরি ও শেয়ার করে
class PdfGeneratorService {
  /// ব্যক্তিগত তৎপরতার রিপোর্ট PDF তৈরি করা (Daily Grid + Targets comparison summary)
  static Future<void> generatePersonalReportPdf({
    required List<DailyPersonalEntry> entries,
    required DateTime fromDate,
    required DateTime toDate,
    required String userName,
    required String branchName,
    String? majlisTitle,
    BuildContext? context,
  }) async {
    final font = await PdfExportService.loadSutonnyFont();
    final boldFont = await PdfExportService.loadBengaliBoldFont();

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: font,
        bold: boldFont,
      ),
    );

    // Map entries by date string
    final entryMap = <String, DailyPersonalEntry>{};
    for (final e in entries) {
      entryMap[e.date] = e;
    }

    // Generate all dates in range
    final allDates = <DateTime>[];
    DateTime current = DateTime(fromDate.year, fromDate.month, fromDate.day);
    final end = DateTime(toDate.year, toDate.month, toDate.day);
    while (!current.isAfter(end)) {
      allDates.add(current);
      current = current.add(const Duration(days: 1));
    }

    // Fetch plan and comment for context month
    final plan = await ReportStorageService.getMonthlyPlan(fromDate.year, fromDate.month);
    final commentsList = await ReportStorageService.getCommentsForMonth(fromDate.year, fromDate.month);

    // Calculate aggregates
    int quranDays = 0;
    int quranTotalAyah = 0;
    int hadithDays = 0;
    int hadithTotalCount = 0;
    int litDays = 0;
    int litTotalPages = 0;
    double academicTotalHours = 0.0;
    int jamaatTotalWaqt = 0;
    int selfAnalysisTotalDays = 0;
    int dawahTotalFriends = 0;
    int dawahTotalMaterials = 0;
    int orgMeetings = 0;
    double orgTotalHours = 0.0;
    int orgTotalWorkers = 0;
    int miscNewspaper = 0;
    int miscExercise = 0;

    for (final entry in entries) {
      if (entry.isEmpty) continue;
      
      // Quran
      if (entry.quranSura.isNotEmpty || entry.quranAyah.isNotEmpty) {
        quranDays++;
        try {
          quranTotalAyah += int.parse(entry.quranAyah.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }

      // Hadith
      final hCount = entry.hadithCount.isEmpty ? entry.hadithStudy : entry.hadithCount;
      if (hCount.isNotEmpty) {
        hadithDays++;
        try {
          hadithTotalCount += int.parse(hCount.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }

      // Lit
      final lPages = entry.islamicLitPages.isEmpty ? entry.islamicLiterature : entry.islamicLitPages;
      if (lPages.isNotEmpty) {
        litDays++;
        try {
          litTotalPages += int.parse(lPages.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }

      // Academic
      final aHours = entry.textbookHours.isEmpty ? entry.textbookStudy : entry.textbookHours;
      if (aHours.isNotEmpty) {
        try {
          academicTotalHours += double.parse(aHours.replaceAll(RegExp(r'[^0-9.]'), ''));
        } catch (_) {}
      }

      // Jamaat
      if (entry.jamaatPrayer.isNotEmpty) {
        try {
          jamaatTotalWaqt += int.parse(entry.jamaatPrayer.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }

      // Self
      if (entry.selfAnalysis == 'হ্যাঁ' || entry.selfAnalysis == 'yes') {
        selfAnalysisTotalDays++;
      }

      // Dawah friends
      if (entry.contactCount.isNotEmpty) {
        try {
          dawahTotalFriends += int.parse(entry.contactCount.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }

      // Dawah materials
      final dMat = entry.dawahMaterials.isEmpty ? entry.dawah : entry.dawahMaterials;
      if (dMat.isNotEmpty) {
        try {
          dawahTotalMaterials += int.parse(dMat.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }

      // Meetings
      if (entry.meetingName.isNotEmpty) {
        orgMeetings++;
      }

      // Org hours
      final oHours = entry.orgTime.isEmpty ? entry.timeService : entry.orgTime;
      if (oHours.isNotEmpty) {
        try {
          orgTotalHours += double.parse(oHours.replaceAll(RegExp(r'[^0-9.]'), ''));
        } catch (_) {}
      }

      // Org workers
      if (entry.memberContactCount.isNotEmpty) {
        try {
          orgTotalWorkers += int.parse(entry.memberContactCount.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }

      // Misc
      if (entry.newspaperTime.isNotEmpty) {
        try {
          miscNewspaper += int.parse(entry.newspaperTime.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }
      if (entry.physicalExerciseTime.isNotEmpty) {
        try {
          miscExercise += int.parse(entry.physicalExerciseTime.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (_) {}
      }
    }

    final headers = [
      'তারিখ',
      'কুরআন\n(সূরা/আয়াত)',
      'হাদীস\n(সংখ্যা/বিষয়)',
      'সাহিত্য\n(পৃষ্ঠা/বই)',
      'পাঠ্যপুস্তক\n(ঘণ্টা)',
      'সালাত\n(ওয়াক্ত)',
      'আত্মবিচার\n(হ্যাঁ/না)',
      'বন্ধু যোগযোগ\n(জন)',
      'দাওয়াত উপকরণ\n(টি)',
      'সভায় যোগদান\n(নাম)',
      'কর্মী যোগাযোগ\n(জন)',
      'সাংগঠনিক সময়\n(ঘণ্টা)',
      'বিবিধ\n(পত্রিকা/ব্যায়াম)',
    ];

    // Page 1: Daily Grid landscape
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(16),
        build: (context) {
          return [
            // Title Header
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(b('বিসমিল্লাহির রাহমানির রাহীম'), style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.SizedBox(height: 2),
                  pw.Text(b(majlisTitle ?? 'বাংলাদেশ খেলাফত মজলিস'), style: pw.TextStyle(font: boldFont, fontSize: 18, color: PdfColors.blue900)),
                  pw.Text(b('ব্যক্তিগত তৎপরতার দৈনিক রিপোর্ট টেবিল'), style: pw.TextStyle(font: boldFont, fontSize: 11)),
                  pw.SizedBox(height: 4),
                ],
              ),
            ),
            // Meta Row
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(b('কর্মীর নাম: $userName'), style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text(b('শাখা: $branchName'), style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text(b('রিপোর্ট মাস: ${_formatDateMonth(fromDate)}'), style: pw.TextStyle(font: font, fontSize: 8)),
              ],
            ),
            pw.SizedBox(height: 6),
            // Table
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey500, width: 0.5),
              columnWidths: const {
                0: pw.FixedColumnWidth(28), // Date
                1: pw.FlexColumnWidth(1.3), // Quran
                2: pw.FlexColumnWidth(1.3), // Hadith
                3: pw.FlexColumnWidth(1.2), // Lit
                4: pw.FlexColumnWidth(0.9), // Textbook
                5: pw.FlexColumnWidth(0.8), // Prayer
                6: pw.FlexColumnWidth(1.1), // Self analysis
                7: pw.FlexColumnWidth(0.9), // Friend Contact
                8: pw.FlexColumnWidth(0.9), // Dawah materials
                9: pw.FlexColumnWidth(1.1), // Meetings
                10: pw.FlexColumnWidth(0.9), // Worker contact
                11: pw.FlexColumnWidth(0.9), // Org time
                12: pw.FlexColumnWidth(1.1), // Misc
              },
              children: [
                // Header row
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue50),
                  children: headers.map((h) => pw.Container(
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: pw.Text(b(h), style: pw.TextStyle(font: boldFont, fontSize: 8), textAlign: pw.TextAlign.center),
                  )).toList(),
                ),
                // Data rows
                ...allDates.map((date) {
                  final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  final entry = entryMap[key];
                  final isMissing = entry == null || entry.isEmpty;

                  String quranVal = '';
                  String hadithVal = '';
                  String litVal = '';
                  String textVal = '';
                  String prayerVal = '';
                  String selfVal = '';
                  String dFriends = '';
                  String dMaterials = '';
                  String meetingVal = '';
                  String orgWorkers = '';
                  String orgHoursVal = '';
                  String miscVal = '';

                  if (!isMissing) {
                    if (entry.quranSura.isNotEmpty || entry.quranAyah.isNotEmpty) {
                      quranVal = '${entry.quranSura} (${entry.quranAyah})';
                    } else {
                      quranVal = entry.quranStudy;
                    }

                    if (entry.hadithCount.isNotEmpty || entry.hadithTopic.isNotEmpty) {
                      hadithVal = '${entry.hadithCount} (${entry.hadithTopic})';
                    } else {
                      hadithVal = entry.hadithStudy;
                    }

                    if (entry.islamicLitPages.isNotEmpty || entry.islamicLitBook.isNotEmpty) {
                      litVal = '${entry.islamicLitPages} (${entry.islamicLitBook})';
                    } else {
                      litVal = entry.islamicLiterature;
                    }

                    textVal = entry.textbookHours.isNotEmpty ? entry.textbookHours : entry.textbookStudy;
                    prayerVal = entry.jamaatPrayer;
                    selfVal = entry.selfAnalysis;
                    dFriends = entry.contactCount;
                    dMaterials = entry.dawahMaterials.isEmpty ? entry.dawah : entry.dawahMaterials;
                    meetingVal = entry.meetingName;
                    orgWorkers = entry.memberContactCount;
                    orgHoursVal = entry.orgTime.isEmpty ? entry.timeService : entry.orgTime;
                    
                    List<String> miscParts = [];
                    if (entry.newspaperTime.isNotEmpty) miscParts.add('পত্রিকা: ${entry.newspaperTime}মি.');
                    if (entry.physicalExerciseTime.isNotEmpty) miscParts.add('শরীরচর্চা: ${entry.physicalExerciseTime}মি.');
                    if (entry.familyWelfareTime.isNotEmpty) miscParts.add('সামাজিক: ${entry.familyWelfareTime}মি.');
                    miscVal = miscParts.join('\n');
                  }

                  return pw.TableRow(
                    children: [
                      _cell('${date.day}', boldFont, 6.5, align: pw.TextAlign.center),
                      _cell(quranVal, font, 6),
                      _cell(hadithVal, font, 6),
                      _cell(litVal, font, 6),
                      _cell(textVal, font, 6, align: pw.TextAlign.center),
                      _cell(prayerVal, font, 6, align: pw.TextAlign.center),
                      _cell(selfVal, font, 6, align: pw.TextAlign.center),
                      _cell(dFriends, font, 6, align: pw.TextAlign.center),
                      _cell(dMaterials, font, 6, align: pw.TextAlign.center),
                      _cell(meetingVal, font, 6),
                      _cell(orgWorkers, font, 6, align: pw.TextAlign.center),
                      _cell(orgHoursVal, font, 6, align: pw.TextAlign.center),
                      _cell(miscVal, font, 5.5),
                    ],
                  );
                }),
                // Total Summary row at bottom
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue50),
                  children: [
                    _cell('মোট', boldFont, 6.5, align: pw.TextAlign.center),
                    _cell('$quranTotalAyah আয়াত\n($quranDays দিন)', boldFont, 6, align: pw.TextAlign.center),
                    _cell('$hadithTotalCount হাদীস\n($hadithDays দিন)', boldFont, 6, align: pw.TextAlign.center),
                    _cell('$litTotalPages পৃষ্ঠা\n($litDays দিন)', boldFont, 6, align: pw.TextAlign.center),
                    _cell('${academicTotalHours.toStringAsFixed(1)} ঘ.', boldFont, 6, align: pw.TextAlign.center),
                    _cell('$jamaatTotalWaqt ওয়াক্ত', boldFont, 6, align: pw.TextAlign.center),
                    _cell('$selfAnalysisTotalDays দিন', boldFont, 6, align: pw.TextAlign.center),
                    _cell('$dawahTotalFriends জন', boldFont, 6, align: pw.TextAlign.center),
                    _cell('$dawahTotalMaterials টি', boldFont, 6, align: pw.TextAlign.center),
                    _cell('$orgMeetings টি', boldFont, 6, align: pw.TextAlign.center),
                    _cell('$orgTotalWorkers জন', boldFont, 6, align: pw.TextAlign.center),
                    _cell('${orgTotalHours.toStringAsFixed(1)} ঘ.', boldFont, 6, align: pw.TextAlign.center),
                    _cell('পত্রিকা: $miscNewspaper মি.\nব্যায়াম: $miscExercise মি.', boldFont, 5.5),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    // Page 2: Summary Dashboard & Comments (Portrait layout looks better for dashboard)
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          final targetQuran = plan?.quranAyahCount ?? '-';
          final targetHadith = plan?.hadithCount ?? '-';
          final targetLit = plan?.litPages ?? '-';
          final targetPrayer = plan?.jamaatPrayerWaqt ?? '-';
          final targetSelf = plan?.selfAnalysisDays ?? '-';
          final targetFriend = plan?.friendTargetCount ?? '-';
          final targetMaterials = plan?.dawahBookletCount ?? '-';
          final targetMeetings = plan?.meetingsCount ?? '-';
          final targetWorkers = plan?.workerContactsCount ?? '-';
          final targetOrgHours = plan?.orgHours ?? '-';

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(majlisTitle ?? 'বাংলাদেশ খেলাফত মজলিস', style: pw.TextStyle(font: boldFont, fontSize: 18, color: PdfColors.blue900)),
                    pw.Text('ব্যক্তিগত মাসিক তৎপরতা রিপোর্ট সামারি (পরিকল্পনা বনাম অর্জন)', style: pw.TextStyle(font: boldFont, fontSize: 11)),
                    pw.SizedBox(height: 12),
                  ],
                ),
              ),
              
              pw.Text('১. কুরআন অধ্যয়ন:', style: pw.TextStyle(font: boldFont, fontSize: 10, color: PdfColors.blue800)),
              _pdfSummaryRow(font, boldFont, 'মোট পঠিত আয়াত:', '$targetQuran টি', '$quranTotalAyah টি'),
              _pdfSummaryRow(font, boldFont, 'গড় পঠিত আয়াত:', '-', quranDays > 0 ? '${(quranTotalAyah / quranDays).toStringAsFixed(1)} টি' : '০ টি'),

              _pdfSummaryRow(font, boldFont, 'দারস তৈরি:', '${plan?.quranDarsCount ?? "-"} টি', '-'),
              _pdfSummaryRow(font, boldFont, 'দারস বিষয়:', plan?.quranDarsTopic ?? '-', '-'),
              _pdfSummaryRow(font, boldFont, 'মুখস্থ আয়াত:', plan?.quranMemorizeAyah ?? '-', '-'),

              pw.SizedBox(height: 8),
              pw.Text('২. হাদীস অধ্যয়ন:', style: pw.TextStyle(font: boldFont, fontSize: 10, color: PdfColors.blue800)),
              _pdfSummaryRow(font, boldFont, 'মোট পঠিত হাদীস:', '$targetHadith টি', '$hadithTotalCount টি'),
              _pdfSummaryRow(font, boldFont, 'দারস তৈরি:', '${plan?.hadithDarsCount ?? "-"} টি', '-'),

              pw.SizedBox(height: 8),
              pw.Text('৩. দ্বীনি ও সাধারণ সাহিত্য পাঠ:', style: pw.TextStyle(font: boldFont, fontSize: 10, color: PdfColors.blue800)),
              _pdfSummaryRow(font, boldFont, 'মোট পৃষ্ঠা পাঠ:', '$targetLit পৃষ্ঠা', '$litTotalPages পৃষ্ঠা'),
              _pdfSummaryRow(font, boldFont, 'বইয়ের নাম:', plan?.litBook ?? '-', '-'),

              pw.SizedBox(height: 8),
              pw.Text('৪. সালাত ও আত্মগঠন (ইবাদত):', style: pw.TextStyle(font: boldFont, fontSize: 10, color: PdfColors.blue800)),
              _pdfSummaryRow(font, boldFont, 'জামাআতে নামাজ (ওয়াক্ত):', '$targetPrayer ওয়াক্ত', '$jamaatTotalWaqt ওয়াক্ত'),
              _pdfSummaryRow(font, boldFont, 'আত্মবিচার আদায় (দিন):', '$targetSelf দিন', '$selfAnalysisTotalDays দিন'),

              pw.SizedBox(height: 8),
              pw.Text('৫. দাওয়াতি কাজ ও জনসংযোগ:', style: pw.TextStyle(font: boldFont, fontSize: 10, color: PdfColors.blue800)),
              _pdfSummaryRow(font, boldFont, 'বন্ধু যোগাযোগ (জন):', '$targetFriend জন', '$dawahTotalFriends জন'),
              _pdfSummaryRow(font, boldFont, 'উপকরণ বিতরণ (টি):', '$targetMaterials টি', '$dawahTotalMaterials টি'),

              pw.SizedBox(height: 8),
              pw.Text('৬. সাংগঠনিক কাজ:', style: pw.TextStyle(font: boldFont, fontSize: 10, color: PdfColors.blue800)),
              _pdfSummaryRow(font, boldFont, 'সভায় যোগদান:', '$targetMeetings টি', '$orgMeetings টি'),
              _pdfSummaryRow(font, boldFont, 'কর্মী যোগাযোগ (জন):', '$targetWorkers জন', '$orgTotalWorkers জন'),
              _pdfSummaryRow(font, boldFont, 'সাংগঠনিক সময়দান:', '$targetOrgHours ঘণ্টা', '${orgTotalHours.toStringAsFixed(1)} ঘণ্টা'),

              pw.SizedBox(height: 12),
              pw.Container(height: 1, color: PdfColors.grey400),
              pw.SizedBox(height: 8),

              // Comments Section
              pw.Text('দায়িত্বশীলের মন্তব্য ও মূল্যায়ন:', style: pw.TextStyle(font: boldFont, fontSize: 11, color: PdfColors.blue800)),
              pw.SizedBox(height: 6),
              if (commentsList.isNotEmpty)
                ...commentsList.map((c) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Text('• ${c.comment} (তারিখ: ${_formatEpoch(c.timestamp)})', style: pw.TextStyle(font: font, fontSize: 9)),
                ))
              else
                pw.Text('কোনো মন্তব্য পাওয়া যায়নি।', style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600)),

              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Container(width: 100, height: 0.5, color: PdfColors.black),
                      pw.SizedBox(height: 4),
                      pw.Text('কর্মীর স্বাক্ষর', style: pw.TextStyle(font: font, fontSize: 9)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Container(width: 100, height: 0.5, color: PdfColors.black),
                      pw.SizedBox(height: 4),
                      pw.Text('দায়িত্বশীলের স্বাক্ষর', style: pw.TextStyle(font: font, fontSize: 9)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();
    if (context != null) {
      await openPdfPreview(
        context,
        pdfBytes,
        'ব্যক্তিগত রিপোর্ট',
        fileName: 'personal_report_${_formatDateFile(fromDate)}_to_${_formatDateFile(toDate)}.pdf',
      );
    } else {
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'personal_report_${_formatDateFile(fromDate)}_to_${_formatDateFile(toDate)}.pdf',
      );
    }
  }

  /// বায়তুলমাল রিপোর্ট PDF তৈরি করা
  static Future<void> generateBaytulmalReportPdf({
    required BaytulmalReportEntry entry,
    BuildContext? context,
  }) async {
    final pdfBytes = await PdfExportService.generateKhelafatBaytulmalPdfBytes(entry: entry);

    if (context != null) {
      await openPdfPreview(
        context,
        pdfBytes,
        'বায়তুলমাল রিপোর্ট',
        fileName: 'baytulmal_report_${entry.year}_${entry.month}.pdf',
      );
    } else {
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'baytulmal_report_${entry.year}_${entry.month}.pdf',
      );
    }
  }

  // Helper widgets
  static pw.Widget _cell(String text, pw.Font font, double fontSize, {bool isMissing = false, pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(3),
      child: pw.Text(
        b(text),
        style: pw.TextStyle(
          font: font,
          fontSize: fontSize,
          color: isMissing ? PdfColors.red : PdfColors.black,
        ),
        textAlign: align,
      ),
    );
  }

  static String _formatDateFile(DateTime d) => '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';

  /// প্রাথমিক সদস্য ফরম PDF তৈরি করা (Same to Same printed brochure layout)
  static Future<void> generateMembershipPdf({
    required String name,
    required String fatherName,
    required String nidNo,
    required String bloodGroup,
    required String phone,
    required String email,
    required String currentAddress,
    required String village,
    required String union,
    required String thana,
    required String district,
    required String joinDate,
    required String fbLink,
    BuildContext? context,
  }) async {
    final font = await PdfExportService.loadSutonnyFont();
    final boldFont = await PdfExportService.loadBengaliBoldFont();

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: font,
        bold: boldFont,
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ==========================================
              // TOP HALF: OATH & DECLARATION
              // ==========================================
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('বিসমিল্লাহির রাহমানির রাহীম', style: pw.TextStyle(font: font, fontSize: 10)),
                    pw.SizedBox(height: 6),
                    pw.Text('ইসলামী যুব মজলিস', style: pw.TextStyle(font: boldFont, fontSize: 20, color: PdfColors.blue800)),
                    pw.Text('www.yuvamajlis.org.bd', style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey700)),
                    pw.SizedBox(height: 10),
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.symmetric(vertical: 6),
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.blue700,
                      ),
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        'প্রাথমিক সদস্য ফরম (শপথ ও ঘোষণা)',
                        style: pw.TextStyle(font: boldFont, fontSize: 13, color: PdfColors.white),
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
              pw.RichText(
                text: pw.TextSpan(
                  style: pw.TextStyle(font: font, fontSize: 11, color: PdfColors.black, height: 1.6),
                  children: [
                    pw.TextSpan(text: 'আমি '),
                    pw.TextSpan(text: '$name, ', style: pw.TextStyle(font: boldFont, color: PdfColors.blue900)),
                    pw.TextSpan(text: 'দৃঢ়ভাবে বিশ্বাস করি যে, ইসলামই আল্লাহর একমাত্র মনোনীত জীবনব্যবস্থা। ইসলামী আদর্শের আলোকে যুবসমাজের নেতৃত্বে একটি কল্যাণমুখী সমাজ গড়ার লক্ষ্যে ইসলামী যুব মজলিসের সাথে একমত হয়ে এ সংগঠনে যোগদান করছি। আমি এ লক্ষ্য অর্জনে যথাসাধ্য চেষ্টা করব ইনশাআল্লাহ।'),
                  ],
                ),
              ),
              pw.SizedBox(height: 50),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('তারিখ: $joinDate', style: pw.TextStyle(font: font, fontSize: 11)),
                  pw.Column(
                    children: [
                      pw.Container(width: 120, height: 0.5, color: PdfColors.black),
                      pw.SizedBox(height: 4),
                      pw.Text('আবেদনকারীর স্বাক্ষর', style: pw.TextStyle(font: font, fontSize: 10)),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 35),
              // Dashed Line separating top and bottom
              pw.Row(
                children: List.generate(
                  40,
                  (index) => pw.Expanded(
                    child: pw.Container(
                      height: 1,
                      color: index % 2 == 0 ? PdfColors.white : PdfColors.grey500,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 35),

              // ==========================================
              // BOTTOM HALF: DETAILED MEMBER INFO
              // ==========================================
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('ইসলামী যুব মজলিস', style: pw.TextStyle(font: boldFont, fontSize: 18, color: PdfColors.blue800)),
                    pw.SizedBox(height: 16),
                  ],
                ),
              ),

              _pdfRow(font, boldFont, 'নাম :', name),
              _pdfRow(font, boldFont, 'পিতার নাম :', fatherName),
              pw.Row(
                children: [
                  pw.Expanded(child: _pdfRow(font, boldFont, 'জাতীয় পরিচয়পত্র (NID) :', nidNo)),
                  pw.Expanded(child: _pdfRow(font, boldFont, 'রক্তের গ্রুপ :', bloodGroup)),
                ],
              ),
              _pdfRow(font, boldFont, 'বর্তমান ঠিকানা :', currentAddress),
              _pdfRow(font, boldFont, 'মোবাইল নম্বর :', phone),
              _pdfRow(font, boldFont, 'ইমেইল ঠিকানা :', email.isEmpty ? '-' : email),
              _pdfRow(font, boldFont, 'ফেসবুক লিংক :', fbLink.isEmpty ? '-' : fbLink),
              
              pw.SizedBox(height: 12),
              pw.Text('স্থায়ী ঠিকানা:', style: pw.TextStyle(font: boldFont, fontSize: 11, color: PdfColors.blue700)),
              pw.SizedBox(height: 4),
              pw.Row(
                children: [
                  pw.Expanded(child: _pdfRow(font, boldFont, 'গ্রাম/মহল্লা :', village)),
                  pw.Expanded(child: _pdfRow(font, boldFont, 'ইউনিয়ন/ওয়ার্ড :', union)),
                ],
              ),
              pw.Row(
                children: [
                  pw.Expanded(child: _pdfRow(font, boldFont, 'থানা ও উপজেলা :', thana)),
                  pw.Expanded(child: _pdfRow(font, boldFont, 'জেলা :', district)),
                ],
              ),

              pw.SizedBox(height: 50),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('তারিখ: $joinDate', style: pw.TextStyle(font: font, fontSize: 11)),
                  pw.Column(
                    children: [
                      pw.Container(width: 120, height: 0.5, color: PdfColors.black),
                      pw.SizedBox(height: 4),
                      pw.Text('আবেদনকারীর স্বাক্ষর', style: pw.TextStyle(font: font, fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();
    if (context != null) {
      await openPdfPreview(
        context,
        pdfBytes,
        'প্রাথমিক সদস্য ফরম',
      );
    } else {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );
    }
  }

  static pw.Widget _pdfRow(pw.Font font, pw.Font boldFont, String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Text(b(label), style: pw.TextStyle(font: boldFont, fontSize: 10, color: PdfColors.grey800)),
          pw.SizedBox(width: 6),
          pw.Expanded(
            child: pw.Text(
              b(value),
              style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.black),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _pdfSummaryRow(pw.Font font, pw.Font boldFont, String label, String target, String actual) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(b(label), style: pw.TextStyle(font: font, fontSize: 9)),
          pw.Row(
            children: [
              pw.Text(b('পরিকল্পনা: '), style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey700)),
              pw.Text(b(target), style: pw.TextStyle(font: boldFont, fontSize: 8.5)),
              pw.SizedBox(width: 12),
              pw.Text(b('অর্জিত: '), style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey700)),
              pw.Text(b(actual), style: pw.TextStyle(font: boldFont, fontSize: 8.5, color: PdfColors.green800)),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatDateMonth(DateTime d) {
    const months = ['জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন', 'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'];
    return '${months[d.month - 1]} ${d.year}';
  }

  static String _formatEpoch(int ms) {
    final d = DateTime.fromMillisecondsSinceEpoch(ms);
    return '${d.day}/${d.month}/${d.year}';
  }

  /// ব্যক্তিগত মাসিক পরিকল্পনা PDF তৈরি করা (Same to Same printed brochure layout)
  static Future<void> generatePersonalPlanPdf({
    required MonthlyPlan plan,
    required String userName,
    required String branchName,
    required int year,
    required int month,
    BuildContext? context,
  }) async {
    final font = await PdfExportService.loadSutonnyFont();
    final boldFont = await PdfExportService.loadBengaliBoldFont();

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: font,
        bold: boldFont,
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(b('বিসমিল্লাহির রাহমানির রাহীম'), style: pw.TextStyle(font: font, fontSize: 10)),
                    pw.SizedBox(height: 4),
                    pw.Text(b('ইসলামী যুব মজলিস'), style: pw.TextStyle(font: boldFont, fontSize: 20, color: PdfColors.blue900)),
                    pw.Text(b('ব্যক্তিগত মাসিক পরিকল্পনা (টার্গেট)'), style: pw.TextStyle(font: boldFont, fontSize: 12)),
                    pw.SizedBox(height: 10),
                  ],
                ),
              ),
              // Meta Row
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(b('কর্মীর নাম: $userName'), style: pw.TextStyle(font: font, fontSize: 9)),
                  pw.Text(b('শাখা: $branchName'), style: pw.TextStyle(font: font, fontSize: 9)),
                  pw.Text(b('মাস: ${_formatDateMonth(DateTime(year, month))}'), style: pw.TextStyle(font: font, fontSize: 9)),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Container(height: 1, color: PdfColors.blue800),
              pw.SizedBox(height: 12),

              _pdfPlanRowGroup(boldFont, font, '১. কুরআন অধ্যয়ন', [
                _pdfKeyValue('মোট পঠিত আয়াত টার্গেট:', '${plan.quranAyahCount} টি'),
                _pdfKeyValue('সূরা/পারা:', plan.quranSuraPara),
                _pdfKeyValue('দারস তৈরি:', '${plan.quranDarsCount} টি'),
                _pdfKeyValue('দারস বিষয়:', plan.quranDarsTopic),
                _pdfKeyValue('মুখস্থ আয়াত সংখ্যা:', plan.quranMemorizeAyah),
              ]),

              _pdfPlanRowGroup(boldFont, font, '২. হাদীস অধ্যয়ন', [
                _pdfKeyValue('পঠিত হাদীস সংখ্যা টার্গেট:', '${plan.hadithCount} টি'),
                _pdfKeyValue('হাদীস গ্রন্থ/বিষয়:', plan.hadithTopic),
                _pdfKeyValue('দারস তৈরি:', '${plan.hadithDarsCount} টি'),
                _pdfKeyValue('দারস বিষয়:', plan.hadithDarsTopic),
                _pdfKeyValue('মুখস্থ হাদীস সংখ্যা:', plan.hadithMemorizeCount),
              ]),

              _pdfPlanRowGroup(boldFont, font, '৩. দ্বীনি ও সাধারণ সাহিত্য পাঠ', [
                _pdfKeyValue('পঠিত পৃষ্ঠা সংখ্যা টার্গেট:', '${plan.litPages} পৃষ্ঠা'),
                _pdfKeyValue('বইয়ের নাম:', plan.litBook),
                _pdfKeyValue('বই/আলোচনা নোট পৃষ্ঠা:', '${plan.litNotes} পৃষ্ঠা'),
              ]),

              _pdfPlanRowGroup(boldFont, font, '৪. সালাত ও আত্মগঠন (ইবাদত)', [
                _pdfKeyValue('জামাআতে নামাজ (ওয়াক্ত):', '${plan.jamaatPrayerWaqt} ওয়াক্ত'),
                _pdfKeyValue('নফল ইবাদত বিবরণ:', plan.naflPrayer),
                _pdfKeyValue('আত্মবিচার আদায় দিন টার্গেট:', '${plan.selfAnalysisDays} দিন'),
              ]),

              _pdfPlanRowGroup(boldFont, font, '৫. দাওয়াতি কাজ ও জনসংযোগ', [
                _pdfKeyValue('বন্ধু যোগাযোগ (জন):', plan.friendTargetCount),
                _pdfKeyValue('টার্গেট বন্ধুদের নাম:', plan.friendTargetNames),
                _pdfKeyValue('প্রাথমিক সদস্য বৃদ্ধি (জন):', plan.primaryMemberTargetCount),
                _pdfKeyValue('টার্গেট সদস্যদের নাম:', plan.primaryMemberTargetNames),
                _pdfKeyValue('বই/পরিচিতি/স্টিকার বিতরণ:', plan.dawahBookletCount),
                _pdfKeyValue('ছাত্র পরিক্রমা বিতরণ (টি):', plan.studentReviewCount),
                _pdfKeyValue('শুভাকাঙ্ক্ষী যোগাযোগ (জন):', plan.supporterTargetCount),
                _pdfKeyValue('কার্ড/উপহার/SMS বিতরণ:', plan.giftSmsCount),
                _pdfKeyValue('গ্রুপ দাওয়াত (বার):', plan.groupDawahCount),
              ]),

              _pdfPlanRowGroup(boldFont, font, '৬. সাংগঠনিক কাজ', [
                _pdfKeyValue('সভায় যোগদান টার্গেট:', plan.meetingsCount),
                _pdfKeyValue('কর্মী যোগাযোগ টার্গেট (জন):', plan.workerContactsCount),
                _pdfKeyValue('সাংগঠনিক সময়দান:', '${plan.orgHours} ঘণ্টা'),
                _pdfKeyValue('বায়তুলমাল পরিশোধ টার্গেট:', '${plan.baytulmalAmount} টাকা'),
              ]),

              _pdfPlanRowGroup(boldFont, font, '৭. বিবিধ ও সংশ্লিষ্টদের জন্য', [
                _pdfKeyValue('পত্রিকা পাঠ (মিনিট):', plan.newspaperMinutes),
                _pdfKeyValue('শরীরচর্চা দিন টার্গেট:', plan.physicalExerciseDays),
                _pdfKeyValue('কারিগরি শিক্ষা সময়:', plan.technicalSkillHours),
                _pdfKeyValue('পারিবারিক/সামাজিক সময়:', plan.familyTimeHours),
                _pdfKeyValue('সদস্য স্তরে উন্নীতকরণ:', plan.memberUpgradeTargetCount),
                _pdfKeyValue('সহযোগী সদস্য স্তরে উন্নীতকরণ:', plan.associateUpgradeTargetCount),
              ]),

              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(b('তারিখ: ________________'), style: pw.TextStyle(font: font, fontSize: 9)),
                  pw.Column(
                    children: [
                      pw.Container(width: 120, height: 0.5, color: PdfColors.black),
                      pw.SizedBox(height: 4),
                      pw.Text(b('কর্মীর স্বাক্ষর'), style: pw.TextStyle(font: font, fontSize: 9)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();
    if (context != null) {
      await openPdfPreview(
        context,
        pdfBytes,
        'ব্যক্তিগত মাসিক পরিকল্পনা',
      );
    } else {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );
    }
  }

  static pw.Widget _pdfPlanRowGroup(pw.Font boldFont, pw.Font font, String title, List<pw.Widget> items) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(b(title), style: pw.TextStyle(font: boldFont, fontSize: 10, color: PdfColors.blue800)),
          pw.SizedBox(height: 4),
          pw.Wrap(
            spacing: 12,
            runSpacing: 4,
            children: items,
          ),
        ],
      ),
    );
  }

  static pw.Widget _pdfKeyValue(String key, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(right: 8),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(b(key), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
          pw.SizedBox(width: 3),
          pw.Text(b(value.isEmpty ? '-' : value), style: const pw.TextStyle(fontSize: 8, color: PdfColors.black)),
        ],
      ),
    );
  }
}
