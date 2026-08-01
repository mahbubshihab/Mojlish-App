import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/student_majlis/baytulmal_report/domain/entities/baytulmal_report_entity.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/pdf_preview_screen.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস — বায়তুলমাল রিপোর্ট ডেডিকেটেড পিডিএফ সার্ভিস
/// ডেমো ফরম্যাটের (chatro_baytulmal_p1.png) শতভাগ হুবহু ২-কলাম টেবিল ও সামারি লেআউট
class StudentBaytulmalPdfService {
  /// ডেমো ফরম লেআউট অনুযায়ী পিডিএফ বাইটস জেনারেট করা
  static Future<Uint8List> generatePdfBytes({
    required BaytulmalReportEntity report,
  }) async {
    final font = await PdfExportService.loadSutonnyFont();

    pw.MemoryImage? logoImage;
    try {
      final bytes = await rootBundle.load(MajlisAssets.chatroLogo);
      logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {}

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: font,
        bold: font,
      ),
    );

    // হিসাব নির্ধারণ
    final double motAy = report.motAy > 0
        ? report.motAy
        : (report.jonoshoktiIyanot +
            report.shakhaIyanot +
            report.shuvakangkhiIyanot +
            report.ekkalinAy);

    final double sorbomotAy = report.sorbomotAy > 0
        ? report.sorbomotAy
        : (motAy + report.bigotoSeshonMasherUdbritto);

    final double motBay = report.motBay > 0
        ? report.motBay
        : (report.urdhotonIyanotPorishodh +
            report.urdhotonSofor +
            report.office +
            report.jatayat +
            report.jogajog +
            report.prochar);

    final double sorbomotBay = report.sorbomotBay > 0
        ? report.sorbomotBay
        : (motBay + report.bigotoSeshonMasherGhatti);

    final double udbrittoBaGhatti = sorbomotAy - sorbomotBay;

    final primaryBlue = PdfColor.fromHex('#004b92');
    final tableHeaderBg = PdfColor.fromHex('#e8f1fd');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // ================= TOP HEADER =================
              PdfExportService.bWidget('বিসমিল্লাহির রাহমানির রাহীম',
                  fontSize: 9.5, textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 2),
              PdfExportService.bWidget('বায়তুলমাল রিপোর্ট',
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                  textAlign: pw.TextAlign.center,
                  color: primaryBlue),
              pw.SizedBox(height: 4),

