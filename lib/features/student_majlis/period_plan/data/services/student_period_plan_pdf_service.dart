import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/pdf_preview_screen.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস — বার্ষিক/ষান্মাসিক/দ্বি-মাসিক পর্যায়ভিত্তিক পরিকল্পনা (২ পৃষ্ঠা A4) PDF জেনারেটর সার্ভিস
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
            padding: const pw.EdgeInsets.symmetric(vertical: 3.0, horizontal: 8),
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
          borderRadius: pw.BorderRadius.circular(6),
        ),
        child: PdfExportService.bWidget(
          title,
          fontSize: 8.5,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      );
    }

    pw.Widget buildDottedRow(String label, String value, {String unit = '', String prefix = ''}) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
        padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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

    pw.Widget buildTrainingRow4(
      String label,
      String count,
      String date,
      String time,
      String place,
    ) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
        child: pw.Row(
          children: [
            buildInlineCell(label, count, unit: 'টি,'),
            pw.SizedBox(width: 4),
            buildInlineCell('তারিখ', date, unit: ','),
            pw.SizedBox(width: 4),
            buildInlineCell('সময়', time, unit: ','),
            pw.SizedBox(width: 4),
            PdfExportService.bWidget('স্থান : ', fontSize: 7.2),
            pw.Expanded(
              child: pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5)),
                ),
                alignment: pw.Alignment.centerLeft,
                child: PdfExportService.bWidget(
                  place.isEmpty ? '........................' : place,
                  fontSize: 7.2,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget buildTrainingRow3(
      String label,
      String count,
      String sessionCount,
      String date,
    ) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
        child: pw.Row(
          children: [
            buildInlineCell('$label : সংখ্যা', count, unit: 'টি,'),
            pw.SizedBox(width: 6),
            buildInlineCell('অধিবেশন', sessionCount, unit: 'টি,'),
            pw.SizedBox(width: 6),
            PdfExportService.bWidget('তারিখ : ', fontSize: 7.2),
            pw.Expanded(
              child: pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5)),
                ),
                alignment: pw.Alignment.centerLeft,
                child: PdfExportService.bWidget(
                  date.isEmpty ? '................................' : date,
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
        margin: const pw.EdgeInsets.only(top: 2.0),
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

    // ==========================================
    // --- PAGE 1: 100% MATCHING image.png ---
    // ==========================================
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Ribbon & Metadata
              buildHeaderRibbon(),
              pw.SizedBox(height: 3),
              buildMetadataBar(),
              pw.SizedBox(height: 2),

              // 1. প্রথম দফা : দাওয়াত
              buildBadge('প্রথম দফা : দাওয়াত'),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
                child: pw.Row(
                  children: [
                    buildInlineCell('বন্ধু বৃদ্ধি', g('dawa_bondhu'), unit: 'জন |'),
                    pw.SizedBox(width: 8),
                    buildInlineCell('প্রাথমিক সদস্য বৃদ্ধি', g('dawa_primary_member'), unit: 'জন'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
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

    // ==========================================
    // --- PAGE 2: 100% MATCHING image copy.png ---
    // ==========================================
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        build: (pw.Context context) {
          // Compute budget totals
          int inc1 = int.tryParse(g('budget_inc_1')) ?? 0;
          int inc2 = int.tryParse(g('budget_inc_2')) ?? 0;
          int inc3 = int.tryParse(g('budget_inc_3')) ?? 0;
          int inc4 = int.tryParse(g('budget_inc_4')) ?? 0;
          int inc5 = int.tryParse(g('budget_inc_5')) ?? 0;
          int inc6 = int.tryParse(g('budget_inc_6')) ?? 0;
          int inc7 = int.tryParse(g('budget_inc_7')) ?? 0;
          int calcIncTotal = inc1 + inc2 + inc3 + inc4 + inc5 + inc6 + inc7;
          String incTotalStr = g('budget_inc_total').isNotEmpty ? g('budget_inc_total') : (calcIncTotal > 0 ? '$calcIncTotal' : '');

          int exp1 = int.tryParse(g('budget_exp_1')) ?? 0;
          int exp2 = int.tryParse(g('budget_exp_2')) ?? 0;
          int exp3 = int.tryParse(g('budget_exp_3')) ?? 0;
          int exp4 = int.tryParse(g('budget_exp_4')) ?? 0;
          int exp5 = int.tryParse(g('budget_exp_5')) ?? 0;
          int exp6 = int.tryParse(g('budget_exp_6')) ?? 0;
          int exp7 = int.tryParse(g('budget_exp_7')) ?? 0;
          int calcExpTotal = exp1 + exp2 + exp3 + exp4 + exp5 + exp6 + exp7;
          String expTotalStr = g('budget_exp_total').isNotEmpty ? g('budget_exp_total') : (calcExpTotal > 0 ? '$calcExpTotal' : '');

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 3. তৃতীয় দফা : প্রশিক্ষণ
              buildBadge('তৃতীয় দফা : প্রশিক্ষণ'),
              buildTrainingRow4('কর্মশালা', g('train_kormoshala_count'), g('train_kormoshala_date'), g('train_kormoshala_time'), g('train_kormoshala_place')),
              buildTrainingRow4('শিক্ষা সভা', g('train_shikkha_soba_count'), g('train_shikkha_soba_date'), g('train_shikkha_soba_time'), g('train_shikkha_soba_place')),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
                child: pw.Row(
                  children: [
                    buildInlineCell('সামষ্টিক অধ্যয়ন : সংখ্যা', g('train_shamoshtik_count'), unit: 'টি,'),
                    pw.SizedBox(width: 8),
                    buildInlineCell('অধিবেশন', g('train_shamoshtik_session'), unit: 'টি'),
                  ],
                ),
              ),
              buildTrainingRow4('শবগুজারি', g('train_shobgujari_count'), g('train_shobgujari_date'), g('train_shobgujari_time'), g('train_shobgujari_place')),
              buildTrainingRow4('জিকির মাহফিল', g('train_jikir_count'), g('train_jikir_date'), g('train_jikir_time'), g('train_jikir_place')),
              buildTrainingRow3('প্রশিক্ষণ চক্র', g('train_chokro_count'), g('train_chokro_session'), g('train_chokro_date')),
              buildTrainingRow3('স্কিলস ডেভেলপমেন্ট কোর্স', g('train_skills_count'), g('train_skills_session'), g('train_skills_date')),
              buildTrainingRow4('তরবিয়তী সফর', g('train_torbiyoti_count'), g('train_torbiyoti_date'), g('train_torbiyoti_time'), g('train_torbiyoti_place')),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
                child: pw.Row(
                  children: [
                    buildInlineCell('কুরআন ও হাদিস শিক্ষা ক্লাস : সংখ্যা', g('train_quran_hadis_count'), unit: 'টি,'),
                    pw.SizedBox(width: 8),
                    buildInlineCell('অধিবেশন', g('train_quran_hadis_session'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
                child: pw.Row(
                  children: [
                    buildInlineCell('মাসআলা-মাসায়েল শিক্ষা ক্লাস : সংখ্যা', g('train_masala_count'), unit: 'টি,'),
                    pw.SizedBox(width: 8),
                    buildInlineCell('অধিবেশন', g('train_masala_session'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
                child: pw.Row(
                  children: [
                    buildInlineCell('উন্মুক্ত ক্লাস : সংখ্যা', g('train_unmukto_count'), unit: 'টি,'),
                    pw.SizedBox(width: 8),
                    buildInlineCell('অধিবেশন', g('train_unmukto_session'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
                child: pw.Row(
                  children: [
                    buildInlineCell('স্পীকার্স / সাংস্কৃতিক ফোরাম : সংখ্যা', g('train_speakers_cultural_count'), unit: 'টি,'),
                    pw.SizedBox(width: 8),
                    buildInlineCell('অধিবেশন', g('train_speakers_cultural_session'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
                child: pw.Row(
                  children: [
                    buildInlineCell('পাঠাগার বৃদ্ধি', g('train_pathagar_growth'), unit: 'টি,'),
                    pw.SizedBox(width: 8),
                    buildInlineCell('বই বৃদ্ধি', g('train_pathagar_book_growth'), unit: 'টি'),
                  ],
                ),
              ),
              pw.SizedBox(height: 2),

              // 4. চতুর্থ দফা : আন্দোলন
              buildBadge('চতুর্থ দফা : আন্দোলন'),
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 1, bottom: 2),
                child: PdfExportService.bWidget('ছাত্রকল্যাণ', fontSize: 7.8, fontWeight: pw.FontWeight.bold, color: oceanCyan),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
                child: pw.Row(
                  children: [
                    buildInlineCell('যাকাত সংগ্রহ করা হবে', g('mov_zakat_target'), unit: 'টাকা |'),
                    pw.SizedBox(width: 8),
                    buildInlineCell('টেবিল ব্যাংক / কলসি বৃদ্ধি', g('mov_table_bank_growth'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('লজিং / টিউশনি সংগ্রহ ', fontSize: 7.2),
                    buildInlineCell('', g('mov_lodging')),
                    PdfExportService.bWidget(' / ', fontSize: 7.2),
                    buildInlineCell('', g('mov_tuition'), unit: 'টি |'),
                    pw.SizedBox(width: 8),
                    buildInlineCell('স্টাইপেন্ড বা বৃত্তি চালু', g('mov_stipend'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
                child: pw.Row(
                  children: [
                    buildInlineCell('আবাসনের ব্যবস্থা করা হবে', g('mov_housing'), unit: 'জন ছাত্রের |'),
                    pw.SizedBox(width: 8),
                    buildInlineCell('ফ্রি কোচিং', g('mov_free_coaching'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
                child: buildInlineCell('একাডেমিক / ভর্তি কোচিং', g('mov_academic_coaching'), unit: 'টি'),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('প্রশ্নপত্র / সাজেশন / নোট বিলি ', fontSize: 7.2),
                    buildInlineCell('', g('mov_question')),
                    PdfExportService.bWidget(' / ', fontSize: 7.2),
                    buildInlineCell('', g('mov_suggesion')),
                    PdfExportService.bWidget(' / ', fontSize: 7.2),
                    buildInlineCell('', g('mov_note'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
                child: pw.Row(
                  children: [
                    buildInlineCell('ল্যাঙ্গুয়েজ লাইব্রেরি প্রতিষ্ঠা', g('mov_lang_lib'), unit: 'টি,'),
                    pw.SizedBox(width: 8),
                    buildInlineCell('বই বৃদ্ধি', g('mov_lang_lib_books'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 0.7),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('ভর্তি গাইড প্রকাশ / সহযোগিতা ', fontSize: 7.2),
                    buildInlineCell('', g('mov_guide_pub')),
                    PdfExportService.bWidget(' / ', fontSize: 7.2),
                    buildInlineCell('', g('mov_guide_help'), unit: 'টি,'),
                    pw.SizedBox(width: 6),
                    buildInlineCell('ভর্তিকালীন সহযোগিতা করা হবে', g('mov_admission_help_students'), unit: 'জন'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 1, bottom: 2),
                child: PdfExportService.bWidget('(ছাত্রকল্যাণের আয়-ব্যয়ের বাজেট আলাদা কাগজে সংরক্ষণ করতে হবে)', fontSize: 6.5, color: PdfColors.grey700),
              ),
              pw.SizedBox(height: 2),

              // 5. সামাজিক খেদমত
              buildBadge('সামাজিক খেদমত'),
              pw.SizedBox(height: 1),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Left Column (6 items)
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        buildInlineCell('♦ গাছ লাগানো হবে', g('social_tree_count'), unit: 'টি'),
                        pw.SizedBox(height: 1.5),
                        PdfExportService.bWidget('♦ সাধারণ মানুষের জন্য বিশুদ্ধ কুরআন তিলাওয়াত শিক্ষার ব্যবস্থা করা হবে।', fontSize: 6.8),
                        pw.SizedBox(height: 1.5),
                        PdfExportService.bWidget('♦ খেদমতে খালকের ব্যাপারে জনশক্তিকে উদ্বুদ্ধ করা হবে।', fontSize: 6.8),
                        pw.SizedBox(height: 1.5),
                        PdfExportService.bWidget('♦ অন্নবস্ত্রদান কর্মসূচি পালন করা হবে।', fontSize: 6.8),
                        pw.SizedBox(height: 1.5),
                        PdfExportService.bWidget('♦ পরিষ্কার-পরিচ্ছন্নতা কার্যক্রমে অংশ নেয়া হবে।', fontSize: 6.8),
                        pw.SizedBox(height: 1.5),
                        PdfExportService.bWidget('♦ দুর্গম্য মুহূর্তে অসহায় মানুষের পাশে দাঁড়ানো হবে।', fontSize: 6.8),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  // Right Column (6 items)
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        buildInlineCell('♦ রক্তদান করা হবে', g('social_blood_count'), unit: 'ব্যাগ'),
                        pw.SizedBox(height: 1.5),
                        PdfExportService.bWidget('♦ মাদক, অশ্লীলতা, পর্নোগ্রাফি ও প্রযুক্তির অপব্যবহার রোধে জনসচেতনতা বৃদ্ধি করা হবে।', fontSize: 6.8),
                        pw.SizedBox(height: 1.5),
                        PdfExportService.bWidget('♦ সকল প্রকার জুলুম ও অন্যায়ের বিরুদ্ধে জনমত গড়ে তোলা হবে।', fontSize: 6.8),
                        pw.SizedBox(height: 1.5),
                        PdfExportService.bWidget('♦ খেলাফত মজলিসের কাজে সম্ভাব্য সহযোগিতা করা হবে।', fontSize: 6.8),
                        pw.SizedBox(height: 1.5),
                        PdfExportService.bWidget('♦ মোহাররমা আত্মীয়দের মাঝে দাওয়াতি কাজ করা হবে।', fontSize: 6.8),
                        pw.SizedBox(height: 1.5),
                        PdfExportService.bWidget('♦ ফ্রি রক্তদান, দন্ত ও চক্ষুসেবা কর্মসূচি পালন করা হবে।', fontSize: 6.8),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 3),

              // 6. বায়তুলমাল বাজেট (Table)
              buildBadge('বায়তুলমাল বাজেট'),
              pw.SizedBox(height: 2),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
                columnWidths: const {
                  0: pw.FixedColumnWidth(16), // ক্র
                  1: pw.FlexColumnWidth(1.6), // আয়ের উৎস
                  2: pw.FlexColumnWidth(1.0), // টাকা
                  3: pw.FixedColumnWidth(16), // ক্র
                  4: pw.FlexColumnWidth(1.6), // ব্যয়ের খাত
                  5: pw.FlexColumnWidth(1.0), // টাকা
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColor.fromHex('#E0F2FE')),
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('ক্র.', fontSize: 7, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('আয়ের উৎস', fontSize: 7, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('টাকা', fontSize: 7, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('ক্র.', fontSize: 7, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('ব্যয়ের খাত', fontSize: 7, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('টাকা', fontSize: 7, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                    ],
                  ),
                  // Row 01
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('০১', fontSize: 6.8, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('জনশক্তি ইয়ানত', fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_inc_1'), fontSize: 6.8, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('০১', fontSize: 6.8, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('ঊর্ধ্বতন ইয়ানত পরিশোধ', fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_exp_1'), fontSize: 6.8, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                    ],
                  ),
                  // Row 02
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('০২', fontSize: 6.8, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('শাখা ইয়ানত', fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_inc_2'), fontSize: 6.8, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('০২', fontSize: 6.8, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('ঊর্ধ্বতন সফর', fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_exp_2'), fontSize: 6.8, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                    ],
                  ),
                  // Row 03
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('০৩', fontSize: 6.8, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('শুভাকাঙ্ক্ষী ইয়ানত', fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_inc_3'), fontSize: 6.8, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('০৩', fontSize: 6.8, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('অফিস', fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_exp_3'), fontSize: 6.8, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                    ],
                  ),
                  // Row 04
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('০৪', fontSize: 6.8, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('এককালীন আয়', fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_inc_4'), fontSize: 6.8, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('০৪', fontSize: 6.8, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('যাতায়াত', fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_exp_4'), fontSize: 6.8, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                    ],
                  ),
                  // Row 05
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('০৫', fontSize: 6.8, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_inc_src_5'), fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_inc_5'), fontSize: 6.8, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('০৫', fontSize: 6.8, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('যোগাযোগ', fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_exp_5'), fontSize: 6.8, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                    ],
                  ),
                  // Row 06
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('০৬', fontSize: 6.8, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_inc_src_6'), fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_inc_6'), fontSize: 6.8, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('০৬', fontSize: 6.8, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('প্রচার', fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_exp_6'), fontSize: 6.8, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                    ],
                  ),
                  // Row 07
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('০৭', fontSize: 6.8, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_inc_src_7'), fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_inc_7'), fontSize: 6.8, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('০৭', fontSize: 6.8, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_exp_head_7'), fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(g('budget_exp_7'), fontSize: 6.8, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                    ],
                  ),
                  // Total Row
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColor.fromHex('#F1F5F9')),
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('', fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('মোট আয়', fontSize: 7, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(incTotalStr, fontSize: 7, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('', fontSize: 6.8)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget('মোট ব্যয়', fontSize: 7, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                      pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(expTotalStr, fontSize: 7, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                    ],
                  ),
                ],
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
        'পর্যায়ভিত্তিক পরিকল্পনা (২ পৃষ্ঠা)',
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
