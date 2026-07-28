import 'package:equatable/equatable.dart';

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
