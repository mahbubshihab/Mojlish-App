/// বায়তুলমাল আয়-ব্যয়ের মাসিক রিপোর্ট মডেল
class BaytulmalReportEntry {
  final String month; // yyyy-MM format
  final String year;
  final String branchName;

  // আয়
  final String executiveMemberAyanat; // নির্বাহী সদস্যের এয়ানত (জন)
  final String executiveMemberAyanatTaka; // টাকা
  final String subBranchAyanat; // অধতন শাখা এয়ানত (শাখা সংখ্যা)
  final String subBranchAyanatTaka; // টাকা
  final String suhridAyanat; // সুহৃদ/ভক্তাক্ষী এয়ানত (জন)
  final String suhridAyanatTaka; // টাকা
  final String safarIncome; // সফর আয়
  final String safarIncomeTaka;
  final String prokashnaIncome; // প্রকাশনা আয়
  final String prokashnaIncomeTaka;
  final String onetimeIncome; // এককালীন আয়
  final String onetimeIncomeTaka;
  final String previousBalance; // বিগত মাস/মৌসুমের উদ্বৃত্ত
  final String kothayAay; // কথায় (আয়)

  // ব্যয়
  final String upwardAyanat; // উর্ধতন এয়ানত পরিশোধ
  final String upwardAyanatTaka;
  final String officeRent; // অফিস ভাড়া ও বিল
  final String officeRentTaka;
  final String officeCost; // অফিস খরচ
  final String officeCostTaka;
  final String safarExpense; // সফর
  final String safarExpenseTaka;
  final String transport; // যাতায়াত
  final String transportTaka;
  final String communication; // যোগাযোগ
  final String communicationTaka;
  final String prochar; // প্রচার
  final String procharTaka;
  final String prokashnaExpense; // প্রকাশনা
  final String prokashnaExpenseTaka;
  final String dibosPalan; // দিবস পালন (দিবসের নাম)
  final String dibosPatanTaka; // দিবস পালন ব্যয় টাকা
  final String appayan; // আপ্যায়ন
  final String appayanTaka;
  final String sova; // সভা/সমাবেশ
  final String sovaTaka;
  final String kothayBbay; // কথায় (ব্যয়)
  final String remarks; // মন্তব্য

  // স্বাক্ষর ও সত্যায়ন
  final String reportDate;
  final String baytulmalSecretary;
  final String president;

  String get dibosPalanTaka => dibosPatanTaka;

  const BaytulmalReportEntry({
    required this.month,
    required this.year,
    this.branchName = '',
    this.executiveMemberAyanat = '',
    this.executiveMemberAyanatTaka = '',
    this.subBranchAyanat = '',
    this.subBranchAyanatTaka = '',
    this.suhridAyanat = '',
    this.suhridAyanatTaka = '',
    this.safarIncome = '',
    this.safarIncomeTaka = '',
    this.prokashnaIncome = '',
    this.prokashnaIncomeTaka = '',
    this.onetimeIncome = '',
    this.onetimeIncomeTaka = '',
    this.previousBalance = '',
    this.kothayAay = '',
    this.upwardAyanat = '',
    this.upwardAyanatTaka = '',
    this.officeRent = '',
    this.officeRentTaka = '',
    this.officeCost = '',
    this.officeCostTaka = '',
    this.safarExpense = '',
    this.safarExpenseTaka = '',
    this.transport = '',
    this.transportTaka = '',
    this.communication = '',
    this.communicationTaka = '',
    this.prochar = '',
    this.procharTaka = '',
    this.prokashnaExpense = '',
    this.prokashnaExpenseTaka = '',
    this.dibosPalan = '',
    this.dibosPatanTaka = '',
    this.appayan = '',
    this.appayanTaka = '',
    this.sova = '',
    this.sovaTaka = '',
    this.kothayBbay = '',
    this.remarks = '',
    this.reportDate = '',
    this.baytulmalSecretary = '',
    this.president = '',
  });

  double get totalIncome {
    return _parse(executiveMemberAyanatTaka) +
        _parse(subBranchAyanatTaka) +
        _parse(suhridAyanatTaka) +
        _parse(safarIncomeTaka) +
        _parse(prokashnaIncomeTaka) +
        _parse(onetimeIncomeTaka) +
        _parse(previousBalance);
  }

