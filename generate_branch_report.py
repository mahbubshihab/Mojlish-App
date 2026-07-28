import os
import json

base_path = "/Users/mahbubshihab/Development/Mojlish app/lib/features/khelafat_majlis/branch_report"

folders = [
    "data/models",
    "data/datasources",
    "data/repositories",
    "domain/entities",
    "domain/repositories",
    "presentation/bloc",
    "presentation/pages",
    "presentation/widgets"
]

for folder in folders:
    os.makedirs(os.path.join(base_path, folder), exist_ok=True)

# 1. Entity
entity_code = """import 'package:equatable/equatable.dart';

class BranchReport extends Equatable {
  final String id;
  final String branchName;
  final DateTime monthYear;
  // TODO: Add all fields corresponding to the form
  final Map<String, dynamic> manpower;
  final Map<String, dynamic> dawah;
  final Map<String, dynamic> organization;
  final Map<String, dynamic> meetings;
  final Map<String, dynamic> baytulmal;
  final Map<String, dynamic> tour;
  final Map<String, dynamic> training;
  final Map<String, dynamic> office;
  final Map<String, dynamic> publicity;
  final Map<String, dynamic> library;
  final Map<String, dynamic> socialWelfare;
  final String comments;
  final DateTime createdAt;

  const BranchReport({
    required this.id,
    required this.branchName,
    required this.monthYear,
    required this.manpower,
    required this.dawah,
    required this.organization,
    required this.meetings,
    required this.baytulmal,
    required this.tour,
    required this.training,
    required this.office,
    required this.publicity,
    required this.library,
    required this.socialWelfare,
    required this.comments,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        branchName,
        monthYear,
        manpower,
        dawah,
        organization,
        meetings,
        baytulmal,
        tour,
        training,
        office,
        publicity,
        library,
        socialWelfare,
        comments,
        createdAt,
      ];
}
"""

with open(os.path.join(base_path, "domain/entities/branch_report.dart"), "w") as f:
    f.write(entity_code)

# 2. Model
model_code = """import '../../domain/entities/branch_report.dart';

class BranchReportModel extends BranchReport {
  const BranchReportModel({
    required super.id,
    required super.branchName,
    required super.monthYear,
    required super.manpower,
    required super.dawah,
    required super.organization,
    required super.meetings,
    required super.baytulmal,
    required super.tour,
    required super.training,
    required super.office,
    required super.publicity,
    required super.library,
    required super.socialWelfare,
    required super.comments,
    required super.createdAt,
  });

  factory BranchReportModel.fromJson(Map<String, dynamic> json) {
    return BranchReportModel(
      id: json['id'],
      branchName: json['branchName'],
      monthYear: DateTime.parse(json['monthYear']),
      manpower: json['manpower'] ?? {},
      dawah: json['dawah'] ?? {},
      organization: json['organization'] ?? {},
      meetings: json['meetings'] ?? {},
      baytulmal: json['baytulmal'] ?? {},
      tour: json['tour'] ?? {},
      training: json['training'] ?? {},
      office: json['office'] ?? {},
      publicity: json['publicity'] ?? {},
      library: json['library'] ?? {},
      socialWelfare: json['socialWelfare'] ?? {},
      comments: json['comments'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branchName': branchName,
      'monthYear': monthYear.toIso8601String(),
      'manpower': manpower,
      'dawah': dawah,
      'organization': organization,
      'meetings': meetings,
      'baytulmal': baytulmal,
      'tour': tour,
      'training': training,
      'office': office,
      'publicity': publicity,
      'library': library,
      'socialWelfare': socialWelfare,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
"""

with open(os.path.join(base_path, "data/models/branch_report_model.dart"), "w") as f:
    f.write(model_code)

# 3. Repository Interface
repo_interface_code = """import 'package:dartz/dartz.dart';
import '../entities/branch_report.dart';

abstract class BranchReportRepository {
  Future<Either<Exception, BranchReport>> submitReport(BranchReport report);
  Future<Either<Exception, BranchReport>> getReport(String id);
  Future<Either<Exception, List<BranchReport>>> getReports();
}
"""

with open(os.path.join(base_path, "domain/repositories/branch_report_repository.dart"), "w") as f:
    f.write(repo_interface_code)

# 4. Datasource
datasource_code = """import '../models/branch_report_model.dart';

abstract class BranchReportRemoteDataSource {
  Future<BranchReportModel> submitReport(BranchReportModel report);
  Future<BranchReportModel> getReport(String id);
  Future<List<BranchReportModel>> getReports();
}

class BranchReportRemoteDataSourceImpl implements BranchReportRemoteDataSource {
  @override
  Future<BranchReportModel> submitReport(BranchReportModel report) async {
    // TODO: implement API call
    return report;
  }

  @override
  Future<BranchReportModel> getReport(String id) async {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<List<BranchReportModel>> getReports() async {
    // TODO: implement API call
    return [];
  }
}
"""

with open(os.path.join(base_path, "data/datasources/branch_report_remote_data_source.dart"), "w") as f:
    f.write(datasource_code)

