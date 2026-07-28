import '../../domain/entities/branch_plan_entity.dart';

class BranchPlanModel extends BranchPlanEntity {
  BranchPlanModel({
    required super.branchName,
    required super.month,
    required super.year,
    required super.manpower,
    required super.dawahPrograms,
    required super.organizations,
    required super.baytulmal,
    required super.travels,
    required super.meetings,
    required super.trainings,
    required super.department,
    required super.publications,
    required super.library,
    required super.socialWelfare,
  });

  factory BranchPlanModel.fromJson(Map<String, dynamic> json) {
    return BranchPlanModel(
      branchName: json['branchName'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      manpower: json['manpower'] ?? {},
      dawahPrograms: List<Map<String, dynamic>>.from(json['dawahPrograms'] ?? []),
      organizations: List<Map<String, dynamic>>.from(json['organizations'] ?? []),
      baytulmal: json['baytulmal'] ?? {},
      travels: List<Map<String, dynamic>>.from(json['travels'] ?? []),
      meetings: List<Map<String, dynamic>>.from(json['meetings'] ?? []),
      trainings: List<Map<String, dynamic>>.from(json['trainings'] ?? []),
      department: json['department'] ?? {},
      publications: List<Map<String, dynamic>>.from(json['publications'] ?? []),
      library: json['library'] ?? {},
      socialWelfare: json['socialWelfare'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchName': branchName,
      'month': month,
      'year': year,
      'manpower': manpower,
      'dawahPrograms': dawahPrograms,
      'organizations': organizations,
      'baytulmal': baytulmal,
      'travels': travels,
      'meetings': meetings,
      'trainings': trainings,
      'department': department,
      'publications': publications,
      'library': library,
      'socialWelfare': socialWelfare,
    };
  }
}
