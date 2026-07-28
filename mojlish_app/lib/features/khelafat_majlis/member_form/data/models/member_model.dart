import '../../domain/entities/member.dart';

class KhelafatMajlisMemberModel extends KhelafatMajlisMember {
  const KhelafatMajlisMemberModel({
    super.id,
    required super.name,
    required super.fatherName,
    required super.educationalQualification,
    required super.age,
    required super.profession,
    required super.presentAddress,
    required super.mobile,
    required super.permanentAddress,
    required super.date,
  });

  factory KhelafatMajlisMemberModel.fromJson(Map<String, dynamic> json) {
    return KhelafatMajlisMemberModel(
      id: json['id'],
      name: json['name'],
      fatherName: json['fatherName'],
      educationalQualification: json['educationalQualification'],
      age: json['age'],
      profession: json['profession'],
      presentAddress: json['presentAddress'],
      mobile: json['mobile'],
      permanentAddress: json['permanentAddress'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fatherName': fatherName,
      'educationalQualification': educationalQualification,
      'age': age,
      'profession': profession,
      'presentAddress': presentAddress,
      'mobile': mobile,
      'permanentAddress': permanentAddress,
      'date': date.toIso8601String(),
    };
  }
}
