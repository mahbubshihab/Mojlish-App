import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';

/// খেলাফত মজলিস — শাখার রিপোর্ট ফরম (২ পৃষ্ঠা) অফিশিয়াল PDF সার্ভিস
class KhelafatBranchReportPdfService {
  static Future<Uint8List> generatePdfBytes({
    required String shakhaName,
    required String month,
    required String year,
    required Map<String, dynamic> data,
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

    // PAGE 1: শাখার রিপোর্ট ফরম (পৃষ্ঠা ১)
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Top Header
              PdfExportService.bWidget('বিসমিল্লাহির রাহমানির রাহীম', fontSize: 9.5),
              pw.SizedBox(height: 2),
              PdfExportService.bWidget('শাখার রিপোর্ট ফরম', fontSize: 14, fontWeight: pw.FontWeight.bold),
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
                  PdfExportService.bWidget('খেলাফত মজলিস', fontSize: 22, fontWeight: pw.FontWeight.bold),
                ],
              ),
              pw.SizedBox(height: 2),
              PdfExportService.bWidget('কেন্দ্রীয় কার্যালয়: ১৬ বিজয়নগর, (৫ম তলা), ঢাকা-১০০০ | ফোন: ৯৫৮৫৩২১', fontSize: 8.5),
              pw.SizedBox(height: 10),

              // Info Box: শাখা, মাস, সন
              pw.Container(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    PdfExportService.bWidget('শাখা: ${shakhaName.isEmpty ? "........................" : shakhaName}', fontSize: 10.5, fontWeight: pw.FontWeight.bold),
                    PdfExportService.bWidget('মাস: ${month.isEmpty ? "........................" : month}', fontSize: 10.5, fontWeight: pw.FontWeight.bold),
                    PdfExportService.bWidget('সন: ${year.isEmpty ? "........................" : year}', fontSize: 10.5, fontWeight: pw.FontWeight.bold),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),

