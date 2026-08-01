import 'package:flutter/material.dart';
import '../../../../common/widgets/custom_labeled_input_field.dart';

class BranchReportScreen extends StatefulWidget {
  const BranchReportScreen({Key? key}) : super(key: key);

  @override
  State<BranchReportScreen> createState() => _BranchReportScreenState();
}

class _BranchReportScreenState extends State<BranchReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('শাখার রিপোর্ট ফরম - খেলাফত মজলিস'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('জনশক্তি'),
            // TODO: Add form fields for Manpower
            _buildSectionHeader('দাওয়াত ও গণসংযোগ'),
            // TODO: Add form fields for Dawah
            _buildSectionHeader('সংগঠন'),
            // TODO: Add form fields for Organization
            _buildSectionHeader('সভাসমূহ'),
            // TODO: Add form fields for Meetings
            _buildSectionHeader('বায়তুলমাল'),
            // TODO: Add form fields for Baytulmal
            _buildSectionHeader('সফর'),
            // TODO: Add form fields for Tour
            _buildSectionHeader('প্রশিক্ষণ'),
            // TODO: Add form fields for Training
            _buildSectionHeader('দফতর'),
            // TODO: Add form fields for Office
            _buildSectionHeader('প্রচার'),
            // TODO: Add form fields for Publicity
            _buildSectionHeader('পাঠাগার'),
            // TODO: Add form fields for Library
            _buildSectionHeader('সমাজকল্যাণ'),
            // TODO: Add form fields for Social Welfare
            const SizedBox(height: 16),
            const CustomLabeledInputField(
              label: 'মন্তব্য (সমস্যা ও সম্ভাবনা উল্লেখসহ)',
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Dispatch SubmitBranchReportEvent
              },
              child: const Text('জমা দিন'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
