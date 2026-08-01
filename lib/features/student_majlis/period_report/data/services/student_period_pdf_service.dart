import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/pdf_preview_screen.dart';
import '../models/period_report_model.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট (১ পৃষ্ঠা) PDF জেনারেটর সার্ভিস
/// বিজয় এনকোডিং (SutonnyMJ ফন্ট) ও রয়াল ব্লু গ্রাফিক্স ডিজাইনে সাজানো
class StudentPeriodPdfService {
  static Future<Uint8List> generatePdfBytes({
    String branch = '',
    String month = '',
    String session = '',
    String? shakhaName,
    String? periodName,
    Map<String, dynamic>? data,
    Map<String, String>? formData,
    PeriodReportModel? report,
  }) async {
    final effectiveBranch = (shakhaName != null && shakhaName.isNotEmpty) ? shakhaName : branch;
    final effectiveMonth = month;
    final effectiveSession = (periodName != null && periodName.isNotEmpty) ? periodName : session;
    final fontRegular = await PdfExportService.loadSutonnyFont();
    final fontBold = await PdfExportService.loadBengaliBoldFont();

    final mapData = <String, String>{};
    if (data != null) {
      data.forEach((k, v) => mapData[k] = v.toString());
    }
    if (report != null) {
      mapData['branch'] = report.branch;
      mapData['month'] = report.month;
      mapData['session'] = report.session;
      mapData['mp_member_count'] = '${report.manpower.members}';
      mapData['mp_cand_member_count'] = '${report.manpower.candidateMembers}';
      mapData['mp_assoc_member_count'] = '${report.manpower.associateMembers}';
      mapData['mp_cand_assoc_member_count'] = '${report.manpower.candidateAssociateMembers}';
      mapData['mp_worker_count'] = '${report.manpower.workers}';
      mapData['dw_primary_count'] = '${report.dawah.primaryMembers}';
      mapData['dw_friend_count'] = '${report.dawah.friends}';
      mapData['dw_wellwisher_count'] = '${report.dawah.wellWishers}';
      mapData['org_public_uni'] = '${report.organization.publicUniversities}';
      mapData['org_private_uni'] = '${report.organization.privateUniversities}';
      mapData['org_college_govt'] = '${report.organization.colleges}';
      mapData['org_madrasa_kamil'] = '${report.organization.madrasas}';
      mapData['org_school_govt'] = '${report.organization.schools}';
    }

    if (formData != null) {
      mapData.addAll(formData);
    }

    String g(String key) => mapData[key] ?? '';

    pw.MemoryImage? logoImage;
    try {
      final ByteData logoBytes = await rootBundle.load(MajlisAssets.chatroLogo);
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (_) {
      try {
        final ByteData defaultBytes = await rootBundle.load('assets/images/logo.png');
        logoImage = pw.MemoryImage(defaultBytes.buffer.asUint8List());
      } catch (_) {}
    }

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: fontRegular,
        bold: fontBold,
      ),
    );

    final royalBlue = PdfColor.fromHex('#2563EB');
    const tableBorderColor = PdfColors.black;

