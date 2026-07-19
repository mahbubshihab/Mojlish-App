import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import '../models/daily_personal_entry.dart';
import '../models/baytulmal_report_entry.dart';

/// PDF জেনারেটর সার্ভিস — রিপোর্ট থেকে PDF তৈরি ও শেয়ার করে
class PdfGeneratorService {
  /// ব্যক্তিগত তৎপরতার রিপোর্ট PDF তৈরি করা
  static Future<void> generatePersonalReportPdf({
    required List<DailyPersonalEntry> entries,
    required DateTime fromDate,
    required DateTime toDate,
    required String userName,
    required String branchName,
  }) async {
    final pdf = pw.Document();

    // Font loading (use default for now since custom Bangla font needs TTF asset)
    final font = await PdfGoogleFonts.notoSansBengaliRegular();
    final boldFont = await PdfGoogleFonts.notoSansBengaliBold();

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

    // Column headers
    final headers = [
      'তারিখ',
      'কোরআন\nঅধ্যয়ন',
      'হাদীস\nঅধ্যয়ন',
      'ইসলামী\nসাহিত্য',
      'জামায়াতে\nনামাজ',
      'যোগাযোগ',
      'দাওয়াত\n(জন)',
      'সময় দান',
      'সমাজ\nসেবা',
      'মন্তব্য',
    ];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (context) {
          return [
            // Header
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'বিসমিল্লাহির রাহমানির রাহীম',
                    style: pw.TextStyle(font: font, fontSize: 10),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'খেলাফত মজলিস',
                    style: pw.TextStyle(font: boldFont, fontSize: 22),
                  ),
                  pw.Text(
                    'কেন্দ্রীয় কার্যালয়: ১৬ বিজয়নগর, (৫ম তলা), ঢাকা-১০০০ | ফোন: ০২-৪৯৩৫৪৯২১',
                    style: pw.TextStyle(font: font, fontSize: 8),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'ব্যক্তিগত তৎপরতার রিপোর্ট',
                    style: pw.TextStyle(font: boldFont, fontSize: 14),
                  ),
                  pw.SizedBox(height: 6),
                ],
              ),
            ),
            // Meta info
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('কর্মীর নাম: $userName', style: pw.TextStyle(font: font, fontSize: 10))),
                pw.Expanded(child: pw.Text('শাখা: $branchName', style: pw.TextStyle(font: font, fontSize: 10))),
                pw.Expanded(child: pw.Text('সময়কাল: ${_formatDate(fromDate)} - ${_formatDate(toDate)}', style: pw.TextStyle(font: font, fontSize: 10))),
              ],
            ),
            pw.SizedBox(height: 8),
            // Table
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
              columnWidths: {
                0: const pw.FixedColumnWidth(35),
                1: const pw.FlexColumnWidth(),
                2: const pw.FlexColumnWidth(),
                3: const pw.FlexColumnWidth(),
                4: const pw.FlexColumnWidth(),
                5: const pw.FlexColumnWidth(),
                6: const pw.FlexColumnWidth(),
                7: const pw.FlexColumnWidth(),
                8: const pw.FlexColumnWidth(),
                9: const pw.FlexColumnWidth(1.5),
              },
              children: [
                // Header row
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                  children: headers.map((h) => pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(h, style: pw.TextStyle(font: boldFont, fontSize: 7), textAlign: pw.TextAlign.center),
                  )).toList(),
                ),
                // Data rows
                ...allDates.map((date) {
                  final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  final entry = entryMap[key];
                  final isMissing = entry == null || entry.isEmpty;
                  return pw.TableRow(
                    decoration: isMissing ? const pw.BoxDecoration(color: PdfColors.red50) : null,
                    children: [
                      _cell('${date.day.toString().padLeft(2, '0')}', boldFont, 8),
                      _cell(isMissing ? 'মিসিং' : entry.quranStudy, font, 7, isMissing: isMissing),
                      _cell(isMissing ? '' : entry.hadithStudy, font, 7),
                      _cell(isMissing ? '' : entry.islamicLiterature, font, 7),
                      _cell(isMissing ? '' : entry.jamaatPrayer, font, 7),
                      _cell(isMissing ? '' : entry.contact, font, 7),
                      _cell(isMissing ? '' : entry.dawah, font, 7),
                      _cell(isMissing ? '' : entry.volunteering, font, 7),
                      _cell(isMissing ? '' : entry.socialService, font, 7),
                      _cell(isMissing ? '' : entry.remarks, font, 7),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('তারিখ: ___________', style: pw.TextStyle(font: font, fontSize: 10)),
                pw.Text('দায়িত্বশীলের স্বাক্ষর: ___________', style: pw.TextStyle(font: font, fontSize: 10)),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'personal_report_${_formatDateFile(fromDate)}_to_${_formatDateFile(toDate)}.pdf',
    );
  }

  /// বায়তুলমাল রিপোর্ট PDF তৈরি করা
  static Future<void> generateBaytulmalReportPdf({
    required BaytulmalReportEntry entry,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.notoSansBengaliRegular();
    final boldFont = await PdfGoogleFonts.notoSansBengaliBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text('বিসমিল্লাহির রাহমানির রাহীম', style: pw.TextStyle(font: font, fontSize: 10)),
              pw.Text('শাখার বায়তুলমাল রিপোর্ট ফর্ম', style: pw.TextStyle(font: font, fontSize: 11)),
              pw.Text('খেলাফত মজলিস', style: pw.TextStyle(font: boldFont, fontSize: 20)),
              pw.Text('কেন্দ্রীয় কার্যালয়: ১৬ বিজয়নগর, (৫ম তলা), ঢাকা-১০০০ | ফোন: ০২-৪৯৩৫৪৯২১', style: pw.TextStyle(font: font, fontSize: 8)),
              pw.SizedBox(height: 10),
              // শাখা, মাস, সন
              pw.Table(
                border: pw.TableBorder.all(width: 0.5),
                children: [
                  pw.TableRow(children: [
                    _headerCell('শাখা: ${entry.branchName}', boldFont),
                    _headerCell('মাস: ${entry.month}', boldFont),
                    _headerCell('সন: ${entry.year}', boldFont),
                  ]),
                ],
              ),
              pw.SizedBox(height: 8),
              // আয়
              _sectionTitle('আয়', boldFont),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(),
                  2: const pw.FlexColumnWidth(),
                },
                children: [
                  pw.TableRow(decoration: const pw.BoxDecoration(color: PdfColors.grey200), children: [
                    _cell('আয়ের উৎস', boldFont, 9), _cell('টাকা', boldFont, 9), _cell('পয়সা', boldFont, 9),
                  ]),
                  _incomeRow('নির্বাহী সদস্যের এয়ানত (সংখ্যা: ${entry.executiveMemberAyanat} জন)', entry.executiveMemberAyanatTaka, font),
                  _incomeRow('অধতন শাখা এয়ানত (শাখা সংখ্যা: ${entry.subBranchAyanat} টি)', entry.subBranchAyanatTaka, font),
                  _incomeRow('সুহৃদ/ভক্তাক্ষী এয়ানত (সংখ্যা: ${entry.suhridAyanat} জন)', entry.suhridAyanatTaka, font),
                  _incomeRow('সফর', entry.safarIncomeTaka, font),
                  _incomeRow('প্রকাশনা', entry.prokashnaIncomeTaka, font),
                  _incomeRow('এককালীন (বিস্তারিত আলাদা কাগজে)', entry.onetimeIncomeTaka, font),
                  _incomeRow('বিগত মাস/মৌসুমের উদ্বৃত্ত', entry.previousBalance, font),
                  pw.TableRow(decoration: const pw.BoxDecoration(color: PdfColors.grey100), children: [
                    _cell('মেট আয়', boldFont, 9), _cell(entry.totalIncome.toStringAsFixed(2), boldFont, 9), _cell('', boldFont, 9),
                  ]),
                ],
              ),
              pw.SizedBox(height: 8),
              // ব্যয়
              _sectionTitle('ব্যয়', boldFont),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(),
                  2: const pw.FlexColumnWidth(),
                },
                children: [
                  pw.TableRow(decoration: const pw.BoxDecoration(color: PdfColors.grey200), children: [
                    _cell('ব্যয়ের খাত', boldFont, 9), _cell('টাকা', boldFont, 9), _cell('পয়সা', boldFont, 9),
                  ]),
                  _incomeRow('উর্ধতন এয়ানত পরিশোধ (মাসিক ধার্যকৃত: ${entry.upwardAyanat} টাকা)', entry.upwardAyanatTaka, font),
                  _incomeRow('অফিস ভাড়া ও বিল', entry.officeRentTaka, font),
                  _incomeRow('অফিস খরচ', entry.officeCostTaka, font),
                  _incomeRow('সফর', entry.safarExpenseTaka, font),
                  _incomeRow('যাতায়াত', entry.transportTaka, font),
                  _incomeRow('যোগাযোগ', entry.communicationTaka, font),
                  _incomeRow('প্রচার', entry.procharTaka, font),
                  _incomeRow('প্রকাশনা', entry.prokashnaExpenseTaka, font),
                  _incomeRow('দিবস পালন (নাম: ${entry.dibosPalan})', entry.dibosPatanTaka, font),
                  _incomeRow('আপ্যায়ন', entry.appayanTaka, font),
                  _incomeRow('সভা/সমাবেশ বাস্তবায়ন (বিস্তারিত আলাদা কাগজে)', entry.sovaTaka, font),
                  pw.TableRow(decoration: const pw.BoxDecoration(color: PdfColors.grey100), children: [
                    _cell('মেট ব্যয়', boldFont, 9), _cell(entry.totalExpense.toStringAsFixed(2), boldFont, 9), _cell('', boldFont, 9),
                  ]),
                  pw.TableRow(children: [
                    _cell('উদ্বৃত্ত / ঘাটতি', boldFont, 9), _cell(entry.balance.toStringAsFixed(2), boldFont, 9), _cell('', boldFont, 9),
                  ]),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text('মন্তব্য: ${entry.remarks}', style: pw.TextStyle(font: font, fontSize: 9)),
              pw.SizedBox(height: 16),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('তারিখ: ___________', style: pw.TextStyle(font: font, fontSize: 10)),
                  pw.Text('বায়তুলমাল সম্পাদকের স্বাক্ষর: ___________', style: pw.TextStyle(font: font, fontSize: 10)),
                  pw.Text('সভাপতির স্বাক্ষর: ___________', style: pw.TextStyle(font: font, fontSize: 10)),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'baytulmal_report_${entry.year}_${entry.month}.pdf',
    );
  }

  // Helper widgets
  static pw.Widget _cell(String text, pw.Font font, double fontSize, {bool isMissing = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(3),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: fontSize,
          color: isMissing ? PdfColors.red : PdfColors.black,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _headerCell(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 10)),
    );
  }

  static pw.Widget _sectionTitle(String title, pw.Font boldFont) {
    return pw.Container(
      width: double.infinity,
      color: PdfColors.blue100,
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: pw.Text(title, style: pw.TextStyle(font: boldFont, fontSize: 11)),
    );
  }

  static pw.TableRow _incomeRow(String label, String amount, pw.Font font) {
    return pw.TableRow(children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(label, style: pw.TextStyle(font: font, fontSize: 8)),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(amount, style: pw.TextStyle(font: font, fontSize: 8), textAlign: pw.TextAlign.right),
      ),
      pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text('', style: pw.TextStyle(font: font, fontSize: 8))),
    ]);
  }

  static String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
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
  }) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.notoSansBengaliRegular();
    final boldFont = await PdfGoogleFonts.notoSansBengaliBold();

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
                    pw.Text('বাংলাদেশ ইসলামী যুব মজলিস', style: pw.TextStyle(font: boldFont, fontSize: 20, color: PdfColors.blue800)),
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
                    pw.Text('বাংলাদেশ ইসলামী যুব মজলিস', style: pw.TextStyle(font: boldFont, fontSize: 18, color: PdfColors.blue800)),
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

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _pdfRow(pw.Font font, pw.Font boldFont, String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Text(label, style: pw.TextStyle(font: boldFont, fontSize: 10, color: PdfColors.grey800)),
          pw.SizedBox(width: 6),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.black),
            ),
          ),
        ],
      ),
    );
  }
}
