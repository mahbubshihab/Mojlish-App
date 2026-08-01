import 'package:equatable/equatable.dart';

class WomenMajlisPersonalReportDailyEntry extends Equatable {
  final int date;
  final String quranStudy;
  final String hadithStudy;
  final String islamicLiteratureReading;
  final String contact;
  final String dawah;
  final String meetingAttendance;
  final int timeGivenHours;
  final String socialService;
  final bool selfCriticism;

  const WomenMajlisPersonalReportDailyEntry({
    required this.date,
    required this.quranStudy,
    required this.hadithStudy,
    required this.islamicLiteratureReading,
    required this.contact,
    required this.dawah,
    required this.meetingAttendance,
    required this.timeGivenHours,
    required this.socialService,
    required this.selfCriticism,
  });

  @override
  List<Object?> get props => [
        date,
        quranStudy,
        hadithStudy,
        islamicLiteratureReading,
        contact,
        dawah,
        meetingAttendance,
        timeGivenHours,
        socialService,
        selfCriticism,
      ];
}

class WomenMajlisPersonalReportEntity extends Equatable {
  final String workerName;
  final String branch;
  final String month;
  final String year;
  final List<WomenMajlisPersonalReportDailyEntry> dailyEntries;
  final int meetingsAttendedThisMonth;
  final String meetingName;
  final String branchResponsibleComment;
  final String responsibleSignature;

  const WomenMajlisPersonalReportEntity({
    required this.workerName,
    required this.branch,
    required this.month,
    required this.year,
    required this.dailyEntries,
    required this.meetingsAttendedThisMonth,
    required this.meetingName,
    required this.branchResponsibleComment,
    required this.responsibleSignature,
  });

  @override
  List<Object?> get props => [
        workerName,
        branch,
        month,
        year,
        dailyEntries,
        meetingsAttendedThisMonth,
        meetingName,
        branchResponsibleComment,
        responsibleSignature,
      ];
}
