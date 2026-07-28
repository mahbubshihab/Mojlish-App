import 'package:dartz/dartz.dart';
import 'package:mojlish_app/core/error/failures.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/data/datasources/personal_report_remote_data_source.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/data/models/personal_report_model.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/domain/entities/personal_report_entity.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/domain/repositories/personal_report_repository.dart';

class PersonalReportRepositoryImpl implements PersonalReportRepository {
  final PersonalReportRemoteDataSource remoteDataSource;

  PersonalReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> submitPersonalReport(PersonalReportEntity report) async {
    try {
      final model = PersonalReportModel(
        id: report.id,
        month: report.month,
        year: report.year,
        quranTotalAyat: report.quranTotalAyat,
        quranDays: report.quranDays,
        quranSurah: report.quranSurah,
        quranAverage: report.quranAverage,
        darsPreparationTotal: report.darsPreparationTotal,
        darsPreparationSubject: report.darsPreparationSubject,
        darsPreparationMemorizedAyat: report.darsPreparationMemorizedAyat,
        hadithTotal: report.hadithTotal,
        hadithDays: report.hadithDays,
        hadithBook: report.hadithBook,
        hadithAverage: report.hadithAverage,
        darsPreparationHadithTotal: report.darsPreparationHadithTotal,
        darsPreparationHadithSubject: report.darsPreparationHadithSubject,
        darsPreparationHadithMemorized: report.darsPreparationHadithMemorized,
        darsPreparationHadithMemorizedSubject: report.darsPreparationHadithMemorizedSubject,
        islamicLiteratureTotalPages: report.islamicLiteratureTotalPages,
        islamicLiteratureDays: report.islamicLiteratureDays,
        islamicLiteratureAverage: report.islamicLiteratureAverage,
        islamicLiteratureBookName: report.islamicLiteratureBookName,
        islamicLiteratureNotePages: report.islamicLiteratureNotePages,
        textbookClassAttendanceTotal: report.textbookClassAttendanceTotal,
        textbookClassAttendanceHours: report.textbookClassAttendanceHours,
        textbookClassAttendanceDays: report.textbookClassAttendanceDays,
        textbookClassAttendanceAverage: report.textbookClassAttendanceAverage,
        jamatNamazTotal: report.jamatNamazTotal,
        selfAssessmentDays: report.selfAssessmentDays,
        friendIncreaseTotal: report.friendIncreaseTotal,
        friendIncreaseNames: report.friendIncreaseNames,
        primaryMemberIncreaseTotal: report.primaryMemberIncreaseTotal,
        primaryMemberIncreaseNames: report.primaryMemberIncreaseNames,
        bookDistributionTotal: report.bookDistributionTotal,
        studentReviewDistributionTotal: report.studentReviewDistributionTotal,
        wellWisherIncreaseTotal: report.wellWisherIncreaseTotal,
        wellWisherIncreaseNames: report.wellWisherIncreaseNames,
        cardGiftSmsEmailLetterMagazineTotal: report.cardGiftSmsEmailLetterMagazineTotal,
        groupDawahTotal: report.groupDawahTotal,
        otherDawahMaterials: report.otherDawahMaterials,
        workerIncreaseTotal: report.workerIncreaseTotal,
        workerIncreaseNames: report.workerIncreaseNames,
        meetingAttendanceTotal: report.meetingAttendanceTotal,
        orgDawahTimeGivenAverageHours: report.orgDawahTimeGivenAverageHours,
        baytulmalPaidAmount: report.baytulmalPaidAmount,
        baytulmalPaidDate: report.baytulmalPaidDate,
        workerCommunicationTotal: report.workerCommunicationTotal,
        workerCommunicationNames: report.workerCommunicationNames,
        dailyOtherMagazineReadingAverageHours: report.dailyOtherMagazineReadingAverageHours,
        physicalExerciseDays: report.physicalExerciseDays,
        technicalComputerLanguageTimeGivenAverageHours: report.technicalComputerLanguageTimeGivenAverageHours,
        familySocialWorkTimeGivenAverageHours: report.familySocialWorkTimeGivenAverageHours,
        miscellaneousOthers: report.miscellaneousOthers,
        promotedToMemberTotal: report.promotedToMemberTotal,
        promotedToMemberNames: report.promotedToMemberNames,
        promotedToAssociateMemberTotal: report.promotedToAssociateMemberTotal,
        promotedToAssociateMemberNames: report.promotedToAssociateMemberNames,
        meetingAdvice: report.meetingAdvice,
      );
      await remoteDataSource.submitPersonalReport(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PersonalReportEntity>> getPersonalReport(String month, String year) async {
    try {
      final report = await remoteDataSource.getPersonalReport(month, year);
      return Right(report);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