  double get totalExpense {
    return _parse(upwardAyanatTaka) +
        _parse(officeRentTaka) +
        _parse(officeCostTaka) +
        _parse(safarExpenseTaka) +
        _parse(transportTaka) +
        _parse(communicationTaka) +
        _parse(procharTaka) +
        _parse(prokashnaExpenseTaka) +
        _parse(dibosPatanTaka) +
        _parse(appayanTaka) +
        _parse(sovaTaka);
  }

  double get balance => totalIncome - totalExpense;

  double _parse(String s) => double.tryParse(s.replaceAll(',', '')) ?? 0.0;

  Map<String, dynamic> toJson() => {
    'month': month,
    'year': year,
    'branchName': branchName,
    'branch': branchName,
    'executiveMemberAyanat': executiveMemberAyanat,
    'nirbahiSodossoSonkkha': executiveMemberAyanat,
    'executiveMemberAyanatTaka': executiveMemberAyanatTaka,
    'nirbahiSodossoIyanat': executiveMemberAyanatTaka,
    'subBranchAyanat': subBranchAyanat,
    'shakhaSonkkha': subBranchAyanat,
    'subBranchAyanatTaka': subBranchAyanatTaka,
    'odhostonShakhaIyanat': subBranchAyanatTaka,
    'suhridAyanat': suhridAyanat,
    'shudhiSonkkha': suhridAyanat,
    'suhridAyanatTaka': suhridAyanatTaka,
    'shudhiIyanat': suhridAyanatTaka,
    'safarIncome': safarIncome,
    'safarIncomeTaka': safarIncomeTaka,
    'soforAay': safarIncomeTaka,
    'prokashnaIncome': prokashnaIncome,
    'prokashnaIncomeTaka': prokashnaIncomeTaka,
    'prokashonaAay': prokashnaIncomeTaka,
    'onetimeIncome': onetimeIncome,
    'onetimeIncomeTaka': onetimeIncomeTaka,
    'ekkalinAay': onetimeIncomeTaka,
    'previousBalance': previousBalance,
    'bigotoMashUdbritto': previousBalance,
    'kothayAay': kothayAay,
    'upwardAyanat': upwardAyanat,
    'mashikDharjokrito': upwardAyanat,
    'upwardAyanatTaka': upwardAyanatTaka,
    'urdhotonIyanatPorishodh': upwardAyanatTaka,
    'officeRent': officeRent,
    'officeRentTaka': officeRentTaka,
    'officeVaraOBill': officeRentTaka,
    'officeCost': officeCost,
    'officeCostTaka': officeCostTaka,
    'officeKhoroch': officeCostTaka,
    'safarExpense': safarExpense,
    'safarExpenseTaka': safarExpenseTaka,
    'soforBbay': safarExpenseTaka,
    'transport': transport,
    'transportTaka': transportTaka,
    'jatayat': transportTaka,
    'communication': communication,
    'communicationTaka': communicationTaka,
    'jogajog': communicationTaka,
    'prochar': prochar,
    'procharTaka': procharTaka,
    'prokashnaExpense': prokashnaExpense,
    'prokashnaExpenseTaka': prokashnaExpenseTaka,
    'prokashonaBbay': prokashnaExpenseTaka,
    'dibosPalan': dibosPalan,
    'diboshNam': dibosPalan,
    'dibosPatanTaka': dibosPatanTaka,
    'dibosPalanTaka': dibosPatanTaka,
    'diboshPalon': dibosPatanTaka,
    'appayan': appayan,
    'appayanTaka': appayanTaka,
    'appayon': appayanTaka,
    'sova': sova,
    'sovaTaka': sovaTaka,
    'shobhaShomabesh': sovaTaka,
    'kothayBbay': kothayBbay,
    'remarks': remarks,
    'reportDate': reportDate,
    'baytulmalSecretary': baytulmalSecretary,
    'baytulmalSompodokShakkhor': baytulmalSecretary,
    'president': president,
    'sobhapotiShakkhor': president,
  };

