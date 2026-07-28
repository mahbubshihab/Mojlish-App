import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/period_report_model.dart';

/// ছাত্র মজলিস বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট PDF জেনারেটর সার্ভিস
class StudentPeriodPdfService {
  static Future<void> generateAndPrintPdf(StudentPeriodReportModel report) async {
    final fontRegular = await PdfGoogleFonts.notoSansBengaliRegular();
    final fontBold = await PdfGoogleFonts.notoSansBengaliBold();

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: fontRegular,
        bold: fontBold,
      ),
    );

    final textStyleSmall = pw.TextStyle(font: fontRegular, fontSize: 8);
    final textStyleBoldSmall = pw.TextStyle(font: fontBold, fontSize: 8);
    final textStyleTitle = pw.TextStyle(font: fontBold, fontSize: 13);

    // ===================================
    // PAGE 1: জনশক্তি, দাওয়াত, সংগঠন
    // ===================================
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(16),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text('বিসমিল্লাহির রাহমানির রাহীম', style: pw.TextStyle(font: fontRegular, fontSize: 9)),
              pw.SizedBox(height: 2),
              pw.Text(
                '${report.periodType} রিপোর্ট (${report.periodName})',
                style: textStyleTitle.copyWith(color: PdfColors.blue800),
              ),
              pw.SizedBox(height: 2),
              pw.Text('বাংলাদেশ ইসলামী ছাত্র মজলিস', style: pw.TextStyle(font: fontBold, fontSize: 12)),
              pw.SizedBox(height: 8),

              // মেটা তথ্য বার
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.blue900, width: 1),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('শাখা : ${report.branch}', style: textStyleBoldSmall),
                    pw.Text('মাস/সময়কাল : ${report.periodName}', style: textStyleBoldSmall),
                    pw.Text('সেশন : ${report.session}', style: textStyleBoldSmall),
                    pw.Text('বছর : ${report.year}', style: textStyleBoldSmall),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),

              // সেকশন ১: জনশক্তি
              pw.Container(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text('১. জনশক্তি (Manpower)', style: textStyleBoldSmall),
              ),
              pw.SizedBox(height: 2),
              pw.TableHelper.fromTextArray(
                headers: ['জনশক্তি', 'সংখ্যা', 'বৃদ্ধি', 'কিভাবে', 'টার্গেট', 'ঘাটতি', 'কারণ'],
                cellStyle: textStyleSmall,
                headerStyle: textStyleBoldSmall,
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
                cellAlignment: pw.Alignment.center,
                data: [
                  ['সদস্য', '${report.sodosso.presentCount}', '${report.sodosso.increase}', report.sodosso.how, '${report.sodosso.target}', '${report.sodosso.deficit}', report.sodosso.reason],
                  ['সদস্য প্রার্থী', '${report.sodossoPrarthi.presentCount}', '${report.sodossoPrarthi.increase}', report.sodossoPrarthi.how, '${report.sodossoPrarthi.target}', '${report.sodossoPrarthi.deficit}', report.sodossoPrarthi.reason],
                  ['সহযোগী সদস্য', '${report.sohoyogiSodosso.presentCount}', '${report.sohoyogiSodosso.increase}', report.sohoyogiSodosso.how, '${report.sohoyogiSodosso.target}', '${report.sohoyogiSodosso.deficit}', report.sohoyogiSodosso.reason],
                  ['সহযোগী সদস্য প্রার্থী', '${report.sohoyogiSodossoPrarthi.presentCount}', '${report.sohoyogiSodossoPrarthi.increase}', report.sohoyogiSodossoPrarthi.how, '${report.sohoyogiSodossoPrarthi.target}', '${report.sohoyogiSodossoPrarthi.deficit}', report.sohoyogiSodossoPrarthi.reason],
                  ['কর্মী', '${report.kormi.presentCount}', '${report.kormi.increase}', report.kormi.how, '${report.kormi.target}', '${report.kormi.deficit}', report.kormi.reason],
                  ['মোট', '${report.totalManpower.presentCount}', '${report.totalManpower.increase}', '-', '${report.totalManpower.target}', '${report.totalManpower.deficit}', '-'],
                ],
              ),
              pw.SizedBox(height: 8),

              // সেকশন ২: দাওয়াত ও বিতরণ
              pw.Container(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text('২. দাওয়াত ও বিতরণ (Dawah & Distribution)', style: textStyleBoldSmall),
              ),
              pw.SizedBox(height: 2),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.TableHelper.fromTextArray(
                      headers: ['দাওয়াত', 'সংখ্যা', 'বৃদ্ধি'],
                      cellStyle: textStyleSmall,
                      headerStyle: textStyleBoldSmall,
                      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
                      cellAlignment: pw.Alignment.center,
                      data: [
                        ['প্রাথমিক সদস্য', '${report.primaryMemberDawahCount}', '${report.primaryMemberDawahIncrease}'],
                        ['বন্ধু', '${report.friendDawahCount}', '${report.friendDawahIncrease}'],
                        ['শুভাকাঙ্ক্ষী', '${report.wellWisherDawahCount}', '${report.wellWisherDawahIncrease}'],
                        ['গ্রুপ দাওয়াত', '${report.groupDawahCount}', '-'],
                        ['চা-চক্র', '${report.teaCircleCount}', '-'],
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    child: pw.TableHelper.fromTextArray(
                      headers: ['বিতরণ', 'পরিমাণ'],
                      cellStyle: textStyleSmall,
                      headerStyle: textStyleBoldSmall,
                      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
                      cellAlignment: pw.Alignment.center,
                      data: [
                        ['ইসলামী সাহিত্য', report.islamicLiterature],
                        ['পরিচিতি', report.introductionBook],
                        ['ছাত্র পরিক্রমা/স্টুডেন্টস রিভিউ', report.studentReview],
                        ['কিশোর পত্রিকা', report.teenMagazine],
                        ['স্টিকার/কার্ড/ডায়েরি', report.stickerCardDiary],
                        ['রুটিন/সূত্রাবলী', report.routineFormula],
                        ['লিফলেট/পোস্টার/ক্যালেন্ডার', report.leafletPosterCalendar],
                        ['দাওয়াত কার্ড/উপহার', report.invitationCardGift],
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 4),

              pw.Container(
                padding: const pw.EdgeInsets.all(4),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400)),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('শাখার সংবাদ প্রকাশিত হয়েছে (প্রিন্ট/ইলেকট্রনিক/অনলাইন): ${report.newsPublishedCount} | বার দেয়ালিকা প্রকাশ: ${report.wallMagazineCount} | দেয়াল লিখন: ${report.wallWritingCount}', style: textStyleSmall),
                    pw.SizedBox(height: 2),
                    pw.Text('বক্তৃতা/বিতর্ক/সাধারণ জ্ঞান প্রতিযোগিতা: ${report.competitionCount} | নবীন বরণ: ${report.freshersReceptionCount} | অন্যান্য: ${report.otherDawahMediaDetails}', style: textStyleSmall),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),

              // সেকশন ৩: সংগঠন
              pw.Container(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text('৩. সংগঠন (Organization)', style: textStyleBoldSmall),
              ),
              pw.SizedBox(height: 2),
              pw.TableHelper.fromTextArray(
                headers: ['প্রতিষ্ঠানের ধরন', 'সংখ্যা', 'প্রতিষ্ঠানের ধরন', 'সংখ্যা'],
                cellStyle: textStyleSmall,
                headerStyle: textStyleBoldSmall,
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
                cellAlignment: pw.Alignment.center,
                data: [
                  ['পাবলিক বিশ্ববিদ্যালয়', '${report.publicUniversity}', 'মাদরাসা (কামিল)', '${report.kamilMadrasa}'],
                  ['প্রাইভেট বিশ্ববিদ্যালয়', '${report.privateUniversity}', 'মাদরাসা (ফাজিল)', '${report.fazilMadrasa}'],
                  ['মেডিকেল কলেজ', '${report.medicalCollege}', 'মাদরাসা (আলিম)', '${report.alimMadrasa}'],
                  ['বিশ্ববিদ্যালয় কলেজ', '${report.universityCollege}', 'মাদরাসা (দাখিল)', '${report.dakhilMadrasa}'],
                  ['হোমিও কলেজ', '${report.homeoCollege}', 'মাদরাসা (কওমী)', '${report.qawmiMadrasa}'],
                  ['আইন কলেজ', '${report.lawCollege}', 'স্কুল (সরকারি)', '${report.govSchool}'],
                  ['টেকনিক্যাল প্রতিষ্ঠান', '${report.technicalInst}', 'স্কুল (বেসরকারি)', '${report.nonGovSchool}'],
                  ['কলেজ (সরকারি)', '${report.govCollege}', 'জোন/থানা', '${report.zoneThana}'],
                  ['কলেজ (বেসরকারি)', '${report.nonGovCollege}', 'মোট শাখা', '${report.totalBranchCount}'],
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Text('সহযোগী সদস্য শাখা (নামসহ): ${report.associateMemberBranchNames}', style: textStyleSmall),
            ],
          );
        },
      ),
    );

    // ===================================
    // PAGE 2: সভা, প্রশিক্ষণ, পাঠাগার, বায়তুলমাল, ইত্যাদি
    // ===================================
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(16),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                '${report.periodType} রিপোর্ট (${report.periodName}) - পৃষ্ঠা ২',
                style: textStyleTitle.copyWith(color: PdfColors.blue800),
              ),
              pw.SizedBox(height: 6),

              // সেকশন ৪: সভাসমূহ
              pw.Container(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text('৪. সভাসমূহ (Meetings)', style: textStyleBoldSmall),
              ),
              pw.SizedBox(height: 2),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.TableHelper.fromTextArray(
                      headers: ['সভাসমূহ', 'সংখ্যা', 'উপস্থিতি', 'সর্বোচ্চ/সর্বনিম্ন'],
                      cellStyle: textStyleSmall,
                      headerStyle: textStyleBoldSmall,
                      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
                      cellAlignment: pw.Alignment.center,
                      data: [
                        ['দায়িত্বশীল সভা', '${report.dayittoshilMeeting.count}', '${report.dayittoshilMeeting.attendance}', report.dayittoshilMeeting.maxMin],
                        ['থানা/জোনাল সভা', '${report.thanaZonalMeeting.count}', '${report.thanaZonalMeeting.attendance}', report.thanaZonalMeeting.maxMin],
                        ['সদস্য সভা', '${report.sodossoMeeting.count}', '${report.sodossoMeeting.attendance}', report.sodossoMeeting.maxMin],
                        ['সহযোগী সদস্য সভা', '${report.sohoyogiSodossoMeeting.count}', '${report.sohoyogiSodossoMeeting.attendance}', report.sohoyogiSodossoMeeting.maxMin],
                        ['কর্মী সভা', '${report.kormiMeeting.count}', '${report.kormiMeeting.attendance}', report.kormiMeeting.maxMin],
                        ['জরুরি সভা', '${report.emergencyMeeting.count}', '${report.emergencyMeeting.attendance}', report.emergencyMeeting.maxMin],
                        ['সাধারণ সভা', '${report.generalMeeting.count}', '${report.generalMeeting.attendance}', report.generalMeeting.maxMin],
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Expanded(
                    child: pw.TableHelper.fromTextArray(
                      headers: ['সভাসমূহ', 'সংখ্যা', 'উপস্থিতি', 'সর্বোচ্চ/সর্বনিম্ন'],
                      cellStyle: textStyleSmall,
                      headerStyle: textStyleBoldSmall,
                      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
                      cellAlignment: pw.Alignment.center,
                      data: [
                        ['আলোচনা সভা', '${report.discussionMeeting.count}', '${report.discussionMeeting.attendance}', report.discussionMeeting.maxMin],
                        ['সহযোগী সদস্য সমাবেশ', '${report.sohoyogiSodossoSamabesh.count}', '${report.sohoyogiSodossoSamabesh.attendance}', report.sohoyogiSodossoSamabesh.maxMin],
                        ['কর্মী সমাবেশ', '${report.kormiSamabesh.count}', '${report.kormiSamabesh.attendance}', report.kormiSamabesh.maxMin],
                        ['ছাত্র সমাবেশ', '${report.studentSamabesh.count}', '${report.studentSamabesh.attendance}', report.studentSamabesh.maxMin],
                        ['মিছিল', '${report.rally.count}', '${report.rally.attendance}', report.rally.maxMin],
                        ['দিবস পালন', '${report.dayObservance.count}', '${report.dayObservance.attendance}', report.dayObservance.maxMin],
                        ['অন্যান্য', '${report.otherMeetings.count}', '${report.otherMeetings.attendance}', report.otherMeetings.maxMin],
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 6),

              // সেকশন ৫: প্রশিক্ষণ
              pw.Container(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text('৫. প্রশিক্ষণ (Training)', style: textStyleBoldSmall),
              ),
              pw.SizedBox(height: 2),
              pw.TableHelper.fromTextArray(
                headers: ['প্রশিক্ষণ', 'সংখ্যা', 'অধिवेशन', 'উপস্থিতি', 'সর্বোচ্চ/সর্বনিম্ন'],
                cellStyle: textStyleSmall,
                headerStyle: textStyleBoldSmall,
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
                cellAlignment: pw.Alignment.center,
                data: [
                  ['স্কিলস ডেভেলপমেন্ট', '${report.skillsDev.count}', '${report.skillsDev.sessionCount}', '${report.skillsDev.attendance}', report.skillsDev.maxMin],
                  ['কর্মশালা', '${report.workshop.count}', '${report.workshop.sessionCount}', '${report.workshop.attendance}', report.workshop.maxMin],
                  ['তরবিয়তি সফর', '${report.torbiyatiSofor.count}', '${report.torbiyatiSofor.sessionCount}', '${report.torbiyatiSofor.attendance}', report.torbiyatiSofor.maxMin],
                  ['প্রশিক্ষণ চক্র', '${report.trainingCircle.count}', '${report.trainingCircle.sessionCount}', '${report.trainingCircle.attendance}', report.trainingCircle.maxMin],
                  ['শিক্ষা সভা', '${report.shikshaSobha.count}', '${report.shikshaSobha.sessionCount}', '${report.shikshaSobha.attendance}', report.shikshaSobha.maxMin],
                  ['কুরআন ও হাদীস ক্লাস', '${report.quranHadithClass.count}', '${report.quranHadithClass.sessionCount}', '${report.quranHadithClass.attendance}', report.quranHadithClass.maxMin],
                  ['শবগুজারি', '${report.shabGujari.count}', '${report.shabGujari.sessionCount}', '${report.shabGujari.attendance}', report.shabGujari.maxMin],
                  ['জিকির মাহফিল', '${report.zikrMahfil.count}', '${report.zikrMahfil.sessionCount}', '${report.zikrMahfil.attendance}', report.zikrMahfil.maxMin],
                  ['সামষ্টিক অধ্যয়ন', '${report.samostikOddhayon.count}', '${report.samostikOddhayon.sessionCount}', '${report.samostikOddhayon.attendance}', report.samostikOddhayon.maxMin],
                  ['হাদীস পাঠ', '${report.hadithPath.count}', '${report.hadithPath.sessionCount}', '${report.hadithPath.attendance}', report.hadithPath.maxMin],
                  ['সাংস্কৃতিক ফোরাম', '${report.culturalForum.count}', '${report.culturalForum.sessionCount}', '${report.culturalForum.attendance}', report.culturalForum.maxMin],
                  ['উন্মুক্ত ক্লাস', '${report.openClass.count}', '${report.openClass.sessionCount}', '${report.openClass.attendance}', report.openClass.maxMin],
                ],
              ),
              pw.SizedBox(height: 6),

              // সেকশন ৬ & ৭: পাঠাগার ও বায়তুলমাল
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400)),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('৬. পাঠাগার', style: textStyleBoldSmall),
                          pw.Text('সংখ্যা: ${report.libraryCount} | বই সংখ্যা: ${report.bookCount}', style: textStyleSmall),
                          pw.Text('পাঠক: ${report.readerCount} | ইস্যু: ${report.issuedBooks} | পঠিত: ${report.readBooks}', style: textStyleSmall),
                          pw.Text('বৃদ্ধি: ${report.libraryIncrease} | ঘাটতি: ${report.libraryDeficit}', style: textStyleSmall),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400)),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('৭. বায়তুলমাল', style: textStyleBoldSmall),
                          pw.Text('আয়: ৳${report.totalIncome} | ব্যয়: ৳${report.totalExpense}', style: textStyleSmall),
                          pw.Text('বকেয়া: ৳${report.dueAmount} | বকেয়া পরিশোধ: ৳${report.dueRepaid}', style: textStyleSmall),
                          pw.Text('উর্ধ্বতন এয়ানত: ৳${report.seniorEyanatPaid} | ধার্যকৃত: ৳${report.assignedAmount}', style: textStyleSmall),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 6),

              // সেকশন ৮ & ৯: প্রকাশনা ও ছাত্রকল্যাণ
              pw.Container(
                padding: const pw.EdgeInsets.all(4),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400)),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('৮. প্রকাশনা: মোট ক্রয়: ৳${report.pubTotalPurchase} | পরিশোধ: ৳${report.pubRepaid} | বকেয়া: ৳${report.pubDue} | বকেয়া পরিশোধ: ৳${report.pubDueRepaid}', style: textStyleSmall),
                    pw.SizedBox(height: 2),
                    pw.Text('৯. ছাত্রকল্যাণ: আয়: ৳${report.welfareIncome} | ব্যয়: ৳${report.welfareExpense} | লজিং: ${report.lodgingCount} | টিউশনি: ${report.tuitionCount} | টেবিল ব্যাংক: ${report.tableBankCount}', style: textStyleSmall),
                    pw.Text('নোট বিলি: ${report.questionNoteBiliCount} | যাকাত: ৳${report.zakatCollection} | কোচিং/আবাসন: ${report.freeCoachingAccomodationCount} (জন: ${report.freeCoachingPersons}) | রক্তদান: ${report.bloodDonationBags} ব্যাগ', style: textStyleSmall),
                  ],
                ),
              ),
              pw.SizedBox(height: 6),

              // সেকশন ১০ & ১১: যোগাযোগ ও মন্তব্য
              pw.Container(
                padding: const pw.EdgeInsets.all(4),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400)),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('১০. যোগাযোগ: সার্কুলার প্রাপ্ত: ${report.circularReceived.count} (কপি: ${report.circularReceived.copyCount}) | সার্কুলার প্রেরিত: ${report.circularSent.count} | চিঠি প্রাপ্ত: ${report.letterReceived.count} | চিঠি প্রেরিত: ${report.letterSent.count}', style: textStyleSmall),
                    pw.SizedBox(height: 2),
                    pw.Text('১১. অন্যান্য ছাত্র সংগঠনের তৎপরতা: ${report.otherOrgActivities}', style: textStyleSmall),
                    pw.Text('বিবিধ: ${report.miscellaneous}', style: textStyleSmall),
                    pw.Text('মন্তব্য: ${report.remarks}', style: textStyleSmall),
                  ],
                ),
              ),
              pw.Spacer(),

              // স্বাক্ষর
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('তারিখ: ${report.presidentSignatureDate}', style: textStyleSmall),
                  pw.Column(
                    children: [
                      pw.Container(width: 100, height: 1, color: PdfColors.black),
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

    // PDF প্রদর্শন ও প্রিন্ট
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${report.periodType}_রিপোর্ট_${report.periodName}.pdf',
    );
  }
}
