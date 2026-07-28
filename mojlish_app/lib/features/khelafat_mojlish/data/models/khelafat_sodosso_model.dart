/// খেলাফত মজলিস প্রাথমিক সদস্য ফরম ডেটা মডেল
class KhelafatSodossoModel {
  final String id;
  final String name;
  final String fatherName;
  final String educationalQualification;
  final int age;
  final String occupation;
  final String presentAddress;
  final String mobileNo;
  final String permanentAddress;
  final String applicationDate;
  final bool acceptedPledge;

  const KhelafatSodossoModel({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.educationalQualification,
    required this.age,
    required this.occupation,
    required this.presentAddress,
    required this.mobileNo,
    required this.permanentAddress,
    required this.applicationDate,
    required this.acceptedPledge,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'fatherName': fatherName,
        'educationalQualification': educationalQualification,
        'age': age,
        'occupation': occupation,
        'presentAddress': presentAddress,
        'mobileNo': mobileNo,
        'permanentAddress': permanentAddress,
        'applicationDate': applicationDate,
        'acceptedPledge': acceptedPledge,
      };

  factory KhelafatSodossoModel.fromJson(Map<String, dynamic> json) => KhelafatSodossoModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        fatherName: json['fatherName'] ?? '',
        educationalQualification: json['educationalQualification'] ?? '',
        age: json['age'] ?? 0,
        occupation: json['occupation'] ?? '',
        presentAddress: json['presentAddress'] ?? '',
        mobileNo: json['mobileNo'] ?? '',
        permanentAddress: json['permanentAddress'] ?? '',
        applicationDate: json['applicationDate'] ?? '',
        acceptedPledge: json['acceptedPledge'] ?? false,
      );

  static const String officialPledgeText =
      "আমি বিশ্বাস করি যে কুরআন, সুন্নাহ ও খেলাফতে রাশেদার অনুসরণের মধ্যেই ইহকালীন কল্যাণ ও পরকালীন মুক্তি নিহিত। এ দেশে খেলাফত প্রতিষ্ঠার লক্ষ্যে খেলাফত মজলিসের গৃহীত কর্মসূচীর সাথে একমত হয়ে একমাত্র আল্লাহর সন্তুষ্টির জন্যই এ সংগঠনে যোগদান করছি। আমি এর যাবতীয় কর্মতৎপরতায় সম্ভাব্য সহযোগিতা করতে সচেষ্ট থাকবো, ইনশাআল্লাহ।";
}
