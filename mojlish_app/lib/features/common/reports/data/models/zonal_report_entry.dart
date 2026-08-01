class ZonalReportEntry {
  final String month;
  final String year;
  final String zoneName;

  // জনশক্তি (Manpower)
  final String sodossoCount;
  final String sodossoBridhi;
  final String sodossoGhatti;
  final String sodossoPrarthiCount;
  final String sodossoPrarthiBridhi;
  final String sodossoPrarthiGhatti;

  // সংগঠন (Organization)
  final String districtCount;
  final String districtOrg;
  final String districtReorg;
  final String cityCount;
  final String cityOrg;
  final String cityReorg;
  final String upazilaThanaCount;
  final String upazilaThanaOrg;
  final String upazilaThanaReorg;

  // সভা/প্রশিক্ষণ (Meeting/Training)
  final String shakhaDaitoshilCount;
  final String shakhaDaitoshilPresence;
  final String districtExecCount;
  final String districtExecPresence;
  final String zonalTorbiotCount;
  final String zonalTorbiotPresence;

  // সফর (জোন থেকে)
  final String travelDetails;

  // আয়-ব্যয় (Income-Expense summary)
  final String safarIncomeTaka;
  final String centralIncomeTaka;
  final String onetimeIncomeTaka;
  final String safarExpenseTaka;
  final String communicationExpenseTaka;
  final String officeExpenseTaka;
  final String otherExpenseTaka;

  // অন্যান্য (Other status counters)
  final String shakhaReportSubmitted;
  final String shakhaPlanSubmitted;
  final String shakhaBaytulmalSubmitted;

  // মন্তব্য ও পরামর্শ
  final String remarks;
  final String suggestions;
  final int? updatedAt;

  ZonalReportEntry({
    required this.month,
    required this.year,
    required this.zoneName,
    this.sodossoCount = '',
    this.sodossoBridhi = '',
    this.sodossoGhatti = '',
    this.sodossoPrarthiCount = '',
    this.sodossoPrarthiBridhi = '',
    this.sodossoPrarthiGhatti = '',
    this.districtCount = '',
    this.districtOrg = '',
    this.districtReorg = '',
    this.cityCount = '',
    this.cityOrg = '',
    this.cityReorg = '',
    this.upazilaThanaCount = '',
    this.upazilaThanaOrg = '',
    this.upazilaThanaReorg = '',
    this.shakhaDaitoshilCount = '',
    this.shakhaDaitoshilPresence = '',
    this.districtExecCount = '',
    this.districtExecPresence = '',
    this.zonalTorbiotCount = '',
    this.zonalTorbiotPresence = '',
    this.travelDetails = '',
    this.safarIncomeTaka = '',
    this.centralIncomeTaka = '',
    this.onetimeIncomeTaka = '',
    this.safarExpenseTaka = '',
    this.communicationExpenseTaka = '',
    this.officeExpenseTaka = '',
    this.otherExpenseTaka = '',
    this.shakhaReportSubmitted = '',
    this.shakhaPlanSubmitted = '',
    this.shakhaBaytulmalSubmitted = '',
    this.remarks = '',
    this.suggestions = '',
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'year': year,
      'zoneName': zoneName,
      'sodossoCount': sodossoCount,
      'sodossoBridhi': sodossoBridhi,
      'sodossoGhatti': sodossoGhatti,
      'sodossoPrarthiCount': sodossoPrarthiCount,
      'sodossoPrarthiBridhi': sodossoPrarthiBridhi,
      'sodossoPrarthiGhatti': sodossoPrarthiGhatti,
      'districtCount': districtCount,
      'districtOrg': districtOrg,
      'districtReorg': districtReorg,
      'cityCount': cityCount,
      'cityOrg': cityOrg,
      'cityReorg': cityReorg,
      'upazilaThanaCount': upazilaThanaCount,
      'upazilaThanaOrg': upazilaThanaOrg,
      'upazilaThanaReorg': upazilaThanaReorg,
      'shakhaDaitoshilCount': shakhaDaitoshilCount,
      'shakhaDaitoshilPresence': shakhaDaitoshilPresence,
      'districtExecCount': districtExecCount,
      'districtExecPresence': districtExecPresence,
      'zonalTorbiotCount': zonalTorbiotCount,
      'zonalTorbiotPresence': zonalTorbiotPresence,
      'travelDetails': travelDetails,
      'safarIncomeTaka': safarIncomeTaka,
      'centralIncomeTaka': centralIncomeTaka,
      'onetimeIncomeTaka': onetimeIncomeTaka,
      'safarExpenseTaka': safarExpenseTaka,
      'communicationExpenseTaka': communicationExpenseTaka,
      'officeExpenseTaka': officeExpenseTaka,
      'otherExpenseTaka': otherExpenseTaka,
      'shakhaReportSubmitted': shakhaReportSubmitted,
      'shakhaPlanSubmitted': shakhaPlanSubmitted,
      'shakhaBaytulmalSubmitted': shakhaBaytulmalSubmitted,
      'remarks': remarks,
      'suggestions': suggestions,
      'updatedAt': updatedAt,
    };
  }

  factory ZonalReportEntry.fromMap(Map<String, dynamic>? map, [int? year, int? month]) {
    if (map == null) {
      return ZonalReportEntry(
        year: year?.toString() ?? '',
        month: month?.toString() ?? '',
        zoneName: '',
      );
    }
    return ZonalReportEntry.fromJson(map);
  }

  factory ZonalReportEntry.fromJson(Map<String, dynamic> json) {
    return ZonalReportEntry(
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      zoneName: json['zoneName'] ?? '',
      sodossoCount: json['sodossoCount'] ?? '',
      sodossoBridhi: json['sodossoBridhi'] ?? '',
      sodossoGhatti: json['sodossoGhatti'] ?? '',
      sodossoPrarthiCount: json['sodossoPrarthiCount'] ?? '',
      sodossoPrarthiBridhi: json['sodossoPrarthiBridhi'] ?? '',
      sodossoPrarthiGhatti: json['sodossoPrarthiGhatti'] ?? '',
      districtCount: json['districtCount'] ?? '',
      districtOrg: json['districtOrg'] ?? '',
      districtReorg: json['districtReorg'] ?? '',
      cityCount: json['cityCount'] ?? '',
      cityOrg: json['cityOrg'] ?? '',
      cityReorg: json['cityReorg'] ?? '',
      upazilaThanaCount: json['upazilaThanaCount'] ?? '',
      upazilaThanaOrg: json['upazilaThanaOrg'] ?? '',
      upazilaThanaReorg: json['upazilaThanaReorg'] ?? '',
      shakhaDaitoshilCount: json['shakhaDaitoshilCount'] ?? '',
      shakhaDaitoshilPresence: json['shakhaDaitoshilPresence'] ?? '',
      districtExecCount: json['districtExecCount'] ?? '',
      districtExecPresence: json['districtExecPresence'] ?? '',
      zonalTorbiotCount: json['zonalTorbiotCount'] ?? '',
      zonalTorbiotPresence: json['zonalTorbiotPresence'] ?? '',
      travelDetails: json['travelDetails'] ?? '',
      safarIncomeTaka: json['safarIncomeTaka'] ?? '',
      centralIncomeTaka: json['centralIncomeTaka'] ?? '',
      onetimeIncomeTaka: json['onetimeIncomeTaka'] ?? '',
      safarExpenseTaka: json['safarExpenseTaka'] ?? '',
      communicationExpenseTaka: json['communicationExpenseTaka'] ?? '',
      officeExpenseTaka: json['officeExpenseTaka'] ?? '',
      otherExpenseTaka: json['otherExpenseTaka'] ?? '',
      shakhaReportSubmitted: json['shakhaReportSubmitted'] ?? '',
      shakhaPlanSubmitted: json['shakhaPlanSubmitted'] ?? '',
      shakhaBaytulmalSubmitted: json['shakhaBaytulmalSubmitted'] ?? '',
      remarks: json['remarks'] ?? '',
      suggestions: json['suggestions'] ?? '',
      updatedAt: json['updatedAt'],
    );
  }

  ZonalReportEntry copyWith({
    String? month,
    String? year,
    String? zoneName,
    String? sodossoCount,
    String? sodossoBridhi,
    String? sodossoGhatti,
    String? sodossoPrarthiCount,
    String? sodossoPrarthiBridhi,
    String? sodossoPrarthiGhatti,
    String? districtCount,
    String? districtOrg,
    String? districtReorg,
    String? cityCount,
    String? cityOrg,
    String? cityReorg,
    String? upazilaThanaCount,
    String? upazilaThanaOrg,
    String? upazilaThanaReorg,
    String? shakhaDaitoshilCount,
    String? shakhaDaitoshilPresence,
    String? districtExecCount,
    String? districtExecPresence,
    String? zonalTorbiotCount,
    String? zonalTorbiotPresence,
    String? travelDetails,
    String? safarIncomeTaka,
    String? centralIncomeTaka,
    String? onetimeIncomeTaka,
    String? safarExpenseTaka,
    String? communicationExpenseTaka,
    String? officeExpenseTaka,
    String? otherExpenseTaka,
    String? shakhaReportSubmitted,
    String? shakhaPlanSubmitted,
    String? shakhaBaytulmalSubmitted,
    String? remarks,
    String? suggestions,
    int? updatedAt,
  }) {
    return ZonalReportEntry(
      month: month ?? this.month,
      year: year ?? this.year,
      zoneName: zoneName ?? this.zoneName,
      sodossoCount: sodossoCount ?? this.sodossoCount,
      sodossoBridhi: sodossoBridhi ?? this.sodossoBridhi,
      sodossoGhatti: sodossoGhatti ?? this.sodossoGhatti,
      sodossoPrarthiCount: sodossoPrarthiCount ?? this.sodossoPrarthiCount,
      sodossoPrarthiBridhi: sodossoPrarthiBridhi ?? this.sodossoPrarthiBridhi,
      sodossoPrarthiGhatti: sodossoPrarthiGhatti ?? this.sodossoPrarthiGhatti,
      districtCount: districtCount ?? this.districtCount,
      districtOrg: districtOrg ?? this.districtOrg,
      districtReorg: districtReorg ?? this.districtReorg,
      cityCount: cityCount ?? this.cityCount,
      cityOrg: cityOrg ?? this.cityOrg,
      cityReorg: cityReorg ?? this.cityReorg,
      upazilaThanaCount: upazilaThanaCount ?? this.upazilaThanaCount,
      upazilaThanaOrg: upazilaThanaOrg ?? this.upazilaThanaOrg,
      upazilaThanaReorg: upazilaThanaReorg ?? this.upazilaThanaReorg,
      shakhaDaitoshilCount: shakhaDaitoshilCount ?? this.shakhaDaitoshilCount,
      shakhaDaitoshilPresence: shakhaDaitoshilPresence ?? this.shakhaDaitoshilPresence,
      districtExecCount: districtExecCount ?? this.districtExecCount,
      districtExecPresence: districtExecPresence ?? this.districtExecPresence,
      zonalTorbiotCount: zonalTorbiotCount ?? this.zonalTorbiotCount,
      zonalTorbiotPresence: zonalTorbiotPresence ?? this.zonalTorbiotPresence,
      travelDetails: travelDetails ?? this.travelDetails,
      safarIncomeTaka: safarIncomeTaka ?? this.safarIncomeTaka,
      centralIncomeTaka: centralIncomeTaka ?? this.centralIncomeTaka,
      onetimeIncomeTaka: onetimeIncomeTaka ?? this.onetimeIncomeTaka,
      safarExpenseTaka: safarExpenseTaka ?? this.safarExpenseTaka,
      communicationExpenseTaka: communicationExpenseTaka ?? this.communicationExpenseTaka,
      officeExpenseTaka: officeExpenseTaka ?? this.officeExpenseTaka,
      otherExpenseTaka: otherExpenseTaka ?? this.otherExpenseTaka,
      shakhaReportSubmitted: shakhaReportSubmitted ?? this.shakhaReportSubmitted,
      shakhaPlanSubmitted: shakhaPlanSubmitted ?? this.shakhaPlanSubmitted,
      shakhaBaytulmalSubmitted: shakhaBaytulmalSubmitted ?? this.shakhaBaytulmalSubmitted,
      remarks: remarks ?? this.remarks,
      suggestions: suggestions ?? this.suggestions,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get totalIncome {
    double parse(String s) => double.tryParse(s) ?? 0.0;
    return parse(safarIncomeTaka) + parse(centralIncomeTaka) + parse(onetimeIncomeTaka);
  }

  double get totalExpense {
    double parse(String s) => double.tryParse(s) ?? 0.0;
    return parse(safarExpenseTaka) + parse(communicationExpenseTaka) + parse(officeExpenseTaka) + parse(otherExpenseTaka);
  }

  double get balance => totalIncome - totalExpense;
}
