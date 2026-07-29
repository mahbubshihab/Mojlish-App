import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bijoy_helper/bijoy_helper.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/features/common/reports/data/models/baytulmal_report_entry.dart';

class MonthReportPdfData {
  final int year;
  final int month;
  final String monthName;
  final List<String> headers;
  final List<List<String>> tableData;
  final int filledDays;
  final int totalDays;
  final String? comments;

  MonthReportPdfData({
    required this.year,
    required this.month,
    required this.monthName,
    required this.headers,
    required this.tableData,
    required this.filledDays,
    required this.totalDays,
    this.comments,
  });
}

class _TextToken {
  final bool isBengali;
  final String text;
  _TextToken(this.isBengali, this.text);
}

List<_TextToken> _splitBengaliEnglishTokens(String text) {
  if (text.isEmpty) return [];

  final List<_TextToken> tokens = [];
  bool? currentIsBengali;
  final StringBuffer buffer = StringBuffer();

  for (int i = 0; i < text.length; i++) {
    final code = text.codeUnitAt(i);
    final isBnChar = code >= 0x0980 && code <= 0x09FF;
    final isEnChar = (code >= 0x61 && code <= 0x7A) || (code >= 0x41 && code <= 0x5A);

    bool isBn;
    if (isBnChar) {
      isBn = true;
    } else if (isEnChar) {
      isBn = false;
    } else {
      isBn = currentIsBengali ?? true;
    }

    if (currentIsBengali != null && isBn != currentIsBengali) {
      tokens.add(_TextToken(currentIsBengali, buffer.toString()));
      buffer.clear();
    }

    currentIsBengali = isBn;
    buffer.writeCharCode(code);
  }

  if (buffer.isNotEmpty && currentIsBengali != null) {
    tokens.add(_TextToken(currentIsBengali, buffer.toString()));
  }

  return tokens;
}

/// Helper function to convert Unicode Bengali string to Bijoy ANSI for SutonnyMJ TTF PDF rendering
String b(String text) {
  if (text.isEmpty || text == '-') return text;
  final cleanText = text.replaceAll('_', '.').replaceAll('✓', '√');

  final bool hasEnglish = cleanText.codeUnits.any((c) => (c >= 0x61 && c <= 0x7A) || (c >= 0x41 && c <= 0x5A));
  final bool hasBengali = cleanText.codeUnits.any((c) => c >= 0x0980 && c <= 0x09FF);

  // If pure English text, do NOT convert via toBijoy (prevents turning English to Bengali glyphs)
  if (hasEnglish && !hasBengali) {
    return cleanText;
  }

  try {
    return cleanText.toBijoy;
  } catch (_) {
    return cleanText;
  }
}

