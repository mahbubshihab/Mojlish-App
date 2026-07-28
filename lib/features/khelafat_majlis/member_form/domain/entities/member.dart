import 'package:equatable/equatable.dart';

class KhelafatMajlisMember extends Equatable {
  final String? id;
  final String name;
  final String fatherName;
  final String educationalQualification;
  final String age;
  final String profession;
  final String presentAddress;
  final String mobile;
  final String permanentAddress;
  final DateTime date;

  const KhelafatMajlisMember({
    this.id,
    required this.name,
    required this.fatherName,
    required this.educationalQualification,
    required this.age,
    required this.profession,
    required this.presentAddress,
    required this.mobile,
    required this.permanentAddress,
    required this.date,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        fatherName,
        educationalQualification,
        age,
        profession,
        presentAddress,
        mobile,
        permanentAddress,
        date,
      ];
}
