import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';

/// খেলাফত মজলিস — প্রাথমিক সদস্য ফরম (অফিশিয়াল ১টি প্রিমিয়াম A4 Landscape PDF)
class KhelafatMemberFormPdfService {
  static Future<Uint8List> generatePdfBytes({
    required String name,
    required String fatherName,
    required String educationalQualification,
    required String age,
    required String profession,
    required String presentAddress,
    required String mobile,
    required String permanentAddress,
    required String dateStr,
  }) async {
    final fontRegular = await PdfExportService.loadSutonnyFont();
    final fontBold = await PdfExportService.loadBengaliBoldFont();

    pw.MemoryImage? logoImage;
    try {
      final bytes = await rootBundle.load(MajlisAssets.khelafatLogo);
      logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {}

    final primaryGreen = PdfColor.fromHex('#1B5E20'); // Rich Deep Emerald Green
    final goldAccent = PdfColor.fromHex('#B8860B'); // Warm Gold Accent
    final pageBgColor = PdfColor.fromHex('#F5EAD4'); // Rich Golden Cream Paper Tone
    final cardBgColor = PdfColor.fromHex('#FAF4E4'); // Inner Card Warm Soft White Tone

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: fontRegular,
        bold: fontBold,
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Container(
            color: pageBgColor,
            padding: const pw.EdgeInsets.all(20),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                // ==========================================
                // LEFT SIDE: আবেদন ফরম অংশ (Office Application Part)
                // ==========================================
                pw.Expanded(
                  flex: 5,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: pw.BoxDecoration(
                      color: pageBgColor,
                      border: pw.Border(right: pw.BorderSide(color: goldAccent.shade(0.3), width: 0.8)),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        PdfExportService.bWidget('বিসমিল্লাহির রাহমানির রাহীম', fontSize: 9.5, color: PdfColor.fromHex('#3D331E')),
                        pw.SizedBox(height: 4),

                        // Logo & Org Name
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            if (logoImage != null) ...[
                              pw.Image(logoImage, width: 28, height: 28),
                              pw.SizedBox(width: 8),
                            ],
                            PdfExportService.bWidget(
                              'খেলাফত মজলিস',
                              fontSize: 22,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryGreen,
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 2),
                        PdfExportService.bWidget('কেন্দ্রীয় কার্যালয়', fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#2D2718')),
                        PdfExportService.bWidget('১৬ বিজয়নগর (৫ম তলা), ঢাকা-১০০০ । ফোন : ০২-৪৭১১৫৪২১', fontSize: 8.8, color: PdfColor.fromHex('#2D2718')),
                        PdfExportService.bWidget('web : www.khelafat-majlis.org, e-mail : khelafatmajlis@gmail.com', fontSize: 8.2, color: PdfColor.fromHex('#2D2718')),
                        pw.SizedBox(height: 8),

                        // Pill Header Badge
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 3.5),
                          decoration: pw.BoxDecoration(
                            color: primaryGreen,
                            borderRadius: pw.BorderRadius.circular(14),
                          ),
                          child: PdfExportService.bWidget(
                            'প্রাথমিক সদস্য ফরম',
                            fontSize: 11.5,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 18),

                        // Form Fields (Spacious & Crisp)
                        _buildDottedField('নাম', name, primaryGreen),
                        _buildDottedField('পিতার নাম', fatherName, primaryGreen),
                        _buildDottedField('শিক্ষাগত যোগ্যতা', educationalQualification, primaryGreen),
                        pw.Row(
                          children: [
                            pw.Expanded(child: _buildDottedField('বয়স', age, primaryGreen)),
                            pw.SizedBox(width: 12),
                            pw.Expanded(child: _buildDottedField('পেশা', profession, primaryGreen)),
                          ],
                        ),
                        _buildDottedField('বর্তমান ঠিকানা', presentAddress, primaryGreen),
                        _buildDottedField('মোবাইল', mobile, primaryGreen),
                        _buildDottedField('স্থায়ী ঠিকানা', permanentAddress, primaryGreen),

                        pw.Spacer(),

                        // Footer Signatures
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            PdfExportService.bWidget('তারিখ : ${dateStr.isEmpty ? "...................." : dateStr}', fontSize: 10, color: PdfColor.fromHex('#2D2718')),
                            PdfExportService.bWidget('স্বাক্ষর : ....................', fontSize: 10, color: PdfColor.fromHex('#2D2718')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                pw.SizedBox(width: 16),

                // ==========================================
                // RIGHT SIDE: সদস্য অঙ্গীকার পত্র (Member Oath Card with Ornate Frame)
                // ==========================================
                pw.Expanded(
                  flex: 5,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: primaryGreen, width: 2.2),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(14),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: goldAccent, width: 1.0),
                        borderRadius: pw.BorderRadius.circular(6),
                        color: cardBgColor,
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          PdfExportService.bWidget('বিসমিল্লাহির রাহমানির রাহীম', fontSize: 9.5, color: PdfColor.fromHex('#3D331E')),
                          pw.SizedBox(height: 4),

                          // Logo & Org Name
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              if (logoImage != null) ...[
                                pw.Image(logoImage, width: 28, height: 28),
                                pw.SizedBox(width: 8),
                              ],
                              PdfExportService.bWidget(
                                'খেলাফত মজলিস',
                                fontSize: 22,
                                fontWeight: pw.FontWeight.bold,
                                color: primaryGreen,
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 2),
                          PdfExportService.bWidget('কেন্দ্রীয় কার্যালয়', fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#2D2718')),
                          PdfExportService.bWidget('১৬ বিজয়নগর (৫ম তলা), ঢাকা-১০০০ । ফোন : ০২-৪৭১১৫৪২১', fontSize: 8.8, color: PdfColor.fromHex('#2D2718')),
                          PdfExportService.bWidget('web : www.khelafat-majlis.org, e-mail : khelafatmajlis@gmail.com', fontSize: 8.2, color: PdfColor.fromHex('#2D2718')),
                          pw.SizedBox(height: 8),

                          // Pill Header Badge
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 3.5),
                            decoration: pw.BoxDecoration(
                              color: primaryGreen,
                              borderRadius: pw.BorderRadius.circular(14),
                            ),
                            child: PdfExportService.bWidget(
                              'প্রাথমিক সদস্য ফরম',
                              fontSize: 11.5,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                          pw.SizedBox(height: 22),

                          // Member Declaration Line
                          pw.Align(
                            alignment: pw.Alignment.centerLeft,
                            child: PdfExportService.bWidget(
                              'আমি  ${name.isEmpty ? "..................................................................................................................................." : name}',
                              fontSize: 11.0,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#1F261D'),
                            ),
                          ),
                          pw.SizedBox(height: 12),

                          // Member Oath Text
                          PdfExportService.bWidget(
                            'বিশ্বাস করি যে কুরআন, সুন্নাহ ও খেলাফতে রাশেদার অনুসরণের মধ্যেই ইহকালীন কল্যাণ ও পরকালীন মুক্তি নিহিত। এ দেশে খেলাফত প্রতিষ্ঠার লক্ষ্যে খেলাফত মজলিসের গৃহীত কর্মসূচীর সাথে একমত হয়ে একমাত্র আল্লাহর সন্তুষ্টির জন্যই এ সংগঠনে যোগদান করছি। আমি এর যাবতীয় কর্মতৎপরতায় সম্ভাব্য সহযোগিতা করতে সচেষ্ট থাকবো, ইনশাআল্লাহ।',
                            fontSize: 10.8,
                            textAlign: pw.TextAlign.justify,
                            color: PdfColor.fromHex('#1F261D'),
                          ),

                          pw.Spacer(),

                          // Footer Signatures
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              PdfExportService.bWidget('তারিখ : ${dateStr.isEmpty ? "...................." : dateStr}', fontSize: 10, color: PdfColor.fromHex('#2D2718')),
                              PdfExportService.bWidget('স্বাক্ষর : ....................', fontSize: 10, color: PdfColor.fromHex('#2D2718')),
                            ],
                          ),
                        ],
                      ),
                    ),
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
    required String educationalQualification,
    required String age,
    required String profession,
    required String presentAddress,
    required String mobile,
    required String permanentAddress,
    required String dateStr,
  }) async {
    final pdfBytes = await generatePdfBytes(
      name: name,
      fatherName: fatherName,
      educationalQualification: educationalQualification,
      age: age,
      profession: profession,
      presentAddress: presentAddress,
      mobile: mobile,
      permanentAddress: permanentAddress,
      dateStr: dateStr,
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'খেলাফত_মজলিস_প্রাথমিক_সদস্য_ফরম',
    );
  }

  static pw.Widget _buildDottedField(String label, String val, PdfColor labelColor) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Row(
        children: [
          PdfExportService.bWidget('$label : ', fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#2D2718')),
          pw.Expanded(
            child: pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey700, width: 0.5)),
              ),
              child: PdfExportService.bWidget(val.isEmpty ? ' ' : val, fontSize: 10, color: PdfColor.fromHex('#1F261D')),
            ),
          ),
        ],
      ),
    );
  }
}
