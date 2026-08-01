import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/pdf_preview_screen.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস — বার্ষিক/ষান্মাসিক/দ্বি-মাসিক পর্যায়ভিত্তিক পরিকল্পনা (১ পৃষ্ঠা) PDF জেনারেটর সার্ভিস
/// বিজয় এনকোডিং (SutonnyMJ ফন্ট) ও আধুনিক ওশান সায়ান গ্রাফিক্স ডিজাইনে সাজানো
class StudentPeriodPlanPdfService {
  static Future<Uint8List> generatePdfBytes({
    required String branch,
    required String month,
    required String session,
    Map<String, String>? formData,
  }) async {
    final fontRegular = await PdfExportService.loadSutonnyFont();
    final fontBold = await PdfExportService.loadBengaliBoldFont();

    final data = formData ?? {};
    String g(String key) => data[key] ?? '';

    pw.MemoryImage? logoImage;
    try {
      final ByteData logoBytes = await rootBundle.load(MajlisAssets.chatroLogo);
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (_) {
      try {
        final ByteData logoBytes = await rootBundle.load(MajlisAssets.defaultLogo);
        logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
      } catch (_) {}
    }

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: fontRegular,
        bold: fontBold,
      ),
    );

    final oceanCyan = PdfColor.fromHex('#0077B6');

