enum MajlisType {
  khelafat, // খেলাফত মজলিস
  jubo,      // বাংলাদেশ ইসলামী যুব মজলিস
  chatro,    // বাংলাদেশ ইসলামী ছাত্র মজলিস
  mohila,    // ইসলামী মহিলা মজলিস
  sromik,    // বাংলাদেশ ইসলামী শ্রমিক মজলিস
}

extension MajlisTypeExtension on MajlisType {
  String get displayName {
    switch (this) {
      case MajlisType.khelafat:
        return 'খেলাফত মজলিস';
      case MajlisType.jubo:
        return 'বাংলাদেশ ইসলামী যুব মজলিস';
      case MajlisType.chatro:
        return 'বাংলাদেশ ইসলামী ছাত্র মজলিস';
      case MajlisType.mohila:
        return 'ইসলামী মহিলা মজলিস';
      case MajlisType.sromik:
        return 'বাংলাদেশ ইসলামী শ্রমিক মজলিস';
    }
  }

  static MajlisType fromString(String name) {
    if (name.contains('যুব')) return MajlisType.jubo;
    if (name.contains('ছাত্র')) return MajlisType.chatro;
    if (name.contains('মহিলা')) return MajlisType.mohila;
    if (name.contains('শ্রমিক')) return MajlisType.sromik;
    return MajlisType.khelafat;
  }
}

class MajlisPersonalReportColumn {
  final String id;
  final String title;
  final String subtitle;
  final double width;

  const MajlisPersonalReportColumn({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.width = 100,
  });
}

class MajlisPersonalReportConfig {
  final MajlisType type;
  final String name;
  final String subtitle;
  final String address;
  final List<MajlisPersonalReportColumn> columns;
  final List<String> footerNotes;

  const MajlisPersonalReportConfig({
    required this.type,
    required this.name,
    required this.subtitle,
    required this.address,
    required this.columns,
    required this.footerNotes,
  });

