/// জনশক্তি বিভাগের জন্য সাব-মডেল
class ManpowerCategoryData {
  final int presentCount;
  final int increase;
  final String how;
  final int target;
  final int deficit;
  final String reason;

  const ManpowerCategoryData({
    this.presentCount = 0,
    this.increase = 0,
    this.how = '',
    this.target = 0,
    this.deficit = 0,
    this.reason = '',
  });

  Map<String, dynamic> toJson() => {
        'presentCount': presentCount,
        'increase': increase,
        'how': how,
        'target': target,
        'deficit': deficit,
        'reason': reason,
      };

  factory ManpowerCategoryData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ManpowerCategoryData();
    return ManpowerCategoryData(
      presentCount: (json['presentCount'] as num?)?.toInt() ?? 0,
      increase: (json['increase'] as num?)?.toInt() ?? 0,
      how: json['how'] as String? ?? '',
      target: (json['target'] as num?)?.toInt() ?? 0,
      deficit: (json['deficit'] as num?)?.toInt() ?? 0,
      reason: json['reason'] as String? ?? '',
    );
  }

  ManpowerCategoryData copyWith({
    int? presentCount,
    int? increase,
    String? how,
    int? target,
    int? deficit,
    String? reason,
  }) {
    return ManpowerCategoryData(
      presentCount: presentCount ?? this.presentCount,
      increase: increase ?? this.increase,
      how: how ?? this.how,
      target: target ?? this.target,
      deficit: deficit ?? this.deficit,
      reason: reason ?? this.reason,
    );
  }
}

/// শাখা সামারির জন্য সাব-মডেল
class BranchSummaryData {
  final int count;
  final int increase;
  final int deficit;

  const BranchSummaryData({
    this.count = 0,
    this.increase = 0,
    this.deficit = 0,
  });

  Map<String, dynamic> toJson() => {
        'count': count,
        'increase': increase,
        'deficit': deficit,
      };

  factory BranchSummaryData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BranchSummaryData();
    return BranchSummaryData(
      count: (json['count'] as num?)?.toInt() ?? 0,
      increase: (json['increase'] as num?)?.toInt() ?? 0,
      deficit: (json['deficit'] as num?)?.toInt() ?? 0,
    );
  }

  BranchSummaryData copyWith({
    int? count,
    int? increase,
    int? deficit,
  }) {
    return BranchSummaryData(
      count: count ?? this.count,
      increase: increase ?? this.increase,
      deficit: deficit ?? this.deficit,
    );
  }
}

/// সভা ডেটার জন্য সাব-মডেল
class MeetingData {
  final int count;
  final int attendance;
  final String maxMin;

  const MeetingData({
    this.count = 0,
    this.attendance = 0,
    this.maxMin = '',
  });

  Map<String, dynamic> toJson() => {
        'count': count,
        'attendance': attendance,
        'maxMin': maxMin,
      };

  factory MeetingData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const MeetingData();
    return MeetingData(
      count: (json['count'] as num?)?.toInt() ?? 0,
      attendance: (json['attendance'] as num?)?.toInt() ?? 0,
      maxMin: json['maxMin'] as String? ?? '',
    );
  }

  MeetingData copyWith({
    int? count,
    int? attendance,
    String? maxMin,
  }) {
    return MeetingData(
      count: count ?? this.count,
      attendance: attendance ?? this.attendance,
      maxMin: maxMin ?? this.maxMin,
    );
  }
}

/// প্রশিক্ষণ ডেটার জন্য সাব-মডেল
class TrainingData {
  final int count;
  final int sessionCount;
  final int attendance;
  final String maxMin;

  const TrainingData({
    this.count = 0,
    this.sessionCount = 0,
    this.attendance = 0,
    this.maxMin = '',
  });

  Map<String, dynamic> toJson() => {
        'count': count,
        'sessionCount': sessionCount,
        'attendance': attendance,
        'maxMin': maxMin,
      };

  factory TrainingData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TrainingData();
    return TrainingData(
      count: (json['count'] as num?)?.toInt() ?? 0,
      sessionCount: (json['sessionCount'] as num?)?.toInt() ?? 0,
      attendance: (json['attendance'] as num?)?.toInt() ?? 0,
      maxMin: json['maxMin'] as String? ?? '',
    );
  }

  TrainingData copyWith({
    int? count,
    int? sessionCount,
    int? attendance,
    String? maxMin,
  }) {
    return TrainingData(
      count: count ?? this.count,
      sessionCount: sessionCount ?? this.sessionCount,
      attendance: attendance ?? this.attendance,
      maxMin: maxMin ?? this.maxMin,
    );
  }
}

