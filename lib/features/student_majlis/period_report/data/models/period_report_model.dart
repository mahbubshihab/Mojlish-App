import '../../domain/entities/period_report.dart';

class PeriodReportModel extends PeriodReport {
  const PeriodReportModel({
    required super.id,
    required super.branch,
    required super.month,
    required super.session,
    required super.manpower,
    required super.dawah,
    required super.organization,
    required super.meetings,
    required super.training,
    required super.library,
    required super.baytulmal,
  });

  factory PeriodReportModel.fromJson(Map<String, dynamic> json) {
    return PeriodReportModel(
      id: json['id'] ?? '',
      branch: json['branch'] ?? '',
      month: json['month'] ?? '',
      session: json['session'] ?? '',
      manpower: ManpowerModel.fromJson(json['manpower'] ?? {}),
      dawah: DawahModel.fromJson(json['dawah'] ?? {}),
      organization: OrganizationModel.fromJson(json['organization'] ?? {}),
      meetings: MeetingsModel.fromJson(json['meetings'] ?? {}),
      training: TrainingModel.fromJson(json['training'] ?? {}),
      library: LibraryModel.fromJson(json['library'] ?? {}),
      baytulmal: BaytulmalModel.fromJson(json['baytulmal'] ?? {}),
    );
  }

  factory PeriodReportModel.empty({
    String periodType = '',
    int year = 2026,
    String periodName = '',
  }) {
    return PeriodReportModel(
      id: '${periodType}_${year}_$periodName',
      branch: '',
      month: periodName,
      session: year.toString(),
      manpower: const ManpowerModel(),
      dawah: const DawahModel(),
      organization: const OrganizationModel(),
      meetings: const MeetingsModel(),
      training: const TrainingModel(),
      library: const LibraryModel(),
      baytulmal: const BaytulmalModel(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch': branch,
      'month': month,
      'session': session,
      'manpower': (manpower as ManpowerModel).toJson(),
      'dawah': (dawah as DawahModel).toJson(),
      'organization': (organization as OrganizationModel).toJson(),
      'meetings': (meetings as MeetingsModel).toJson(),
      'training': (training as TrainingModel).toJson(),
      'library': (library as LibraryModel).toJson(),
      'baytulmal': (baytulmal as BaytulmalModel).toJson(),
    };
  }
}

class ManpowerModel extends Manpower {
  const ManpowerModel({
    super.members = 0,
    super.candidateMembers = 0,
    super.associateMembers = 0,
    super.candidateAssociateMembers = 0,
    super.workers = 0,
  });

  factory ManpowerModel.fromJson(Map<String, dynamic> json) {
    return ManpowerModel(
      members: json['members'] ?? 0,
      candidateMembers: json['candidateMembers'] ?? 0,
      associateMembers: json['associateMembers'] ?? 0,
      candidateAssociateMembers: json['candidateAssociateMembers'] ?? 0,
      workers: json['workers'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'members': members,
      'candidateMembers': candidateMembers,
      'associateMembers': associateMembers,
      'candidateAssociateMembers': candidateAssociateMembers,
      'workers': workers,
    };
  }
}

class DawahModel extends Dawah {
  const DawahModel({
    super.primaryMembers = 0,
    super.friends = 0,
    super.wellWishers = 0,
  });

  factory DawahModel.fromJson(Map<String, dynamic> json) {
    return DawahModel(
      primaryMembers: json['primaryMembers'] ?? 0,
      friends: json['friends'] ?? 0,
      wellWishers: json['wellWishers'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primaryMembers': primaryMembers,
      'friends': friends,
      'wellWishers': wellWishers,
    };
  }
}

class OrganizationModel extends Organization {
  const OrganizationModel({
    super.publicUniversities = 0,
    super.privateUniversities = 0,
    super.colleges = 0,
    super.madrasas = 0,
    super.schools = 0,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      publicUniversities: json['publicUniversities'] ?? 0,
      privateUniversities: json['privateUniversities'] ?? 0,
      colleges: json['colleges'] ?? 0,
      madrasas: json['madrasas'] ?? 0,
      schools: json['schools'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'publicUniversities': publicUniversities,
      'privateUniversities': privateUniversities,
      'colleges': colleges,
      'madrasas': madrasas,
      'schools': schools,
    };
  }
}

class MeetingsModel extends Meetings {
  const MeetingsModel({
    super.responsibleMeetings = 0,
    super.memberMeetings = 0,
    super.generalMeetings = 0,
  });

  factory MeetingsModel.fromJson(Map<String, dynamic> json) {
    return MeetingsModel(
      responsibleMeetings: json['responsibleMeetings'] ?? 0,
      memberMeetings: json['memberMeetings'] ?? 0,
      generalMeetings: json['generalMeetings'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responsibleMeetings': responsibleMeetings,
      'memberMeetings': memberMeetings,
      'generalMeetings': generalMeetings,
    };
  }
}

class TrainingModel extends Training {
  const TrainingModel({
    super.skillsDevelopment = 0,
    super.workshops = 0,
    super.educationMeetings = 0,
  });

  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    return TrainingModel(
      skillsDevelopment: json['skillsDevelopment'] ?? 0,
      workshops: json['workshops'] ?? 0,
      educationMeetings: json['educationMeetings'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skillsDevelopment': skillsDevelopment,
      'workshops': workshops,
      'educationMeetings': educationMeetings,
    };
  }
}

class LibraryModel extends Library {
  const LibraryModel({
    super.totalBooks = 0,
    super.totalReaders = 0,
  });

  factory LibraryModel.fromJson(Map<String, dynamic> json) {
    return LibraryModel(
      totalBooks: json['totalBooks'] ?? 0,
      totalReaders: json['totalReaders'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBooks': totalBooks,
      'totalReaders': totalReaders,
    };
  }
}

class BaytulmalModel extends Baytulmal {
  const BaytulmalModel({
    super.totalIncome = 0.0,
    super.totalExpense = 0.0,
  });

  factory BaytulmalModel.fromJson(Map<String, dynamic> json) {
    return BaytulmalModel(
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      totalExpense: (json['totalExpense'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
    };
  }
}
