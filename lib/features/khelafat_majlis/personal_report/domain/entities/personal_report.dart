class DailyActivity {
  final int date;
  final String quranStudySurahAyat;
  final String hadithStudyNumberSubject;
  final String islamicLiteratureNamePage;
  final String jamaatNamazWaqt;
  final String communicationNumberName;
  final String dawatNumberName;
  final String meetingAttendanceNumber;
  final String timeGivenHours;
  final String socialServiceKind;
  final bool selfCriticismYesNo;

  DailyActivity({
    required this.date,
    required this.quranStudySurahAyat,
    required this.hadithStudyNumberSubject,
    required this.islamicLiteratureNamePage,
    required this.jamaatNamazWaqt,
    required this.communicationNumberName,
    required this.dawatNumberName,
    required this.meetingAttendanceNumber,
    required this.timeGivenHours,
    required this.socialServiceKind,
    required this.selfCriticismYesNo,
  });
}

class PersonalReport {
  final String workerName;
  final String branch;
  final String month;
  final String year;
  final List<DailyActivity> dailyActivities;
  final String meetingsAttendedThisMonth;
  final String meetingNames;
  final String branchResponsibleComments;

  PersonalReport({
    required this.workerName,
    required this.branch,
    required this.month,
    required this.year,
    required this.dailyActivities,
    required this.meetingsAttendedThisMonth,
    required this.meetingNames,
    required this.branchResponsibleComments,
  });
}
