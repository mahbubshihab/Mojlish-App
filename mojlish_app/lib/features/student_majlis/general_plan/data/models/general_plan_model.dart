import '../../domain/entities/general_plan_entity.dart';

class GeneralPlanModel extends GeneralPlanEntity {
  const GeneralPlanModel({
    required super.branch,
    required super.month,
    required super.session,
    required super.friendIncrease,
    required super.primaryMemberIncrease,
    required super.schoolGovt,
    required super.schoolNonGovt,
    required super.college,
    required super.madrasaAlia,
    required super.madrasaQawmi,
    required super.university,
    required super.wellWisherIncrease,
    required super.associateMemberTarget,
    required super.workerIncrease,
    required super.workshopCount,
    required super.educationMeetingCount,
    required super.zakatCollection,
    required super.totalIncome,
    required super.totalExpenditure,
  });

  factory GeneralPlanModel.fromJson(Map<String, dynamic> json) {
    return GeneralPlanModel(
      branch: json['branch'] ?? '',
      month: json['month'] ?? '',
      session: json['session'] ?? '',
      friendIncrease: json['friendIncrease'] ?? 0,
      primaryMemberIncrease: json['primaryMemberIncrease'] ?? 0,
      schoolGovt: json['schoolGovt'] ?? 0,
      schoolNonGovt: json['schoolNonGovt'] ?? 0,
      college: json['college'] ?? 0,
      madrasaAlia: json['madrasaAlia'] ?? 0,
      madrasaQawmi: json['madrasaQawmi'] ?? 0,
      university: json['university'] ?? 0,
      wellWisherIncrease: json['wellWisherIncrease'] ?? 0,
      associateMemberTarget: json['associateMemberTarget'] ?? 0,
      workerIncrease: json['workerIncrease'] ?? 0,
      workshopCount: json['workshopCount'] ?? 0,
      educationMeetingCount: json['educationMeetingCount'] ?? 0,
      zakatCollection: json['zakatCollection'] ?? 0,
      totalIncome: json['totalIncome'] ?? 0,
      totalExpenditure: json['totalExpenditure'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch': branch,
      'month': month,
      'session': session,
      'friendIncrease': friendIncrease,
      'primaryMemberIncrease': primaryMemberIncrease,
      'schoolGovt': schoolGovt,
      'schoolNonGovt': schoolNonGovt,
      'college': college,
      'madrasaAlia': madrasaAlia,
      'madrasaQawmi': madrasaQawmi,
      'university': university,
      'wellWisherIncrease': wellWisherIncrease,
      'associateMemberTarget': associateMemberTarget,
      'workerIncrease': workerIncrease,
      'workshopCount': workshopCount,
      'educationMeetingCount': educationMeetingCount,
      'zakatCollection': zakatCollection,
      'totalIncome': totalIncome,
      'totalExpenditure': totalExpenditure,
    };
  }
}
