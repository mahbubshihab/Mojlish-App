import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/data/models/baytulmal_report_entry.dart';

/// খেলাফত মজলিস — বায়তুলমাল রিপোর্ট ফিচার স্পেসিফিক পিডিএফ সার্ভিস
class KhelafatBaytulmalPdfService {
  /// খেলাফত মজলিস অফিশিয়াল ফরম্যাট অনুযায়ী পিডিএফ বাইটস তৈরি করা
  static Future<Uint8List> generatePdfBytes({
    required BaytulmalReportEntry entry,
    String? incomeInWords,
    String? expenseInWords,
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
              PdfExportService.b('বিসমিল্লাহির রাহমানির রাহীম', fontSize: 9.5),
              pw.SizedBox(height: 2),
              PdfExportService.b('শাখার বায়তুলমাল রিপোর্ট ফরম', fontSize: 13, fontWeight: pw.FontWeight.bold),
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
              PdfExportService.b('কেন্দ্রীয় কার্যালয়: ১৬ পুরানা পল্টন, (২য় তলা), ঢাকা-১০০০। ফোন: ৯৫৫৮৫২১', fontSize: 8.5),
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
                    PdfExportService.b('শাখা: ${entry.branchName.isEmpty ? "........................" : entry.branchName}', fontSize: 10.5, fontWeight: pw.FontWeight.bold),
                    PdfExportService.b('মাস: ${entry.month.isEmpty ? "........................" : entry.month}', fontSize: 10.5, fontWeight: pw.FontWeight.bold),
                    PdfExportService.b('সন: ${entry.year.isEmpty ? "........................" : entry.year}', fontSize: 10.5, fontWeight: pw.FontWeight.bold),
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
                child: PdfExportService.b('আয়', fontSize: 11, fontWeight: pw.FontWeight.bold),
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
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b('আয়ের উৎস', fontSize: 9.5, fontWeight: pw.FontWeight.bold)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b('টাকা', fontSize: 9.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b('পয়সা', fontSize: 9.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                    ],
                  ),
                  _buildTableRow('নির্বাহী সদস্যদের ইয়ানত (নির্বাহী সদস্য সংখ্যা: ${entry.executiveMemberAyanat.isEmpty ? "____" : entry.executiveMemberAyanat} জন)', entry.executiveMemberAyanatTaka),
                  _buildTableRow('অধস্তন শাখা ইয়ানত (শাখা সংখ্যা: ${entry.subBranchAyanat.isEmpty ? "____" : entry.subBranchAyanat} টি)', entry.subBranchAyanatTaka),
                  _buildTableRow('সুধী/শুভাকাঙ্ক্ষী ইয়ানত (শুভাকাঙ্ক্ষী সংখ্যা: ${entry.suhridAyanat.isEmpty ? "____" : entry.suhridAyanat} জন)', entry.suhridAyanatTaka),
                  _buildTableRow('সফর', entry.safarIncomeTaka),
                  _buildTableRow('প্রকাশনা', entry.prokashnaIncomeTaka),
                  _buildTableRow('এককালীন (বিস্তারিত আলাদা কাগজে)', entry.onetimeIncomeTaka),
                  _buildTableRow('মোট আয়', directIncomeSum > 0 ? directIncomeSum.toStringAsFixed(0) : '', isBold: true),
                  _buildTableRow('বিগত মাস / সেশনের উদ্বৃত্ত', entry.previousBalance),
                  _buildTableRow('সর্বমোট আয়', grandTotalIncome > 0 ? grandTotalIncome.toStringAsFixed(0) : '', isBold: true),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: PdfExportService.b('কথায়: ${incomeInWords ?? "........................................................................................................"}', fontSize: 9),
              ),
              pw.SizedBox(height: 10),

              // ================= SECTION 2: ব্যয় =================
              pw.Container(
                width: double.infinity,
                color: PdfColors.grey300,
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                alignment: pw.Alignment.center,
                child: PdfExportService.b('ব্যয়', fontSize: 11, fontWeight: pw.FontWeight.bold),
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
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b('ব্যয়ের খাত', fontSize: 9.5, fontWeight: pw.FontWeight.bold)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b('টাকা', fontSize: 9.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.b('পয়সা', fontSize: 9.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                    ],
                  ),
                  _buildTableRow('উর্ধ্বতন ইয়ানত পরিশোধ (মাসিক ধার্যকৃত: ${entry.upwardAyanat.isEmpty ? "____" : entry.upwardAyanat} টাকা)', entry.upwardAyanatTaka),
                  _buildTableRow('অফিস ভাড়া ও বিল', entry.officeRentTaka),
                  _buildTableRow('অফিস খরচ', entry.officeCostTaka),
                  _buildTableRow('সফর', entry.safarExpenseTaka),
                  _buildTableRow('যাতায়াত', entry.transportTaka),
                  _buildTableRow('যোগাযোগ', entry.communicationTaka),
                  _buildTableRow('প্রচার', entry.procharTaka),
                  _buildTableRow('প্রকাশনা', entry.prokashnaExpenseTaka),
                  _buildTableRow('দিবস পালন (নাম: ${entry.dibosPalan.isEmpty ? "________________________" : entry.dibosPalan})', entry.dibosPatanTaka),
                  _buildTableRow('আপ্যায়ন', entry.appayanTaka),
                  _buildTableRow('সভা/সমাবেশ বাস্তবায়ন (বিস্তারিত আলাদা কাগজে)', entry.sovaTaka),
                  _buildTableRow('মোট ব্যয়', totalExpense > 0 ? totalExpense.toStringAsFixed(0) : '', isBold: true),
                  _buildTableRow('সর্বমোট আয়', grandTotalIncome > 0 ? grandTotalIncome.toStringAsFixed(0) : '', isBold: true),
                  _buildTableRow('উদ্বৃত্ত / ঘাটতি', netBalance != 0 ? netBalance.toStringAsFixed(0) : '', isBold: true),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: PdfExportService.b('কথায়: ${expenseInWords ?? "........................................................................................................"}', fontSize: 9),
              ),

              pw.Spacer(),

              // ================= FOOTER SIGNATURES =================
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  PdfExportService.b('তারিখ: ...........................................', fontSize: 9.5),
                  PdfExportService.b('বায়তুলমাল সম্পাদকের স্বাক্ষর', fontSize: 9.5, fontWeight: pw.FontWeight.bold),
                  PdfExportService.b('সভাপতির স্বাক্ষর', fontSize: 9.5, fontWeight: pw.FontWeight.bold),
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

  static pw.TableRow _buildTableRow(String label, String takaVal, {bool isBold = false}) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: PdfExportService.b(label, fontSize: 9, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: PdfExportService.b(takaVal, fontSize: 9, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: PdfExportService.b(takaVal.isNotEmpty ? '০০' : '', fontSize: 9, textAlign: pw.TextAlign.center),
        ),
      ],
    );
  }
}
