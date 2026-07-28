import 'package:flutter_bloc/flutter_bloc.dart';
import 'branch_plan_event.dart';
import 'branch_plan_state.dart';
import '../domain/repositories/branch_plan_repository.dart';
import '../domain/entities/branch_plan_entity.dart';

class BranchPlanBloc extends Bloc<BranchPlanEvent, BranchPlanState> {
  final BranchPlanRepository repository;

  BranchPlanBloc({required this.repository}) : super(BranchPlanInitial()) {
    on<LoadBranchPlanEvent>((event, emit) async {
      emit(BranchPlanLoading());
      final result = await repository.getBranchPlan(event.branchId);
      result.fold(
        (error) => emit(BranchPlanError(error)),
        (plan) => emit(BranchPlanLoaded(plan)),
      );
    });

    on<SubmitBranchPlanEvent>((event, emit) async {
      emit(BranchPlanLoading());
      
      final plan = BranchPlanEntity(
        branchName: event.branchName,
        month: event.month,
        year: event.year,
        manpower: {},
        dawahPrograms: [],
        organizations: [],
        baytulmal: {},
        travels: [],
        meetings: [],
        trainings: [],
        department: {},
        publications: [],
        library: {},
        socialWelfare: {},
      );

      final result = await repository.submitBranchPlan(plan);
      result.fold(
        (error) => emit(BranchPlanError(error)),
        (success) => emit(BranchPlanSubmitSuccess()),
      );
    });
  }
}
