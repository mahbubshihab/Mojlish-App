import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';

/// খেলাফত মজলিস — শাখার পরিকল্পনা ফরম (২ পৃষ্ঠা) অফিশিয়াল PDF সার্ভিস
class KhelafatBranchPlanPdfService {
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

    // PAGE 1: শাখার পরিকল্পনা ফরম (পৃষ্ঠা ১)
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
              PdfExportService.bWidget('শাখার পরিকল্পনা ফরম', fontSize: 14, fontWeight: pw.FontWeight.bold),
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
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(3.5),
                  1: pw.FlexColumnWidth(2),
                  2: pw.FlexColumnWidth(4.5),
                },
                children: [
                  _buildTableHeader(['জনশক্তি', 'বৃদ্ধি (সংখ্যা)', 'নাম (বিস্তারিত আলাদা কাগজে)']),
                  _buildPlanRow('সদস্য (মানে উন্নীতকরণ)', data['sodossoTarget'] ?? '', data['sodossoNames'] ?? ''),
                  _buildPlanRow('সদস্য প্রার্থী (মানে উন্নীতকরণ)', data['sodossoPrarthiTarget'] ?? '', data['sodossoPrarthiNames'] ?? ''),
                  _buildPlanRow('কর্মী', data['kormiTarget'] ?? '', data['kormiNames'] ?? ''),
                  _buildPlanRow('প্রাথমিক সদস্য', data['primaryMemberTarget'] ?? '', data['primaryMemberNames'] ?? ''),
                  _buildPlanRow('মোট জনশক্তি', data['totalManpowerTarget'] ?? '', '', isBold: true),
                  _buildPlanRow('সুধী / শুভাকাঙ্ক্ষী', data['shudhiTarget'] ?? '', data['shudhiNames'] ?? ''),
                ],
              ),
              pw.SizedBox(height: 8),

              // 2. দাওয়াত ও গণসংযোগ (Table)
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(3),
                  1: pw.FlexColumnWidth(1.2),
                  2: pw.FlexColumnWidth(2),
                  3: pw.FlexColumnWidth(1.5),
                  4: pw.FlexColumnWidth(1.5),
                  5: pw.FlexColumnWidth(1.5),
                  6: pw.FlexColumnWidth(2),
                },
                children: [
                  _buildTableHeader(['দাওয়াত ও গণসংযোগ কর্মসূচি', 'সংখ্যা', 'তারিখ ও সময় / উপলক্ষ', 'স্থান', 'উপস্থিতি (টার্গেট)', 'মেহমান', 'বাস্তবায়নের দায়িত্ব']),
                  _buildDawahRow('ব্যক্তিগত দাওয়াত দান', data['personalDawahCount'] ?? ''),
                  _buildDawahRow('গ্রুপ দাওয়াত', data['groupDawahCount'] ?? ''),
                  _buildDawahRow('দাওয়াতি মাহফিল / সভা', data['dawahMahfilCount'] ?? ''),
                  _buildDawahRow('আলোচনা সভা / সাধারণ সভা', data['generalMeetingCount'] ?? ''),
                  _buildDawahRow('ওলামা / সুধী সমাবেশ', data['olamaMeetingCount'] ?? ''),
                  _buildDawahRow('ওয়াজ / সিরাত মাহফিল', data['siratMahfilCount'] ?? ''),
                  _buildDawahRow('মিছিল / মানব বন্ধন / জনসভা', data['rallyCount'] ?? ''),
                  _buildDawahRow('পরিচিতি বিতরণ', data['introDistCount'] ?? ''),
                  _buildDawahRow('লিফলেট বিতরণ', data['leafletDistCount'] ?? ''),
                  _buildDawahRow('পোস্টার', data['posterCount'] ?? ''),
                  _buildDawahRow('দিবস পালন (নামসহ)', data['dayObservanceCount'] ?? ''),
                ],
              ),
              pw.SizedBox(height: 8),

              // 3. সংগঠন (Table)
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2.5),
                  1: pw.FlexColumnWidth(1.5),
                  2: pw.FlexColumnWidth(2),
                  3: pw.FlexColumnWidth(2),
                  4: pw.FlexColumnWidth(1.5),
                  5: pw.FlexColumnWidth(2),
                  6: pw.FlexColumnWidth(2),
                },
                children: [
                  _buildTableHeader(['প্রশাসনিক ইউনিট', 'সংগঠন (পুনর্গঠন/বৃদ্ধি)', 'নাম', 'বাস্তবায়নের দায়িত্ব', 'কাজ সৃষ্টি', 'নাম', 'বাস্তবায়নের দায়িত্ব']),
                  _buildOrgRow('জেলা / মহানগরী', data['districtOrg'] ?? ''),
                  _buildOrgRow('উপজেলা / থানা', data['upazilaOrg'] ?? ''),
                  _buildOrgRow('পৌরসভা', data['pourashavaOrg'] ?? ''),
                  _buildOrgRow('ইউনিয়ন', data['unionOrg'] ?? ''),
                  _buildOrgRow('ওয়ার্ড (মহানগরী/পৌর/ইউনিয়ন)', data['wardOrg'] ?? ''),
                  _buildOrgRow('মসজিদ ভিত্তিক সংগঠন', data['mosqueOrg'] ?? ''),
                ],
              ),
              pw.SizedBox(height: 8),

              // 4. বায়তুলমাল (Table)
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2.5),
                  1: pw.FlexColumnWidth(2.5),
                  2: pw.FlexColumnWidth(2.5),
                  3: pw.FlexColumnWidth(2.5),
                },
                children: [
                  _buildTableHeader(['বায়তুলমাল', 'মোট আয়', 'মোট ব্যয়', 'উর্ধ্বতন কোটা (ধার্যকৃত)']),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget('আয়-ব্যয়ের বিস্তারিত পরিকল্পনা আলাদা কাগজে', fontSize: 8.5)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(data['baytulmalTotalIncome'] ?? '', fontSize: 9, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(data['baytulmalTotalExpense'] ?? '', fontSize: 9, textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(data['baytulmalQuota'] ?? '', fontSize: 9, textAlign: pw.TextAlign.center)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),

              // 5. সফর (Table)
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(1.5),
                  1: pw.FlexColumnWidth(1.5),
                  2: pw.FlexColumnWidth(3),
                  3: pw.FlexColumnWidth(2.5),
                  4: pw.FlexColumnWidth(2.5),
                },
                children: [
                  _buildTableHeader(['সফর', 'তারিখ', 'উপলক্ষ', 'স্থান', 'মেহমান']),
                  _buildSafarRow(data['safarDate'] ?? '', data['safarEvent'] ?? '', data['safarPlace'] ?? '', data['safarGuest'] ?? ''),
                ],
              ),
            ],
          );
        },
      ),
    );

    // PAGE 2: সভাসমূহ, প্রশিক্ষণ, দফতর, প্রচার, প্রকাশনা, পাঠাগার, সমাজকল্যাণ (পৃষ্ঠা ২)
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.SizedBox(height: 5),

              // 1. সভাসমূহ (Table)
              _buildSectionTitle('সভাসমূহ'),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(3.5),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(2),
                  3: pw.FlexColumnWidth(1.5),
                  4: pw.FlexColumnWidth(1.5),
                  5: pw.FlexColumnWidth(1.5),
                  6: pw.FlexColumnWidth(2),
                },
                children: [
                  _buildTableHeader(['কর্মসূচি', 'সংখ্যা', 'তারিখ ও সময় / উপলক্ষ', 'স্থান', 'উপস্থিতি (টার্গেট)', 'মেহমান', 'বাস্তবায়নের দায়িত্ব']),
                  _buildMeetingRow('জেলা / মহানগরী নির্বাহী সভা', data['distExecMeeting'] ?? ''),
                  _buildMeetingRow('জেলা / মহানগরী মজলিসে শূরা অধিবেশন', data['distShuraMeeting'] ?? ''),
                  _buildMeetingRow('থানা / উপজেলা দায়িত্বশীল সভা', data['thanaDaitoshilMeeting'] ?? ''),
                  _buildMeetingRow('থানা / উপজেলা নির্বাহী সভা', data['thanaExecMeeting'] ?? ''),
                  _buildMeetingRow('ইউনিয়ন শাখার সভা', data['unionMeeting'] ?? ''),
                  _buildMeetingRow('ওয়ার্ড / গ্রাম / মসজিদ শাখার সভা', data['wardMeeting'] ?? ''),
                  _buildMeetingRow('কর্মী সভা / সমাবেশ', data['kormiMeeting'] ?? ''),
                  _buildMeetingRow('কর্মী সম্মেলন', data['kormiConference'] ?? ''),
                ],
              ),
              pw.SizedBox(height: 8),

              // 2. প্রশিক্ষণ (Table)
              _buildSectionTitle('প্রশিক্ষণ'),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(3.5),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(2),
                  3: pw.FlexColumnWidth(1.5),
                  4: pw.FlexColumnWidth(1.5),
                  5: pw.FlexColumnWidth(1.5),
                  6: pw.FlexColumnWidth(2),
                },
                children: [
                  _buildTableHeader(['বিবরণ', 'সংখ্যা', 'তারিখ ও সময় / উপলক্ষ', 'স্থান', 'উপস্থিতি (টার্গেট)', 'মেহমান', 'বাস্তবায়নের দায়িত্ব']),
                  _buildMeetingRow('তরবিয়তী মজলিস', data['torbiotMajlis'] ?? ''),
                  _buildMeetingRow('তরবিয়তী সভা', data['torbiotMeeting'] ?? ''),
                  _buildMeetingRow('তরবিয়তী সফর', data['torbiotSafar'] ?? ''),
                  _buildMeetingRow('সদস্য সভা', data['sodossoMeeting'] ?? ''),
                  _buildMeetingRow('শবগুজারি', data['shobgujari'] ?? ''),
                  _buildMeetingRow('সামষ্টিক পাঠ', data['samostikPath'] ?? ''),
                  _buildMeetingRow('কুরআন-হাদীস শিক্ষা সভা', data['quranEduc'] ?? ''),
                  _buildMeetingRow('হাদীস পাঠ', data['hadithPath'] ?? ''),
                  _buildMeetingRow('পারিবারিক তালিম', data['familyTalim'] ?? ''),
                ],
              ),
              pw.SizedBox(height: 8),

              // 3. দফতর ও প্রচার (2 Tables side by side)
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        _buildSectionTitle('দফতর'),
                        pw.Table(
                          border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                          columnWidths: const {
                            0: pw.FlexColumnWidth(3),
                            1: pw.FlexColumnWidth(1),
                            2: pw.FlexColumnWidth(2),
                          },
                          children: [
                            _buildTableHeader(['বিবরণ', 'সংখ্যা', 'বিষয়']),
                            _buildSimpleRow('সার্কুলার প্রেরণ', data['circularCount'] ?? ''),
                            _buildSimpleRow('চিঠি প্রেরণ', data['letterCount'] ?? ''),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        _buildSectionTitle('প্রচার'),
                        pw.Table(
                          border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                          columnWidths: const {
                            0: pw.FlexColumnWidth(3),
                            1: pw.FlexColumnWidth(2),
                          },
                          children: [
                            _buildTableHeader(['বিবরণ', 'মিডিয়ায় প্রেরিত']),
                            _buildSimple2ColRow('সংবাদ বিজ্ঞপ্তি', data['pressReleaseCount'] ?? ''),
                            _buildSimple2ColRow('বিবৃতি / বাণী', data['statementCount'] ?? ''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),

              // 4. প্রকাশনা ও পাঠাগার
              _buildSectionTitle('প্রকাশনা ও পাঠাগার'),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
                columnWidths: const {
                  0: pw.FlexColumnWidth(3),
                  1: pw.FlexColumnWidth(2),
                  2: pw.FlexColumnWidth(3),
                },
                children: [
                  _buildTableHeader(['বিবরণ', 'সংখ্যা', 'উপলক্ষ']),
                  _buildSimpleRow('প্রকাশনা বিক্রি ও বিতরণ', data['publicationSale'] ?? ''),
                  _buildSimpleRow('পাঠাগার বই বৃদ্ধি', data['libraryBookAdd'] ?? ''),
                ],
              ),
              pw.SizedBox(height: 8),

              // 5. সমাজকল্যাণ (Table)
              _buildSectionTitle('সমাজকল্যাণ'),
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
                  _buildIncomeExpenseRow('নিয়মিত অনুদান', data['regDonation'] ?? '', 'চিকিৎসা সেবা', data['medService'] ?? ''),
                  _buildIncomeExpenseRow('এককালীন অনুদান', data['onetimeDonation'] ?? '', 'পুনর্বাসন সহায়তা', data['rehabSupport'] ?? ''),
                  _buildIncomeExpenseRow('যাকাত', data['zakatDonation'] ?? '', 'ত্রাণ তৎপরতা', data['reliefSupport'] ?? ''),
                  _buildIncomeExpenseRow('মোট আয়', data['socialTotalIncome'] ?? '', 'মোট ব্যয়', data['socialTotalExpense'] ?? '', isBold: true),
                ],
              ),

              pw.Spacer(),

              // Footer
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

  static pw.Widget _buildSectionTitle(String title) {
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

  static pw.TableRow _buildPlanRow(String label, String target, String names, {bool isBold = false}) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(label, fontSize: 8.5, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(target, fontSize: 8.5, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(names, fontSize: 8.5)),
      ],
    );
  }

  static pw.TableRow _buildDawahRow(String label, String count) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(label, fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(count, fontSize: 8.5, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
      ],
    );
  }

  static pw.TableRow _buildOrgRow(String label, String val) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(label, fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(val, fontSize: 8.5, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
      ],
    );
  }

  static pw.TableRow _buildSafarRow(String d, String e, String p, String g) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget('সফর কর্মসূচি', fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(d, fontSize: 8.5, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(e, fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(p, fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: PdfExportService.bWidget(g, fontSize: 8.5)),
      ],
    );
  }

  static pw.TableRow _buildMeetingRow(String label, String count) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(label, fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(count, fontSize: 8.5, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
      ],
    );
  }

  static pw.TableRow _buildSimpleRow(String label, String count) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(label, fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(count, fontSize: 8.5, textAlign: pw.TextAlign.center)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget('', fontSize: 8.5)),
      ],
    );
  }

  static pw.TableRow _buildSimple2ColRow(String label, String count) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(label, fontSize: 8.5)),
        pw.Padding(padding: const pw.EdgeInsets.all(2.5), child: PdfExportService.bWidget(count, fontSize: 8.5, textAlign: pw.TextAlign.center)),
      ],
    );
  }

  static pw.TableRow _buildIncomeExpenseRow(String u1, String p1, String k2, String p2, {bool isBold = false}) {
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
