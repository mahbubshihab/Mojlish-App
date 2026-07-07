/// ব্যক্তিগত তৎপরতার দৈনিক রিপোর্ট এন্ট্রি মডেল
/// স্ক্যান করা ফর্মের কলামগুলো অনুযায়ী
class DailyPersonalEntry {
  final String date; // yyyy-MM-dd format

  // কুরআন অধ্যয়ন
  final String quranSura;  // সূরা (পড়া)
  final String quranAyah; // আয়াত

  // পুরনো ফিল্ড (backward compatibility)
  final String quranStudy;

  // হাদিস অধ্যয়ন
  final String hadithStudy;

  // সাহিত্য অধ্যয়ন
  final String islamicLiterature; // ইসলামি সাহিত্য
  final String otherLiterature;   // অন্যান্য সাহিত্য

  // পাঠ্যপুস্তক অধ্যয়ন
  final String textbookStudy;

  // জামায়াতে নামাজ
  final String jamaatPrayer;

  // যোগাযোগ
  final String contactName;  // নাম
  final String contactCount; // সংখ্যা
  final String contact;      // backward compat

  // দাওয়াত
  final String dawah;

  // সময় দান
  final String timeService;
  final String volunteering; // backward compat

  // সমাজ সেবা
  final String socialService;

  // মন্তব্য
  final String remarks;

  const DailyPersonalEntry({
    required this.date,
    this.quranSura = '',
    this.quranAyah = '',
    this.quranStudy = '',
    this.hadithStudy = '',
    this.islamicLiterature = '',
    this.otherLiterature = '',
    this.textbookStudy = '',
    this.jamaatPrayer = '',
    this.contactName = '',
    this.contactCount = '',
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
    'quranStudy': quranStudy,
    'hadithStudy': hadithStudy,
    'islamicLiterature': islamicLiterature,
    'otherLiterature': otherLiterature,
    'textbookStudy': textbookStudy,
    'jamaatPrayer': jamaatPrayer,
    'contactName': contactName,
    'contactCount': contactCount,
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
      quranStudy: json['quranStudy'] ?? '',
      hadithStudy: json['hadithStudy'] ?? '',
      islamicLiterature: json['islamicLiterature'] ?? '',
      otherLiterature: json['otherLiterature'] ?? '',
      textbookStudy: json['textbookStudy'] ?? '',
      jamaatPrayer: json['jamaatPrayer'] ?? '',
      contactName: json['contactName'] ?? '',
      contactCount: json['contactCount'] ?? '',
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
      quranStudy.isEmpty &&
      hadithStudy.isEmpty &&
      islamicLiterature.isEmpty &&
      jamaatPrayer.isEmpty &&
      dawah.isEmpty &&
      timeService.isEmpty &&
      volunteering.isEmpty &&
      socialService.isEmpty;
}
