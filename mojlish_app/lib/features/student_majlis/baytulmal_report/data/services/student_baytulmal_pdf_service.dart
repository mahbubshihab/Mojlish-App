import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/student_majlis/baytulmal_report/domain/entities/baytulmal_report_entity.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/pdf_preview_screen.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস — বায়তুলমাল রিপোর্ট ডেডিকেটেড পিডিএফ সার্ভিস
/// ডেমো ফরম্যাটের (image.png) শতভাগ হুবহু ২-সেকশন টেবিল ও সামারি লেআউট (Single A4 Page)
class StudentBaytulmalPdfService {
  static final primaryAmber = PdfColor.fromHex('#D97706');
  static final lightBannerBg = PdfColor.fromHex('#FEF3C7');
  static final tableHeaderBg = PdfColor.fromHex('#FFFBEB');

  /// ডেমো ফরম লেআউট অনুযায়ী পিডিএফ বাইটস জেনারেট করা
  static Future<Uint8List> generatePdfBytes({
    required BaytulmalReportEntity report,
  }) async {
    final fontRegular = await PdfExportService.loadSutonnyFont();
    final fontBold = await PdfExportService.loadBengaliBoldFont();

    pw.MemoryImage? logoImage;
    try {
      final bytes = await rootBundle.load(MajlisAssets.chatroLogo);
      logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {}

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: fontRegular,
        bold: fontBold,
      ),
    );

    // Dynamic Income sum
    double customIncomeSum = 0;
    for (var item in report.customIncomes) {
      customIncomeSum += item.amount;
    }
    final double motAy = report.motAy > 0
        ? report.motAy
        : (report.jonoshoktiIyanot +
            report.shakhaIyanot +
            report.shuvakangkhiIyanot +
            report.ekkalinAy +
            customIncomeSum);

    final double sorbomotAy = report.sorbomotAy > 0
        ? report.sorbomotAy
        : (motAy + report.bigotoSeshonMasherUdbritto);

    // Dynamic Expense sum
    double customExpenseSum = 0;
    for (var item in report.customExpenses) {
      customExpenseSum += item.amount;
    }
    final double motBay = report.motBay > 0
        ? report.motBay
        : (report.urdhotonIyanotPorishodh +
            report.urdhotonSofor +
            report.office +
            report.jatayat +
            report.jogajog +
            report.prochar +
            customExpenseSum);

    final double sorbomotBay = report.sorbomotBay > 0
        ? report.sorbomotBay
        : (motBay + report.bigotoSeshonMasherGhatti);

    final double udbrittoBaGhatti = sorbomotAy - sorbomotBay;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // ================= TOP HEADER =================
              PdfExportService.bWidget(
                'বিসমিল্লাহির রাহমানির রাহীম',
                fontSize: 9.5,
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 2),

