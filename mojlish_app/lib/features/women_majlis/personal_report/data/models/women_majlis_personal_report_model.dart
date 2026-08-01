import '../../domain/entities/women_majlis_personal_report_entity.dart';

class WomenMajlisPersonalReportDailyEntryModel extends WomenMajlisPersonalReportDailyEntry {
  const WomenMajlisPersonalReportDailyEntryModel({
    required super.date,
    required super.quranStudy,
    required super.hadithStudy,
    required super.islamicLiteratureReading,
    required super.contact,
    required super.dawah,
    required super.meetingAttendance,
    required super.timeGivenHours,
    required super.socialService,
    required super.selfCriticism,
  });

  factory WomenMajlisPersonalReportDailyEntryModel.fromJson(Map<String, dynamic> json) {
    return WomenMajlisPersonalReportDailyEntryModel(
      date: json['date'] ?? 0,
      quranStudy: json['quranStudy'] ?? '',
      hadithStudy: json['hadithStudy'] ?? '',
      islamicLiteratureReading: json['islamicLiteratureReading'] ?? '',
      contact: json['contact'] ?? '',
      dawah: json['dawah'] ?? '',
      meetingAttendance: json['meetingAttendance'] ?? '',
      timeGivenHours: json['timeGivenHours'] ?? 0,
      socialService: json['socialService'] ?? '',
      selfCriticism: json['selfCriticism'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'quranStudy': quranStudy,
      'hadithStudy': hadithStudy,
      'islamicLiteratureReading': islamicLiteratureReading,
      'contact': contact,
      'dawah': dawah,
      'meetingAttendance': meetingAttendance,
      'timeGivenHours': timeGivenHours,
      'socialService': socialService,
      'selfCriticism': selfCriticism,
    };
  }
}

class WomenMajlisPersonalReportModel extends WomenMajlisPersonalReportEntity {
  const WomenMajlisPersonalReportModel({
    required super.workerName,
    required super.branch,
    required super.month,
    required super.year,
    required super.dailyEntries,
    required super.meetingsAttendedThisMonth,
    required super.meetingName,
    required super.branchResponsibleComment,
    required super.responsibleSignature,
  });

  factory WomenMajlisPersonalReportModel.fromJson(Map<String, dynamic> json) {
    return WomenMajlisPersonalReportModel(
      workerName: json['workerName'] ?? '',
      branch: json['branch'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      dailyEntries: (json['dailyEntries'] as List<dynamic>?)
              ?.map((e) => WomenMajlisPersonalReportDailyEntryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meetingsAttendedThisMonth: json['meetingsAttendedThisMonth'] ?? 0,
      meetingName: json['meetingName'] ?? '',
      branchResponsibleComment: json['branchResponsibleComment'] ?? '',
      responsibleSignature: json['responsibleSignature'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workerName': workerName,
      'branch': branch,
      'month': month,
      'year': year,
      'dailyEntries': dailyEntries.map((e) => (e as WomenMajlisPersonalReportDailyEntryModel).toJson()).toList(),
      'meetingsAttendedThisMonth': meetingsAttendedThisMonth,
      'meetingName': meetingName,
      'branchResponsibleComment': branchResponsibleComment,
      'responsibleSignature': responsibleSignature,
    };
  }
}
