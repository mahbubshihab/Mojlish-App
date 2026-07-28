import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';

/// খেলাফত মজলিস শাখার পরিকল্পনা ফরম (১০টি বিভাগ)
class KhelafatShakhaPlanScreen extends StatefulWidget {
  const KhelafatShakhaPlanScreen({super.key});

  @override
  State<KhelafatShakhaPlanScreen> createState() => _KhelafatShakhaPlanScreenState();
}

class _KhelafatShakhaPlanScreenState extends State<KhelafatShakhaPlanScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Form Controllers
  final _branchCtrl = TextEditingController();
  final _monthCtrl = TextEditingController();

  // Section 1: Workforce targets
  final _sodossoCtrl = TextEditingController();
  final _sodossoPrarthiCtrl = TextEditingController();
  final _kormiCtrl = TextEditingController();
  final _prathomikCtrl = TextEditingController();

  // Section 4: Baytulmal Budget
  final _incomeCtrl = TextEditingController();
  final _expenseCtrl = TextEditingController();
  final _kotaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _branchCtrl.dispose();
    _monthCtrl.dispose();
    _sodossoCtrl.dispose();
    _sodossoPrarthiCtrl.dispose();
    _kormiCtrl.dispose();
    _prathomikCtrl.dispose();
    _incomeCtrl.dispose();
    _expenseCtrl.dispose();
    _kotaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;
        final bgColor = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
        final textColor = isDark ? Colors.white : AppTheme.textDark;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF162032) : Colors.white,
            elevation: 0,
            title: const Row(
              children: [
                Icon(Icons.assignment_rounded, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text('শাখার পরিকল্পনা ফরম', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppTheme.primaryColor,
              indicatorWeight: 3,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              tabs: const [
                Tab(text: '👥 জনশক্তি'),
                Tab(text: '📢 দাওয়াত ও সংগঠন'),
                Tab(text: '💰 বায়তুলমাল বাজেট'),
                Tab(text: '📖 প্রশিক্ষণ ও সভা'),
                Tab(text: '🤝 সমাজকল্যাণ ও দপ্তর'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildWorkforceTab(isDark, cardBg, textColor),
              _buildDawatTab(isDark, cardBg, textColor),
              _buildBaytulmalTab(isDark, cardBg, textColor),
              _buildTrainingTab(isDark, cardBg, textColor),
              _buildWelfareTab(isDark, cardBg, textColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWorkforceTab(bool isDark, Color cardBg, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('১. জনশক্তি বৃদ্ধি ও মানে উন্নীতকরণ পরিকল্পনা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryColor)),
                  const SizedBox(height: 12),
                  _buildInputRow('সদস্য (মানে উন্নীতকরণ টার্গেট)', _sodossoCtrl, isDark, textColor),
                  _buildInputRow('সদস্য প্রার্থী টার্গেট', _sodossoPrarthiCtrl, isDark, textColor),
                  _buildInputRow('কর্মী বৃদ্ধি টার্গেট', _kormiCtrl, isDark, textColor),
                  _buildInputRow('প্রাথমিক সদস্য বৃদ্ধি টার্গেট', _prathomikCtrl, isDark, textColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDawatTab(bool isDark, Color cardBg, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('২. দাওয়াত ও গণসংযোগ কর্মসূচি পরিকল্পনা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryColor)),
                  const SizedBox(height: 12),
                  _buildCheckItem('ব্যক্তিগত দাওয়াত দান কর্মসূচী'),
                  _buildCheckItem('গ্রুপ দাওয়াত ও দাওয়াতি সফর'),
                  _buildCheckItem('আলোচনা সভা / ওলামা সমাবেশ'),
                  _buildCheckItem('ওয়াজ / সিরাত মাহফিল'),
                  _buildCheckItem('পরিচিতি ও লিফলেট বিতরণ'),
                  _buildCheckItem('মিছিল / মানববন্ধন / জনসভা'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaytulmalTab(bool isDark, Color cardBg, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('৩. বায়তুলমাল বাজেট পরিকল্পনা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryColor)),
                  const SizedBox(height: 12),
                  _buildInputRow('ধার্যকৃত মোট আয় (টাকা)', _incomeCtrl, isDark, textColor),
                  _buildInputRow('ধার্যকৃত মোট ব্যয় (টাকা)', _expenseCtrl, isDark, textColor),
                  _buildInputRow('ঊর্ধ্বতন কোটা অংশ (টাকা)', _kotaCtrl, isDark, textColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingTab(bool isDark, Color cardBg, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('৪. প্রশিক্ষণ ও সভাসমূহ পরিকল্পনা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryColor)),
                  const SizedBox(height: 12),
                  _buildCheckItem('তরবিয়তী সভা ও তরবিয়তী সফর'),
                  _buildCheckItem('শবগুজারী ও সামষ্টিক পাঠ'),
                  _buildCheckItem('কুরআন-হাদিস শিক্ষা সভা'),
                  _buildCheckItem('জেলা/উপজেলা/থানা নির্বাহী সভা'),
                  _buildCheckItem('কর্মী সভা ও সমাবেশ'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelfareTab(bool isDark, Color cardBg, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('৫. সমাজকল্যাণ ও দপ্তর পরিকল্পনা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryColor)),
                  const SizedBox(height: 12),
                  _buildCheckItem('চিকিৎসা সেবা ও ফ্রি আই ক্যাম্প'),
                  _buildCheckItem('ত্রাণ তৎপরতা ও পুনর্বাসন সহায়তা'),
                  _buildCheckItem('কর্জে হাসানা বিতরণ'),
                  _buildCheckItem('সার্কুলার ও মিডিয়া বিজ্ঞপ্তি প্রচার'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow(String label, TextEditingController ctrl, bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        style: TextStyle(color: textColor, fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 12),
          filled: true,
          fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildCheckItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