  factory BaytulmalReportEntry.fromMap(Map<String, dynamic>? map, [int? year, int? month]) {
    if (map == null) {
      return BaytulmalReportEntry(
        year: year?.toString() ?? '',
        month: month?.toString() ?? '',
      );
    }
    return BaytulmalReportEntry.fromJson(map);
  }

  factory BaytulmalReportEntry.fromJson(Map<String, dynamic> json) {
    String str(dynamic val) => val?.toString() ?? '';
    String pick(String k1, [String? k2, String? k3]) {
      if (json[k1] != null && json[k1].toString().isNotEmpty) return json[k1].toString();
      if (k2 != null && json[k2] != null && json[k2].toString().isNotEmpty) return json[k2].toString();
      if (k3 != null && json[k3] != null && json[k3].toString().isNotEmpty) return json[k3].toString();
      return '';
    }

    return BaytulmalReportEntry(
      month: str(json['month']),
      year: str(json['year']),
      branchName: pick('branchName', 'branch'),
      executiveMemberAyanat: pick('executiveMemberAyanat', 'nirbahiSodossoSonkkha'),
      executiveMemberAyanatTaka: pick('executiveMemberAyanatTaka', 'nirbahiSodossoIyanat'),
      subBranchAyanat: pick('subBranchAyanat', 'shakhaSonkkha'),
      subBranchAyanatTaka: pick('subBranchAyanatTaka', 'odhostonShakhaIyanat'),
      suhridAyanat: pick('suhridAyanat', 'shudhiSonkkha'),
      suhridAyanatTaka: pick('suhridAyanatTaka', 'shudhiIyanat'),
      safarIncome: str(json['safarIncome']),
      safarIncomeTaka: pick('safarIncomeTaka', 'soforAay'),
      prokashnaIncome: str(json['prokashnaIncome']),
      prokashnaIncomeTaka: pick('prokashnaIncomeTaka', 'prokashonaAay'),
      onetimeIncome: str(json['onetimeIncome']),
      onetimeIncomeTaka: pick('onetimeIncomeTaka', 'ekkalinAay'),
      previousBalance: pick('previousBalance', 'bigotoMashUdbritto'),
      kothayAay: str(json['kothayAay']),
      upwardAyanat: pick('upwardAyanat', 'mashikDharjokrito'),
      upwardAyanatTaka: pick('upwardAyanatTaka', 'urdhotonIyanatPorishodh'),
      officeRent: str(json['officeRent']),
      officeRentTaka: pick('officeRentTaka', 'officeVaraOBill'),
      officeCost: str(json['officeCost']),
      officeCostTaka: pick('officeCostTaka', 'officeKhoroch'),
      safarExpense: str(json['safarExpense']),
      safarExpenseTaka: pick('safarExpenseTaka', 'soforBbay'),
      transport: str(json['transport']),
      transportTaka: pick('transportTaka', 'jatayat'),
      communication: str(json['communication']),
      communicationTaka: pick('communicationTaka', 'jogajog'),
      prochar: str(json['prochar']),
      procharTaka: pick('procharTaka'),
      prokashnaExpense: str(json['prokashnaExpense']),
      prokashnaExpenseTaka: pick('prokashnaExpenseTaka', 'prokashonaBbay'),
      dibosPalan: pick('dibosPalan', 'diboshNam'),
      dibosPatanTaka: pick('dibosPatanTaka', 'dibosPalanTaka', 'diboshPalon'),
      appayan: str(json['appayan']),
      appayanTaka: pick('appayanTaka', 'appayon'),
      sova: str(json['sova']),
      sovaTaka: pick('sovaTaka', 'shobhaShomabesh'),
      kothayBbay: str(json['kothayBbay']),
      remarks: str(json['remarks']),
      reportDate: str(json['reportDate']),
      baytulmalSecretary: pick('baytulmalSecretary', 'baytulmalSompodokShakkhor'),
      president: pick('president', 'sobhapotiShakkhor'),
    );
  }

