import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/pdf_preview_screen.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস — বার্ষিক/ষান্মাসিক/দ্বি-মাসিক পর্যায়ভিত্তিক পরিকল্পনা (২ পৃষ্ঠা) PDF জেনারেটর সার্ভিস
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
            fontSize: 8.5,
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 2),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: pw.BoxDecoration(
              color: oceanCyan,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                if (logoImage != null) ...[
                  pw.Image(logoImage, width: 26, height: 26),
                  pw.SizedBox(width: 8),
                ],
                pw.Column(
                  children: [
                    PdfExportService.bWidget(
                      'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 1),
                    PdfExportService.bWidget(
                      'বার্ষিক/ষান্মাসিক/দ্বি-মাসিক পরিকল্পনা',
                      fontSize: 10,
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
        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
        decoration: pw.BoxDecoration(
          color: PdfColor.fromHex('#F0F9FF'),
          border: pw.Border.all(color: oceanCyan, width: 0.8),
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            PdfExportService.bWidget(
              'শাখা: ${branch.isEmpty ? "........................" : branch}',
              fontSize: 8.5,
              fontWeight: pw.FontWeight.bold,
              color: oceanCyan,
            ),
            PdfExportService.bWidget(
              'মাস: ${month.isEmpty ? "........................" : month}',
              fontSize: 8.5,
              fontWeight: pw.FontWeight.bold,
              color: oceanCyan,
            ),
            PdfExportService.bWidget(
              'সেশন: ${session.isEmpty ? "........................" : session}',
              fontSize: 8.5,
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
        margin: const pw.EdgeInsets.symmetric(vertical: 2.5),
        padding: const pw.EdgeInsets.symmetric(vertical: 2.5, horizontal: 8),
        decoration: pw.BoxDecoration(
          color: oceanCyan,
          borderRadius: pw.BorderRadius.circular(10),
        ),
        child: PdfExportService.bWidget(
          title,
          fontSize: 9.5,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      );
    }

    pw.Widget buildDottedRow(String label, String value, {String unit = '', String prefix = ''}) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 1),
        child: pw.Row(
          children: [
            if (prefix.isNotEmpty) ...[
              PdfExportService.bWidget(prefix, fontSize: 7.5),
              pw.SizedBox(width: 2),
            ],
            PdfExportService.bWidget(label, fontSize: 7.5),
            pw.SizedBox(width: 3),
            pw.Expanded(
              child: pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5)),
                ),
                alignment: pw.Alignment.centerLeft,
                child: PdfExportService.bWidget(
                  value.isEmpty ? '................................................' : value,
                  fontSize: 7.5,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            if (unit.isNotEmpty) ...[
              pw.SizedBox(width: 3),
              PdfExportService.bWidget(unit, fontSize: 7.5),
            ],
          ],
        ),
      );
    }

    pw.Widget buildInlineDottedCell(String label, String value, {String unit = '', String prefix = ''}) {
      return pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          if (prefix.isNotEmpty) ...[
            PdfExportService.bWidget(prefix, fontSize: 7.5),
            pw.SizedBox(width: 1.5),
          ],
          if (label.isNotEmpty) ...[
            PdfExportService.bWidget(label, fontSize: 7.5),
            pw.SizedBox(width: 2),
          ],
          pw.Container(
            constraints: const pw.BoxConstraints(minWidth: 25),
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5)),
            ),
            alignment: pw.Alignment.center,
            child: PdfExportService.bWidget(
              value.isEmpty ? '.......' : value,
              fontSize: 7.5,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          if (unit.isNotEmpty) ...[
            pw.SizedBox(width: 1.5),
            PdfExportService.bWidget(unit, fontSize: 7.5),
          ],
        ],
      );
    }

    pw.Widget buildFooter() {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(vertical: 2.5),
        margin: const pw.EdgeInsets.only(top: 4),
        decoration: pw.BoxDecoration(
          color: oceanCyan,
          borderRadius: pw.BorderRadius.circular(3),
        ),
        child: pw.Center(
          child: pw.Text(
            'www.chhatra-majlis.org.bd',
            style: pw.TextStyle(
              fontSize: 8,
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // --- PAGE 1 ---
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Top Header Ribbon
              buildHeaderRibbon(),
              pw.SizedBox(height: 4),

              // Metadata Bar
              buildMetadataBar(),
              pw.SizedBox(height: 2),

              // 1. প্রথম দফা : দাওয়াত
              buildBadge('প্রথম দফা : দাওয়াত'),
              buildDottedRow('বন্ধু বৃদ্ধি', g('dawa_bondhu'), unit: 'জন'),
              buildDottedRow('প্রাথমিক সদস্য বৃদ্ধি', g('dawa_primary_member'), unit: 'জন'),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('ক. স্কুল : সরকারি', g('dawa_school_govt'), unit: 'জন,'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('বেসরকারি', g('dawa_school_non_govt'), unit: 'জন,'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('খ. কলেজ', g('dawa_college'), unit: 'জন'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('গ. মাদ্রাসা : আলিয়া', g('dawa_madrasa_alia'), unit: 'জন,'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('কওমী', g('dawa_madrasa_qawmi'), unit: 'জন,'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('ঘ. বিশ্ববিদ্যালয়', g('dawa_university'), unit: 'জন'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('শুভাকাঙ্ক্ষী বৃদ্ধি / যোগাযোগ', g('dawa_shuvakangkhi_growth')),
                    PdfExportService.bWidget(' / ', fontSize: 7.5),
                    buildInlineDottedCell('', g('dawa_shuvakangkhi_contact'), unit: 'জন'),
                  ],
                ),
              ),
              buildDottedRow('পরিচিতি / ইসলামী সাহিত্য বিতরণ', g('dawa_sahitya'), unit: 'টি', prefix: '♦ '),
              buildDottedRow('ছাত্র পরিক্রমা / কিশোর পত্রিকা বিতরণ', g('dawa_patrika'), unit: 'টি', prefix: '♦ '),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('♦ লিফলেট / স্টিকার / পোস্টার লাগানো ', fontSize: 7.5),
                    buildInlineDottedCell('', g('dawa_leaflet')),
                    PdfExportService.bWidget(' / ', fontSize: 7.5),
                    buildInlineDottedCell('', g('dawa_stiker')),
                    PdfExportService.bWidget(' / ', fontSize: 7.5),
                    buildInlineDottedCell('', g('dawa_poster'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('♦ দেয়াল লিখন / দেয়ালিকা প্রকাশ / নবীন বরণ ', fontSize: 7.5),
                    buildInlineDottedCell('', g('dawa_deyal_likhon')),
                    PdfExportService.bWidget(' / ', fontSize: 7.5),
                    buildInlineDottedCell('', g('dawa_deyalika')),
                    PdfExportService.bWidget(' / ', fontSize: 7.5),
                    buildInlineDottedCell('', g('dawa_nobin_boron'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('♦ গ্রুপ দাওয়াত / চা চক্র / উন্মুক্ত আসর ', fontSize: 7.5),
                    buildInlineDottedCell('', g('dawa_group_dawa')),
                    PdfExportService.bWidget(' / ', fontSize: 7.5),
                    buildInlineDottedCell('', g('dawa_cha_chokro')),
                    PdfExportService.bWidget(' / ', fontSize: 7.5),
                    buildInlineDottedCell('', g('dawa_onmukto_asor'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('♦ বক্তৃতা / বিতর্ক / সাধারণ জ্ঞান প্রতিযোগিতা ', fontSize: 7.5),
                    buildInlineDottedCell('', g('dawa_boktita')),
                    PdfExportService.bWidget(' / ', fontSize: 7.5),
                    buildInlineDottedCell('', g('dawa_bitorko')),
                    PdfExportService.bWidget(' / ', fontSize: 7.5),
                    buildInlineDottedCell('', g('dawa_giyan_proti'), unit: 'টি'),
                  ],
                ),
              ),
              buildDottedRow('অন্যান্য দাওয়াতি কার্যক্রম', g('dawa_other'), prefix: '♦ '),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('কাজ বৃদ্ধি : প্রাতিষ্ঠানিক', g('dawa_work_inst'), unit: 'টি,'),
                    pw.SizedBox(width: 6),
                    buildInlineDottedCell('আবাসিক', g('dawa_work_res'), unit: 'টি'),
                  ],
                ),
              ),
              buildDottedRow('   নাম :', g('dawa_work_names')),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('প্রাথমিক শাখা বৃদ্ধি : প্রাতিষ্ঠানিক', g('dawa_branch_inst'), unit: 'টি,'),
                    pw.SizedBox(width: 6),
                    buildInlineDottedCell('আবাসিক', g('dawa_branch_res'), unit: 'টি'),
                  ],
                ),
              ),
              buildDottedRow('   নাম :', g('dawa_branch_names')),

              // 2. দ্বিতীয় দফা : সংগঠন
              buildBadge('দ্বিতীয় দফা : সংগঠন'),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('সহযোগী সদস্য প্রার্থী টার্গেট', g('org_candidate_target'), unit: 'জন |'),
                    pw.SizedBox(width: 4),
                    PdfExportService.bWidget('নাম : ', fontSize: 7.5),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: PdfExportService.bWidget(g('org_candidate_names').isEmpty ? '................................................' : g('org_candidate_names'), fontSize: 7.5, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              buildDottedRow('কর্মী বৃদ্ধি', g('org_worker_growth'), unit: 'জন'),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('ক. স্কুল : সরকারি', g('org_school_govt'), unit: 'জন,'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('বেসরকারি', g('org_school_non_govt'), unit: 'জন |'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('খ. কলেজ', g('org_college'), unit: 'জন'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('গ. মাদ্রাসা : আলিয়া', g('org_madrasa_alia'), unit: 'জন,'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('কওমী', g('org_madrasa_qawmi'), unit: 'জন |'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('ঘ. বিশ্ববিদ্যালয়', g('org_university'), unit: 'জন'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('সহযোগী সদস্য শাখা বৃদ্ধি', g('org_assoc_branch_growth'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    PdfExportService.bWidget('নাম : ', fontSize: 7.5),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: PdfExportService.bWidget(g('org_assoc_branch_names').isEmpty ? '................................' : g('org_assoc_branch_names'), fontSize: 7.5, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('থানা / জোন শাখা বৃদ্ধি', g('org_zone_branch_growth'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    PdfExportService.bWidget('নাম : ', fontSize: 7.5),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: PdfExportService.bWidget(g('org_zone_branch_names').isEmpty ? '................................' : g('org_zone_branch_names'), fontSize: 7.5, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('কর্মী শাখা বৃদ্ধি', g('org_worker_branch_growth'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('প্রাতিষ্ঠানিক', g('org_worker_branch_inst'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('আবাসিক', g('org_worker_branch_res'), unit: 'টি'),
                  ],
                ),
              ),
              buildDottedRow('   নাম :', g('org_worker_branch_names')),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('উর্ধ্বতন সফর আনা হবে', g('org_senior_visit'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    PdfExportService.bWidget('তারিখ : ', fontSize: 7.5),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: PdfExportService.bWidget(g('org_senior_visit_date').isEmpty ? '................................' : g('org_senior_visit_date'), fontSize: 7.5, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. সভাসমূহ
              buildBadge('সভাসমূহ'),
              _buildMeetingRow('দায়িত্বশীল সভা', g('meet_daitoshil'), g('meet_daitoshil_date_time')),
              _buildMeetingRow('জোনাল দায়িত্বশীল সভা', g('meet_zonal'), g('meet_zonal_date_time')),
              _buildMeetingRow('সদস্য সভা', g('meet_member'), g('meet_member_date_time')),
              _buildMeetingRow('সহযোগী সদস্য সভা', g('meet_assoc_member'), g('meet_assoc_member_date_time')),
              _buildMeetingRow('কর্মী সভা', g('meet_worker'), g('meet_worker_date_time')),
              _buildMeetingRow('সাধারণ সভা', g('meet_general'), g('meet_general_date_time')),
              _buildMeetingRow('আলোচনা সভা', g('meet_discussion'), g('meet_discussion_date_time')),
              buildDottedRow('অন্যান্য সভাসমূহ', g('meet_other')),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('বায়তুলমাল সংগ্রহ করা হবে', g('meet_baytulmal_target'), unit: 'টাকা'),
                    pw.SizedBox(width: 4),
                    PdfExportService.bWidget('(প্রতি মাসের আয়-ব্যয়ের বিস্তারিত বাজেট আলাদা কাগজে থাকবে।)', fontSize: 6.5, color: PdfColors.grey700),
                  ],
                ),
              ),

              pw.SizedBox(height: 6),
              buildFooter(),
            ],
          );
        },
      ),
    );

    // --- PAGE 2 ---
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 4. তৃতীয় দফা : প্রশিক্ষণ
              buildBadge('তৃতীয় দফা : প্রশিক্ষণ'),
              _buildTrainingTripleRow('কর্মশালা', g('train_workshop'), g('train_workshop_date'), g('train_workshop_time'), g('train_workshop_place')),
              _buildTrainingTripleRow('শিক্ষা সভা', g('train_edu_meeting'), g('train_edu_meeting_date'), g('train_edu_meeting_time'), g('train_edu_meeting_place')),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('সমষ্টিগত অধ্যয়ন : সংখ্যা', g('train_group_study_count'), unit: 'টি,'),
                    pw.SizedBox(width: 10),
                    buildInlineDottedCell('অধিবেশন', g('train_group_study_session'), unit: 'টি'),
                  ],
                ),
              ),
              _buildTrainingTripleRow('শবগুজারী', g('train_shobgujari'), g('train_shobgujari_date'), g('train_shobgujari_time'), g('train_shobgujari_place')),
              _buildTrainingTripleRow('জিকির মাহফিল', g('train_zikir'), g('train_zikir_date'), g('train_zikir_time'), g('train_zikir_place')),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('প্রশিক্ষণ চক্র : সংখ্যা', g('train_cycle_count'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('অধিবেশন', g('train_cycle_session'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    PdfExportService.bWidget('তারিখ : ', fontSize: 7.5),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: PdfExportService.bWidget(g('train_cycle_date').isEmpty ? '............' : g('train_cycle_date'), fontSize: 7.5, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('স্কিলস ডেভেলপমেন্ট কোর্স সংখ্যা', g('train_skills_course_count'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('অধিবেশন', g('train_skills_course_session'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    PdfExportService.bWidget('তারিখ : ', fontSize: 7.5),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: PdfExportService.bWidget(g('train_skills_course_date').isEmpty ? '............' : g('train_skills_course_date'), fontSize: 7.5, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              _buildTrainingTripleRow('তারবিয়াতি সফর', g('train_tarbiyati_tour'), g('train_tarbiyati_tour_date'), g('train_tarbiyati_tour_time'), g('train_tarbiyati_tour_place')),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('কুরআন ও হাদিস শিক্ষা ক্লাস : সংখ্যা', g('train_quran_hadith_count'), unit: 'টি,'),
                    pw.SizedBox(width: 10),
                    buildInlineDottedCell('অধিবেশন', g('train_quran_hadith_session'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('মাসআলা-মাসায়েল শিক্ষা ক্লাস : সংখ্যা', g('train_masala_count'), unit: 'টি,'),
                    pw.SizedBox(width: 10),
                    buildInlineDottedCell('অধিবেশন', g('train_masala_session'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('উন্মুক্ত ক্লাস : সংখ্যা', g('train_open_class_count'), unit: 'টি,'),
                    pw.SizedBox(width: 10),
                    buildInlineDottedCell('অধিবেশন', g('train_open_class_session'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('স্পীকার্স / সাংস্কৃতিক ফোরাম : সংখ্যা', g('train_speakers_count'), unit: 'টি,'),
                    pw.SizedBox(width: 10),
                    buildInlineDottedCell('অধিবেশন', g('train_speakers_session'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('পাঠাগার বৃদ্ধি', g('train_library_growth'), unit: 'টি,'),
                    pw.SizedBox(width: 10),
                    buildInlineDottedCell('বই বৃদ্ধি', g('train_book_growth'), unit: 'টি'),
                  ],
                ),
              ),

              // 5. চতুর্থ দফা : আন্দোলন
              buildBadge('চতুর্থ দফা : আন্দোলন'),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: PdfExportService.bWidget('ছাত্রকল্যাণ', fontSize: 8, fontWeight: pw.FontWeight.bold, color: oceanCyan),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('যাকাত সংগ্রহ করা হবে', g('welfare_zakat'), unit: 'টাকা |'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('টেবিল ব্যাংক / কলসি বৃদ্ধি', g('welfare_table_bank'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('লজিং / টিউশনি সংগ্রহ ', fontSize: 7.5),
                    buildInlineDottedCell('', g('welfare_lodging')),
                    PdfExportService.bWidget(' / ', fontSize: 7.5),
                    buildInlineDottedCell('', g('welfare_tuition'), unit: 'টি |'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('স্টাইপেন্ড বা বৃত্তি চালু', g('welfare_stipend'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('আবাসনের ব্যবস্থা করা হবে', g('welfare_accommodation'), unit: 'জন ছাত্রের |'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('ফ্রি কোচিং', g('welfare_free_coaching'), unit: 'টি'),
                  ],
                ),
              ),
              buildDottedRow('একাডেমিক / ভর্তি কোচিং', g('welfare_coaching'), unit: 'টি'),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('প্রশ্নপত্র / সাজেশন / নোট বিলি ', fontSize: 7.5),
                    buildInlineDottedCell('', g('welfare_question_paper')),
                    PdfExportService.bWidget(' / ', fontSize: 7.5),
                    buildInlineDottedCell('', g('welfare_suggestion')),
                    PdfExportService.bWidget(' / ', fontSize: 7.5),
                    buildInlineDottedCell('', g('welfare_note'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('লাইভ লাইব্রেরী প্রতিষ্ঠা', g('welfare_live_library'), unit: 'টি,'),
                    pw.SizedBox(width: 6),
                    buildInlineDottedCell('বই বৃদ্ধি', g('welfare_live_library_book'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('ভর্তি গাইড প্রকাশ / সহযোগিতা ', fontSize: 7.5),
                    buildInlineDottedCell('', g('welfare_admission_guide')),
                    PdfExportService.bWidget(' / ', fontSize: 7.5),
                    buildInlineDottedCell('', g('welfare_admission_help'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('ভর্তিকালীন সহযোগিতা করা হবে', g('welfare_admission_student_help'), unit: 'জনকে'),
                  ],
                ),
              ),
              pw.Center(
                child: PdfExportService.bWidget('(ছাত্রকল্যাণের আয়-ব্যয়ের বাজেট আলাদা কাগজে সংরক্ষণ করতে হবে)', fontSize: 6.5, color: PdfColors.grey700),
              ),

              // 6. সামাজিক খেদমত
              buildBadge('সামাজিক খেদমত'),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('♦ গাছ লাগানো হবে', g('social_tree'), unit: 'টি |'),
                    pw.SizedBox(width: 6),
                    buildInlineDottedCell('♦ রক্তদান করা হবে', g('social_blood'), unit: 'ব্যাগ'),
                  ],
                ),
              ),
              _buildBulletItem('♦ সাধারণ মানুষের জন্য বিশুদ্ধ কুরআন তিলাওয়াত শিক্ষার ব্যবস্থা করা হবে।'),
              _buildBulletItem('♦ মাদক, অশ্লীলতা, পর্নোগ্রাফি ও প্রযুক্তির অপব্যবহার রোধে জনসচেতনতা বৃদ্ধি করা হবে।'),
              _buildBulletItem('♦ সকল প্রকার জুলুম ও অন্যায়ের বিরুদ্ধে জনমত গড়ে তোলা হবে।'),
              _buildBulletItem('♦ খেলাফত মজলিসের কাজে সম্ভাব্য সহযোগিতা করা হবে।'),
              _buildBulletItem('♦ মহররমা আত্মীয়াদের মাঝে দাওয়াতি কাজ করা হবে।'),
              _buildBulletItem('♦ ফ্রি রক্তদান, দন্ত ও চক্ষুসেবা কর্মসূচি পালন করা হবে।'),
              _buildBulletItem('♦ দুর্যোগময় মুহূর্তে অসহায় মানুষের পাশে দাঁড়ানো হবে।'),

              // 7. বায়তুলমাল বাজেট
              buildBadge('বায়তুলমাল বাজেট'),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(0.6),
                  1: pw.FlexColumnWidth(3.0),
                  2: pw.FlexColumnWidth(1.8),
                  3: pw.FlexColumnWidth(0.6),
                  4: pw.FlexColumnWidth(3.0),
                  5: pw.FlexColumnWidth(1.8),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('ক্র.', fontSize: 7.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('আয়ের উৎস', fontSize: 7.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('টাকা', fontSize: 7.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('ক্র.', fontSize: 7.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('ব্যয়ের খাত', fontSize: 7.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('টাকা', fontSize: 7.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center)),
                    ],
                  ),
                  _buildBudgetFullRow('০১', 'জনশক্তি ইয়ানত', g('inc_1'), '০১', ' ঊর্ধ্বতন এয়ানত পরিশোধ', g('exp_1')),
                  _buildBudgetFullRow('০২', 'শাখা ইয়ানত', g('inc_2'), '০২', ' ঊর্ধ্বতন সফর', g('exp_2')),
                  _buildBudgetFullRow('০৩', 'শুভাকাঙ্ক্ষী ইয়ানত', g('inc_3'), '০৩', 'অফিস', g('exp_3')),
                  _buildBudgetFullRow('০৪', 'এককালীন আয়', g('inc_4'), '০৪', 'যাতায়াত', g('exp_4')),
                  _buildBudgetFullRow('০৫', 'অন্যান্য আয়', g('inc_5'), '০৫', 'যোগাযোগ', g('exp_5')),
                  _buildBudgetFullRow('০৬', '', g('inc_6'), '০৬', 'প্রচার', g('exp_6')),
                  _buildBudgetFullRow('০৭', '', g('inc_7'), '০৭', '', g('exp_7')),
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('', fontSize: 7.5)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('মোট আয়', fontSize: 7.5, fontWeight: pw.FontWeight.bold)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget(g('inc_total'), fontSize: 7.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('', fontSize: 7.5)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget('মোট ব্যয়', fontSize: 7.5, fontWeight: pw.FontWeight.bold)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: PdfExportService.bWidget(g('exp_total'), fontSize: 7.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.right)),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 6),
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

  static pw.Widget _buildMeetingRow(String label, String count, String dateTime) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        children: [
          PdfExportService.bWidget(label, fontSize: 7.5),
          pw.SizedBox(width: 3),
          pw.Container(
            constraints: const pw.BoxConstraints(minWidth: 25),
            decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
            alignment: pw.Alignment.center,
            child: PdfExportService.bWidget(count.isEmpty ? '.......' : count, fontSize: 7.5, fontWeight: pw.FontWeight.bold),
          ),
          PdfExportService.bWidget(' টি, তারিখ ও সময় : ', fontSize: 7.5),
          pw.Expanded(
            child: pw.Container(
              decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
              child: PdfExportService.bWidget(dateTime.isEmpty ? '................................................' : dateTime, fontSize: 7.5, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTrainingTripleRow(String label, String count, String date, String time, String place) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        children: [
          PdfExportService.bWidget(label, fontSize: 7.5),
          pw.SizedBox(width: 3),
          pw.Container(
            constraints: const pw.BoxConstraints(minWidth: 20),
            decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
            alignment: pw.Alignment.center,
            child: PdfExportService.bWidget(count.isEmpty ? '.....' : count, fontSize: 7.5, fontWeight: pw.FontWeight.bold),
          ),
          PdfExportService.bWidget(' টি, তারিখ : ', fontSize: 7.5),
          pw.Container(
            constraints: const pw.BoxConstraints(minWidth: 40),
            decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
            child: PdfExportService.bWidget(date.isEmpty ? '............' : date, fontSize: 7.5, fontWeight: pw.FontWeight.bold),
          ),
          PdfExportService.bWidget(' সময় : ', fontSize: 7.5),
          pw.Container(
            constraints: const pw.BoxConstraints(minWidth: 35),
            decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
            child: PdfExportService.bWidget(time.isEmpty ? '..........' : time, fontSize: 7.5, fontWeight: pw.FontWeight.bold),
          ),
          PdfExportService.bWidget(' স্থান : ', fontSize: 7.5),
          pw.Expanded(
            child: pw.Container(
              decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
              child: PdfExportService.bWidget(place.isEmpty ? '................' : place, fontSize: 7.5, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildBulletItem(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
      child: PdfExportService.bWidget(text, fontSize: 7.5),
    );
  }

  static pw.TableRow _buildBudgetFullRow(String incNo, String incName, String incVal, String expNo, String expName, String expVal) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(incNo, fontSize: 7.5, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(incName, fontSize: 7.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(incVal, fontSize: 7.5, textAlign: pw.TextAlign.right)),
        pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(expNo, fontSize: 7.5, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(expName, fontSize: 7.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: PdfExportService.bWidget(expVal, fontSize: 7.5, textAlign: pw.TextAlign.right)),
      ],
    );
  }
}
