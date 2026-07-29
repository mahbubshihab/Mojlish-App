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
  final String dibosPalan; // দিবস পালন
  final String dibosPatanTaka;
  final String appayan; // আপ্যায়ন
  final String appayanTaka;
  final String sova; // সভা/সমাবেশ
  final String sovaTaka;
  final String remarks; // মন্তব্য

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
    this.remarks = '',
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
    'executiveMemberAyanat': executiveMemberAyanat,
    'executiveMemberAyanatTaka': executiveMemberAyanatTaka,
    'subBranchAyanat': subBranchAyanat,
    'subBranchAyanatTaka': subBranchAyanatTaka,
    'suhridAyanat': suhridAyanat,
    'suhridAyanatTaka': suhridAyanatTaka,
    'safarIncome': safarIncome,
    'safarIncomeTaka': safarIncomeTaka,
    'prokashnaIncome': prokashnaIncome,
    'prokashnaIncomeTaka': prokashnaIncomeTaka,
    'onetimeIncome': onetimeIncome,
    'onetimeIncomeTaka': onetimeIncomeTaka,
    'previousBalance': previousBalance,
    'upwardAyanat': upwardAyanat,
    'upwardAyanatTaka': upwardAyanatTaka,
    'officeRent': officeRent,
    'officeRentTaka': officeRentTaka,
    'officeCost': officeCost,
    'officeCostTaka': officeCostTaka,
    'safarExpense': safarExpense,
    'safarExpenseTaka': safarExpenseTaka,
    'transport': transport,
    'transportTaka': transportTaka,
    'communication': communication,
    'communicationTaka': communicationTaka,
    'prochar': prochar,
    'procharTaka': procharTaka,
    'prokashnaExpense': prokashnaExpense,
    'prokashnaExpenseTaka': prokashnaExpenseTaka,
    'dibosPalan': dibosPalan,
    'dibosPatanTaka': dibosPatanTaka,
    'appayan': appayan,
    'appayanTaka': appayanTaka,
    'sova': sova,
    'sovaTaka': sovaTaka,
    'remarks': remarks,
  };

  factory BaytulmalReportEntry.fromJson(Map<String, dynamic> json) {
    return BaytulmalReportEntry(
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      branchName: json['branchName'] ?? '',
      executiveMemberAyanat: json['executiveMemberAyanat'] ?? '',
      executiveMemberAyanatTaka: json['executiveMemberAyanatTaka'] ?? '',
      subBranchAyanat: json['subBranchAyanat'] ?? '',
      subBranchAyanatTaka: json['subBranchAyanatTaka'] ?? '',
      suhridAyanat: json['suhridAyanat'] ?? '',
      suhridAyanatTaka: json['suhridAyanatTaka'] ?? '',
      safarIncome: json['safarIncome'] ?? '',
      safarIncomeTaka: json['safarIncomeTaka'] ?? '',
      prokashnaIncome: json['prokashnaIncome'] ?? '',
      prokashnaIncomeTaka: json['prokashnaIncomeTaka'] ?? '',
      onetimeIncome: json['onetimeIncome'] ?? '',
      onetimeIncomeTaka: json['onetimeIncomeTaka'] ?? '',
      previousBalance: json['previousBalance'] ?? '',
      upwardAyanat: json['upwardAyanat'] ?? '',
      upwardAyanatTaka: json['upwardAyanatTaka'] ?? '',
      officeRent: json['officeRent'] ?? '',
      officeRentTaka: json['officeRentTaka'] ?? '',
      officeCost: json['officeCost'] ?? '',
      officeCostTaka: json['officeCostTaka'] ?? '',
      safarExpense: json['safarExpense'] ?? '',
      safarExpenseTaka: json['safarExpenseTaka'] ?? '',
      transport: json['transport'] ?? '',
      transportTaka: json['transportTaka'] ?? '',
      communication: json['communication'] ?? '',
      communicationTaka: json['communicationTaka'] ?? '',
      prochar: json['prochar'] ?? '',
      procharTaka: json['procharTaka'] ?? '',
      prokashnaExpense: json['prokashnaExpense'] ?? '',
      prokashnaExpenseTaka: json['prokashnaExpenseTaka'] ?? '',
      dibosPalan: json['dibosPalan'] ?? '',
      dibosPatanTaka: json['dibosPatanTaka'] ?? '',
      appayan: json['appayan'] ?? '',
      appayanTaka: json['appayanTaka'] ?? '',
      sova: json['sova'] ?? '',
      sovaTaka: json['sovaTaka'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }
}