              // Logo + Organization Title
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (logoImage != null) ...[
                    pw.Image(logoImage, width: 34, height: 34),
                    pw.SizedBox(width: 8),
                  ],
                  PdfExportService.bWidget('বাংলাদেশ ইসলামী ছাত্র মজলিস',
                      fontSize: 21,
                      fontWeight: pw.FontWeight.bold,
                      color: primaryBlue),
                ],
              ),
              pw.SizedBox(height: 10),

              // ================= INFO ROW BOX (শাখা, মাস, সেশন) =================
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: primaryBlue, width: 0.8),
                ),
                padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    PdfExportService.bWidget(
                        'শাখা : ${report.branch.isEmpty ? "...................................." : report.branch}',
                        fontSize: 10.5,
                        fontWeight: pw.FontWeight.bold),
                    PdfExportService.bWidget(
                        'মাস : ${report.month.isEmpty ? "...................................." : report.month}',
                        fontSize: 10.5,
                        fontWeight: pw.FontWeight.bold),
                    PdfExportService.bWidget(
                        'সেশন : ${report.session.isEmpty ? "...................................." : report.session}',
                        fontSize: 10.5,
                        fontWeight: pw.FontWeight.bold),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),

              // ================= SECTION 1: আয় =================
              pw.Container(
                width: double.infinity,
                color: PdfColor.fromHex('#d0e1f9'),
                padding: const pw.EdgeInsets.symmetric(vertical: 3),
                alignment: pw.Alignment.center,
                child: PdfExportService.bWidget('আয়',
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryBlue),
              ),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: primaryBlue),
                columnWidths: const {
                  0: pw.FlexColumnWidth(5.5),
                  1: pw.FlexColumnWidth(2),
                  2: pw.FlexColumnWidth(1.2),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: tableHeaderBg),
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3.5),
                          child: PdfExportService.bWidget('আয়ের উৎস',
                              fontSize: 9.5, fontWeight: pw.FontWeight.bold)),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3.5),
                          child: PdfExportService.bWidget('টাকা',
                              fontSize: 9.5,
                              fontWeight: pw.FontWeight.bold,
                              textAlign: pw.TextAlign.center)),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3.5),
                          child: PdfExportService.bWidget('পয়সা',
                              fontSize: 9.5,
                              fontWeight: pw.FontWeight.bold,
                              textAlign: pw.TextAlign.center)),
                    ],
                  ),
                  _buildRow('১ । জনশক্তি এয়ানত (সদস্য/সহযোগী সদস্য/কর্মী)',
                      report.jonoshoktiIyanot),
                  _buildRow('২ । শাখা এয়ানত', report.shakhaIyanot),
                  _buildRow('৩ । শুভাকাঙ্ক্ষী এয়ানত', report.shuvakangkhiIyanot),
                  _buildRow(
                      '৪ । এককালীন আয় (বিস্তারিত আলাদা কাগজে)', report.ekkalinAy),
                  _buildRow('', 0, forceEmpty: true),
                  _buildRow('', 0, forceEmpty: true),
                  _buildRow('', 0, forceEmpty: true),
                  _buildRow('', 0, forceEmpty: true),
                ],
              ),

              // Income Summary Block (Matching Demo Photo)
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    left: pw.BorderSide(color: primaryBlue, width: 0.5),
                    right: pw.BorderSide(color: primaryBlue, width: 0.5),
                    bottom: pw.BorderSide(color: primaryBlue, width: 0.5),
                  ),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Left: কথায়
                    pw.Expanded(
                      flex: 55,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(6),
                        alignment: pw.Alignment.topLeft,
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(color: primaryBlue, width: 0.5),
                          ),
                        ),
                        child: PdfExportService.bWidget(
                            'কথায় : ${report.motAyInWords.isEmpty ? "........................................................................................................" : report.motAyInWords}',
                            fontSize: 9),
                      ),
                    ),
                    // Right: Summary Table (মোট আয়, বিগত উদ্বৃত্ত, সর্বমোট আয়)
                    pw.Expanded(
                      flex: 32,
                      child: pw.Table(
                        border: pw.TableBorder.all(width: 0.5, color: primaryBlue),
                        columnWidths: const {
                          0: pw.FlexColumnWidth(2),
                          1: pw.FlexColumnWidth(1.2),
                        },
                        children: [
                          _buildSummaryRow(
                              'মোট আয়', motAy),
                          _buildSummaryRow(
                              'বিগত সেশন/মাসের উদ্বৃত্ত',
                              report.bigotoSeshonMasherUdbritto),
                          _buildSummaryRow(
                              'সর্বমোট আয়', sorbomotAy,
                              isBold: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // ================= SECTION 2: ব্যয় =================
              pw.Container(
                width: double.infinity,
                color: PdfColor.fromHex('#d0e1f9'),
                padding: const pw.EdgeInsets.symmetric(vertical: 3),
                alignment: pw.Alignment.center,
                child: PdfExportService.bWidget('ব্যয়',
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryBlue),
              ),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: primaryBlue),
                columnWidths: const {
                  0: pw.FlexColumnWidth(5.5),
                  1: pw.FlexColumnWidth(2),
                  2: pw.FlexColumnWidth(1.2),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: tableHeaderBg),
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3.5),
                          child: PdfExportService.bWidget('ব্যয়ের খাত',
                              fontSize: 9.5, fontWeight: pw.FontWeight.bold)),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3.5),
                          child: PdfExportService.bWidget('টাকা',
                              fontSize: 9.5,
                              fontWeight: pw.FontWeight.bold,
                              textAlign: pw.TextAlign.center)),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3.5),
                          child: PdfExportService.bWidget('পয়সা',
                              fontSize: 9.5,
                              fontWeight: pw.FontWeight.bold,
                              textAlign: pw.TextAlign.center)),
                    ],
                  ),
                  _buildRow('১ । ঊর্ধ্বতন এয়ানত পরিশোধ',
                      report.urdhotonIyanotPorishodh),
                  _buildRow('২ । ঊর্ধ্বতন সফর', report.urdhotonSofor),
                  _buildRow('৩ । অফিস', report.office),
                  _buildRow('৪ । যাতায়াত', report.jatayat),
                  _buildRow('৫ । যোগাযোগ', report.jogajog),
                  _buildRow('৬ । প্রচার', report.prochar),
                  _buildRow('', 0, forceEmpty: true),
                  _buildRow('', 0, forceEmpty: true),
                  _buildRow('', 0, forceEmpty: true),
                ],
              ),

              // Expense Summary Block (Matching Demo Photo)
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    left: pw.BorderSide(color: primaryBlue, width: 0.5),
                    right: pw.BorderSide(color: primaryBlue, width: 0.5),
                    bottom: pw.BorderSide(color: primaryBlue, width: 0.5),
                  ),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Left: কথায় & Note
                    pw.Expanded(
                      flex: 55,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(6),
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(color: primaryBlue, width: 0.5),
                          ),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            PdfExportService.bWidget(
                                'কথায় : ${report.motBayInWords.isEmpty ? "........................................................................................................" : report.motBayInWords}',
                                fontSize: 9),
                            pw.SizedBox(height: 20),
                            PdfExportService.bWidget(
                                '(ঘাটতি তালিকার বিস্তারিত আলাদা কাগজে)',
                                fontSize: 8.5,
                                color: PdfColors.grey700),
                          ],
                        ),
                      ),
                    ),
                    // Right: Summary Table (মোট ব্যয়, বিগত ঘাটতি, সর্বমোট ব্যয়, সর্বমোট আয়, উদ্বৃত্ত/ঘাটতি)
                    pw.Expanded(
                      flex: 32,
                      child: pw.Table(
                        border: pw.TableBorder.all(width: 0.5, color: primaryBlue),
                        columnWidths: const {
                          0: pw.FlexColumnWidth(2),
                          1: pw.FlexColumnWidth(1.2),
                        },
                        children: [
                          _buildSummaryRow(
                              'মোট ব্যয়', motBay),
                          _buildSummaryRow(
                              'বিগত সেশন/মাসের ঘাটতি',
                              report.bigotoSeshonMasherGhatti),
                          _buildSummaryRow(
                              'সর্বমোট ব্যয়', sorbomotBay,
                              isBold: true),
                          _buildSummaryRow(
                              'সর্বমোট আয়', sorbomotAy,
                              isBold: true),
                          _buildSummaryRow(
                              'উদ্বৃত্ত/ঘাটতি', udbrittoBaGhatti,
                              isBold: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.Spacer(),

              // ================= FOOTER SIGNATURE =================
              pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    PdfExportService.bWidget(
                        '..................................................',
                        fontSize: 9.5),
                    pw.SizedBox(height: 3),
                    PdfExportService.bWidget(
                        report.presidentSignature.isNotEmpty
                            ? 'সভাপতির স্বাক্ষর: ${report.presidentSignature}'
                            : 'সভাপতির স্বাক্ষর',
                        fontSize: 9.5,
                        fontWeight: pw.FontWeight.bold),
                  ],
                ),
              ),
              pw.SizedBox(height: 4),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// শেয়ার / প্রিন্ট করার অ্যাকশন সুবিধা
  static Future<void> generateAndSharePdf(BaytulmalReportEntity report, {BuildContext? context}) async {
    final bytes = await generatePdfBytes(report: report);
    final fileName = 'chatro_baytulmal_report_${report.branch.isEmpty ? "shakha" : report.branch}_${report.month.isEmpty ? "month" : report.month}.pdf';
    if (context != null) {
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

  // Helper row builder for main tables (Taka & Poisa split)
  static pw.TableRow _buildRow(String label, double val,
      {bool forceEmpty = false}) {
    final (taka, poisa) = _formatTakaPoisa(val, forceEmpty: forceEmpty);

    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: PdfExportService.bWidget(label, fontSize: 9),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: PdfExportService.bWidget(taka,
              fontSize: 9, textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: PdfExportService.bWidget(poisa,
              fontSize: 9, textAlign: pw.TextAlign.center),
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
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: PdfExportService.bWidget(label,
              fontSize: 8.5,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: PdfExportService.bWidget(taka,
              fontSize: 8.5,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: PdfExportService.bWidget(poisa,
              fontSize: 8.5,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              textAlign: pw.TextAlign.center),
        ),
      ],
    );
  }

  // Formats double value into Taka and Poisa strings
  static (String, String) _formatTakaPoisa(double amount,
      {bool forceEmpty = false, bool isSummary = false}) {
    if (forceEmpty) {
      return ('', '');
    }
    if (amount == 0 && !isSummary) {
      return ('', '');
    }

    final taka = amount.truncate().toString();
    final poisaVal = ((amount - amount.truncate()).abs() * 100).round();
    final poisa = poisaVal == 0 ? '০০' : poisaVal.toString().padLeft(2, '0');

    return (taka, poisa);
  }
}
