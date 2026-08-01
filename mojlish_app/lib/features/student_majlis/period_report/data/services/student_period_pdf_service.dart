import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import '../models/period_report_model.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/pdf_preview_screen.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট (২ পৃষ্ঠা) PDF জেনারেটর সার্ভিস
class StudentPeriodPdfService {
  static Future<Uint8List> generatePdfBytes({
    required String branch,
    required String month,
    required String session,
    Map<String, String>? formData,
    PeriodReportModel? report,
  }) async {
    final fontRegular = await PdfGoogleFonts.notoSansBengaliRegular();
    final fontBold = await PdfGoogleFonts.notoSansBengaliBold();

    final data = <String, String>{};
    if (report != null) {
      data['branch'] = report.branch;
      data['month'] = report.month;
      data['session'] = report.session;
      data['mp_member_count'] = '${report.manpower.members}';
      data['mp_cand_member_count'] = '${report.manpower.candidateMembers}';
      data['mp_assoc_member_count'] = '${report.manpower.associateMembers}';
      data['mp_cand_assoc_member_count'] = '${report.manpower.candidateAssociateMembers}';
      data['mp_worker_count'] = '${report.manpower.workers}';
      data['dw_primary_count'] = '${report.dawah.primaryMembers}';
      data['dw_friend_count'] = '${report.dawah.friends}';
      data['dw_wellwisher_count'] = '${report.dawah.wellWishers}';
      data['org_public_uni'] = '${report.organization.publicUniversities}';
      data['org_private_uni'] = '${report.organization.privateUniversities}';
      data['org_college_govt'] = '${report.organization.colleges}';
      data['org_madrasa_kamil'] = '${report.organization.madrasas}';
      data['org_school_govt'] = '${report.organization.schools}';
      data['meet_daitoshil_count'] = '${report.meetings.responsibleMeetings}';
      data['meet_member_count'] = '${report.meetings.memberMeetings}';
      data['meet_general_count'] = '${report.meetings.generalMeetings}';
      data['train_skills_count'] = '${report.training.skillsDevelopment}';
      data['train_workshop_count'] = '${report.training.workshops}';
      data['train_education_count'] = '${report.training.educationMeetings}';
      data['lib_book_growth'] = '${report.library.totalBooks}';
      data['lib_reader_count'] = '${report.library.totalReaders}';
      data['bm_total_income'] = '${report.baytulmal.totalIncome}';
      data['bm_total_expense'] = '${report.baytulmal.totalExpense}';
    }

    if (formData != null) {
      data.addAll(formData);
    }

    String g(String key) => data[key] ?? '';

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

    final textStyleBoldSmall = pw.TextStyle(font: fontBold, fontSize: 7.5, color: PdfColors.black);
    final textStyleTiny = pw.TextStyle(font: fontRegular, fontSize: 6.8, color: PdfColors.black);
    final textStyleBoldTiny = pw.TextStyle(font: fontBold, fontSize: 6.8, color: PdfColors.black);

    const headerBlue = PdfColor.fromInt(0xFF1E3A8A);
    const tableBorderColor = PdfColors.grey700;

    pw.Widget buildHeader(String pageTitle) {
      return pw.Column(
        children: [
          pw.Text('বিসমিল্লাহির রাহমানির রাহীম', style: pw.TextStyle(font: fontRegular, fontSize: 8)),
          pw.SizedBox(height: 1),
          pw.Text(pageTitle, style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.grey900)),
          pw.SizedBox(height: 1),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              if (logoImage != null) ...[
                pw.Image(logoImage, width: 20, height: 20),
                pw.SizedBox(width: 5),
              ],
              pw.Text('বাংলাদেশ ইসলামী ছাত্র মজলিস', style: pw.TextStyle(font: fontBold, fontSize: 15, color: headerBlue)),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
              color: PdfColors.grey100,
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('শাখা : ${branch.isEmpty ? g("branch") : branch}', style: textStyleBoldSmall),
                pw.Text('মাস : ${month.isEmpty ? g("month") : month}', style: textStyleBoldSmall),
                pw.Text('সেশন : ${session.isEmpty ? g("session") : session}', style: textStyleBoldSmall),
              ],
            ),
          ),
        ],
      );
    }

    pw.Widget cellText(String text, {bool isBold = false, pw.TextAlign align = pw.TextAlign.center, double size = 7.0}) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1.5),
        child: pw.Text(
          text,
          textAlign: align,
          style: pw.TextStyle(font: isBold ? fontBold : fontRegular, fontSize: size),
        ),
      );
    }

    // ==========================================
    // PAGE 1: জনশক্তি, দাওয়াত, সংগঠন
    // ==========================================
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              buildHeader('বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট'),
              pw.SizedBox(height: 6),

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
                      cellText('কিভাবে', isBold: true),
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
              pw.SizedBox(height: 6),

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
                      pw.Text('গ্রুপ দাওয়াত : ', style: textStyleTiny),
                      pw.Text(g('dw_group_dawa').isEmpty ? '.......' : g('dw_group_dawa'), style: textStyleBoldTiny),
                      pw.SizedBox(width: 20),
                      pw.Text('চা-চক্র : ', style: textStyleTiny),
                      pw.Text(g('dw_cha_chokro').isEmpty ? '.......' : g('dw_cha_chokro'), style: textStyleBoldTiny),
                    ]),
                    pw.SizedBox(height: 1.5),
                    pw.Row(children: [
                      pw.Text('প্রাথমিক শাখা : ', style: textStyleTiny),
                      pw.Text(' প্রাতিষ্ঠানিক : ', style: textStyleTiny),
                      pw.Text(g('dw_pri_shakha_inst'), style: textStyleBoldTiny),
                      pw.Text('  বৃদ্ধি : ', style: textStyleTiny),
                      pw.Text(g('dw_pri_shakha_inst_growth'), style: textStyleBoldTiny),
                      pw.Text('  ঘাটতি : ', style: textStyleTiny),
                      pw.Text(g('dw_pri_shakha_inst_shortage'), style: textStyleBoldTiny),
                      pw.SizedBox(width: 10),
                      pw.Text(' আবাসিক : ', style: textStyleTiny),
                      pw.Text(g('dw_pri_shakha_res'), style: textStyleBoldTiny),
                      pw.Text('  বৃদ্ধি : ', style: textStyleTiny),
                      pw.Text(g('dw_pri_shakha_res_growth'), style: textStyleBoldTiny),
                      pw.Text('  ঘাটতি : ', style: textStyleTiny),
                      pw.Text(g('dw_pri_shakha_res_shortage'), style: textStyleBoldTiny),
                    ]),
                    pw.SizedBox(height: 1.5),
                    pw.Row(children: [
                      pw.Text('শাখার সংবাদ প্রকাশিত হয়েছে(প্রিন্ট/ইলেকট্রনিক/অনলাইন মিডিয়ায়) : ', style: textStyleTiny),
                      pw.Text(g('dw_news_media').isEmpty ? '...../.....' : g('dw_news_media'), style: textStyleBoldTiny),
                      pw.Text(' বার ', style: textStyleTiny),
                      pw.SizedBox(width: 15),
                      pw.Text('দেয়ালিকা প্রকাশ : ', style: textStyleTiny),
                      pw.Text(g('dw_deyalika').isEmpty ? '.......' : g('dw_deyalika'), style: textStyleBoldTiny),
                    ]),
                    pw.SizedBox(height: 1.5),
                    pw.Row(children: [
                      pw.Text('বক্তৃতা/বিতর্ক/সাধারণ জ্ঞান প্রতিযোগিতা : ', style: textStyleTiny),
                      pw.Text(g('dw_competition').isEmpty ? '...../.....' : g('dw_competition'), style: textStyleBoldTiny),
                      pw.SizedBox(width: 10),
                      pw.Text('নবীন বরণ : ', style: textStyleTiny),
                      pw.Text(g('dw_nobin_boron').isEmpty ? '.......' : g('dw_nobin_boron'), style: textStyleBoldTiny),
                      pw.SizedBox(width: 10),
                      pw.Text('অন্যান্য : (বিস্তারিত আলাদা কাগজে)', style: textStyleTiny),
                    ]),
                  ],
                ),
              ),
              pw.SizedBox(height: 6),

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
                      pw.Text('মোট শাখা : ', style: textStyleTiny),
                      pw.Text(g('org_total_shakha').isEmpty ? '.....' : g('org_total_shakha'), style: textStyleBoldTiny),
                      pw.SizedBox(width: 8),
                      pw.Text('কর্মী শাখা : ', style: textStyleTiny),
                      pw.Text(g('org_kormi_shakha').isEmpty ? '.....' : g('org_kormi_shakha'), style: textStyleBoldTiny),
                      pw.SizedBox(width: 8),
                      pw.Text(' প্রাতিষ্ঠানিক : ', style: textStyleTiny),
                      pw.Text(' বৃদ্ধি : ', style: textStyleTiny),
                      pw.Text(g('org_inst_growth'), style: textStyleBoldTiny),
                      pw.Text(' ঘাটতি : ', style: textStyleTiny),
                      pw.Text(g('org_inst_shortage'), style: textStyleBoldTiny),
                      pw.SizedBox(width: 8),
                      pw.Text(' আবাসিক : ', style: textStyleTiny),
                      pw.Text(' বৃদ্ধি : ', style: textStyleTiny),
                      pw.Text(g('org_res_growth'), style: textStyleBoldTiny),
                      pw.Text(' ঘাটতি : ', style: textStyleTiny),
                      pw.Text(g('org_res_shortage'), style: textStyleBoldTiny),
                    ]),
                    pw.SizedBox(height: 1.5),
                    pw.Row(children: [
                      pw.Text('সহযোগী সদস্য শাখা (নামসহ) : ', style: textStyleTiny),
                      pw.Text(g('org_assoc_shakha_names').isEmpty ? '........................................................................................................................' : g('org_assoc_shakha_names'), style: textStyleBoldTiny),
                    ]),
                  ],
                ),
              ),
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
        margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    pw.Text('পাঠক সংখ্যা : ', style: textStyleTiny),
                    pw.Text(g('lib_reader_count').isEmpty ? '.......' : g('lib_reader_count'), style: textStyleBoldTiny),
                    pw.SizedBox(width: 20),
                    pw.Text('ইস্যুকৃত বই : ', style: textStyleTiny),
                    pw.Text(g('lib_issued_books').isEmpty ? '.......' : g('lib_issued_books'), style: textStyleBoldTiny),
                    pw.SizedBox(width: 20),
                    pw.Text('পঠিত বই : ', style: textStyleTiny),
                    pw.Text(g('lib_read_books').isEmpty ? '.......' : g('lib_read_books'), style: textStyleBoldTiny),
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
                      pw.Text('বায়তুলমাল (আয়-ব্যয়ের বিস্তারিত রিপোর্ট আলাদা কাগজে)  বকেয়াঃ ', style: textStyleTiny),
                      pw.Text(g('bm_due').isEmpty ? '.........' : g('bm_due'), style: textStyleBoldTiny),
                      pw.Text('  বকেয়া পরিশোধঃ ', style: textStyleTiny),
                      pw.Text(g('bm_due_paid').isEmpty ? '.........' : g('bm_due_paid'), style: textStyleBoldTiny),
                    ]),
                    pw.SizedBox(height: 1.5),
                    pw.Row(children: [
                      pw.Text('মোট আয় : ', style: textStyleTiny),
                      pw.Text(g('bm_total_income'), style: textStyleBoldTiny),
                      pw.SizedBox(width: 15),
                      pw.Text('মোট ব্যয় : ', style: textStyleTiny),
                      pw.Text(g('bm_total_expense'), style: textStyleBoldTiny),
                      pw.SizedBox(width: 15),
                      pw.Text('উর্ধ্বতন ইয়ানত পরিশোধ : ', style: textStyleTiny),
                      pw.Text(g('bm_senior_paid'), style: textStyleBoldTiny),
                      pw.SizedBox(width: 15),
                      pw.Text('ধারকৃত : ', style: textStyleTiny),
                      pw.Text(g('bm_borrowed'), style: textStyleBoldTiny),
                    ]),
                    pw.SizedBox(height: 3),
                    pw.Row(children: [
                      pw.Text('প্রকাশনা (বিস্তারিত রিপোর্ট আলাদা কাগজে) : মোট ক্রয়ঃ ', style: textStyleTiny),
                      pw.Text(g('pub_total_buy'), style: textStyleBoldTiny),
                      pw.Text('  পরিশোধঃ ', style: textStyleTiny),
                      pw.Text(g('pub_paid'), style: textStyleBoldTiny),
                      pw.Text('  বকেয়াঃ ', style: textStyleTiny),
                      pw.Text(g('pub_due'), style: textStyleBoldTiny),
                      pw.Text('  বকেয়া পরিশোধঃ ', style: textStyleTiny),
                      pw.Text(g('pub_due_paid'), style: textStyleBoldTiny),
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
                      pw.Text('ছাত্রকল্যাণ (আয়-ব্যয়সহ বিস্তারিত রিপোর্ট আলাদা কাগজে)  ', style: textStyleBoldTiny),
                      pw.Text('মোট আয় : ', style: textStyleTiny),
                      pw.Text(g('sw_total_income'), style: textStyleBoldTiny),
                      pw.SizedBox(width: 20),
                      pw.Text('মোট ব্যয় : ', style: textStyleTiny),
                      pw.Text(g('sw_total_expense'), style: textStyleBoldTiny),
                    ]),
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      pw.Text('লজিং : ', style: textStyleTiny),
                      pw.Text(g('sw_lodging'), style: textStyleBoldTiny),
                      pw.Text(' টি  ', style: textStyleTiny),
                      pw.Text('টিউশনি : ', style: textStyleTiny),
                      pw.Text(g('sw_tuition'), style: textStyleBoldTiny),
                      pw.Text(' টি  ', style: textStyleTiny),
                      pw.Text('টেবিল/কলসি ব্যাংক : ', style: textStyleTiny),
                      pw.Text(g('sw_table_bank').isEmpty ? '...../.....' : g('sw_table_bank'), style: textStyleBoldTiny),
                      pw.Text(' টি  ', style: textStyleTiny),
                      pw.Text('প্রশ্নপত্র/সাজেশন/নোট বিলি : ', style: textStyleTiny),
                      pw.Text(g('sw_notes_dist').isEmpty ? '...../.....' : g('sw_notes_dist'), style: textStyleBoldTiny),
                      pw.Text(' টি', style: textStyleTiny),
                    ]),
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      pw.Text('যাকাত সংগ্রহঃ ', style: textStyleTiny),
                      pw.Text(g('sw_zakat_collected'), style: textStyleBoldTiny),
                      pw.Text(' টাকা  ', style: textStyleTiny),
                      pw.Text('ল্যাঙ্গুয়েজ লাইব্রেরি :  বই বৃদ্ধি : ', style: textStyleTiny),
                      pw.Text(g('sw_lang_lib_books'), style: textStyleBoldTiny),
                      pw.Text(' টি  ঘাটতি : ', style: textStyleTiny),
                      pw.Text(g('sw_lang_lib_shortage'), style: textStyleBoldTiny),
                      pw.Text(' জন  ', style: textStyleTiny),
                      pw.Text('একাডেমিক/ভর্তি কোচিংঃ ', style: textStyleTiny),
                      pw.Text(g('sw_coaching').isEmpty ? '...../.....' : g('sw_coaching'), style: textStyleBoldTiny),
                      pw.Text(' টি', style: textStyleTiny),
                    ]),
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      pw.Text('ফ্রি কোচিং/আবাসন ব্যবস্থা : ', style: textStyleTiny),
                      pw.Text(g('sw_free_coaching'), style: textStyleBoldTiny),
                      pw.Text(' টি  জন/ বৃদ্ধি : ', style: textStyleTiny),
                      pw.Text(g('sw_free_coaching_people_growth'), style: textStyleBoldTiny),
                      pw.Text('  ঘাটতি : ', style: textStyleTiny),
                      pw.Text(g('sw_free_coaching_shortage'), style: textStyleBoldTiny),
                      pw.Text(' জন  ', style: textStyleTiny),
                      pw.Text('স্টাইপেন্ড চালু হয়েছে : ', style: textStyleTiny),
                      pw.Text(g('sw_stipend_count'), style: textStyleBoldTiny),
                      pw.Text(' টি  ', style: textStyleTiny),
                      pw.Text('রক্ত দানঃ ', style: textStyleTiny),
                      pw.Text(g('sw_blood_bags'), style: textStyleBoldTiny),
                      pw.Text(' ব্যাগ', style: textStyleTiny),
                    ]),
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      pw.Text('ভর্তি গাইড প্রকাশ/সহযোগিতা : ', style: textStyleTiny),
                      pw.Text(g('sw_guide_pub').isEmpty ? '...../.....' : g('sw_guide_pub'), style: textStyleBoldTiny),
                      pw.Text(' টি  ', style: textStyleTiny),
                      pw.Text('ভর্তিকালীন সহযোগিতা করা হয়েছে : ', style: textStyleTiny),
                      pw.Text(g('sw_admission_help'), style: textStyleBoldTiny),
                      pw.Text(' জনকে  ', style: textStyleTiny),
                      pw.Text('অন্যান্য : (আলাদা কাগজে)', style: textStyleTiny),
                    ]),
                  ],
                ),
              ),
              pw.SizedBox(height: 3),

              // ৭. সফর & অতিরিক্ত তথ্যাবলী
              pw.Text('সফর (আলাদা কাগজে)', style: textStyleTiny),
              pw.Text('অন্যান্য ছাত্র সংগঠনের তৎপরতা (আলাদা কাগজে)', style: textStyleTiny),
              pw.Text('বিবিধ (আলাদা কাগজে)', style: textStyleTiny),
              pw.SizedBox(height: 3),

              // ৮. মন্তব্য (Remarks Box)
              pw.Text('মন্তব্য (গৃহীত পরিকল্পনার আলোকে, সমস্যা ও সম্ভাবনা উল্লেখ করে)', style: textStyleBoldTiny),
              pw.SizedBox(height: 1),
              pw.Container(
                width: double.infinity,
                height: 32,
                padding: const pw.EdgeInsets.all(3),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: tableBorderColor, width: 0.5)),
                child: pw.Text(
                  g('remarks').isEmpty ? '................................................................................................................................................................' : g('remarks'),
                  style: textStyleTiny,
                ),
              ),

              pw.Spacer(),

              // স্বাক্ষর (Footer Signature)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    children: [
                      pw.Container(width: 110, height: 0.5, color: PdfColors.black),
                      pw.SizedBox(height: 2),
                      pw.Text('সভাপতির স্বাক্ষর', style: textStyleBoldSmall),
                    ],
                  ),
                ],
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
    if (context != null) {
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
    final style1 = pw.TextStyle(font: isSectionHeader ? fontBold : fontRegular, fontSize: 6.8);
    final styleVal = pw.TextStyle(font: fontRegular, fontSize: 6.8);
    return pw.TableRow(
      decoration: isSectionHeader ? const pw.BoxDecoration(color: PdfColors.grey100) : null,
      children: [
        pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1), child: pw.Text(label1, style: style1)),
        pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1), child: pw.Text(val1, textAlign: pw.TextAlign.center, style: styleVal)),
        pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1), child: pw.Text(label2, style: styleVal)),
        pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1), child: pw.Text(val2, style: styleVal)),
        pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1), child: pw.Text(val3, style: styleVal)),
      ],
    );
  }

  static pw.TableRow _buildTrainingRow(String label, String c, String s, String p, String m) {
    final style = const pw.TextStyle(fontSize: 6.8);
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1), child: pw.Text(label, style: style)),
        pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1), child: pw.Text(c, textAlign: pw.TextAlign.center, style: style)),
        pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1), child: pw.Text(s, textAlign: pw.TextAlign.center, style: style)),
        pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1), child: pw.Text(p, textAlign: pw.TextAlign.center, style: style)),
        pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1), child: pw.Text(m, textAlign: pw.TextAlign.center, style: style)),
      ],
    );
  }
}
