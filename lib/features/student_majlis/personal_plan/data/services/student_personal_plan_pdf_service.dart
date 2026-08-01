import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/pdf_preview_screen.dart';
import '../../domain/entities/personal_plan_entity.dart';

/// বাংলাদেশ ইসলামী ছাত্র মজলিস - ব্যক্তিগত মাসিক পরিকল্পনা PDF জেনারেটর সার্ভিস
/// বিজয় এনকোডিং (SutonnyMJ ফন্ট) ও ওশান ব্লু (#0077B6) ডিজাইনে নির্মিত
class StudentPersonalPlanPdfService {
  static Future<Uint8List> generatePdfBytes(PersonalPlanEntity plan) async {
    final fontRegular = await PdfExportService.loadSutonnyFont();
    final fontBold = await PdfExportService.loadBengaliBoldFont();

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: fontRegular,
        bold: fontBold,
      ),
    );

    final oceanBlue = PdfColor.fromHex('#0077B6');
    final titleBgColor = PdfColor.fromHex('#E0F2FE');

    pw.Widget buildDottedInline({
      required String label,
      required String value,
      String prefix = '■ ',
      String suffix = '',
      int defaultDots = 15,
      double fontSize = 8.5,
    }) {
      final hasValue = value.trim().isNotEmpty;
      final displayVal = hasValue ? value.trim() : ('.' * defaultDots);
      return pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          if (prefix.isNotEmpty)
            PdfExportService.bWidget(
              prefix,
              fontSize: fontSize,
              color: oceanBlue,
              fontWeight: pw.FontWeight.bold,
            ),
          PdfExportService.bWidget(label, fontSize: fontSize),
          pw.SizedBox(width: 2),
          PdfExportService.bWidget(
            displayVal,
            fontSize: fontSize,
            fontWeight: hasValue ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: hasValue ? PdfColors.blue900 : PdfColors.grey600,
          ),
          if (suffix.isNotEmpty) ...[
            pw.SizedBox(width: 2),
            PdfExportService.bWidget(suffix, fontSize: fontSize),
          ],
        ],
      );
    }

    pw.Widget buildSectionHeader(String title) {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(vertical: 2.5, horizontal: 6),
        margin: const pw.EdgeInsets.only(top: 6, bottom: 4),
        decoration: pw.BoxDecoration(
          color: titleBgColor,
          borderRadius: pw.BorderRadius.circular(2),
          border: pw.Border(
            left: pw.BorderSide(color: oceanBlue, width: 3),
          ),
        ),
        child: PdfExportService.bWidget(
          title,
          fontSize: 9.5,
          fontWeight: pw.FontWeight.bold,
          color: oceanBlue,
        ),
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Top Header Title Box
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(vertical: 6),
                decoration: pw.BoxDecoration(
                  color: oceanBlue,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Center(
                  child: PdfExportService.bWidget(
                    'ব্যক্তিগত মাসিক পরিকল্পনা',
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ),
              pw.SizedBox(height: 8),

              // Top Metadata Bar
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F8FAFC'),
                  borderRadius: pw.BorderRadius.circular(4),
                  border: pw.Border.all(color: oceanBlue, width: 0.6),
                ),
                child: pw.Column(
                  children: [
                    pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 3,
                          child: buildDottedInline(label: 'নাম:', value: plan.name, prefix: '', defaultDots: 35),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Expanded(
                          flex: 2,
                          child: buildDottedInline(label: 'শাখা:', value: plan.branch, prefix: '', defaultDots: 25),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 3),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 3,
                          child: buildDottedInline(label: 'দায়িত্ব:', value: plan.responsibility, prefix: '', defaultDots: 35),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Expanded(
                          flex: 1,
                          child: buildDottedInline(label: 'মাস:', value: plan.month, prefix: '', defaultDots: 12),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Expanded(
                          flex: 1,
                          child: buildDottedInline(label: 'সন:', value: plan.year, prefix: '', defaultDots: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 4),

              // 1. অধ্যয়ন
              buildSectionHeader('১. অধ্যয়ন'),
              pw.Row(
                children: [
                  buildDottedInline(label: 'কুরআন : আয়াত সংখ্যা ', value: plan.quranAyatCount, defaultDots: 12),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• সূরা/পারা ', value: plan.quranSuraPara, prefix: '', defaultDots: 30),
                ],
              ),
              pw.SizedBox(height: 3),
              pw.Row(
                children: [
                  pw.SizedBox(width: 10),
                  buildDottedInline(label: '• দারস তৈরি : ', value: plan.quranDarasCount, prefix: '', suffix: 'টি', defaultDots: 6),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• বিষয় ', value: plan.quranDarasTopic, prefix: '', defaultDots: 24),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• মুখস্থ ', value: plan.quranMemorizeAyat, prefix: '', suffix: 'আয়াত', defaultDots: 10),
                ],
              ),
              pw.SizedBox(height: 3),
              pw.Row(
                children: [
                  buildDottedInline(label: 'হাদীস : সংখ্যা ', value: plan.hadithCount, suffix: 'টি', defaultDots: 8),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• হাদীস গ্রন্থ/বিষয় ', value: plan.hadithBookTopic, prefix: '', defaultDots: 35),
                ],
              ),
              pw.SizedBox(height: 3),
              pw.Row(
                children: [
                  pw.SizedBox(width: 10),
                  buildDottedInline(label: '• দারস তৈরি : ', value: plan.hadithDarasCount, prefix: '', suffix: 'টি', defaultDots: 6),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• বিষয় ', value: plan.hadithDarasTopic, prefix: '', defaultDots: 18),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• মুখস্থ ', value: plan.hadithMemorizeCount, prefix: '', suffix: 'টি', defaultDots: 6),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• বিষয় ', value: plan.hadithMemorizeTopic, prefix: '', defaultDots: 18),
                ],
              ),
              pw.SizedBox(height: 3),
              pw.Row(
                children: [
                  buildDottedInline(label: 'ইসলামী সাহিত্য : পৃষ্ঠা সংখ্যা ', value: plan.islamicLiteraturePages, defaultDots: 10),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• বইয়ের নাম ', value: plan.islamicLiteratureBookName, prefix: '', defaultDots: 35),
                ],
              ),
              pw.SizedBox(height: 3),
              pw.Row(
                children: [
                  pw.SizedBox(width: 10),
                  buildDottedInline(label: 'বই/আলোচনা নোট ', value: plan.islamicLiteratureBookNotesPage, prefix: '', suffix: 'পৃষ্ঠা', defaultDots: 16),
                ],
              ),
              pw.SizedBox(height: 3),
              pw.Row(
                children: [
                  buildDottedInline(label: 'পাঠ্য পুস্তক/ক্লাসে অংশগ্রহণ : (গড়ে) ', value: plan.textbookClassAvgHours, suffix: ' ঘণ্টা', defaultDots: 10),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• সময় নির্ধারণ : ', value: plan.textbookClassTime, prefix: '', defaultDots: 16),
                ],
              ),

              // 2. ইবাদত
              buildSectionHeader('২. ইবাদত'),
              pw.Row(
                children: [
                  buildDottedInline(label: 'জামাআতে নামায ', value: plan.jamatNamazWaqt, suffix: 'ওয়াক্ত', defaultDots: 14),
                  pw.SizedBox(width: 10),
                  buildDottedInline(label: '• আত্মবিচার ', value: plan.selfEvaluationDays, prefix: '', suffix: 'দিন', defaultDots: 14),
                ],
              ),
              pw.SizedBox(height: 3),
              buildDottedInline(label: 'নফল ইবাদত ', value: plan.nafalIbadat, defaultDots: 50),

              // 3. দাওয়াতি কাজ
              buildSectionHeader('৩. দাওয়াতি কাজ'),
              pw.Row(
                children: [
                  buildDottedInline(label: 'বন্ধু টার্গেট/যোগাযোগ ', value: plan.friendTargetContactCount, suffix: 'জন', defaultDots: 10),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• নাম (টার্গেট) ', value: plan.friendTargetContactName, prefix: '', defaultDots: 35),
                ],
              ),
              pw.SizedBox(height: 3),
              pw.Row(
                children: [
                  buildDottedInline(label: 'প্রাথমিক সদস্য বৃদ্ধি/যোগাযোগ ', value: plan.primaryMemberIncreaseContactCount, suffix: 'জন', defaultDots: 10),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• নাম (বৃদ্ধি) ', value: plan.primaryMemberIncreaseContactName, prefix: '', defaultDots: 30),
                ],
              ),
              pw.SizedBox(height: 3),
              pw.Row(
                children: [
                  buildDottedInline(label: 'বই/পরিচিতি/স্টিকার বিতরণ ', value: plan.bookIntroStickerDistributionCount, suffix: 'টি', defaultDots: 10),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• ছাত্র পরিক্রমা/Student\'s Review বিতরণ ', value: plan.studentReviewDistributionCount, prefix: '', suffix: 'টি', defaultDots: 10),
                ],
              ),
              pw.SizedBox(height: 3),
              pw.Row(
                children: [
                  buildDottedInline(label: 'শুভাকাঙ্ক্ষী বৃদ্ধি/যোগাযোগ ', value: plan.wellWisherIncreaseContactCount, suffix: 'জন', defaultDots: 10),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• নাম (বৃদ্ধি) ', value: plan.wellWisherIncreaseContactName, prefix: '', defaultDots: 30),
                ],
              ),
              pw.SizedBox(height: 3),
              buildDottedInline(label: 'কার্ড/উপহার/SMS/E-mail/চিঠি/কিশোর পত্রিকা ', value: plan.cardGiftSmsEmailLetterMagazineCount, suffix: 'টি', defaultDots: 25),
              pw.SizedBox(height: 3),
              pw.Row(
                children: [
                  buildDottedInline(label: 'গ্রুপ দাওয়াত ', value: plan.groupDawahCount, suffix: 'বার', defaultDots: 8),
                  pw.SizedBox(width: 10),
                  buildDottedInline(label: 'অন্যান্য দাওয়াতি উপকরণ বিতরণ ', value: plan.otherDawahMaterialsDistribution, defaultDots: 25),
                ],
              ),

              // 4. সাংগঠনিক কাজ
              buildSectionHeader('৪. সাংগঠনিক কাজ'),
              pw.Row(
                children: [
                  buildDottedInline(label: 'কর্মী মানে উন্নীতকরণ ', value: plan.workerStandardUpgradeCount, suffix: 'জন', defaultDots: 10),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• নাম ', value: plan.workerStandardUpgradeName, prefix: '', defaultDots: 35),
                ],
              ),
              pw.SizedBox(height: 3),
              pw.Row(
                children: [
                  buildDottedInline(label: 'সভায় যোগদান ', value: plan.meetingAttendanceCount, suffix: 'টি', defaultDots: 8),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: 'সাংগঠনিক/দাওয়াতি কাজে সময়দান (গড়ে) ', value: plan.orgDawahTimeAvgHours, suffix: 'ঘণ্টা', defaultDots: 10),
                ],
              ),
              pw.SizedBox(height: 3),
              pw.Row(
                children: [
                  buildDottedInline(label: 'বায়তুলমাল প্রদান করা হবে ', value: plan.baytulmalAmount, suffix: 'টাকা', defaultDots: 12),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: 'কর্মী যোগাযোগ ', value: plan.workerContactCount, suffix: 'জন', defaultDots: 10),
                ],
              ),
              pw.SizedBox(height: 3),
              pw.Row(
                children: [
                  pw.SizedBox(width: 10),
                  buildDottedInline(label: 'নাম ', value: plan.workerNames, prefix: '', defaultDots: 50),
                ],
              ),

              // 5. বিবিধ
              buildSectionHeader('৫. বিবিধ'),
              pw.Row(
                children: [
                  buildDottedInline(label: 'দৈনিক /অন্যান্য পত্রিকা পাঠ (গড়ে) ', value: plan.dailyOtherNewspaperAvgHours, suffix: 'ঘণ্টা', defaultDots: 10),
                  pw.SizedBox(width: 10),
                  buildDottedInline(label: 'শরীরচর্চা ', value: plan.physicalExerciseDays, suffix: 'দিন', defaultDots: 10),
                ],
              ),
              pw.SizedBox(height: 3),
              buildDottedInline(label: 'কারিগরি/কম্পিউটার/ভাষা শিক্ষায় সময়দান (গড়ে) ', value: plan.techLanguageStudyAvgHours, suffix: 'ঘণ্টা', defaultDots: 15),
              pw.SizedBox(height: 3),
              buildDottedInline(label: 'পারিবারিক/সামাজিক কাজে সময়দান (গড়ে) ', value: plan.familySocialWorkAvgHours, suffix: 'ঘণ্টা', defaultDots: 15),
              pw.SizedBox(height: 3),
              buildDottedInline(label: 'অন্যান্য ', value: plan.others, defaultDots: 50),

              // 6. সংশ্লিষ্টদের জন্য
              buildSectionHeader('৬. সংশ্লিষ্টদের জন্য'),
              pw.Row(
                children: [
                  buildDottedInline(label: 'সদস্য পর্যায়ে উন্নীতকরণ টার্গেট ', value: plan.memberLevelUpgradeTargetCount, suffix: 'জন', defaultDots: 8),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• নাম ', value: plan.memberLevelUpgradeTargetName, prefix: '', defaultDots: 30),
                ],
              ),
              pw.SizedBox(height: 3),
              pw.Row(
                children: [
                  buildDottedInline(label: 'সহযোগী সদস্য পর্যায়ে উন্নীতকরণ টার্গেট ', value: plan.associateMemberLevelUpgradeTargetCount, suffix: 'জন', defaultDots: 8),
                  pw.SizedBox(width: 8),
                  buildDottedInline(label: '• নাম ', value: plan.associateMemberLevelUpgradeTargetName, prefix: '', defaultDots: 25),
                ],
              ),

              pw.Spacer(),

              // Footer Signatures
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 10, bottom: 5),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    PdfExportService.bWidget('দায়িত্বশীলদের স্বাক্ষর', fontSize: 8.5),
                    PdfExportService.bWidget('পরিকল্পনা গ্রহণকারীর স্বাক্ষর', fontSize: 8.5),
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

  static Future<void> generateAndPrintPdf(PersonalPlanEntity plan, [BuildContext? context]) async {
    final pdfBytes = await generatePdfBytes(plan);
    if (context != null && context.mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfPreviewScreen(
            pdfBytes: pdfBytes,
            fileName: 'ছাত্র_মজলিস_ব্যক্তিগত_মাসিক_পরিকল্পনা_${plan.name.replaceAll(' ', '_')}.pdf',
            title: 'ব্যক্তিগত মাসিক পরিকল্পনা',
          ),
        ),
      );
    } else {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: 'ছাত্র_মজলিস_ব্যক্তিগত_মাসিক_পরিকল্পনা_${plan.name.replaceAll(' ', '_')}.pdf',
      );
    }
  }

  static Future<void> printOrDownloadPdf(PersonalPlanEntity plan) async {
    await generateAndPrintPdf(plan);
  }
}
