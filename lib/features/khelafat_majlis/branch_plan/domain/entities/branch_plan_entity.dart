class BranchPlanEntity {
  final String branchName;
  final String month;
  final String year;

  // You can add more detailed entity fields for Manpower, Dawah, etc.
  final Map<String, dynamic> manpower;
  final List<Map<String, dynamic>> dawahPrograms;
  final List<Map<String, dynamic>> organizations;
  final Map<String, dynamic> baytulmal;
  final List<Map<String, dynamic>> travels;
  final List<Map<String, dynamic>> meetings;
  final List<Map<String, dynamic>> trainings;
  final Map<String, dynamic> department;
  final List<Map<String, dynamic>> publications;
  final Map<String, dynamic> library;
  final Map<String, dynamic> socialWelfare;

  BranchPlanEntity({
    required this.branchName,
    required this.month,
    required this.year,
    required this.manpower,
    required this.dawahPrograms,
    required this.organizations,
    required this.baytulmal,
    required this.travels,
    required this.meetings,
    required this.trainings,
    required this.department,
    required this.publications,
    required this.library,
    required this.socialWelfare,
  });
}
