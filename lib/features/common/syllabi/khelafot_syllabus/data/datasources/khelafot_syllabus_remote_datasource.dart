import '../models/khelafot_syllabus_model.dart';

abstract class KhelafotSyllabusRemoteDataSource {
  Future<List<KhelafotSyllabusModel>> getSyllabi();
}

class KhelafotSyllabusRemoteDataSourceImpl implements KhelafotSyllabusRemoteDataSource {
  @override
  Future<List<KhelafotSyllabusModel>> getSyllabi() async {
    // Return dummy data for now
    return [
      const KhelafotSyllabusModel(
        id: '1',
        title: 'প্রথম স্তর (কর্মীদের জন্য)',
        description: 'ঈমান ও আক্বীদা',
      ),
    ];
  }
}
