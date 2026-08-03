class MajlisTypes {
  static const String khelafat = 'খেলাফত মজলিস';
  static const String jubo = 'ইসলামী যুব মজলিস';
  static const String chatro = 'বাংলাদেশ ইসলামী ছাত্র মজলিস';
  static const String labor = 'বাংলাদেশ ইসলামী শ্রমিক মজলিস';
  static const String women = 'বাংলাদেশ ইসলামী মহিলা মজলিস';

  /// শর্ট বা ডিসপ্লে নেম
  static const String juboShort = 'ইসলামী যুব মজলিস';
  static const String chatroShort = 'ইসলামী ছাত্র মজলিস';
  static const String laborShort = 'ইসলামী শ্রমিক মজলিস';
  static const String womenShort = 'ইসলামী মহিলা মজলিস';

  /// রা স্ট্রিং থেকে মজলিস কি পাওয়ার হেল্পার (khelafat, jubo, chatro, labor, women)
  static String getKey(String? raw) {
    if (raw == null) return 'khelafat';
    final name = raw.toLowerCase();
    if (name.contains('jubo') || name.contains('youth') || name.contains('যুব')) {
      return 'jubo';
    } else if (name.contains('chatro') || name.contains('student') || name.contains('ছাত্র')) {
      return 'chatro';
    } else if (name.contains('labor') || name.contains('shromik') || name.contains('শ্রমিক')) {
      return 'labor';
    } else if (name.contains('women') || name.contains('mohila') || name.contains('মহিলা')) {
      return 'women';
    }
    return 'khelafat';
  }

  /// অফিসিয়াল পূর্ণ নাম পাওয়ার হেল্পার
  static String getOfficialName(String? raw) {
    final key = getKey(raw);
    switch (key) {
      case 'jubo':
        return jubo;
      case 'chatro':
        return chatro;
      case 'labor':
        return labor;
      case 'women':
        return women;
      default:
        return khelafat;
    }
  }

  /// ডিসপ্লে নাম পাওয়ার হেল্পার
  static String getDisplayName(String? raw) {
    final key = getKey(raw);
    switch (key) {
      case 'jubo':
        return juboShort;
      case 'chatro':
        return chatroShort;
      case 'labor':
        return laborShort;
      case 'women':
        return womenShort;
      default:
        return khelafat;
    }
  }
}