/// যোগাযোগ ডেটার জন্য সাব-মডেল
class CommItemData {
  final int count;
  final int copyCount;

  const CommItemData({
    this.count = 0,
    this.copyCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'count': count,
        'copyCount': copyCount,
      };

  factory CommItemData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CommItemData();
    return CommItemData(
      count: (json['count'] as num?)?.toInt() ?? 0,
      copyCount: (json['copyCount'] as num?)?.toInt() ?? 0,
    );
  }

  CommItemData copyWith({
    int? count,
    int? copyCount,
  }) {
    return CommItemData(
      count: count ?? this.count,
      copyCount: copyCount ?? this.copyCount,
    );
  }
}

/// বাংলাদেশ ইসলামী ছাত্র মজলিস — বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট মডেল
class StudentPeriodReportModel {
  final String id;
  final String branch;
  final String periodType; // 'দ্বি-মাসিক', 'ষান্মাসিক', 'বার্ষিক'
  final String periodName; // 'জানুয়ারী - ফেব্রুয়ারি' ইত্যাদি
  final String session;
  final int year;

  // ১. জনশক্তি
  final ManpowerCategoryData sodosso;
  final ManpowerCategoryData sodossoPrarthi;
  final ManpowerCategoryData sohoyogiSodosso;
  final ManpowerCategoryData sohoyogiSodossoPrarthi;
  final ManpowerCategoryData kormi;

  // ২. দাওয়াত ও বিতরণ
  final int primaryMemberDawahCount;
  final int primaryMemberDawahIncrease;
  final int friendDawahCount;
  final int friendDawahIncrease;
  final int wellWisherDawahCount;
  final int wellWisherDawahIncrease;

  final int groupDawahCount;
  final int teaCircleCount;
  final BranchSummaryData primaryBranch;
  final BranchSummaryData instBranch;
  final BranchSummaryData residentialBranch;

  final String islamicLiterature;
  final String introductionBook;
  final String studentReview;
  final String teenMagazine;
  final String stickerCardDiary;
  final String routineFormula;
  final String leafletPosterCalendar;
  final String invitationCardGift;

  final int newsPublishedCount;
  final int wallMagazineCount;
  final int wallWritingCount;
  final int competitionCount;
  final int freshersReceptionCount;
  final String otherDawahMediaDetails;

  // ৩. সংগঠন
  final int publicUniversity;
  final int privateUniversity;
  final int medicalCollege;
  final int universityCollege;
  final int homeoCollege;
  final int lawCollege;
  final int technicalInst;
  final int govCollege;
  final int nonGovCollege;
  final int kamilMadrasa;
  final int fazilMadrasa;
  final int alimMadrasa;
  final int dakhilMadrasa;
  final int qawmiMadrasa;
  final int govSchool;
  final int nonGovSchool;
  final int zoneThana;

  final int totalBranchCount;
  final int kormiBranchCount;
  final BranchSummaryData instBranchSummary;
  final BranchSummaryData residentialBranchSummary;
  final String associateMemberBranchNames;

  // ৪. সভাসমূহ (পৃষ্ঠা ২)
  final MeetingData dayittoshilMeeting;
  final MeetingData thanaZonalMeeting;
  final MeetingData sodossoMeeting;
  final MeetingData sohoyogiSodossoMeeting;
  final MeetingData kormiMeeting;
  final MeetingData emergencyMeeting;
  final MeetingData generalMeeting;

  final MeetingData discussionMeeting;
  final MeetingData sohoyogiSodossoSamabesh;
  final MeetingData kormiSamabesh;
  final MeetingData studentSamabesh;
  final MeetingData rally;
  final MeetingData dayObservance;
  final MeetingData otherMeetings;

  // ৫. প্রশিক্ষণ (পৃষ্ঠা ২)
  final TrainingData skillsDev;
  final TrainingData workshop;
  final TrainingData torbiyatiSofor;
  final TrainingData trainingCircle;
  final TrainingData shikshaSobha;
  final TrainingData quranHadithClass;
  final TrainingData shabGujari;
  final TrainingData zikrMahfil;
  final TrainingData samostikOddhayon;
  final TrainingData hadithPath;
  final TrainingData culturalForum;
  final TrainingData openClass;

  // ৬. পাঠাগার
  final int libraryCount;
  final int bookCount;
  final int readerCount;
  final int issuedBooks;
  final int readBooks;
  final int libraryIncrease;
  final int libraryDeficit;

