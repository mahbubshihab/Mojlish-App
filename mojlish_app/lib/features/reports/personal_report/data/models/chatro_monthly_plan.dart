import 'dart:convert';

/// ছাত্র মজলিস মাসিক/মেয়াদী পরিকল্পনা মডেল
/// স্ক্যান করা অফিশিয়াল ফরমের ৭টি দফা অনুযায়ী
class ChatroMonthlyPlan {
  final int year;
  final int month;
  final String session;
  final String branchName;

  // ১ম দফা: দাওয়াত
  final String friendTarget;             // বন্ধু বৃদ্ধি (জন)
  final String primaryMemberTarget;      // প্রাথমিক সদস্য বৃদ্ধি (জন)
  final String schoolGovtCount;          // ক. স্কুল সরকারি (জন)
  final String schoolNonGovtCount;       // স্কুল বেসরকারি (জন)
  final String collegeCount;             // খ. কলেজ (জন)
  final String madrasaAliaCount;         // গ. মাদ্রাসা আলিয়া (জন)
  final String madrasaQawmiCount;        // মাদ্রাসা কওমী (জন)
  final String universityCount;          // ঘ. বিশ্ববিদ্যালয় (জন)
  final String wellWisherCount;          // শুভাকাঙ্ক্ষী বৃদ্ধি/যোগাযোগ (জন)
  final String literatureDistribution;    // পরিচিতি/ইসলামী সাহিত্য বিতরণ (টি)
  final String magazineDistribution;      // ছাত্র পরিক্রমা/কিশোর পত্রিকা বিতরণ (টি)
  final String posterStickerCount;       // লিফলেট/স্টিকার/পোস্টার (টি)
  final String wallWritingCount;         // দেয়াল লিখন/নবীন বরণ (টি)
  final String groupDawahCount;          // গ্রুপ দাওয়াত/চা চক্র (টি)
  final String debateCompetitionCount;   // বক্তৃতা/বিতর্ক/সাধারণ জ্ঞান (টি)
  final String institutionalBranchCount; // কাজ বৃদ্ধি প্রাতিষ্ঠানিক (টি)
  final String residentialBranchCount;   // কাজ বৃদ্ধি আবাসিক (টি)

  // ২য় দফা: সংগঠন
  final String associateCandidateTarget; // সহযোগী সদস্য প্রার্থী টার্গেট (জন/নাম)
  final String kormiTarget;              // কর্মী বৃদ্ধি (জন)
  final String associateBranchIncrease;  // সহযোগী সদস্য শাখা বৃদ্ধি (টি/নাম)
  final String zonalBranchIncrease;      // থানা/জোন শাখা বৃদ্ধি (টি/নাম)
  final String workerBranchIncrease;     // কর্মী শাখা বৃদ্ধি (টি)
  final String seniorVisitCount;         // ঊর্ধ্বতন সফর আনা হবে (টি/তারিখ)

  // ৩য় দফা: সভাসমূহ
  final String executiveMeetingCount;    // দায়িত্বশীল সভা (টি/তারিখ)
  final String zonalMeetingCount;        // জোনাল দায়িত্বশীল সভা (টি/তারিখ)
  final String memberMeetingCount;       // সদস্য সভা (টি/তারিখ)
  final String associateMeetingCount;    // সহযোগী সদস্য সভা (টি/তারিখ)
  final String workerMeetingCount;       // কর্মী সভা (টি/তারিখ)
  final String generalMeetingCount;      // সাধারণ সভা (টি/তারিখ)
  final String discussionMeetingCount;   // আলোচনা সভা (টি/তারিখ)
  final String baytulmalCollectionTarget;// বায়তুলমাল সংগ্রহ করা হবে (টাকা)

  // ৪র্থ দফা: প্রশিক্ষণ
  final String workshopCount;            // কর্মশালা (টি/তারিখ)
  final String studyTourCount;           // শিক্ষা সফর (টি/তারিখ)
  final String groupStudyCount;          // সমষ্টিগত অধ্যয়ন (অধিবেশন)
  final String nightStayCount;           // শবগুজারী (টি/তারিখ)
  final String zikrMahfilCount;          // জিকির মাহফিল (টি/তারিখ)
  final String trainingCircleCount;      // প্রশিক্ষণ চক্র (টি)
  final String skillCourseCount;         // স্কিলস ডেভেলপমেন্ট কোর্স (টি)
  final String quranHadithClassCount;    // কুরআন ও হাদিস শিক্ষা ক্লাস (টি)
  final String masailaClassCount;        // মাসআলা-মাসায়েল শিক্ষা ক্লাস (টি)
  final String openClassCount;           // উন্মুক্ত ক্লাস (টি)
  final String libraryBookIncrease;      // পাঠাগার বৃদ্ধি (বই)

  // ৫ম দফা: আন্দোলন ও ছাত্রকল্যাণ
  final String zakatCollectionTarget;    // যাকাত সংগ্রহ (টাকা)
  final String tuitionHelpCount;         // লজিং/টিউশনি সংগ্রহ (টি)
  final String hostelHelpCount;          // আবাসন ব্যবস্থা (জন)
  final String coachingClassCount;       // একাডেমিক/ভর্তি কোচিং (টি)
  final String noteBookDistribution;     // প্রশ্নপত্র/সাজেশন/নোট বিতরণ (টি)
  final String libraryEstablishment;     // লাইব্রেরী প্রতিষ্ঠা (টি)

