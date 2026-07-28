import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import '../../data/models/khelafat_porichiti_data.dart';

/// খেলাফত মজলিস সংক্ষিপ্ত পরিচিতি স্ক্রিন
class KhelafatPorichitiScreen extends StatefulWidget {
  const KhelafatPorichitiScreen({super.key});

  @override
  State<KhelafatPorichitiScreen> createState() => _KhelafatPorichitiScreenState();
}

class _KhelafatPorichitiScreenState extends State<KhelafatPorichitiScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
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
                Icon(Icons.info_outline_rounded, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  'সংক্ষিপ্ত পরিচিতি — খেলাফত মজলিস',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                onPressed: () => themeManager.toggleTheme(),
              ),
              const SizedBox(width: 8),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppTheme.primaryColor,
              indicatorWeight: 3,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(text: '📜 পরিচিতি ও লক্ষ্য'),
                Tab(text: '🎯 ৭-দফা কর্মসূচি'),
                Tab(text: '👥 সদস্যপদ ও স্তর'),
                Tab(text: '🏛️ ১৭-দফা জাতীয় নীতি'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildIntroTab(isDark, cardBg, textColor),
              _buildProgramTab(isDark, cardBg, textColor),
              _buildMembershipTab(isDark, cardBg, textColor),
              _buildPolicyTab(isDark, cardBg, textColor),
            ],
          ),
        );
      },
    );
  }

  // 1. Intro Tab
  Widget _buildIntroTab(bool isDark, Color cardBg, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF047857)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.account_balance_rounded, size: 44, color: Colors.white),
                const SizedBox(height: 10),
                const Text(
                  KhelafatPorichitiData.organizationName,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text(
                  KhelafatPorichitiData.subtitle,
                  style: TextStyle(fontSize: 14, color: Color(0xFFA7F3D0), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'প্রতিষ্ঠা: ${KhelafatPorichitiData.establishmentDate}',
                    style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Goal Box
          Card(
            color: isDark ? const Color(0xFF063A2F) : const Color(0xFFDCFCE7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppTheme.primaryColor, width: 1.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.flag_rounded, color: AppTheme.primaryColor),
                      SizedBox(width: 8),
                      Text(
                        KhelafatPorichitiData.goalTitle,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    KhelafatPorichitiData.goalText,
                    style: TextStyle(fontSize: 14, height: 1.5, color: isDark ? const Color(0xFFA7F3D0) : AppTheme.primaryDark),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Intro Full Text
          Card(
            color: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    KhelafatPorichitiData.introTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    KhelafatPorichitiData.introText,
                    style: TextStyle(fontSize: 14, height: 1.7, color: textColor),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 2. Program Tab
  Widget _buildProgramTab(bool isDark, Color cardBg, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'মৌলিক ৭-দফা কর্মসূচি:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 14),

          ...KhelafatPorichitiData.basic7Points.map(
            (point) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.04), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Text(
                point,
                style: TextStyle(fontSize: 14, height: 1.6, color: textColor),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 3. Membership Tab
  Widget _buildMembershipTab(bool isDark, Color cardBg, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
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
                  const Text(
                    '১. প্রাথমিক সদস্য (Primary Member)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    KhelafatPorichitiData.primaryMemberDesc,
                    style: TextStyle(fontSize: 13, height: 1.5, color: textColor),
                  ),
                  const Divider(height: 20),
                  const Text(
                    '২. কর্মী (Worker)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    KhelafatPorichitiData.workerDesc,
                    style: TextStyle(fontSize: 13, height: 1.5, color: textColor),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Full Member Requirements
          const Text(
            '৩. সদস্য পদ লাভের শর্তাবলী (Full Member Criteria):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 10),

          ...KhelafatPorichitiData.fullMemberCriteria.map(
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                color: cardBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    c,
                    style: TextStyle(fontSize: 13, height: 1.5, color: textColor),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Organizational Hierarchy
          const Text(
            'সাংগঠনিক স্তরবিন্যাস (Structure):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 10),
          ...KhelafatPorichitiData.organizationalLevels.map(
            (level) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_tree_rounded, color: AppTheme.primaryColor, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    level,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 4. Policy Tab (17 National Policies)
  Widget _buildPolicyTab(bool isDark, Color cardBg, Color textColor) {
    final filteredPolicies = KhelafatPorichitiData.nationalPolicies.where((p) {
      if (_searchQuery.isEmpty) return true;
      return p.title.toLowerCase().contains(_searchQuery) || p.description.toLowerCase().contains(_searchQuery);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
          TextField(
            controller: _searchCtrl,
            onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: InputDecoration(
              hintText: '১৭-দফা সামাজিক নীতি অনুসন্ধান করুন...',
              hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade500, fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryColor),
              filled: true,
              fillColor: cardBg,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
              ),
            ),
          ),

          const SizedBox(height: 16),

          ...filteredPolicies.map(
            (policy) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${policy.number}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          policy.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          policy.description,
                          style: TextStyle(fontSize: 13, height: 1.5, color: textColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