              // 1. জনশক্তি (Table)
              _buildSectionHeader('জনশক্তি'),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2.5),
                  1: pw.FlexColumnWidth(1.2),
                  2: pw.FlexColumnWidth(1.2),
                  3: pw.FlexColumnWidth(2),
                  4: pw.FlexColumnWidth(1.2),
                  5: pw.FlexColumnWidth(2),
                },
                children: [
                  _buildTableHeader(['জনশক্তি', 'সংখ্যা', 'বৃদ্ধি', 'কারণ', 'ঘাটতি', 'কারণ']),
                  _buildManpowerRow('সদস্য', data['sodossoCount'] ?? '', data['sodossoBridhi'] ?? '', data['sodossoBridhiReason'] ?? '', data['sodossoGhatti'] ?? '', data['sodossoGhattiReason'] ?? ''),
                  _buildManpowerRow('সদস্য প্রার্থী', data['sodossoPrarthiCount'] ?? '', data['sodossoPrarthiBridhi'] ?? '', data['sodossoPrarthiBridhiReason'] ?? '', data['sodossoPrarthiGhatti'] ?? '', data['sodossoPrarthiGhattiReason'] ?? ''),
                  _buildManpowerRow('কর্মী', data['kormiCount'] ?? '', data['kormiBridhi'] ?? '', '', data['kormiGhatti'] ?? '', ''),
                  _buildManpowerRow('প্রাথমিক সদস্য', data['primaryMemberCount'] ?? '', data['primaryMemberBridhi'] ?? '', '', data['primaryMemberGhatti'] ?? '', ''),
                  _buildManpowerRow('মোট জনশক্তি', data['totalManpowerCount'] ?? '', '', '', '', '', isBold: true),
                  _buildManpowerRow('সুধী / শুভাকাঙ্ক্ষী', data['shudhiCount'] ?? '', data['shudhiBridhi'] ?? '', '', data['shudhiGhatti'] ?? '', ''),
                ],
              ),
              pw.SizedBox(height: 8),

              // 2. দাওয়াত ও গণসংযোগ (Table)
              _buildSectionHeader('দাওয়াত ও গণসংযোগ'),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(4),
                        1: pw.FlexColumnWidth(1.5),
                        2: pw.FlexColumnWidth(2),
                      },
                      children: [
                        _buildTableHeader(['কর্মসূচি', 'সংখ্যা', 'উপস্থিতি (গড়)']),
                        _buildMeetingRow('ব্যক্তিগত দাওয়াত দান', data['personalDawahCount'] ?? '', data['personalDawahPresence'] ?? ''),
                        _buildMeetingRow('গ্রুপ দাওয়াত', data['groupDawahCount'] ?? '', data['groupDawahPresence'] ?? ''),
                        _buildMeetingRow('দাওয়াতি মাহফিল / সভা', data['dawahMahfilCount'] ?? '', data['dawahMahfilPresence'] ?? ''),
                        _buildMeetingRow('আলোচনা সভা / সাধারণ সভা', data['generalMeetingCount'] ?? '', data['generalMeetingPresence'] ?? ''),
                        _buildMeetingRow('ওলামা / সুধী সমাবেশ', data['olamaMeetingCount'] ?? '', data['olamaMeetingPresence'] ?? ''),
                        _buildMeetingRow('ওয়াজ / সিরাত মাহফিল', data['siratMahfilCount'] ?? '', data['siratMahfilPresence'] ?? ''),
                        _buildMeetingRow('মিছিল / মানববন্ধন / জনসভা', data['rallyCount'] ?? '', data['rallyPresence'] ?? ''),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(4),
                        1: pw.FlexColumnWidth(1.5),
                        2: pw.FlexColumnWidth(2),
                      },
                      children: [
                        _buildTableHeader(['কর্মসূচি', 'সংখ্যা', 'উপলক্ষ']),
                        _buildMeetingRow('পরিচিতি বিতরণ', data['introDistCount'] ?? '', data['introDistEvent'] ?? ''),
                        _buildMeetingRow('লিফলেট বিতরণ', data['leafletDistCount'] ?? '', data['leafletDistEvent'] ?? ''),
                        _buildMeetingRow('পোস্টার', data['posterCount'] ?? '', data['posterEvent'] ?? ''),
                        _buildMeetingRow('দিবস পালন (নামসহ)', data['dayObservanceCount'] ?? '', data['dayObservanceName'] ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),

              // 3. সংগঠন (Table)
              _buildSectionHeader('সংগঠন'),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(3),
                  1: pw.FlexColumnWidth(1.5),
                  2: pw.FlexColumnWidth(2),
                  3: pw.FlexColumnWidth(2),
                  4: pw.FlexColumnWidth(2),
                },
                children: [
                  _buildTableHeader(['প্রশাসনিক ইউনিট', 'সংখ্যা', 'সংগঠন', 'কাজ', 'জনশক্তি']),
                  _buildOrgRow('জেলা / মহানগরী', data['districtCount'] ?? '', data['districtOrg'] ?? '', data['districtWork'] ?? '', data['districtManpower'] ?? ''),
                  _buildOrgRow('উপজেলা / থানা', data['upazilaCount'] ?? '', data['upazilaOrg'] ?? '', data['upazilaWork'] ?? '', data['upazilaManpower'] ?? ''),
                  _buildOrgRow('পৌরসভা', data['pourashavaCount'] ?? '', data['pourashavaOrg'] ?? '', '', ''),
                  _buildOrgRow('ইউনিয়ন', data['unionCount'] ?? '', data['unionOrg'] ?? '', '', ''),
                  _buildOrgRow('ওয়ার্ড (মহানগরী/পৌর/ইউনিয়ন)', data['wardCount'] ?? '', data['wardOrg'] ?? '', '', ''),
                  _buildOrgRow('মসজিদ ভিত্তিক সংগঠন', data['mosqueCount'] ?? '', data['mosqueOrg'] ?? '', '', ''),
                ],
              ),
              pw.SizedBox(height: 8),

              // 4. সভাসমূহ (Table)
              _buildSectionHeader('সভাসমূহ'),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(4),
                        1: pw.FlexColumnWidth(1.5),
                        2: pw.FlexColumnWidth(2),
                      },
                      children: [
                        _buildTableHeader(['বিবরণ', 'সংখ্যা', 'উপস্থিতি (গড়)']),
                        _buildMeetingRow('জেলা / মহানগরী নির্বাহী সভা', data['distExecMeetingCount'] ?? '', data['distExecMeetingPres'] ?? ''),
                        _buildMeetingRow('জেলা / মহানগরী শূরা অধিবেশন', data['distShuraMeetingCount'] ?? '', data['distShuraMeetingPres'] ?? ''),
                        _buildMeetingRow('থানা / উপজেলা দায়িত্বশীল সভা', data['thanaDaitoshilMeetingCount'] ?? '', data['thanaDaitoshilMeetingPres'] ?? ''),
                        _buildMeetingRow('থানা / উপজেলা নির্বাহী সভা', data['thanaExecMeetingCount'] ?? '', data['thanaExecMeetingPres'] ?? ''),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(4),
                        1: pw.FlexColumnWidth(1.5),
                        2: pw.FlexColumnWidth(2),
                      },
                      children: [
                        _buildTableHeader(['বিবরণ', 'সংখ্যা', 'উপস্থিতি (গড়)']),
                        _buildMeetingRow('ইউনিয়ন শাখার সভা', data['unionMeetingCount'] ?? '', data['unionMeetingPres'] ?? ''),
                        _buildMeetingRow('ওয়ার্ড / গ্রাম / মসজিদ শাখার সভা', data['wardMeetingCount'] ?? '', data['wardMeetingPres'] ?? ''),
                        _buildMeetingRow('কর্মী সভা / সমাবেশ', data['kormiMeetingCount'] ?? '', data['kormiMeetingPres'] ?? ''),
                        _buildMeetingRow('কর্মী সম্মেলন', data['kormiConferenceCount'] ?? '', data['kormiConferencePres'] ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),

              // 5. বায়তুলমাল (Table)
              _buildSectionHeader('বায়তুলমাল (আয়-ব্যয়ের বিস্তারিত রিপোর্ট আলাদা কাগজে)'),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(2),
                  2: pw.FlexColumnWidth(2),
                  3: pw.FlexColumnWidth(2),
                  4: pw.FlexColumnWidth(2),
                  5: pw.FlexColumnWidth(2),
                },
                children: [
                  _buildTableHeader(['মোট আয়', 'মোট ব্যয়', 'উর্ধ্বতন কোটা', 'পরিশোধ', 'শুভাকাঙ্ক্ষী সংখ্যা', 'শুভাকাঙ্ক্ষী আয়']),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(data['baytulmalIncome'] ?? '', fontSize: 8.5, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(data['baytulmalExpense'] ?? '', fontSize: 8.5, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(data['baytulmalQuota'] ?? '', fontSize: 8.5, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(data['baytulmalPaid'] ?? '', fontSize: 8.5, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(data['shudhiCount'] ?? '', fontSize: 8.5, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(data['shudhiIncome'] ?? '', fontSize: 8.5, textAlign: pw.TextAlign.center)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // PAGE 2: সফর, প্রশিক্ষণ, দফতর, প্রচার, প্রকাশনা, পাঠাগার, সমাজকল্যাণ, মন্তব্য (পৃষ্ঠা ২)
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.SizedBox(height: 5),

              // 1. সফর (Table)
              _buildSectionHeader('সফর'),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(1.5),
                  2: pw.FlexColumnWidth(6.5),
                },
                children: [
                  _buildTableHeader(['সফর', 'সংখ্যা', 'তারিখ, স্থান ও উপলক্ষ']),
                  _buildSafarDetailRow('উর্ধ্বতন', data['upperSafarCount'] ?? '', data['upperSafarDetails'] ?? ''),
                  _buildSafarDetailRow('স্থানীয় শাখা', data['localSafarCount'] ?? '', data['localSafarDetails'] ?? ''),
                ],
              ),
              pw.SizedBox(height: 8),

              // 2. প্রশিক্ষণ (Table)
              _buildSectionHeader('প্রশিক্ষণ'),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(4),
                        1: pw.FlexColumnWidth(1.5),
                        2: pw.FlexColumnWidth(2),
                      },
                      children: [
                        _buildTableHeader(['বিবরণ', 'সংখ্যা', 'উপস্থিতি (গড়)']),
                        _buildMeetingRow('তরবিয়তী মজলিস', data['torbiotMajlisCount'] ?? '', data['torbiotMajlisPres'] ?? ''),
                        _buildMeetingRow('তরবিয়তী সভা', data['torbiotMeetingCount'] ?? '', data['torbiotMeetingPres'] ?? ''),
                        _buildMeetingRow('তরবিয়তী সফর', data['torbiotSafarCount'] ?? '', data['torbiotSafarPres'] ?? ''),
                        _buildMeetingRow('সদস্য সভা', data['sodossoMeetingCount'] ?? '', data['sodossoMeetingPres'] ?? ''),
                        _buildMeetingRow('শবগুজারি', data['shobgujariCount'] ?? '', data['shobgujariPres'] ?? ''),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(4),
                        1: pw.FlexColumnWidth(1.5),
                        2: pw.FlexColumnWidth(2),
                      },
                      children: [
                        _buildTableHeader(['বিবরণ', 'সংখ্যা', 'উপস্থিতি (গড়)']),
                        _buildMeetingRow('সামষ্টিক পাঠ', data['samostikPathCount'] ?? '', data['samostikPathPres'] ?? ''),
                        _buildMeetingRow('কুরআন-হাদীস শিক্ষা সভা', data['quranEducCount'] ?? '', data['quranEducPres'] ?? ''),
                        _buildMeetingRow('হাদীস পাঠ', data['hadithPathCount'] ?? '', data['hadithPathPres'] ?? ''),
                        _buildMeetingRow('পারিবারিক তালিম', data['familyTalimCount'] ?? '', data['familyTalimPres'] ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),

              // 3. দফতর (Table)
              _buildSectionHeader('দফতর'),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(1),
                        2: pw.FlexColumnWidth(2),
                      },
                      children: [
                        _buildTableHeader(['বিবরণ', 'সংখ্যা', 'বিষয়']),
                        _buildOfficeRow('সার্কুলার প্রাপ্তি', data['circularRecCount'] ?? '', data['circularRecSubject'] ?? ''),
                        _buildOfficeRow('সার্কুলার প্রেরণ', data['circularSendCount'] ?? '', data['circularSendSubject'] ?? ''),
                        _buildOfficeRow('যোগাযোগ', data['communicationCount'] ?? '', data['communicationSubject'] ?? ''),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(1),
                        2: pw.FlexColumnWidth(2),
                      },
                      children: [
                        _buildTableHeader(['বিবরণ', 'সংখ্যা', 'বিষয়']),
                        _buildOfficeRow('চিঠি প্রেরণ', data['letterSendCount'] ?? '', data['letterSendSubject'] ?? ''),
                        _buildOfficeRow('চিঠি প্রাপ্তি', data['letterRecCount'] ?? '', data['letterRecSubject'] ?? ''),
                        _buildOfficeRow('অন্যান্য', data['otherOfficeCount'] ?? '', data['otherOfficeSubject'] ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),

              // 4. প্রচার ও প্রকাশনা (Side by side)
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        _buildSectionHeader('প্রচার'),
                        pw.Table(
                          border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                          columnWidths: const {
                            0: pw.FlexColumnWidth(3),
                            1: pw.FlexColumnWidth(1),
                            2: pw.FlexColumnWidth(2),
                          },
                          children: [
                            _buildTableHeader(['বিবরণ', 'সংখ্যা', 'বিষয়']),
                            _buildOfficeRow('সংবাদ বিজ্ঞপ্তি', data['pressReleaseCount'] ?? '', data['pressReleaseSubject'] ?? ''),
                            _buildOfficeRow('বিবৃতি / বাণী', data['statementCount'] ?? '', data['statementSubject'] ?? ''),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        _buildSectionHeader('প্রকাশনা'),
                        pw.Table(
                          border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                          columnWidths: const {
                            0: pw.FlexColumnWidth(3),
                            1: pw.FlexColumnWidth(1),
                            2: pw.FlexColumnWidth(2),
                          },
                          children: [
                            _buildTableHeader(['বিবরণ', 'সংখ্যা', 'উপলক্ষ']),
                            _buildOfficeRow('পোস্টার', data['posterPubCount'] ?? '', data['posterPubEvent'] ?? ''),
                            _buildOfficeRow('লিফলেট', data['leafletPubCount'] ?? '', data['leafletPubEvent'] ?? ''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),

              // 5. পাঠাগার (Table)
              _buildSectionHeader('পাঠাগার'),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2.5),
                  1: pw.FlexColumnWidth(2.5),
                  2: pw.FlexColumnWidth(2.5),
                  3: pw.FlexColumnWidth(2.5),
                },
                children: [
                  _buildTableHeader(['পাঠাগার সংখ্যা', 'বই সংখ্যা', 'পঠিত বই সংখ্যা', 'পাঠক সংখ্যা']),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(data['libraryCount'] ?? '', fontSize: 8.5, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(data['bookCount'] ?? '', fontSize: 8.5, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(data['readBookCount'] ?? '', fontSize: 8.5, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(data['readerCount'] ?? '', fontSize: 8.5, textAlign: pw.TextAlign.center)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),

              // 6. সমাজকল্যাণ (Table)
              _buildSectionHeader('সমাজকল্যাণ (বিস্তারিত আলাদা কাগজে)'),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(3),
                  1: pw.FlexColumnWidth(2),
                  2: pw.FlexColumnWidth(3),
                  3: pw.FlexColumnWidth(2),
                },
                children: [
                  _buildTableHeader(['আয়ের উৎস', 'আয়ের পরিমাণ', 'কার্যক্রম', 'ব্যয়ের পরিমাণ']),
                  _buildSocialRow('নিয়মিত অনুদান', data['regDonation'] ?? '', 'চিকিৎসা সেবা', data['medService'] ?? ''),
                  _buildSocialRow('এককালীন অনুদান', data['onetimeDonation'] ?? '', 'পুনর্বাসন সহায়তা', data['rehabSupport'] ?? ''),
                  _buildSocialRow('যাকাত', data['zakatDonation'] ?? '', 'ত্রাণ তৎপরতা', data['reliefSupport'] ?? ''),
                  _buildSocialRow('মোট আয়', data['socialTotalIncome'] ?? '', 'মোট ব্যয়', data['socialTotalExpense'] ?? '', isBold: true),
                ],
              ),
              pw.SizedBox(height: 10),

              // 7. মন্তব্য (সমস্যা ও সম্ভাবনা উল্লেখসহ)
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: PdfExportService.bWidget('মন্তব্য (সমস্যা ও সম্ভাবনা উল্লেখসহ):', fontSize: 9.5, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 3),
              pw.Container(
                width: double.infinity,
                height: 45,
                padding: const pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey500, width: 0.5)),
                child: PdfExportService.bWidget(data['remarks'] ?? '........................................................................................................................................................', fontSize: 9),
              ),

              pw.Spacer(),

              // Footer Signatures
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  PdfExportService.bWidget('তারিখ: ...........................................', fontSize: 9.5),
                  PdfExportService.bWidget('সভাপতির স্বাক্ষর', fontSize: 9.5, fontWeight: pw.FontWeight.bold),
                ],
              ),
              pw.SizedBox(height: 4),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildSectionHeader(String title) {
    return pw.Container(
      width: double.infinity,
      color: PdfColors.grey300,
      padding: const pw.EdgeInsets.symmetric(vertical: 2.5),
      alignment: pw.Alignment.center,
      child: PdfExportService.bWidget(title, fontSize: 10, fontWeight: pw.FontWeight.bold),
    );
  }

  static pw.TableRow _buildTableHeader(List<String> headers) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey100),
      children: headers.map((h) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(3),
          child: PdfExportService.bWidget(h, fontSize: 8.5, fontWeight: pw.FontWeight.bold, textAlign: pw.TextAlign.center),
        );
      }).toList(),
    );
  }

  static pw.TableRow _buildManpowerRow(String label, String c, String b, String br, String g, String gr, {bool isBold = false}) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(label, fontSize: 8.5, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(c, fontSize: 8.5, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(b, fontSize: 8.5, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(br, fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(g, fontSize: 8.5, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(gr, fontSize: 8.5)),
      ],
    );
  }

  static pw.TableRow _buildMeetingRow(String label, String count, String pres) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(label, fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(count, fontSize: 8.5, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(pres, fontSize: 8.5, textAlign: pw.TextAlign.center)),
      ],
    );
  }

  static pw.TableRow _buildOrgRow(String label, String count, String org, String work, String manpower) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(label, fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(count, fontSize: 8.5, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(org, fontSize: 8.5, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(work, fontSize: 8.5, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(manpower, fontSize: 8.5, textAlign: pw.TextAlign.center)),
      ],
    );
  }

  static pw.TableRow _buildSafarDetailRow(String label, String count, String details) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(label, fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(count, fontSize: 8.5, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(details, fontSize: 8.5)),
      ],
    );
  }

  static pw.TableRow _buildOfficeRow(String label, String count, String subject) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(label, fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(count, fontSize: 8.5, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(subject, fontSize: 8.5)),
      ],
    );
  }

  static pw.TableRow _buildSocialRow(String u1, String p1, String k2, String p2, {bool isBold = false}) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(u1, fontSize: 8.5, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(p1, fontSize: 8.5, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(k2, fontSize: 8.5, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(p2, fontSize: 8.5, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, textAlign: pw.TextAlign.center)),
      ],
    );
  }
}
