import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/data/models/zonal_report_entry.dart';

/// খেলাফত মজলিস — জোনাল রিপোর্ট ২-পৃষ্ঠা অফিশিয়াল PDF সার্ভিস
class KhelafatZonalPdfService {
  static Future<Uint8List> generatePdfBytes({
    required ZonalReportEntry entry,
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

    double totalIncome = entry.totalIncome;
    double totalExpense = entry.totalExpense;
    double netBalance = entry.balance;

    // PAGE 1: জোনাল রিপোর্ট ফরম (পৃষ্ঠা ১)
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header
              PdfExportService.b('বিসমিল্লাহির রাহমানির রাহীম', fontSize: 9.5),
              pw.SizedBox(height: 2),
              PdfExportService.b('জোনাল রিপোর্ট ফরম', fontSize: 14, fontWeight: pw.FontWeight.bold),
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
                  PdfExportService.b('খেলাফত মজলিস', fontSize: 22, fontWeight: pw.FontWeight.bold),
                ],
              ),
              pw.SizedBox(height: 2),
              PdfExportService.b('কেন্দ্রীয় কার্যালয়: ১৬, বিজয়নগর (৫ম তলা), ঢাকা-১০০০, ফোন: ০২-৯৫৮৫৩২১', fontSize: 8.5),
              pw.SizedBox(height: 10),

              // Info Box: জোন, মাস, সন
              pw.Container(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    PdfExportService.b('জোন: ${entry.zoneName.isEmpty ? "........................" : entry.zoneName}', fontSize: 10.5, fontWeight: pw.FontWeight.bold),
                    PdfExportService.b('মাস: ${entry.month.isEmpty ? "........................" : entry.month}', fontSize: 10.5, fontWeight: pw.FontWeight.bold),
                    PdfExportService.b('সন: ${entry.year.isEmpty ? "........................" : entry.year}', fontSize: 10.5, fontWeight: pw.FontWeight.bold),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),