  static MajlisPersonalReportConfig getConfig(MajlisType type) {
    switch (type) {
      case MajlisType.khelafat:
        return const MajlisPersonalReportConfig(
          type: MajlisType.khelafat,
          name: 'খেলাফত মজলিস',
          subtitle: 'মাসিক ব্যক্তিগত তৎপরতার রিপোর্ট',
          address: 'কেন্দ্রীয় কার্যালয় : ১৬ বিজয়নগর, (৫ম তলা), ঢাকা -১০০০ | মোবাইল : ০১৭১১ ৩৪৪৮১২',
          columns: [
            MajlisPersonalReportColumn(id: 'quran', title: 'কোরআন অধ্যয়ন', subtitle: 'সূরা, আয়াত', width: 115),
            MajlisPersonalReportColumn(id: 'hadith', title: 'হাদীস অধ্যয়ন', subtitle: 'সংখ্যা, বিষয়', width: 110),
            MajlisPersonalReportColumn(id: 'literature', title: 'ইসলামী সাহিত্য পাঠ', subtitle: 'নাম, পৃষ্ঠা', width: 120),
            MajlisPersonalReportColumn(id: 'jamaat', title: 'জামাতে নামাজ', subtitle: 'কত ওয়াক্ত', width: 90),
            MajlisPersonalReportColumn(id: 'contact', title: 'যোগাযোগ', subtitle: 'সংখ্যা, নাম', width: 110),
            MajlisPersonalReportColumn(id: 'dawat', title: 'দাওয়াত কত জন', subtitle: 'নাম', width: 110),
            MajlisPersonalReportColumn(id: 'meeting', title: 'সভা/বৈঠকে', subtitle: 'যোগদান সংখ্যা', width: 100),
            MajlisPersonalReportColumn(id: 'time', title: 'সময় দান', subtitle: 'কত ঘণ্টা', width: 90),
            MajlisPersonalReportColumn(id: 'social', title: 'সমাজ সেবা', subtitle: 'কি ধরণের', width: 100),
            MajlisPersonalReportColumn(id: 'atmo', title: 'আত্ম-সমালোচনা', subtitle: 'হ্যাঁ/না', width: 90),
          ],
          footerNotes: [
            'এ মাসে সভায় যোগদান .....টি, সভার নাম :',
            'শাখা দায়িত্বশীলের মন্তব্য ও পরামর্শ :',
          ],
        );

      case MajlisType.sromik:
        return const MajlisPersonalReportConfig(
          type: MajlisType.sromik,
          name: 'বাংলাদেশ ইসলামী শ্রমিক মজলিস',
          subtitle: 'মাসিক ব্যক্তিগত তৎপরতার রিপোর্ট',
          address: 'কেন্দ্রীয় কার্যালয় : ১৬ বিজয়নগর, (৫ম তলা), ঢাকা -১০০০ | মোবাইল : ০১৭১১ ৩৪৪৮১২',
          columns: [
            MajlisPersonalReportColumn(id: 'quran', title: 'কোরআন অধ্যয়ন', subtitle: 'সূরা, আয়াত', width: 115),
            MajlisPersonalReportColumn(id: 'hadith', title: 'হাদীস অধ্যয়ন', subtitle: 'সংখ্যা, বিষয়', width: 110),
            MajlisPersonalReportColumn(id: 'literature', title: 'ইসলামী সাহিত্য পাঠ', subtitle: 'নাম, পৃষ্ঠা', width: 120),
            MajlisPersonalReportColumn(id: 'jamaat', title: 'জামাতে নামাজ', subtitle: 'কত ওয়াক্ত', width: 90),
            MajlisPersonalReportColumn(id: 'contact', title: 'যোগাযোগ', subtitle: 'সংখ্যা, নাম', width: 110),
            MajlisPersonalReportColumn(id: 'dawat', title: 'দাওয়াত কত জন', subtitle: 'নাম', width: 110),
            MajlisPersonalReportColumn(id: 'meeting', title: 'সভা/বৈঠকে', subtitle: 'যোগদান সংখ্যা', width: 100),
            MajlisPersonalReportColumn(id: 'time', title: 'সময় দান', subtitle: 'কত ঘণ্টা', width: 90),
            MajlisPersonalReportColumn(id: 'social', title: 'সমাজ সেবা', subtitle: 'কি ধরণের', width: 100),
            MajlisPersonalReportColumn(id: 'atmo', title: 'আত্ম-সমালোচনা', subtitle: 'হ্যাঁ/না', width: 90),
          ],
          footerNotes: [
            'এ মাসে সভায় যোগদান .....টি, সভার নাম :',
            'শাখা দায়িত্বশীলের মন্তব্য ও পরামর্শ :',
          ],
        );

      case MajlisType.jubo:
        return const MajlisPersonalReportConfig(
          type: MajlisType.jubo,
          name: 'ইসলামী যুব মজলিস',
          subtitle: 'মাসিক ব্যক্তিগত তৎপরতার রিপোর্ট',
          address: 'কেন্দ্রীয় কার্যালয়: ১৬ বিজয়নগর, (৫ম তলা), ঢাকা-১০০০ | ফোন: ০১৮৩৮-০০৫৯১১',
          columns: [
            MajlisPersonalReportColumn(id: 'jamaat', title: 'জামাতে নামাজ', subtitle: 'কত ওয়াক্ত', width: 95),
            MajlisPersonalReportColumn(id: 'quran', title: 'কোরআন অধ্যয়ন', subtitle: 'সূরা, আয়াত', width: 110),
            MajlisPersonalReportColumn(id: 'hadith', title: 'হাদীস অধ্যয়ন', subtitle: 'সংখ্যা, বিষয়', width: 110),
            MajlisPersonalReportColumn(id: 'literature', title: 'ইসলামী সাহিত্য পাঠ', subtitle: 'নাম, পৃষ্ঠা', width: 120),
            MajlisPersonalReportColumn(id: 'kormi_contact', title: 'কর্মী যোগাযোগ', subtitle: 'সংখ্যা, নাম', width: 110),
            MajlisPersonalReportColumn(id: 'dawat', title: 'দাওয়াত কত জন', subtitle: 'নাম', width: 110),
            MajlisPersonalReportColumn(id: 'time', title: 'সময় দান', subtitle: 'কত ঘণ্টা', width: 90),
            MajlisPersonalReportColumn(id: 'job_business', title: 'চাকুরি/ব্যবসা বসা', subtitle: 'সময় দান ঘণ্টা', width: 110),
            MajlisPersonalReportColumn(id: 'atmo', title: 'আত্ম-সমালোচনা', subtitle: '(✓)', width: 90),
          ],
          footerNotes: [
            'সভায় যোগদান মোট .....টি সভার নাম :',
            'উর্ধতন দায়িত্বশীলের মন্তব্য ও পরামর্শ :',
          ],
        );

      case MajlisType.chatro:
        return const MajlisPersonalReportConfig(
          type: MajlisType.chatro,
          name: 'বাংলাদেশ ইসলামী ছাত্র মজলিস',
          subtitle: 'মাসিক ব্যক্তিগত তৎপরতার রিপোর্ট',
          address: 'কেন্দ্রীয় কার্যালয়: ঢাকা',
          columns: [
            MajlisPersonalReportColumn(id: 'quran', title: 'কুরআন', subtitle: 'সূরা • আয়াত', width: 100),
            MajlisPersonalReportColumn(id: 'hadith', title: 'হাদীস', subtitle: 'সংখ্যা • বিষয়', width: 100),
            MajlisPersonalReportColumn(id: 'literature', title: 'ইসলামী সাহিত্য', subtitle: 'পৃষ্ঠা সংখ্যা', width: 110),
            MajlisPersonalReportColumn(id: 'textbook', title: 'পাঠ্যপুস্তক/ক্লাস', subtitle: 'সময়', width: 100),
            MajlisPersonalReportColumn(id: 'jamaat', title: 'জামাতে নামায', subtitle: 'ওয়াক্ত', width: 90),
            MajlisPersonalReportColumn(id: 'dawat_contact', title: 'বন্ধু/সদস্য যোগাযোগ', subtitle: 'সংখ্যা • নাম', width: 120),
            MajlisPersonalReportColumn(id: 'dawat_materials', title: 'উপকরণ বিতরণ', subtitle: 'পরিমাণ', width: 100),
            MajlisPersonalReportColumn(id: 'sanghotonik_time', title: 'সাংগঠনিক/দাওয়াতি কাজে', subtitle: 'সময় দান', width: 110),
            MajlisPersonalReportColumn(id: 'kormi_contact', title: 'কর্মী যোগাযোগ', subtitle: 'জন • নাম', width: 110),
            MajlisPersonalReportColumn(id: 'extra_activities', title: 'বিবিধ/পত্রিকা/শরীরচর্চা', subtitle: 'সময়', width: 110),
          ],
          footerNotes: [
            'পরামর্শ :',
            'স্বাক্ষর :',
          ],
        );

      case MajlisType.mohila:
        return const MajlisPersonalReportConfig(
          type: MajlisType.mohila,
          name: 'বাংলাদেশ ইসলামী মহিলা মজলিস',
          subtitle: 'মাসিক ব্যক্তিগত তৎপরতার রিপোর্ট',
          address: 'কেন্দ্রীয় কার্যালয়: ফায়েনাজ টাওয়ার, ফ্ল্যাট-১১/এ, ৩৭/২ পুরানা পল্টন, (কালভার্ট রোড), ঢাকা-১০০০ | মোবাইল: ০১৮১৫ ০৪২০OD',
          columns: [
            MajlisPersonalReportColumn(id: 'quran', title: 'কোরআন অধ্যয়ন', subtitle: 'সূরা, আয়াত', width: 110),
            MajlisPersonalReportColumn(id: 'hadith', title: 'হাদীস অধ্যয়ন', subtitle: 'সংখ্যা, বিষয়', width: 110),
            MajlisPersonalReportColumn(id: 'literature', title: 'ইসলামী সাহিত্য পাঠ', subtitle: 'নাম, পৃষ্ঠা', width: 120),
            MajlisPersonalReportColumn(id: 'contact', title: 'যোগাযোগ', subtitle: 'সংখ্যা, নাম', width: 110),
            MajlisPersonalReportColumn(id: 'dawat', title: 'দাওয়াত কত জন', subtitle: 'নাম', width: 110),
            MajlisPersonalReportColumn(id: 'meeting', title: 'সভায় যোগদান', subtitle: '', width: 100),
            MajlisPersonalReportColumn(id: 'time', title: 'সময় দান', subtitle: 'কত ঘণ্টা', width: 90),
            MajlisPersonalReportColumn(id: 'social', title: 'সমাজ সেবা', subtitle: 'কি ধরণের', width: 100),
            MajlisPersonalReportColumn(id: 'atmo', title: 'আত্ম-সমালোচনা', subtitle: 'হ্যাঁ/না', width: 90),
          ],
          footerNotes: [
            'এ মাসে সভায় যোগদান .....টি, সভার নাম :',
            'শাখা দায়িত্বশীলের মন্তব্য ও পরামর্শ :',
          ],
        );
    }
  }
}
