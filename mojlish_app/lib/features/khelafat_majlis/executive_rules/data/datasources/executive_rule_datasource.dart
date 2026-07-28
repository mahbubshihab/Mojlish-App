import '../models/executive_rule_model.dart';

abstract class ExecutiveRuleDataSource {
  Future<List<ExecutiveRuleModel>> getExecutiveRules();
}

class ExecutiveRuleDataSourceImpl implements ExecutiveRuleDataSource {
  @override
  Future<List<ExecutiveRuleModel>> getExecutiveRules() async {
    // Return dummy data or fetch from API
    await Future.delayed(const Duration(seconds: 1));
    return [
      const ExecutiveRuleModel(
        id: '1',
        title: 'কর্মপ্রণালী - ১',
        content: 'খেলাফত মজলিস কর্মপ্রণালী বিস্তারিত...',
        imageUrl: 'assets/images/karjopronali/image.png',
      ),
      const ExecutiveRuleModel(
        id: '2',
        title: 'কর্মপ্রণালী - ২',
        content: 'বিস্তারিত...',
        imageUrl: 'assets/images/karjopronali/image_copy.png',
      ),
    ];
  }
}
