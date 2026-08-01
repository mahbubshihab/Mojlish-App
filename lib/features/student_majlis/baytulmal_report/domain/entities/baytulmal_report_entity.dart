class BaytulmalItemEntity {
  final String title;
  final double amount;

  const BaytulmalItemEntity({
    required this.title,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'amount': amount,
      };

  factory BaytulmalItemEntity.fromJson(Map<String, dynamic> json) =>
      BaytulmalItemEntity(
        title: json['title'] ?? '',
        amount: (json['amount'] ?? 0).toDouble(),
      );
}

class BaytulmalReportEntity {
  final String branch;
  final String month;
  final String session;

  final double jonoshoktiIyanot;
  final double shakhaIyanot;
  final double shuvakangkhiIyanot;
  final double ekkalinAy;
  final List<BaytulmalItemEntity> customIncomes;

  final double motAy;
  final double bigotoSeshonMasherUdbritto;
  final double sorbomotAy;
  final String motAyInWords;

  final double urdhotonIyanotPorishodh;
  final double urdhotonSofor;
  final double office;
  final double jatayat;
  final double jogajog;
  final double prochar;
  final List<BaytulmalItemEntity> customExpenses;

  final double motBay;
  final double bigotoSeshonMasherGhatti;
  final double sorbomotBay;
  final double udbrittoBaGhatti;
  final String motBayInWords;

  final String presidentSignature;

  BaytulmalReportEntity({
    required this.branch,
    required this.month,
    required this.session,
    required this.jonoshoktiIyanot,
    required this.shakhaIyanot,
    required this.shuvakangkhiIyanot,
    required this.ekkalinAy,
    this.customIncomes = const [],
    required this.motAy,
    required this.bigotoSeshonMasherUdbritto,
    required this.sorbomotAy,
    required this.motAyInWords,
    required this.urdhotonIyanotPorishodh,
    required this.urdhotonSofor,
    required this.office,
    required this.jatayat,
    required this.jogajog,
    required this.prochar,
    this.customExpenses = const [],
    required this.motBay,
    required this.bigotoSeshonMasherGhatti,
    required this.sorbomotBay,
    required this.udbrittoBaGhatti,
    required this.motBayInWords,
    required this.presidentSignature,
  });
}

