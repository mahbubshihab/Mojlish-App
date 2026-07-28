import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../domain/entities/baytulmal_report_entity.dart';

class StudentBaytulmalPdfService {
  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
  ];

  static String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  static Future<void> generateAndSharePdf(dynamic report) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.notoSansBengaliRegular();
    final boldFont = await PdfGoogleFonts.notoSansBengaliBold();

    final monthName = (report.month >= 1 && report.month <= 12)
        ? _monthNames[report.month - 1]
        : _bn(report.month);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Header
              pw.Center(
                child: pw.Text(
                  'বিসমিল্লাহির রাহমানির রাহিম',
                  style: pw.TextStyle(font: font, fontSize: 11, color: PdfColors.blueGrey800),
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Center(
                child: pw.Text(
                  'বায়তুলমাল রিপোর্ট',
                  style: pw.TextStyle(font: boldFont, fontSize: 18, color: PdfColors.blue800),
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Center(
                child: pw.Text(
                  'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                  style: pw.TextStyle(font: boldFont, fontSize: 22, color: PdfColors.blue900),
                ),
              ),
              pw.SizedBox(height: 10),

              // Metadata row
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.blue800, width: 0.8),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('শাখা : ${report.branchName.isEmpty ? '________' : report.branchName}',
                        style: pw.TextStyle(font: font, fontSize: 11)),
                    pw.Text('মাস : $monthName ${_bn(report.year)}',
                        style: pw.TextStyle(font: font, fontSize: 11)),
                    pw.Text('সেশন : ${report.session.isEmpty ? _bn(report.year) : report.session}',
                        style: pw.TextStyle(font: font, fontSize: 11)),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),

              // 1. আয় সেকশন
              pw.Container(
                color: PdfColors.blue100,
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text('আয়', style: pw.TextStyle(font: boldFont, fontSize: 14, color: PdfColors.blue900)),
                ),
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.blueGrey300, width: 0.5),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(1),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.blue50),
                    children: [
                      _th('আয়ের উৎস', font: boldFont),
                      _th('টাকা', font: boldFont, align: pw.TextAlign.right),
                      _th('পয়সা', font: boldFont, align: pw.TextAlign.right),
                    ],
                  ),
                  // Pre-printed rows
                  _tRow('১. জনশক্তি এয়ানত (সদস্য/সহযোগী সদস্য/কর্মী)', report.jonoshaktiAyanatTaka, report.jonoshaktiAyanatPaisa, font),
                  _tRow('২. শাখা এয়ানত', report.shakhaAyanatTaka, report.shakhaAyanatPaisa, font),
                  _tRow('৩. শুভাকাঙ্ক্ষী এয়ানত', report.suhridAyanatTaka, report.suhridAyanatPaisa, font),
                  _tRow('৪. এককালীন আয় (বিস্তারিত আলাদা কাগজে)', report.ekkalinIncomeTaka, report.ekkalinIncomePaisa, font),
                  // Custom rows
                  for (int i = 0; i < report.customIncomeRows.length; i++)
                    _tRow('${i + 5}. ${report.customIncomeRows[i].title}', report.customIncomeRows[i].taka, report.customIncomeRows[i].paisa, font),
                ],
              ),

              // Income Summary Box
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.blueGrey300, width: 0.5),
                ),
                padding: const pw.EdgeInsets.all(6),
                child: pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('কথায় : ${report.incomeInWords}', style: pw.TextStyle(font: font, fontSize: 10)),
                        pw.Text('মোট আয়: ৳ ${report.totalIncome.toStringAsFixed(2)}', style: pw.TextStyle(font: boldFont, fontSize: 10)),
                      ],
                    ),
                    pw.SizedBox(height: 2),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('বিগত সেশন/মাসের উদ্বৃত্ত: ৳ ${report.previousSurplus.toStringAsFixed(2)}', style: pw.TextStyle(font: font, fontSize: 10)),
                        pw.Text('সর্বমোট আয়: ৳ ${report.grandTotalIncome.toStringAsFixed(2)}', style: pw.TextStyle(font: boldFont, fontSize: 11, color: PdfColors.green800)),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 14),

              // 2. ব্যয় সেকশন
              pw.Container(
                color: PdfColors.red100,
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text('ব্যয়', style: pw.TextStyle(font: boldFont, fontSize: 14, color: PdfColors.red900)),
                ),
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.blueGrey300, width: 0.5),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(1),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.red50),
                    children: [
                      _th('ব্যয়ের খাত', font: boldFont),
                      _th('টাকা', font: boldFont, align: pw.TextAlign.right),
                      _th('পয়সা', font: boldFont, align: pw.TextAlign.right),
                    ],
                  ),
                  // Pre-printed rows
                  _tRow('১. ঊর্ধ্বতন এয়ানত পরিশোধ', report.upwardAyanatTaka, report.upwardAyanatPaisa, font),
                  _tRow('২. ঊর্ধ্বতন সফর', report.upwardSafarTaka, report.upwardSafarPaisa, font),
                  _tRow('৩. অফিস', report.officeTaka, report.officePaisa, font),
                  _tRow('৪. যাতায়াত', report.transportTaka, report.transportPaisa, font),
                  _tRow('৫. যোগাযোগ', report.communicationTaka, report.communicationPaisa, font),
                  _tRow('৬. প্রচার', report.procharTaka, report.procharPaisa, font),
                  // Custom rows
                  for (int i = 0; i < report.customExpenseRows.length; i++)
                    _tRow('${i + 7}. ${report.customExpenseRows[i].title}', report.customExpenseRows[i].taka, report.customExpenseRows[i].paisa, font),
                ],
              ),

              // Expense Summary Box
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.blueGrey300, width: 0.5),
                ),
                padding: const pw.EdgeInsets.all(6),
                child: pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('কথায় : ${report.expenseInWords}', style: pw.TextStyle(font: font, fontSize: 10)),
                        pw.Text('মোট ব্যয়: ৳ ${report.totalExpense.toStringAsFixed(2)}', style: pw.TextStyle(font: boldFont, fontSize: 10)),
                      ],
                    ),
                    pw.SizedBox(height: 2),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('বিগত সেশন/মাসের ঘাটতি: ৳ ${report.previousDeficit.toStringAsFixed(2)}', style: pw.TextStyle(font: font, fontSize: 10)),
                        pw.Text('সর্বমোট ব্যয়: ৳ ${report.grandTotalExpense.toStringAsFixed(2)}', style: pw.TextStyle(font: boldFont, fontSize: 10)),
                      ],
                    ),
                    pw.Divider(color: PdfColors.grey400, thickness: 0.5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('সর্বমোট আয়: ৳ ${report.grandTotalIncome.toStringAsFixed(2)}', style: pw.TextStyle(font: font, fontSize: 10)),
                        pw.Text(
                          report.balance >= 0
                              ? 'উদ্বৃত্ত: ৳ ${report.balance.toStringAsFixed(2)}'
                              : 'ঘাটতি: ৳ ${report.balance.abs().toStringAsFixed(2)}',
                          style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 11,
                            color: report.balance >= 0 ? PdfColors.green800 : PdfColors.red800,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 2),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text('(ঘাটতি তালিকার বিস্তারিত আলাদা কাগজে)',
                          style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey700)),
                    ),
                  ],
                ),
              ),

              pw.Spacer(),

              // Footer: President Signature
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    children: [
                      pw.Container(width: 120, height: 1, color: PdfColors.black),
                      pw.SizedBox(height: 4),
                      pw.Text('সভাপতির স্বাক্ষর', style: pw.TextStyle(font: font, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'baytulmal_report_${report.year}_${report.month}.pdf',
    );
  }

  static pw.Widget _th(String text, {required pw.Font font, pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 10), textAlign: align),
    );
  }

  static pw.TableRow _tRow(String title, String taka, String paisa, pw.Font font) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: pw.Text(title, style: pw.TextStyle(font: font, fontSize: 9)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: pw.Text(taka.isEmpty ? '0' : taka, style: pw.TextStyle(font: font, fontSize: 9), textAlign: pw.TextAlign.right),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: pw.Text(paisa.isEmpty ? '0' : paisa, style: pw.TextStyle(font: font, fontSize: 9), textAlign: pw.TextAlign.right),
        ),
      ],
    );
  }
}
