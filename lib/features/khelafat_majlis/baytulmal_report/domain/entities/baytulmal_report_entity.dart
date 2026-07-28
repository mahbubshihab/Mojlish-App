class BaytulmalReportEntity {
  final String branch;
  final String month;
  final String year;

  // Income
  final double nirbahiSodossoIyanat;
  final int nirbahiSodossoSonkkha;
  final double odhostonShakhaIyanat;
  final int shakhaSonkkha;
  final double shudhiIyanat;
  final int shudhiSonkkha;
  final double soforAay;
  final double prokashonaAay;
  final double ekkalinAay;
  final double motAay;
  final double bigotoMashUdbritto;
  final double sorbomotAay;
  final String kothayAay;

  // Expenditure
  final double urdhotonIyanatPorishodh;
  final double mashikDharjokrito;
  final double officeVaraOBill;
  final double officeKhoroch;
  final double soforBbay;
  final double jatayat;
  final double jogajog;
  final double prochar;
  final double prokashonaBbay;
  final double diboshPalon;
  final String diboshNam;
  final double appayon;
  final double shobhaShomabesh;
  final double motBbay;
  final double udbrittoGhatti;
  final String kothayBbay;

  final String reportDate;
  final String baytulmalSompodokShakkhor;
  final String sobhapotiShakkhor;

  BaytulmalReportEntity({
    required this.branch,
    required this.month,
    required this.year,
    required this.nirbahiSodossoIyanat,
    required this.nirbahiSodossoSonkkha,
    required this.odhostonShakhaIyanat,
    required this.shakhaSonkkha,
    required this.shudhiIyanat,
    required this.shudhiSonkkha,
    required this.soforAay,
    required this.prokashonaAay,
    required this.ekkalinAay,
    required this.motAay,
    required this.bigotoMashUdbritto,
    required this.sorbomotAay,
    required this.kothayAay,
    required this.urdhotonIyanatPorishodh,
    required this.mashikDharjokrito,
    required this.officeVaraOBill,
    required this.officeKhoroch,
    required this.soforBbay,
    required this.jatayat,
    required this.jogajog,
    required this.prochar,
    required this.prokashonaBbay,
    required this.diboshPalon,
    required this.diboshNam,
    required this.appayon,
    required this.shobhaShomabesh,
    required this.motBbay,
    required this.udbrittoGhatti,
    required this.kothayBbay,
    required this.reportDate,
    required this.baytulmalSompodokShakkhor,
    required this.sobhapotiShakkhor,
  });
}
