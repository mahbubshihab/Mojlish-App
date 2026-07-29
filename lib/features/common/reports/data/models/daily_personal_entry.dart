/// ব্যক্তিগত তৎপরতার দৈনিক রিপোর্ট এন্ট্রি মডেল
/// স্ক্যান করা ফর্মের কলামগুলো অনুযায়ী
class DailyPersonalEntry {
  final String date; // yyyy-MM-dd format

  // কুরআন অধ্যয়ন
  final String quranSura;  // সূরা (পড়া)
  final String quranAyah;  // আয়াত

  // হাদিস অধ্যয়ন
  final String hadithCount; // হাদিস সংখ্যা
  final String hadithTopic; // হাদিস বিষয়

  // সাহিত্য অধ্যয়ন
  final String islamicLitPages; // ইসলামি সাহিত্য পৃষ্ঠা
  final String islamicLitBook;  // বইয়ের নাম

  // পাঠ্যপুস্তক অধ্যয়ন
  final String textbookHours; // পাঠ্যপুস্তক/ক্লাস সময় (ঘণ্টা)

  // জামায়াতে নামাজ
  final String jamaatPrayer;  // জামাআতে নামায (ওয়াক্ত)
  final String selfAnalysis;  // আত্মবিচার (হ্যাঁ/না)

  // দাওয়াতি কাজ
  final String contactCount;   // বন্ধু/সদস্য যোগাযোগ সংখ্যা
  final String contactName;    // যোগাযোগের নাম
  final String dawahMaterials; // দাওয়াতি উপকরণ বিতরণ (পরিমাণ)

  // সাংগঠনিক কাজ
  final String meetingName;        // সভায় যোগদান (নাম)
  final String orgTime;            // সাংগঠনিক কাজে সময়দান (ঘণ্টা)
  final String memberContactCount; // কর্মী যোগাযোগ সংখ্যা
  final String memberContactName;  // কর্মী যোগাযোগের নাম

  // বিবিধ
  final String newspaperTime;        // দৈনিক পত্রিকা পাঠ সময় (মিনিট)
  final String physicalExerciseTime; // শরীরচর্চা সময় (মিনিট)
  final String familyWelfareTime;   // পারিবারিক/সামাজিক খেদমত সময় (মিনিট)

  // যুব মজলিস বিশেষ ফিল্ড
  final String jobBusinessTime; // চাকুরি/ব্যবসা বসা সময় দান (ঘণ্টা)

  // পুরনো ফিল্ডসমূহ (backward compatibility)
  final String quranStudy;
  final String hadithStudy;
  final String islamicLiterature;
  final String otherLiterature;
  final String textbookStudy;
  final String contact;
  final String dawah;
  final String timeService;
  final String volunteering;
  final String socialService;
  final String remarks;