  // ৬ষ্ঠ দফা: সামাজিক খেদমত
  final String treePlantationCount;      // গাছ লাগানো হবে (টি)
  final String bloodDonationBags;        // রক্তদান করা হবে (ব্যাগ)
  final String quranTeachingCount;       // সাধারণ মানুষের জন্য কুরআন শিক্ষা (জন)
  final String socialWelfareNotes;       // খেদমত ও দুস্থ মানুষের পাশে দাঁড়ানো

  // ৭ম দফা: বাজেট
  final String totalEstimatedIncome;     // মোট সম্ভাব্য আয় (টাকা)
  final String totalEstimatedExpense;    // মোট সম্ভাব্য ব্যয় (টাকা)

  const ChatroMonthlyPlan({
    required this.year,
    required this.month,
    this.session = '',
    this.branchName = '',
    this.friendTarget = '',
    this.primaryMemberTarget = '',
    this.schoolGovtCount = '',
    this.schoolNonGovtCount = '',
    this.collegeCount = '',
    this.madrasaAliaCount = '',
    this.madrasaQawmiCount = '',
    this.universityCount = '',
    this.wellWisherCount = '',
    this.literatureDistribution = '',
    this.magazineDistribution = '',
    this.posterStickerCount = '',
    this.wallWritingCount = '',
    this.groupDawahCount = '',
    this.debateCompetitionCount = '',
    this.institutionalBranchCount = '',
    this.residentialBranchCount = '',
    this.associateCandidateTarget = '',
    this.kormiTarget = '',
    this.associateBranchIncrease = '',
    this.zonalBranchIncrease = '',
    this.workerBranchIncrease = '',
    this.seniorVisitCount = '',
    this.executiveMeetingCount = '',
    this.zonalMeetingCount = '',
    this.memberMeetingCount = '',
    this.associateMeetingCount = '',
    this.workerMeetingCount = '',
    this.generalMeetingCount = '',
    this.discussionMeetingCount = '',
    this.baytulmalCollectionTarget = '',
    this.workshopCount = '',
    this.studyTourCount = '',
    this.groupStudyCount = '',
    this.nightStayCount = '',
    this.zikrMahfilCount = '',
    this.trainingCircleCount = '',
    this.skillCourseCount = '',
    this.quranHadithClassCount = '',
    this.masailaClassCount = '',
    this.openClassCount = '',
    this.libraryBookIncrease = '',
    this.zakatCollectionTarget = '',
    this.tuitionHelpCount = '',
    this.hostelHelpCount = '',
    this.coachingClassCount = '',
    this.noteBookDistribution = '',
    this.libraryEstablishment = '',
    this.treePlantationCount = '',
    this.bloodDonationBags = '',
    this.quranTeachingCount = '',
    this.socialWelfareNotes = '',
    this.totalEstimatedIncome = '',
    this.totalEstimatedExpense = '',
  });

  Map<String, dynamic> toJson() => {
    'year': year,
    'month': month,
    'session': session,
    'branchName': branchName,
    'friendTarget': friendTarget,
    'primaryMemberTarget': primaryMemberTarget,
    'schoolGovtCount': schoolGovtCount,
    'schoolNonGovtCount': schoolNonGovtCount,
    'collegeCount': collegeCount,
    'madrasaAliaCount': madrasaAliaCount,
    'madrasaQawmiCount': madrasaQawmiCount,
    'universityCount': universityCount,
    'wellWisherCount': wellWisherCount,
    'literatureDistribution': literatureDistribution,
    'magazineDistribution': magazineDistribution,
    'posterStickerCount': posterStickerCount,
    'wallWritingCount': wallWritingCount,
    'groupDawahCount': groupDawahCount,
    'debateCompetitionCount': debateCompetitionCount,
    'institutionalBranchCount': institutionalBranchCount,
    'residentialBranchCount': residentialBranchCount,
    'associateCandidateTarget': associateCandidateTarget,
    'kormiTarget': kormiTarget,
    'associateBranchIncrease': associateBranchIncrease,
    'zonalBranchIncrease': zonalBranchIncrease,
    'workerBranchIncrease': workerBranchIncrease,
    'seniorVisitCount': seniorVisitCount,
    'executiveMeetingCount': executiveMeetingCount,
    'zonalMeetingCount': zonalMeetingCount,
    'memberMeetingCount': memberMeetingCount,
    'associateMeetingCount': associateMeetingCount,
    'workerMeetingCount': workerMeetingCount,
    'generalMeetingCount': generalMeetingCount,
    'discussionMeetingCount': discussionMeetingCount,
    'baytulmalCollectionTarget': baytulmalCollectionTarget,
    'workshopCount': workshopCount,
    'studyTourCount': studyTourCount,
    'groupStudyCount': groupStudyCount,
    'nightStayCount': nightStayCount,
    'zikrMahfilCount': zikrMahfilCount,
    'trainingCircleCount': trainingCircleCount,
    'skillCourseCount': skillCourseCount,
    'quranHadithClassCount': quranHadithClassCount,
    'masailaClassCount': masailaClassCount,
    'openClassCount': openClassCount,
    'libraryBookIncrease': libraryBookIncrease,
    'zakatCollectionTarget': zakatCollectionTarget,
    'tuitionHelpCount': tuitionHelpCount,
    'hostelHelpCount': hostelHelpCount,
    'coachingClassCount': coachingClassCount,
    'noteBookDistribution': noteBookDistribution,
    'libraryEstablishment': libraryEstablishment,
    'treePlantationCount': treePlantationCount,
    'bloodDonationBags': bloodDonationBags,
    'quranTeachingCount': quranTeachingCount,
    'socialWelfareNotes': socialWelfareNotes,
    'totalEstimatedIncome': totalEstimatedIncome,
    'totalEstimatedExpense': totalEstimatedExpense,
  };

