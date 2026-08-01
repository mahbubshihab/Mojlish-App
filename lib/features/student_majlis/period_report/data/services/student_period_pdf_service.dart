import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/pdf_preview_screen.dart';
import '../models/period_report_model.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট (২ পৃষ্ঠা) PDF জেনারেটর সার্ভিস
/// বিজয় এনকোডিং (SutonnyMJ ফন্ট) ও আধুনিক ওশান সায়ান গ্রাফিক্স ডিজাইনে সাজানো
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
    final effectiveBranch = shakhaName ?? branch;
    final effectiveSession = periodName ?? session;
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
      mapData['meet_daitoshil_count'] = '${report.meetings.responsibleMeetings}';
      mapData['meet_member_count'] = '${report.meetings.memberMeetings}';
      mapData['meet_general_count'] = '${report.meetings.generalMeetings}';
      mapData['train_skills_count'] = '${report.training.skillsDevelopment}';
      mapData['train_workshop_count'] = '${report.training.workshops}';
      mapData['train_education_count'] = '${report.training.educationMeetings}';
      mapData['lib_book_growth'] = '${report.library.totalBooks}';
      mapData['lib_reader_count'] = '${report.library.totalReaders}';
      mapData['bm_total_income'] = '${report.baytulmal.totalIncome}';
      mapData['bm_total_expense'] = '${report.baytulmal.totalExpense}';
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

    final oceanCyan = PdfColor.fromHex('#0077B6');
    const tableBorderColor = PdfColors.grey700;

    pw.Widget buildHeaderRibbon(String pageTitle) {
      final branchVal = effectiveBranch.isEmpty ? g("branch") : effectiveBranch;
      final monthVal = month.isEmpty ? g("month") : month;
      final sessionVal = effectiveSession.isEmpty ? g("session") : effectiveSession;

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
            padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: pw.BoxDecoration(
              color: oceanCyan,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                if (logoImage != null) ...[
                  pw.Image(logoImage, width: 24, height: 24),
                  pw.SizedBox(width: 6),
                ],
                pw.Column(
                  children: [
                    PdfExportService.bWidget(
                      'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 1),
                    PdfExportService.bWidget(
                      pageTitle,
                      fontSize: 9.5,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#F0F9FF'),
              border: pw.Border.all(color: oceanCyan, width: 0.8),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                PdfExportService.bWidget(
                  'শাখা : ${branchVal.isEmpty ? "........................" : branchVal}',
                  fontSize: 8.5,
                  fontWeight: pw.FontWeight.bold,
                  color: oceanCyan,
                ),
                PdfExportService.bWidget(
                  'মাস : ${monthVal.isEmpty ? "........................" : monthVal}',
                  fontSize: 8.5,
                  fontWeight: pw.FontWeight.bold,
                  color: oceanCyan,
                ),
                PdfExportService.bWidget(
                  'সেশন : ${sessionVal.isEmpty ? "........................" : sessionVal}',
                  fontSize: 8.5,
                  fontWeight: pw.FontWeight.bold,
                  color: oceanCyan,
                ),
              ],
            ),
          ),
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

    pw.Widget cellText(
      String text, {
      bool isBold = false,
      pw.TextAlign align = pw.TextAlign.center,
      double size = 7.0,
      PdfColor color = PdfColors.black,
    }) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1.5),
        child: PdfExportService.bWidget(
          text,
          fontSize: size,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          textAlign: align,
          color: color,
        ),
      );
    }

    // ==========================================
    // PAGE 1: জনশক্তি, দাওয়াত, সংগঠন
    // ==========================================
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              buildHeaderRibbon('বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট'),
              pw.SizedBox(height: 5),

              // ১. জনশক্তি টেবিল
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
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
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
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                    children: [
                      cellText('মোট', isBold: true, align: pw.TextAlign.left),
                      cellText(g('mp_total_count'), isBold: true),
                      cellText(g('mp_total_growth'), isBold: true),
                      cellText(g('mp_total_how'), isBold: true),
                      cellText(g('mp_total_target'), isBold: true),
                      cellText(g('mp_total_shortage'), isBold: true),
                      cellText(g('mp_total_reason'), isBold: true),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 5),

              // ২. দাওয়াত ও বিতরণ (Side-by-Side Tables)
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Left: দাওয়াত
                  pw.Expanded(
                    flex: 4,
                    child: pw.Table(
                      border: pw.TableBorder.all(color: tableBorderColor, width: 0.5),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(2.5),
                        1: pw.FlexColumnWidth(1.2),
                        2: pw.FlexColumnWidth(1.2),
                      },
                      children: [
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                          children: [
                            cellText('দাওয়াত', isBold: true),
                            cellText('সংখ্যা', isBold: true),
                            cellText('বৃদ্ধি', isBold: true),
                          ],
                        ),
                        pw.TableRow(children: [
                          cellText('প্রাথমিক সদস্য', align: pw.TextAlign.left),
                          cellText(g('dw_primary_count')),
                          cellText(g('dw_primary_growth')),
                        ]),
                        pw.TableRow(children: [
                          cellText('বন্ধু', align: pw.TextAlign.left),
                          cellText(g('dw_friend_count')),
                          cellText(g('dw_friend_growth')),
                        ]),
                        pw.TableRow(children: [
                          cellText('শুভাকাঙ্ক্ষী', align: pw.TextAlign.left),
                          cellText(g('dw_wellwisher_count')),
                          cellText(g('dw_wellwisher_growth')),
                        ]),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 4),
                  // Right: বিতরণ
                  pw.Expanded(
                    flex: 6,
                    child: pw.Table(
                      border: pw.TableBorder.all(color: tableBorderColor, width: 0.5),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(2.5),
                        1: pw.FlexColumnWidth(1.2),
                        2: pw.FlexColumnWidth(2.5),
                        3: pw.FlexColumnWidth(1.2),
                      },
                      children: [
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                          children: [
                            cellText('বিতরণ', isBold: true),
                            cellText('পরিমাণ', isBold: true),
                            cellText('বিতরণ', isBold: true),
                            cellText('পরিমাণ', isBold: true),
                          ],
                        ),
                        pw.TableRow(children: [
                          cellText('ইসলামী সাহিত্য', align: pw.TextAlign.left),
                          cellText(g('dist_sahitya')),
                          cellText('স্টিকার/ভিউকার্ড/ডায়েরি', align: pw.TextAlign.left),
                          cellText(g('dist_sticker')),
                        ]),
                        pw.TableRow(children: [
                          cellText('পরিচিতি', align: pw.TextAlign.left),
                          cellText(g('dist_porichiti')),
                          cellText('ক্লাস/পরীক্ষার রুটিন/সূত্রাবলী', align: pw.TextAlign.left),
                          cellText(g('dist_routine')),
                        ]),
                        pw.TableRow(children: [
                          cellText('ছাত্র পরিক্রমা/স্টুডেন্টস রিভিউ', align: pw.TextAlign.left),
                          cellText(g('dist_porikroma')),
                          cellText('লিফলেট/পোস্টার/ক্যালেন্ডার', align: pw.TextAlign.left),
                          cellText(g('dist_leaflet')),
                        ]),
                        pw.TableRow(children: [
                          cellText('কিশোর পত্রিকা', align: pw.TextAlign.left),
                          cellText(g('dist_kishore')),
                          cellText('দাওয়াত কার্ড / ঈদ কার্ড / উপহার', align: pw.TextAlign.left),
                          cellText(g('dist_card')),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 3),

              // দাওয়াত অতিরিক্ত তথ্যাবলী (Dawah Sub-lines)
              pw.Container(
                padding: const pw.EdgeInsets.all(3),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: tableBorderColor, width: 0.5)),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(children: [
                      PdfExportService.bWidget('গ্রুপ দাওয়াত : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_group_dawa').isEmpty ? '.......' : g('dw_group_dawa'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 20),
                      PdfExportService.bWidget('চা-চক্র : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_cha_chokro').isEmpty ? '.......' : g('dw_cha_chokro'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                    ]),
                    pw.SizedBox(height: 1.5),
                    pw.Row(children: [
                      PdfExportService.bWidget('প্রাথমিক শাখা : ', fontSize: 6.8),
                      PdfExportService.bWidget(' প্রাতিষ্ঠানিক : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_pri_shakha_inst'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('  বৃদ্ধি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_pri_shakha_inst_growth'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('  ঘাটতি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_pri_shakha_inst_shortage'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 10),
                      PdfExportService.bWidget(' আবাসিক : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_pri_shakha_res'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('  বৃদ্ধি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_pri_shakha_res_growth'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('  ঘাটতি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_pri_shakha_res_shortage'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                    ]),
                    pw.SizedBox(height: 1.5),
                    pw.Row(children: [
                      PdfExportService.bWidget('শাখার সংবাদ প্রকাশিত হয়েছে(প্রিন্ট/ইলেকট্রনিক/অনলাইন মিডিয়ায়) : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_news_media').isEmpty ? '...../.....' : g('dw_news_media'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' বার ', fontSize: 6.8),
                      pw.SizedBox(width: 15),
                      PdfExportService.bWidget('দেয়ালিকা প্রকাশ : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_deyalika').isEmpty ? '.......' : g('dw_deyalika'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                    ]),
                    pw.SizedBox(height: 1.5),
                    pw.Row(children: [
                      PdfExportService.bWidget('বক্তৃতা/বিতর্ক/সাধারণ জ্ঞান প্রতিযোগিতা : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_competition').isEmpty ? '...../.....' : g('dw_competition'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 10),
                      PdfExportService.bWidget('নবীন বরণ : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('dw_nobin_boron').isEmpty ? '.......' : g('dw_nobin_boron'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 10),
                      PdfExportService.bWidget('অন্যান্য : (বিস্তারিত আলাদা কাগজে)', fontSize: 6.8),
                    ]),
                  ],
                ),
              ),
              pw.SizedBox(height: 5),

              // ৩. সংগঠন (Organization Table)
              pw.Table(
                border: pw.TableBorder.all(color: tableBorderColor, width: 0.5),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2.6),
                  1: pw.FlexColumnWidth(1.0),
                  2: pw.FlexColumnWidth(2.6),
                  3: pw.FlexColumnWidth(1.8),
                  4: pw.FlexColumnWidth(2.0),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
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
                  _buildOrgTableRow('মাদ্রাসা', '', '', '', '', fontRegular, fontBold, isSectionHeader: true),
                  _buildOrgTableRow('    কামিল', g('org_madrasa_kamil'), '', '', '', fontRegular, fontBold),
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
              pw.SizedBox(height: 3),

              // সংগঠন সারসংক্ষেপ লাইন (Org Footer Summary)
              pw.Container(
                padding: const pw.EdgeInsets.all(3),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: tableBorderColor, width: 0.5)),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(children: [
                      PdfExportService.bWidget('মোট শাখা : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('org_total_shakha').isEmpty ? '.....' : g('org_total_shakha'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 8),
                      PdfExportService.bWidget('কর্মী শাখা : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('org_kormi_shakha').isEmpty ? '.....' : g('org_kormi_shakha'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 8),
                      PdfExportService.bWidget(' প্রাতিষ্ঠানিক : ', fontSize: 6.8),
                      PdfExportService.bWidget(' বৃদ্ধি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('org_inst_growth'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' ঘাটতি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('org_inst_shortage'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 8),
                      PdfExportService.bWidget(' আবাসিক : ', fontSize: 6.8),
                      PdfExportService.bWidget(' বৃদ্ধি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('org_res_growth'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' ঘাটতি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('org_res_shortage'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                    ]),
                    pw.SizedBox(height: 1.5),
                    pw.Row(children: [
                      PdfExportService.bWidget('সহযোগী সদস্য শাখা (নামসহ) : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('org_assoc_shakha_names').isEmpty ? '........................................................................................................................' : g('org_assoc_shakha_names'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                    ]),
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
    // PAGE 2: সভাসমূহ, প্রশিক্ষণ, পাঠাগার, বায়তুলমাল, প্রকাশনা, ছাত্রকল্যাণ, সফর, যোগাযোগ, মন্তব্য
    // ==========================================
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ১. সভাসমূহ (Meetings Side-by-Side Tables)
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Left Meetings Table
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(color: tableBorderColor, width: 0.5),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(2.6),
                        1: pw.FlexColumnWidth(1.0),
                        2: pw.FlexColumnWidth(1.2),
                        3: pw.FlexColumnWidth(1.4),
                      },
                      children: [
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                          children: [
                            cellText('সভাসমূহ', isBold: true),
                            cellText('সংখ্যা', isBold: true),
                            cellText('উপস্থিতি', isBold: true),
                            cellText('সর্বোচ্চ/সর্বনিম্ন', isBold: true),
                          ],
                        ),
                        pw.TableRow(children: [cellText('দায়িত্বশীল সভা', align: pw.TextAlign.left), cellText(g('meet_daitoshil_count')), cellText(g('meet_daitoshil_pres')), cellText(g('meet_daitoshil_max_min'))]),
                        pw.TableRow(children: [cellText('থানা/জোনাল দায়িত্বশীল সভা', align: pw.TextAlign.left), cellText(g('meet_thana_daitoshil_count')), cellText(g('meet_thana_daitoshil_pres')), cellText(g('meet_thana_daitoshil_max_min'))]),
                        pw.TableRow(children: [cellText('সদস্য সভা', align: pw.TextAlign.left), cellText(g('meet_member_count')), cellText(g('meet_member_pres')), cellText(g('meet_member_max_min'))]),
                        pw.TableRow(children: [cellText('সহযোগী সদস্য সভা', align: pw.TextAlign.left), cellText(g('meet_assoc_member_count')), cellText(g('meet_assoc_member_pres')), cellText(g('meet_assoc_member_max_min'))]),
                        pw.TableRow(children: [cellText('কর্মী সভা', align: pw.TextAlign.left), cellText(g('meet_worker_count')), cellText(g('meet_worker_pres')), cellText(g('meet_worker_max_min'))]),
                        pw.TableRow(children: [cellText('জরুরি সভা', align: pw.TextAlign.left), cellText(g('meet_urgent_count')), cellText(g('meet_urgent_pres')), cellText(g('meet_urgent_max_min'))]),
                        pw.TableRow(children: [cellText('সাধারণ সভা', align: pw.TextAlign.left), cellText(g('meet_general_count')), cellText(g('meet_general_pres')), cellText(g('meet_general_max_min'))]),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 4),
                  // Right Meetings Table
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(color: tableBorderColor, width: 0.5),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(2.6),
                        1: pw.FlexColumnWidth(1.0),
                        2: pw.FlexColumnWidth(1.2),
                        3: pw.FlexColumnWidth(1.4),
                      },
                      children: [
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                          children: [
                            cellText('সভাসমূহ', isBold: true),
                            cellText('সংখ্যা', isBold: true),
                            cellText('উপস্থিতি', isBold: true),
                            cellText('সর্বোচ্চ/সর্বনিম্ন', isBold: true),
                          ],
                        ),
                        pw.TableRow(children: [cellText('আলোচনা সভা', align: pw.TextAlign.left), cellText(g('meet_discussion_count')), cellText(g('meet_discussion_pres')), cellText(g('meet_discussion_max_min'))]),
                        pw.TableRow(children: [cellText('সহযোগী সদস্য সমাবেশ', align: pw.TextAlign.left), cellText(g('meet_assoc_samabesh_count')), cellText(g('meet_assoc_samabesh_pres')), cellText(g('meet_assoc_samabesh_max_min'))]),
                        pw.TableRow(children: [cellText('কর্মী সমাবেশ', align: pw.TextAlign.left), cellText(g('meet_worker_samabesh_count')), cellText(g('meet_worker_samabesh_pres')), cellText(g('meet_worker_samabesh_max_min'))]),
                        pw.TableRow(children: [cellText('ছাত্র সমাবেশ', align: pw.TextAlign.left), cellText(g('meet_student_samabesh_count')), cellText(g('meet_student_samabesh_pres')), cellText(g('meet_student_samabesh_max_min'))]),
                        pw.TableRow(children: [cellText('মিছিল', align: pw.TextAlign.left), cellText(g('meet_rally_count')), cellText(g('meet_rally_pres')), cellText(g('meet_rally_max_min'))]),
                        pw.TableRow(children: [cellText('দিবস পালন', align: pw.TextAlign.left), cellText(g('meet_day_observance_count')), cellText(g('meet_day_observance_pres')), cellText(g('meet_day_observance_max_min'))]),
                        pw.TableRow(children: [cellText('অন্যান্য', align: pw.TextAlign.left), cellText(g('meet_other_count')), cellText(g('meet_other_pres')), cellText(g('meet_other_max_min'))]),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),

              // ২. প্রশিক্ষণ (Training Table)
              pw.Table(
                border: pw.TableBorder.all(color: tableBorderColor, width: 0.5),
                columnWidths: const {
                  0: pw.FlexColumnWidth(3.0),
                  1: pw.FlexColumnWidth(1.0),
                  2: pw.FlexColumnWidth(1.2),
                  3: pw.FlexColumnWidth(1.2),
                  4: pw.FlexColumnWidth(1.4),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      cellText('প্রশিক্ষণ', isBold: true),
                      cellText('সংখ্যা', isBold: true),
                      cellText('অধিবেশন', isBold: true),
                      cellText('উপস্থিতি', isBold: true),
                      cellText('সর্বোচ্চ/সর্বনিম্ন', isBold: true),
                    ],
                  ),
                  _buildTrainingRow('স্কিলস ডেভেলপমেন্ট প্রোগ্রাম', g('train_skills_count'), g('train_skills_session'), g('train_skills_pres'), g('train_skills_max_min')),
                  _buildTrainingRow('কর্মশালা', g('train_workshop_count'), g('train_workshop_session'), g('train_workshop_pres'), g('train_workshop_max_min')),
                  _buildTrainingRow('তরবিয়াতি সফর', g('train_tarbiyath_count'), g('train_tarbiyath_session'), g('train_tarbiyath_pres'), g('train_tarbiyath_max_min')),
                  _buildTrainingRow('প্রশিক্ষণ চক্র', g('train_cycle_count'), g('train_cycle_session'), g('train_cycle_pres'), g('train_cycle_max_min')),
                  _buildTrainingRow('শিক্ষা সভা', g('train_education_count'), g('train_education_session'), g('train_education_pres'), g('train_education_max_min')),
                  _buildTrainingRow('কুরআন ও হাদীস শিক্ষা ক্লাস', g('train_quran_hadith_count'), g('train_quran_hadith_session'), g('train_quran_hadith_pres'), g('train_quran_hadith_max_min')),
                  _buildTrainingRow('শবগুজারি', g('train_shobgujari_count'), g('train_shobgujari_session'), g('train_shobgujari_pres'), g('train_shobgujari_max_min')),
                  _buildTrainingRow('জিকির মাহফিল', g('train_zikir_count'), g('train_zikir_session'), g('train_zikir_pres'), g('train_zikir_max_min')),
                  _buildTrainingRow('সমষ্টিগত অধ্যয়ন', g('train_group_study_count'), g('train_group_study_session'), g('train_group_study_pres'), g('train_group_study_max_min')),
                  _buildTrainingRow('হাদীস পাঠ', g('train_hadith_path_count'), g('train_hadith_path_session'), g('train_hadith_path_pres'), g('train_hadith_path_max_min')),
                  _buildTrainingRow('স্পীকার্স/সাংস্কৃতিক ফোরাম', g('train_speakers_count'), g('train_speakers_session'), g('train_speakers_pres'), g('train_speakers_max_min')),
                  _buildTrainingRow('উন্মুক্ত ক্লাস', g('train_open_class_count'), g('train_open_class_session'), g('train_open_class_pres'), g('train_open_class_max_min')),
                ],
              ),
              pw.SizedBox(height: 5),

              // ৩. পাঠাগার (Library Table & Sub-line)
              pw.Table(
                border: pw.TableBorder.all(color: tableBorderColor, width: 0.5),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2.5),
                  1: pw.FlexColumnWidth(2.5),
                  2: pw.FlexColumnWidth(2.5),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      cellText('পাঠাগার', isBold: true),
                      cellText('বৃদ্ধি', isBold: true),
                      cellText('ঘাটতি', isBold: true),
                    ],
                  ),
                  pw.TableRow(children: [
                    cellText('সংখ্যা', align: pw.TextAlign.left),
                    cellText(g('lib_shakha_growth')),
                    cellText(g('lib_shakha_shortage')),
                  ]),
                  pw.TableRow(children: [
                    cellText('বই সংখ্যা', align: pw.TextAlign.left),
                    cellText(g('lib_book_growth')),
                    cellText(g('lib_book_shortage')),
                  ]),
                ],
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    left: pw.BorderSide(color: tableBorderColor, width: 0.5),
                    right: pw.BorderSide(color: tableBorderColor, width: 0.5),
                    bottom: pw.BorderSide(color: tableBorderColor, width: 0.5),
                  ),
                ),
                child: pw.Row(
                  children: [
                    PdfExportService.bWidget('পাঠক সংখ্যা : ', fontSize: 6.8),
                    PdfExportService.bWidget(g('lib_reader_count').isEmpty ? '.......' : g('lib_reader_count'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                    pw.SizedBox(width: 20),
                    PdfExportService.bWidget('ইস্যুকৃত বই : ', fontSize: 6.8),
                    PdfExportService.bWidget(g('lib_issued_books').isEmpty ? '.......' : g('lib_issued_books'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                    pw.SizedBox(width: 20),
                    PdfExportService.bWidget('পঠিত বই : ', fontSize: 6.8),
                    PdfExportService.bWidget(g('lib_read_books').isEmpty ? '.......' : g('lib_read_books'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                  ],
                ),
              ),
              pw.SizedBox(height: 5),

              // ৪. বায়তুলমাল & ৫. প্রকাশনা Box
              pw.Container(
                padding: const pw.EdgeInsets.all(3),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: tableBorderColor, width: 0.5)),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(children: [
                      PdfExportService.bWidget('বায়তুলমাল (আয়-ব্যয়ের বিস্তারিত রিপোর্ট আলাদা কাগজে)  বকেয়াঃ ', fontSize: 6.8),
                      PdfExportService.bWidget(g('bm_due').isEmpty ? '.........' : g('bm_due'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('  বকেয়া পরিশোধঃ ', fontSize: 6.8),
                      PdfExportService.bWidget(g('bm_due_paid').isEmpty ? '.........' : g('bm_due_paid'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                    ]),
                    pw.SizedBox(height: 1.5),
                    pw.Row(children: [
                      PdfExportService.bWidget('মোট আয় : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('bm_total_income'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 15),
                      PdfExportService.bWidget('মোট ব্যয় : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('bm_total_expense'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 15),
                      PdfExportService.bWidget('উর্ধ্বতন ইয়ানত পরিশোধ : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('bm_senior_paid'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 15),
                      PdfExportService.bWidget('ধারকৃত : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('bm_borrowed'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                    ]),
                    pw.SizedBox(height: 3),
                    pw.Row(children: [
                      PdfExportService.bWidget('প্রকাশনা (বিস্তারিত রিপোর্ট আলাদা কাগজে) : মোট ক্রয়ঃ ', fontSize: 6.8),
                      PdfExportService.bWidget(g('pub_total_buy'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('  পরিশোধঃ ', fontSize: 6.8),
                      PdfExportService.bWidget(g('pub_paid'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('  বকেয়াঃ ', fontSize: 6.8),
                      PdfExportService.bWidget(g('pub_due'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('  বকেয়া পরিশোধঃ ', fontSize: 6.8),
                      PdfExportService.bWidget(g('pub_due_paid'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                    ]),
                  ],
                ),
              ),
              pw.SizedBox(height: 5),

              // ৬. ছাত্রকল্যাণ (Student Welfare Box)
              pw.Container(
                padding: const pw.EdgeInsets.all(3),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: tableBorderColor, width: 0.5)),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(children: [
                      PdfExportService.bWidget('ছাত্রকল্যাণ (আয়-ব্যয়সহ বিস্তারিত রিপোর্ট আলাদা কাগজে)  ', fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('মোট আয় : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_total_income'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      pw.SizedBox(width: 20),
                      PdfExportService.bWidget('মোট ব্যয় : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_total_expense'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                    ]),
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      PdfExportService.bWidget('লজিং : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_lodging'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' টি  ', fontSize: 6.8),
                      PdfExportService.bWidget('টিউশনি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_tuition'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' টি  ', fontSize: 6.8),
                      PdfExportService.bWidget('টেবিল/কলসি ব্যাংক : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_table_bank').isEmpty ? '...../.....' : g('sw_table_bank'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' টি  ', fontSize: 6.8),
                      PdfExportService.bWidget('প্রশ্নপত্র/সাজেশন/নোট বিলি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_notes_dist').isEmpty ? '...../.....' : g('sw_notes_dist'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' টি', fontSize: 6.8),
                    ]),
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      PdfExportService.bWidget('যাকাত সংগ্রহঃ ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_zakat_collected'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' টাকা  ', fontSize: 6.8),
                      PdfExportService.bWidget('ল্যাঙ্গুয়েজ লাইব্রেরি :  বই বৃদ্ধি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_lang_lib_books'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' টি  ঘাটতি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_lang_lib_shortage'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' জন  ', fontSize: 6.8),
                      PdfExportService.bWidget('একাডেমিক/ভর্তি কোচিংঃ ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_coaching').isEmpty ? '...../.....' : g('sw_coaching'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' টি', fontSize: 6.8),
                    ]),
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      PdfExportService.bWidget('ফ্রি কোচিং/আবাসন ব্যবস্থা : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_free_coaching'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' টি  জন/ বৃদ্ধি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_free_coaching_people_growth'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget('  ঘাটতি : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_free_coaching_shortage'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' জন  ', fontSize: 6.8),
                      PdfExportService.bWidget('স্টাইপেন্ড চালু হয়েছে : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_stipend_count'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' টি  ', fontSize: 6.8),
                      PdfExportService.bWidget('রক্ত দানঃ ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_blood_bags'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' ব্যাগ', fontSize: 6.8),
                    ]),
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      PdfExportService.bWidget('ভর্তি গাইড প্রকাশ/সহযোগিতা : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_guide_pub').isEmpty ? '...../.....' : g('sw_guide_pub'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' টি  ', fontSize: 6.8),
                      PdfExportService.bWidget('ভর্তিকালীন সহযোগিতা করা হয়েছে : ', fontSize: 6.8),
                      PdfExportService.bWidget(g('sw_admission_help'), fontSize: 6.8, fontWeight: pw.FontWeight.bold),
                      PdfExportService.bWidget(' জনকে  ', fontSize: 6.8),
                      PdfExportService.bWidget('অন্যান্য : (আলাদা কাগজে)', fontSize: 6.8),
                    ]),
                  ],
                ),
              ),
              pw.SizedBox(height: 3),

              // ৭. সফর & অতিরিক্ত তথ্যাবলী
              PdfExportService.bWidget('সফর (আলাদা কাগজে)', fontSize: 6.8),
              PdfExportService.bWidget('অন্যান্য ছাত্র সংগঠনের তৎপরতা (আলাদা কাগজে)', fontSize: 6.8),
              PdfExportService.bWidget('বিবিধ (আলাদা কাগজে)', fontSize: 6.8),
              pw.SizedBox(height: 3),

              // ৮. মন্তব্য (Remarks Box)
              PdfExportService.bWidget('মন্তব্য (গৃহীত পরিকল্পনার আলোকে, সমস্যা ও সম্ভাবনা উল্লেখ করে)', fontSize: 6.8, fontWeight: pw.FontWeight.bold),
              pw.SizedBox(height: 1),
              pw.Container(
                width: double.infinity,
                height: 32,
                padding: const pw.EdgeInsets.all(3),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: tableBorderColor, width: 0.5)),
                child: PdfExportService.bWidget(
                  g('remarks').isEmpty ? '................................................................................................................................................................' : g('remarks'),
                  fontSize: 6.8,
                ),
              ),

              pw.SizedBox(height: 6),

              // স্বাক্ষর (Footer Signature)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    children: [
                      pw.Container(width: 110, height: 0.5, color: PdfColors.black),
                      pw.SizedBox(height: 2),
                      PdfExportService.bWidget('সভাপতির স্বাক্ষর', fontSize: 7.5, fontWeight: pw.FontWeight.bold),
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
        'পর্যায়ভিত্তিক রিপোর্ট',
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
      decoration: isSectionHeader ? const pw.BoxDecoration(color: PdfColors.grey100) : null,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: PdfExportService.bWidget(label1, fontSize: 6.8, fontWeight: weight),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: PdfExportService.bWidget(val1, fontSize: 6.8, textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: PdfExportService.bWidget(label2, fontSize: 6.8),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: PdfExportService.bWidget(label2.isEmpty ? '' : val2, fontSize: 6.8),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: PdfExportService.bWidget(label2.isEmpty ? '' : val3, fontSize: 6.8),
        ),
      ],
    );
  }

  static pw.TableRow _buildTrainingRow(String label, String c, String s, String p, String m) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: PdfExportService.bWidget(label, fontSize: 6.8),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: PdfExportService.bWidget(c, fontSize: 6.8, textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: PdfExportService.bWidget(s, fontSize: 6.8, textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: PdfExportService.bWidget(p, fontSize: 6.8, textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: PdfExportService.bWidget(m, fontSize: 6.8, textAlign: pw.TextAlign.center),
        ),
      ],
    );
  }
}
