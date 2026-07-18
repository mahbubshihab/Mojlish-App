class MonthlyPlan {
  final int year;
  final int month;

  // কুরআন অধ্যয়ন
  final String quranAyahCount;
  final String quranSuraPara;
  final String quranDarsCount;
  final String quranDarsTopic;
  final String quranMemorizeAyah;

  // হাদিস অধ্যয়ন
  final String hadithCount;
  final String hadithTopic;
  final String hadithDarsCount;
  final String hadithDarsTopic;
  final String hadithMemorizeCount;
  final String hadithMemorizeTopic;

  // দ্বীনি সাহিত্য
  final String litPages;
  final String litBook;
  final String litNotes; // বই/আলোচনা নোট

  // পাঠ্যপুস্তক
  final String academicHours;

  // ইবাদত
  final String jamaatPrayerWaqt;
  final String selfAnalysisDays;
  final String naflPrayer;

  // দাওয়াতি কাজ
  final String friendTargetCount;
  final String friendTargetNames;
  final String primaryMemberTargetCount;
  final String primaryMemberTargetNames;
  final String dawahBookletCount;   // বই/পরিচিতি/স্টিকার বিতরণ
  final String studentReviewCount; // ছাত্র পরিক্রমা বিতরণ
  final String supporterTargetCount;
  final String supporterTargetNames;
  final String giftSmsCount;        // কার্ড/উপহার/SMS বিতরণ
  final String groupDawahCount;     // গ্রুপ দাওয়াত বার
  final String otherDawahMaterials; // অন্যান্য দাওয়াতি উপকরণ বিতরণ

  // সাংগঠনিক কাজ
  final String upgradeWorkerCount;
  final String upgradeWorkerNames;
  final String meetingsCount;
  final String orgHours;
  final String baytulmalAmount;
  final String workerContactsCount;
  final String workerContactsNames;

  // বিবিধ
  final String newspaperMinutes;
  final String physicalExerciseDays;
  final String technicalSkillHours;
  final String familyTimeHours;
  final String otherNotes;

  // সংশ্লিষ্টদের জন্য
  final String memberUpgradeTargetCount;
  final String memberUpgradeTargetNames;
  final String associateUpgradeTargetCount;
  final String associateUpgradeTargetNames;

  const MonthlyPlan({
    required this.year,
    required this.month,
    this.quranAyahCount = '',
    this.quranSuraPara = '',
    this.quranDarsCount = '',
    this.quranDarsTopic = '',
    this.quranMemorizeAyah = '',
    this.hadithCount = '',
    this.hadithTopic = '',
    this.hadithDarsCount = '',
    this.hadithDarsTopic = '',
    this.hadithMemorizeCount = '',
    this.hadithMemorizeTopic = '',
    this.litPages = '',
    this.litBook = '',
    this.litNotes = '',
    this.academicHours = '',
    this.jamaatPrayerWaqt = '',
    this.selfAnalysisDays = '',
    this.naflPrayer = '',
    this.friendTargetCount = '',
    this.friendTargetNames = '',
    this.primaryMemberTargetCount = '',
    this.primaryMemberTargetNames = '',
    this.dawahBookletCount = '',
    this.studentReviewCount = '',
    this.supporterTargetCount = '',
    this.supporterTargetNames = '',
    this.giftSmsCount = '',
    this.groupDawahCount = '',
    this.otherDawahMaterials = '',
    this.upgradeWorkerCount = '',
    this.upgradeWorkerNames = '',
    this.meetingsCount = '',
    this.orgHours = '',
    this.baytulmalAmount = '',
    this.workerContactsCount = '',
    this.workerContactsNames = '',
    this.newspaperMinutes = '',
    this.physicalExerciseDays = '',
    this.technicalSkillHours = '',
    this.familyTimeHours = '',
    this.otherNotes = '',
    this.memberUpgradeTargetCount = '',
    this.memberUpgradeTargetNames = '',
    this.associateUpgradeTargetCount = '',
    this.associateUpgradeTargetNames = '',
  });

  Map<String, dynamic> toJson() => {
    'year': year,
    'month': month,
    'quranAyahCount': quranAyahCount,
    'quranSuraPara': quranSuraPara,
    'quranDarsCount': quranDarsCount,
    'quranDarsTopic': quranDarsTopic,
    'quranMemorizeAyah': quranMemorizeAyah,
    'hadithCount': hadithCount,
    'hadithTopic': hadithTopic,
    'hadithDarsCount': hadithDarsCount,
    'hadithDarsTopic': hadithDarsTopic,
    'hadithMemorizeCount': hadithMemorizeCount,
    'hadithMemorizeTopic': hadithMemorizeTopic,
    'litPages': litPages,
    'litBook': litBook,
    'litNotes': litNotes,
    'academicHours': academicHours,
    'jamaatPrayerWaqt': jamaatPrayerWaqt,
    'selfAnalysisDays': selfAnalysisDays,
    'naflPrayer': naflPrayer,
    'friendTargetCount': friendTargetCount,
    'friendTargetNames': friendTargetNames,
    'primaryMemberTargetCount': primaryMemberTargetCount,
    'primaryMemberTargetNames': primaryMemberTargetNames,
    'dawahBookletCount': dawahBookletCount,
    'studentReviewCount': studentReviewCount,
    'supporterTargetCount': supporterTargetCount,
    'supporterTargetNames': supporterTargetNames,
    'giftSmsCount': giftSmsCount,
    'groupDawahCount': groupDawahCount,
    'otherDawahMaterials': otherDawahMaterials,
    'upgradeWorkerCount': upgradeWorkerCount,
    'upgradeWorkerNames': upgradeWorkerNames,
    'meetingsCount': meetingsCount,
    'orgHours': orgHours,
    'baytulmalAmount': baytulmalAmount,
    'workerContactsCount': workerContactsCount,
    'workerContactsNames': workerContactsNames,
    'newspaperMinutes': newspaperMinutes,
    'physicalExerciseDays': physicalExerciseDays,
    'technicalSkillHours': technicalSkillHours,
    'familyTimeHours': familyTimeHours,
    'otherNotes': otherNotes,
    'memberUpgradeTargetCount': memberUpgradeTargetCount,
    'memberUpgradeTargetNames': memberUpgradeTargetNames,
    'associateUpgradeTargetCount': associateUpgradeTargetCount,
    'associateUpgradeTargetNames': associateUpgradeTargetNames,
  };

  factory MonthlyPlan.fromJson(Map<String, dynamic> json) {
    return MonthlyPlan(
      year: json['year'] ?? 0,
      month: json['month'] ?? 0,
      quranAyahCount: json['quranAyahCount'] ?? '',
      quranSuraPara: json['quranSuraPara'] ?? '',
      quranDarsCount: json['quranDarsCount'] ?? '',
      quranDarsTopic: json['quranDarsTopic'] ?? '',
      quranMemorizeAyah: json['quranMemorizeAyah'] ?? '',
      hadithCount: json['hadithCount'] ?? '',
      hadithTopic: json['hadithTopic'] ?? '',
      hadithDarsCount: json['hadithDarsCount'] ?? '',
      hadithDarsTopic: json['hadithDarsTopic'] ?? '',
      hadithMemorizeCount: json['hadithMemorizeCount'] ?? '',
      hadithMemorizeTopic: json['hadithMemorizeTopic'] ?? '',
      litPages: json['litPages'] ?? '',
      litBook: json['litBook'] ?? '',
      litNotes: json['litNotes'] ?? '',
      academicHours: json['academicHours'] ?? '',
      jamaatPrayerWaqt: json['jamaatPrayerWaqt'] ?? '',
      selfAnalysisDays: json['selfAnalysisDays'] ?? '',
      naflPrayer: json['naflPrayer'] ?? '',
      friendTargetCount: json['friendTargetCount'] ?? '',
      friendTargetNames: json['friendTargetNames'] ?? '',
      primaryMemberTargetCount: json['primaryMemberTargetCount'] ?? '',
      primaryMemberTargetNames: json['primaryMemberTargetNames'] ?? '',
      dawahBookletCount: json['dawahBookletCount'] ?? '',
      studentReviewCount: json['studentReviewCount'] ?? '',
      supporterTargetCount: json['supporterTargetCount'] ?? '',
      supporterTargetNames: json['supporterTargetNames'] ?? '',
      giftSmsCount: json['giftSmsCount'] ?? '',
      groupDawahCount: json['groupDawahCount'] ?? '',
      otherDawahMaterials: json['otherDawahMaterials'] ?? '',
      upgradeWorkerCount: json['upgradeWorkerCount'] ?? '',
      upgradeWorkerNames: json['upgradeWorkerNames'] ?? '',
      meetingsCount: json['meetingsCount'] ?? '',
      orgHours: json['orgHours'] ?? '',
      baytulmalAmount: json['baytulmalAmount'] ?? '',
      workerContactsCount: json['workerContactsCount'] ?? '',
      workerContactsNames: json['workerContactsNames'] ?? '',
      newspaperMinutes: json['newspaperMinutes'] ?? '',
      physicalExerciseDays: json['physicalExerciseDays'] ?? '',
      technicalSkillHours: json['technicalSkillHours'] ?? '',
      familyTimeHours: json['familyTimeHours'] ?? '',
      otherNotes: json['otherNotes'] ?? '',
      memberUpgradeTargetCount: json['memberUpgradeTargetCount'] ?? '',
      memberUpgradeTargetNames: json['memberUpgradeTargetNames'] ?? '',
      associateUpgradeTargetCount: json['associateUpgradeTargetCount'] ?? '',
      associateUpgradeTargetNames: json['associateUpgradeTargetNames'] ?? '',
    );
  }
}
