class PersonalPlanEntity {
  final String id;
  final String name;
  final String branch;
  final String responsibility;
  final String month;
  final String year;

  // Study
  final String quranAyatCount;
  final String quranSuraPara;
  final String quranDarasCount;
  final String quranDarasTopic;
  final String quranMemorizeAyat;

  final String hadithCount;
  final String hadithBookTopic;
  final String hadithDarasCount;
  final String hadithDarasTopic;
  final String hadithMemorizeCount;
  final String hadithMemorizeTopic;

  final String islamicLiteraturePages;
  final String islamicLiteratureBookName;
  final String islamicLiteratureBookNotesPage;

  final String textbookClassAvgHours;
  final String textbookClassTime;

  // Worship
  final String jamatNamazWaqt;
  final String selfEvaluationDays;
  final String nafalIbadat;

  // Dawah
  final String friendTargetContactCount;
  final String friendTargetContactName;
  final String primaryMemberIncreaseContactCount;
  final String primaryMemberIncreaseContactName;
  final String bookIntroStickerDistributionCount;
  final String studentReviewDistributionCount;
  final String wellWisherIncreaseContactCount;
  final String wellWisherIncreaseContactName;
  final String cardGiftSmsEmailLetterMagazineCount;
  final String groupDawahCount;
  final String otherDawahMaterialsDistribution;

  // Organizational
  final String workerStandardUpgradeCount;
  final String workerStandardUpgradeName;
  final String meetingAttendanceCount;
  final String orgDawahTimeAvgHours;
  final String baytulmalAmount;
  final String workerContactCount;
  final String workerNames;

  // Misc
  final String dailyOtherNewspaperAvgHours;
  final String physicalExerciseDays;
  final String techLanguageStudyAvgHours;
  final String familySocialWorkAvgHours;
  final String others;

  // For Concerned Persons
  final String memberLevelUpgradeTargetCount;
  final String memberLevelUpgradeTargetName;
  final String associateMemberLevelUpgradeTargetCount;
  final String associateMemberLevelUpgradeTargetName;

  PersonalPlanEntity({
    this.id = '',
    this.name = '',
    this.branch = '',
    this.responsibility = '',
    this.month = '',
    this.year = '',
    this.quranAyatCount = '',
    this.quranSuraPara = '',
    this.quranDarasCount = '',
    this.quranDarasTopic = '',
    this.quranMemorizeAyat = '',
    this.hadithCount = '',
    this.hadithBookTopic = '',
    this.hadithDarasCount = '',
    this.hadithDarasTopic = '',
    this.hadithMemorizeCount = '',
    this.hadithMemorizeTopic = '',
    this.islamicLiteraturePages = '',
    this.islamicLiteratureBookName = '',
    this.islamicLiteratureBookNotesPage = '',
    this.textbookClassAvgHours = '',
    this.textbookClassTime = '',
    this.jamatNamazWaqt = '',
    this.selfEvaluationDays = '',
    this.nafalIbadat = '',
    this.friendTargetContactCount = '',
    this.friendTargetContactName = '',
    this.primaryMemberIncreaseContactCount = '',
    this.primaryMemberIncreaseContactName = '',
    this.bookIntroStickerDistributionCount = '',
    this.studentReviewDistributionCount = '',
    this.wellWisherIncreaseContactCount = '',
    this.wellWisherIncreaseContactName = '',
    this.cardGiftSmsEmailLetterMagazineCount = '',
    this.groupDawahCount = '',
    this.otherDawahMaterialsDistribution = '',
    this.workerStandardUpgradeCount = '',
    this.workerStandardUpgradeName = '',
    this.meetingAttendanceCount = '',
    this.orgDawahTimeAvgHours = '',
    this.baytulmalAmount = '',
    this.workerContactCount = '',
    this.workerNames = '',
    this.dailyOtherNewspaperAvgHours = '',
    this.physicalExerciseDays = '',
    this.techLanguageStudyAvgHours = '',
    this.familySocialWorkAvgHours = '',
    this.others = '',
    this.memberLevelUpgradeTargetCount = '',
    this.memberLevelUpgradeTargetName = '',
    this.associateMemberLevelUpgradeTargetCount = '',
    this.associateMemberLevelUpgradeTargetName = '',
  });
}