  const DailyPersonalEntry({
    required this.date,
    this.quranSura = '',
    this.quranAyah = '',
    this.hadithCount = '',
    this.hadithTopic = '',
    this.islamicLitPages = '',
    this.islamicLitBook = '',
    this.textbookHours = '',
    this.jamaatPrayer = '',
    this.selfAnalysis = '',
    this.contactCount = '',
    this.contactName = '',
    this.dawahMaterials = '',
    this.meetingName = '',
    this.orgTime = '',
    this.memberContactCount = '',
    this.memberContactName = '',
    this.newspaperTime = '',
    this.physicalExerciseTime = '',
    this.familyWelfareTime = '',
    this.jobBusinessTime = '',
    
    // Default compatibility values
    this.quranStudy = '',
    this.hadithStudy = '',
    this.islamicLiterature = '',
    this.otherLiterature = '',
    this.textbookStudy = '',
    this.contact = '',
    this.dawah = '',
    this.timeService = '',
    this.volunteering = '',
    this.socialService = '',
    this.remarks = '',
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'quranSura': quranSura,
    'quranAyah': quranAyah,
    'hadithCount': hadithCount,
    'hadithTopic': hadithTopic,
    'islamicLitPages': islamicLitPages,
    'islamicLitBook': islamicLitBook,
    'textbookHours': textbookHours,
    'jamaatPrayer': jamaatPrayer,
    'selfAnalysis': selfAnalysis,
    'contactCount': contactCount,
    'contactName': contactName,
    'dawahMaterials': dawahMaterials,
    'meetingName': meetingName,
    'orgTime': orgTime,
    'memberContactCount': memberContactCount,
    'memberContactName': memberContactName,
    'newspaperTime': newspaperTime,
    'physicalExerciseTime': physicalExerciseTime,
    'familyWelfareTime': familyWelfareTime,
    'jobBusinessTime': jobBusinessTime,
    
    'quranStudy': quranStudy,
    'hadithStudy': hadithStudy,
    'islamicLiterature': islamicLiterature,
    'otherLiterature': otherLiterature,
    'textbookStudy': textbookStudy,
    'contact': contact,
    'dawah': dawah,
    'timeService': timeService,
    'volunteering': volunteering,
    'socialService': socialService,
    'remarks': remarks,
  };

  factory DailyPersonalEntry.fromJson(Map<String, dynamic> json) {
    return DailyPersonalEntry(
      date: json['date'] ?? '',
      quranSura: json['quranSura'] ?? '',
      quranAyah: json['quranAyah'] ?? '',
      hadithCount: json['hadithCount'] ?? '',
      hadithTopic: json['hadithTopic'] ?? '',
      islamicLitPages: json['islamicLitPages'] ?? '',
      islamicLitBook: json['islamicLitBook'] ?? '',
      textbookHours: json['textbookHours'] ?? '',
      jamaatPrayer: json['jamaatPrayer'] ?? '',
      selfAnalysis: json['selfAnalysis'] ?? '',
      contactCount: json['contactCount'] ?? '',
      contactName: json['contactName'] ?? '',
      dawahMaterials: json['dawahMaterials'] ?? '',
      meetingName: json['meetingName'] ?? '',
      orgTime: json['orgTime'] ?? '',
      memberContactCount: json['memberContactCount'] ?? '',
      memberContactName: json['memberContactName'] ?? '',
      newspaperTime: json['newspaperTime'] ?? '',
      physicalExerciseTime: json['physicalExerciseTime'] ?? '',
      familyWelfareTime: json['familyWelfareTime'] ?? '',
      jobBusinessTime: json['jobBusinessTime'] ?? '',
      
      // Compatibility mapping (fallback to old keys if new keys are empty)
      quranStudy: json['quranStudy'] ?? '',
      hadithStudy: json['hadithStudy'] ?? '',
      islamicLiterature: json['islamicLiterature'] ?? '',
      otherLiterature: json['otherLiterature'] ?? '',
      textbookStudy: json['textbookStudy'] ?? '',
      contact: json['contact'] ?? '',
      dawah: json['dawah'] ?? '',
      timeService: json['timeService'] ?? '',
      volunteering: json['volunteering'] ?? '',
      socialService: json['socialService'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }

  bool get isEmpty =>
      quranSura.isEmpty &&
      quranAyah.isEmpty &&
      hadithCount.isEmpty &&
      hadithTopic.isEmpty &&
      islamicLitPages.isEmpty &&
      islamicLitBook.isEmpty &&
      textbookHours.isEmpty &&
      jamaatPrayer.isEmpty &&
      selfAnalysis.isEmpty &&
      contactCount.isEmpty &&
      contactName.isEmpty &&
      dawahMaterials.isEmpty &&
      meetingName.isEmpty &&
      orgTime.isEmpty &&
      memberContactCount.isEmpty &&
      memberContactName.isEmpty &&
      newspaperTime.isEmpty &&
      physicalExerciseTime.isEmpty &&
      familyWelfareTime.isEmpty &&
      jobBusinessTime.isEmpty;
}
