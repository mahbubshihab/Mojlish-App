import '../models/overview_model.dart';

abstract class OverviewRemoteDataSource {
  Future<OverviewModel> getOverview();
}

class OverviewRemoteDataSourceImpl implements OverviewRemoteDataSource {
  @override
  Future<OverviewModel> getOverview() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return const OverviewModel(
      title: 'ইসলামী যুব মজলিস পরিচিতি',
      content: 'আল্লাহ তাআলার সন্তুষ্টি অর্জনের লক্ষ্যে যুবকদের আত্মিক মানোন্নয়ন, মেধার বিকাশ ও দক্ষতা বৃদ্ধি এবং রাজনৈতিক সচেতনতা সৃষ্টির মাধ্যমে যুবসমাজকে ঐক্যবদ্ধ করে কল্যাণমুখী সমাজব্যবস্থা গড়ে তোলা।',
    );
  }
}
