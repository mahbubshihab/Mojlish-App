import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';

/// ছাত্র মজলিস বার্ষিক/ষান্মাসিক/দ্বি-মাসিক পরিকল্পনা (২ পৃষ্ঠা) PDF জেনারেটর সার্ভিস
class StudentPeriodPlanPdfService {
  static Future<Uint8List> generatePdfBytes({
    required String branch,
    required String month,
    required String session,
    Map<String, String>? formData,
  }) async {
    pw.Font fontRegular;
    pw.Font fontBold;

    try {
      fontRegular = await PdfGoogleFonts.notoSansBengaliRegular();
      fontBold = await PdfGoogleFonts.notoSansBengaliBold();
    } catch (_) {
      final fontData = await rootBundle.load('assets/fonts/kalpurush.ttf');
      fontRegular = pw.Font.ttf(fontData);
      fontBold = pw.Font.ttf(fontData);
    }

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

    final textStyleSmall = pw.TextStyle(font: fontRegular, fontSize: 7.5);
    final textStyleBoldSmall = pw.TextStyle(font: fontBold, fontSize: 7.5);
    const headerBlue = PdfColor.fromInt(0xFF1E3A8A);
    const sectionBg = PdfColor.fromInt(0xFF2563EB);

    pw.Widget buildBadge(String title) {
      return pw.Container(
        width: double.infinity,
        alignment: pw.Alignment.center,
        margin: const pw.EdgeInsets.symmetric(vertical: 2.5),
        padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: pw.BoxDecoration(
          color: sectionBg,
          borderRadius: pw.BorderRadius.circular(10),
        ),
        child: pw.Text(
          title,
          style: pw.TextStyle(font: fontBold, fontSize: 9.5, color: PdfColors.white),
        ),
      );
    }

    pw.Widget buildDottedRow(String label, String value, {String unit = '', String prefix = ''}) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 1),
        child: pw.Row(
          children: [
            if (prefix.isNotEmpty) ...[
              pw.Text(prefix, style: textStyleSmall),
              pw.SizedBox(width: 2),
            ],
            pw.Text(label, style: textStyleSmall),
            pw.SizedBox(width: 3),
            pw.Expanded(
              child: pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5)),
                ),
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  value.isEmpty ? '................................................' : value,
                  style: textStyleBoldSmall,
                  maxLines: 1,
                ),
              ),
            ),
            if (unit.isNotEmpty) ...[
              pw.SizedBox(width: 3),
              pw.Text(unit, style: textStyleSmall),
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
            pw.Text(prefix, style: textStyleSmall),
            pw.SizedBox(width: 1.5),
          ],
          if (label.isNotEmpty) ...[
            pw.Text(label, style: textStyleSmall),
            pw.SizedBox(width: 2),
          ],
          pw.Container(
            constraints: const pw.BoxConstraints(minWidth: 25),
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5)),
            ),
            alignment: pw.Alignment.center,
            child: pw.Text(
              value.isEmpty ? '.......' : value,
              style: textStyleBoldSmall,
            ),
          ),
          if (unit.isNotEmpty) ...[
            pw.SizedBox(width: 1.5),
            pw.Text(unit, style: textStyleSmall),
          ],
        ],
      );
    }

    pw.Widget buildFooter() {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        margin: const pw.EdgeInsets.only(top: 4),
        color: headerBlue,
        child: pw.Center(
          child: pw.Text(
            'www.chhatra-majlis.org.bd',
            style: pw.TextStyle(font: fontRegular, fontSize: 8, color: PdfColors.white),
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
              // Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('বিসমিল্লাহির রাহমানির রাহীম', style: pw.TextStyle(font: fontRegular, fontSize: 8.5)),
                    pw.SizedBox(height: 1),
                    pw.Text('বার্ষিক/ষান্মাসিক/দ্বি-মাসিক পরিকল্পনা', style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.grey900)),
                    pw.SizedBox(height: 1),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        if (logoImage != null) ...[
                          pw.Image(logoImage, width: 20, height: 20),
                          pw.SizedBox(width: 5),
                        ],
                        pw.Text('বাংলাদেশ ইসলামী ছাত্র মজলিস', style: pw.TextStyle(font: fontBold, fontSize: 16, color: headerBlue)),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 4),

              // Info Row
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400, width: 0.5)),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('শাখা: ${branch.isEmpty ? "........................" : branch}', style: textStyleBoldSmall),
                    pw.Text('মাস: ${month.isEmpty ? "........................" : month}', style: textStyleBoldSmall),
                    pw.Text('সেশন: ${session.isEmpty ? "........................" : session}', style: textStyleBoldSmall),
                  ],
                ),
              ),
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
                    pw.Text(' / ', style: textStyleSmall),
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
                    pw.Text('♦ লিফলেট / স্টিকার / পোস্টার লাগানো ', style: textStyleSmall),
                    buildInlineDottedCell('', g('dawa_leaflet')),
                    pw.Text(' / ', style: textStyleSmall),
                    buildInlineDottedCell('', g('dawa_stiker')),
                    pw.Text(' / ', style: textStyleSmall),
                    buildInlineDottedCell('', g('dawa_poster'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    pw.Text('♦ দেয়াল লিখন / দেয়ালিকা প্রকাশ / নবীন বরণ ', style: textStyleSmall),
                    buildInlineDottedCell('', g('dawa_deyal_likhon')),
                    pw.Text(' / ', style: textStyleSmall),
                    buildInlineDottedCell('', g('dawa_deyalika')),
                    pw.Text(' / ', style: textStyleSmall),
                    buildInlineDottedCell('', g('dawa_nobin_boron'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    pw.Text('♦ গ্রুপ দাওয়াত / চা চক্র / উন্মুক্ত আসর ', style: textStyleSmall),
                    buildInlineDottedCell('', g('dawa_group_dawa')),
                    pw.Text(' / ', style: textStyleSmall),
                    buildInlineDottedCell('', g('dawa_cha_chokro')),
                    pw.Text(' / ', style: textStyleSmall),
                    buildInlineDottedCell('', g('dawa_onmukto_asor'), unit: 'টি'),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    pw.Text('♦ বক্তৃতা / বিতর্ক / সাধারণ জ্ঞান প্রতিযোগিতা ', style: textStyleSmall),
                    buildInlineDottedCell('', g('dawa_boktita')),
                    pw.Text(' / ', style: textStyleSmall),
                    buildInlineDottedCell('', g('dawa_bitorko')),
                    pw.Text(' / ', style: textStyleSmall),
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
                    pw.Text('নাম : ', style: textStyleSmall),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: pw.Text(g('org_candidate_names').isEmpty ? '................................................' : g('org_candidate_names'), style: textStyleBoldSmall),
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
                    pw.Text('নাম : ', style: textStyleSmall),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: pw.Text(g('org_assoc_branch_names').isEmpty ? '................................' : g('org_assoc_branch_names'), style: textStyleBoldSmall),
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
                    pw.Text('নাম : ', style: textStyleSmall),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: pw.Text(g('org_zone_branch_names').isEmpty ? '................................' : g('org_zone_branch_names'), style: textStyleBoldSmall),
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
                    pw.Text('তারিখ : ', style: textStyleSmall),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: pw.Text(g('org_senior_visit_date').isEmpty ? '................................' : g('org_senior_visit_date'), style: textStyleBoldSmall),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. সভাসমূহ
              buildBadge('সভাসমূহ'),
              _buildMeetingRow('দায়িত্বশীল সভা', g('meet_daitoshil'), g('meet_daitoshil_date_time'), textStyleSmall, textStyleBoldSmall),
              _buildMeetingRow('জোনাল দায়িত্বশীল সভা', g('meet_zonal'), g('meet_zonal_date_time'), textStyleSmall, textStyleBoldSmall),
              _buildMeetingRow('সদস্য সভা', g('meet_member'), g('meet_member_date_time'), textStyleSmall, textStyleBoldSmall),
              _buildMeetingRow('সহযোগী সদস্য সভা', g('meet_assoc_member'), g('meet_assoc_member_date_time'), textStyleSmall, textStyleBoldSmall),
              _buildMeetingRow('কর্মী সভা', g('meet_worker'), g('meet_worker_date_time'), textStyleSmall, textStyleBoldSmall),
              _buildMeetingRow('সাধারণ সভা', g('meet_general'), g('meet_general_date_time'), textStyleSmall, textStyleBoldSmall),
              _buildMeetingRow('আলোচনা সভা', g('meet_discussion'), g('meet_discussion_date_time'), textStyleSmall, textStyleBoldSmall),
              buildDottedRow('অন্যান্য সভাসমূহ', g('meet_other')),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('বায়তুলমাল সংগ্রহ করা হবে', g('meet_baytulmal_target'), unit: 'টাকা'),
                    pw.SizedBox(width: 4),
                    pw.Text('(প্রতি মাসের আয়-ব্যয়ের বিস্তারিত বাজেট আলাদা কাগজে থাকবে।)', style: pw.TextStyle(font: fontRegular, fontSize: 6.5, color: PdfColors.grey700)),
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
              _buildTrainingTripleRow('কর্মশালা', g('train_workshop'), g('train_workshop_date'), g('train_workshop_time'), g('train_workshop_place'), textStyleSmall, textStyleBoldSmall),
              _buildTrainingTripleRow('শিক্ষা সভা', g('train_edu_meeting'), g('train_edu_meeting_date'), g('train_edu_meeting_time'), g('train_edu_meeting_place'), textStyleSmall, textStyleBoldSmall),
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
              _buildTrainingTripleRow('শবগুজারী', g('train_shobgujari'), g('train_shobgujari_date'), g('train_shobgujari_time'), g('train_shobgujari_place'), textStyleSmall, textStyleBoldSmall),
              _buildTrainingTripleRow('জিকির মাহফিল', g('train_zikir'), g('train_zikir_date'), g('train_zikir_time'), g('train_zikir_place'), textStyleSmall, textStyleBoldSmall),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  children: [
                    buildInlineDottedCell('প্রশিক্ষণ চক্র : সংখ্যা', g('train_cycle_count'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('অধিবেশন', g('train_cycle_session'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    pw.Text('তারিখ : ', style: textStyleSmall),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: pw.Text(g('train_cycle_date').isEmpty ? '............' : g('train_cycle_date'), style: textStyleBoldSmall),
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
                    pw.Text('তারিখ : ', style: textStyleSmall),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
                        child: pw.Text(g('train_skills_course_date').isEmpty ? '............' : g('train_skills_course_date'), style: textStyleBoldSmall),
                      ),
                    ),
                  ],
                ),
              ),
              _buildTrainingTripleRow('তারবিয়াতি সফর', g('train_tarbiyati_tour'), g('train_tarbiyati_tour_date'), g('train_tarbiyati_tour_time'), g('train_tarbiyati_tour_place'), textStyleSmall, textStyleBoldSmall),
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
                child: pw.Text('ছাত্রকল্যাণ', style: pw.TextStyle(font: fontBold, fontSize: 8, color: headerBlue)),
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
                    pw.Text('লজিং / টিউশনি সংগ্রহ ', style: textStyleSmall),
                    buildInlineDottedCell('', g('welfare_lodging')),
                    pw.Text(' / ', style: textStyleSmall),
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
                    pw.Text('প্রশ্নপত্র / সাজেশন / নোট বিলি ', style: textStyleSmall),
                    buildInlineDottedCell('', g('welfare_question_paper')),
                    pw.Text(' / ', style: textStyleSmall),
                    buildInlineDottedCell('', g('welfare_suggestion')),
                    pw.Text(' / ', style: textStyleSmall),
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
                    pw.Text('ভর্তি গাইড প্রকাশ / সহযোগিতা ', style: textStyleSmall),
                    buildInlineDottedCell('', g('welfare_admission_guide')),
                    pw.Text(' / ', style: textStyleSmall),
                    buildInlineDottedCell('', g('welfare_admission_help'), unit: 'টি,'),
                    pw.SizedBox(width: 4),
                    buildInlineDottedCell('ভর্তিকালীন সহযোগিতা করা হবে', g('welfare_admission_student_help'), unit: 'জনকে'),
                  ],
                ),
              ),
              pw.Center(
                child: pw.Text('(ছাত্রকল্যাণের আয়-ব্যয়ের বাজেট আলাদা কাগজে সংরক্ষণ করতে হবে)', style: pw.TextStyle(font: fontRegular, fontSize: 6.5, color: PdfColors.grey700)),
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
              _buildBulletItem('♦ সাধারণ মানুষের জন্য বিশুদ্ধ কুরআন তিলাওয়াত শিক্ষার ব্যবস্থা করা হবে।', textStyleSmall),
              _buildBulletItem('♦ মাদক, অশ্লীলতা, পর্নোগ্রাফি ও প্রযুক্তির অপব্যবহার রোধে জনসচেতনতা বৃদ্ধি করা হবে।', textStyleSmall),
              _buildBulletItem('♦ সকল প্রকার জুলুম ও অন্যায়ের বিরুদ্ধে জনমত গড়ে তোলা হবে।', textStyleSmall),
              _buildBulletItem('♦ খেলাফত মজলিসের কাজে সম্ভাব্য সহযোগিতা করা হবে।', textStyleSmall),
              _buildBulletItem('♦ মহররমা আত্মীয়াদের মাঝে দাওয়াতি কাজ করা হবে।', textStyleSmall),
              _buildBulletItem('♦ ফ্রি রক্তদান, দন্ত ও চক্ষুসেবা কর্মসূচি পালন করা হবে।', textStyleSmall),
              _buildBulletItem('♦ দুর্যোগময় মুহূর্তে অসহায় মানুষের পাশে দাঁড়ানো হবে।', textStyleSmall),

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
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('ক্র.', style: textStyleBoldSmall, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('আয়ের উৎস', style: textStyleBoldSmall, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('টাকা', style: textStyleBoldSmall, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('ক্র.', style: textStyleBoldSmall, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('ব্যয়ের খাত', style: textStyleBoldSmall, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('টাকা', style: textStyleBoldSmall, textAlign: pw.TextAlign.center)),
                    ],
                  ),
                  _buildBudgetFullRow('০১', 'জনশক্তি ইয়ানত', g('inc_1'), '০১', ' ঊর্ধ্বতন এয়ানত পরিশোধ', g('exp_1'), textStyleSmall),
                  _buildBudgetFullRow('০২', 'শাখা ইয়ানত', g('inc_2'), '০২', ' ঊর্ধ্বতন সফর', g('exp_2'), textStyleSmall),
                  _buildBudgetFullRow('০৩', 'শুভাকাঙ্ক্ষী ইয়ানত', g('inc_3'), '০৩', 'অফিস', g('exp_3'), textStyleSmall),
                  _buildBudgetFullRow('০৪', 'এককালীন আয়', g('inc_4'), '০৪', 'যাতায়াত', g('exp_4'), textStyleSmall),
                  _buildBudgetFullRow('০৫', 'অন্যান্য আয়', g('inc_5'), '০৫', 'যোগাযোগ', g('exp_5'), textStyleSmall),
                  _buildBudgetFullRow('০৬', '', g('inc_6'), '০৬', 'প্রচার', g('exp_6'), textStyleSmall),
                  _buildBudgetFullRow('০৭', '', g('inc_7'), '০৭', '', g('exp_7'), textStyleSmall),
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('', style: textStyleBoldSmall)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('মোট আয়', style: textStyleBoldSmall)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text(g('inc_total'), style: textStyleBoldSmall, textAlign: pw.TextAlign.right)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('', style: textStyleBoldSmall)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('মোট ব্যয়', style: textStyleBoldSmall)),
                      pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text(g('exp_total'), style: textStyleBoldSmall, textAlign: pw.TextAlign.right)),
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
  }) async {
    final pdfBytes = await generatePdfBytes(
      branch: branch,
      month: month,
      session: session,
      formData: formData,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'ছাত্র_মজলিস_পরিকল্পনা_${month}_$session.pdf',
    );
  }

  static pw.Widget _buildMeetingRow(String label, String count, String dateTime, pw.TextStyle labelStyle, pw.TextStyle valStyle) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        children: [
          pw.Text(label, style: labelStyle),
          pw.SizedBox(width: 3),
          pw.Container(
            constraints: const pw.BoxConstraints(minWidth: 25),
            decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
            alignment: pw.Alignment.center,
            child: pw.Text(count.isEmpty ? '.......' : count, style: valStyle),
          ),
          pw.Text(' টি, তারিখ ও সময় : ', style: labelStyle),
          pw.Expanded(
            child: pw.Container(
              decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
              child: pw.Text(dateTime.isEmpty ? '................................................' : dateTime, style: valStyle),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTrainingTripleRow(String label, String count, String date, String time, String place, pw.TextStyle labelStyle, pw.TextStyle valStyle) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        children: [
          pw.Text(label, style: labelStyle),
          pw.SizedBox(width: 3),
          pw.Container(
            constraints: const pw.BoxConstraints(minWidth: 20),
            decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
            alignment: pw.Alignment.center,
            child: pw.Text(count.isEmpty ? '.....' : count, style: valStyle),
          ),
          pw.Text(' টি, তারিখ : ', style: labelStyle),
          pw.Container(
            constraints: const pw.BoxConstraints(minWidth: 40),
            decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
            child: pw.Text(date.isEmpty ? '............' : date, style: valStyle),
          ),
          pw.Text(' সময় : ', style: labelStyle),
          pw.Container(
            constraints: const pw.BoxConstraints(minWidth: 35),
            decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
            child: pw.Text(time.isEmpty ? '..........' : time, style: valStyle),
          ),
          pw.Text(' স্থান : ', style: labelStyle),
          pw.Expanded(
            child: pw.Container(
              decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
              child: pw.Text(place.isEmpty ? '................' : place, style: valStyle),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildBulletItem(String text, pw.TextStyle style) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
      child: pw.Text(text, style: style),
    );
  }

  static pw.TableRow _buildBudgetFullRow(String incNo, String incName, String incVal, String expNo, String expName, String expVal, pw.TextStyle style) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(incNo, style: style, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(incName, style: style)),
        pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(incVal, style: style, textAlign: pw.TextAlign.right)),
        pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(expNo, style: style, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(expName, style: style)),
        pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(expVal, style: style, textAlign: pw.TextAlign.right)),
      ],
    );
  }
}