    pw.Widget cellText(
      String text, {
      bool isBold = false,
      pw.TextAlign align = pw.TextAlign.center,
      double size = 6.8,
      PdfColor color = PdfColors.black,
    }) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1.2),
        child: PdfExportService.bWidget(
          text,
          fontSize: size,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          textAlign: align,
          color: color,
        ),
      );
    }

    final branchVal = effectiveBranch.isEmpty ? g("branch") : effectiveBranch;
    final monthVal = effectiveMonth.isEmpty ? g("month") : effectiveMonth;
    final sessionVal = effectiveSession.isEmpty ? g("session") : effectiveSession;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // 1. Header Area
              PdfExportService.bWidget(
                'বিসমিল্লাহির রাহমানির রাহীম',
                fontSize: 8.0,
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 1),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: royalBlue, width: 0.8),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: PdfExportService.bWidget(
                  'বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট',
                  fontSize: 8.5,
                  fontWeight: pw.FontWeight.bold,
                  color: royalBlue,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  if (logoImage != null) ...[
                    pw.Image(logoImage, width: 22, height: 22),
                    pw.SizedBox(width: 6),
                  ],
                  PdfExportService.bWidget(
                    'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: royalBlue,
                  ),
                ],
              ),
              pw.SizedBox(height: 2),
              // Metadata Row Box
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: tableBorderColor, width: 0.6),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    PdfExportService.bWidget(
                      'শাখা : ${branchVal.isEmpty ? "........................" : branchVal}',
                      fontSize: 8.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    PdfExportService.bWidget(
                      'মাস : ${monthVal.isEmpty ? "........................" : monthVal}',
                      fontSize: 8.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    PdfExportService.bWidget(
                      'সেশন : ${sessionVal.isEmpty ? "........................" : sessionVal}',
                      fontSize: 8.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 3),

              // TABLE 1: "জনশক্তি"
              pw.Table(
                border: pw.TableBorder.all(color: tableBorderColor, width: 0.5),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2.2),
                  1: pw.FlexColumnWidth(1.2),
                  2: pw.FlexColumnWidth(1.2),
                  3: pw.FlexColumnWidth(1.6),
                  4: pw.FlexColumnWidth(1.2),
                  5: pw.FlexColumnWidth(1.2),
                  6: pw.FlexColumnWidth(2.0),
                },
                children: [
                  pw.TableRow(
                    children: [
                      cellText('জনশক্তি', isBold: true),
                      cellText('সংখ্যা', isBold: true),
                      cellText('বৃদ্ধি', isBold: true),
                      cellText('কীভাবে', isBold: true),
                      cellText('টার্গেট', isBold: true),
                      cellText('ঘাটতি', isBold: true),
                      cellText('কারণ', isBold: true),
                    ],
                  ),
                  pw.TableRow(children: [
                    cellText('সদস্য', align: pw.TextAlign.left),
                    cellText(g('mp_member_count')),
                    cellText(g('mp_member_growth')),
                    cellText(g('mp_member_how')),
                    cellText(g('mp_member_target')),
                    cellText(g('mp_member_shortage')),
                    cellText(g('mp_member_reason')),
                  ]),
                  pw.TableRow(children: [
                    cellText('সদস্য প্রার্থী', align: pw.TextAlign.left),
                    cellText(g('mp_cand_member_count')),
                    cellText(g('mp_cand_member_growth')),
                    cellText(g('mp_cand_member_how')),
                    cellText(g('mp_cand_member_target')),
                    cellText(g('mp_cand_member_shortage')),
                    cellText(g('mp_cand_member_reason')),
                  ]),
                  pw.TableRow(children: [
                    cellText('সহযোগী সদস্য', align: pw.TextAlign.left),
                    cellText(g('mp_assoc_member_count')),
                    cellText(g('mp_assoc_member_growth')),
                    cellText(g('mp_assoc_member_how')),
                    cellText(g('mp_assoc_member_target')),
                    cellText(g('mp_assoc_member_shortage')),
                    cellText(g('mp_assoc_member_reason')),
                  ]),
                  pw.TableRow(children: [
                    cellText('সহযোগী সদস্য প্রার্থী', align: pw.TextAlign.left),
                    cellText(g('mp_cand_assoc_member_count')),
                    cellText(g('mp_cand_assoc_member_growth')),
                    cellText(g('mp_cand_assoc_member_how')),
                    cellText(g('mp_cand_assoc_member_target')),
                    cellText(g('mp_cand_assoc_member_shortage')),
                    cellText(g('mp_cand_assoc_member_reason')),
                  ]),
                  pw.TableRow(children: [
                    cellText('কর্মী', align: pw.TextAlign.left),
                    cellText(g('mp_worker_count')),
                    cellText(g('mp_worker_growth')),
                    cellText(g('mp_worker_how')),
                    cellText(g('mp_worker_target')),
                    cellText(g('mp_worker_shortage')),
                    cellText(g('mp_worker_reason')),
                  ]),
                  pw.TableRow(children: [
                    cellText('মোট', isBold: true, align: pw.TextAlign.left),
                    cellText(g('mp_total_count'), isBold: true),
                    cellText(g('mp_total_growth'), isBold: true),
                    cellText(g('mp_total_how'), isBold: true),
                    cellText(g('mp_total_target'), isBold: true),
                    cellText(g('mp_total_shortage'), isBold: true),
                    cellText(g('mp_total_reason'), isBold: true),
                  ]),
                ],
              ),
              pw.SizedBox(height: 3),

              // TABLE 2: "দাওয়াত ও উপকরণ"
              pw.Table(
                border: pw.TableBorder.all(color: tableBorderColor, width: 0.5),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2.2),
                  1: pw.FlexColumnWidth(1.0),
                  2: pw.FlexColumnWidth(1.0),
                  3: pw.FlexColumnWidth(2.5),
                  4: pw.FlexColumnWidth(1.2),
                  5: pw.FlexColumnWidth(2.8),
                  6: pw.FlexColumnWidth(1.4),
                },
                children: [
                  pw.TableRow(
                    children: [
                      cellText('দাওয়াত', isBold: true),
                      cellText('সংখ্যা', isBold: true),
                      cellText('বৃদ্ধি', isBold: true),
                      cellText('বিতরণ', isBold: true),
                      cellText('পরিমাণ', isBold: true),
                      cellText('বিতরণ', isBold: true),
                      cellText('পরিমাণ', isBold: true),
                    ],
                  ),
                  pw.TableRow(children: [
                    cellText('প্রাথমিক সদস্য', align: pw.TextAlign.left),
                    cellText(g('dw_primary_count')),
                    cellText(g('dw_primary_growth')),
                    cellText('ইসলামী সাহিত্য', align: pw.TextAlign.left),
                    cellText(g('dist_sahitya')),
                    cellText('স্টিকার/ভিউকার্ড/ডায়েরি', align: pw.TextAlign.left),
                    cellText(g('dist_sticker').isEmpty ? '  /  ' : g('dist_sticker')),
                  ]),
                  pw.TableRow(children: [
                    cellText('বন্ধু', align: pw.TextAlign.left),
                    cellText(g('dw_friend_count')),
                    cellText(g('dw_friend_growth')),
                    cellText('পরিচিতি', align: pw.TextAlign.left),
                    cellText(g('dist_porichiti')),
                    cellText('ক্লাস/পরীক্ষার রুটিন/সূত্রাবলী', align: pw.TextAlign.left),
                    cellText(g('dist_routine').isEmpty ? '  /  ' : g('dist_routine')),
                  ]),
                  pw.TableRow(children: [
                    cellText('শুভাকাঙ্ক্ষী', align: pw.TextAlign.left),
                    cellText(g('dw_wellwisher_count').isEmpty ? '  /  ' : g('dw_wellwisher_count')),
                    cellText(g('dw_wellwisher_growth').isEmpty ? '  /  ' : g('dw_wellwisher_growth')),
                    cellText('ছাত্র পরিক্রমা/স্টুডেন্টস রিভিউ', align: pw.TextAlign.left),
                    cellText(g('dist_porikroma').isEmpty ? '  /  ' : g('dist_porikroma')),
                    cellText('লিফলেট/পোস্টার/ক্যালেন্ডার', align: pw.TextAlign.left),
                    cellText(g('dist_leaflet').isEmpty ? '  /  ' : g('dist_leaflet')),
                  ]),
                ],
              ),
              // Row 4: Group Dawah / Cha Chokro + Kishore Patrika + Dawot card
              pw.Table(
                border: pw.TableBorder(
                  left: const pw.BorderSide(color: tableBorderColor, width: 0.5),
                  right: const pw.BorderSide(color: tableBorderColor, width: 0.5),
                  bottom: const pw.BorderSide(color: tableBorderColor, width: 0.5),
                ),
                columnWidths: const {
                  0: pw.FlexColumnWidth(4.2),
                  1: pw.FlexColumnWidth(2.5),
                  2: pw.FlexColumnWidth(1.2),
                  3: pw.FlexColumnWidth(2.8),
                  4: pw.FlexColumnWidth(1.4),
                },
                children: [
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1.2),
                      child: pw.Row(
                        children: [
                          PdfExportService.bWidget('গ্রুপ দাওয়াত : ', fontSize: 6.8),
                          PdfExportService.bWidget(g('dw_group_dawa'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                          pw.Spacer(),
                          PdfExportService.bWidget('চা-চক্র : ', fontSize: 6.8),
                          PdfExportService.bWidget(g('dw_cha_chokro'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                        ],
                      ),
                    ),
                    cellText('কিশোর পত্রিকা', align: pw.TextAlign.left),
                    cellText(g('dist_kishore')),
                    cellText('দাওয়াত কার্ড / ঈদ কার্ড / উপহার', align: pw.TextAlign.left),
                    cellText(g('dist_card').isEmpty ? '  /  ' : g('dist_card')),
                  ]),
                ],
              ),

              // Table 2 Bottom Sub-Rows (Full width)
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    left: pw.BorderSide(color: tableBorderColor, width: 0.5),
                    right: pw.BorderSide(color: tableBorderColor, width: 0.5),
                    bottom: pw.BorderSide(color: tableBorderColor, width: 0.5),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(children: [
                      PdfExportService.bWidget('প্রাথমিক শাখা : ', fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' প্রাতিষ্ঠানিক :  বৃদ্ধি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_pri_shakha_inst_growth'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('    ঘাটতি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_pri_shakha_inst_shortage'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 15),
                      PdfExportService.bWidget(' আবাসিক :  বৃদ্ধি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_pri_shakha_res_growth'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('    ঘাটতি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_pri_shakha_res_shortage'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                    ]),
                    pw.SizedBox(height: 1.5),
                    pw.Row(children: [
                      PdfExportService.bWidget('শাখার সংবাদ প্রকাশিত হয়েছে(প্রিন্ট/ইলেকট্রনিক/অনলাইন মিডিয়ায়) : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_news_media').isEmpty ? '    /    ' : g('dw_news_media'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' বার ', fontSize: 6.8),
                      pw.SizedBox(width: 12),
                      PdfExportService.bWidget('দেয়ালিকা প্রকাশ : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_deyalika'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 12),
                      PdfExportService.bWidget('দেয়াল লিখন : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_deyal_likhon'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                    ]),
                    pw.SizedBox(height: 1.5),
                    pw.Row(children: [
                      PdfExportService.bWidget('বক্তৃতা/বিতর্ক/সাধারণ জ্ঞান প্রতিযোগিতা : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_competition').isEmpty ? '    /    /    ' : g('dw_competition'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 12),
                      PdfExportService.bWidget('নবীন বরণ : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_nobin_boron'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 12),
                      PdfExportService.bWidget('অন্যান্য : (বিস্তারিত আলাদা কাগজে)', fontSize: 6.8),
                    ]),
                  ],
                ),
              ),
              pw.SizedBox(height: 3),

              // TABLE 3: "সংগঠন ও শিক্ষাপ্রতিষ্ঠান শ্রেণিবিন্যাস"
              pw.Table(
                border: pw.TableBorder.all(color: tableBorderColor, width: 0.5),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2.6),
                  1: pw.FlexColumnWidth(1.0),
                  2: pw.FlexColumnWidth(2.6),
                  3: pw.FlexColumnWidth(1.8),
                  4: pw.FlexColumnWidth(2.2),
                },
                children: [
                  pw.TableRow(
                    children: [
                      cellText('সংগঠন', isBold: true),
                      cellText('সংখ্যা', isBold: true),
                      cellText('সংগঠন', isBold: true),
                      cellText('কাজ', isBold: true),
                      cellText('জনশক্তির শ্রেণিবিন্যাস', isBold: true),
                    ],
                  ),
                  _buildOrgTableRow('পাবলিক বিশ্ববিদ্যালয়', g('org_public_uni'), g('org_custom_name_1'), g('org_custom_work_1'), g('org_custom_manpower_1'), fontRegular, fontBold),
                  _buildOrgTableRow('প্রাইভেট বিশ্ববিদ্যালয়', g('org_private_uni'), g('org_custom_name_2'), g('org_custom_work_2'), g('org_custom_manpower_2'), fontRegular, fontBold),
                  _buildOrgTableRow('মেডিকেল কলেজ', g('org_med_college'), g('org_custom_name_3'), g('org_custom_work_3'), g('org_custom_manpower_3'), fontRegular, fontBold),
                  _buildOrgTableRow('বিশ্ববিদ্যালয় কলেজ', g('org_uni_college'), g('org_custom_name_4'), g('org_custom_work_4'), g('org_custom_manpower_4'), fontRegular, fontBold),
                  _buildOrgTableRow('হোমিও কলেজ', g('org_homoeo_college'), g('org_custom_name_5'), g('org_custom_work_5'), g('org_custom_manpower_5'), fontRegular, fontBold),
                  _buildOrgTableRow('আইন কলেজ', g('org_law_college'), g('org_custom_name_6'), g('org_custom_work_6'), g('org_custom_manpower_6'), fontRegular, fontBold),
                  _buildOrgTableRow('টেকনিক্যাল প্রতিষ্ঠান', g('org_tech_inst'), g('org_custom_name_7'), g('org_custom_work_7'), g('org_custom_manpower_7'), fontRegular, fontBold),
                  _buildOrgTableRow('কলেজ', '', g('org_custom_name_8'), g('org_custom_work_8'), g('org_custom_manpower_8'), fontRegular, fontBold, isSectionHeader: true),
                  _buildOrgTableRow('    সরকারি', g('org_college_govt'), g('org_custom_name_9'), g('org_custom_work_9'), g('org_custom_manpower_9'), fontRegular, fontBold),
                  _buildOrgTableRow('    বেসরকারি', g('org_college_non_govt'), g('org_custom_name_10'), g('org_custom_work_10'), g('org_custom_manpower_10'), fontRegular, fontBold),
                  _buildOrgTableRow('মাদ্রাসা', '', g('org_custom_name_11'), g('org_custom_work_11'), g('org_custom_manpower_11'), fontRegular, fontBold, isSectionHeader: true),
                  _buildOrgTableRow('    কামিল', g('org_madrasa_kamil'), g('org_custom_name_12'), g('org_custom_work_12'), g('org_custom_manpower_12'), fontRegular, fontBold),
                  _buildOrgTableRow('    ফাজিল', g('org_madrasa_fazil'), '', '', '', fontRegular, fontBold),
                  _buildOrgTableRow('    আলিম', g('org_madrasa_alim'), '', '', '', fontRegular, fontBold),
                  _buildOrgTableRow('    দাখিল', g('org_madrasa_dakhil'), '', '', '', fontRegular, fontBold),
                  _buildOrgTableRow('    কওমী', g('org_madrasa_qawmi'), '', '', '', fontRegular, fontBold),
                  _buildOrgTableRow('স্কুল', '', '', '', '', fontRegular, fontBold, isSectionHeader: true),
                  _buildOrgTableRow('    সরকারি', g('org_school_govt'), '', '', '', fontRegular, fontBold),
                  _buildOrgTableRow('    বেসরকারি', g('org_school_non_govt'), '', '', '', fontRegular, fontBold),
                  _buildOrgTableRow('জোন/থানা', g('org_zone_thana'), '', '', '', fontRegular, fontBold),
                ],
              ),

              // Table 3 Bottom Summary Rows
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    left: pw.BorderSide(color: tableBorderColor, width: 0.5),
                    right: pw.BorderSide(color: tableBorderColor, width: 0.5),
                    bottom: pw.BorderSide(color: tableBorderColor, width: 0.5),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(children: [
                      PdfExportService.bWidget('মোট শাখা : ', fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(g('org_total_shakha'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 8),
                      PdfExportService.bWidget('কর্মী শাখা : ', fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' প্রাতিষ্ঠানিক :  বৃদ্ধি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('org_kormi_inst_growth'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('    ঘাটতি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('org_kormi_inst_shortage'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 8),
                      PdfExportService.bWidget('  আবাসিক :  বৃদ্ধি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('org_kormi_res_growth'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('    ঘাটতি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('org_kormi_res_shortage'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                    ]),
                    pw.SizedBox(height: 1.5),
                    pw.Row(children: [
                      PdfExportService.bWidget('সহযোগী সদস্য শাখা (নামসহ) : ', fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(
                        g('org_assoc_shakha_names').isEmpty ? '........................................................................................................................' : g('org_assoc_shakha_names'),
                        fontSize: 6.8,
                      ),
                    ]),
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

  static Future<void> generateAndPrintPdf({
    required String branch,
    required String month,
    required String session,
    Map<String, String>? formData,
    PeriodReportModel? report,
    BuildContext? context,
  }) async {
    final pdfBytes = await generatePdfBytes(
      branch: branch,
      month: month,
      session: session,
      formData: formData,
      report: report,
    );

    final fileName = 'ছাত্র_মজলিস_রিপোর্ট_${month}_$session.pdf';
    if (context != null && context.mounted) {
      await openPdfPreview(
        context,
        pdfBytes,
        'বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট',
        fileName: fileName,
      );
    } else {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: fileName,
      );
    }
  }

  static pw.TableRow _buildOrgTableRow(
    String label1,
    String val1,
    String label2,
    String val2,
    String val3,
    pw.Font fontRegular,
    pw.Font fontBold, {
    bool isSectionHeader = false,
  }) {
    final weight = isSectionHeader ? pw.FontWeight.bold : pw.FontWeight.normal;
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 0.8),
          child: PdfExportService.bWidget(label1, fontSize: 6.5, fontWeight: weight),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 0.8),
          child: PdfExportService.bWidget(val1, fontSize: 6.5, textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 0.8),
          child: PdfExportService.bWidget(label2, fontSize: 6.5),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 0.8),
          child: PdfExportService.bWidget(label2.isEmpty ? '' : val2, fontSize: 6.5),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 0.8),
          child: PdfExportService.bWidget(label2.isEmpty ? '' : val3, fontSize: 6.5),
        ),
      ],
    );
  }
}
