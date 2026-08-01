import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

/// Full-screen PDF preview screen with print & share capabilities
class PdfPreviewScreen extends StatelessWidget {
  final Uint8List pdfBytes;
  final String title;
  final String? fileName;

  const PdfPreviewScreen({
    super.key,
    required this.pdfBytes,
    required this.title,
    this.fileName,
  });

  static Future<void> open(
    BuildContext context,
    Uint8List pdfBytes,
    String title, {
    String? fileName,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreviewScreen(
          pdfBytes: pdfBytes,
          title: title,
          fileName: fileName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
      ),
      body: PdfPreview(
        build: (format) async => pdfBytes,
        allowPrinting: true,
        allowSharing: true,
        canChangeOrientation: false,
        canChangePageFormat: false,
        pdfFileName: fileName ?? '$title.pdf',
      ),
    );
  }
}

/// Helper function to open full-screen PDF preview screen in a new MaterialPageRoute
Future<void> openPdfPreview(
  BuildContext context,
  Uint8List pdfBytes,
  String title, {
  String? fileName,
}) async {
  await PdfPreviewScreen.open(context, pdfBytes, title, fileName: fileName);
}
