/// খেলাফত মজলিস সিলেবাস ডেটা স্ট্রাকচার ও কনস্ট্যান্টস
class SyllabusBook {
  final String title;
  final String author;
  final bool isRequired; // true for পাঠ্য পুস্তক, false for সহায়ক পুস্তক

  const SyllabusBook({
    required this.title,
    required this.author,
    this.isRequired = true,
  });
}

class SyllabusSubject {
  final String id;
  final String title;
  final String iconName;
  final List<String> topics;
  final List<SyllabusBook> textbooks;
  final List<SyllabusBook> referenceBooks;

  const SyllabusSubject({
    required this.id,
    required this.title,
    required this.iconName,
    required this.topics,
    required this.textbooks,
    this.referenceBooks = const [],
  });
}

class SyllabusLevel {
  final String title;
  final String subtitle;
  final String targetAudience;
  final List<SyllabusSubject> subjects;

  const SyllabusLevel({
    required this.title,
    required this.subtitle,
    required this.targetAudience,
    required this.subjects,
  });
}

class KhelafatSyllabusData {
  static const String introTitle = "ভূমিকা";
  static const String introText = 
      "দ্বীনের জ্ঞান অর্জন করা প্রত্যেক মুসলিম নারী-পুরুষের উপর ফরজ। খেলাফত মজলিস আল্লাহর জমিনে আল্লাহর খেলাফত প্রতিষ্ঠা করতে চায়। এ সংগঠনকে তার অভীষ্ট লক্ষ্যে পৌঁছাতে হলে প্রয়োজন যোগ্য, প্রশিক্ষিত কর্মী বাহিনী এবং গণসম্পৃক্ততা। প্রয়োজন তাদের মধ্যে আদর্শ চরিত্র ও ব্যাপক জ্ঞানের সমাহার। তাই খেলাফত মজলিস তার সর্বস্তরের দায়িত্বশীল ও কর্মীদের এ পথে এগিয়ে নেওয়ার জন্য একটি সিলেবাস প্রণয়ন করেছে।\n\n"
      "সিলেবাসে বিষয় ও বই দুটিই উল্লেখ করা হয়েছে। বিষয় অনুযায়ী অধিকতর সামঞ্জস্যপূর্ণ বই-পুস্তকের তালিকা প্রদান করা হয়েছে। আমাদের সিলেবাসে তিনটি স্তর রয়েছে:\n"
      "১. প্রথম স্তর — কর্মীদের জন্য\n"
      "২. দ্বিতীয় স্তর — সদস্যদের জন্য\n"
      "৩. উচ্চতর স্তর — সদস্যদের উন্নত জ্ঞানচর্চার জন্য।";

  static const String publisherInfo = 
      "প্রকাশনায়: খেলাফত মজলিস\n"
      "১৬, বিজয়নগর (৫ম তলা), ঢাকা-১০০০\n"
      "ফোন: ৯৫৮৫৪৩১\n"
      "ইমেইল: khelafatmajlis@gmail.com\n"
      "ওয়েবসাইট: www.khelafatmajlis.org";

