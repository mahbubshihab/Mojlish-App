import '../../domain/entities/member_form_entity.dart';

class MemberFormModel extends MemberFormEntity {
  const MemberFormModel({
    required super.name,
    required super.fatherName,
    required super.educationalInstitution,
    required super.bloodGroup,
    required super.studentClass,
    required super.department,
    required super.rollNo,
    required super.presentAddress,
    required super.mobile,
    required super.permanentVillage,
    required super.permanentPostOffice,
    required super.permanentThana,
    required super.permanentDistrict,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'father_name': fatherName,
      'educational_institution': educationalInstitution,
      'blood_group': bloodGroup,
      'student_class': studentClass,
      'department': department,
      'roll_no': rollNo,
      'present_address': presentAddress,
      'mobile': mobile,
      'permanent_village': permanentVillage,
      'permanent_post_office': permanentPostOffice,
      'permanent_thana': permanentThana,
      'permanent_district': permanentDistrict,
    };
  }

  factory MemberFormModel.fromJson(Map<String, dynamic> json) {
    return MemberFormModel(
      name: json['name'] ?? '',
      fatherName: json['father_name'] ?? '',
      educationalInstitution: json['educational_institution'] ?? '',
      bloodGroup: json['blood_group'] ?? '',
      studentClass: json['student_class'] ?? '',
      department: json['department'] ?? '',
      rollNo: json['roll_no'] ?? '',
      presentAddress: json['present_address'] ?? '',
      mobile: json['mobile'] ?? '',
      permanentVillage: json['permanent_village'] ?? '',
      permanentPostOffice: json['permanent_post_office'] ?? '',
      permanentThana: json['permanent_thana'] ?? '',
      permanentDistrict: json['permanent_district'] ?? '',
    );
  }
}
