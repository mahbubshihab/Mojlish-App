import '../../domain/entities/general_plan_entity.dart';
import '../../domain/repositories/general_plan_repository.dart';
import '../datasources/general_plan_remote_datasource.dart';
import '../models/general_plan_model.dart';

class GeneralPlanRepositoryImpl implements GeneralPlanRepository {
  final GeneralPlanRemoteDataSource remoteDataSource;

  GeneralPlanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitGeneralPlan(GeneralPlanEntity plan) async {
    final model = GeneralPlanModel(
      branch: plan.branch,
      month: plan.month,
      session: plan.session,
      friendIncrease: plan.friendIncrease,
      primaryMemberIncrease: plan.primaryMemberIncrease,
      schoolGovt: plan.schoolGovt,
      schoolNonGovt: plan.schoolNonGovt,
      college: plan.college,
      madrasaAlia: plan.madrasaAlia,
      madrasaQawmi: plan.madrasaQawmi,
      university: plan.university,
      wellWisherIncrease: plan.wellWisherIncrease,
      associateMemberTarget: plan.associateMemberTarget,
      workerIncrease: plan.workerIncrease,
      workshopCount: plan.workshopCount,
      educationMeetingCount: plan.educationMeetingCount,
      zakatCollection: plan.zakatCollection,
      totalIncome: plan.totalIncome,
      totalExpenditure: plan.totalExpenditure,
    );
    await remoteDataSource.submitGeneralPlan(model);
  }

  @override
  Future<GeneralPlanEntity?> getGeneralPlan(String planId) async {
    return await remoteDataSource.getGeneralPlan(planId);
  }
}