              // 1. জনশক্তি (Table)
              _buildSectionHeader('জনশক্তি'),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2.5),
                  1: pw.FlexColumnWidth(1.5),
                  2: pw.FlexColumnWidth(1.5),
                  3: pw.FlexColumnWidth(1.5),
                  4: pw.FlexColumnWidth(3),
                },
                children: [
                  _buildTableHeader(['বিবরণ', 'সংখ্যা', 'বৃদ্ধি', 'ঘাটতি', 'কারণ']),
                  _buildManpowerRow('সদস্য', entry.sodossoCount, entry.sodossoBridhi, entry.sodossoGhatti),
                  _buildManpowerRow('সদস্য প্রার্থী', entry.sodossoPrarthiCount, entry.sodossoPrarthiBridhi, entry.sodossoPrarthiGhatti),
                ],
              ),
              pw.SizedBox(height: 8),

              // 2. সংগঠন (Table)
              _buildSectionHeader('সংগঠন'),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2.5),
                  1: pw.FlexColumnWidth(1.5),
                  2: pw.FlexColumnWidth(2),
                  3: pw.FlexColumnWidth(2),
                  4: pw.FlexColumnWidth(2),
                },
                children: [
                  _buildTableHeader(['বিবরণ', 'সংখ্যা', 'সংগঠন', 'পুনর্গঠন(নামসহ)', 'কাজ(নামসহ)']),
                  _buildOrgRow('জেলা', entry.districtCount, entry.districtOrg, entry.districtReorg),
                  _buildOrgRow('মহানগরী', entry.cityCount, entry.cityOrg, entry.cityReorg),
                  _buildOrgRow('উপজেলা', entry.upazilaThanaCount, entry.upazilaThanaOrg, entry.upazilaThanaReorg),
                  _buildOrgRow('পৌরসভা', '', '', ''),
                  _buildOrgRow('থানা', '', '', ''),
                  _buildOrgRow('ইউনিয়ন', '', '', ''),
                ],
              ),
              pw.SizedBox(height: 8),

              // 3. সভা/প্রশিক্ষণ (Table)
              _buildSectionHeader('সভা/প্রশিক্ষণ'),
              pw.Row(
                children: [
                  Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(4),
                        1: pw.FlexColumnWidth(1.5),
                        2: pw.FlexColumnWidth(2),
                      },
                      children: [
                        _buildTableHeader(['বিবরণ', 'সংখ্যা', 'উপস্থিতি(গড়)']),
                        _buildMeetingRow('শাখা দায়িত্বশীল বৈঠক (জোনাল)', entry.shakhaDaitoshilCount, entry.shakhaDaitoshilPresence),
                        _buildMeetingRow('জেলা নির্বাহী বৈঠক', entry.districtExecCount, entry.districtExecPresence),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(4),
                        1: pw.FlexColumnWidth(1.5),
                        2: pw.FlexColumnWidth(2),
                      },
                      children: [
                        _buildTableHeader(['বিবরণ', 'সংখ্যা', 'উপস্থিতি(গড়)']),
                        _buildMeetingRow('তরবিয়তী মজলিস (জোনাল)', entry.zonalTorbiotCount, entry.zonalTorbiotPresence),
                        _buildMeetingRow('অন্যান্য', '', ''),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),

              // 4. সফর (জোন থেকে)
              _buildSectionHeader('সফর (জোন থেকে)'),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(1.2),
                  1: pw.FlexColumnWidth(3),
                  2: pw.FlexColumnWidth(3),
                  3: pw.FlexColumnWidth(1.2),
                  4: pw.FlexColumnWidth(3),
                  5: pw.FlexColumnWidth(3),
                },
                children: [
                  _buildTableHeader(['তারিখ', 'শাখার নাম', 'উপলক্ষ/কর্মসূচী', 'তারিখ', 'শাখার নাম', 'উপলক্ষ/কর্মসূচী']),
                  _buildSafarGridRow('', entry.travelDetails, '', '', '', ''),
                  _buildSafarGridRow('', '', '', '', '', ''),
                  _buildSafarGridRow('', '', '', '', '', ''),
                  _buildSafarGridRow('', '', '', '', '', ''),
                ],
              ),

              pw.Spacer(),
              pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: PdfExportService.b('অপর পৃষ্ঠায় দ্রষ্টব্য', fontSize: 9.5, fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );

    // PAGE 2: আয়-ব্যয়, অন্যান্য, মন্তব্য ও পরামর্শ
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.SizedBox(height: 10),
              _buildSectionHeader('আয়-ব্যয়'),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(1.2),
                  1: pw.FlexColumnWidth(3.5),
                  2: pw.FlexColumnWidth(2),
                  3: pw.FlexColumnWidth(1.2),
                  4: pw.FlexColumnWidth(3.5),
                  5: pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.center,
                        padding: const pw.EdgeInsets.all(3),
                        child: PdfExportService.b('আয়', fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Container(), pw.Container(),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        padding: const pw.EdgeInsets.all(3),
                        child: PdfExportService.b('ব্যয়', fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Container(), pw.Container(),
                    ],
                  ),
                  _buildTableHeader(['তারিখ', 'উৎস', 'পরিমাণ(টাকা)', 'তারিখ', 'খাত', 'পরিমাণ(টাকা)']),
                  _buildIncomeExpenseRow('', 'সফর আয় (শাখা থেকে)', entry.safarIncomeTaka, '', 'সফর', entry.safarExpenseTaka),
                  _buildIncomeExpenseRow('', 'কেন্দ্র থেকে (বায়তুল বিভাগ)', entry.centralIncomeTaka, '', 'যোগাযোগ', entry.communicationExpenseTaka),
                  _buildIncomeExpenseRow('', 'এককালীন (যদি থাকে)', entry.onetimeIncomeTaka, '', 'অফিস', entry.officeExpenseTaka),
                  _buildIncomeExpenseRow('', '', '', '', 'অন্যান্য (যদি থাকে)', entry.otherExpenseTaka),
                  _buildIncomeExpenseRow('', 'মোট আয়', totalIncome > 0 ? totalIncome.toStringAsFixed(0) : '', '', 'মোট ব্যয়', totalExpense > 0 ? totalExpense.toStringAsFixed(0) : '', isBold: true),
                  _buildIncomeExpenseRow('', 'উদ্বৃত্ত / ঘাটতি', netBalance != 0 ? netBalance.toStringAsFixed(0) : '', '', '', '', isBold: true),
                ],
              ),
              pw.SizedBox(height: 16),

              // অন্যান্য সেকশন
              _buildSectionHeader('অন্যান্য'),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey500, width: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    PdfExportService.b('১ । শাখা রিপোর্ট জমা হয়েছে: ${entry.shakhaReportSubmitted.isEmpty ? "........" : entry.shakhaReportSubmitted} টি;  শাখার নাম- ....................................................', fontSize: 9.5),
                    pw.SizedBox(height: 6),
                    PdfExportService.b('২ । শাখা পরিকল্পনা জমা হয়েছে: ${entry.shakhaPlanSubmitted.isEmpty ? "........" : entry.shakhaPlanSubmitted} টি;  শাখার নাম- ....................................................', fontSize: 9.5),
                    pw.SizedBox(height: 6),
                    PdfExportService.b('৩ । শাখা বায়তুলমাল জমা হয়েছে: ${entry.shakhaBaytulmalSubmitted.isEmpty ? "........" : entry.shakhaBaytulmalSubmitted} টি;  শাখার নাম- ....................................................', fontSize: 9.5),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),

              // মন্তব্য
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: PdfExportService.b('মন্তব্য:', fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Container(
                width: double.infinity,
                height: 60,
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey500, width: 0.5)),
                child: PdfExportService.b(entry.remarks.isEmpty ? '........................................................................................................................................................' : entry.remarks, fontSize: 9.5),
              ),
              pw.SizedBox(height: 14),

              // পরামর্শ
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: PdfExportService.b('পরামর্শ:', fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Container(
                width: double.infinity,
                height: 60,
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey500, width: 0.5)),
                child: PdfExportService.b(entry.suggestions.isEmpty ? '........................................................................................................................................................' : entry.suggestions, fontSize: 9.5),
              ),

              pw.Spacer(),

              // Footer Signatures
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  PdfExportService.b('তারিখ: ...........................................', fontSize: 9.5),
                  PdfExportService.b('জোন পরিচালকের স্বাক্ষর', fontSize: 9.5, fontWeight: pw.FontWeight.bold),
                ],
              ),
              pw.SizedBox(height: 8),
              PdfExportService.b('বি: দ্র: জেলা শাখার রিপোর্ট (শাখা রিপোর্ট ফরমে) আলাদাভাবে নিয়মিত কেন্দ্রে পাঠানোর ব্যবস্থা করবেন।', fontSize: 8.5),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildSectionHeader(String title) {
    return pw.Container(
      width: double.infinity,
      color: PdfColors.grey300,
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      alignment: pw.Alignment.center,
      child: PdfExportService.b(title, fontSize: 10.5, fontWeight: pw.FontWeight.bold),
    );
  }

  static pw.TableRow _buildTableHeader(List<String> headers) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey100),
      children: headers.map((h) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(3),
          child: PdfExportService.b(h, fontSize: 9, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center),
        );
      }).toList(),
    );
  }

  static pw.TableRow _buildManpowerRow(String label, String count, String bridhi, String ghatti) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(label, fontSize: 9)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(count, fontSize: 9, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(bridhi, fontSize: 9, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(ghatti, fontSize: 9, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b('', fontSize: 9)),
      ],
    );
  }

  static pw.TableRow _buildOrgRow(String label, String count, String org, String reorg) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(label, fontSize: 9)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(count, fontSize: 9, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(org, fontSize: 9, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(reorg, fontSize: 9, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b('', fontSize: 9)),
      ],
    );
  }

  static pw.TableRow _buildMeetingRow(String label, String count, String pres) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(label, fontSize: 9)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(count, fontSize: 9, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(pres, fontSize: 9, textAlign: pw.TextAlign.center)),
      ],
    );
  }

  static pw.TableRow _buildSafarGridRow(String d1, String s1, String c1, String d2, String s2, String c2) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(d1, fontSize: 9, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(s1, fontSize: 9)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(c1, fontSize: 9)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(d2, fontSize: 9, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(s2, fontSize: 9)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(c2, fontSize: 9)),
      ],
    );
  }

  static pw.TableRow _buildIncomeExpenseRow(String d1, String u1, String p1, String d2, String k2, String p2, {bool isBold = false}) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(d1, fontSize: 9, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(u1, fontSize: 9, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(p1, fontSize: 9, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(d2, fontSize: 9, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(k2, fontSize: 9, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b(p2, fontSize: 9, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, textAlign: pw.TextAlign.center)),
      ],
    );
  }
}
