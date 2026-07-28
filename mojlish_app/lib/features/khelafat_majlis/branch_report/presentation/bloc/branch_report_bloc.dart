import 'package:flutter_bloc/flutter_bloc.dart';
import 'branch_report_event.dart';
import 'branch_report_state.dart';

class KhelafatBranchReportBloc extends Bloc<KhelafatBranchReportEvent, KhelafatBranchReportState> {
  KhelafatBranchReportBloc() : super(KhelafatBranchReportInitial()) {
    on<LoadKhelafatBranchReportData>((event, emit) {
      emit(KhelafatBranchReportLoading());
      emit(KhelafatBranchReportLoaded());
    });
  }
}
