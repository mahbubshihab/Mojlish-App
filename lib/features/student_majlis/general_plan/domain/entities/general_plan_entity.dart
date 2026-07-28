import 'package:equatable/equatable.dart';

class GeneralPlanEntity extends Equatable {
  final String branch;
  final String month;
  final String session;

  // Phase 1: Dawah
  final int friendIncrease;
  final int primaryMemberIncrease;
  final int schoolGovt;
  final int schoolNonGovt;
  final int college;
  final int madrasaAlia;
  final int madrasaQawmi;
  final int university;
  final int wellWisherIncrease;

  // Phase 2: Organization
  final int associateMemberTarget;
  final int workerIncrease;

  // Phase 3: Training
  final int workshopCount;
  final int educationMeetingCount;

  // Phase 4: Movement (Student Welfare & Social Service)
  final int zakatCollection;

  // Baitulmal Budget
  final int totalIncome;
  final int totalExpenditure;

  const GeneralPlanEntity({
    required this.branch,
    required this.month,
    required this.session,
    required this.friendIncrease,
    required this.primaryMemberIncrease,
    required this.schoolGovt,
    required this.schoolNonGovt,
    required this.college,
    required this.madrasaAlia,
    required this.madrasaQawmi,
    required this.university,
    required this.wellWisherIncrease,
    required this.associateMemberTarget,
    required this.workerIncrease,
    required this.workshopCount,
    required this.educationMeetingCount,
    required this.zakatCollection,
    required this.totalIncome,
    required this.totalExpenditure,
  });

  @override
  List<Object?> get props => [
        branch,
        month,
        session,
        friendIncrease,
        primaryMemberIncrease,
        schoolGovt,
        schoolNonGovt,
        college,
        madrasaAlia,
        madrasaQawmi,
        university,
        wellWisherIncrease,
        associateMemberTarget,
        workerIncrease,
        workshopCount,
        educationMeetingCount,
        zakatCollection,
        totalIncome,
        totalExpenditure,
      ];
}
