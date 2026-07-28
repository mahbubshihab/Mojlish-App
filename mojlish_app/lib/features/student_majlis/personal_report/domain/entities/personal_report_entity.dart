import 'package:equatable/equatable.dart';

class PersonalReportEntity extends Equatable {
  final String id;
  final String month;
  final String year;

  // Study
  final int quranTotalAyat;
  final int quranDays;
  final String quranSurah;
  final int quranAverage;

  final int darsPreparationTotal;
  final String darsPreparationSubject;
  final int darsPreparationMemorizedAyat;

  final int hadithTotal;
  final int hadithDays;
  final String hadithBook;
  final int hadithAverage;

  final int darsPreparationHadithTotal;
  final String darsPreparationHadithSubject;
  final int darsPreparationHadithMemorized;
  final String darsPreparationHadithMemorizedSubject;

  final int islamicLiteratureTotalPages;
  final int islamicLiteratureDays;
  final int islamicLiteratureAverage;
  final String islamicLiteratureBookName;
  final int islamicLiteratureNotePages;

  final int textbookClassAttendanceTotal;
  final int textbookClassAttendanceHours;
  final int textbookClassAttendanceDays;
  final int textbookClassAttendanceAverage;

  // Worship
  final int jamatNamazTotal;
  final int selfAssessmentDays;

  // Dawah Work
  final int friendIncreaseTotal;
  final String friendIncreaseNames;

  final int primaryMemberIncreaseTotal;
  final String primaryMemberIncreaseNames;

  final int bookDistributionTotal;
  final int studentReviewDistributionTotal;

  final int wellWisherIncreaseTotal;
  final String wellWisherIncreaseNames;

  final int cardGiftSmsEmailLetterMagazineTotal;

  final int groupDawahTotal;
  final String otherDawahMaterials;

  // Organizational Work
  final int workerIncreaseTotal;
  final String workerIncreaseNames;

  final int meetingAttendanceTotal;
  final int orgDawahTimeGivenAverageHours;

  final double baytulmalPaidAmount;
  final String baytulmalPaidDate;

  final int workerCommunicationTotal;
  final String workerCommunicationNames;

  // Miscellaneous
  final int dailyOtherMagazineReadingAverageHours;
  final int physicalExerciseDays;

  final int technicalComputerLanguageTimeGivenAverageHours;

  final int familySocialWorkTimeGivenAverageHours;

  final String miscellaneousOthers;

  // For Concerned Persons
  final int promotedToMemberTotal;
  final String promotedToMemberNames;

  final int promotedToAssociateMemberTotal;
  final String promotedToAssociateMemberNames;

  final String meetingAdvice;

  const PersonalReportEntity({
    required this.id,
    required this.month,
    required this.year,
    required this.quranTotalAyat,
    required this.quranDays,
    required this.quranSurah,
    required this.quranAverage,
    required this.darsPreparationTotal,
    required this.darsPreparationSubject,
    required this.darsPreparationMemorizedAyat,
    required this.hadithTotal,
    required this.hadithDays,
    required this.hadithBook,
    required this.hadithAverage,
    required this.darsPreparationHadithTotal,
    required this.darsPreparationHadithSubject,
    required this.darsPreparationHadithMemorized,
    required this.darsPreparationHadithMemorizedSubject,
    required this.islamicLiteratureTotalPages,
    required this.islamicLiteratureDays,
    required this.islamicLiteratureAverage,
    required this.islamicLiteratureBookName,
    required this.islamicLiteratureNotePages,
    required this.textbookClassAttendanceTotal,
    required this.textbookClassAttendanceHours,
    required this.textbookClassAttendanceDays,
    required this.textbookClassAttendanceAverage,
    required this.jamatNamazTotal,
    required this.selfAssessmentDays,
    required this.friendIncreaseTotal,
    required this.friendIncreaseNames,
    required this.primaryMemberIncreaseTotal,
    required this.primaryMemberIncreaseNames,
    required this.bookDistributionTotal,
    required this.studentReviewDistributionTotal,
    required this.wellWisherIncreaseTotal,
    required this.wellWisherIncreaseNames,
    required this.cardGiftSmsEmailLetterMagazineTotal,
    required this.groupDawahTotal,
    required this.otherDawahMaterials,
    required this.workerIncreaseTotal,
    required this.workerIncreaseNames,
    required this.meetingAttendanceTotal,
    required this.orgDawahTimeGivenAverageHours,
    required this.baytulmalPaidAmount,
    required this.baytulmalPaidDate,
    required this.workerCommunicationTotal,
    required this.workerCommunicationNames,
    required this.dailyOtherMagazineReadingAverageHours,
    required this.physicalExerciseDays,
    required this.technicalComputerLanguageTimeGivenAverageHours,
    required this.familySocialWorkTimeGivenAverageHours,
    required this.miscellaneousOthers,
    required this.promotedToMemberTotal,
    required this.promotedToMemberNames,
    required this.promotedToAssociateMemberTotal,
    required this.promotedToAssociateMemberNames,
    required this.meetingAdvice,
  });

  @override
  List<Object?> get props => [
        id,
        month,
        year,
        quranTotalAyat,
        quranDays,
        quranSurah,
        quranAverage,
        darsPreparationTotal,
        darsPreparationSubject,
        darsPreparationMemorizedAyat,
        hadithTotal,
        hadithDays,
        hadithBook,
        hadithAverage,
        darsPreparationHadithTotal,
        darsPreparationHadithSubject,
        darsPreparationHadithMemorized,
        darsPreparationHadithMemorizedSubject,
        islamicLiteratureTotalPages,
        islamicLiteratureDays,
        islamicLiteratureAverage,
        islamicLiteratureBookName,
        islamicLiteratureNotePages,
        textbookClassAttendanceTotal,
        textbookClassAttendanceHours,
        textbookClassAttendanceDays,
        textbookClassAttendanceAverage,
        jamatNamazTotal,
        selfAssessmentDays,
        friendIncreaseTotal,
        friendIncreaseNames,
        primaryMemberIncreaseTotal,
        primaryMemberIncreaseNames,
        bookDistributionTotal,
        studentReviewDistributionTotal,
        wellWisherIncreaseTotal,
        wellWisherIncreaseNames,
        cardGiftSmsEmailLetterMagazineTotal,
        groupDawahTotal,
        otherDawahMaterials,
        workerIncreaseTotal,
        workerIncreaseNames,
        meetingAttendanceTotal,
        orgDawahTimeGivenAverageHours,
        baytulmalPaidAmount,
        baytulmalPaidDate,
        workerCommunicationTotal,
        workerCommunicationNames,
        dailyOtherMagazineReadingAverageHours,
        physicalExerciseDays,
        technicalComputerLanguageTimeGivenAverageHours,
        familySocialWorkTimeGivenAverageHours,
        miscellaneousOthers,
        promotedToMemberTotal,
        promotedToMemberNames,
        promotedToAssociateMemberTotal,
        promotedToAssociateMemberNames,
        meetingAdvice,
      ];
}