/// Smart PDF Widget builder that renders Bengali with SutonnyMJ (Bijoy) and English with Helvetica
pw.Widget smartText(
  String rawText, {
  required pw.Font sutonnyFont,
  pw.Font? helveticaFont,
  double fontSize = 8.5,
  PdfColor color = PdfColors.black,
  pw.FontWeight fontWeight = pw.FontWeight.normal,
  pw.TextAlign textAlign = pw.TextAlign.left,
}) {
  final hFont = helveticaFont ?? pw.Font.helvetica();
  if (rawText.isEmpty) {
    return pw.Text('', style: pw.TextStyle(fontSize: fontSize));
  }

  final cleanText = rawText.replaceAll('_', '.').replaceAll('✓', '√');
  final bool hasEnglish = cleanText.codeUnits.any((c) => (c >= 0x61 && c <= 0x7A) || (c >= 0x41 && c <= 0x5A));
  final bool hasBengali = cleanText.codeUnits.any((c) => c >= 0x0980 && c <= 0x09FF);

  if (hasEnglish && !hasBengali) {
    return pw.Text(
      cleanText,
      textAlign: textAlign,
      style: pw.TextStyle(
        font: hFont,
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }

  if (hasBengali && !hasEnglish) {
    String bijoyText;
    try {
      bijoyText = cleanText.toBijoy;
    } catch (_) {
      bijoyText = cleanText;
    }
    return pw.Text(
      bijoyText,
      textAlign: textAlign,
      style: pw.TextStyle(
        font: sutonnyFont,
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }

  final tokens = _splitBengaliEnglishTokens(cleanText);
  return pw.RichText(
    textAlign: textAlign,
    text: pw.TextSpan(
      children: tokens.map((token) {
        if (token.isBengali) {
          String bijoyToken;
          try {
            bijoyToken = token.text.toBijoy;
          } catch (_) {
            bijoyToken = token.text;
          }
          return pw.TextSpan(
            text: bijoyToken,
            style: pw.TextStyle(
              font: sutonnyFont,
              fontSize: fontSize,
              color: color,
              fontWeight: fontWeight,
            ),
          );
        } else {
          return pw.TextSpan(
            text: token.text,
            style: pw.TextStyle(
              font: hFont,
              fontSize: fontSize,
              color: color,
              fontWeight: fontWeight,
            ),
          );
        }
      }).toList(),
    ),
  );
}

/// Central PDF Export and Download Service for Mojlish App Reports and Forms (Bijoy ANSI Engine)
class PdfExportService {
  static const String chatroCentralAddress =
      'কেন্দ্রীয় কার্যালয়: ১৬ বিজয়নগর, (৫ম তলা), ঢাকা-১০০০ | ফোন: ৯৫৮৫৩২১';

  /// Resolves standard minimal theme color matching the logo
  static PdfColor getAccentColor(String? majlisName, String? logoPath) {
    if (majlisName != null && (majlisName.contains('যুব') || majlisName.contains('ছাত্র'))) {
      return PdfColors.blue900; // Minimal Deep Blue matching Youth/Student Majlis logo
    }
    return PdfColors.teal900; // Minimal Deep Emerald matching Khelafat/Women Majlis logo
  }

  /// Loads the embedded SutonnyMJ ANSI TTF Font (Gold Standard Bijoy Font for PDFs)
  static Future<pw.Font> loadSutonnyFont() async {
    try {
      final fontData = await rootBundle.load('assets/fonts/SutonnyMJ.ttf');
      return pw.Font.ttf(fontData);
    } catch (_) {
      final fallbackData = await rootBundle.load('assets/fonts/kalpurush.ttf');
      return pw.Font.ttf(fallbackData);
    }
  }

  /// Generates a standardized PDF document bytes for any report or form data
  static Future<Uint8List> generateSingleFormPdfBytes({
    required String title,
    required String majlisName,
    required String userName,
    required String period,
    required Map<String, dynamic> dataFields,
    List<List<String>>? tableData,
    List<String>? tableHeaders,
    String? comments,
    String? logoAssetPath,
    String? address,
  }) async {
    return generateReportPdf(
      title: title,
      majlisName: majlisName,
      userName: userName,
      period: period,
      dataFields: dataFields,
      tableData: tableData,
      tableHeaders: tableHeaders,
      comments: comments,
      logoAssetPath: logoAssetPath,
      address: address,
    );
  }

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
    String? logoAssetPath,
    String? address,
  }) async {
    final font = await loadSutonnyFont();
    final accentColor = getAccentColor(majlisName, logoAssetPath);

    final effectiveLogoPath = (logoAssetPath != null && logoAssetPath.isNotEmpty)
        ? logoAssetPath
        : majlisName.contains('খেলাফত')
            ? MajlisAssets.khelafatLogo
            : majlisName.contains('যুব')
                ? MajlisAssets.juboLogo
                : majlisName.contains('ছাত্র')
                    ? MajlisAssets.chatroLogo
                    : null;

    final effectiveAddress = (address != null && address.isNotEmpty && address != 'কেন্দ্রীয় কার্যালয়: ঢাকা')
        ? address
        : majlisName.contains('ছাত্র')
            ? chatroCentralAddress
            : address;

    pw.MemoryImage? logoImage;
    if (effectiveLogoPath != null && effectiveLogoPath.isNotEmpty) {
      try {
        final bytes = await rootBundle.load(effectiveLogoPath);
        logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
      } catch (_) {}
    }

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: font,
        bold: font,
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        build: (pw.Context context) {
          return [
            // Header matching logo color with minimal clean style
            pw.Container(
              alignment: pw.Alignment.center,
              padding: const pw.EdgeInsets.only(bottom: 10),
              decoration: pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: accentColor, width: 1.5)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  if (logoImage != null) ...[
                    pw.Image(logoImage, width: 44, height: 44),
                    pw.SizedBox(width: 12),
                  ],
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        b(majlisName),
                        style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: accentColor),
                      ),
                      if (effectiveAddress != null && effectiveAddress.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(b(effectiveAddress), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800)),
                      ],
                      pw.SizedBox(height: 4),
                      pw.Text(
                        b(title),
                        style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),

            // Metadata Bar with Minimal Soft Tint
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(color: PdfColors.grey300, width: 0.6),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(b('ব্যবহারকারীর নাম: $userName'), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                      pw.SizedBox(height: 2),
                      pw.Text(b('মজলিস: $majlisName'), style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.grey800)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(b('সময়কাল: $period'), style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.grey800)),
                      pw.SizedBox(height: 2),
                      pw.Text(b('তারিখ: ${DateTime.now().toString().split(' ')[0]}'), style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.grey800)),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 14),

            // Data Fields Section
            if (dataFields.isNotEmpty) ...[
              pw.Text(b('রিপোর্ট বিবরণী'), style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: accentColor)),
              pw.SizedBox(height: 6),
              pw.Wrap(
                spacing: 10,
                runSpacing: 6,
                children: dataFields.entries.map((entry) {
                  return pw.Container(
                    width: 230,
                    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(b(entry.key), style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.grey800)),
                        pw.Text(b('${entry.value}'), style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              pw.SizedBox(height: 14),
            ],

            // Table Section with Minimal Logo-matched Header Fill
            if (tableData != null && tableData.isNotEmpty && tableHeaders != null) ...[
              pw.Text(b('দৈনন্দিন বিবরণী টেবিল'), style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: accentColor)),
              pw.SizedBox(height: 6),
              pw.TableHelper.fromTextArray(
                headers: tableHeaders.map((h) => b(h)).toList(),
                data: tableData.map((row) => row.map((cell) => smartText(cell, sutonnyFont: font, fontSize: 7.5)).toList()).toList(),
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                headerStyle: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: pw.BoxDecoration(color: accentColor),
                cellStyle: const pw.TextStyle(fontSize: 7.5, color: PdfColors.black),
                cellAlignment: pw.Alignment.center,
                cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
              ),
              pw.SizedBox(height: 14),
            ],

            // Comments Section
            if (comments != null && comments.isNotEmpty) ...[
              pw.Text(b('মন্তব্য ও পরামর্শ'), style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: accentColor)),
              pw.SizedBox(height: 4),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(b(comments), style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.grey800)),
              ),
            ],
          ];
        },
      ),
    );

    return pdf.save();
  }

  /// Multi-Month Personal Report PDF Generator — SutonnyMJ Bijoy Font & Minimal Logo-Matched Color Theme
  static Future<Uint8List> generateMultiMonthPersonalReportPdf({
    required String majlisName,
    required String title,
    required String userName,
    required List<MonthReportPdfData> monthsData,
    String? logoAssetPath,
    String? address,
  }) async {
    final font = await loadSutonnyFont();
    final accentColor = getAccentColor(majlisName, logoAssetPath);

    final effectiveLogoPath = (logoAssetPath != null && logoAssetPath.isNotEmpty)
        ? logoAssetPath
        : majlisName.contains('খেলাফত')
            ? MajlisAssets.khelafatLogo
            : majlisName.contains('যুব')
                ? MajlisAssets.juboLogo
                : majlisName.contains('ছাত্র')
                    ? MajlisAssets.chatroLogo
                    : null;

    final effectiveAddress = (address != null && address.isNotEmpty && address != 'কেন্দ্রীয় কার্যালয়: ঢাকা')
        ? address
        : majlisName.contains('ছাত্র')
            ? chatroCentralAddress
            : address;

    pw.MemoryImage? logoImage;
    if (effectiveLogoPath != null && effectiveLogoPath.isNotEmpty) {
      try {
        final bytes = await rootBundle.load(effectiveLogoPath);
        logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
      } catch (_) {}
    }

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: font,
        bold: font,
      ),
    );

    // Each month uses pw.MultiPage with SutonnyMJ Bijoy TTF font
    for (final monthData in monthsData) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          build: (pw.Context context) {
            return [
              // Header with Minimal Color matching Logo Accent
              pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 5),
                decoration: pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(color: accentColor, width: 1.5)),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    if (logoImage != null) ...[
                      pw.Image(logoImage, width: 40, height: 40),
                      pw.SizedBox(width: 10),
                    ],
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text(
                            b(majlisName),
                            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: accentColor),
                          ),
                          if (effectiveAddress != null && effectiveAddress.isNotEmpty) ...[
                            pw.SizedBox(height: 2),
                            pw.Text(
                              b(effectiveAddress),
                              textAlign: pw.TextAlign.center,
                              style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey800),
                            ),
                          ],
                          pw.SizedBox(height: 2),
                          pw.Text(
                            b(title),
                            style: pw.TextStyle(fontSize: 11.5, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 5),

              // Top Info Bar matching exact org form image
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    if (majlisName.contains('খেলাফত') || majlisName.contains('মহিলা')) ...[
                      pw.Text(b('কর্মীর নাম : ............................................'), style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.black)),
                      pw.Text(b('শাখা : ............................................'), style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.black)),
                      pw.Text(b('মাস : ${monthData.monthName}   সন : ${monthData.year}'), style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                    ] else ...[
                      pw.Text(b('নাম : ............................................'), style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.black)),
                      pw.Text(b('প্রা.সদস্য/কর্মী/শুরা সদস্য (✓)  শাখা: ........................'), style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.black)),
                      pw.Text(b('মাস: ${monthData.monthName}   সন: ${monthData.year}'), style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                    ],
                  ],
                ),
              ),
              pw.SizedBox(height: 3),

              // Table fitting 31 rows cleanly on 1 A4 Page
              pw.TableHelper.fromTextArray(
                headers: monthData.headers.map((h) => b(h)).toList(),
                data: monthData.tableData.map((row) => row.map((cell) => smartText(cell, sutonnyFont: font, fontSize: 6.8, textAlign: pw.TextAlign.center)).toList()).toList(),
                border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
                headerStyle: pw.TextStyle(fontSize: 7.2, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
                cellStyle: const pw.TextStyle(fontSize: 6.8, color: PdfColors.black),
                cellAlignment: pw.Alignment.center,
                cellPadding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1.0),
              ),
              pw.SizedBox(height: 6),

              // Bottom Footer Section matching exact org form image
              if (majlisName.contains('ছাত্র'))
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(b('পরামর্শ : ............................................................................................................................................'), style: const pw.TextStyle(fontSize: 8, color: PdfColors.black)),
                        pw.Text(b('স্বাক্ষর : ................................................'), style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.black)),
                      ],
                    ),
                  ],
                )
              else if (majlisName.contains('খেলাফত') || majlisName.contains('মহিলা'))
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(b('এ মাসে সভায় যোগদান .................... টি, সভার নাম : ................................................................................................................................'), style: const pw.TextStyle(fontSize: 8, color: PdfColors.black)),
                    pw.SizedBox(height: 4),
                    pw.Text(b('শাখা দায়িত্বশীলের মন্তব্য ও পরামর্শ : ...................................................................................................................................................................'), style: const pw.TextStyle(fontSize: 8, color: PdfColors.black)),
                    pw.SizedBox(height: 4),
                    pw.Text(b('...................................................................................................................................................................................................................'), style: const pw.TextStyle(fontSize: 8, color: PdfColors.black)),
                    pw.SizedBox(height: 6),
                    pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(b('দায়িত্বশীলের স্বাক্ষর : ................................................................'), style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.black)),
                    ),
                  ],
                )
              else
                // Youth Majlis Outer Box
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    border: pw.Border.all(color: PdfColors.black, width: 0.8),
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(b('সভায় যোগদান মোট ........... টি সভার নাম : ........................................................................................................'), style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.black)),
                      pw.SizedBox(height: 6),
                      pw.Text(b('উর্ধ্বতন দায়িত্বশীলের মন্তব্য ও পরামর্শ : ......................................................................................................................'), style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.black)),
                      pw.SizedBox(height: 6),
                      pw.Text(b('...............................................................................................................................................................'), style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.black)),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(b('শাখা দায়িত্বশীলের নাম : ..........................................'), style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.black)),
                          pw.Text(b('স্বাক্ষর ও তারিখ : ..........................................'), style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.black)),
                        ],
                      ),
                    ],
                  ),
                ),
            ];
          },
        ),
      );
    }

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
    String? logoAssetPath,
    String? address,
  }) async {
    final effectiveLogo = (logoAssetPath != null && logoAssetPath.isNotEmpty)
        ? logoAssetPath
        : majlisName.contains('ছাত্র')
            ? MajlisAssets.chatroLogo
            : logoAssetPath;

    final effectiveAddress = (address != null && address.isNotEmpty && address != 'কেন্দ্রীয় কার্যালয়: ঢাকা')
        ? address
        : majlisName.contains('ছাত্র')
            ? chatroCentralAddress
            : address;

    final pdfBytes = await generateReportPdf(
      title: title,
      majlisName: majlisName,
      userName: userName,
      period: period,
      dataFields: dataFields,
      tableData: tableData,
      tableHeaders: tableHeaders,
      comments: comments,
      logoAssetPath: effectiveLogo,
      address: effectiveAddress,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: '${majlisName}_${title.replaceAll(' ', '_')}.pdf',
    );
  }

  /// Print or Download Multi-Month Personal Report PDF (1 A4 page per month with Custom/Central Address)
  static Future<void> printOrDownloadMultiMonthPdf({
    required String majlisName,
    required String title,
    required String userName,
    required List<MonthReportPdfData> monthsData,
    String? logoAssetPath,
    String? address,
  }) async {
    final effectiveLogo = (logoAssetPath != null && logoAssetPath.isNotEmpty)
        ? logoAssetPath
        : majlisName.contains('ছাত্র')
            ? MajlisAssets.chatroLogo
            : logoAssetPath;

    final effectiveAddress = (address != null && address.isNotEmpty && address != 'কেন্দ্রীয় কার্যালয়: ঢাকা')
        ? address
        : majlisName.contains('ছাত্র')
            ? chatroCentralAddress
            : address;

    final pdfBytes = await generateMultiMonthPersonalReportPdf(
      majlisName: majlisName,
      title: title,
      userName: userName,
      monthsData: monthsData,
      logoAssetPath: effectiveLogo,
      address: effectiveAddress,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: '${majlisName}_${title.replaceAll(' ', '_')}_multi_month.pdf',
    );
  }

  /// Generates verbatim 100% exact 2-part A4 PDF for Student Majlis Primary Member Form matching official image
  static Future<Uint8List> generateChatroMemberFormPdf({
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
  }) async {
    final font = await loadSutonnyFont();
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

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // PART 1: Top Pledge Section
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.cyan800, width: 1),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(b('বিসমিল্লাহির রাহমানির রাহিম'), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        if (logoImage != null) ...[
                          pw.Image(logoImage, width: 28, height: 28),
                          pw.SizedBox(width: 8),
                        ],
                        pw.Text(b('বাংলাদেশ ইসলামী ছাত্র মজলিস'), style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold, color: PdfColors.cyan900)),
                      ],
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(b(chatroCentralAddress), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800)),
                    pw.SizedBox(height: 1),
                    pw.Text('www.chhatra-majlis.org.bd', style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.cyan800)),
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
                      b('ইসলাম আল্লাহর মনোনীত দ্বীন বা জীবনব্যবস্থা এবং এর পূর্ণাঙ্গ অনুসরণের মধ্যেই মানব জীবনে ইহকালীন কল্যাণ ও পরকালীন মুক্তি নিহিত। এ উদ্দেশ্যে বাংলাদেশ ইসলামী ছাত্র মজলিস যে কর্মসূচি গ্রহণ করেছে, আমি তার সাথে একমত হয়ে আল্লাহর সন্তুষ্টি অর্জনের জন্যে এ সংগঠনে যোগদান করছি।'),
                      textAlign: pw.TextAlign.justify,
                      style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.3),
                    ),
                    pw.SizedBox(height: 16),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(b('তারিখ : .....................'), style: const pw.TextStyle(fontSize: 9.5)),
                        pw.Text(b('স্বাক্ষর : .....................'), style: const pw.TextStyle(fontSize: 9.5)),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 14),

              // PART 2: Bottom Personal Info Section
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.cyan800, width: 1),
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
                        pw.Text(b('বাংলাদেশ ইসলামী ছাত্র মজলিস'), style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold, color: PdfColors.cyan900)),
                      ],
                    ),
                    pw.SizedBox(height: 2),
                    pw.Center(
                      child: pw.Text(b(chatroCentralAddress), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800)),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(b('নাম : ${name.isNotEmpty ? name : "...................................................................................................................."}'), style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 6),
                    pw.Text(b('পিতার নাম : ${fatherName.isNotEmpty ? fatherName : "...................................................................................................................."}'), style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 6),
                    pw.Row(
                      children: [
                        pw.Expanded(child: pw.Text(b('শিক্ষা প্রতিষ্ঠান : ${eduInstitution.isNotEmpty ? eduInstitution : ".................................................."}'), style: const pw.TextStyle(fontSize: 10))),
                        pw.Text(b('রক্তের গ্রুপ : ${bloodGroup.isNotEmpty ? bloodGroup : "...................."}'), style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                    pw.SizedBox(height: 6),
                    pw.Row(
                      children: [
                        pw.Expanded(child: pw.Text(b('শ্রেণি : ${studentClass.isNotEmpty ? studentClass : "...................."}'), style: const pw.TextStyle(fontSize: 10))),
                        pw.Expanded(child: pw.Text(b('বিভাগ : ${department.isNotEmpty ? department : "...................."}'), style: const pw.TextStyle(fontSize: 10))),
                        pw.Text(b('ক্রমিক নং : ${rollNo.isNotEmpty ? rollNo : "...................."}'), style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(b('বর্তমান ঠিকানা : ${presentAddress.isNotEmpty ? presentAddress : "...................................................................................................................."}'), style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 6),
                    pw.Text(b('মোবাইল : ${mobile.isNotEmpty ? mobile : "...................................................................................................................."}'), style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 6),
                    pw.Row(
                      children: [
                        pw.Expanded(child: pw.Text(b('স্থায়ী ঠিকানা : গ্রাম : ${village.isNotEmpty ? village : "........................................"}'), style: const pw.TextStyle(fontSize: 10))),
                        pw.Text(b('ডাকঘর : ${postOffice.isNotEmpty ? postOffice : "........................................"}'), style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                    pw.SizedBox(height: 6),
                    pw.Row(
                      children: [
                        pw.Expanded(child: pw.Text(b('থানা/উপজেলা : ${thana.isNotEmpty ? thana : "........................................"}'), style: const pw.TextStyle(fontSize: 10))),
                        pw.Text(b('জেলা : ${district.isNotEmpty ? district : "........................................"}'), style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                    pw.SizedBox(height: 16),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(b('তারিখ : .....................'), style: const pw.TextStyle(fontSize: 9.5)),
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

  /// Print or Download Student Majlis Primary Member Form PDF
  static Future<void> printOrDownloadChatroMemberFormPdf({
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
  }) async {
    final pdfBytes = await generateChatroMemberFormPdf(
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
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'বাংলাদেশ_ইসলামী_ছাত্র_মজলিস_প্রাথমিক_সদস্য_ফরম.pdf',
    );
  }

  /// Generates verbatim 100% exact 2-part A4 PDF for Youth Majlis Primary Member Form matching official images
  static Future<Uint8List> generateYouthMemberFormPdf({
    required String name,
    required String fatherName,
    required String nidNumber,
    required String village,
    required String unionName,
    required String thanaUpazila,
    required String district,
    required String presentAddress,
    required String mobile,
    required String email,
    required String joinDate,
  }) async {
    final font = await loadSutonnyFont();
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: font,
        bold: font,
      ),
    );

    pw.MemoryImage? logoImage;
    try {
      final bytes = await rootBundle.load(MajlisAssets.juboLogo);
      logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {}

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // PART 1: Top Personal Info Section (Matching media__1785275697596.png)
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.green800, width: 1.2),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (logoImage != null) pw.Image(logoImage, width: 44, height: 44),
                        pw.SizedBox(width: 10),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Text(b('বিসমিল্লাহির রাহমানির রাহিম'), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                              pw.SizedBox(height: 2),
                              pw.Text(b('ইসলামী যুব মজলিস'), style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                              pw.Text(b('১৬, বিজয়নগর, (৫ম তলা), পুরানা পল্টন, ঢাকা-১০<ctrl42>'), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800)),
                              pw.Text('http://islamijubomajlis.org', style: const pw.TextStyle(fontSize: 8, color: PdfColors.blue800)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 6),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('24292', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.green800,
                            borderRadius: pw.BorderRadius.circular(12),
                          ),
                          child: pw.Text(b('প্রাথমিক সদস্য ফরম'), style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(b('নাম : ${name.isNotEmpty ? name : "...................................................................................................................."}'), style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 6),
                    pw.Text(b('পিতা : ${fatherName.isNotEmpty ? fatherName : "...................................................................................................................."}'), style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 6),
                    pw.Text(b('জাতীয় পরিচয়পত্র নং : ${nidNumber.isNotEmpty ? nidNumber : "...................................................................................................................."}'), style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 6),
                    pw.Text(b('ঠিকানা : গ্রাম : ${village.isNotEmpty ? village : "...................................................................................................................."}'), style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 6),
                    pw.Row(
                      children: [
                        pw.Expanded(child: pw.Text(b('ইউনিয়ন : ${unionName.isNotEmpty ? unionName : "........................................"}'), style: const pw.TextStyle(fontSize: 10))),
                        pw.Expanded(child: pw.Text(b('থানা ও উপজেলা : ${thanaUpazila.isNotEmpty ? thanaUpazila : "........................................"}'), style: const pw.TextStyle(fontSize: 10))),
                      ],
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(b('জেলা : ${district.isNotEmpty ? district : "...................................................................................................................."}'), style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 6),
                    pw.Text(b('বর্তমান ঠিকানা : ${presentAddress.isNotEmpty ? presentAddress : "...................................................................................................................."}'), style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 6),
                    pw.Text(b('মোবাইল : ${mobile.isNotEmpty ? mobile : "...................................................................................................................."}'), style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 6),
                    pw.Text(b('ইমেইল : ${email.isNotEmpty ? email : "...................................................................................................................."}'), style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 12),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(b('যোগদানের তারিখ : ${joinDate.isNotEmpty ? joinDate : "....................."}'), style: const pw.TextStyle(fontSize: 9.5)),
                        pw.Text(b('স্বাক্ষর : .....................'), style: const pw.TextStyle(fontSize: 9.5)),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),

              // PART 2: Bottom Pledge Section (Matching media__1785275794053.png)
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.green800, width: 1.2),
                ),
                child: pw.Column(
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (logoImage != null) pw.Image(logoImage, width: 44, height: 44),
                        pw.SizedBox(width: 10),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Text(b('বিসমিল্লাহির রাহমানির রাহিম'), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                              pw.SizedBox(height: 2),
                              pw.Text(b('ইসলামী যুব মজলিস'), style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                              pw.Text(b('১৬, বিজয়নগর, (৫ম তলা), পুরানা পল্টন, ঢাকা-১০<ctrl42> | http://islamijubomajlis.org'), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 6),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('24292', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.green800,
                            borderRadius: pw.BorderRadius.circular(12),
                          ),
                          child: pw.Text(b('প্রাথমিক সদস্য ফরম'), style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 12),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        b('আমি ${name.isNotEmpty ? name : "...................................................................................................."} দৃঢ়ভাবে বিশ্বাস করি যে,'),
                        style: const pw.TextStyle(fontSize: 10.5),
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      b('ইসলামই আল্লাহর একমাত্র মনোনীত জীবনব্যবস্থা। ইসলামী আদর্শের আলোকে যুবসমাজের নেতৃত্বে একটি কল্যাণমুখী সমাজ গড়ার লক্ষ্যে ইসলামী যুব মজলিসের সাথে একমত হয়ে এ সংগঠনে যোগদান করছি।'),
                      textAlign: pw.TextAlign.justify,
                      style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.3),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        b('আমি এ লক্ষ্য অর্জনে যথাসাধ্য চেষ্টা করবো ইনশাআল্লাহ।'),
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                    pw.SizedBox(height: 18),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(b('তারিখ : ${joinDate.isNotEmpty ? joinDate : "....................."}'), style: const pw.TextStyle(fontSize: 9.5)),
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

  /// Print or Download Youth Majlis Primary Member Form PDF
  static Future<void> printOrDownloadYouthMemberFormPdf({
    required String name,
    required String fatherName,
    required String nidNumber,
    required String village,
    required String unionName,
    required String thanaUpazila,
    required String district,
    required String presentAddress,
    required String mobile,
    required String email,
    required String joinDate,
  }) async {
    final pdfBytes = await generateYouthMemberFormPdf(
      name: name,
      fatherName: fatherName,
      nidNumber: nidNumber,
      village: village,
      unionName: unionName,
      thanaUpazila: thanaUpazila,
      district: district,
      presentAddress: presentAddress,
      mobile: mobile,
      email: email,
      joinDate: joinDate,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'বাংলাদেশ_ইসলামী_যুব_মজলিস_প্রাথমিক_সদস্য_ফরম.pdf',
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

  /// Generates exact official Khelafat Majlis Branch Baytulmal Report Form PDF
  static Future<Uint8List> generateKhelafatBaytulmalPdfBytes({
    required BaytulmalReportEntry entry,
    String? incomeInWords,
    String? expenseInWords,
  }) async {
    final font = await loadSutonnyFont();

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

    double directIncomeSum = (double.tryParse(entry.executiveMemberAyanatTaka) ?? 0) +
        (double.tryParse(entry.subBranchAyanatTaka) ?? 0) +
        (double.tryParse(entry.suhridAyanatTaka) ?? 0) +
        (double.tryParse(entry.safarIncomeTaka) ?? 0) +
        (double.tryParse(entry.prokashnaIncomeTaka) ?? 0) +
        (double.tryParse(entry.onetimeIncomeTaka) ?? 0);

    double prevBal = double.tryParse(entry.previousBalance) ?? 0;
    double grandTotalIncome = directIncomeSum + prevBal;

    double totalExpense = (double.tryParse(entry.upwardAyanatTaka) ?? 0) +
        (double.tryParse(entry.officeRentTaka) ?? 0) +
        (double.tryParse(entry.officeCostTaka) ?? 0) +
        (double.tryParse(entry.safarExpenseTaka) ?? 0) +
        (double.tryParse(entry.transportTaka) ?? 0) +
        (double.tryParse(entry.communicationTaka) ?? 0) +
        (double.tryParse(entry.procharTaka) ?? 0) +
        (double.tryParse(entry.prokashnaExpenseTaka) ?? 0) +
        (double.tryParse(entry.dibosPatanTaka) ?? 0) +
        (double.tryParse(entry.appayanTaka) ?? 0) +
        (double.tryParse(entry.sovaTaka) ?? 0);

    double netBalance = grandTotalIncome - totalExpense;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Top Header
              b('বিসমিল্লাহির রাহমানির রাহীম', fontSize: 9.5),
              pw.SizedBox(height: 2),
              b('শাখার বায়তুলমাল রিপোর্ট ফরম', fontSize: 13, fontWeight: pw.FontWeight.bold),
              pw.SizedBox(height: 4),

              // Logo + Organization Name
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (logoImage != null) ...[
                    pw.Image(logoImage, width: 34, height: 34),
                    pw.SizedBox(width: 8),
                  ],
                  b('খেলাফত মজলিস', fontSize: 22, fontWeight: pw.FontWeight.bold),
                ],
              ),
              pw.SizedBox(height: 2),
              b('কেন্দ্রীয় কার্যালয়: ১৬ পুরানা পল্টন, (২য় তলা), ঢাকা-১০০০। ফোন: ৯৫৫৮৫২১', fontSize: 8.5),
              pw.SizedBox(height: 10),

              // Info Row Box: শাখা, মাস, সন
              pw.Container(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey200,
                ),
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    b('শাখা: ${entry.branchName.isEmpty ? "........................" : entry.branchName}', fontSize: 10.5, fontWeight: pw.FontWeight.bold),
                    b('মাস: ${entry.month.isEmpty ? "........................" : entry.month}', fontSize: 10.5, fontWeight: pw.FontWeight.bold),
                    b('সন: ${entry.year.isEmpty ? "........................" : entry.year}', fontSize: 10.5, fontWeight: pw.FontWeight.bold),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),

              // ================= SECTION 1: আয় =================
              pw.Container(
                width: double.infinity,
                color: PdfColors.grey300,
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                alignment: pw.Alignment.center,
                child: b('আয়', fontSize: 11, fontWeight: pw.FontWeight.bold),
              ),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(6),
                  1: pw.FlexColumnWidth(2),
                  2: pw.FlexColumnWidth(1.2),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: b('আয়ের উৎস', fontSize: 9.5, fontWeight: pw.FontWeight.bold)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: b('টাকা', fontSize: 9.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: b('পয়সা', fontSize: 9.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                    ],
                  ),
                  _buildKhelafatBaytulmalTableRow('নির্বাহী সদস্যদের ইয়ানত (নির্বাহী সদস্য সংখ্যা: ${entry.executiveMemberAyanat.isEmpty ? "____" : entry.executiveMemberAyanat} জন)', entry.executiveMemberAyanatTaka),
                  _buildKhelafatBaytulmalTableRow('অধস্তন শাখা ইয়ানত (শাখা সংখ্যা: ${entry.subBranchAyanat.isEmpty ? "____" : entry.subBranchAyanat} টি)', entry.subBranchAyanatTaka),
                  _buildKhelafatBaytulmalTableRow('সুধী/শুভাকাঙ্ক্ষী ইয়ানত (শুভাকাঙ্ক্ষী সংখ্যা: ${entry.suhridAyanat.isEmpty ? "____" : entry.suhridAyanat} জন)', entry.suhridAyanatTaka),
                  _buildKhelafatBaytulmalTableRow('সফর', entry.safarIncomeTaka),
                  _buildKhelafatBaytulmalTableRow('প্রকাশনা', entry.prokashnaIncomeTaka),
                  _buildKhelafatBaytulmalTableRow('এককালীন (বিস্তারিত আলাদা কাগজে)', entry.onetimeIncomeTaka),
                  _buildKhelafatBaytulmalTableRow('মোট আয়', directIncomeSum > 0 ? directIncomeSum.toStringAsFixed(0) : '', isBold: true),
                  _buildKhelafatBaytulmalTableRow('বিগত মাস / সেশনের উদ্বৃত্ত', entry.previousBalance),
                  _buildKhelafatBaytulmalTableRow('সর্বমোট আয়', grandTotalIncome > 0 ? grandTotalIncome.toStringAsFixed(0) : '', isBold: true),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: b('কথায়: ${incomeInWords ?? "........................................................................................................"}', fontSize: 9),
              ),
              pw.SizedBox(height: 10),

              // ================= SECTION 2: ব্যয় =================
              pw.Container(
                width: double.infinity,
                color: PdfColors.grey300,
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                alignment: pw.Alignment.center,
                child: b('ব্যয়', fontSize: 11, fontWeight: pw.FontWeight.bold),
              ),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(6),
                  1: pw.FlexColumnWidth(2),
                  2: pw.FlexColumnWidth(1.2),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: b('ব্যয়ের খাত', fontSize: 9.5, fontWeight: pw.FontWeight.bold)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: b('টাকা', fontSize: 9.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: b('পয়সা', fontSize: 9.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                    ],
                  ),
                  _buildKhelafatBaytulmalTableRow('উর্ধ্বতন ইয়ানত পরিশোধ (মাসিক ধার্যকৃত: ${entry.upwardAyanat.isEmpty ? "____" : entry.upwardAyanat} টাকা)', entry.upwardAyanatTaka),
                  _buildKhelafatBaytulmalTableRow('অফিস ভাড়া ও বিল', entry.officeRentTaka),
                  _buildKhelafatBaytulmalTableRow('অফিস খরচ', entry.officeCostTaka),
                  _buildKhelafatBaytulmalTableRow('সফর', entry.safarExpenseTaka),
                  _buildKhelafatBaytulmalTableRow('যাতায়াত', entry.transportTaka),
                  _buildKhelafatBaytulmalTableRow('যোগাযোগ', entry.communicationTaka),
                  _buildKhelafatBaytulmalTableRow('প্রচার', entry.procharTaka),
                  _buildKhelafatBaytulmalTableRow('প্রকাশনা', entry.prokashnaExpenseTaka),
                  _buildKhelafatBaytulmalTableRow('দিবস পালন (নাম: ${entry.dibosPalan.isEmpty ? "________________________" : entry.dibosPalan})', entry.dibosPatanTaka),
                  _buildKhelafatBaytulmalTableRow('আপ্যায়ন', entry.appayanTaka),
                  _buildKhelafatBaytulmalTableRow('সভা/সমাবেশ বাস্তবায়ন (বিস্তারিত আলাদা কাগজে)', entry.sovaTaka),
                  _buildKhelafatBaytulmalTableRow('মোট ব্যয়', totalExpense > 0 ? totalExpense.toStringAsFixed(0) : '', isBold: true),
                  _buildKhelafatBaytulmalTableRow('সর্বমোট আয়', grandTotalIncome > 0 ? grandTotalIncome.toStringAsFixed(0) : '', isBold: true),
                  _buildKhelafatBaytulmalTableRow('উদ্বৃত্ত / ঘাটতি', netBalance != 0 ? netBalance.toStringAsFixed(0) : '', isBold: true),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: b('কথায়: ${expenseInWords ?? "........................................................................................................"}', fontSize: 9),
              ),

              pw.Spacer(),

              // ================= FOOTER SIGNATURES =================
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  b('তারিখ: ...........................................', fontSize: 9.5),
                  b('বায়তুলমাল সম্পাদকের স্বাক্ষর', fontSize: 9.5, fontWeight: pw.FontWeight.bold),
                  b('সভাপতির স্বাক্ষর', fontSize: 9.5, fontWeight: pw.FontWeight.bold),
                ],
              ),
              pw.SizedBox(height: 6),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.TableRow _buildKhelafatBaytulmalTableRow(String label, String takaVal, {bool isBold = false}) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: b(label, fontSize: 9, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: b(takaVal, fontSize: 9, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: b(takaVal.isNotEmpty ? '০০' : '', fontSize: 9, textAlign: pw.TextAlign.center),
        ),
      ],
    );
  }
}
