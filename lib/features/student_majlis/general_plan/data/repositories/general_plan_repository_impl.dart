import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/general_plan_entity.dart';
import '../../domain/repositories/general_plan_repository.dart';
import '../datasources/general_plan_remote_datasource.dart';
import '../models/general_plan_model.dart';

class GeneralPlanRepositoryImpl implements GeneralPlanRepository {
  final GeneralPlanRemoteDataSource remoteDataSource;

  GeneralPlanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> submitGeneralPlan(GeneralPlanEntity plan) async {
    try {
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
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, GeneralPlanEntity>> getGeneralPlan(String planId) async {
    try {
      final plan = await remoteDataSource.getGeneralPlan(planId);
      return Right(plan);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
