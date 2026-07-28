import '../../domain/entities/baytulmal_report_entity.dart';

/// StudentBaytulmalReport Model for JSON Serialization / Deserialization
class StudentBaytulmalReportModel extends StudentBaytulmalReportEntity {
  const StudentBaytulmalReportModel({
    required super.id,
    required super.year,
    required super.month,
    super.session,
    super.branchName,
    super.jonoshaktiAyanatTaka,
    super.jonoshaktiAyanatPaisa,
    super.shakhaAyanatTaka,
    super.shakhaAyanatPaisa,
    super.suhridAyanatTaka,
    super.suhridAyanatPaisa,
    super.ekkalinIncomeTaka,
    super.ekkalinIncomePaisa,
    super.customIncomeRows,
    super.incomeInWords,
    super.previousSurplusTaka,
    super.previousSurplusPaisa,
    super.upwardAyanatTaka,
    super.upwardAyanatPaisa,
    super.upwardSafarTaka,
    super.upwardSafarPaisa,
    super.officeTaka,
    super.officePaisa,
    super.transportTaka,
    super.transportPaisa,
    super.communicationTaka,
    super.communicationPaisa,
    super.procharTaka,
    super.procharPaisa,
    super.customExpenseRows,
    super.expenseInWords,
    super.previousDeficitTaka,
    super.previousDeficitPaisa,
  });