    pw.Widget buildHeaderRibbon() {
      return pw.Column(
        children: [
          PdfExportService.bWidget(
            'বিসমিল্লাহির রাহমানির রাহীম',
            fontSize: 7.5,
            fontWeight: pw.FontWeight.bold,
            color: oceanCyan,
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 1.5),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(vertical: 3.5, horizontal: 8),
            decoration: pw.BoxDecoration(
              color: oceanCyan,
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                if (logoImage != null) ...[
                  pw.Image(logoImage, width: 22, height: 22),
                  pw.SizedBox(width: 6),
                ],
                pw.Column(
                  children: [
                    PdfExportService.bWidget(
                      'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 0.5),
                    PdfExportService.bWidget(
                      'বার্ষিক/ষান্মাসিক/দ্বি-মাসিক পরিকল্পনা',
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    pw.Widget buildMetadataBar() {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
        decoration: pw.BoxDecoration(
          color: PdfColor.fromHex('#F0F9FF'),
          border: pw.Border.all(color: oceanCyan, width: 0.6),
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            PdfExportService.bWidget(
              'শাখা: ${branch.isEmpty ? "........................" : branch}',
              fontSize: 8.0,
              fontWeight: pw.FontWeight.bold,
              color: oceanCyan,
            ),
            PdfExportService.bWidget(
              'মাস: ${month.isEmpty ? "........................" : month}',
              fontSize: 8.0,
              fontWeight: pw.FontWeight.bold,
              color: oceanCyan,
            ),
            PdfExportService.bWidget(
              'সেশন: ${session.isEmpty ? "........................" : session}',
              fontSize: 8.0,
              fontWeight: pw.FontWeight.bold,
              color: oceanCyan,
            ),
          ],
        ),
      );
    }

    pw.Widget buildBadge(String title) {
      return pw.Container(
        width: double.infinity,
        alignment: pw.Alignment.center,
        margin: const pw.EdgeInsets.symmetric(vertical: 2.0),
        padding: const pw.EdgeInsets.symmetric(vertical: 2.0, horizontal: 6),
        decoration: pw.BoxDecoration(
          color: oceanCyan,
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: PdfExportService.bWidget(
          title,
          fontSize: 9.0,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      );
    }

    pw.Widget buildDottedRow(String label, String value, {String unit = '', String prefix = ''}) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
        child: pw.Row(
          children: [
            if (prefix.isNotEmpty) ...[
              PdfExportService.bWidget(prefix, fontSize: 7.2),
              pw.SizedBox(width: 1.5),
            ],
            PdfExportService.bWidget(label, fontSize: 7.2),
            pw.SizedBox(width: 2.5),
            pw.Expanded(
              child: pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5)),
                ),
                alignment: pw.Alignment.centerLeft,
                child: PdfExportService.bWidget(
                  value.isEmpty ? '................................................................' : value,
                  fontSize: 7.2,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            if (unit.isNotEmpty) ...[
              pw.SizedBox(width: 2.5),
              PdfExportService.bWidget(unit, fontSize: 7.2),
            ],
          ],
        ),
      );
    }

    pw.Widget buildInlineCell(String label, String value, {String unit = '', String prefix = ''}) {
      return pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          if (prefix.isNotEmpty) ...[
            PdfExportService.bWidget(prefix, fontSize: 7.2),
            pw.SizedBox(width: 1),
          ],
          if (label.isNotEmpty) ...[
            PdfExportService.bWidget(label, fontSize: 7.2),
            pw.SizedBox(width: 2),
          ],
          pw.Container(
            constraints: const pw.BoxConstraints(minWidth: 22),
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5)),
            ),
            alignment: pw.Alignment.center,
            child: PdfExportService.bWidget(
              value.isEmpty ? '......' : value,
              fontSize: 7.2,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          if (unit.isNotEmpty) ...[
            pw.SizedBox(width: 1.5),
            PdfExportService.bWidget(unit, fontSize: 7.2),
          ],
        ],
      );
    }

    pw.Widget buildMeetingRow(String label, String count, String dateTime) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
        child: pw.Row(
          children: [
            buildInlineCell(label, count, unit: 'টি,'),
            pw.SizedBox(width: 6),
            PdfExportService.bWidget('তারিখ ও সময় : ', fontSize: 7.2),
            pw.Expanded(
              child: pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5)),
                ),
                alignment: pw.Alignment.centerLeft,
                child: PdfExportService.bWidget(
                  dateTime.isEmpty ? '................................................' : dateTime,
                  fontSize: 7.2,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget buildFooter() {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(vertical: 2.0),
        margin: const pw.EdgeInsets.only(top: 3.0),
        decoration: pw.BoxDecoration(
          color: oceanCyan,
          borderRadius: pw.BorderRadius.circular(3),
        ),
        child: pw.Center(
          child: pw.Text(
            'www.chhatra-majlis.org.bd',
            style: pw.TextStyle(
              fontSize: 7.5,
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // --- SINGLE A4 PAGE ---
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Top Header Ribbon
              buildHeaderRibbon(),
              pw.SizedBox(height: 3),

              // Metadata Bar
              buildMetadataBar(),
              pw.SizedBox(height: 2),

              // 1. প্রথম দফা : দাওয়াত
              buildBadge('প্রথম দফা : দাওয়াত'),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    buildInlineCell('বন্ধু বৃদ্ধি', g('dawa_bondhu'), unit: 'জন |'),
                    pw.SizedBox(width: 8),
                    buildInlineCell('প্রাথমিক সদস্য বৃদ্ধি', g('dawa_primary_member'), unit: 'জন'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    buildInlineCell('ক. স্কুল : সরকারি', g('dawa_school_govt'), unit: 'জন,'),
                    pw.SizedBox(width: 4),
                    buildInlineCell('বেসরকারি', g('dawa_school_non_govt'), unit: 'জন |'),
                    pw.SizedBox(width: 4),
                    buildInlineCell('খ. কলেজ', g('dawa_college'), unit: 'জন'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    buildInlineCell('গ. মাদ্রাসা : আলিয়া', g('dawa_madrasa_alia'), unit: 'জন,'),
                    pw.SizedBox(width: 4),
                    buildInlineCell('কওমী', g('dawa_madrasa_qawmi'), unit: 'জন |'),
                    pw.SizedBox(width: 4),
                    buildInlineCell('ঘ. বিশ্ববিদ্যালয়', g('dawa_university'), unit: 'জন'),
                  ],
                ),
              ),
              buildDottedRow('শুভানুধ্যায়ী বৃদ্ধি / যোগাযোগ', g('dawa_shuvakangkhi'), unit: 'জন'),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('♦ পরিচিতি / ইসলামী সাহিত্য বিতরণ ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_sahitya_1')),
                    PdfExportService.bWidget(' / ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_sahitya_2'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('♦ ছাত্র পরিক্রমা / কিশোর পত্রিকা বিতরণ ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_patrika_1')),
                    PdfExportService.bWidget(' / ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_patrika_2'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('♦ লিফলেট / স্টিকার / পোস্টার লাগানো ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_leaflet_1')),
                    PdfExportService.bWidget(' / ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_leaflet_2')),
                    PdfExportService.bWidget(' / ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_leaflet_3'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('♦ দেয়াল লিখন / দেয়ালিকা প্রকাশ / নবীন বরণ ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_deyal_1')),
                    PdfExportService.bWidget(' / ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_deyal_2')),
                    PdfExportService.bWidget(' / ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_deyal_3'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('♦ গ্রুপ দাওয়াত / চা চক্র / উন্মুক্ত আসর ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_group_1')),
                    PdfExportService.bWidget(' / ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_group_2')),
                    PdfExportService.bWidget(' / ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_group_3'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('♦ বক্তৃতা / বিতর্ক / সাধারণ জ্ঞান প্রতিযোগিতা ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_boktita_1')),
                    PdfExportService.bWidget(' / ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_boktita_2')),
                    PdfExportService.bWidget(' / ', fontSize: 7.2),
                    buildInlineCell('', g('dawa_boktita_3'), unit: 'টি'),
                  ],
                ),
              ),
              buildDottedRow('অন্যান্য দাওয়াতি কার্যক্রম', g('dawa_other'), prefix: '♦ '),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    buildInlineCell('কাজ বৃদ্ধি : প্রাতিষ্ঠানিক', g('dawa_work_inst'), unit: 'টি,'),
                    pw.SizedBox(width: 6),
                    buildInlineCell('আবাসিক', g('dawa_work_res'), unit: 'টি'),
                  ],
                ),
              ),
              buildDottedRow('   নাম :', g('dawa_work_names')),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    buildInlineCell('প্রাথমিক শাখা বৃদ্ধি : প্রাতিষ্ঠানিক', g('dawa_branch_inst'), unit: 'টি,'),
                    pw.SizedBox(width: 6),
                    buildInlineCell('আবাসিক', g('dawa_branch_res'), unit: 'টি'),
                  ],
                ),
              ),
              buildDottedRow('   নাম :', g('dawa_branch_names')),

              // 2. দ্বিতীয় দফা : সংগঠন
              buildBadge('দ্বিতীয় দফা : সংগঠন'),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    buildInlineCell('সহযোগী সদস্য প্রার্থী টার্গেট', g('org_assoc_candidate_target'), unit: 'জন |'),
                    pw.SizedBox(width: 4),
                    PdfExportService.bWidget('নাম : ', fontSize: 7.2),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: PdfExportService.bWidget(g('org_assoc_candidate_names').isEmpty ? '................................................' : g('org_assoc_candidate_names'), fontSize: 7.2, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              buildDottedRow('কর্মী বৃদ্ধি', g('org_worker_growth'), unit: 'জন'),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    buildInlineCell('ক. স্কুল : সরকারি', g('org_school_govt'), unit: 'জন,'),
                    pw.SizedBox(width: 4),
                    buildInlineCell('বেসরকারি', g('org_school_non_govt'), unit: 'জন |'),
                    pw.SizedBox(width: 4),
                    buildInlineCell('খ. কলেজ', g('org_college'), unit: 'জন'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    buildInlineCell('গ. মাদ্রাসা : আলিয়া', g('org_madrasa_alia'), unit: 'জন,'),
                    pw.SizedBox(width: 4),
                    buildInlineCell('কওমী', g('org_madrasa_qawmi'), unit: 'জন |'),
                    pw.SizedBox(width: 4),
                    buildInlineCell('ঘ. বিশ্ববিদ্যালয়', g('org_university'), unit: 'জন'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    buildInlineCell('সহযোগী সদস্য শাখা বৃদ্ধি', g('org_assoc_branch_growth'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    PdfExportService.bWidget('নাম : ', fontSize: 7.2),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: PdfExportService.bWidget(g('org_assoc_branch_names').isEmpty ? '................................' : g('org_assoc_branch_names'), fontSize: 7.2, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    buildInlineCell('থানা / জোন শাখা বৃদ্ধি', g('org_thana_zone_branch_growth'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    PdfExportService.bWidget('নাম : ', fontSize: 7.2),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: PdfExportService.bWidget(g('org_thana_zone_branch_names').isEmpty ? '................................' : g('org_thana_zone_branch_names'), fontSize: 7.2, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    buildInlineCell('কর্মী শাখা বৃদ্ধি', g('org_worker_branch_growth'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    buildInlineCell('প্রাতিষ্ঠানিক', g('org_worker_branch_inst'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    buildInlineCell('আবাসিক', g('org_worker_branch_res'), unit: 'টি'),
                  ],
                ),
              ),
              buildDottedRow('   নাম :', g('org_worker_branch_names')),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    buildInlineCell('ঊর্ধ্বতন সফর আনা হবে', g('org_senior_visit_count'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    PdfExportService.bWidget('তারিখ : ', fontSize: 7.2),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: PdfExportService.bWidget(g('org_senior_visit_date').isEmpty ? '................................' : g('org_senior_visit_date'), fontSize: 7.2, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. সভাসমূহ
              buildBadge('সভাসমূহ'),
              buildMeetingRow('দায়িত্বশীল সভা', g('meet_daitoshil_count'), g('meet_daitoshil_date_time')),
              buildMeetingRow('জোনাল দায়িত্বশীল সভা', g('meet_zonal_daitoshil_count'), g('meet_zonal_daitoshil_date_time')),
              buildMeetingRow('সদস্য সভা', g('meet_member_count'), g('meet_member_date_time')),
              buildMeetingRow('সহযোগী সদস্য সভা', g('meet_assoc_member_count'), g('meet_assoc_member_date_time')),
              buildMeetingRow('কর্মী সভা', g('meet_worker_count'), g('meet_worker_date_time')),
              buildMeetingRow('সাধারণ সভা', g('meet_general_count'), g('meet_general_date_time')),
              buildMeetingRow('আলোচনা সভা', g('meet_discussion_count'), g('meet_discussion_date_time')),
              buildDottedRow('অন্যান্য সভাসমূহ', g('meet_other')),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
                child: pw.Row(
                  children: [
                    buildInlineCell('বায়তুলমাল সংগ্রহ করা হবে', g('meet_baytulmal_target'), unit: 'টাকা'),
                    pw.SizedBox(width: 4),
                    PdfExportService.bWidget('(প্রতি মাসের আয়-ব্যয়ের বিস্তারিত বাজেট আলাদা কাগজে থাকবে।)', fontSize: 6.5, color: PdfColors.grey700),
                  ],
                ),
              ),

              pw.Spacer(),
              buildFooter(),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<void> generateAndPrintPdf({
    required String branch,
    required String month,
    required String session,
    Map<String, String>? formData,
    BuildContext? context,
  }) async {
    final pdfBytes = await generatePdfBytes(
      branch: branch,
      month: month,
      session: session,
      formData: formData,
    );

    final fileName = 'ছাত্র_মজলিস_পরিকল্পনা_${month}_$session.pdf';
    if (context != null) {
      if (!context.mounted) return;
      await openPdfPreview(
        context,
        pdfBytes,
        'পর্যায়ভিত্তিক পরিকল্পনা',
        fileName: fileName,
      );
    } else {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: fileName,
      );
    }
  }
}
