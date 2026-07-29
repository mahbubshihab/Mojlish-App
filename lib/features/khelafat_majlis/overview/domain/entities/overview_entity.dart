import 'package:equatable/equatable.dart';

class BasicProgramItem extends Equatable {
  final int number;
  final String title;
  final String description;

  const BasicProgramItem({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [number, title, description];
}

class MembershipInfo extends Equatable {
  final String primaryMember;
  final String workerMember;
  final List<String> conditions;

  const MembershipInfo({
    required this.primaryMember,
    required this.workerMember,
    required this.conditions,
  });

  @override
  List<Object?> get props => [primaryMember, workerMember, conditions];
}

class StructureInfo extends Equatable {
  final List<String> levels;
  final String ameer;
  final String advisoryCouncil;
  final String generalAssembly;
  final String shura;
  final String executiveCouncil;

  const StructureInfo({
    required this.levels,
    required this.ameer,
    required this.advisoryCouncil,
    required this.generalAssembly,
    required this.shura,
    required this.executiveCouncil,
  });

  @override
  List<Object?> get props => [
        levels,
        ameer,
        advisoryCouncil,
        generalAssembly,
        shura,
        executiveCouncil,
      ];
}

class BaytulmalInfo extends Equatable {
  final String description;

  const BaytulmalInfo({required this.description});

  @override
  List<Object?> get props => [description];
}

class PoliticalCommitmentItem extends Equatable {
  final int number;
  final String title;
  final String description;

  const PoliticalCommitmentItem({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [number, title, description];
}

class CallToActionInfo extends Equatable {
  final String title;
  final String description;
  final String officeAddress;
  final String phone;
  final String web;
  final String email;
  final String price;
  final String regNo;

  const CallToActionInfo({
    required this.title,
    required this.description,
    required this.officeAddress,
    required this.phone,
    required this.web,
    required this.email,
    required this.price,
    required this.regNo,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        officeAddress,
        phone,
        web,
        email,
        price,
        regNo,
      ];
}

class OverviewEntity extends Equatable {
  final String title;
  final String subtitle;
  final String bismillah;
  final List<String> introductionParagraphs;
  final String organizationalGoal;
  final List<BasicProgramItem> basicPrograms;
  final MembershipInfo membershipInfo;
  final StructureInfo structureInfo;
  final BaytulmalInfo baytulmalInfo;
  final List<String> implementationPrinciples;
  final List<PoliticalCommitmentItem> politicalCommitments;
  final CallToActionInfo callToAction;

  const OverviewEntity({
    required this.title,
    required this.subtitle,
    required this.bismillah,
    required this.introductionParagraphs,
    required this.organizationalGoal,
    required this.basicPrograms,
    required this.membershipInfo,
    required this.structureInfo,
    required this.baytulmalInfo,
    required this.implementationPrinciples,
    required this.politicalCommitments,
    required this.callToAction,
  });

  @override
  List<Object?> get props => [
        title,
        subtitle,
        bismillah,
        introductionParagraphs,
        organizationalGoal,
        basicPrograms,
        membershipInfo,
        structureInfo,
        baytulmalInfo,
        implementationPrinciples,
        politicalCommitments,
        callToAction,
      ];
}
