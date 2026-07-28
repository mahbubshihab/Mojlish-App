import 'package:dartz/dartz.dart';
import '../../domain/entities/branch_plan_entity.dart';
import '../../domain/repositories/branch_plan_repository.dart';
import '../datasources/branch_plan_remote_data_source.dart';
import '../models/branch_plan_model.dart';

class BranchPlanRepositoryImpl implements BranchPlanRepository {
  final BranchPlanRemoteDataSource remoteDataSource;

  BranchPlanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, BranchPlanEntity>> getBranchPlan(String id) async {
    try {
      final model = await remoteDataSource.getBranchPlan(id);
      return Right(model);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> submitBranchPlan(BranchPlanEntity plan) async {
    try {
      final model = BranchPlanModel(
        branchName: plan.branchName,
        month: plan.month,
        year: plan.year,
        manpower: plan.manpower,
        dawahPrograms: plan.dawahPrograms,
        organizations: plan.organizations,
        baytulmal: plan.baytulmal,
        travels: plan.travels,
        meetings: plan.meetings,
        trainings: plan.trainings,
        department: plan.department,
        publications: plan.publications,
        library: plan.library,
        socialWelfare: plan.socialWelfare,
      );
      await remoteDataSource.submitBranchPlan(model);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
