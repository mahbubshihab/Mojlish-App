import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';

/// খেলাফত মজলিস — শাখার রিপোর্ট ফরম (২-পৃষ্ঠার অফিশিয়াল Bijoy-SutonnyMJ হুবহু পিডিএফ জেনারেটর)
class KhelafatBranchReportPdfService {
  static Future<Uint8List> generatePdfBytes(
    Map<String, dynamic> data, {
    String shakhaName = '',
    String month = '',
    String year = '',
    pw.Document? pdfDocument,
  }) async {
    final fontRegular = await PdfExportService.loadSutonnyFont();
    final fontBold = await PdfExportService.loadBengaliBoldFont();

    final mapData = Map<String, dynamic>.from(data);
    final sName = shakhaName.isNotEmpty ? shakhaName : (mapData['shakhaName'] ?? mapData['branchName'] ?? '').toString();
    final mName = month.isNotEmpty ? month : (mapData['month'] ?? '').toString();
    final yName = year.isNotEmpty ? year : (mapData['year'] ?? '').toString();

    pw.MemoryImage? logoImage;
    try {
      final bytes = await rootBundle.load(MajlisAssets.khelafatLogo);
      logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {}

    final pdf = pdfDocument ??
        pw.Document(
          theme: pw.ThemeData.withFont(
            base: fontRegular,
            bold: fontBold,
          ),
        );

    // Value lookup helper
    String v(dynamic key) {
      if (key == null) return '';
      if (key is List) {
        for (final k in key) {
          final res = v(k);
          if (res.isNotEmpty) return res;
        }
        return '';
      }
      final kStr = key.toString();
      if (mapData.containsKey(kStr) && mapData[kStr] != null) {
        final val = mapData[kStr].toString().trim();
        if (val.isNotEmpty) return val;
      }
      for (final section in [
        'manpower',
        'dawah',
        'organization',
        'meetings',
        'baytulmal',
        'tour',
        'training',
        'office',
        'publicity',
        'publication',
        'library',
        'socialWelfare'
      ]) {
        if (mapData[section] is Map && mapData[section][kStr] != null) {
          final val = mapData[section][kStr].toString().trim();
          if (val.isNotEmpty) return val;
        }
      }
      return '';
    }

    // Section Header Banner Widget
    pw.Widget buildSectionHeader(String title) {
      return pw.Container(
        width: double.infinity,
        margin: const pw.EdgeInsets.only(top: 4, bottom: 2),
        padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey100,
          border: pw.Border.all(color: PdfColors.grey700, width: 0.35),
        ),
        child: PdfExportService.bWidget(
          title,
          fontSize: 8.0,
          fontWeight: pw.FontWeight.bold,
        ),
      );
    }

    // Table Builder Helper
    pw.Widget buildTable({
      required List<String> headers,
      required List<List<String>> rows,
      Map<int, pw.TableColumnWidth>? columnWidths,
    }) {
      return pw.Table(
        border: pw.TableBorder.all(width: 0.35, color: PdfColors.grey700),
        columnWidths: columnWidths,
        children: [
          if (headers.isNotEmpty)
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: headers.map((h) {
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1.5),
                  child: pw.Center(
                    child: PdfExportService.bWidget(
                      h,
                      fontSize: 7.2,
                      fontWeight: pw.FontWeight.bold,
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
          ...rows.map((row) {
            return pw.TableRow(
              children: row.asMap().entries.map((entry) {
                final idx = entry.key;
                final cellText = entry.value;
                final isLabel = idx == 0;
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 1.2),
                  child: PdfExportService.bWidget(
                    cellText,
                    fontSize: 7.0,
                    fontWeight: pw.FontWeight.normal,
                    textAlign: isLabel ? pw.TextAlign.left : pw.TextAlign.center,
                  ),
                );
              }).toList(),
            );
          }),
        ],
      );
    }

    // ==========================================
    // PAGE 1: শাখার রিপোর্ট ফরম (পৃষ্ঠা ১)
    // ==========================================
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // PAGE 1 HEADER
              pw.Center(
                child: pw.Column(
                  children: [
                    PdfExportService.bWidget(
                      'বিসমিল্লাহির রাহমানির রাহীম',
                      fontSize: 8.5,
                    ),
                    pw.SizedBox(height: 1),
                    PdfExportService.bWidget(
                      'শাখার রিপোর্ট ফরম',
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    pw.SizedBox(height: 2),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        if (logoImage != null) ...[
                          pw.Image(logoImage, width: 22, height: 22),
                          pw.SizedBox(width: 6),
                        ],
                        PdfExportService.bWidget(
                          'খেলাফত মজলিস',
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 1),
                    PdfExportService.bWidget(
                      'কেন্দ্রীয় কার্যালয়: ১৮ বিজয়নগর, (৫ম তলা), ঢাকা-১০০০ | ফোন: ৯৫৮৫৩২১',
                      fontSize: 7.5,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 4),

              // INFO BANNER BOX: শাখা, মাস, সন
              pw.Container(
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey200,
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    PdfExportService.bWidget('শাখা: ${sName.isEmpty ? ".................................................." : sName}', fontSize: 9, fontWeight: pw.FontWeight.bold),
                    PdfExportService.bWidget('মাস: ${mName.isEmpty ? "...................." : mName}', fontSize: 9, fontWeight: pw.FontWeight.bold),
                    PdfExportService.bWidget('সন: ${yName.isEmpty ? "............" : yName}', fontSize: 9, fontWeight: pw.FontWeight.bold),
                  ],
                ),
              ),
              pw.SizedBox(height: 4),

              // ------------------------------------------
              // 1. জনশক্তি
              // ------------------------------------------
              buildSectionHeader('১. জনশক্তি'),
              buildTable(
                headers: ['জনশক্তি', 'সংখ্যা', 'বৃদ্ধি', 'কারণ', 'ঘাটতি', 'কারণ'],
                columnWidths: {
                  0: const pw.FlexColumnWidth(2.5),
                  1: const pw.FlexColumnWidth(1.2),
                  2: const pw.FlexColumnWidth(1.2),
                  3: const pw.FlexColumnWidth(2.5),
                  4: const pw.FlexColumnWidth(1.2),
                  5: const pw.FlexColumnWidth(2.5),
                },
                rows: [
                  ['সদস্য', v('sodossoCount'), v('sodossoBridhi'), v('sodossoBridhiReason'), v('sodossoGhatti'), v('sodossoGhattiReason')],
                  ['সদস্য প্রার্থী', v('sodossoPrarthiCount'), v('sodossoPrarthiBridhi'), v('sodossoPrarthiBridhiReason'), v('sodossoPrarthiGhatti'), v('sodossoPrarthiGhattiReason')],
                  ['কর্মী', v('kormiCount'), v('kormiBridhi'), '', v('kormiGhatti'), ''],
                  ['প্রাথমিক সদস্য', v('primaryMemberCount'), v('primaryMemberBridhi'), '', v('primaryMemberGhatti'), ''],
                  ['মোট জনশক্তি', v(['totalManpowerCount', 'totalManpower']), '', '', '', ''],
                  ['সুধী / শুভাকাঙ্ক্ষী', v(['shudhiCount', 'shudhiTarget']), v('shudhiBridhi'), '', v('shudhiGhatti'), ''],
                ],
              ),

              // ------------------------------------------
              // 2. দাওয়াত ও গণসংযোগ
              // ------------------------------------------
              buildSectionHeader('২. দাওয়াত ও গণসংযোগ'),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: buildTable(
                      headers: ['কর্মসূচি', 'সংখ্যা', 'উপস্থিতি (গড়)'],
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3.0),
                        1: const pw.FlexColumnWidth(1.0),
                        2: const pw.FlexColumnWidth(1.5),
                      },
                      rows: [
                        ['ব্যক্তিগত দাওয়াত দান', v('personalDawahCount'), v('personalDawahPresence')],
                        ['গ্রুপ দাওয়াত', v('groupDawahCount'), v('groupDawahPresence')],
                        ['দাওয়াতি মাহফিল / সভা', v('dawahMahfilCount'), v('dawahMahfilPresence')],
                        ['আলোচনা সভা / সাধারণ সভা', v('generalMeetingCount'), v('generalMeetingPresence')],
                        ['ওলামা / সুধী সমাবেশ', v('olamaMeetingCount'), v('olamaMeetingPresence')],
                        ['ওয়াজ / সিরাত মাহফিল', v('siratMahfilCount'), v('siratMahfilPresence')],
                        ['মিছিল / মানববন্ধন / জনসভা', v('rallyCount'), v('rallyPresence')],
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 4),
                  pw.Expanded(
                    child: buildTable(
                      headers: ['কর্মসূচি', 'সংখ্যা', 'উপলক্ষ'],
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3.0),
                        1: const pw.FlexColumnWidth(1.0),
                        2: const pw.FlexColumnWidth(1.5),
                      },
                      rows: [
                        ['পরিচিতি বিতরণ', v('introDistCount'), v('introDistEvent')],
                        ['লিফলেট বিতরণ', v('leafletDistCount'), v('leafletDistEvent')],
                        ['পোস্টার', v('posterCount'), v('posterEvent')],
                        ['দিবস পালন (নামসহ)', v('dayObservanceCount'), v('dayObservanceName')],
                        ['', '', ''],
                        ['', '', ''],
                        ['', '', ''],
                      ],
                    ),
                  ),
                ],
              ),

              // ------------------------------------------
              // 3. সংগঠন
              // ------------------------------------------
              buildSectionHeader('৩. সংগঠন'),
              buildTable(
                headers: ['প্রশাসনিক ইউনিট', 'সংখ্যা', 'সংগঠন', 'কাজ', 'জনশক্তি'],
                columnWidths: {
                  0: const pw.FlexColumnWidth(2.5),
                  1: const pw.FlexColumnWidth(1.0),
                  2: const pw.FlexColumnWidth(1.2),
                  3: const pw.FlexColumnWidth(1.2),
                  4: const pw.FlexColumnWidth(1.2),
                },
                rows: [
                  ['জেলা / মহানগরী', v('districtCount'), v('districtOrg'), v('districtWork'), v('districtManpower')],
                  ['উপজেলা / থানা', v('upazilaCount'), v('upazilaOrg'), v('upazilaWork'), v('upazilaManpower')],
                  ['পৌরসভা', v('pourashavaCount'), v('pourashavaOrg'), '', ''],
                  ['ইউনিয়ন', v('unionCount'), v('unionOrg'), '', ''],
                  ['ওয়ার্ড (মহানগরী/পৌর/ইউনিয়ন)', v('wardCount'), v('wardOrg'), '', ''],
                  ['মসজিদ ভিত্তিক সংগঠন', v('mosqueCount'), v('mosqueOrg'), '', ''],
                ],
              ),

              // ------------------------------------------
              // 4. সভাসমূহ
              // ------------------------------------------
              buildSectionHeader('৪. সভাসমূহ'),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: buildTable(
                      headers: ['বিবরণ', 'সংখ্যা', 'উপস্থিতি (গড়)'],
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3.0),
                        1: const pw.FlexColumnWidth(1.0),
                        2: const pw.FlexColumnWidth(1.5),
                      },
                      rows: [
                        ['জেলা / মহানগরী নির্বাহী সভা', v('distExecMeetingCount'), v('distExecMeetingPres')],
                        ['জেলা / মহানগরী মজলিসে শূরা অধিবেশন', v('distShuraMeetingCount'), v('distShuraMeetingPres')],
                        ['থানা / উপজেলা দায়িত্বশীল সভা', v('thanaDaitoshilMeetingCount'), v('thanaDaitoshilMeetingPres')],
                        ['থানা / উপজেলা নির্বাহী সভা', v('thanaExecMeetingCount'), v('thanaExecMeetingPres')],
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 4),
                  pw.Expanded(
                    child: buildTable(
                      headers: ['বিবরণ', 'সংখ্যা', 'উপস্থিতি (গড়)'],
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3.0),
                        1: const pw.FlexColumnWidth(1.0),
                        2: const pw.FlexColumnWidth(1.5),
                      },
                      rows: [
                        ['ইউনিয়ন শাখার সভা', v('unionMeetingCount'), v('unionMeetingPres')],
                        ['ওয়ার্ড / গ্রাম / মসজিদ শাখার সভা', v('wardMeetingCount'), v('wardMeetingPres')],
                        ['কর্মী সভা / সমাবেশ', v('kormiMeetingCount'), v('kormiMeetingPres')],
                        ['কর্মী সম্মেলন', v('kormiConferenceCount'), v('kormiConferencePres')],
                      ],
                    ),
                  ),
                ],
              ),

              // ------------------------------------------
              // 5. বায়তুলমাল
              // ------------------------------------------
              buildSectionHeader('৫. বায়তুলমাল (আয়-ব্যয়ের বিস্তারিত রিপোর্ট আলাদা কাগজে)'),
              buildTable(
                headers: ['মোট আয়', 'মোট ব্যয়', 'উর্ধ্বতন কোটা', 'পরিশোধ', 'শুভাকাঙ্ক্ষী সংখ্যা', 'শুভাকাঙ্ক্ষী আয়'],
                columnWidths: {
                  0: const pw.FlexColumnWidth(1.5),
                  1: const pw.FlexColumnWidth(1.5),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(1.5),
                  4: const pw.FlexColumnWidth(1.8),
                  5: const pw.FlexColumnWidth(1.5),
                },
                rows: [
                  [
                    v('baytulmalIncome'),
                    v('baytulmalExpense'),
                    v('baytulmalQuota'),
                    v('baytulmalPaid'),
                    v(['shudhiCountBaytulmal', 'shudhiCount']),
                    v(['shudhiIncome', 'shudhiBaytulmalIncome']),
                  ],
                ],
              ),
            ],
          );
        },
      ),
    );

    // ==========================================
    // PAGE 2: শাখার রিপোর্ট ফরম (পৃষ্ঠা ২)
    // ==========================================
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // ------------------------------------------
              // 6. সফর
              // ------------------------------------------
              buildSectionHeader('৬. সফর'),
              buildTable(
                headers: ['সফর', 'সংখ্যা', 'তারিখ, স্থান ও উপলক্ষ'],
                columnWidths: {
                  0: const pw.FlexColumnWidth(2.0),
                  1: const pw.FlexColumnWidth(1.0),
                  2: const pw.FlexColumnWidth(5.0),
                },
                rows: [
                  ['উর্ধ্বতন', v('upperSafarCount'), v('upperSafarDetails')],
                  ['স্থানীয় শাখা', v('localSafarCount'), v('localSafarDetails')],
                ],
              ),

              // ------------------------------------------
              // 7. প্রশিক্ষণ
              // ------------------------------------------
              buildSectionHeader('৭. প্রশিক্ষণ'),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: buildTable(
                      headers: ['বিবরণ', 'সংখ্যা', 'উপস্থিতি (গড়)'],
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3.0),
                        1: const pw.FlexColumnWidth(1.0),
                        2: const pw.FlexColumnWidth(1.5),
                      },
                      rows: [
                        ['তরবিয়তী মজলিস', v('torbiotMajlisCount'), v('torbiotMajlisPres')],
                        ['তরবিয়তী সভা', v('torbiotMeetingCount'), v('torbiotMeetingPres')],
                        ['তরবিয়তী সফর', v('torbiotSafarCount'), v('torbiotSafarPres')],
                        ['সদস্য সভা', v('sodossoMeetingCount'), v('sodossoMeetingPres')],
                        ['শবগুজারি', v('shobgujariCount'), v('shobgujariPres')],
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 4),
                  pw.Expanded(
                    child: buildTable(
                      headers: ['বিবরণ', 'সংখ্যা', 'উপস্থিতি (গড়)'],
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3.0),
                        1: const pw.FlexColumnWidth(1.0),
                        2: const pw.FlexColumnWidth(1.5),
                      },
                      rows: [
                        ['সামষ্টিক পাঠ', v('samostikPathCount'), v('samostikPathPres')],
                        ['কুরআন-হাদীস শিক্ষা সভা', v('quranEducCount'), v('quranEducPres')],
                        ['হাদিস পাঠ', v('hadithPathCount'), v('hadithPathPres')],
                        ['পারিবারিক তালিম', v('familyTalimCount'), v('familyTalimPres')],
                        ['', '', ''],
                      ],
                    ),
                  ),
                ],
              ),

              // ------------------------------------------
              // 8. দফতর
              // ------------------------------------------
              buildSectionHeader('৮. দফতর'),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: buildTable(
                      headers: ['বিবরণ', 'সংখ্যা', 'বিষয়'],
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3.0),
                        1: const pw.FlexColumnWidth(1.0),
                        2: const pw.FlexColumnWidth(2.0),
                      },
                      rows: [
                        ['সার্কুলার প্রাপ্তি', v('circularRecCount'), ''],
                        ['সার্কুলার প্রেরণ', v('circularSendCount'), ''],
                        ['যোগাযোগ', '', ''],
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 4),
                  pw.Expanded(
                    child: buildTable(
                      headers: ['বিবরণ', 'সংখ্যা', 'বিষয়'],
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3.0),
                        1: const pw.FlexColumnWidth(1.0),
                        2: const pw.FlexColumnWidth(2.0),
                      },
                      rows: [
                        ['চিঠি প্রেরণ', v('letterSendCount'), ''],
                        ['চিঠি প্রাপ্তি', v('letterRecCount'), ''],
                        ['অন্যান্য', '', ''],
                      ],
                    ),
                  ),
                ],
              ),

              // ------------------------------------------
              // 9. প্রচার
              // ------------------------------------------
              buildSectionHeader('৯. প্রচার'),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: buildTable(
                      headers: ['বিবরণ', 'সংখ্যা', 'বিষয়', 'ছাপানো'],
                      columnWidths: {
                        0: const pw.FlexColumnWidth(2.5),
                        1: const pw.FlexColumnWidth(1.0),
                        2: const pw.FlexColumnWidth(1.5),
                        3: const pw.FlexColumnWidth(1.0),
                      },
                      rows: [
                        ['সংবাদ বিজ্ঞপ্তি', v('pressReleaseCount'), '', ''],
                        ['বিবৃতি / বাণী', v('statementCount'), '', ''],
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 4),
                  pw.Expanded(
                    child: buildTable(
                      headers: ['বিবরণ', 'সংখ্যা', 'বিষয়'],
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3.0),
                        1: const pw.FlexColumnWidth(1.0),
                        2: const pw.FlexColumnWidth(2.0),
                      },
                      rows: [
                        ['সংবাদ সম্মেলন', '', ''],
                        ['', '', ''],
                      ],
                    ),
                  ),
                ],
              ),

              // ------------------------------------------
              // 10. প্রকাশনা
              // ------------------------------------------
              buildSectionHeader('১০. প্রকাশনা'),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: buildTable(
                      headers: ['বিবরণ', 'সংখ্যা', 'উপলক্ষ'],
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3.0),
                        1: const pw.FlexColumnWidth(1.0),
                        2: const pw.FlexColumnWidth(2.0),
                      },
                      rows: [
                        ['পোস্টার', v('posterPubCount'), ''],
                        ['লিফলেট', v('leafletPubCount'), ''],
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 4),
                  pw.Expanded(
                    child: buildTable(
                      headers: ['বিবরণ', 'সংখ্যা', 'উপলক্ষ'],
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3.0),
                        1: const pw.FlexColumnWidth(1.0),
                        2: const pw.FlexColumnWidth(2.0),
                      },
                      rows: [
                        ['দাওয়াত কার্ড', '', ''],
                        ['', '', ''],
                      ],
                    ),
                  ),
                ],
              ),

              // ------------------------------------------
              // 11. পাঠাগার
              // ------------------------------------------
              buildSectionHeader('১১. পাঠাগার'),
              buildTable(
                headers: ['পাঠাগার সংখ্যা', 'বই সংখ্যা', 'পঠিত বই সংখ্যা', 'পাঠক সংখ্যা'],
                columnWidths: {
                  0: const pw.FlexColumnWidth(1.5),
                  1: const pw.FlexColumnWidth(1.5),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(1.5),
                },
                rows: [
                  [v('libraryCount'), v('bookCount'), v('readBookCount'), v('readerCount')],
                ],
              ),

              // ------------------------------------------
              // 12. সমাজকল্যাণ (বিস্তারিত আলাদা কাগজে)
              // ------------------------------------------
              buildSectionHeader('১২. সমাজকল্যাণ (বিস্তারিত আলাদা কাগজে)'),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 4,
                    child: buildTable(
                      headers: ['আয়ের উৎস', 'আয়ের পরিমাণ'],
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3.0),
                        1: const pw.FlexColumnWidth(1.5),
                      },
                      rows: [
                        ['নিয়মিত অনুদান', v('regDonation')],
                        ['এককালীন অনুদান', ''],
                        ['যাকাত (শরীয়ত নির্ধারিত খাতে যাকাতের অর্থ ব্যয় হবে)', v('zakatDonation')],
                        ['মোট আয়', v('totalSocialIncome')],
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 4),
                  pw.Expanded(
                    flex: 6,
                    child: buildTable(
                      headers: ['কার্যক্রম', 'ব্যয়ের পরিমাণ', 'কার্যক্রম', 'ব্যয়ের পরিমাণ'],
                      columnWidths: {
                        0: const pw.FlexColumnWidth(2.0),
                        1: const pw.FlexColumnWidth(1.2),
                        2: const pw.FlexColumnWidth(2.0),
                        3: const pw.FlexColumnWidth(1.2),
                      },
                      rows: [
                        ['চিকিৎসা সেবা', v('medService'), 'পুনর্বাসন সহায়তা', ''],
                        ['ঋণ পরিশোধ', '', 'ত্রাণ তৎপরতা', v('reliefSupport')],
                        ['করজে হাসানা', '', 'অন্যান্য সহায়তা', ''],
                        ['মোট ব্যয়', v('totalSocialExpense'), '', ''],
                      ],
                    ),
                  ),
                ],
              ),

              // ------------------------------------------
              // 13. রাজনৈতিক ও অন্যান্য রিপোর্ট
              // ------------------------------------------
              buildSectionHeader('১৩. রাজনৈতিক ও অন্যান্য রিপোর্ট পৃথক কাগজে'),

              // ------------------------------------------
              // 14. মন্তব্য (সমস্যা ও সম্ভাবনা উল্লেখসহ)
              // ------------------------------------------
              buildSectionHeader('১৪. মন্তব্য (সমস্যা ও সম্ভাবনা উল্লেখসহ)'),
              pw.Container(
                width: double.infinity,
                height: 40,
                padding: const pw.EdgeInsets.all(3),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey700, width: 0.35),
                ),
                child: PdfExportService.bWidget(
                  v(['comments', 'remarks']).isNotEmpty ? v(['comments', 'remarks']) : '',
                  fontSize: 7.5,
                ),
              ),

              pw.SizedBox(height: 6),

              // BOTTOM SIGNATURES
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 4, bottom: 4),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    PdfExportService.bWidget('তারিখ: ....................', fontSize: 8.5),
                    PdfExportService.bWidget('সভাপতি / সম্পাদকের স্বাক্ষর: ....................', fontSize: 8.5),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    if (pdfDocument != null) return Uint8List(0);
    return pdf.save();
  }

  static Future<void> printOrDownloadPdf(
    BuildContext context,
    Map<String, dynamic> data, {
    String shakhaName = '',
    String month = '',
    String year = '',
  }) async {
    final pdfBytes = await generatePdfBytes(
      data,
      shakhaName: shakhaName,
      month: month,
      year: year,
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'Shakhar_Report_${shakhaName.isNotEmpty ? shakhaName : 'form'}.pdf',
    );
  }
}
