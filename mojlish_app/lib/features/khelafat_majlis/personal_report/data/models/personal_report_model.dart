import '../../domain/entities/personal_report.dart';

class DailyActivityModel extends DailyActivity {
  DailyActivityModel({
    required super.date,
    required super.quranStudySurahAyat,
    required super.hadithStudyNumberSubject,
    required super.islamicLiteratureNamePage,
    required super.jamaatNamazWaqt,
    required super.communicationNumberName,
    required super.dawatNumberName,
    required super.meetingAttendanceNumber,
    required super.timeGivenHours,
    required super.socialServiceKind,
    required super.selfCriticismYesNo,
  });

  factory DailyActivityModel.fromJson(Map<String, dynamic> json) {
    return DailyActivityModel(
      date: json['date'] ?? 0,
      quranStudySurahAyat: json['quranStudySurahAyat'] ?? '',
      hadithStudyNumberSubject: json['hadithStudyNumberSubject'] ?? '',
      islamicLiteratureNamePage: json['islamicLiteratureNamePage'] ?? '',
      jamaatNamazWaqt: json['jamaatNamazWaqt'] ?? '',
      communicationNumberName: json['communicationNumberName'] ?? '',
      dawatNumberName: json['dawatNumberName'] ?? '',
      meetingAttendanceNumber: json['meetingAttendanceNumber'] ?? '',
      timeGivenHours: json['timeGivenHours'] ?? '',
      socialServiceKind: json['socialServiceKind'] ?? '',
      selfCriticismYesNo: json['selfCriticismYesNo'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'quranStudySurahAyat': quranStudySurahAyat,
      'hadithStudyNumberSubject': hadithStudyNumberSubject,
      'islamicLiteratureNamePage': islamicLiteratureNamePage,
      'jamaatNamazWaqt': jamaatNamazWaqt,
      'communicationNumberName': communicationNumberName,
      'dawatNumberName': dawatNumberName,
      'meetingAttendanceNumber': meetingAttendanceNumber,
      'timeGivenHours': timeGivenHours,
      'socialServiceKind': socialServiceKind,
      'selfCriticismYesNo': selfCriticismYesNo,
    };
  }
}

class PersonalReportModel extends PersonalReport {
  PersonalReportModel({
    required super.workerName,
    required super.branch,
    required super.month,
    required super.year,
    required super.dailyActivities,
    required super.meetingsAttendedThisMonth,
    required super.meetingNames,
    required super.branchResponsibleComments,
  });

  factory PersonalReportModel.fromJson(Map<String, dynamic> json) {
    return PersonalReportModel(
      workerName: json['workerName'] ?? '',
      branch: json['branch'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      dailyActivities: (json['dailyActivities'] as List?)
              ?.map((e) => DailyActivityModel.fromJson(e))
              .toList() ??
          [],
      meetingsAttendedThisMonth: json['meetingsAttendedThisMonth'] ?? '',
      meetingNames: json['meetingNames'] ?? '',
      branchResponsibleComments: json['branchResponsibleComments'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workerName': workerName,
      'branch': branch,
      'month': month,
      'year': year,
      'dailyActivities':
          dailyActivities.map((e) => (e as DailyActivityModel).toJson()).toList(),
      'meetingsAttendedThisMonth': meetingsAttendedThisMonth,
      'meetingNames': meetingNames,
      'branchResponsibleComments': branchResponsibleComments,
    };
  }
}
