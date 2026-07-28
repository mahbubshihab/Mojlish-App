import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

/// Central PDF Export and Download Service for Mojlish App Reports and Forms
class PdfExportService {
  /// Generates a standardized PDF document for any report or form data
  static Future<Uint8List> generateReportPdf({
    required String title,
    required String majlisName,
    required String userName,
    required String period,
    required Map<String, dynamic> dataFields,
    List<List<String>>? tableData,
    List<String>? tableHeaders,
    String? comments,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Container(
              alignment: pw.Alignment.center,
              padding: const pw.EdgeInsets.only(bottom: 16),
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.teal, width: 2)),
              ),
              child: pw.Column(
                children: [
                  pw.Text(
                    majlisName,
                    style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    title,
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Metadata Section
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    cross: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('ব্যবহারকারীর নাম: $userName', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text('মজলিস: $majlisName', style: const pw.TextStyle(fontSize: 11)),
                    ],
                  ),
                  pw.Column(
                    cross: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('সময়কাল: $period', style: const pw.TextStyle(fontSize: 11)),
                      pw.SizedBox(height: 4),
                      pw.Text('তারিখ: ${DateTime.now().toString().split(' ')[0]}', style: const pw.TextStyle(fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Data Fields Section
            if (dataFields.isNotEmpty) ...[
              pw.Text('রিপোর্ট বিবরণী', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.teal800)),
              pw.SizedBox(height: 8),
              pw.Wrap(
                spacing: 12,
                runSpacing: 8,
                children: dataFields.entries.map((entry) {
                  return pw.Container(
                    width: 240,
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(entry.key, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                        pw.Text('${entry.value}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              pw.SizedBox(height: 20),
            ],

            // Table Section (if available)
            if (tableData != null && tableData.isNotEmpty && tableHeaders != null) ...[
              pw.Text('দৈনন্দিন বিবরণী টেবিল', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.teal800)),
              pw.SizedBox(height: 8),
              pw.TableHelper.fromTextArray(
                headers: tableHeaders,
                data: tableData,
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.teal),
                cellStyle: const pw.TextStyle(fontSize: 8),
                cellAlignment: pw.Alignment.center,
              ),
              pw.SizedBox(height: 20),
            ],

            // Comments Section (if available)
            if (comments != null && comments.isNotEmpty) ...[
              pw.Text('মন্তব্য ও পরামর্শ', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.teal800)),
              pw.SizedBox(height: 6),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Text(comments, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800)),
              ),
            ],
          ];
        },
      ),
    );

    return pdf.save();
  }

  /// Downloads or opens the generated PDF print preview sheet
  static Future<void> printOrDownloadPdf({
    required String title,
    required String majlisName,
    required String userName,
    required String period,
    required Map<String, dynamic> dataFields,
    List<List<String>>? tableData,
    List<String>? tableHeaders,
    String? comments,
  }) async {
    final pdfBytes = await generateReportPdf(
      title: title,
      majlisName: majlisName,
      userName: userName,
      period: period,
      dataFields: dataFields,
      tableData: tableData,
      tableHeaders: tableHeaders,
      comments: comments,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: '${majlisName}_${title.replaceAll(' ', '_')}.pdf',
    );
  }

  /// Saves PDF file to local downloads / documents directory
  static Future<File> savePdfToLocalFile({
    required String fileName,
    required Uint8List pdfBytes,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(pdfBytes);
    return file;
  }
}
