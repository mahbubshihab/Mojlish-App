import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস — প্রাথমিক সদস্য ফরম (অফিশিয়াল ২-পার্ট টপ/বটম Portrait PDF)
class StudentMemberFormPdfService {
  static Future<Uint8List> generatePdfBytes({
    required String name,
    required String fatherName,
    required String eduInstitution,
    required String bloodGroup,
    required String studentClass,
    required String department,
    required String rollNo,
    required String presentAddress,
    required String mobile,
    required String village,
    required String postOffice,
    required String thana,
    required String district,
    String? dateStr,
  }) async {
    final fontRegular = await PdfExportService.loadSutonnyFont();
    final fontBold = await PdfExportService.loadBengaliBoldFont();

    pw.MemoryImage? logoImage;
    try {
      final bytes = await rootBundle.load(MajlisAssets.chatroLogo);
      logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {}

    final primaryCyan = PdfColor.fromHex('#0077B6'); // Offical Chatro Majlis Cyan
    final paperBgColor = PdfColor.fromHex('#E4F0F8'); // Soft Light Blue Paper Background

    final date = dateStr ?? '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: fontRegular,
        bold: fontBold,
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Container(
            color: paperBgColor,
            padding: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: pw.Column(
              children: [
                // ==========================================
                // TOP HALF: অঙ্গীকার নামা অংশ (Top Pledge Part)
                // ==========================================
                pw.Expanded(
                  flex: 5,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      PdfExportService.bWidget('বিসমিল্লাহির রাহমানির রাহীম', fontSize: 9.5, color: primaryCyan),
                      pw.SizedBox(height: 6),

                      // Logo & Org Header
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          if (logoImage != null) ...[
                            pw.Image(logoImage, width: 28, height: 28),
                            pw.SizedBox(width: 6),
                          ],
                          PdfExportService.bWidget(
                            'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryCyan,
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 2),
                      PdfExportService.bWidget('www.chhatra-majlis.org.bd', fontSize: 9.5, color: primaryCyan),
                      pw.SizedBox(height: 8),

                      // Full Width Ribbon Banner
                      pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.symmetric(vertical: 4),
                        color: primaryCyan,
                        child: pw.Center(
                          child: PdfExportService.bWidget(
                            'প্রাথমিক সদস্য ফরম',
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 16),

                      // Member Declaration Line
                      pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: PdfExportService.bWidget(
                          'আমি  ${name.isEmpty ? "..................................................................................................................................." : name}  বিশ্বাস করি যে,',
                          fontSize: 10.5,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryCyan,
                        ),
                      ),
                      pw.SizedBox(height: 8),

                      // Oath Text
                      PdfExportService.bWidget(
                        'ইসলাম আল্লাহর মনোনীত দ্বীন বা জীবনব্যবস্থা এবং এর পূর্ণাঙ্গ অনুসরণের মধ্যেই মানব জীবনে ইহকালীন কল্যাণ ও পরকালীন মুক্তি নিহিত। এ উদ্দেশ্যে বাংলাদেশ ইসলামী ছাত্র মজলিস যে কর্মসূচি গ্রহণ করেছে, আমি তার সাথে একমত হয়ে আল্লাহর সন্তুষ্টি অর্জনের জন্যে এ সংগঠনে যোগদান করছি।',
                        fontSize: 10,
                        textAlign: pw.TextAlign.justify,
                        color: primaryCyan,
                      ),

                      pw.Spacer(),

                      // Top Part Footer Signatures
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          PdfExportService.bWidget('তারিখ : $date', fontSize: 9.5, color: primaryCyan),
                          PdfExportService.bWidget('স্বাক্ষর : ....................', fontSize: 9.5, color: primaryCyan),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                    ],
                  ),
                ),

                // Dashed Line Separator
                pw.Container(
                  margin: const pw.EdgeInsets.symmetric(vertical: 8),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.8, style: pw.BorderStyle.dashed)),
                  ),
                ),

