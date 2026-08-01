import 'package:equatable/equatable.dart';

class YouthMajlisDailyActivity extends Equatable {
  final int day;
  final int jamatNamazCount;
  final String quranSurah;
  final String quranAyat;
  final int hadithCount;
  final String hadithTopic;
  final String islamicLiteratureName;
  final int islamicLiteraturePageCount;
  final int workerCommunicationCount;
  final String workerCommunicationNames;
  final int dawatCount;
  final String dawatNames;
  final double timeGivenHours;
  final double jobBusinessTimeGivenHours;
  final bool selfCriticism;

  const YouthMajlisDailyActivity({
    required this.day,
    required this.jamatNamazCount,
    required this.quranSurah,
    required this.quranAyat,
    required this.hadithCount,
    required this.hadithTopic,
    required this.islamicLiteratureName,
    required this.islamicLiteraturePageCount,
    required this.workerCommunicationCount,
    required this.workerCommunicationNames,
    required this.dawatCount,
    required this.dawatNames,
    required this.timeGivenHours,
    required this.jobBusinessTimeGivenHours,
    required this.selfCriticism,
  });

  @override
  List<Object?> get props => [
        day,
        jamatNamazCount,
        quranSurah,
        quranAyat,
        hadithCount,
        hadithTopic,
        islamicLiteratureName,
        islamicLiteraturePageCount,
        workerCommunicationCount,
        workerCommunicationNames,
        dawatCount,
        dawatNames,
        timeGivenHours,
        jobBusinessTimeGivenHours,
        selfCriticism,
      ];
}

class YouthMajlisPersonalReport extends Equatable {
  final String id;
  final String name;
  final String memberType;
  final String branch;
  final String month;
  final String year;
  final List<YouthMajlisDailyActivity> dailyActivities;
  final int totalMeetingsAttended;
  final String meetingNames;
  final String supervisorComments;
  final String branchOfficialName;
  final DateTime? createdAt;

  const YouthMajlisPersonalReport({
    required this.id,
    required this.name,
    required this.memberType,
    required this.branch,
    required this.month,
    required this.year,
    required this.dailyActivities,
    required this.totalMeetingsAttended,
    required this.meetingNames,
    required this.supervisorComments,
    required this.branchOfficialName,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        memberType,
        branch,
        month,
        year,
        dailyActivities,
        totalMeetingsAttended,
        meetingNames,
        supervisorComments,
        branchOfficialName,
        createdAt,
      ];
}
