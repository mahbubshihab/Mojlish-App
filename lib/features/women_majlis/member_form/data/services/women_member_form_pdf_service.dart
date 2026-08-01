import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';

/// বাংলাদেশ ইসলামী মহিলা মজলিস — প্রাথমিক সদস্যা ফরম (অফিশিয়াল ২-পার্ট A4 Landscape PDF)
class WomenMemberFormPdfService {
  static Future<Uint8List> generatePdfBytes({
    required String name,
    required String fatherOrHusbandName,
    required String motherName,
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
      final bytes = await rootBundle.load(MajlisAssets.mohilaLogo);
      logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {}

    final primaryMagenta = PdfColor.fromHex('#91005A'); // Deep Magenta Theme
    final pageBgColor = PdfColor.fromHex('#F8C8DC'); // Rich Soft Pink Paper Background
    final cardBgColor = PdfColor.fromHex('#FFF5F8'); // Inner Card Crisp Soft Pink/White Tone

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
            padding: const pw.EdgeInsets.all(16),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                // ==========================================
                // LEFT SIDE: আবেদন ফরম অংশ (Office Application Part)
                // ==========================================
                pw.Expanded(
                  flex: 5,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: pw.BoxDecoration(
                      color: pageBgColor,
                      border: pw.Border(right: pw.BorderSide(color: primaryMagenta.shade(0.3), width: 0.8)),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        PdfExportService.bWidget('বিসমিল্লাহির রাহমানির রাহীম', fontSize: 9.0, color: primaryMagenta),
                        pw.SizedBox(height: 3),

                        // Logo & Org Name
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            if (logoImage != null) ...[
                              pw.Image(logoImage, width: 26, height: 26),
                              pw.SizedBox(width: 6),
                            ],
                            PdfExportService.bWidget(
                              'বাংলাদেশ ইসলামী মহিলা মজলিস',
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryMagenta,
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 2),
                        PdfExportService.bWidget('কেন্দ্রীয় কার্যালয়', fontSize: 8.8, fontWeight: pw.FontWeight.bold, color: primaryMagenta),
                        PdfExportService.bWidget('ফায়েনাজ টাওয়ার, ফ্ল্যাট # ১১/এ, ৩৭/২ পুরানা পল্টন', fontSize: 8.0, color: primaryMagenta),
                        PdfExportService.bWidget('(কালভার্ট রোড), ঢাকা-১০০০ । মোবাইল : ০১৮১৫ ০৪২০৮৭', fontSize: 7.8, color: primaryMagenta),
                        PdfExportService.bWidget('E-mail : mahilamajlis@gmail.com', fontSize: 7.5, color: primaryMagenta),
                        pw.SizedBox(height: 6),

                        // Pill Header Badge
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                          decoration: pw.BoxDecoration(
                            color: primaryMagenta,
                            borderRadius: pw.BorderRadius.circular(14),
                          ),
                          child: PdfExportService.bWidget(
                            'প্রাথমিক সদস্যা ফরম',
                            fontSize: 10.5,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 14),

                        // Form Fields
                        _buildDottedField('নাম', name, primaryMagenta),
                        _buildDottedField('পিতা/স্বামীর নাম', fatherOrHusbandName, primaryMagenta),
                        _buildDottedField('মাতার নাম', motherName, primaryMagenta),
                        _buildDottedField('শিক্ষাগত যোগ্যতা', educationalQualification, primaryMagenta),
                        _buildDottedField('বয়স', age, primaryMagenta),
                        _buildDottedField('পেশা', profession, primaryMagenta),
                        _buildDottedField('বর্তমান ঠিকানা', presentAddress, primaryMagenta),
                        _buildDottedField('মোবাইল', mobile, primaryMagenta),
                        _buildDottedField('স্থায়ী ঠিকানা', permanentAddress, primaryMagenta),

                        pw.Spacer(),

                        // Footer Signatures
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            PdfExportService.bWidget('তারিখ : ${dateStr.isEmpty ? "...................." : dateStr}', fontSize: 9.5, color: primaryMagenta),
                            PdfExportService.bWidget('স্বাক্ষর : ....................', fontSize: 9.5, color: primaryMagenta),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                pw.SizedBox(width: 14),

                // ==========================================
                // RIGHT SIDE: সদস্যা অঙ্গীকার পত্র (Member Oath Card with Ornate Double Frame)
                // ==========================================
                pw.Expanded(
                  flex: 5,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: primaryMagenta, width: 2.0),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: primaryMagenta, width: 0.8),
                        borderRadius: pw.BorderRadius.circular(6),
                        color: cardBgColor,
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          PdfExportService.bWidget('বিসমিল্লাহির রাহমানির রাহীম', fontSize: 9.0, color: primaryMagenta),
                          pw.SizedBox(height: 3),

                          // Logo & Org Name
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              if (logoImage != null) ...[
                                pw.Image(logoImage, width: 26, height: 26),
                                pw.SizedBox(width: 6),
                              ],
                              PdfExportService.bWidget(
                                'বাংলাদেশ ইসলামী মহিলা মজলিস',
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                                color: primaryMagenta,
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 2),
                          PdfExportService.bWidget('কেন্দ্রীয় কার্যালয়', fontSize: 8.8, fontWeight: pw.FontWeight.bold, color: primaryMagenta),
                          PdfExportService.bWidget('ফায়েনাজ টাওয়ার, ফ্ল্যাট # ১১/এ, ৩৭/২ পুরানা পল্টন', fontSize: 8.0, color: primaryMagenta),
                          PdfExportService.bWidget('(কালভার্ট রোড), ঢাকা-১০০০ । মোবাইল : ০১৮১৫ ০৪২০৮৭', fontSize: 7.8, color: primaryMagenta),
                          PdfExportService.bWidget('E-mail : mahilamajlis@gmail.com', fontSize: 7.5, color: primaryMagenta),
                          pw.SizedBox(height: 6),

                          // Pill Header Badge
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                            decoration: pw.BoxDecoration(
                              color: primaryMagenta,
                              borderRadius: pw.BorderRadius.circular(14),
                            ),
                            child: PdfExportService.bWidget(
                              'প্রাথমিক সদস্যা ফরম',
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
                              'আমি  ${name.isEmpty ? "..................................................................................................................................." : name}',
                              fontSize: 10.0,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryMagenta,
                            ),
                          ),
                          pw.SizedBox(height: 10),

                          // Member Oath Text
                          PdfExportService.bWidget(
                            'বিশ্বাস করি যে কুরআন, সুন্নাহ ও খেলাফতে রাশেদার অনুসরণের মধ্যেই ইহকালীন কল্যাণ ও পরকালীন মুক্তি নিহিত। এ দেশে খেলাফত রাষ্ট্রব্যবস্থা প্রতিষ্ঠার লক্ষ্যে বাংলাদেশ ইসলামী মহিলা মজলিস গৃহীত কর্মসূচীর সাথে একমত হয়ে একমাত্র আল্লাহর সন্তুষ্টির জন্যই এ সংগঠনে যোগদান করছি। আমি এর যাবতীয় কর্মতৎপরতায় সম্ভাব্য সহযোগিতা করতে সচেষ্ট থাকবো, ইনশাআল্লাহ।',
                            fontSize: 9.8,
                            textAlign: pw.TextAlign.justify,
                            color: primaryMagenta,
                          ),

                          pw.Spacer(),

                          // Footer Signatures
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              PdfExportService.bWidget('তারিখ : ${dateStr.isEmpty ? "...................." : dateStr}', fontSize: 9.5, color: primaryMagenta),
                              PdfExportService.bWidget('স্বাক্ষর : ....................', fontSize: 9.5, color: primaryMagenta),
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
    required String fatherOrHusbandName,
    required String motherName,
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
      fatherOrHusbandName: fatherOrHusbandName,
      motherName: motherName,
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
      name: 'মহিলা_মজলিস_প্রাথমিক_সদস্যা_ফরম',
    );
  }

  static pw.Widget _buildDottedField(String label, String val, PdfColor primaryColor) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 7),
      child: pw.Row(
        children: [
          PdfExportService.bWidget('$label : ', fontSize: 9.2, fontWeight: pw.FontWeight.bold, color: primaryColor),
          pw.Expanded(
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: primaryColor.shade(0.4), width: 0.5)),
              ),
              child: PdfExportService.bWidget(val.isEmpty ? ' ' : val, fontSize: 9.2, color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
