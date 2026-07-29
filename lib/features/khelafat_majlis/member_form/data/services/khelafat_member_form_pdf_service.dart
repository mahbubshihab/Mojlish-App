import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';

/// খেলাফত মজলিস — প্রাথমিক সদস্য ফরম (অফিশিয়াল ১-পৃষ্ঠা ২-পার্ট রসিদ ও সদস্য কার্ড PDF)
class KhelafatMemberFormPdfService {
  static Future<Uint8List> generatePdfBytes({
    required String regNo,
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
    final font = await PdfExportService.loadSutonnyFont();

    pw.MemoryImage? logoImage;
    try {
      final bytes = await rootBundle.load(MajlisAssets.khelafatLogo);
      logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {}

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: font,
        bold: font,
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // LEFT SIDE: রসিদ/অফিস কপি (Office Counterfoil)
              pw.Expanded(
                flex: 4,
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400, width: 0.8),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      PdfExportService.bWidget('বিসমিল্লাহির রাহমানির রাহীম', fontSize: 9),
                      pw.SizedBox(height: 2),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          if (logoImage != null) ...[
                            pw.Image(logoImage, width: 24, height: 24),
                            pw.SizedBox(width: 6),
                          ],
                          PdfExportService.bWidget('খেলাফত মজলিস', fontSize: 18, fontWeight: pw.FontWeight.bold),
                        ],
                      ),
                      pw.SizedBox(height: 2),
                      PdfExportService.bWidget('কেন্দ্রীয় কার্যালয়', fontSize: 8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('১৬ বিজয়নগর (৫ম তলা), ঢাকা-১০০০ | ফোন: ০২-৪৯৫৮৫৩২১', fontSize: 7.5),
                      PdfExportService.bWidget('web: www.khelafat-majlis.org, e-mail: khelafatmajlis@gmail.com', fontSize: 7),
                      pw.SizedBox(height: 6),

                      // Badge
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey300,
                          borderRadius: pw.BorderRadius.circular(10),
                        ),
                        child: PdfExportService.bWidget('প্রাথমিক সদস্য ফরম', fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 12),

                      // Fields
                      _buildLeftField('নাম', name),
                      _buildLeftField('পিতার নাম', fatherName),
                      _buildLeftField('শিক্ষাগত যোগ্যতা', educationalQualification),
                      pw.Row(
                        children: [
                          pw.Expanded(child: _buildLeftField('বয়স', age)),
                          pw.SizedBox(width: 8),
                          pw.Expanded(child: _buildLeftField('পেশা', profession)),
                        ],
                      ),
                      _buildLeftField('বর্তমান ঠিকানা', presentAddress),
                      _buildLeftField('মোবাইল', mobile),
                      _buildLeftField('স্থায়ী ঠিকানা', permanentAddress),

                      pw.Spacer(),

                      // Footer Signatures
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          PdfExportService.bWidget('তারিখ: $dateStr', fontSize: 8.5),
                          PdfExportService.bWidget('স্বাক্ষর: .........................', fontSize: 8.5),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              pw.SizedBox(width: 14),

              // RIGHT SIDE: সদস্য কার্ড / শপথ পত্র (Member Card with Decorative Border)
              pw.Expanded(
                flex: 5,
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.amber800, width: 2),
                    borderRadius: pw.BorderRadius.circular(8),
                    color: PdfColors.grey50,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      // Top Row: Bismillah & Reg No
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          PdfExportService.bWidget('বিসমিল্লাহির রাহমানির রাহীম', fontSize: 8.5),
                          PdfExportService.bWidget('নিবন্ধন নং: ${regNo.isEmpty ? "০৩৮" : regNo}', fontSize: 8.5, fontWeight: pw.FontWeight.bold),
                        ],
                      ),
                      pw.SizedBox(height: 2),

                      // Logo & Org Name
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          if (logoImage != null) ...[
                            pw.Image(logoImage, width: 28, height: 28),
                            pw.SizedBox(width: 6),
                          ],
                          PdfExportService.bWidget('খেলাফত মজলিস', fontSize: 20, fontWeight: pw.FontWeight.bold),
                        ],
                      ),
                      pw.SizedBox(height: 2),
                      PdfExportService.bWidget('কেন্দ্রীয় কার্যালয়', fontSize: 8.5, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('১৬ বিজয়নগর (৫ম তলা), ঢাকা-১০০০ | ফোন: ০২-৪৯৫৮৫৩২১', fontSize: 8),
                      PdfExportService.bWidget('web: www.khelafat-majlis.org, e-mail: khelafatmajlis@gmail.com', fontSize: 7.5),
                      pw.SizedBox(height: 6),

                      // Badge
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey300,
                          borderRadius: pw.BorderRadius.circular(10),
                        ),
                        child: PdfExportService.bWidget('প্রাথমিক সদস্য ফরম', fontSize: 11, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 16),

                      // Member Name Line
                      pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: PdfExportService.bWidget('আমি ${name.isEmpty ? "..........................................................................................................................." : name}', fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 10),

                      // Oath Declaration Text
                      pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.white,
                          border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                          borderRadius: pw.BorderRadius.circular(6),
                        ),
                        child: PdfExportService.bWidget(
                          'বিশ্বাস করি যে কুরআন, সুন্নাহ ও খেলাফতে রাশেদার অনুসরণের মধ্যেই ইহকালীন কল্যাণ ও পরকালীন মুক্তি নিহিত। এ দেশে খেলাফত প্রতিষ্ঠার লক্ষ্যে খেলাফত মজলিসের গৃহীত কর্মসূচীর সাথে একমত হয়ে একমাত্র আল্লাহর সন্তুষ্টির জন্যই এ সংগঠনে যোগদান করছি। আমি এর যাবতীয় কর্মকাণ্ডে সম্ভাব্য সহযোগিতা করতে সচেষ্ট থাকবো, ইনশাআল্লাহ।',
                          fontSize: 9.5,
                          textAlign: pw.TextAlign.justify,
                        ),
                      ),

                      pw.Spacer(),

                      // Footer Signatures
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          PdfExportService.bWidget('তারিখ: $dateStr', fontSize: 9),
                          PdfExportService.bWidget('স্বাক্ষর: ...........................................', fontSize: 9, fontWeight: pw.FontWeight.bold),
                        ],
                      ),
                    ],
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

  static pw.Widget _buildLeftField(String label, String val) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        children: [
          PdfExportService.bWidget('$label: ', fontSize: 8.5, fontWeight: pw.FontWeight.bold),
          pw.Expanded(
            child: pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey600, width: 0.5)),
              ),
              child: PdfExportService.bWidget(val.isEmpty ? ' ' : val, fontSize: 8.5),
            ),
          ),
        ],
      ),
    );
  }
}
