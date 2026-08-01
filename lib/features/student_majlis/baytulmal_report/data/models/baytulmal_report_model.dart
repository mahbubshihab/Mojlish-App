import '../../domain/entities/baytulmal_report_entity.dart';

class BaytulmalReportModel extends BaytulmalReportEntity {
  BaytulmalReportModel({
    required super.branch,
    required super.month,
    required super.session,
    required super.jonoshoktiIyanot,
    required super.shakhaIyanot,
    required super.shuvakangkhiIyanot,
    required super.ekkalinAy,
    super.customIncomes = const [],
    required super.motAy,
    required super.bigotoSeshonMasherUdbritto,
    required super.sorbomotAy,
    required super.motAyInWords,
    required super.urdhotonIyanotPorishodh,
    required super.urdhotonSofor,
    required super.office,
    required super.jatayat,
    required super.jogajog,
    required super.prochar,
    super.customExpenses = const [],
    required super.motBay,
    required super.bigotoSeshonMasherGhatti,
    required super.sorbomotBay,
    required super.udbrittoBaGhatti,
    required super.motBayInWords,
    required super.presidentSignature,
  });

  factory BaytulmalReportModel.fromJson(Map<String, dynamic> json) {
    List<BaytulmalItemEntity> parseCustomItems(String key) {
      if (json[key] is List) {
        return (json[key] as List)
            .map((e) => BaytulmalItemEntity.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    }

    return BaytulmalReportModel(
      branch: json['branch'] ?? '',
      month: json['month'] ?? '',
      session: json['session'] ?? '',
      jonoshoktiIyanot: (json['jonoshoktiIyanot'] ?? 0).toDouble(),
      shakhaIyanot: (json['shakhaIyanot'] ?? 0).toDouble(),
      shuvakangkhiIyanot: (json['shuvakangkhiIyanot'] ?? 0).toDouble(),
      ekkalinAy: (json['ekkalinAy'] ?? 0).toDouble(),
      customIncomes: parseCustomItems('customIncomes'),
      motAy: (json['motAy'] ?? 0).toDouble(),
      bigotoSeshonMasherUdbritto: (json['bigotoSeshonMasherUdbritto'] ?? 0).toDouble(),
      sorbomotAy: (json['sorbomotAy'] ?? 0).toDouble(),
      motAyInWords: json['motAyInWords'] ?? '',
      urdhotonIyanotPorishodh: (json['urdhotonIyanotPorishodh'] ?? 0).toDouble(),
      urdhotonSofor: (json['urdhotonSofor'] ?? 0).toDouble(),
      office: (json['office'] ?? 0).toDouble(),
      jatayat: (json['jatayat'] ?? 0).toDouble(),
      jogajog: (json['jogajog'] ?? 0).toDouble(),
      prochar: (json['prochar'] ?? 0).toDouble(),
      customExpenses: parseCustomItems('customExpenses'),
      motBay: (json['motBay'] ?? 0).toDouble(),
      bigotoSeshonMasherGhatti: (json['bigotoSeshonMasherGhatti'] ?? 0).toDouble(),
      sorbomotBay: (json['sorbomotBay'] ?? 0).toDouble(),
      udbrittoBaGhatti: (json['udbrittoBaGhatti'] ?? 0).toDouble(),
      motBayInWords: json['motBayInWords'] ?? '',
      presidentSignature: json['presidentSignature'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch': branch,
      'month': month,
      'session': session,
      'jonoshoktiIyanot': jonoshoktiIyanot,
      'shakhaIyanot': shakhaIyanot,
      'shuvakangkhiIyanot': shuvakangkhiIyanot,
      'ekkalinAy': ekkalinAy,
      'customIncomes': customIncomes.map((e) => e.toJson()).toList(),
      'motAy': motAy,
      'bigotoSeshonMasherUdbritto': bigotoSeshonMasherUdbritto,
      'sorbomotAy': sorbomotAy,
      'motAyInWords': motAyInWords,
      'urdhotonIyanotPorishodh': urdhotonIyanotPorishodh,
      'urdhotonSofor': urdhotonSofor,
      'office': office,
      'jatayat': jatayat,
      'jogajog': jogajog,
      'prochar': prochar,
      'customExpenses': customExpenses.map((e) => e.toJson()).toList(),
      'motBay': motBay,
      'bigotoSeshonMasherGhatti': bigotoSeshonMasherGhatti,
      'sorbomotBay': sorbomotBay,
      'udbrittoBaGhatti': udbrittoBaGhatti,
      'motBayInWords': motBayInWords,
      'presidentSignature': presidentSignature,
    };
  }
}

