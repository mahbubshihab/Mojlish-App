import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/services/user_storage_service.dart';
import 'package:mojlish_app/core/services/auth_service.dart';
import '../../../dashboard/presentation/screens/main_dashboard_screen.dart';

class OrgSelectionScreen extends StatefulWidget {
  const OrgSelectionScreen({super.key});

  @override
  State<OrgSelectionScreen> createState() => _OrgSelectionScreenState();
}

class _OrgSelectionScreenState extends State<OrgSelectionScreen> {
  String? _selectedOrg;
  String? _hoveredOrg;
  String _userName = '';
  final AuthService _authService = AuthService();

  final List<Map<String, dynamic>> _majlisItems = [
    {
      'title': 'খেলাফত মজলিস',
      'subtitle': 'কেন্দ্রীয় ও প্রধান মজলিস পরিচালনা সংস্থা',
      'tag': 'মূল দল',
      'icon': Icons.account_balance_rounded,
      'color': const Color(0xFF059669),
      'isHero': true,
    },
    {
      'title': 'ছাত্র মজলিস',
      'subtitle': 'বাংলাদেশ ইসলামী ছাত্র মজলিস',
      'tag': 'অঙ্গ সংগঠন',
      'icon': Icons.school_rounded,
      'color': const Color(0xFF2563EB),
      'isHero': false,
    },
    {
      'title': 'যুব মজলিস',
      'subtitle': 'বাংলাদেশ ইসলামী যুব মজলিস',
      'tag': 'অঙ্গ সংগঠন',
      'icon': Icons.groups_rounded,
      'color': const Color(0xFFD97706),
      'isHero': false,
    },
    {
      'title': 'মহিলা মজলিস',
      'subtitle': 'ইসলামী মহিলা মজলিস শাখা',
      'tag': 'অঙ্গ সংগঠন',
      'icon': Icons.woman_rounded,
      'color': const Color(0xFFDB2777),
      'isHero': false,
    },
    {
      'title': 'শ্রমিক মজলিস',
      'subtitle': 'বাংলাদেশ ইসলামী শ্রমিক মজলিস',
      'tag': 'অঙ্গ সংগঠন',
      'icon': Icons.engineering_rounded,
      'color': const Color(0xFF0D9488),
      'isHero': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final savedMajlis = await UserStorageService.getActiveMajlis();
    final savedName = await UserStorageService.getUserName();
    final googleUser = FirebaseAuth.instance.currentUser;

    setState(() {
      _selectedOrg = savedMajlis ?? 'খেলাফত মজলিস';
      _userName = savedName.isNotEmpty
          ? savedName
          : (googleUser?.displayName ?? 'সম্মানিত সদস্য');
    });
  }

  Future<void> _handleProceed() async {
    final majlis = _selectedOrg ?? 'খেলাফত মজলিস';
    await _authService.updateActiveMajlis(majlis);
    themeManager.setMajlisTheme(majlis);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainDashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;

        final scaffoldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
        final navBg = isDark ? const Color(0xFF1E293B) : Colors.white;
        final borderNav = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
        final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textTitle = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
        final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

        final currentSelected = _selectedOrg ?? 'খেলাফত মজলিস';

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: Container(
              decoration: BoxDecoration(
                color: navBg,
                border: Border(bottom: BorderSide(color: borderNav, width: 1)),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: Main.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/election_symbol_wall_clock.png',
                            height: 32,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.stars_rounded,
                              color: Color(0xFF059669),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'মজলিস পোর্টাল',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: textTitle,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                              color: textMuted,
                            ),
                            onPressed: () => themeManager.toggleTheme(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 850),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logged In User Greeting Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF059669).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF059669),
                              child: Text(
                                _userName.isNotEmpty ? _userName[0] : 'আ',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'স্বাগতম, $_userName!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: textTitle,
                                    ),
                                  ),
                                  Text(
                                    'আপনার সক্রিয় মজলিস নির্বাচন করুন',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title Header
                      Text(
                        'সংগঠন ও শাখা নির্বাচন করুন',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: textTitle,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'অ্যাপ্লিকেশন ড্যাশবোর্ডে প্রবেশ করতে আপনার কাঙ্ক্ষিত মজলিস সিলেক্ট করুন।',
                        style: TextStyle(
                          fontSize: 14,
                          color: textMuted,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Majlis Cards Options
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _majlisItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final item = _majlisItems[index];
                          final title = item['title'] as String;
                          final subtitle = item['subtitle'] as String;
                          final tag = item['tag'] as String;
                          final icon = item['icon'] as IconData;
                          final color = item['color'] as Color;
                          final isSelected = currentSelected == title;

                          return InkWell(
                            onTap: () => setState(() => _selectedOrg = title),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: isSelected ? color.withValues(alpha: 0.08) : cardBg,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? color : borderNav,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(icon, color: color, size: 28),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              title,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: textTitle,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: color.withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                tag,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: color,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          subtitle,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Radio<String>(
                                    value: title,
                                    groupValue: currentSelected,
                                    activeColor: color,
                                    onChanged: (val) {
                                      if (val != null) setState(() => _selectedOrg = val);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // Proceed Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _handleProceed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                          ),
                          child: const Row(
                            mainAxisAlignment: Main.center,
                            children: [
                              Text(
                                'ড্যাশবোর্ডে প্রবেশ করুন',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
