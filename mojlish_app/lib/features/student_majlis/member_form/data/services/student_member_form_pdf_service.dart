import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/pdf_preview_screen.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস — প্রাথমিক সদস্য ফরম (অফিশিয়াল ২-পার্ট রসিদ ও সদস্য কার্ড PDF)
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
    final font = await PdfExportService.loadSutonnyFont();
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: font,
        bold: font,
      ),
    );

    pw.MemoryImage? logoImage;
    try {
      final bytes = await rootBundle.load(MajlisAssets.chatroLogo);
      logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {}

    final date = dateStr ?? '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // PART 1: Top Pledge Section (Counterfoil / Pledge)
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.cyan800, width: 1),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(b('বিসমিল্লাহির রাহমানির রাহীম'), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        if (logoImage != null) ...[
                          pw.Image(logoImage, width: 28, height: 28),
                          pw.SizedBox(width: 8),
                        ],
                        pw.Text(b('বাংলাদেশ ইসলামী ছাত্র মজলিস'), style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.cyan900)),
                      ],
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text('www.chhatra-majlis.org.bd', style: const pw.TextStyle(fontSize: 9, color: PdfColors.cyan800)),
                    pw.SizedBox(height: 6),
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      color: PdfColors.cyan700,
                      child: pw.Center(
                        child: pw.Text(b('প্রাথমিক সদস্য ফরম'), style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        b('আমি ${name.isNotEmpty ? name : "...................................................................."} বিশ্বাস করি যে,'),
                        style: const pw.TextStyle(fontSize: 10.5),
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      b('ইসলাম আল্লাহর মনোনীত দ্বীন বা জীবনব্যবস্থা এবং এর পূর্ণাঙ্গ অনুসরণের মধ্যেই মানব জীবনে ইহকালীন কল্যাণ ও পরকালীন মুক্তি নিহিত। এ উদ্দেশ্যে বাংলাদেশ ইসলামী ছাত্র মজলিস যে কর্মসূচি গ্রহণ করেছে, আমি তার সাথে একমত হয়ে আল্লাহর সন্তুষ্টি অর্জনের জন্যে এ সংগঠনে যোগদান করছি।'),
                      textAlign: pw.TextAlign.justify,
                      style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.3),
                    ),
                    pw.SizedBox(height: 16),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(b('তারিখ : $date'), style: const pw.TextStyle(fontSize: 9.5)),
                        pw.Text(b('স্বাক্ষর : .....................'), style: const pw.TextStyle(fontSize: 9.5)),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),

              // PART 2: Bottom Personal Info Section (Member Form / Card)
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.cyan800, width: 1),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        if (logoImage != null) ...[
                          pw.Image(logoImage, width: 28, height: 28),
                          pw.SizedBox(width: 8),
                        ],
                        pw.Text(b('বাংলাদেশ ইসলামী ছাত্র মজলিস'), style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.cyan900)),
                      ],
                    ),
                    pw.SizedBox(height: 12),
                    _buildFieldRow('নাম :', name.isNotEmpty ? name : '....................................................................................................'),
                    _buildFieldRow('পিতার নাম :', fatherName.isNotEmpty ? fatherName : '....................................................................................................'),
                    pw.Row(
                      children: [
                        pw.Expanded(child: _buildFieldRow('শিক্ষা প্রতিষ্ঠান :', eduInstitution.isNotEmpty ? eduInstitution : '..................................................')),
                        pw.SizedBox(width: 8),
                        _buildFieldRow('রক্তের গ্রুপ :', bloodGroup.isNotEmpty ? bloodGroup : '....................'),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Expanded(child: _buildFieldRow('শ্রেণি :', studentClass.isNotEmpty ? studentClass : '....................')),
                        pw.Expanded(child: _buildFieldRow('বিভাগ :', department.isNotEmpty ? department : '....................')),
                        _buildFieldRow('ক্রমিক নং :', rollNo.isNotEmpty ? rollNo : '....................'),
                      ],
                    ),
                    _buildFieldRow('বর্তমান ঠিকানা :', presentAddress.isNotEmpty ? presentAddress : '....................................................................................................'),
                    _buildFieldRow('মোবাইল :', mobile.isNotEmpty ? mobile : '....................................................................................................'),
                    pw.Row(
                      children: [
                        pw.Expanded(child: _buildFieldRow('স্থায়ী ঠিকানা : গ্রাম :', village.isNotEmpty ? village : '........................................')),
                        pw.SizedBox(width: 8),
                        _buildFieldRow('ডাকঘর :', postOffice.isNotEmpty ? postOffice : '........................................'),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Expanded(child: _buildFieldRow('থানা/উপজেলা :', thana.isNotEmpty ? thana : '........................................')),
                        pw.SizedBox(width: 8),
                        _buildFieldRow('জেলা :', district.isNotEmpty ? district : '........................................'),
                      ],
                    ),
                    pw.SizedBox(height: 16),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(b('তারিখ : $date'), style: const pw.TextStyle(fontSize: 9.5)),
                        pw.Text(b('স্বাক্ষর : .....................'), style: const pw.TextStyle(fontSize: 9.5)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildFieldRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        children: [
          pw.Text(b(label), style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: PdfColors.cyan900)),
          pw.SizedBox(width: 4),
          pw.Expanded(
            child: pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5)),
              ),
              child: pw.Text(b(value), style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.blue900)),
            ),
          ),
        ],
      ),
    );
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
    BuildContext? context,
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

    if (context != null) {
      await openPdfPreview(
        context,
        pdfBytes,
        'প্রাথমিক সদস্য ফরম',
        fileName: 'Chatro_Majlis_Member_Form.pdf',
      );
    } else {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: 'Chatro_Majlis_Member_Form.pdf',
      );
    }
  }
}
