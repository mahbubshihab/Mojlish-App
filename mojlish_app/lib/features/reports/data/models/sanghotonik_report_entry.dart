class SanghotonikReportEntry {
  final String month; //padLeft(2, '0')
  final String year;
  final String branchName;

  // জনশক্তি (Manpower)
  final String sodossoCount;
  final String sodossoBridhi;
  final String sodossoGhatti;
  final String sodossoPrarthiCount;
  final String sodossoPrarthiBridhi;
  final String sodossoPrarthiGhatti;
  final String kormiCount;
  final String kormiBridhi;
  final String kormiGhatti;
  final String prathmikSodossoCount;
  final String prathmikSodossoBridhi;
  final String prathmikSodossoGhatti;
  final String sudhiCount;

  // দাওয়াত ও গণসংযোগ (Dawah & Contact)
  final String dawahPersonalCount;
  final String dawahPersonalPresence;
  final String dawahGroupCount;
  final String dawahGroupPresence;
  final String dawahMahfilCount;
  final String dawahMahfilPresence;
  final String leafletDistributed;
  final String posterPasted;

  // সংগঠন (Organization)
  final String administrativeUnitCount;
  final String administrativeUnitName;
  final String mosqueOrganizationCount;

  // সভাধমূহ (Meetings)
  final String generalMeetingCount;
  final String generalMeetingPresence;
  final String kormiMeetingCount;
  final String kormiMeetingPresence;

  // বায়তুলমাল সংক্ষিপ্ত
  final String totalIncome;
  final String totalExpense;

  // প্রচার, প্রকাশনা ও পাঠাগার
  final String newsReleaseCount;
  final String posterPublished;
  final String libraryBookCount;
  final String libraryBookReadCount;

  // সমাজকল্যাণ ও মন্তব্য
  final String socialWelfareTaka;
  final String remarks;

  SanghotonikReportEntry({
    required this.month,
    required this.year,
    required this.branchName,
    this.sodossoCount = '',
    this.sodossoBridhi = '',
    this.sodossoGhatti = '',
    this.sodossoPrarthiCount = '',
    this.sodossoPrarthiBridhi = '',
    this.sodossoPrarthiGhatti = '',
    this.kormiCount = '',
    this.kormiBridhi = '',
    this.kormiGhatti = '',
    this.prathmikSodossoCount = '',
    this.prathmikSodossoBridhi = '',
    this.prathmikSodossoGhatti = '',
    this.sudhiCount = '',
    this.dawahPersonalCount = '',
    this.dawahPersonalPresence = '',
    this.dawahGroupCount = '',
    this.dawahGroupPresence = '',
    this.dawahMahfilCount = '',
    this.dawahMahfilPresence = '',
    this.leafletDistributed = '',
    this.posterPasted = '',
    this.administrativeUnitCount = '',
    this.administrativeUnitName = '',
    this.mosqueOrganizationCount = '',
    this.generalMeetingCount = '',
    this.generalMeetingPresence = '',
    this.kormiMeetingCount = '',
    this.kormiMeetingPresence = '',
    this.totalIncome = '',
    this.totalExpense = '',
    this.newsReleaseCount = '',
    this.posterPublished = '',
    this.libraryBookCount = '',
    this.libraryBookReadCount = '',
    this.socialWelfareTaka = '',
    this.remarks = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'year': year,
      'branchName': branchName,
      'sodossoCount': sodossoCount,
      'sodossoBridhi': sodossoBridhi,
      'sodossoGhatti': sodossoGhatti,
      'sodossoPrarthiCount': sodossoPrarthiCount,
      'sodossoPrarthiBridhi': sodossoPrarthiBridhi,
      'sodossoPrarthiGhatti': sodossoPrarthiGhatti,
      'kormiCount': kormiCount,
      'kormiBridhi': kormiBridhi,
      'kormiGhatti': kormiGhatti,
      'prathmikSodossoCount': prathmikSodossoCount,
      'prathmikSodossoBridhi': prathmikSodossoBridhi,
      'prathmikSodossoGhatti': prathmikSodossoGhatti,
      'sudhiCount': sudhiCount,
      'dawahPersonalCount': dawahPersonalCount,
      'dawahPersonalPresence': dawahPersonalPresence,
      'dawahGroupCount': dawahGroupCount,
      'dawahGroupPresence': dawahGroupPresence,
      'dawahMahfilCount': dawahMahfilCount,
      'dawahMahfilPresence': dawahMahfilPresence,
      'leafletDistributed': leafletDistributed,
      'posterPasted': posterPasted,
      'administrativeUnitCount': administrativeUnitCount,
      'administrativeUnitName': administrativeUnitName,
      'mosqueOrganizationCount': mosqueOrganizationCount,
      'generalMeetingCount': generalMeetingCount,
      'generalMeetingPresence': generalMeetingPresence,
      'kormiMeetingCount': kormiMeetingCount,
      'kormiMeetingPresence': kormiMeetingPresence,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'newsReleaseCount': newsReleaseCount,
      'posterPublished': posterPublished,
      'libraryBookCount': libraryBookCount,
      'libraryBookReadCount': libraryBookReadCount,
      'socialWelfareTaka': socialWelfareTaka,
      'remarks': remarks,
    };
  }

  factory SanghotonikReportEntry.fromJson(Map<String, dynamic> json) {
    return SanghotonikReportEntry(
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      branchName: json['branchName'] ?? '',
      sodossoCount: json['sodossoCount'] ?? '',
      sodossoBridhi: json['sodossoBridhi'] ?? '',
      sodossoGhatti: json['sodossoGhatti'] ?? '',
      sodossoPrarthiCount: json['sodossoPrarthiCount'] ?? '',
      sodossoPrarthiBridhi: json['sodossoPrarthiBridhi'] ?? '',
      sodossoPrarthiGhatti: json['sodossoPrarthiGhatti'] ?? '',
      kormiCount: json['kormiCount'] ?? '',
      kormiBridhi: json['kormiBridhi'] ?? '',
      kormiGhatti: json['kormiGhatti'] ?? '',
      prathmikSodossoCount: json['prathmikSodossoCount'] ?? '',
      prathmikSodossoBridhi: json['prathmikSodossoBridhi'] ?? '',
      prathmikSodossoGhatti: json['prathmikSodossoGhatti'] ?? '',
      sudhiCount: json['sudhiCount'] ?? '',
      dawahPersonalCount: json['dawahPersonalCount'] ?? '',
      dawahPersonalPresence: json['dawahPersonalPresence'] ?? '',
      dawahGroupCount: json['dawahGroupCount'] ?? '',
      dawahGroupPresence: json['dawahGroupPresence'] ?? '',
      dawahMahfilCount: json['dawahMahfilCount'] ?? '',
      dawahMahfilPresence: json['dawahMahfilPresence'] ?? '',
      leafletDistributed: json['leafletDistributed'] ?? '',
      posterPasted: json['posterPasted'] ?? '',
      administrativeUnitCount: json['administrativeUnitCount'] ?? '',
      administrativeUnitName: json['administrativeUnitName'] ?? '',
      mosqueOrganizationCount: json['mosqueOrganizationCount'] ?? '',
      generalMeetingCount: json['generalMeetingCount'] ?? '',
      generalMeetingPresence: json['generalMeetingPresence'] ?? '',
      kormiMeetingCount: json['kormiMeetingCount'] ?? '',
      kormiMeetingPresence: json['kormiMeetingPresence'] ?? '',
      totalIncome: json['totalIncome'] ?? '',
      totalExpense: json['totalExpense'] ?? '',
      newsReleaseCount: json['newsReleaseCount'] ?? '',
      posterPublished: json['posterPublished'] ?? '',
      libraryBookCount: json['libraryBookCount'] ?? '',
      libraryBookReadCount: json['libraryBookReadCount'] ?? '',
      socialWelfareTaka: json['socialWelfareTaka'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }
}
