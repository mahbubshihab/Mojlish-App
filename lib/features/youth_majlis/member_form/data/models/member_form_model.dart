import 'package:mojlish_app/features/youth_majlis/member_form/domain/entities/member_form_entity.dart';

class MemberFormModel extends MemberFormEntity {
  const MemberFormModel({
    super.id,
    required super.name,
    required super.fatherName,
    required super.nidNumber,
    required super.village,
    required super.unionName,
    required super.thanaUpazila,
    required super.district,
    required super.presentAddress,
    required super.mobile,
    super.email,
    required super.joinDate,
    super.signatureUrl,
  });

  factory MemberFormModel.fromJson(Map<String, dynamic> json) {
    return MemberFormModel(
      id: json['id'],
      name: json['name'],
      fatherName: json['fatherName'],
      nidNumber: json['nidNumber'],
      village: json['village'],
      unionName: json['unionName'],
      thanaUpazila: json['thanaUpazila'],
      district: json['district'],
      presentAddress: json['presentAddress'],
      mobile: json['mobile'],
      email: json['email'],
      joinDate: DateTime.parse(json['joinDate']),
      signatureUrl: json['signatureUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'fatherName': fatherName,
      'nidNumber': nidNumber,
      'village': village,
      'unionName': unionName,
      'thanaUpazila': thanaUpazila,
      'district': district,
      'presentAddress': presentAddress,
      'mobile': mobile,
      if (email != null) 'email': email,
      'joinDate': joinDate.toIso8601String(),
      if (signatureUrl != null) 'signatureUrl': signatureUrl,
    };
  }
}
