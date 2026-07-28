import 'package:equatable/equatable.dart';

class MemberFormEntity extends Equatable {
  final String? id;
  final String name;
  final String fatherName;
  final String nidNumber;
  final String village;
  final String unionName;
  final String thanaUpazila;
  final String district;
  final String presentAddress;
  final String mobile;
  final String? email;
  final DateTime joinDate;
  final String? signatureUrl;

  const MemberFormEntity({
    this.id,
    required this.name,
    required this.fatherName,
    required this.nidNumber,
    required this.village,
    required this.unionName,
    required this.thanaUpazila,
    required this.district,
    required this.presentAddress,
    required this.mobile,
    this.email,
    required this.joinDate,
    this.signatureUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        fatherName,
        nidNumber,
        village,
        unionName,
        thanaUpazila,
        district,
        presentAddress,
        mobile,
        email,
        joinDate,
        signatureUrl,
      ];
}