                // ==========================================
                // BOTTOM HALF: তথ্য ফরম অংশ (Bottom Info Form Part)
                // ==========================================
                pw.Expanded(
                  flex: 5,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.SizedBox(height: 10),

                      // Logo & Org Header
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          if (logoImage != null) ...[
                            pw.Image(logoImage, width: 28, height: 28),
                            pw.SizedBox(width: 6),
                          ],
                          PdfExportService.bWidget(
                            'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryCyan,
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 16),

                      // Dotted Form Fields
                      _buildDottedLine('নাম', name, primaryCyan),
                      _buildDottedLine('পিতার নাম', fatherName, primaryCyan),

                      pw.Row(
                        children: [
                          pw.Expanded(flex: 7, child: _buildDottedLine('শিক্ষা প্রতিষ্ঠান', eduInstitution, primaryCyan)),
                          pw.SizedBox(width: 10),
                          pw.Expanded(flex: 4, child: _buildDottedLine('রক্তের গ্রুপ', bloodGroup, primaryCyan)),
                        ],
                      ),

                      pw.Row(
                        children: [
                          pw.Expanded(flex: 3, child: _buildDottedLine('শ্রেণি', studentClass, primaryCyan)),
                          pw.SizedBox(width: 8),
                          pw.Expanded(flex: 4, child: _buildDottedLine('বিভাগ', department, primaryCyan)),
                          pw.SizedBox(width: 8),
                          pw.Expanded(flex: 4, child: _buildDottedLine('ক্রমিক নং', rollNo, primaryCyan)),
                        ],
                      ),

                      _buildDottedLine('বর্তমান ঠিকানা', presentAddress, primaryCyan),
                      _buildDottedLine('মোবাইল', mobile, primaryCyan),

                      pw.Row(
                        children: [
                          pw.Expanded(child: _buildDottedLine('স্থায়ী ঠিকানা : গ্রাম', village, primaryCyan)),
                          pw.SizedBox(width: 10),
                          pw.Expanded(child: _buildDottedLine('ডাকঘর', postOffice, primaryCyan)),
                        ],
                      ),

                      pw.Row(
                        children: [
                          pw.Expanded(child: _buildDottedLine('থানা/উপজেলা', thana, primaryCyan)),
                          pw.SizedBox(width: 10),
                          pw.Expanded(child: _buildDottedLine('জেলা', district, primaryCyan)),
                        ],
                      ),

                      pw.Spacer(),

                      // Bottom Part Footer Signatures
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          PdfExportService.bWidget('তারিখ : $date', fontSize: 9.5, color: primaryCyan),
                          PdfExportService.bWidget('স্বাক্ষর : ....................', fontSize: 9.5, color: primaryCyan),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<void> printOrDownloadPdf({
    required String name,
    required String fatherName,
    required String eduInstitution,
    required String bloodGroup,
    required String studentClass,
    required String department,
    required String rollNo,
    required String presentAddress,
    required String mobile,
    required String village,
    required String postOffice,
    required String thana,
    required String district,
    String? dateStr,
  }) async {
    final pdfBytes = await generatePdfBytes(
      name: name,
      fatherName: fatherName,
      eduInstitution: eduInstitution,
      bloodGroup: bloodGroup,
      studentClass: studentClass,
      department: department,
      rollNo: rollNo,
      presentAddress: presentAddress,
      mobile: mobile,
      village: village,
      postOffice: postOffice,
      thana: thana,
      district: district,
      dateStr: dateStr,
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'ছাত্র_মজলিস_প্রাথমিক_সদস্য_ফরম',
    );
  }

  static pw.Widget _buildDottedLine(String label, String val, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        children: [
          PdfExportService.bWidget('$label : ', fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: color),
          pw.Expanded(
            child: pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey600, width: 0.5)),
              ),
              child: PdfExportService.bWidget(val.isEmpty ? ' ' : val, fontSize: 9.5, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
