import 'package:mojlish_app/features/youth_majlis/personal_report/domain/entities/personal_report.dart';

class YouthMajlisDailyActivityModel extends YouthMajlisDailyActivity {
  const YouthMajlisDailyActivityModel({
    required super.day,
    required super.jamatNamazCount,
    required super.quranSurah,
    required super.quranAyat,
    required super.hadithCount,
    required super.hadithTopic,
    required super.islamicLiteratureName,
    required super.islamicLiteraturePageCount,
    required super.workerCommunicationCount,
    required super.workerCommunicationNames,
    required super.dawatCount,
    required super.dawatNames,
    required super.timeGivenHours,
    required super.jobBusinessTimeGivenHours,
    required super.selfCriticism,
  });

  factory YouthMajlisDailyActivityModel.fromJson(Map<String, dynamic> json) {
    return YouthMajlisDailyActivityModel(
      day: json['day'] ?? 0,
      jamatNamazCount: json['jamatNamazCount'] ?? 0,
      quranSurah: json['quranSurah'] ?? '',
      quranAyat: json['quranAyat'] ?? '',
      hadithCount: json['hadithCount'] ?? 0,
      hadithTopic: json['hadithTopic'] ?? '',
      islamicLiteratureName: json['islamicLiteratureName'] ?? '',
      islamicLiteraturePageCount: json['islamicLiteraturePageCount'] ?? 0,
      workerCommunicationCount: json['workerCommunicationCount'] ?? 0,
      workerCommunicationNames: json['workerCommunicationNames'] ?? '',
      dawatCount: json['dawatCount'] ?? 0,
      dawatNames: json['dawatNames'] ?? '',
      timeGivenHours: (json['timeGivenHours'] ?? 0).toDouble(),
      jobBusinessTimeGivenHours: (json['jobBusinessTimeGivenHours'] ?? 0).toDouble(),
      selfCriticism: json['selfCriticism'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'jamatNamazCount': jamatNamazCount,
      'quranSurah': quranSurah,
      'quranAyat': quranAyat,
      'hadithCount': hadithCount,
      'hadithTopic': hadithTopic,
      'islamicLiteratureName': islamicLiteratureName,
      'islamicLiteraturePageCount': islamicLiteraturePageCount,
      'workerCommunicationCount': workerCommunicationCount,
      'workerCommunicationNames': workerCommunicationNames,
      'dawatCount': dawatCount,
      'dawatNames': dawatNames,
      'timeGivenHours': timeGivenHours,
      'jobBusinessTimeGivenHours': jobBusinessTimeGivenHours,
      'selfCriticism': selfCriticism,
    };
  }
}

class YouthMajlisPersonalReportModel extends YouthMajlisPersonalReport {
  const YouthMajlisPersonalReportModel({
    required super.id,
    required super.name,
    required super.memberType,
    required super.branch,
    required super.month,
    required super.year,
    required super.dailyActivities,
    required super.totalMeetingsAttended,
    required super.meetingNames,
    required super.supervisorComments,
    required super.branchOfficialName,
    super.createdAt,
  });

  factory YouthMajlisPersonalReportModel.fromJson(Map<String, dynamic> json) {
    return YouthMajlisPersonalReportModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      memberType: json['memberType'] ?? '',
      branch: json['branch'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      dailyActivities: (json['dailyActivities'] as List<dynamic>?)
              ?.map((e) => YouthMajlisDailyActivityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalMeetingsAttended: json['totalMeetingsAttended'] ?? 0,
      meetingNames: json['meetingNames'] ?? '',
      supervisorComments: json['supervisorComments'] ?? '',
      branchOfficialName: json['branchOfficialName'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'memberType': memberType,
      'branch': branch,
      'month': month,
      'year': year,
      'dailyActivities': dailyActivities
          .map((e) => (e as YouthMajlisDailyActivityModel).toJson())
          .toList(),
      'totalMeetingsAttended': totalMeetingsAttended,
      'meetingNames': meetingNames,
      'supervisorComments': supervisorComments,
      'branchOfficialName': branchOfficialName,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