              // Header Badge: "বায়তুলমাল রিপোর্ট"
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: primaryAmber, width: 1),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                ),
                child: PdfExportService.bWidget(
                  'বায়তুলমাল রিপোর্ট',
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryAmber,
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 4),

              // Logo + Organization Title
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (logoImage != null) ...[
                    pw.Image(logoImage, width: 32, height: 32),
                    pw.SizedBox(width: 8),
                  ],
                  PdfExportService.bWidget(
                    'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                    fontSize: 19,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryAmber,
                  ),
                ],
              ),
              pw.SizedBox(height: 6),

              // Metadata Row Box (শাখা, মাস, সেশন)
              pw.Container(
                width: double.infinity,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: primaryAmber, width: 0.8),
                ),
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    PdfExportService.bWidget(
                      'শাখা : ${report.branch.isEmpty ? "...................................." : report.branch}',
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    PdfExportService.bWidget(
                      'মাস : ${report.month.isEmpty ? "...................................." : report.month}',
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    PdfExportService.bWidget(
                      'সেশন : ${report.session.isEmpty ? "...................................." : report.session}',
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 6),

              // ================= SECTION 1: আয় =================
              pw.Container(
                width: double.infinity,
                decoration: pw.BoxDecoration(
                  color: lightBannerBg,
                  border: pw.Border.all(color: primaryAmber, width: 0.8),
                ),
                padding: const pw.EdgeInsets.symmetric(vertical: 2.5),
                alignment: pw.Alignment.center,
                child: PdfExportService.bWidget(
                  'আয়',
                  fontSize: 11.5,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryAmber,
                ),
              ),
              pw.Table(
                border: pw.TableBorder(
                  left: pw.BorderSide(color: primaryAmber, width: 0.8),
                  right: pw.BorderSide(color: primaryAmber, width: 0.8),
                  bottom: pw.BorderSide(color: primaryAmber, width: 0.8),
                  horizontalInside: pw.BorderSide(color: primaryAmber, width: 0.5),
                  verticalInside: pw.BorderSide(color: primaryAmber, width: 0.5),
                ),
                columnWidths: const {
                  0: pw.FlexColumnWidth(5.5),
                  1: pw.FlexColumnWidth(1.8),
                  2: pw.FlexColumnWidth(1.2),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: tableHeaderBg),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        child: PdfExportService.bWidget('আয়ের উৎস',
                            fontSize: 9.5, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                        child: PdfExportService.bWidget('টাকা',
                            fontSize: 9.5,
                            fontWeight: pw.FontWeight.bold,
                            textAlign: pw.TextAlign.center),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                        child: PdfExportService.bWidget('পয়সা',
                            fontSize: 9.5,
                            fontWeight: pw.FontWeight.bold,
                            textAlign: pw.TextAlign.center),
                      ),
                    ],
                  ),
                  _buildRow('১ । জনশক্তি ইয়ানত (সদস্য/সহযোগী সদস্য/কর্মী)',
                      report.jonoshoktiIyanot),
                  _buildRow('২ । শাখা ইয়ানত', report.shakhaIyanot),
                  _buildRow('৩ । শুভাকাঙ্ক্ষী ইয়ানত', report.shuvakangkhiIyanot),
                  _buildRow(
                      '৪ । এককালীন আয় (বিস্তারিত আলাদা কাগজে)', report.ekkalinAy),
                  _buildCustomOrEmptyRow(report.customIncomes, 0),
                  _buildCustomOrEmptyRow(report.customIncomes, 1),
                  _buildCustomOrEmptyRow(report.customIncomes, 2),
                  _buildCustomOrEmptyRow(report.customIncomes, 3),
                ],
              ),

              // Income Summary Block (Matching Demo Photo Exact Grid Alignment)
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    left: pw.BorderSide(color: primaryAmber, width: 0.8),
                    right: pw.BorderSide(color: primaryAmber, width: 0.8),
                    bottom: pw.BorderSide(color: primaryAmber, width: 0.8),
                  ),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    // Left: কথায়
                    pw.Expanded(
                      flex: 35,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(5),
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(color: primaryAmber, width: 0.5),
                          ),
                        ),
                        alignment: pw.Alignment.topLeft,
                        child: PdfExportService.bWidget(
                          'কথায় : ${report.motAyInWords.isEmpty ? "........................................................................................................" : report.motAyInWords}',
                          fontSize: 8.5,
                        ),
                      ),
                    ),
                    // Right: Summary Sub-Table (aligned under Taka/Paisa columns)
                    pw.Expanded(
                      flex: 50,
                      child: pw.Table(
                        border: pw.TableBorder(
                          horizontalInside: pw.BorderSide(color: primaryAmber, width: 0.5),
                          verticalInside: pw.BorderSide(color: primaryAmber, width: 0.5),
                        ),
                        columnWidths: const {
                          0: pw.FlexColumnWidth(2.0),
                          1: pw.FlexColumnWidth(1.8),
                          2: pw.FlexColumnWidth(1.2),
                        },
                        children: [
                          _buildSummaryRow('মোট আয়', motAy),
                          _buildSummaryRow('বিগত সেশন/মাসের উদ্বৃত্ত',
                              report.bigotoSeshonMasherUdbritto),
                          _buildSummaryRow('সর্বমোট আয়', sorbomotAy, isBold: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),

              // ================= SECTION 2: ব্যয় =================
              pw.Container(
                width: double.infinity,
                decoration: pw.BoxDecoration(
                  color: lightBannerBg,
                  border: pw.Border.all(color: primaryAmber, width: 0.8),
                ),
                padding: const pw.EdgeInsets.symmetric(vertical: 2.5),
                alignment: pw.Alignment.center,
                child: PdfExportService.bWidget(
                  'ব্যয়',
                  fontSize: 11.5,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryAmber,
                ),
              ),
              pw.Table(
                border: pw.TableBorder(
                  left: pw.BorderSide(color: primaryAmber, width: 0.8),
                  right: pw.BorderSide(color: primaryAmber, width: 0.8),
                  bottom: pw.BorderSide(color: primaryAmber, width: 0.8),
                  horizontalInside: pw.BorderSide(color: primaryAmber, width: 0.5),
                  verticalInside: pw.BorderSide(color: primaryAmber, width: 0.5),
                ),
                columnWidths: const {
                  0: pw.FlexColumnWidth(5.5),
                  1: pw.FlexColumnWidth(1.8),
                  2: pw.FlexColumnWidth(1.2),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: tableHeaderBg),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        child: PdfExportService.bWidget('ব্যয়ের খাত',
                            fontSize: 9.5, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                        child: PdfExportService.bWidget('টাকা',
                            fontSize: 9.5,
                            fontWeight: pw.FontWeight.bold,
                            textAlign: pw.TextAlign.center),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                        child: PdfExportService.bWidget('পয়সা',
                            fontSize: 9.5,
                            fontWeight: pw.FontWeight.bold,
                            textAlign: pw.TextAlign.center),
                      ),
                    ],
                  ),
                  _buildRow('১ । ঊর্ধ্বতন ইয়ানত পরিশোধ',
                      report.urdhotonIyanotPorishodh),
                  _buildRow('২ । ঊর্ধ্বতন সফর', report.urdhotonSofor),
                  _buildRow('৩ । অফিস', report.office),
                  _buildRow('৪ । যাতায়াত', report.jatayat),
                  _buildRow('৫ । যোগাযোগ', report.jogajog),
                  _buildRow('৬ । প্রচার', report.prochar),
                  _buildCustomOrEmptyRow(report.customExpenses, 0),
                  _buildCustomOrEmptyRow(report.customExpenses, 1),
                  _buildCustomOrEmptyRow(report.customExpenses, 2),
                ],
              ),

              // Expense Summary Block (Matching Demo Photo Exact Grid Alignment)
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    left: pw.BorderSide(color: primaryAmber, width: 0.8),
                    right: pw.BorderSide(color: primaryAmber, width: 0.8),
                    bottom: pw.BorderSide(color: primaryAmber, width: 0.8),
                  ),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    // Left: কথায় & Bottom Note
                    pw.Expanded(
                      flex: 35,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(5),
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(color: primaryAmber, width: 0.5),
                          ),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            PdfExportService.bWidget(
                              'কথায় : ${report.motBayInWords.isEmpty ? "........................................................................................................" : report.motBayInWords}',
                              fontSize: 8.5,
                            ),
                            pw.SizedBox(height: 12),
                            pw.Center(
                              child: PdfExportService.bWidget(
                                '(ঘাটতি তালিকার বিস্তারিত আলাদা কাগজে)',
                                fontSize: 7.5,
                                color: PdfColors.grey700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Right: Summary Sub-Table (aligned under Taka/Paisa columns)
                    pw.Expanded(
                      flex: 50,
                      child: pw.Table(
                        border: pw.TableBorder(
                          horizontalInside: pw.BorderSide(color: primaryAmber, width: 0.5),
                          verticalInside: pw.BorderSide(color: primaryAmber, width: 0.5),
                        ),
                        columnWidths: const {
                          0: pw.FlexColumnWidth(2.0),
                          1: pw.FlexColumnWidth(1.8),
                          2: pw.FlexColumnWidth(1.2),
                        },
                        children: [
                          _buildSummaryRow('মোট ব্যয়', motBay),
                          _buildSummaryRow('বিগত সেশন/মাসের ঘাটতি',
                              report.bigotoSeshonMasherGhatti),
                          _buildSummaryRow('সর্বমোট ব্যয়', sorbomotBay, isBold: true),
                          _buildSummaryRow('সর্বমোট আয়', sorbomotAy, isBold: true),
                          _buildSummaryRow('উদ্বৃত্ত/ঘাটতি', udbrittoBaGhatti, isBold: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 10),

              // ================= FOOTER SIGNATURE =================
              pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    PdfExportService.bWidget(
                      '..................................................',
                      fontSize: 9.5,
                    ),
                    pw.SizedBox(height: 2),
                    PdfExportService.bWidget(
                      report.presidentSignature.isNotEmpty
                          ? 'সভাপতির স্বাক্ষর: ${report.presidentSignature}'
                          : 'সভাপতির স্বাক্ষর',
                      fontSize: 9.5,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 2),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// শেয়ার / প্রিন্ট করার অ্যাকশন সুবিধা
  static Future<void> generateAndSharePdf(BaytulmalReportEntity report,
      {BuildContext? context}) async {
    final bytes = await generatePdfBytes(report: report);
    final fileName =
        'chatro_baytulmal_report_${report.branch.isEmpty ? "shakha" : report.branch}_${report.month.isEmpty ? "month" : report.month}.pdf';
    if (context != null && context.mounted) {
      await openPdfPreview(
        context,
        bytes,
        'বায়তুলমাল রিপোর্ট',
        fileName: fileName,
      );
    } else {
      await Printing.sharePdf(
        bytes: bytes,
        filename: fileName,
      );
    }
  }

  // Helper row builder for fixed main tables
  static pw.TableRow _buildRow(String label, double val) {
    final (taka, poisa) = _formatTakaPoisa(val);

    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: PdfExportService.bWidget(label, fontSize: 8.5),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: PdfExportService.bWidget(taka,
              fontSize: 8.5, textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: PdfExportService.bWidget(poisa,
              fontSize: 8.5, textAlign: pw.TextAlign.center),
        ),
      ],
    );
  }

  // Helper custom or empty row builder
  static pw.TableRow _buildCustomOrEmptyRow(
      List<BaytulmalItemEntity> items, int index) {
    if (index < items.length && items[index].title.trim().isNotEmpty) {
      final item = items[index];
      final (taka, poisa) = _formatTakaPoisa(item.amount);
      return pw.TableRow(
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: PdfExportService.bWidget(item.title, fontSize: 8.5),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: PdfExportService.bWidget(taka,
                fontSize: 8.5, textAlign: pw.TextAlign.center),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: PdfExportService.bWidget(poisa,
                fontSize: 8.5, textAlign: pw.TextAlign.center),
          ),
        ],
      );
    }

    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: PdfExportService.bWidget('', fontSize: 8.5),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: PdfExportService.bWidget('',
              fontSize: 8.5, textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: PdfExportService.bWidget('',
              fontSize: 8.5, textAlign: pw.TextAlign.center),
        ),
      ],
    );
  }

  // Helper summary row builder (Label, Taka, Poisa)
  static pw.TableRow _buildSummaryRow(String label, double val,
      {bool isBold = false}) {
    final (taka, poisa) = _formatTakaPoisa(val, isSummary: true);

    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: PdfExportService.bWidget(label,
              fontSize: 8,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: PdfExportService.bWidget(taka,
              fontSize: 8,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: PdfExportService.bWidget(poisa,
              fontSize: 8,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              textAlign: pw.TextAlign.center),
        ),
      ],
    );
  }

  // Formats double value into Bengali Taka and Poisa strings
  static (String, String) _formatTakaPoisa(double amount,
      {bool isSummary = false, bool forceEmpty = false}) {
    if (forceEmpty) return ('', '');
    if (amount == 0 && !isSummary) return ('', '');

    final isNeg = amount < 0;
    final absVal = amount.abs();
    final taka = absVal.truncate();
    final poisaVal = ((absVal - taka) * 100).round();

    String toBan(int num) {
      const eng = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      const ban = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
      String s = num.toString();
      for (int i = 0; i < 10; i++) {
        s = s.replaceAll(eng[i], ban[i]);
      }
      return s;
    }

    final takaStr = (isNeg ? '-' : '') + toBan(taka);
    final poisaStr = poisaVal == 0 ? '০০' : toBan(poisaVal).padLeft(2, '০');

    return (takaStr, poisaStr);
  }
}
