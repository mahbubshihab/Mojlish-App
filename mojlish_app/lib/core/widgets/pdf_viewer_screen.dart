import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

/// Full-screen Interactive Pinch-to-Zoom PDF Viewer & Printer
class PdfViewerScreen extends StatefulWidget {
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
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    final Matrix4 matrix = _transformationController.value.clone();
    matrix.scaleByDouble(1.2, 1.2, 1.0, 1.0);
    _transformationController.value = matrix;
  }

  void _zoomOut() {
    final Matrix4 matrix = _transformationController.value.clone();
    matrix.scaleByDouble(1 / 1.2, 1 / 1.2, 1.0, 1.0);
    _transformationController.value = matrix;
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF162032),
        foregroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            tooltip: 'Zoom In',
            onPressed: _zoomIn,
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            tooltip: 'Zoom Out',
            onPressed: _zoomOut,
          ),
          IconButton(
            icon: const Icon(Icons.fit_screen_rounded),
            tooltip: 'Reset Zoom',
            onPressed: _resetZoom,
          ),
        ],
      ),
      body: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 0.8,
        maxScale: 5.0,
        boundaryMargin: const EdgeInsets.all(30),
        clipBehavior: Clip.none,
        child: PdfPreview(
          build: widget.buildPdf,
          allowPrinting: true,
          allowSharing: true,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          maxPageWidth: 750,
          pdfFileName: widget.fileName ?? '${widget.title}.pdf',
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
      ),
    );
  }
}