  // ৭. বায়তুলমাল
  final double totalIncome;
  final double totalExpense;
  final double dueAmount;
  final double dueRepaid;
  final double seniorEyanatPaid;
  final double assignedAmount;

  // ৮. প্রকাশনা
  final double pubTotalPurchase;
  final double pubRepaid;
  final double pubDue;
  final double pubDueRepaid;

  // ৯. ছাত্রকল্যাণ
  final double welfareIncome;
  final double welfareExpense;
  final int lodgingCount;
  final int tuitionCount;
  final int tableBankCount;
  final int questionNoteBiliCount;
  final double zakatCollection;
  final int languageLibraryBookIncrease;
  final int academicCoachingCount;
  final int freeCoachingAccomodationCount;
  final int freeCoachingPersons;
  final int freeCoachingIncrease;
  final int freeCoachingDeficit;
  final int stipendActiveCount;
  final int bloodDonationBags;
  final int admissionGuideCount;
  final int admissionHelpPersons;
  final String otherWelfareDetails;
  final String tourDetails;

  // ১০. যোগাযোগ
  final CommItemData circularReceived;
  final CommItemData circularSent;
  final CommItemData letterReceived;
  final CommItemData letterSent;

  // ১১. অন্যান্য, বিবিধ ও মন্তব্য
  final String otherOrgActivities;
  final String miscellaneous;
  final String remarks;
  final String presidentSignatureDate;

  const StudentPeriodReportModel({
    required this.id,
    this.branch = '',
    this.periodType = 'দ্বি-মাসিক',
    this.periodName = 'জানুয়ারী - ফেব্রুয়ারি',
    this.session = '',
    required this.year,
    this.sodosso = const ManpowerCategoryData(),
    this.sodossoPrarthi = const ManpowerCategoryData(),
    this.sohoyogiSodosso = const ManpowerCategoryData(),
    this.sohoyogiSodossoPrarthi = const ManpowerCategoryData(),
    this.kormi = const ManpowerCategoryData(),
    this.primaryMemberDawahCount = 0,
    this.primaryMemberDawahIncrease = 0,
    this.friendDawahCount = 0,
    this.friendDawahIncrease = 0,
    this.wellWisherDawahCount = 0,
    this.wellWisherDawahIncrease = 0,
    this.groupDawahCount = 0,
    this.teaCircleCount = 0,
    this.primaryBranch = const BranchSummaryData(),
    this.instBranch = const BranchSummaryData(),
    this.residentialBranch = const BranchSummaryData(),
    this.islamicLiterature = '',
    this.introductionBook = '',
    this.studentReview = '',
    this.teenMagazine = '',
    this.stickerCardDiary = '',
    this.routineFormula = '',
    this.leafletPosterCalendar = '',
    this.invitationCardGift = '',
    this.newsPublishedCount = 0,
    this.wallMagazineCount = 0,
    this.wallWritingCount = 0,
    this.competitionCount = 0,
    this.freshersReceptionCount = 0,
    this.otherDawahMediaDetails = '',
    this.publicUniversity = 0,
    this.privateUniversity = 0,
    this.medicalCollege = 0,
    this.universityCollege = 0,
    this.homeoCollege = 0,
    this.lawCollege = 0,
    this.technicalInst = 0,
    this.govCollege = 0,
    this.nonGovCollege = 0,
    this.kamilMadrasa = 0,
    this.fazilMadrasa = 0,
    this.alimMadrasa = 0,
    this.dakhilMadrasa = 0,
    this.qawmiMadrasa = 0,
    this.govSchool = 0,
    this.nonGovSchool = 0,
    this.zoneThana = 0,
    this.totalBranchCount = 0,
    this.kormiBranchCount = 0,
    this.instBranchSummary = const BranchSummaryData(),
    this.residentialBranchSummary = const BranchSummaryData(),
    this.associateMemberBranchNames = '',
    this.dayittoshilMeeting = const MeetingData(),
    this.thanaZonalMeeting = const MeetingData(),
    this.sodossoMeeting = const MeetingData(),
    this.sohoyogiSodossoMeeting = const MeetingData(),
    this.kormiMeeting = const MeetingData(),
    this.emergencyMeeting = const MeetingData(),
    this.generalMeeting = const MeetingData(),
    this.discussionMeeting = const MeetingData(),
    this.sohoyogiSodossoSamabesh = const MeetingData(),
    this.kormiSamabesh = const MeetingData(),
    this.studentSamabesh = const MeetingData(),
    this.rally = const MeetingData(),
    this.dayObservance = const MeetingData(),
    this.otherMeetings = const MeetingData(),
    this.skillsDev = const TrainingData(),
    this.workshop = const TrainingData(),
    this.torbiyatiSofor = const TrainingData(),
    this.trainingCircle = const TrainingData(),
    this.shikshaSobha = const TrainingData(),
    this.quranHadithClass = const TrainingData(),
    this.shabGujari = const TrainingData(),
    this.zikrMahfil = const TrainingData(),
    this.samostikOddhayon = const TrainingData(),
    this.hadithPath = const TrainingData(),
    this.culturalForum = const TrainingData(),
    this.openClass = const TrainingData(),
    this.libraryCount = 0,
    this.bookCount = 0,
    this.readerCount = 0,
    this.issuedBooks = 0,
    this.readBooks = 0,
    this.libraryIncrease = 0,
    this.libraryDeficit = 0,
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.dueAmount = 0.0,
    this.dueRepaid = 0.0,
    this.seniorEyanatPaid = 0.0,
    this.assignedAmount = 0.0,
    this.pubTotalPurchase = 0.0,
    this.pubRepaid = 0.0,
    this.pubDue = 0.0,
    this.pubDueRepaid = 0.0,
    this.welfareIncome = 0.0,
    this.welfareExpense = 0.0,
    this.lodgingCount = 0,
    this.tuitionCount = 0,
    this.tableBankCount = 0,
    this.questionNoteBiliCount = 0,
    this.zakatCollection = 0.0,
    this.languageLibraryBookIncrease = 0,
    this.academicCoachingCount = 0,
    this.freeCoachingAccomodationCount = 0,
    this.freeCoachingPersons = 0,
    this.freeCoachingIncrease = 0,
    this.freeCoachingDeficit = 0,
    this.stipendActiveCount = 0,
    this.bloodDonationBags = 0,
    this.admissionGuideCount = 0,
    this.admissionHelpPersons = 0,
    this.otherWelfareDetails = '',
    this.tourDetails = '',
    this.circularReceived = const CommItemData(),
    this.circularSent = const CommItemData(),
    this.letterReceived = const CommItemData(),
    this.letterSent = const CommItemData(),
    this.otherOrgActivities = '',
    this.miscellaneous = '',
    this.remarks = '',
    this.presidentSignatureDate = '',
  });