  factory ChatroMonthlyPlan.fromJson(Map<String, dynamic> json) {
    return ChatroMonthlyPlan(
      year: json['year'] ?? DateTime.now().year,
      month: json['month'] ?? DateTime.now().month,
      session: json['session'] ?? '',
      branchName: json['branchName'] ?? '',
      friendTarget: json['friendTarget'] ?? '',
      primaryMemberTarget: json['primaryMemberTarget'] ?? '',
      schoolGovtCount: json['schoolGovtCount'] ?? '',
      schoolNonGovtCount: json['schoolNonGovtCount'] ?? '',
      collegeCount: json['collegeCount'] ?? '',
      madrasaAliaCount: json['madrasaAliaCount'] ?? '',
      madrasaQawmiCount: json['madrasaQawmiCount'] ?? '',
      universityCount: json['universityCount'] ?? '',
      wellWisherCount: json['wellWisherCount'] ?? '',
      literatureDistribution: json['literatureDistribution'] ?? '',
      magazineDistribution: json['magazineDistribution'] ?? '',
      posterStickerCount: json['posterStickerCount'] ?? '',
      wallWritingCount: json['wallWritingCount'] ?? '',
      groupDawahCount: json['groupDawahCount'] ?? '',
      debateCompetitionCount: json['debateCompetitionCount'] ?? '',
      institutionalBranchCount: json['institutionalBranchCount'] ?? '',
      residentialBranchCount: json['residentialBranchCount'] ?? '',
      associateCandidateTarget: json['associateCandidateTarget'] ?? '',
      kormiTarget: json['kormiTarget'] ?? '',
      associateBranchIncrease: json['associateBranchIncrease'] ?? '',
      zonalBranchIncrease: json['zonalBranchIncrease'] ?? '',
      workerBranchIncrease: json['workerBranchIncrease'] ?? '',
      seniorVisitCount: json['seniorVisitCount'] ?? '',
      executiveMeetingCount: json['executiveMeetingCount'] ?? '',
      zonalMeetingCount: json['zonalMeetingCount'] ?? '',
      memberMeetingCount: json['memberMeetingCount'] ?? '',
      associateMeetingCount: json['associateMeetingCount'] ?? '',
      workerMeetingCount: json['workerMeetingCount'] ?? '',
      generalMeetingCount: json['generalMeetingCount'] ?? '',
      discussionMeetingCount: json['discussionMeetingCount'] ?? '',
      baytulmalCollectionTarget: json['baytulmalCollectionTarget'] ?? '',
      workshopCount: json['workshopCount'] ?? '',
      studyTourCount: json['studyTourCount'] ?? '',
      groupStudyCount: json['groupStudyCount'] ?? '',
      nightStayCount: json['nightStayCount'] ?? '',
      zikrMahfilCount: json['zikrMahfilCount'] ?? '',
      trainingCircleCount: json['trainingCircleCount'] ?? '',
      skillCourseCount: json['skillCourseCount'] ?? '',
      quranHadithClassCount: json['quranHadithClassCount'] ?? '',
      masailaClassCount: json['masailaClassCount'] ?? '',
      openClassCount: json['openClassCount'] ?? '',
      libraryBookIncrease: json['libraryBookIncrease'] ?? '',
      zakatCollectionTarget: json['zakatCollectionTarget'] ?? '',
      tuitionHelpCount: json['tuitionHelpCount'] ?? '',
      hostelHelpCount: json['hostelHelpCount'] ?? '',
      coachingClassCount: json['coachingClassCount'] ?? '',
      noteBookDistribution: json['noteBookDistribution'] ?? '',
      libraryEstablishment: json['libraryEstablishment'] ?? '',
      treePlantationCount: json['treePlantationCount'] ?? '',
      bloodDonationBags: json['bloodDonationBags'] ?? '',
      quranTeachingCount: json['quranTeachingCount'] ?? '',
      socialWelfareNotes: json['socialWelfareNotes'] ?? '',
      totalEstimatedIncome: json['totalEstimatedIncome'] ?? '',
      totalEstimatedExpense: json['totalEstimatedExpense'] ?? '',
    );
  }
}