  static final List<SyllabusLevel> levels = [
    // ==========================================
    // ১ম স্তর: কর্মী স্তর
    // ==========================================
    SyllabusLevel(
      title: "প্রথম স্তর",
      subtitle: "কর্মীদের জন্য সিলেবাস",
      targetAudience: "এ স্তরের সিলেবাস সর্বস্তরের কর্মীর জন্য প্রযোজ্য। কর্মী হওয়ার জন্য এ সিলেবাস অনুযায়ী অধ্যয়ন করা ও সিলেবাস শেষ করা প্রয়োজন।",
      subjects: [
        SyllabusSubject(
          id: "lvl1_eman",
          title: "ঈমান ও আকীদা",
          iconName: "security",
          topics: [
            "কালিমায়ে তাইয়্যেবা, কালিমায়ে শাহাদাত, কালিমায়ে তাওহীদ ও ঈমানে মুফাসসাল অর্থসহ মুখস্থ করা।",
            "ঈমানের তাৎপর্য সম্পর্কে জ্ঞান অর্জন করা।",
            "যেসব মৌলিক বিষয়ের উপর ঈমান আনতে হবে সেসব বিষয় সম্পর্কে বিস্তারিত জ্ঞান অর্জন করা।",
            "তওহীদ, শিরক, নেফাক ও বেদাত সম্পর্কে জ্ঞান অর্জন করা।",
            "ঈমানের দাবি সম্পর্কে বিস্তারিত জ্ঞান অর্জন করা।",
          ],
          textbooks: [
            SyllabusBook(title: "আল্লাহর পরিচয়", author: "মাওলানা শামসুল হক ফরিদপুরী (রহ)"),
            SyllabusBook(title: "কালিমায়ে তাইয়্যেবা", author: "মাওলানা আব্দুর রহীম (রহ)"),
            SyllabusBook(title: "ঈমানের তাৎপর্য ও দাবি", author: "মাওলানা আব্দুর রহীম (রহ)"),
            SyllabusBook(title: "ইসলামী আকীদা", author: "শায়খ আল গাজালী (রহ)"),
            SyllabusBook(title: "ঈমানের পথ রক্তে রাঙা", author: "ড. আহমদ আব্দুল কাদের"),
          ],
          referenceBooks: [
            SyllabusBook(title: "বেহেশতী জেওর (১ম খণ্ড: আকীদা পর্ব)", author: "মাওলানা আশরাফ আলী থানবী (রহ)", isRequired: false),
            SyllabusBook(title: "তাওহীদের তাকাযা", author: "মাওলানা আব্দুর রহীম (রহ)", isRequired: false),
            SyllabusBook(title: "ইসলামী জীবন ব্যবস্থা (১ম খণ্ড: আকীদা-বিশ্বাস)", author: "আল্লামা মুফতী তাকী ওসমানী", isRequired: false),
          ],
        ),
        SyllabusSubject(
          id: "lvl1_quran",
          title: "আল কুরআন",
          iconName: "menu_book",
          topics: [
            "সহীহ কুরআন তেলাওয়াত শিক্ষা করা।",
            "সূরা ফাতিহা থেকে সূরা ফিল পর্যন্ত অর্থসহ মুখস্থ করা।",
            "ধারাবাহিকভাবে অধ্যায়ন: সূরা বাকারা ও আলে ইমরান।",
            "আল কুরআনের পরিচয়, ফজিলত ও গুরুত্ব সম্পর্কে জানা।",
          ],
          textbooks: [
            SyllabusBook(title: "তা'লীমুল কুরআন", author: "মাওলানা আলী আকবর সিদ্দিকী"),
            SyllabusBook(title: "নূরানী কুরআন শিক্ষা", author: "মুফতী কেফায়েতুল্লাহ"),
            SyllabusBook(title: "আল কুরআনের পরিচয়", author: "মাওলানা ড. মুস্তাফিজুর রহমান"),
            SyllabusBook(title: "তাফসীরে মা'আরেফুল কুরআন (ভূমিকা, বাকারা ও আমপারা)", author: "মুফতী মুহাম্মদ শফী (রহ)"),
          ],
        ),
        SyllabusSubject(
          id: "lvl1_hadith",
          title: "আল হাদিস",
          iconName: "auto_stories",
          topics: [
            "হাদিসের পরিচয়, সংকলন ও সংরক্ষণের প্রাথমিক ইতিহাস।",
            "চল্লিশটি হাদিস অর্থসহ মুখস্থ করা।",
            "নিয়মিত হাদিস অধ্যয়ন।",
          ],
          textbooks: [
            SyllabusBook(title: "মেশকাত শরীফ (১ম খণ্ডের ভূমিকা)", author: "মাওলানা নূর মুহাম্মদ আজমী (রহ)"),
            SyllabusBook(title: "৪০ হাদিস", author: "মাওলানা শামসুল হক ফরিদপুরী (রহ)"),
            SyllabusBook(title: "হাদিস শরীফ ১ম খণ্ড", author: "মাওলানা আব্দুর রহীম (রহ)"),
            SyllabusBook(title: "মেশকাত ১ম খণ্ড", author: "মাওলানা নূর মুহাম্মদ আজমী (রহ)"),
          ],
          referenceBooks: [
            SyllabusBook(title: "রাহে আমল ১ম খণ্ড", author: "আল্লামা জলীল আহসান নদভী", isRequired: false),
            SyllabusBook(title: "রিয়াদুস সালেহীন ১ম খণ্ড", author: "আল্লামা নববী (রহ)", isRequired: false),
            SyllabusBook(title: "আল আদাবুল মুফরাদ", author: "ইমাম বোখারী (রহ)", isRequired: false),
          ],
        ),
        SyllabusSubject(
          id: "lvl1_ibadat",
          title: "ইবাদাত",
          iconName: "volunteer_activism",
          topics: [
            "সালাত, সিয়াম, হজ্ব, যাকাত, জিহাদ ফি সাবিলিল্লাহ ও হুকুকুল ইবাদ সম্পর্কে জ্ঞান অর্জন।",
            "সালাতে পঠিত বিষয়গুলোর বিশুদ্ধ পাঠ ও অর্থ জানা।",
            "ওজু, গোসল, তায়াম্মুম, সালাত, সিয়াম, হালাল-হারাম, কবিরা গুনাহ মাসায়েল জানা।",
            "মাসনুন দোয়া সমূহ মুখস্থ করা।",
          ],
          textbooks: [
            SyllabusBook(title: "আহকামে জিন্দেগী", author: "মাওলানা হেমায়েত উদ্দিন"),
            SyllabusBook(title: "দৈনন্দিন জীবনে ইসলাম (৪থ, ৫থ ও ৬ষ্ঠ অধ্যায়)", author: "ইসলামিক ফাউন্ডেশন বাংলাদেশ"),
          ],
          referenceBooks: [
            SyllabusBook(title: "তা'লীমুল ইসলাম", author: "মুফতী কেফায়েতুল্লাহ (রহ)", isRequired: false),
            SyllabusBook(title: "বেহেশতী জেওর (১, ২, ৩ খণ্ড)", author: "মাওলানা আশরাফ আলী থানবী (রহ)", isRequired: false),
            SyllabusBook(title: "ইসলামী জীবন ব্যবস্থা ২য় খণ্ড (ইবাদাত-বন্দেগী)", author: "আল্লামা মুফতী তাকী ওসমানী", isRequired: false),
          ],
        ),
        SyllabusSubject(
          id: "lvl1_andolon",
          title: "দ্বীন প্রতিষ্ঠার আন্দোলন",
          iconName: "flag",
          topics: [
            "দাওয়াতে দ্বীন, ইকামতে দ্বীন, জিহাদ ফি সাবিলিল্লাহ, আমর বিল মা'রুফ ও নেহি আনিল মুনকার, তাগুত ও ইসলামী আন্দোলন সম্পর্কে ধারণা অর্জন।",
            "ইসলামী আন্দোলন ও ইসলামী বিপ্লবের কর্মপন্থা সম্পর্কে প্রাথমিক ধারণা অর্জন।",
            "ইসলামী রাষ্ট্র প্রতিষ্ঠার আন্দোলনের অপরিহার্যতা ও জনগণের সম্পৃক্ততার গুরুত্ব জানা।",
          ],
          textbooks: [
            SyllabusBook(title: "দাওয়াতে দ্বীন: প্রেক্ষাপট বাংলাদেশ", author: "অধ্যাপক মুহাম্মদ মুজাহেদুল ইসলাম"),
            SyllabusBook(title: "জিহাদের ফজিলত", author: "মাওলানা শামসুল হক ফরিদপুরী (রহ)"),
            SyllabusBook(title: "জিহাদ কী ও কেন", author: "ড. আহমদ আব্দুল কাদের"),
            SyllabusBook(title: "ইসলামী রাষ্ট্র প্রতিষ্ঠার আন্দোলন অপরিহার্য কেন", author: "ড. আহমদ আব্দুল কাদের"),
            SyllabusBook(title: "দাওয়া ও তারাফ", author: "কাজী মুহাম্মদ তাহের"),
            SyllabusBook(title: "ইসলামী আন্দোলন ও মজলুমের লড়াই", author: "ড. আহমদ আব্দুল কাদের"),
            SyllabusBook(title: "ইসলামী আন্দোলন ও উলামা সমাজ", author: "ড. আহমদ আব্দুল কাদের"),
          ],
        ),
        SyllabusSubject(
          id: "lvl1_songothon",
          title: "ইসলামী সংগঠন",
          iconName: "groups",
          topics: [
            "ইসলামে সংগঠিত হওয়ার প্রয়োজনীয়তা।",
            "ইসলামী সংগঠন ও তার বৈশিষ্ট্য।",
            "ইসলামী সংগঠন পরিচালনা ও কর্মীদের গুণাবলী।",
            "খেলাফত মজলিসের গঠন, পরিচিতি, কর্মসূচি ও কার্যপদ্ধতি সম্পর্কে অবগত হওয়া।",
          ],
          textbooks: [
            SyllabusBook(title: "খেলাফত মজলিসের ঘোষণাপত্র", author: "কেন্দ্রীয় কার্যালয়"),
            SyllabusBook(title: "খেলাফত মজলিসের সংক্ষিপ্ত পরিচিতি", author: "কেন্দ্রীয় কার্যালয়"),
            SyllabusBook(title: "খেলাফত মজলিসের গঠনতন্ত্র", author: "কেন্দ্রীয় কার্যালয়"),
            SyllabusBook(title: "খেলাফত মজলিসের কাজ কীভাবে করতে হবে", author: "কেন্দ্রীয় কার্যালয়"),
            SyllabusBook(title: "আদর্শ সংগঠন", author: "ড. আহমদ আব্দুল কাদের"),
            SyllabusBook(title: "আদর্শ কর্মী", author: "ড. আহমদ আব্দুল কাদের"),
            SyllabusBook(title: "ইসলামী সংগঠন ও পরিচালনা", author: "অধ্যাপক সিরাজুল ইসলাম"),
          ],
        ),
      ],
    ),

    // ==========================================
    // ২য় স্তর: সদস্য স্তর
    // ==========================================
    SyllabusLevel(
      title: "দ্বিতীয় স্তর",
      subtitle: "সদস্যদের জন্য সিলেবাস",
      targetAudience: "দ্বিতীয় স্তরের সিলেবাস সদস্য হওয়ার জন্য এবং দায়িত্বশীল হিসেবে যোগ্যতা অর্জনের জন্য প্রযোজ্য।",
      subjects: [
        SyllabusSubject(
          id: "lvl2_eman",
          title: "ঈমান ও আকায়িদ",
          iconName: "verified_user",
          topics: [
            "ইসলামের মৌলিক বিষয় (ঈমান ও আকায়িদ) সম্পর্কে সম্যক ধারণা অর্জন।",
            "ঈমান, কুফর, নিফাক, শিরক ও বিদআত সম্পর্কে বিস্তারিত অবগত হওয়া।",
            "খতমে নবুওয়াত সম্পর্কে গভীর জ্ঞান অর্জন।",
            "জীবন ও জগৎ সম্পর্কে ইসলামের দৃষ্টিভঙ্গি লাভ।",
          ],
          textbooks: [
            SyllabusBook(title: "ইসলামী আকীদা", author: "শায়খ আল গাজালী (রহ)"),
            SyllabusBook(title: "বেহেশতী জেওর (১ম খণ্ড)", author: "মাওলানা আশরাফ আলী থানবী (রহ)"),
            SyllabusBook(title: "ঈমান: তত্ত্ব ও দর্পণ", author: "ইসলামিক ফাউন্ডেশন বাংলাদেশ"),
            SyllabusBook(title: "ইসলামী জীবন ব্যবস্থা (১ম খণ্ড: আকীদা-বিশ্বাস)", author: "আল্লামা মুফতী তাকী ওসমানী"),
            SyllabusBook(title: "ঈমান ও তার ফল", author: "মাওলানা এরশাদ আহমাদ"),
          ],
        ),
        SyllabusSubject(
          id: "lvl2_quran",
          title: "আল কুরআন (সূরাসমেুহ ও তাফসীর)",
          iconName: "menu_book",
          topics: [
            "তাজবীদ সংক্রান্ত জ্ঞান লাভ করা ও বিশুদ্ধ তেলাওয়াত শিক্ষা।",
            "কুরআন সংকলনের ইতিহাস ও উসূলে তাফসীর সম্পর্কে জানা।",
            "কমপক্ষে ২০টি পূর্ণ সূরা এবং সূরা ফাতিহা, বাকারা, আলে ইমরান, নিসা, মায়েদা, আনআম, তাওবা, ইউসুফ, বনী ইসরাঈল, নূর, লুকমান, সেজদাহ, ইয়াসীন, হুজুরাত, আর রহমান, ওয়াকিআহ, হাশর, মুমিনুন, হাদীদ, মুলক ইত্যাদি বিস্তারিত অধ্যায়ন।",
          ],
          textbooks: [
            SyllabusBook(title: "নুজহাতুল কুরআন", author: "মাওলানা ক্বারী মোহাম্মদ ইবরাহীম (রহ)"),
            SyllabusBook(title: "কুরআন সংকলনের ইতিহাস", author: "মুফতী মুহাম্মদ ওবায়দুল্লাহ"),
            SyllabusBook(title: "কুরআন ব্যাখ্যার মূলনীতি", author: "শাহ ওয়ালীউল্লাহ (রহ)"),
            SyllabusBook(title: "কুরআন অধ্যয়নের মূলনীতি", author: "সৈয়দ আবুল হাসান আলী নদভী (রহ)"),
            SyllabusBook(title: "তাফসীরে মা'আরিফুল কুরআন", author: "মুফতী মুহাম্মদ শফী (রহ)"),
          ],
          referenceBooks: [
            SyllabusBook(title: "তাফসীরে ইবনে কাছীর", author: "আল্লামা ইবনে কাছীর (রহ)", isRequired: false),
            SyllabusBook(title: "তাফসীর ফি জিলালিল কুরআন", author: "সাইয়েদ কুতুব শহীদ (রহ)", isRequired: false),
            SyllabusBook(title: "তাফসীরে মাজহারী", author: "কাজী ছানাউল্লাহ পানিপথী (রহ)", isRequired: false),
            SyllabusBook(title: "তাফসীরে ওসমানী", author: "আল্লামা শাব্বীর আহমদ ওসমানী (রহ)", isRequired: false),
          ],
        ),
        SyllabusSubject(
          id: "lvl2_hadith",
          title: "আল হাদিস ও উলুমুল হাদিস",
          iconName: "auto_stories",
          topics: [
            "হাদিস সংরক্ষণ ও সংকলনের ইতিহাস।",
            "উলুমুল হাদিসের মৌলিক পরিচয়।",
            "অর্থসহ ৪০টি গুরুত্বপূর্ণ হাদিস মুখস্থকরণ ও নিয়মিত অধ্যায়ন।",
          ],
          textbooks: [
            SyllabusBook(title: "হাদিসের তত্ত্ব ও ইতিহাস", author: "মাওলানা নূর মুহাম্মদ আজমী (রহ)"),
            SyllabusBook(title: "মেশকাত শরীফ", author: "মাওলানা নূর মুহাম্মদ আজমী (রহ)"),
            SyllabusBook(title: "বোখারী শরীফ", author: "ইমাম বোখারী (রহ)"),
            SyllabusBook(title: "রিয়াদুস সালেহীন", author: "ইমাম নববী (রহ)"),
            SyllabusBook(title: "মুয়াত্তা ইমাম মালিক", author: "ইমাম মালিক (রহ)"),
          ],
        ),
        SyllabusSubject(
          id: "lvl2_fiqh",
          title: "ফিকাহ শাস্ত্র ও উসূলে ফিকাহ",
          iconName: "gavel",
          topics: [
            "দ্বীন ও শরীয়ত বা ফিকাহ শাস্ত্রের সংজ্ঞা ও উৎস (কুরআন, সুন্নাহ, ইজমা, কিয়াস)।",
            "উসূলে ফিকাহ ও মাযহাবের ইতিহাস।",
            "ফারাজ, ওয়াজিব, সুন্নাত, মুস্তাহাব, হালাল-হারাম ও দৈনন্দিন মাসায়েল।",
          ],
          textbooks: [
            SyllabusBook(title: "ফিকাহ শাস্ত্রের ক্রমবিকাশ", author: "আবু সাঈদ আব্দুল্লাহ"),
            SyllabusBook(title: "দ্বীন ও শরীয়ত", author: "মাওলানা মনযূর নোমানী"),
            SyllabusBook(title: "ইসলামী শরিয়তের উৎস", author: "মাওলানা আব্দুর রহীম (রহ)"),
            SyllabusBook(title: "হালাল, হারাম, বিদআত ও ইতিহাদ", author: "মাওলানা শামসুল হক ফরিদপুরী (রহ)"),
            SyllabusBook(title: "ইসলামে হালাল ও হারামের বিধান", author: "শায়খ ইউসুফ আল কারযাভী"),
            SyllabusBook(title: "আসান ফিকাহ", author: "আধুনিক প্রকাশনী"),
            SyllabusBook(title: "ফাতাওয়া ও মাসায়েল", author: "ইসলামিক ফাউন্ডেশন বাংলাদেশ"),
          ],
        ),
        SyllabusSubject(
          id: "lvl2_tasawwuf",
          title: "আত্মশুদ্ধি ও তাসাউফ",
          iconName: "self_improvement",
          topics: [
            "আত্মশুদ্ধি, তাসাউফ, এহসান ও এরফানের ইসলামী ধারণা।",
            "আত্মশুদ্ধির পথ, পদ্ধতি ও ফিকর-মুরাকাবা-মুহাসাবা।",
            "দোয়া-দুরুদ, তাসবীহ-তাহলীল, তেলাওয়াত ও ইসলামী আখলাক।",
          ],
          textbooks: [
            SyllabusBook(title: "মিনহাজুল আবেদীন", author: "ইমাম গাজালী (রহ)"),
            SyllabusBook(title: "তাসাউফ তত্ত্ব", author: "মাওলানা শামসুল হক ফরিদপুরী (রহ)"),
            SyllabusBook(title: "উন্নত জীবনের আদর্শ", author: "মাওলানা আব্দুর রহীম (রহ)"),
            SyllabusBook(title: "সাহাবা চরিত", author: "মাওলানা যাকারিয়া (রহ)"),
            SyllabusBook(title: "তাযকিয়া ও ইহসান", author: "সৈয়দ আবুল হাসান আলী নদভী"),
            SyllabusBook(title: "শরিয়তের দৃষ্টিতে পীর-মুরীদী", author: "হযরত হোসাইন আহমদ মাদানী (রহ)"),
          ],
        ),
        SyllabusSubject(
          id: "lvl2_economy",
          title: "ইসলামী অর্থনীতি ও সমাজ ব্যবস্থা",
          iconName: "account_balance",
          topics: [
            "ইসলামী সমাজের বৈশিষ্ট্য, পরিবার, দাম্পত্য, রাষ্ট্রীয় দায়িত্ব ও নারীর অধিকার।",
            "ইসলামী অর্থনীতি, উৎপাদনের উপাদান, যাকাত ব্যবস্থা, ইসলামী ব্যাংকিং ও পুঁজিবাদ-সমাজবাদের সাথে বৈষম্য।",
          ],
          textbooks: [
            SyllabusBook(title: "ইসলামের দৃষ্টিতে সমাজ", author: "ইসলামিক ফাউন্ডেশন বাংলাদেশ"),
            SyllabusBook(title: "ইসলামী রাষ্ট্র", author: "আবদুন লতিফ জায়াদান"),
            SyllabusBook(title: "ইসলামের অর্থনীতি", author: "মাওলানা আব্দুর রহীম (রহ)"),
            SyllabusBook(title: "ইসলামী অর্থনীতি ও ব্যাংকিং", author: "বিচারপতি মাওলানা তাকী ওসমানী"),
            SyllabusBook(title: "দারিদ্র্য সমস্যা সমাধানে ইসলাম", author: "ড. আহমদ আব্দুল কাদের"),
            SyllabusBook(title: "জাকাত আয় ও বণ্টন", author: "ড. আহমদ আব্দুল কাদের"),
          ],
        ),
      ],
    ),

    // ==========================================
    // ৩য় স্তর: উচ্চতর স্তর
    // ==========================================
    SyllabusLevel(
      title: "উচ্চতর স্তর",
      subtitle: "সদস্যদের উন্নত জ্ঞানচর্চা",
      targetAudience: "দায়িত্বশীল ও প্রবীণ সদস্য ভাইদের জন্য ব্যাপক জ্ঞান অর্জন ও গবেষণার উচ্চতর সিলেবাস।",
      subjects: [
        SyllabusSubject(
          id: "lvl3_advanced_quran",
          title: "উচ্চতর আল কুরআন ও হাদিস",
          iconName: "psychology",
          topics: [
            "আরবী ভাষার জ্ঞান ও দক্ষতা অর্জন।",
            "আল কুরআন ৩০ পারা ধারাবাহিকভাবে গভীর অধ্যয়ন।",
            "ক কুরআনে বিজ্ঞান, কাবেলী ওহী ও আন্তর্জাতিক তাফসীরগ্রন্থ অধ্যয়ন।",
            "সিহাহ সিত্তাহ অধ্যয়ন ও হাদিসের সানাদ-রিজাল পর্যালোচনা।",
          ],
          textbooks: [
            SyllabusBook(title: "আল ইতকান ফি উলূমিল কুরআন", author: "আল্লামা সুয়ূতী (রহ)"),
            SyllabusBook(title: "আল কুরআনে বিজ্ঞান", author: "ইসলামিক ফাউন্ডেশন বাংলাদেশ"),
            SyllabusBook(title: "কুরআন বাইবেল বিজ্ঞান", author: "ড. মরিস বুকাইলি"),
            SyllabusBook(title: "তাফসীরুল কুরআন উৎপত্তি ও ক্রমবিকাশ", author: "ড. মুহাম্মদ আব্দুর রহমান আনছারী"),
            SyllabusBook(title: "সিহাহ সিত্তাহ হাদিসগ্রন্থসমূহ", author: "ইমাম বোখারী, মুসলিম, তিরমিযী, আবু দাউদ, নাসাঈ, ইবনে মাজাহ"),
          ],
        ),
        SyllabusSubject(
          id: "lvl3_history",
          title: "ইতিহাস, আন্দোলন ও ৪০+ মনিষীর জীবনী",
          iconName: "history_edu",
          topics: [
            "মুজাহিদ আন্দোলন, খেলাফত আন্দোলন, ফরায়েজী আন্দোলন, তিতুমীরের আন্দোলন ও ফকীর বিদ্রোহের রাজনৈতিক ইতিহাস।",
            "খোলাফায়ে রাশেদীন থেকে শাহ ওয়ালীউল্লাহ, তিতুমীর, কাসিম নানুতবী, মাহমুদ হাসান, শামসুল হক ফরিদপুরী ও হাফেজ্জী হুজুর (রহ) সহ ৪০+ মনিষীর জীবনী।",
          ],
          textbooks: [
            SyllabusBook(title: "মুজাহিদ আন্দোলন", author: "ইসলামিক ফাউন্ডেশন বাংলাদেশ"),
            SyllabusBook(title: "আজাদী আন্দোলন ১৮৫৭", author: "মাওলানা ফজলুল হক খয়রাবাদী"),
            SyllabusBook(title: "ফরায়েজী আন্দোলন", author: "ড. মঈনুদ্দীন"),
            SyllabusBook(title: "ঈমান যখন জাগলো", author: "সৈয়দ আবুল হাসান আলী নদভী"),
            SyllabusBook(title: "আকাবিরদের অবদান ও জীবনী সংকলন", author: "বিভিন্ন রচয়িতা"),
          ],
        ),
        SyllabusSubject(
          id: "lvl3_bangladesh_global",
          title: "বাংলাদেশ ও আন্তর্জাতিক মুসলিম বিশ্ব",
          iconName: "public",
          topics: [
            "বাংলাদেশের ইতিহাস, ভাষা আন্দোলন, মুক্তিযুদ্ধ, শিক্ষা, রাজনীতি ও ইসলামিক আন্দোলন।",
            "উপমহাদেশ, মধ্যপ্রাচ্য, আফ্রিকা, ফিলিস্তিন, তুর্কি, কাশ্মীর ও বসনিয়াসহ গোটা বিশ্বের মুসলিম পুনর্জাগরণের উপর পূর্ণ ধারণা।",
          ],
          textbooks: [
            SyllabusBook(title: "বাংলার মুসলমানদের ইতিহাস", author: "অধ্যাপক আব্বাস আলী"),
            SyllabusBook(title: "জাতি-ভাষা-সংস্কৃতি-স্বাধীনতা", author: "ড. আহমদ আব্দুল কাদের"),
            SyllabusBook(title: "মুসলিম বিশ্বের ভূগোল ও ইতিহাস", author: "ইসলামিক ফাউন্ডেশন"),
            SyllabusBook(title: "ফিলিস্তিনের মুক্তিসংগ্রাম ও ইন্তিফাদা", author: "বিভিন্ন লেখক"),
          ],
        ),
      ],
    ),
  ];
}
