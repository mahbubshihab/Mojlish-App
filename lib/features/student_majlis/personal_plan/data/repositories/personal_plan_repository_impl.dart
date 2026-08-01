import '../../domain/entities/personal_plan_entity.dart';
import '../../domain/repositories/personal_plan_repository.dart';
import '../datasources/personal_plan_remote_data_source.dart';
import '../models/personal_plan_model.dart';

class PersonalPlanRepositoryImpl implements PersonalPlanRepository {
  final PersonalPlanRemoteDataSource remoteDataSource;

  PersonalPlanRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> submitPersonalPlan(PersonalPlanEntity plan) async {
    final model = PersonalPlanModel(
      id: plan.id,
      name: plan.name,
      branch: plan.branch,
      responsibility: plan.responsibility,
      month: plan.month,
      year: plan.year,
      quranAyatCount: plan.quranAyatCount,
      quranSuraPara: plan.quranSuraPara,
      quranDarasCount: plan.quranDarasCount,
      quranDarasTopic: plan.quranDarasTopic,
      quranMemorizeAyat: plan.quranMemorizeAyat,
      hadithCount: plan.hadithCount,
      hadithBookTopic: plan.hadithBookTopic,
      hadithDarasCount: plan.hadithDarasCount,
      hadithDarasTopic: plan.hadithDarasTopic,
      hadithMemorizeCount: plan.hadithMemorizeCount,
      hadithMemorizeTopic: plan.hadithMemorizeTopic,
      islamicLiteraturePages: plan.islamicLiteraturePages,
      islamicLiteratureBookName: plan.islamicLiteratureBookName,
      islamicLiteratureBookNotesPage: plan.islamicLiteratureBookNotesPage,
      textbookClassAvgHours: plan.textbookClassAvgHours,
      textbookClassTime: plan.textbookClassTime,
      jamatNamazWaqt: plan.jamatNamazWaqt,
      selfEvaluationDays: plan.selfEvaluationDays,
      nafalIbadat: plan.nafalIbadat,
      friendTargetContactCount: plan.friendTargetContactCount,
      friendTargetContactName: plan.friendTargetContactName,
      primaryMemberIncreaseContactCount: plan.primaryMemberIncreaseContactCount,
      primaryMemberIncreaseContactName: plan.primaryMemberIncreaseContactName,
      bookIntroStickerDistributionCount: plan.bookIntroStickerDistributionCount,
      studentReviewDistributionCount: plan.studentReviewDistributionCount,
      wellWisherIncreaseContactCount: plan.wellWisherIncreaseContactCount,
      wellWisherIncreaseContactName: plan.wellWisherIncreaseContactName,
      cardGiftSmsEmailLetterMagazineCount: plan.cardGiftSmsEmailLetterMagazineCount,
      groupDawahCount: plan.groupDawahCount,
      otherDawahMaterialsDistribution: plan.otherDawahMaterialsDistribution,
      workerStandardUpgradeCount: plan.workerStandardUpgradeCount,
      workerStandardUpgradeName: plan.workerStandardUpgradeName,
      meetingAttendanceCount: plan.meetingAttendanceCount,
      orgDawahTimeAvgHours: plan.orgDawahTimeAvgHours,
      baytulmalAmount: plan.baytulmalAmount,
      workerContactCount: plan.workerContactCount,
      workerNames: plan.workerNames,
      dailyOtherNewspaperAvgHours: plan.dailyOtherNewspaperAvgHours,
      physicalExerciseDays: plan.physicalExerciseDays,
      techLanguageStudyAvgHours: plan.techLanguageStudyAvgHours,
      familySocialWorkAvgHours: plan.familySocialWorkAvgHours,
      others: plan.others,
      memberLevelUpgradeTargetCount: plan.memberLevelUpgradeTargetCount,
      memberLevelUpgradeTargetName: plan.memberLevelUpgradeTargetName,
      associateMemberLevelUpgradeTargetCount: plan.associateMemberLevelUpgradeTargetCount,
      associateMemberLevelUpgradeTargetName: plan.associateMemberLevelUpgradeTargetName,
    );
    return await remoteDataSource.submitPersonalPlan(model);
  }

  @override
  Future<PersonalPlanEntity?> getPersonalPlan(String id) async {
    return await remoteDataSource.getPersonalPlan(id);
  }
}
