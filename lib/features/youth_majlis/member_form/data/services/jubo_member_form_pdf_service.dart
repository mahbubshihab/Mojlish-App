import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';

/// ইসলামী যুব মজলিস — প্রাথমিক সদস্য ফরম (অফিশিয়াল ২-পার্ট A4 Landscape PDF)
class JuboMemberFormPdfService {
  static Future<Uint8List> generatePdfBytes({
    required String name,
    required String fatherName,
    required String nidNo,
    required String village,
    required String unionName,
    required String thana,
    required String district,
    required String presentAddress,
    required String mobile,
    required String email,
    required String dateStr,
  }) async {
    final fontRegular = await PdfExportService.loadSutonnyFont();
    final fontBold = await PdfExportService.loadBengaliBoldFont();

    pw.MemoryImage? logoImage;
    try {
      final bytes = await rootBundle.load(MajlisAssets.juboLogo);
      logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {}

    final royalBlue = PdfColor.fromHex('#0D3B66');
    final darkGreen = PdfColor.fromHex('#155D27');
    final cyanAccent = PdfColor.fromHex('#00A8E8');
    final bronzeAccent = PdfColor.fromHex('#C68B59');
    final cardBgColor = PdfColors.white;

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: fontRegular,
        bold: fontBold,
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        build: (pw.Context context) {
          return pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // ==========================================
              // LEFT SIDE: আবেদন ফরম অংশ (Office Application Part)
              // ==========================================
              pw.Expanded(
                flex: 5,
                child: pw.Stack(
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.only(left: 12, right: 10, top: 10, bottom: 10),
                      decoration: pw.BoxDecoration(
                        color: cardBgColor,
                        border: pw.Border.all(color: cyanAccent, width: 1.2),
                        borderRadius: pw.BorderRadius.circular(6),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          PdfExportService.bWidget('বিসমিল্লাহির রাহমানির রাহীম', fontSize: 9.0),
                          pw.SizedBox(height: 2),

                          // Logo & Org Name
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              if (logoImage != null) ...[
                                pw.Image(logoImage, width: 26, height: 26),
                                pw.SizedBox(width: 6),
                              ],
                              PdfExportService.bWidget(
                                'ইসলামী যুব মজলিস',
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold,
                                color: royalBlue,
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 1),
                          PdfExportService.bWidget('১৬, বিজয়নগর, (৫ম তলা), পুরানা পল্টন, ঢাকা-১০০০', fontSize: 8.0),
                          PdfExportService.bWidget('http://islamijubomajlis.org', fontSize: 7.5, color: royalBlue),
                          pw.SizedBox(height: 6),

                          // Pill Header Badge
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                            decoration: pw.BoxDecoration(
                              color: darkGreen,
                              borderRadius: pw.BorderRadius.circular(14),
                            ),
                            child: PdfExportService.bWidget(
                              'প্রাথমিক সদস্য ফরম',
                              fontSize: 10.5,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                          pw.SizedBox(height: 12),

                          // Form Fields
                          _buildDottedField('নাম', name),
                          _buildDottedField('পিতা', fatherName),
                          _buildDottedField('জাতীয় পরিচয়পত্র নং', nidNo),
                          _buildDottedField('ঠিকানা: গ্রাম', village),
                          pw.Row(
                            children: [
                              pw.Expanded(child: _buildDottedField('ইউনিয়ন', unionName)),
                              pw.SizedBox(width: 10),
                              pw.Expanded(child: _buildDottedField('থানা ও উপজেলা', thana)),
                            ],
                          ),
                          _buildDottedField('জেলা', district),
                          _buildDottedField('বর্তমান ঠিকানা', presentAddress),
                          _buildDottedField('মোবাইল', mobile),
                          _buildDottedField('ইমেইল', email),

                          pw.Spacer(),

                          // Footer Signatures
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              PdfExportService.bWidget('যোগদানের তারিখ : ${dateStr.isEmpty ? "...................." : dateStr}', fontSize: 9),
                              PdfExportService.bWidget('স্বাক্ষর : ....................', fontSize: 9),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Left Edge Blue Arc Accent
                    pw.Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: pw.Container(
                        width: 5,
                        decoration: pw.BoxDecoration(
                          color: cyanAccent,
                          borderRadius: const pw.BorderRadius.only(
                            topLeft: pw.Radius.circular(6),
                            bottomLeft: pw.Radius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(width: 14),

              // ==========================================
              // RIGHT SIDE: সদস্য অঙ্গীকার পত্র (Member Oath Card with Geometric Corner Frame)
              // ==========================================
              pw.Expanded(
                flex: 5,
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: darkGreen, width: 1.8),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: bronzeAccent, width: 0.8),
                      borderRadius: pw.BorderRadius.circular(4),
                      color: cardBgColor,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        PdfExportService.bWidget('বিসমিল্লাহির রাহমানির রাহীম', fontSize: 9.0),
                        pw.SizedBox(height: 2),

                        // Logo & Org Name
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            if (logoImage != null) ...[
                              pw.Image(logoImage, width: 26, height: 26),
                              pw.SizedBox(width: 6),
                            ],
                            PdfExportService.bWidget(
                              'ইসলামী যুব মজলিস',
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                              color: royalBlue,
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 1),
                        PdfExportService.bWidget('১৬, বিজয়নগর, (৫ম তলা), পুরানা পল্টন, ঢাকা-১০০০', fontSize: 8.0),
                        PdfExportService.bWidget('http://islamijubomajlis.org', fontSize: 7.5, color: royalBlue),
                        pw.SizedBox(height: 6),

                        // Pill Header Badge
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                          decoration: pw.BoxDecoration(
                            color: darkGreen,
                            borderRadius: pw.BorderRadius.circular(14),
                          ),
                          child: PdfExportService.bWidget(
                            'প্রাথমিক সদস্য ফরম',
                            fontSize: 10.5,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 18),

                        // Member Declaration Line
                        pw.Align(
                          alignment: pw.Alignment.centerLeft,
                          child: PdfExportService.bWidget(
                            'আমি  ${name.isEmpty ? "..................................................................................................................................." : name}  দৃঢ়ভাবে বিশ্বাস করি যে,',
                            fontSize: 9.8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 10),

                        // Member Oath Text
                        PdfExportService.bWidget(
                          'ইসলামই আল্লাহর একমাত্র মনোনীত জীবনব্যবস্থা। ইসলামী আদর্শের আলোকে যুবসমাজের নেতৃত্বে একটি কল্যাণমুখী সমাজ গড়ার লক্ষ্যে ইসলামী যুব মজলিসের সাথে একমত হয়ে এ সংগঠনে যোগদান করছি।',
                          fontSize: 9.5,
                          textAlign: pw.TextAlign.justify,
                        ),
                        pw.SizedBox(height: 8),
                        PdfExportService.bWidget(
                          'আমি এ লক্ষ্য অর্জনে যথাসাধ্য চেষ্টা করবো ইনশাআল্লাহ।',
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          textAlign: pw.TextAlign.left,
                        ),

                        pw.Spacer(),

                        // Footer Signatures
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            PdfExportService.bWidget('তারিখ : ${dateStr.isEmpty ? "...................." : dateStr}', fontSize: 9.0),
                            PdfExportService.bWidget('স্বাক্ষর : ....................', fontSize: 9.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<void> printOrDownloadPdf({
    required String name,
    required String fatherName,
    required String nidNo,
    required String village,
    required String unionName,
    required String thana,
    required String district,
    required String presentAddress,
    required String mobile,
    required String email,
    required String dateStr,
  }) async {
    final pdfBytes = await generatePdfBytes(
      name: name,
      fatherName: fatherName,
      nidNo: nidNo,
      village: village,
      unionName: unionName,
      thana: thana,
      district: district,
      presentAddress: presentAddress,
      mobile: mobile,
      email: email,
      dateStr: dateStr,
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'যুব_মজলিস_প্রাথমিক_সদস্য_ফরম',
    );
  }

  static pw.Widget _buildDottedField(String label, String val) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        children: [
          PdfExportService.bWidget('$label : ', fontSize: 9.2, fontWeight: pw.FontWeight.bold),
          pw.Expanded(
            child: pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey700, width: 0.5)),
              ),
              child: PdfExportService.bWidget(val.isEmpty ? ' ' : val, fontSize: 9.2),
            ),
          ),
        ],
      ),
    );
  }
}
