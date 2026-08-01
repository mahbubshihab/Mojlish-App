import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

/// Full-screen PDF preview screen with print & share capabilities
class PdfPreviewScreen extends StatefulWidget {
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
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
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
        title: Text(widget.title),
        elevation: 0,
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
          build: (format) async => widget.pdfBytes,
          allowPrinting: true,
          allowSharing: true,
          canChangeOrientation: false,
          canChangePageFormat: false,
          pdfFileName: widget.fileName ?? '${widget.title}.pdf',
        ),
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

