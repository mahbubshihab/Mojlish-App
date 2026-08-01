import 'package:mojlish_app/features/student_majlis/personal_report/data/models/personal_report_model.dart';

abstract class PersonalReportRemoteDataSource {
  Future<void> submitPersonalReport(PersonalReportModel report);
  Future<PersonalReportModel> getPersonalReport(String month, String year);
}

class PersonalReportRemoteDataSourceImpl implements PersonalReportRemoteDataSource {
  @override
  Future<void> submitPersonalReport(PersonalReportModel report) async {
    // Implement API call
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<PersonalReportModel> getPersonalReport(String month, String year) async {
    // Implement API call
    return Future.delayed(const Duration(seconds: 1), () => PersonalReportModel(
      id: '1',
      month: month,
      year: year,
      quranTotalAyat: 0,
      quranDays: 0,
      quranSurah: '',
      quranAverage: 0,
      darsPreparationTotal: 0,
      darsPreparationSubject: '',
      darsPreparationMemorizedAyat: 0,
      hadithTotal: 0,
      hadithDays: 0,
      hadithBook: '',
      hadithAverage: 0,
      darsPreparationHadithTotal: 0,
      darsPreparationHadithSubject: '',
      darsPreparationHadithMemorized: 0,
      darsPreparationHadithMemorizedSubject: '',
      islamicLiteratureTotalPages: 0,
      islamicLiteratureDays: 0,
      islamicLiteratureAverage: 0,
      islamicLiteratureBookName: '',
      islamicLiteratureNotePages: 0,
      textbookClassAttendanceTotal: 0,
      textbookClassAttendanceHours: 0,
      textbookClassAttendanceDays: 0,
      textbookClassAttendanceAverage: 0,
      jamatNamazTotal: 0,
      selfAssessmentDays: 0,
      friendIncreaseTotal: 0,
      friendIncreaseNames: '',
      primaryMemberIncreaseTotal: 0,
      primaryMemberIncreaseNames: '',
      bookDistributionTotal: 0,
      studentReviewDistributionTotal: 0,
      wellWisherIncreaseTotal: 0,
      wellWisherIncreaseNames: '',
      cardGiftSmsEmailLetterMagazineTotal: 0,
      groupDawahTotal: 0,
      otherDawahMaterials: '',
      workerIncreaseTotal: 0,
      workerIncreaseNames: '',
      meetingAttendanceTotal: 0,
      orgDawahTimeGivenAverageHours: 0,
      baytulmalPaidAmount: 0.0,
      baytulmalPaidDate: '',
      workerCommunicationTotal: 0,
      workerCommunicationNames: '',
      dailyOtherMagazineReadingAverageHours: 0,
      physicalExerciseDays: 0,
      technicalComputerLanguageTimeGivenAverageHours: 0,
      familySocialWorkTimeGivenAverageHours: 0,
      miscellaneousOthers: '',
      promotedToMemberTotal: 0,
      promotedToMemberNames: '',
      promotedToAssociateMemberTotal: 0,
      promotedToAssociateMemberNames: '',
      meetingAdvice: '',
    ));
  }
}