  /// মোট জনশক্তি গণনার হেলপার গেটার (Total Manpower)
  ManpowerCategoryData get totalManpower {
    return ManpowerCategoryData(
      presentCount: sodosso.presentCount + sodossoPrarthi.presentCount + sohoyogiSodosso.presentCount + sohoyogiSodossoPrarthi.presentCount + kormi.presentCount,
      increase: sodosso.increase + sodossoPrarthi.increase + sohoyogiSodosso.increase + sohoyogiSodossoPrarthi.increase + kormi.increase,
      target: sodosso.target + sodossoPrarthi.target + sohoyogiSodosso.target + sohoyogiSodossoPrarthi.target + kormi.target,
      deficit: sodosso.deficit + sodossoPrarthi.deficit + sohoyogiSodosso.deficit + sohoyogiSodossoPrarthi.deficit + kormi.deficit,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'branch': branch,
        'periodType': periodType,
        'periodName': periodName,
        'session': session,
        'year': year,
        'sodosso': sodosso.toJson(),
        'sodossoPrarthi': sodossoPrarthi.toJson(),
        'sohoyogiSodosso': sohoyogiSodosso.toJson(),
        'sohoyogiSodossoPrarthi': sohoyogiSodossoPrarthi.toJson(),
        'kormi': kormi.toJson(),
        'primaryMemberDawahCount': primaryMemberDawahCount,
        'primaryMemberDawahIncrease': primaryMemberDawahIncrease,
        'friendDawahCount': friendDawahCount,
        'friendDawahIncrease': friendDawahIncrease,
        'wellWisherDawahCount': wellWisherDawahCount,
        'wellWisherDawahIncrease': wellWisherDawahIncrease,
        'groupDawahCount': groupDawahCount,
        'teaCircleCount': teaCircleCount,
        'primaryBranch': primaryBranch.toJson(),
        'instBranch': instBranch.toJson(),
        'residentialBranch': residentialBranch.toJson(),
        'islamicLiterature': islamicLiterature,
        'introductionBook': introductionBook,
        'studentReview': studentReview,
        'teenMagazine': teenMagazine,
        'stickerCardDiary': stickerCardDiary,
        'routineFormula': routineFormula,
        'leafletPosterCalendar': leafletPosterCalendar,
        'invitationCardGift': invitationCardGift,
        'newsPublishedCount': newsPublishedCount,
        'wallMagazineCount': wallMagazineCount,
        'wallWritingCount': wallWritingCount,
        'competitionCount': competitionCount,
        'freshersReceptionCount': freshersReceptionCount,
        'otherDawahMediaDetails': otherDawahMediaDetails,
        'publicUniversity': publicUniversity,
        'privateUniversity': privateUniversity,
        'medicalCollege': medicalCollege,
        'universityCollege': universityCollege,
        'homeoCollege': homeoCollege,
        'lawCollege': lawCollege,
        'technicalInst': technicalInst,
        'govCollege': govCollege,
        'nonGovCollege': nonGovCollege,
        'kamilMadrasa': kamilMadrasa,
        'fazilMadrasa': fazilMadrasa,
        'alimMadrasa': alimMadrasa,
        'dakhilMadrasa': dakhilMadrasa,
        'qawmiMadrasa': qawmiMadrasa,
        'govSchool': govSchool,
        'nonGovSchool': nonGovSchool,
        'zoneThana': zoneThana,
        'totalBranchCount': totalBranchCount,
        'kormiBranchCount': kormiBranchCount,
        'instBranchSummary': instBranchSummary.toJson(),
        'residentialBranchSummary': residentialBranchSummary.toJson(),
        'associateMemberBranchNames': associateMemberBranchNames,
        'dayittoshilMeeting': dayittoshilMeeting.toJson(),
        'thanaZonalMeeting': thanaZonalMeeting.toJson(),
        'sodossoMeeting': sodossoMeeting.toJson(),
        'sohoyogiSodossoMeeting': sohoyogiSodossoMeeting.toJson(),
        'kormiMeeting': kormiMeeting.toJson(),
        'emergencyMeeting': emergencyMeeting.toJson(),
        'generalMeeting': generalMeeting.toJson(),
        'discussionMeeting': discussionMeeting.toJson(),
        'sohoyogiSodossoSamabesh': sohoyogiSodossoSamabesh.toJson(),
        'kormiSamabesh': kormiSamabesh.toJson(),
        'studentSamabesh': studentSamabesh.toJson(),
        'rally': rally.toJson(),
        'dayObservance': dayObservance.toJson(),
        'otherMeetings': otherMeetings.toJson(),
        'skillsDev': skillsDev.toJson(),
        'workshop': workshop.toJson(),
        'torbiyatiSofor': torbiyatiSofor.toJson(),
        'trainingCircle': trainingCircle.toJson(),
        'shikshaSobha': shikshaSobha.toJson(),
        'quranHadithClass': quranHadithClass.toJson(),
        'shabGujari': shabGujari.toJson(),
        'zikrMahfil': zikrMahfil.toJson(),
        'samostikOddhayon': samostikOddhayon.toJson(),
        'hadithPath': hadithPath.toJson(),
        'culturalForum': culturalForum.toJson(),
        'openClass': openClass.toJson(),
        'libraryCount': libraryCount,
        'bookCount': bookCount,
        'readerCount': readerCount,
        'issuedBooks': issuedBooks,
        'readBooks': readBooks,
        'libraryIncrease': libraryIncrease,
        'libraryDeficit': libraryDeficit,
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
        'dueAmount': dueAmount,
        'dueRepaid': dueRepaid,
        'seniorEyanatPaid': seniorEyanatPaid,
        'assignedAmount': assignedAmount,
        'pubTotalPurchase': pubTotalPurchase,
        'pubRepaid': pubRepaid,
        'pubDue': pubDue,
        'pubDueRepaid': pubDueRepaid,
        'welfareIncome': welfareIncome,
        'welfareExpense': welfareExpense,
        'lodgingCount': lodgingCount,
        'tuitionCount': tuitionCount,
        'tableBankCount': tableBankCount,
        'questionNoteBiliCount': questionNoteBiliCount,
        'zakatCollection': zakatCollection,
        'languageLibraryBookIncrease': languageLibraryBookIncrease,
        'academicCoachingCount': academicCoachingCount,
        'freeCoachingAccomodationCount': freeCoachingAccomodationCount,
        'freeCoachingPersons': freeCoachingPersons,
        'freeCoachingIncrease': freeCoachingIncrease,
        'freeCoachingDeficit': freeCoachingDeficit,
        'stipendActiveCount': stipendActiveCount,
        'bloodDonationBags': bloodDonationBags,
        'admissionGuideCount': admissionGuideCount,
        'admissionHelpPersons': admissionHelpPersons,
        'otherWelfareDetails': otherWelfareDetails,
        'tourDetails': tourDetails,
        'circularReceived': circularReceived.toJson(),
        'circularSent': circularSent.toJson(),
        'letterReceived': letterReceived.toJson(),
        'letterSent': letterSent.toJson(),
        'otherOrgActivities': otherOrgActivities,
        'miscellaneous': miscellaneous,
        'remarks': remarks,
        'presidentSignatureDate': presidentSignatureDate,
      };

  factory StudentPeriodReportModel.fromJson(Map<String, dynamic> json) {
    return StudentPeriodReportModel(
      id: json['id'] as String,
      branch: json['branch'] as String? ?? '',
      periodType: json['periodType'] as String? ?? 'দ্বি-মাসিক',
      periodName: json['periodName'] as String? ?? 'জানুয়ারী - ফেব্রুয়ারি',
      session: json['session'] as String? ?? '',
      year: (json['year'] as num?)?.toInt() ?? DateTime.now().year,
      sodosso: ManpowerCategoryData.fromJson(json['sodosso'] as Map<String, dynamic>?),
      sodossoPrarthi: ManpowerCategoryData.fromJson(json['sodossoPrarthi'] as Map<String, dynamic>?),
      sohoyogiSodosso: ManpowerCategoryData.fromJson(json['sohoyogiSodosso'] as Map<String, dynamic>?),
      sohoyogiSodossoPrarthi: ManpowerCategoryData.fromJson(json['sohoyogiSodossoPrarthi'] as Map<String, dynamic>?),
      kormi: ManpowerCategoryData.fromJson(json['kormi'] as Map<String, dynamic>?),
      primaryMemberDawahCount: (json['primaryMemberDawahCount'] as num?)?.toInt() ?? 0,
      primaryMemberDawahIncrease: (json['primaryMemberDawahIncrease'] as num?)?.toInt() ?? 0,
      friendDawahCount: (json['friendDawahCount'] as num?)?.toInt() ?? 0,
      friendDawahIncrease: (json['friendDawahIncrease'] as num?)?.toInt() ?? 0,
      wellWisherDawahCount: (json['wellWisherDawahCount'] as num?)?.toInt() ?? 0,
      wellWisherDawahIncrease: (json['wellWisherDawahIncrease'] as num?)?.toInt() ?? 0,
      groupDawahCount: (json['groupDawahCount'] as num?)?.toInt() ?? 0,
      teaCircleCount: (json['teaCircleCount'] as num?)?.toInt() ?? 0,
      primaryBranch: BranchSummaryData.fromJson(json['primaryBranch'] as Map<String, dynamic>?),
      instBranch: BranchSummaryData.fromJson(json['instBranch'] as Map<String, dynamic>?),
      residentialBranch: BranchSummaryData.fromJson(json['residentialBranch'] as Map<String, dynamic>?),
      islamicLiterature: json['islamicLiterature'] as String? ?? '',
      introductionBook: json['introductionBook'] as String? ?? '',
      studentReview: json['studentReview'] as String? ?? '',
      teenMagazine: json['teenMagazine'] as String? ?? '',
      stickerCardDiary: json['stickerCardDiary'] as String? ?? '',
      routineFormula: json['routineFormula'] as String? ?? '',
      leafletPosterCalendar: json['leafletPosterCalendar'] as String? ?? '',
      invitationCardGift: json['invitationCardGift'] as String? ?? '',
      newsPublishedCount: (json['newsPublishedCount'] as num?)?.toInt() ?? 0,
      wallMagazineCount: (json['wallMagazineCount'] as num?)?.toInt() ?? 0,
      wallWritingCount: (json['wallWritingCount'] as num?)?.toInt() ?? 0,
      competitionCount: (json['competitionCount'] as num?)?.toInt() ?? 0,
      freshersReceptionCount: (json['freshersReceptionCount'] as num?)?.toInt() ?? 0,
      otherDawahMediaDetails: json['otherDawahMediaDetails'] as String? ?? '',
      publicUniversity: (json['publicUniversity'] as num?)?.toInt() ?? 0,
      privateUniversity: (json['privateUniversity'] as num?)?.toInt() ?? 0,
      medicalCollege: (json['medicalCollege'] as num?)?.toInt() ?? 0,
      universityCollege: (json['universityCollege'] as num?)?.toInt() ?? 0,
      homeoCollege: (json['homeoCollege'] as num?)?.toInt() ?? 0,
      lawCollege: (json['lawCollege'] as num?)?.toInt() ?? 0,
      technicalInst: (json['technicalInst'] as num?)?.toInt() ?? 0,
      govCollege: (json['govCollege'] as num?)?.toInt() ?? 0,
      nonGovCollege: (json['nonGovCollege'] as num?)?.toInt() ?? 0,
      kamilMadrasa: (json['kamilMadrasa'] as num?)?.toInt() ?? 0,
      fazilMadrasa: (json['fazilMadrasa'] as num?)?.toInt() ?? 0,
      alimMadrasa: (json['alimMadrasa'] as num?)?.toInt() ?? 0,
      dakhilMadrasa: (json['dakhilMadrasa'] as num?)?.toInt() ?? 0,
      qawmiMadrasa: (json['qawmiMadrasa'] as num?)?.toInt() ?? 0,
      govSchool: (json['govSchool'] as num?)?.toInt() ?? 0,
      nonGovSchool: (json['nonGovSchool'] as num?)?.toInt() ?? 0,
      zoneThana: (json['zoneThana'] as num?)?.toInt() ?? 0,
      totalBranchCount: (json['totalBranchCount'] as num?)?.toInt() ?? 0,
      kormiBranchCount: (json['kormiBranchCount'] as num?)?.toInt() ?? 0,
      instBranchSummary: BranchSummaryData.fromJson(json['instBranchSummary'] as Map<String, dynamic>?),
      residentialBranchSummary: BranchSummaryData.fromJson(json['residentialBranchSummary'] as Map<String, dynamic>?),
      associateMemberBranchNames: json['associateMemberBranchNames'] as String? ?? '',
      dayittoshilMeeting: MeetingData.fromJson(json['dayittoshilMeeting'] as Map<String, dynamic>?),
      thanaZonalMeeting: MeetingData.fromJson(json['thanaZonalMeeting'] as Map<String, dynamic>?),
      sodossoMeeting: MeetingData.fromJson(json['sodossoMeeting'] as Map<String, dynamic>?),
      sohoyogiSodossoMeeting: MeetingData.fromJson(json['sohoyogiSodossoMeeting'] as Map<String, dynamic>?),
      kormiMeeting: MeetingData.fromJson(json['kormiMeeting'] as Map<String, dynamic>?),
      emergencyMeeting: MeetingData.fromJson(json['emergencyMeeting'] as Map<String, dynamic>?),
      generalMeeting: MeetingData.fromJson(json['generalMeeting'] as Map<String, dynamic>?),
      discussionMeeting: MeetingData.fromJson(json['discussionMeeting'] as Map<String, dynamic>?),
      sohoyogiSodossoSamabesh: MeetingData.fromJson(json['sohoyogiSodossoSamabesh'] as Map<String, dynamic>?),
      kormiSamabesh: MeetingData.fromJson(json['kormiSamabesh'] as Map<String, dynamic>?),
      studentSamabesh: MeetingData.fromJson(json['studentSamabesh'] as Map<String, dynamic>?),
      rally: MeetingData.fromJson(json['rally'] as Map<String, dynamic>?),
      dayObservance: MeetingData.fromJson(json['dayObservance'] as Map<String, dynamic>?),
      otherMeetings: MeetingData.fromJson(json['otherMeetings'] as Map<String, dynamic>?),
      skillsDev: TrainingData.fromJson(json['skillsDev'] as Map<String, dynamic>?),
      workshop: TrainingData.fromJson(json['workshop'] as Map<String, dynamic>?),
      torbiyatiSofor: TrainingData.fromJson(json['torbiyatiSofor'] as Map<String, dynamic>?),
      trainingCircle: TrainingData.fromJson(json['trainingCircle'] as Map<String, dynamic>?),
      shikshaSobha: TrainingData.fromJson(json['shikshaSobha'] as Map<String, dynamic>?),
      quranHadithClass: TrainingData.fromJson(json['quranHadithClass'] as Map<String, dynamic>?),
      shabGujari: TrainingData.fromJson(json['shabGujari'] as Map<String, dynamic>?),
      zikrMahfil: TrainingData.fromJson(json['zikrMahfil'] as Map<String, dynamic>?),
      samostikOddhayon: TrainingData.fromJson(json['samostikOddhayon'] as Map<String, dynamic>?),
      hadithPath: TrainingData.fromJson(json['hadithPath'] as Map<String, dynamic>?),
      culturalForum: TrainingData.fromJson(json['culturalForum'] as Map<String, dynamic>?),
      openClass: TrainingData.fromJson(json['openClass'] as Map<String, dynamic>?),
      libraryCount: (json['libraryCount'] as num?)?.toInt() ?? 0,
      bookCount: (json['bookCount'] as num?)?.toInt() ?? 0,
      readerCount: (json['readerCount'] as num?)?.toInt() ?? 0,
      issuedBooks: (json['issuedBooks'] as num?)?.toInt() ?? 0,
      readBooks: (json['readBooks'] as num?)?.toInt() ?? 0,
      libraryIncrease: (json['libraryIncrease'] as num?)?.toInt() ?? 0,
      libraryDeficit: (json['libraryDeficit'] as num?)?.toInt() ?? 0,
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (json['totalExpense'] as num?)?.toDouble() ?? 0.0,
      dueAmount: (json['dueAmount'] as num?)?.toDouble() ?? 0.0,
      dueRepaid: (json['dueRepaid'] as num?)?.toDouble() ?? 0.0,
      seniorEyanatPaid: (json['seniorEyanatPaid'] as num?)?.toDouble() ?? 0.0,
      assignedAmount: (json['assignedAmount'] as num?)?.toDouble() ?? 0.0,
      pubTotalPurchase: (json['pubTotalPurchase'] as num?)?.toDouble() ?? 0.0,
      pubRepaid: (json['pubRepaid'] as num?)?.toDouble() ?? 0.0,
      pubDue: (json['pubDue'] as num?)?.toDouble() ?? 0.0,
      pubDueRepaid: (json['pubDueRepaid'] as num?)?.toDouble() ?? 0.0,
      welfareIncome: (json['welfareIncome'] as num?)?.toDouble() ?? 0.0,
      welfareExpense: (json['welfareExpense'] as num?)?.toDouble() ?? 0.0,
      lodgingCount: (json['lodgingCount'] as num?)?.toInt() ?? 0,
      tuitionCount: (json['tuitionCount'] as num?)?.toInt() ?? 0,
      tableBankCount: (json['tableBankCount'] as num?)?.toInt() ?? 0,
      questionNoteBiliCount: (json['questionNoteBiliCount'] as num?)?.toInt() ?? 0,
      zakatCollection: (json['zakatCollection'] as num?)?.toDouble() ?? 0.0,
      languageLibraryBookIncrease: (json['languageLibraryBookIncrease'] as num?)?.toInt() ?? 0,
      academicCoachingCount: (json['academicCoachingCount'] as num?)?.toInt() ?? 0,
      freeCoachingAccomodationCount: (json['freeCoachingAccomodationCount'] as num?)?.toInt() ?? 0,
      freeCoachingPersons: (json['freeCoachingPersons'] as num?)?.toInt() ?? 0,
      freeCoachingIncrease: (json['freeCoachingIncrease'] as num?)?.toInt() ?? 0,
      freeCoachingDeficit: (json['freeCoachingDeficit'] as num?)?.toInt() ?? 0,
      stipendActiveCount: (json['stipendActiveCount'] as num?)?.toInt() ?? 0,
      bloodDonationBags: (json['bloodDonationBags'] as num?)?.toInt() ?? 0,
      admissionGuideCount: (json['admissionGuideCount'] as num?)?.toInt() ?? 0,
      admissionHelpPersons: (json['admissionHelpPersons'] as num?)?.toInt() ?? 0,
      otherWelfareDetails: json['otherWelfareDetails'] as String? ?? '',
      tourDetails: json['tourDetails'] as String? ?? '',
      circularReceived: CommItemData.fromJson(json['circularReceived'] as Map<String, dynamic>?),
      circularSent: CommItemData.fromJson(json['circularSent'] as Map<String, dynamic>?),
      letterReceived: CommItemData.fromJson(json['letterReceived'] as Map<String, dynamic>?),
      letterSent: CommItemData.fromJson(json['letterSent'] as Map<String, dynamic>?),
      otherOrgActivities: json['otherOrgActivities'] as String? ?? '',
      miscellaneous: json['miscellaneous'] as String? ?? '',
      remarks: json['remarks'] as String? ?? '',
      presidentSignatureDate: json['presidentSignatureDate'] as String? ?? '',
    );
  }

  factory StudentPeriodReportModel.empty({
    required String periodType,
    required int year,
    required String periodName,
  }) {
    final keyId = '${periodType}_${year}_${periodName.replaceAll(' ', '_')}';
    return StudentPeriodReportModel(
      id: keyId,
      periodType: periodType,
      year: year,
      periodName: periodName,
    );
  }
}
