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
    String derivedDistrict = branchOrDistrict.trim();
    if (derivedDistrict.isEmpty) {
      if (permanentAddress.trim().isNotEmpty) {
        final parts = permanentAddress.split(',');
        derivedDistrict = parts.last.trim();
      } else if (presentAddress.trim().isNotEmpty) {
        final parts = presentAddress.split(',');
        derivedDistrict = parts.last.trim();
      }
    }
    if (derivedDistrict.isEmpty) {
      derivedDistrict = 'N/A';
    }

    final String resolvedAddress = presentAddress.trim().isNotEmpty
        ? presentAddress.trim()
        : permanentAddress.trim();

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
      'address': resolvedAddress,
      'permanentAddress': permanentAddress.trim(),
      'district': derivedDistrict,
      'branchName': branchOrDistrict.trim(),
      'status': 'সক্রিয়',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (additionalData != null && additionalData.isNotEmpty) {
      docData['additionalData'] = additionalData;
      if (additionalData.containsKey('facebook') && additionalData['facebook'] != null) {
        docData['facebook'] = additionalData['facebook'].toString().trim();
      }
      if (additionalData.containsKey('notes') && additionalData['notes'] != null) {
        docData['notes'] = additionalData['notes'].toString().trim();
      }
    }

    await _firestore.collection('member_applications').add(docData);
  }
}