  BaytulmalReportEntry copyWith({
    String? month,
    String? year,
    String? branchName,
    String? executiveMemberAyanat,
    String? executiveMemberAyanatTaka,
    String? subBranchAyanat,
    String? subBranchAyanatTaka,
    String? suhridAyanat,
    String? suhridAyanatTaka,
    String? safarIncome,
    String? safarIncomeTaka,
    String? prokashnaIncome,
    String? prokashnaIncomeTaka,
    String? onetimeIncome,
    String? onetimeIncomeTaka,
    String? previousBalance,
    String? kothayAay,
    String? upwardAyanat,
    String? upwardAyanatTaka,
    String? officeRent,
    String? officeRentTaka,
    String? officeCost,
    String? officeCostTaka,
    String? safarExpense,
    String? safarExpenseTaka,
    String? transport,
    String? transportTaka,
    String? communication,
    String? communicationTaka,
    String? prochar,
    String? procharTaka,
    String? prokashnaExpense,
    String? prokashnaExpenseTaka,
    String? dibosPalan,
    String? dibosPatanTaka,
    String? appayan,
    String? appayanTaka,
    String? sova,
    String? sovaTaka,
    String? kothayBbay,
    String? remarks,
    String? reportDate,
    String? baytulmalSecretary,
    String? president,
  }) {
    return BaytulmalReportEntry(
      month: month ?? this.month,
      year: year ?? this.year,
      branchName: branchName ?? this.branchName,
      executiveMemberAyanat: executiveMemberAyanat ?? this.executiveMemberAyanat,
      executiveMemberAyanatTaka: executiveMemberAyanatTaka ?? this.executiveMemberAyanatTaka,
      subBranchAyanat: subBranchAyanat ?? this.subBranchAyanat,
      subBranchAyanatTaka: subBranchAyanatTaka ?? this.subBranchAyanatTaka,
      suhridAyanat: suhridAyanat ?? this.suhridAyanat,
      suhridAyanatTaka: suhridAyanatTaka ?? this.suhridAyanatTaka,
      safarIncome: safarIncome ?? this.safarIncome,
      safarIncomeTaka: safarIncomeTaka ?? this.safarIncomeTaka,
      prokashnaIncome: prokashnaIncome ?? this.prokashnaIncome,
      prokashnaIncomeTaka: prokashnaIncomeTaka ?? this.prokashnaIncomeTaka,
      onetimeIncome: onetimeIncome ?? this.onetimeIncome,
      onetimeIncomeTaka: onetimeIncomeTaka ?? this.onetimeIncomeTaka,
      previousBalance: previousBalance ?? this.previousBalance,
      kothayAay: kothayAay ?? this.kothayAay,
      upwardAyanat: upwardAyanat ?? this.upwardAyanat,
      upwardAyanatTaka: upwardAyanatTaka ?? this.upwardAyanatTaka,
      officeRent: officeRent ?? this.officeRent,
      officeRentTaka: officeRentTaka ?? this.officeRentTaka,
      officeCost: officeCost ?? this.officeCost,
      officeCostTaka: officeCostTaka ?? this.officeCostTaka,
      safarExpense: safarExpense ?? this.safarExpense,
      safarExpenseTaka: safarExpenseTaka ?? this.safarExpenseTaka,
      transport: transport ?? this.transport,
      transportTaka: transportTaka ?? this.transportTaka,
      communication: communication ?? this.communication,
      communicationTaka: communicationTaka ?? this.communicationTaka,
      prochar: prochar ?? this.prochar,
      procharTaka: procharTaka ?? this.procharTaka,
      prokashnaExpense: prokashnaExpense ?? this.prokashnaExpense,
      prokashnaExpenseTaka: prokashnaExpenseTaka ?? this.prokashnaExpenseTaka,
      dibosPalan: dibosPalan ?? this.dibosPalan,
      dibosPatanTaka: dibosPatanTaka ?? this.dibosPatanTaka,
      appayan: appayan ?? this.appayan,
      appayanTaka: appayanTaka ?? this.appayanTaka,
      sova: sova ?? this.sova,
      sovaTaka: sovaTaka ?? this.sovaTaka,
      kothayBbay: kothayBbay ?? this.kothayBbay,
      remarks: remarks ?? this.remarks,
      reportDate: reportDate ?? this.reportDate,
      baytulmalSecretary: baytulmalSecretary ?? this.baytulmalSecretary,
      president: president ?? this.president,
    );
  }
}

