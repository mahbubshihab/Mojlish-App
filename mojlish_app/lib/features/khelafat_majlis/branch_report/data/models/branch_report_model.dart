import '../../domain/entities/branch_report.dart';

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
