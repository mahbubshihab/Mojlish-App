import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../join/join_organization_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('পরিচিতি', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/images/logo.png', height: 100),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'খেলাফত মজলিস',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
              ),
            ),
            const SizedBox(height: 30),
            _buildSection(
              'ইতিহাস',
              'খেলাফত মজলিস ১৯৮৯ সালের ৮ ডিসেম্বর ঢাকার ইঞ্জিনিয়ার্স ইনস্টিটিউশন মিলনায়তনে আয়োজিত এক জাতীয় সম্মেলনের মাধ্যমে প্রতিষ্ঠিত হয়। তৎকালীন বাংলাদেশের আর্থ-সামাজিক ও রাজনৈতিক পরিস্থিতিতে একটি গণভিত্তিক ও সমন্বয়ধর্মী ইসলামী আন্দোলনের প্রয়োজনীয়তা থেকে এই দলের জন্ম। এটি শায়খুল হাদীস মাওলানা আজিজুল হকের নেতৃত্বাধীন খেলাফত আন্দোলন, অধ্যাপক ড. আহমদ আবদুল কাদেরের নেতৃত্বাধীন ইসলামী যুব শিবির, এবং অধ্যক্ষ মাসউদ খানের নেতৃত্বাধীন তমদ্দুন মজলিস ও ভাসানীর ন্যাপের একাংশের সমন্বয়ে গঠিত হয়।',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'লক্ষ্য ও উদ্দেশ্য',
              'খেলাফত মজলিসের মূল লক্ষ্য হলো ইসলামি আদর্শের ভিত্তিতে রাষ্ট্র ও সমাজব্যবস্থা পুনর্গঠন করা।\n\n১. ইসলামী শাসন প্রতিষ্ঠা: কুরআন, সুন্নাহ এবং খোলাফায়ে রাশেদীনের আদর্শের আলোকে প্রথমে বাংলাদেশে এবং পরবর্তীতে বিশ্বব্যাপী আল্লাহর খেলাফত প্রতিষ্ঠা করা।\n\n২. জনকল্যাণমূলক রাষ্ট্র: ন্যায়, ইনসাফ, সাম্য ও জনকল্যাণের ভিত্তিতে একটি জনপ্রতিনিধিত্বশীল রাষ্ট্র গড়ে তোলা।\n\n৩. পার্থিব ও পারলৌকিক মুক্তি: আল্লাহর সন্তুষ্টি লাভের উদ্দেশ্যে দ্বীনের প্রচার-প্রসার এবং মানুষের দুনিয়াবি কল্যাণ ও আখেরাতের মুক্তির পথ প্রশস্ত করা।',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'মৌল কর্মনীতি ও কার্যক্রম',
              'দলটি তাদের লক্ষ্য অর্জনে বিভিন্ন সাংগঠনিক ও দাওয়াতি কার্যক্রম পরিচালনা করে, যার মধ্যে রয়েছে দাওয়াত, সংগঠন তৈরি, সাধারণ মানুষকে ঐক্যবদ্ধ করা এবং আদর্শিক, নৈতিক ও কর্মদক্ষ নেতৃত্ব প্রতিষ্ঠা করা।',
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: 220,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const JoinOrganizationScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.group_add, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'সংগঠনে যুক্ত হোন',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
        ),
      ],
    );
  }
}