  factory StudentBaytulmalReportModel.fromJson(Map<String, dynamic> json) {
    final customInc = (json['customIncomeRows'] as List<dynamic>?)
            ?.map((e) => StudentBaytulmalRowItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final customExp = (json['customExpenseRows'] as List<dynamic>?)
            ?.map((e) => StudentBaytulmalRowItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return StudentBaytulmalReportModel(
      id: json['id'] ?? '',
      year: json['year'] is int ? json['year'] : int.tryParse(json['year']?.toString() ?? '') ?? DateTime.now().year,
      month: json['month'] is int ? json['month'] : int.tryParse(json['month']?.toString() ?? '') ?? DateTime.now().month,
      session: json['session'] ?? '',
      branchName: json['branchName'] ?? '',
      jonoshaktiAyanatTaka: json['jonoshaktiAyanatTaka'] ?? '0',
      jonoshaktiAyanatPaisa: json['jonoshaktiAyanatPaisa'] ?? '0',
      shakhaAyanatTaka: json['shakhaAyanatTaka'] ?? '0',
      shakhaAyanatPaisa: json['shakhaAyanatPaisa'] ?? '0',
      suhridAyanatTaka: json['suhridAyanatTaka'] ?? '0',
      suhridAyanatPaisa: json['suhridAyanatPaisa'] ?? '0',
      ekkalinIncomeTaka: json['ekkalinIncomeTaka'] ?? '0',
      ekkalinIncomePaisa: json['ekkalinIncomePaisa'] ?? '0',
      customIncomeRows: customInc,
      incomeInWords: json['incomeInWords'] ?? '',
      previousSurplusTaka: json['previousSurplusTaka'] ?? '0',
      previousSurplusPaisa: json['previousSurplusPaisa'] ?? '0',
      upwardAyanatTaka: json['upwardAyanatTaka'] ?? '0',
      upwardAyanatPaisa: json['upwardAyanatPaisa'] ?? '0',
      upwardSafarTaka: json['upwardSafarTaka'] ?? '0',
      upwardSafarPaisa: json['upwardSafarPaisa'] ?? '0',
      officeTaka: json['officeTaka'] ?? '0',
      officePaisa: json['officePaisa'] ?? '0',
      transportTaka: json['transportTaka'] ?? '0',
      transportPaisa: json['transportPaisa'] ?? '0',
      communicationTaka: json['communicationTaka'] ?? '0',
      communicationPaisa: json['communicationPaisa'] ?? '0',
      procharTaka: json['procharTaka'] ?? '0',
      procharPaisa: json['procharPaisa'] ?? '0',
      customExpenseRows: customExp,
      expenseInWords: json['expenseInWords'] ?? '',
      previousDeficitTaka: json['previousDeficitTaka'] ?? '0',
      previousDeficitPaisa: json['previousDeficitPaisa'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
      'month': month,
      'session': session,
      'branchName': branchName,
      'jonoshaktiAyanatTaka': jonoshaktiAyanatTaka,
      'jonoshaktiAyanatPaisa': jonoshaktiAyanatPaisa,
      'shakhaAyanatTaka': shakhaAyanatTaka,
      'shakhaAyanatPaisa': shakhaAyanatPaisa,
      'suhridAyanatTaka': suhridAyanatTaka,
      'suhridAyanatPaisa': suhridAyanatPaisa,
      'ekkalinIncomeTaka': ekkalinIncomeTaka,
      'ekkalinIncomePaisa': ekkalinIncomePaisa,
      'customIncomeRows': customIncomeRows.map((e) => e.toJson()).toList(),
      'incomeInWords': incomeInWords,
      'previousSurplusTaka': previousSurplusTaka,
      'previousSurplusPaisa': previousSurplusPaisa,
      'upwardAyanatTaka': upwardAyanatTaka,
      'upwardAyanatPaisa': upwardAyanatPaisa,
      'upwardSafarTaka': upwardSafarTaka,
      'upwardSafarPaisa': upwardSafarPaisa,
      'officeTaka': officeTaka,
      'officePaisa': officePaisa,
      'transportTaka': transportTaka,
      'transportPaisa': transportPaisa,
      'communicationTaka': communicationTaka,
      'communicationPaisa': communicationPaisa,
      'procharTaka': procharTaka,
      'procharPaisa': procharPaisa,
      'customExpenseRows': customExpenseRows.map((e) => e.toJson()).toList(),
      'expenseInWords': expenseInWords,
      'previousDeficitTaka': previousDeficitTaka,
      'previousDeficitPaisa': previousDeficitPaisa,
    };
  }

  factory StudentBaytulmalReportModel.fromEntity(StudentBaytulmalReportEntity entity) {
    return StudentBaytulmalReportModel(
      id: entity.id,
      year: entity.year,
      month: entity.month,
      session: entity.session,
      branchName: entity.branchName,
      jonoshaktiAyanatTaka: entity.jonoshaktiAyanatTaka,
      jonoshaktiAyanatPaisa: entity.jonoshaktiAyanatPaisa,
      shakhaAyanatTaka: entity.shakhaAyanatTaka,
      shakhaAyanatPaisa: entity.shakhaAyanatPaisa,
      suhridAyanatTaka: entity.suhridAyanatTaka,
      suhridAyanatPaisa: entity.suhridAyanatPaisa,
      ekkalinIncomeTaka: entity.ekkalinIncomeTaka,
      ekkalinIncomePaisa: entity.ekkalinIncomePaisa,
      customIncomeRows: entity.customIncomeRows,
      incomeInWords: entity.incomeInWords,
      previousSurplusTaka: entity.previousSurplusTaka,
      previousSurplusPaisa: entity.previousSurplusPaisa,
      upwardAyanatTaka: entity.upwardAyanatTaka,
      upwardAyanatPaisa: entity.upwardAyanatPaisa,
      upwardSafarTaka: entity.upwardSafarTaka,
      upwardSafarPaisa: entity.upwardSafarPaisa,
      officeTaka: entity.officeTaka,
      officePaisa: entity.officePaisa,
      transportTaka: entity.transportTaka,
      transportPaisa: entity.transportPaisa,
      communicationTaka: entity.communicationTaka,
      communicationPaisa: entity.communicationPaisa,
      procharTaka: entity.procharTaka,
      procharPaisa: entity.procharPaisa,
      customExpenseRows: entity.customExpenseRows,
      expenseInWords: entity.expenseInWords,
      previousDeficitTaka: entity.previousDeficitTaka,
      previousDeficitPaisa: entity.previousDeficitPaisa,
    );
  }
}
