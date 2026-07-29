import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

/// Full-screen Interactive Pinch-to-Zoom PDF Viewer & Printer
class PdfViewerScreen extends StatelessWidget {
  final String title;
  final Future<Uint8List> Function(PdfPageFormat format) buildPdf;
  final String? fileName;

  const PdfViewerScreen({
    super.key,
    required this.title,
    required this.buildPdf,
    this.fileName,
  });

  static Future<void> open(
    BuildContext context, {
    required String title,
    required Future<Uint8List> Function(PdfPageFormat format) buildPdf,
    String? fileName,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(
          title: title,
          buildPdf: buildPdf,
          fileName: fileName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF162032),
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: PdfPreview(
        build: buildPdf,
        allowPrinting: true,
        allowSharing: true,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        maxPageWidth: 750,
        pdfFileName: fileName ?? '$title.pdf',
        loadingWidget: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF059669)),
              SizedBox(height: 16),
              Text(
                'PDF প্রিভিউ ও ডাউনলোড প্রস্তুত হচ্ছে...',
                style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
