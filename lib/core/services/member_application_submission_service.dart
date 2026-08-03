import 'package:cloud_firestore/cloud_firestore.dart';

class MemberApplicationSubmissionService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Submit any Majlis member application form to Firestore 'member_applications' collection
  static Future<void> submitApplication({
    required String majlis,
    required String name,
    required String mobile,
    String fatherName = '',
    String educationalQualification = '',
    String age = '',
    String profession = '',
    String presentAddress = '',
    String permanentAddress = '',
    String branchOrDistrict = '',
    Map<String, dynamic>? additionalData,
  }) async {
    final Map<String, dynamic> docData = {
      'majlis': majlis,
      'name': name.trim(),
      'fullName': name.trim(),
      'phone': mobile.trim(),
      'mobile': mobile.trim(),
      'fatherName': fatherName.trim(),
      'education': educationalQualification.trim(),
      'educationalQualification': educationalQualification.trim(),
      'age': age.trim(),
      'profession': profession.trim(),
      'occupation': profession.trim(),
      'presentAddress': presentAddress.trim(),
      'address': presentAddress.trim(),
      'permanentAddress': permanentAddress.trim(),
      'district': branchOrDistrict.trim().isNotEmpty ? branchOrDistrict.trim() : 'N/A',
      'branchName': branchOrDistrict.trim(),
      'status': 'সক্রিয়',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (additionalData != null && additionalData.isNotEmpty) {
      docData['additionalData'] = additionalData;
    }

    await _firestore.collection('member_applications').add(docData);
  }
}
