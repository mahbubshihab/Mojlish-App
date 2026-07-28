import 'package:flutter_bloc/flutter_bloc.dart';
import 'branch_plan_event.dart';
import 'branch_plan_state.dart';

class KhelafatBranchPlanBloc extends Bloc<KhelafatBranchPlanEvent, KhelafatBranchPlanState> {
  KhelafatBranchPlanBloc() : super(KhelafatBranchPlanInitial()) {
    on<LoadKhelafatBranchPlanData>((event, emit) {
      emit(KhelafatBranchPlanLoading());
      emit(KhelafatBranchPlanLoaded());
    });
  }
}
