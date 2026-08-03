import 'package:mojlish_app/core/constants/majlis_assets.dart';

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
        return 'ইসলামী যুব মজলিস';
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
  final String logoPath;
  final List<MajlisPersonalReportColumn> columns;
  final List<String> footerNotes;

  const MajlisPersonalReportConfig({
    required this.type,
    required this.name,
    required this.subtitle,
    required this.address,
    required this.logoPath,
    required this.columns,
    required this.footerNotes,
  });

  static MajlisPersonalReportConfig getConfig(MajlisType type) {
    switch (type) {
      case MajlisType.khelafat:
        return const MajlisPersonalReportConfig(
          type: MajlisType.khelafat,
          name: 'খেলাফত মজলিস',
          subtitle: 'ব্যক্তিগত তৎপরতার রিপোর্ট',
          address: 'কেন্দ্রীয় কার্যালয় : ১৬ বিজয়নগর, (৫ম তলা), ঢাকা -১০০০ | মোবাইল : ০১৭১১ ৩৪৪৮১২',
          logoPath: MajlisAssets.khelafatLogo,
          columns: [
            MajlisPersonalReportColumn(id: 'quran', title: 'কোরআন অধ্যয়ন সূরা, আয়াত', subtitle: '', width: 115),
            MajlisPersonalReportColumn(id: 'hadith', title: 'হাদীস অধ্যয়ন সংখ্যা, বিষয়', subtitle: '', width: 110),
            MajlisPersonalReportColumn(id: 'literature', title: 'ইসলামী সাহিত্য পাঠ নাম, পৃষ্ঠা', subtitle: '', width: 120),
            MajlisPersonalReportColumn(id: 'jamaat', title: 'জামাতে নামাজ কত ওয়াক্ত', subtitle: '', width: 90),
            MajlisPersonalReportColumn(id: 'contact', title: 'যোগাযোগ সংখ্যা, নাম', subtitle: '', width: 110),
            MajlisPersonalReportColumn(id: 'dawat', title: 'দাওয়াত কত জন নাম', subtitle: '', width: 110),
            MajlisPersonalReportColumn(id: 'meeting', title: 'সভা/বৈঠকে যোগদান সংখ্যা', subtitle: '', width: 100),
            MajlisPersonalReportColumn(id: 'time', title: 'সময় দান কত ঘণ্টা', subtitle: '', width: 90),
            MajlisPersonalReportColumn(id: 'social', title: 'সমাজ সেবা কি ধরণের', subtitle: '', width: 100),
            MajlisPersonalReportColumn(id: 'atmo', title: 'আত্ম-সমালোচনা হ্যাঁ/না', subtitle: '', width: 90),
          ],
          footerNotes: [
            'এ মাসে সভায় যোগদান .................... টি, সভার নাম :',
            'শাখা দায়িত্বশীলের মন্তব্য ও পরামর্শ :',
            'দায়িত্বশীলের স্বাক্ষর :',
          ],
        );

      case MajlisType.sromik:
        return const MajlisPersonalReportConfig(
          type: MajlisType.sromik,
          name: 'বাংলাদেশ ইসলামী শ্রমিক মজলিস',
          subtitle: 'ব্যক্তিগত তৎপরতার রিপোর্ট',
          address: 'কেন্দ্রীয় কার্যালয় : ১৬ বিজয়নগর, (৫ম তলা), ঢাকা -১০০০ | মোবাইল : ০১৭১১ ৩৪৪৮১২',
          logoPath: MajlisAssets.khelafatLogo,
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
            'দায়িত্বশীলের স্বাক্ষর :',
          ],
        );

      case MajlisType.jubo:
        return const MajlisPersonalReportConfig(
          type: MajlisType.jubo,
          name: 'ইসলামী যুব মজলিস',
          subtitle: 'মাসিক ব্যক্তিগত তৎপরতার রিপোর্ট',
          address: 'কেন্দ্রীয় কার্যালয়: ১৬ বিজয়নগর, (৫ম তলা), ঢাকা-১০০০ | ফোন: ০১৮৩৮-০০৫৯১১',
          logoPath: MajlisAssets.juboLogo,
          columns: [
            MajlisPersonalReportColumn(id: 'jamaat', title: 'জামাতে নামায কত ওয়াক্ত', subtitle: '', width: 95),
            MajlisPersonalReportColumn(id: 'quran', title: 'কোরআন অধ্যয়ন সূরা, আয়াত', subtitle: '', width: 110),
            MajlisPersonalReportColumn(id: 'hadith', title: 'হাদীস অধ্যয়ন সংখ্যা, বিষয়', subtitle: '', width: 110),
            MajlisPersonalReportColumn(id: 'literature', title: 'ইসলামী সাহিত্য পাঠ, নাম পৃষ্ঠা', subtitle: '', width: 120),
            MajlisPersonalReportColumn(id: 'kormi_contact', title: 'কর্মী যোগাযোগ সংখ্যা, নাম', subtitle: '', width: 110),
            MajlisPersonalReportColumn(id: 'dawat', title: 'দাওয়াত কত জন নাম', subtitle: '', width: 110),
            MajlisPersonalReportColumn(id: 'time', title: 'সময় দান কত ঘন্টা', subtitle: '', width: 90),
            MajlisPersonalReportColumn(id: 'job_business', title: 'চাকুরি/ব্যবসা বসা সময় দান ঘণ্টা', subtitle: '', width: 110),
            MajlisPersonalReportColumn(id: 'atmo', title: 'আত্ম-সমালোচনা (✓)', subtitle: '', width: 90),
          ],
          footerNotes: [
            'সভায় যোগদান মোট ..... টি সভার নাম :',
            'উর্ধ্বতন দায়িত্বশীলের মন্তব্য ও পরামর্শ :',
            'শাখা দায়িত্বশীলের নাম ও স্বাক্ষর :',
          ],
        );

      case MajlisType.chatro:
        return const MajlisPersonalReportConfig(
          type: MajlisType.chatro,
          name: 'বাংলাদেশ ইসলামী ছাত্র মজলিস',
          subtitle: 'মাসিক ব্যক্তিগত রিপোর্ট',
          address: 'কেন্দ্রীয় কার্যালয়: ১৬ বিজয়নগর, (৫ম তলা), ঢাকা-১০০০ | ফোন: ৯৫৮৫৩২১',
          logoPath: MajlisAssets.chatroLogo,
          columns: [
            MajlisPersonalReportColumn(id: 'quran', title: 'কুরআন • সূরা • আয়াত', subtitle: '', width: 90),
            MajlisPersonalReportColumn(id: 'hadith', title: 'হাদীস • সংখ্যা • বিষয়', subtitle: '', width: 90),
            MajlisPersonalReportColumn(id: 'literature', title: 'ইসলামী সাহিত্য • পৃষ্ঠা সংখ্যা', subtitle: '', width: 95),
            MajlisPersonalReportColumn(id: 'textbook', title: 'পাঠ্যপুস্তক/ক্লাসে অংশগ্রহণ • সময়', subtitle: '', width: 95),
            MajlisPersonalReportColumn(id: 'jamaat', title: 'জামাতে নামায • ওয়াক্ত', subtitle: '', width: 85),
            MajlisPersonalReportColumn(id: 'atmo', title: 'আত্মচিন্তা (✓)', subtitle: '', width: 75),
            MajlisPersonalReportColumn(id: 'dawat_contact', title: 'বন্ধু/প্রাথমিক সদস্য/শুভাকাঙ্ক্ষী যোগাযোগ • সংখ্যা • নাম', subtitle: '', width: 105),
            MajlisPersonalReportColumn(id: 'dawat_materials', title: 'বই/পরিচিতি/দাওয়াতি উপকরণ বিতরণ • পরিমাণ', subtitle: '', width: 95),
            MajlisPersonalReportColumn(id: 'meeting', title: 'সভায় যোগদান • নাম', subtitle: '', width: 90),
            MajlisPersonalReportColumn(id: 'sanghotonik_time', title: 'সাংগঠনিক/দাওয়াতি কাজে সময় দান • সময়', subtitle: '', width: 95),
            MajlisPersonalReportColumn(id: 'kormi_contact', title: 'কর্মী যোগাযোগ • জন • নাম', subtitle: '', width: 95),
            MajlisPersonalReportColumn(id: 'newspaper', title: 'দৈনিক/অন্যান্য পত্রিকা পাঠ • সময়', subtitle: '', width: 90),
            MajlisPersonalReportColumn(id: 'exercise', title: 'শরীরচর্চা/কারিগরি শিক্ষা • সময়', subtitle: '', width: 90),
            MajlisPersonalReportColumn(id: 'family_social', title: 'পারিবারিক/সামাজিক খেদমত • সময়', subtitle: '', width: 90),
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
          subtitle: 'ব্যক্তিগত তৎপরতার রিপোর্ট',
          address: 'কেন্দ্রীয় কার্যালয় : ফায়েনাজ টাওয়ার, ফ্ল্যাট-১১/এ, ৩৭/২ পুরানা পল্টন (কালভার্ট রোড), ঢাকা-১০০০। মোবাইল : ০১৮১৫ ০৪২০৮৭',
          logoPath: MajlisAssets.mohilaLogo,
          columns: [
            MajlisPersonalReportColumn(id: 'quran', title: 'কোরআন অধ্যয়ন সূরা, আয়াত', subtitle: '', width: 110),
            MajlisPersonalReportColumn(id: 'hadith', title: 'হাদীস অধ্যয়ন সংখ্যা, বিষয়', subtitle: '', width: 110),
            MajlisPersonalReportColumn(id: 'literature', title: 'ইসলামী সাহিত্য পাঠ নাম, পৃষ্ঠা', subtitle: '', width: 120),
            MajlisPersonalReportColumn(id: 'contact', title: 'যোগাযোগ সংখ্যা, নাম', subtitle: '', width: 110),
            MajlisPersonalReportColumn(id: 'dawat', title: 'দাওয়াত কত জন নাম', subtitle: '', width: 110),
            MajlisPersonalReportColumn(id: 'meeting', title: 'সভায় যোগদান', subtitle: '', width: 100),
            MajlisPersonalReportColumn(id: 'time', title: 'সময় দান কত ঘণ্টা', subtitle: '', width: 90),
            MajlisPersonalReportColumn(id: 'social', title: 'সমাজ সেবা কি ধরণের', subtitle: '', width: 100),
            MajlisPersonalReportColumn(id: 'atmo', title: 'আত্ম-সমালোচনা হ্যাঁ/না', subtitle: '', width: 90),
          ],
          footerNotes: [
            'এ মাসে সভায় যোগদান .................... টি, সভার নাম :',
            'শাখা দায়িত্বশীলের মন্তব্য ও পরামর্শ :',
            'দায়িত্বশীলের স্বাক্ষর :',
          ],
        );
    }
  }
}