# 5. Repository Impl
repo_impl_code = """import 'package:dartz/dartz.dart';
import '../../domain/entities/branch_report.dart';
import '../../domain/repositories/branch_report_repository.dart';
import '../datasources/branch_report_remote_data_source.dart';
import '../models/branch_report_model.dart';

class BranchReportRepositoryImpl implements BranchReportRepository {
  final BranchReportRemoteDataSource remoteDataSource;

  BranchReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, BranchReport>> submitReport(BranchReport report) async {
    try {
      final model = BranchReportModel(
        id: report.id,
        branchName: report.branchName,
        monthYear: report.monthYear,
        manpower: report.manpower,
        dawah: report.dawah,
        organization: report.organization,
        meetings: report.meetings,
        baytulmal: report.baytulmal,
        tour: report.tour,
        training: report.training,
        office: report.office,
        publicity: report.publicity,
        library: report.library,
        socialWelfare: report.socialWelfare,
        comments: report.comments,
        createdAt: report.createdAt,
      );
      final result = await remoteDataSource.submitReport(model);
      return Right(result);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, BranchReport>> getReport(String id) async {
    try {
      final result = await remoteDataSource.getReport(id);
      return Right(result);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<BranchReport>>> getReports() async {
    try {
      final result = await remoteDataSource.getReports();
      return Right(result);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
"""

with open(os.path.join(base_path, "data/repositories/branch_report_repository_impl.dart"), "w") as f:
    f.write(repo_impl_code)

# 6. BLoC
bloc_event_code = """import 'package:equatable/equatable.dart';
import '../../domain/entities/branch_report.dart';

abstract class BranchReportEvent extends Equatable {
  const BranchReportEvent();

  @override
  List<Object> get props => [];
}

class SubmitBranchReportEvent extends BranchReportEvent {
  final BranchReport report;

  const SubmitBranchReportEvent(this.report);

  @override
  List<Object> get props => [report];
}

class LoadBranchReportsEvent extends BranchReportEvent {}
"""

with open(os.path.join(base_path, "presentation/bloc/branch_report_event.dart"), "w") as f:
    f.write(bloc_event_code)

bloc_state_code = """import 'package:equatable/equatable.dart';
import '../../domain/entities/branch_report.dart';

abstract class BranchReportState extends Equatable {
  const BranchReportState();
  
  @override
  List<Object> get props => [];
}

class BranchReportInitial extends BranchReportState {}

class BranchReportLoading extends BranchReportState {}

class BranchReportLoaded extends BranchReportState {
  final List<BranchReport> reports;

  const BranchReportLoaded(this.reports);

  @override
  List<Object> get props => [reports];
}

class BranchReportSubmitted extends BranchReportState {
  final BranchReport report;

  const BranchReportSubmitted(this.report);

  @override
  List<Object> get props => [report];
}

class BranchReportError extends BranchReportState {
  final String message;

  const BranchReportError(this.message);

  @override
  List<Object> get props => [message];
}
"""

with open(os.path.join(base_path, "presentation/bloc/branch_report_state.dart"), "w") as f:
    f.write(bloc_state_code)

bloc_code = """import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/branch_report_repository.dart';
import 'branch_report_event.dart';
import 'branch_report_state.dart';

class BranchReportBloc extends Bloc<BranchReportEvent, BranchReportState> {
  final BranchReportRepository repository;

  BranchReportBloc({required this.repository}) : super(BranchReportInitial()) {
    on<SubmitBranchReportEvent>(_onSubmitReport);
    on<LoadBranchReportsEvent>(_onLoadReports);
  }

  Future<void> _onSubmitReport(
    SubmitBranchReportEvent event,
    Emitter<BranchReportState> emit,
  ) async {
    emit(BranchReportLoading());
    final result = await repository.submitReport(event.report);
    result.fold(
      (failure) => emit(BranchReportError(failure.toString())),
      (report) => emit(BranchReportSubmitted(report)),
    );
  }

  Future<void> _onLoadReports(
    LoadBranchReportsEvent event,
    Emitter<BranchReportState> emit,
  ) async {
    emit(BranchReportLoading());
    final result = await repository.getReports();
    result.fold(
      (failure) => emit(BranchReportError(failure.toString())),
      (reports) => emit(BranchReportLoaded(reports)),
    );
  }
}
"""

with open(os.path.join(base_path, "presentation/bloc/branch_report_bloc.dart"), "w") as f:
    f.write(bloc_code)

# 7. UI Screen
ui_code = """import 'package:flutter/material.dart';

class BranchReportScreen extends StatefulWidget {
  const BranchReportScreen({Key? key}) : super(key: key);

  @override
  State<BranchReportScreen> createState() => _BranchReportScreenState();
}

class _BranchReportScreenState extends State<BranchReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('শাখার রিপোর্ট ফরম - খেলাফত মজলিস'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('জনশক্তি'),
            // TODO: Add form fields for Manpower
            _buildSectionHeader('দাওয়াত ও গণসংযোগ'),
            // TODO: Add form fields for Dawah
            _buildSectionHeader('সংগঠন'),
            // TODO: Add form fields for Organization
            _buildSectionHeader('সভাসমূহ'),
            // TODO: Add form fields for Meetings
            _buildSectionHeader('বায়তুলমাল'),
            // TODO: Add form fields for Baytulmal
            _buildSectionHeader('সফর'),
            // TODO: Add form fields for Tour
            _buildSectionHeader('প্রশিক্ষণ'),
            // TODO: Add form fields for Training
            _buildSectionHeader('দফতর'),
            // TODO: Add form fields for Office
            _buildSectionHeader('প্রচার'),
            // TODO: Add form fields for Publicity
            _buildSectionHeader('পাঠাগার'),
            // TODO: Add form fields for Library
            _buildSectionHeader('সমাজকল্যাণ'),
            // TODO: Add form fields for Social Welfare
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'মন্তব্য (সমস্যা ও সম্ভাবনা উল্লেখসহ)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Dispatch SubmitBranchReportEvent
              },
              child: const Text('জমা দিন'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
"""

with open(os.path.join(base_path, "presentation/pages/branch_report_screen.dart"), "w") as f:
    f.write(ui_code)

print("Files generated successfully.")
