import '../models/overview_model.dart';

abstract class OverviewRemoteDataSource {
  Future<OverviewModel> getOverview();
}

class OverviewRemoteDataSourceImpl implements OverviewRemoteDataSource {
  @override
  Future<OverviewModel> getOverview() async {
    // Mock implementation for the feature
    await Future.delayed(const Duration(seconds: 1));
    return const OverviewModel(
      title: 'খেলাফত মজলিস',
      description: 'খেলাফত প্রতিষ্ঠার লক্ষ্যে গণ-আন্দোলন গড়ে তুলুন\nসংক্ষিপ্ত পরিচিতি',
      basicPrograms: [
        '১. দাওয়াত : ইসলামী জীবনব্যবস্থার ব্যাপক প্রচার-প্রসার...',
        '২. সংগঠন : আগ্রহী সর্বস্তরের জনগণকে খেলাফত মজলিসের আওতায় সংঘবদ্ধ করা।',
        '৩. প্রশিক্ষণ ও কর্মী গঠন : ...',
        '৪. সৎ ও আদর্শবান নেতৃত্ব : ...',
        '৫. ঐক্য : ...',
        '৬. মানব সেবা : ...',
        '৭. আন্দোলন ও সংগ্রাম : ...',
      ],
      membershipConditions: [
        '(১) প্রাথমিক সদস্য : যে কোনো ব্যক্তি খেলাফত মজলিসের আদর্শ, উদ্দেশ্য ও কর্মসূচির সাথে একমত হয়ে সংগঠনে যোগদান করলে...',
        '(২) কর্মী : যেসব প্রাথমিক সদস্য সাংগঠনিক কার্যক্রমে সক্রিয়ভাবে অংশগ্রহণ করবেন...',
      ],
    );
  }
}
