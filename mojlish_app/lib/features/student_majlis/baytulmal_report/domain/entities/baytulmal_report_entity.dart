import 'package:equatable/equatable.dart';

/// Single Row item for custom or standard Baytulmal entry (Title, Taka, Paisa)
class StudentBaytulmalRowItem extends Equatable {
  final String title;
  final String taka;
  final String paisa;

  const StudentBaytulmalRowItem({
    required this.title,
    this.taka = '0',
    this.paisa = '0',
  });

  double get totalAmount {
    final t = double.tryParse(taka) ?? 0.0;
    final p = double.tryParse(paisa) ?? 0.0;
    return t + (p / 100.0);
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'taka': taka,
        'paisa': paisa,
      };

  factory StudentBaytulmalRowItem.fromJson(Map<String, dynamic> json) =>
      StudentBaytulmalRowItem(
        title: json['title'] ?? '',
        taka: json['taka'] ?? '0',
        paisa: json['paisa'] ?? '0',
      );

  StudentBaytulmalRowItem copyWith({
    String? title,
    String? taka,
    String? paisa,
  }) {
    return StudentBaytulmalRowItem(
      title: title ?? this.title,
      taka: taka ?? this.taka,
      paisa: paisa ?? this.paisa,
    );
  }

  @override
  List<Object?> get props => [title, taka, paisa];
}

/// StudentBaytulmalReport Entity representing official paper form
class StudentBaytulmalReportEntity extends Equatable {
  final String id;
  final int year;
  final int month;
  final String session;
  final String branchName;

  // আয় (Income) - Pre-printed rows
  final String jonoshaktiAyanatTaka;
  final String jonoshaktiAyanatPaisa;
  final String shakhaAyanatTaka;
  final String shakhaAyanatPaisa;
  final String suhridAyanatTaka;
  final String suhridAyanatPaisa;
  final String ekkalinIncomeTaka;
  final String ekkalinIncomePaisa;

  // Custom income rows
  final List<StudentBaytulmalRowItem> customIncomeRows;

  // Income summary
  final String incomeInWords;
  final String previousSurplusTaka;
  final String previousSurplusPaisa;

  // ব্যয় (Expense) - Pre-printed rows
  final String upwardAyanatTaka;
  final String upwardAyanatPaisa;
  final String upwardSafarTaka;
  final String upwardSafarPaisa;
  final String officeTaka;
  final String officePaisa;
  final String transportTaka;
  final String transportPaisa;
  final String communicationTaka;
  final String communicationPaisa;
  final String procharTaka;
  final String procharPaisa;

  // Custom expense rows
  final List<StudentBaytulmalRowItem> customExpenseRows;

  // Expense summary
  final String expenseInWords;
  final String previousDeficitTaka;
  final String previousDeficitPaisa;

  const StudentBaytulmalReportEntity({
    required this.id,
    required this.year,
    required this.month,
    this.session = '',
    this.branchName = '',
    this.jonoshaktiAyanatTaka = '0',
    this.jonoshaktiAyanatPaisa = '0',
    this.shakhaAyanatTaka = '0',
    this.shakhaAyanatPaisa = '0',
    this.suhridAyanatTaka = '0',
    this.suhridAyanatPaisa = '0',
    this.ekkalinIncomeTaka = '0',
    this.ekkalinIncomePaisa = '0',
    this.customIncomeRows = const [],
    this.incomeInWords = '',
    this.previousSurplusTaka = '0',
    this.previousSurplusPaisa = '0',
    this.upwardAyanatTaka = '0',
    this.upwardAyanatPaisa = '0',
    this.upwardSafarTaka = '0',
    this.upwardSafarPaisa = '0',
    this.officeTaka = '0',
    this.officePaisa = '0',
    this.transportTaka = '0',
    this.transportPaisa = '0',
    this.communicationTaka = '0',
    this.communicationPaisa = '0',
    this.procharTaka = '0',
    this.procharPaisa = '0',
    this.customExpenseRows = const [],
    this.expenseInWords = '',
    this.previousDeficitTaka = '0',
    this.previousDeficitPaisa = '0',
  });

  static double _parseVal(String t, String p) {
    final takaVal = double.tryParse(t) ?? 0.0;
    final paisaVal = double.tryParse(p) ?? 0.0;
    return takaVal + (paisaVal / 100.0);
  }

  double get totalIncome {
    double sum = _parseVal(jonoshaktiAyanatTaka, jonoshaktiAyanatPaisa) +
        _parseVal(shakhaAyanatTaka, shakhaAyanatPaisa) +
        _parseVal(suhridAyanatTaka, suhridAyanatPaisa) +
        _parseVal(ekkalinIncomeTaka, ekkalinIncomePaisa);

    for (final row in customIncomeRows) {
      sum += row.totalAmount;
    }
    return sum;
  }

  double get previousSurplus => _parseVal(previousSurplusTaka, previousSurplusPaisa);

  double get grandTotalIncome => totalIncome + previousSurplus;

  double get totalExpense {
    double sum = _parseVal(upwardAyanatTaka, upwardAyanatPaisa) +
        _parseVal(upwardSafarTaka, upwardSafarPaisa) +
        _parseVal(officeTaka, officePaisa) +
        _parseVal(transportTaka, transportPaisa) +
        _parseVal(communicationTaka, communicationPaisa) +
        _parseVal(procharTaka, procharPaisa);

    for (final row in customExpenseRows) {
      sum += row.totalAmount;
    }
    return sum;
  }

  double get previousDeficit => _parseVal(previousDeficitTaka, previousDeficitPaisa);

  double get grandTotalExpense => totalExpense + previousDeficit;

  /// Surplus (+) or Deficit (-)
  double get balance => grandTotalIncome - grandTotalExpense;

  @override
  List<Object?> get props => [
        id,
        year,
        month,
        session,
        branchName,
        jonoshaktiAyanatTaka,
        jonoshaktiAyanatPaisa,
        shakhaAyanatTaka,
        shakhaAyanatPaisa,
        suhridAyanatTaka,
        suhridAyanatPaisa,
        ekkalinIncomeTaka,
        ekkalinIncomePaisa,
        customIncomeRows,
        incomeInWords,
        previousSurplusTaka,
        previousSurplusPaisa,
        upwardAyanatTaka,
        upwardAyanatPaisa,
        upwardSafarTaka,
        upwardSafarPaisa,
        officeTaka,
        officePaisa,
        transportTaka,
        transportPaisa,
        communicationTaka,
        communicationPaisa,
        procharTaka,
        procharPaisa,
        customExpenseRows,
        expenseInWords,
        previousDeficitTaka,
        previousDeficitPaisa,
      ];
}
