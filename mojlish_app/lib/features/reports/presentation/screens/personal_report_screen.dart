import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PersonalReportScreen extends StatefulWidget {
  const PersonalReportScreen({super.key});

  @override
  State<PersonalReportScreen> createState() => _PersonalReportScreenState();
}

class _PersonalReportScreenState extends State<PersonalReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ব্যক্তিগত রিপোর্ট')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('প্রাথমিক তথ্য'),
            _buildTextField('নাম', 'আপনার নাম লিখুন'),
            _buildTextField('শাখার নাম', 'শাখার নাম'),
            _buildTextField('মাস', 'যেমন: জুলাই ২০২৬'),
            
            const SizedBox(height: 24),
            _buildSectionHeader('ব্যক্তিগত আমল'),
            _buildNumberField('জামায়াতে নামাজ (ওয়াক্ত)'),
            _buildNumberField('কুরআন তেলাওয়াত (দিন)'),
            _buildNumberField('হাদিস অধ্যয়ন (দিন)'),
            _buildNumberField('ইসলামী সাহিত্য অধ্যয়ন (বই সংখ্যা)'),
            
            const SizedBox(height: 24),
            _buildSectionHeader('সাংগঠনিক তৎপরতা'),
            _buildNumberField('দাওয়াত প্রদান (জন)'),
            _buildNumberField('সমর্থক বৃদ্ধি (জন)'),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('রিপোর্ট সেভ করা হয়েছে')));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('রিপোর্ট জমা দিন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildNumberField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: '০',
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
