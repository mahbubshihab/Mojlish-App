import 'package:equatable/equatable.dart';

class PeriodReport extends Equatable {
  final String id;
  final String branch;
  final String month;
  final String session;
  final Manpower manpower;
  final Dawah dawah;
  final Organization organization;
  final Meetings meetings;
  final Training training;
  final Library library;
  final Baytulmal baytulmal;

  const PeriodReport({
    required this.id,
    required this.branch,
    required this.month,
    required this.session,
    required this.manpower,
    required this.dawah,
    required this.organization,
    required this.meetings,
    required this.training,
    required this.library,
    required this.baytulmal,
  });

  @override
  List<Object?> get props => [
        id,
        branch,
        month,
        session,
        manpower,
        dawah,
        organization,
        meetings,
        training,
        library,
        baytulmal,
      ];
}

class Manpower extends Equatable {
  final int members;
  final int candidateMembers;
  final int associateMembers;
  final int candidateAssociateMembers;
  final int workers;

  const Manpower({
    this.members = 0,
    this.candidateMembers = 0,
    this.associateMembers = 0,
    this.candidateAssociateMembers = 0,
    this.workers = 0,
  });

  @override
  List<Object?> get props => [
        members,
        candidateMembers,
        associateMembers,
        candidateAssociateMembers,
        workers,
      ];
}

class Dawah extends Equatable {
  final int primaryMembers;
  final int friends;
  final int wellWishers;

  const Dawah({
    this.primaryMembers = 0,
    this.friends = 0,
    this.wellWishers = 0,
  });

  @override
  List<Object?> get props => [
        primaryMembers,
        friends,
        wellWishers,
      ];
}

class Organization extends Equatable {
  final int publicUniversities;
  final int privateUniversities;
  final int colleges;
  final int madrasas;
  final int schools;

  const Organization({
    this.publicUniversities = 0,
    this.privateUniversities = 0,
    this.colleges = 0,
    this.madrasas = 0,
    this.schools = 0,
  });

  @override
  List<Object?> get props => [
        publicUniversities,
        privateUniversities,
        colleges,
        madrasas,
        schools,
      ];
}

class Meetings extends Equatable {
  final int responsibleMeetings;
  final int memberMeetings;
  final int generalMeetings;

  const Meetings({
    this.responsibleMeetings = 0,
    this.memberMeetings = 0,
    this.generalMeetings = 0,
  });

  @override
  List<Object?> get props => [
        responsibleMeetings,
        memberMeetings,
        generalMeetings,
      ];
}

class Training extends Equatable {
  final int skillsDevelopment;
  final int workshops;
  final int educationMeetings;

  const Training({
    this.skillsDevelopment = 0,
    this.workshops = 0,
    this.educationMeetings = 0,
  });

  @override
  List<Object?> get props => [
        skillsDevelopment,
        workshops,
        educationMeetings,
      ];
}

class Library extends Equatable {
  final int totalBooks;
  final int totalReaders;

  const Library({
    this.totalBooks = 0,
    this.totalReaders = 0,
  });

  @override
  List<Object?> get props => [totalBooks, totalReaders];
}

class Baytulmal extends Equatable {
  final double totalIncome;
  final double totalExpense;

  const Baytulmal({
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
  });

  @override
  List<Object?> get props => [totalIncome, totalExpense];
}
