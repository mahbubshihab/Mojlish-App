import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/services/user_storage_service.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import '../../../dashboard/presentation/screens/main_dashboard_screen.dart';

class OrgSelectionScreen extends StatefulWidget {
  const OrgSelectionScreen({super.key});

  @override
  State<OrgSelectionScreen> createState() => _OrgSelectionScreenState();
}

class _OrgSelectionScreenState extends State<OrgSelectionScreen> {
  String? _selectedOrg;
  String? _hoveredOrg;
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  bool _isEditingName = false;

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
      'title': 'যুব মজলিস',
      'subtitle': 'বাংলাদেশ ইসলামী যুব মজলিস',
      'tag': 'অঙ্গ সংগঠন',
      'icon': Icons.groups_rounded,
      'color': const Color(0xFFD97706),
      'isHero': false,
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

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    final savedMajlis = await UserStorageService.getSelectedMajlis();
    final savedName = await UserStorageService.getUserName();
    setState(() {
      _selectedOrg = savedMajlis;
      _nameController.text = savedName;
      _isEditingName = savedName.isEmpty;
    });
  }

  Future<void> _handleProceed() async {
    final majlis = _selectedOrg ?? 'খেলাফত মজলিস';
    final name = _nameController.text.trim();
    final finalName = name.isEmpty ? 'মিজানুর রহমান' : name;

    await UserStorageService.saveSelectedMajlis(majlis);
    await UserStorageService.saveUserName(finalName);

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

        // Modern Slate & Clean Android Color Palette
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 32,
                            errorBuilder: (_, _, _) => const Icon(Icons.stars_rounded, color: Color(0xFF059669), size: 32),
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
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF059669).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'v2.0',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => themeManager.toggleTheme(),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: borderNav),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                                size: 16,
                                color: isDark ? Colors.amber : const Color(0xFF475569),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isDark ? 'লাইটিং' : 'ডার্ক',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF334155),
                                ),
                              ),
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
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              final isTablet = constraints.maxWidth > 600 && constraints.maxWidth <= 900;

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 40.0 : (isTablet ? 24.0 : 16.0),
                        vertical: isDesktop ? 28.0 : 16.0,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Hero Header Banner
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(isDesktop ? 28.0 : 20.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isDark
                                        ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                                        : [const Color(0xFFECFDF5), Colors.white],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF059669).withOpacity(0.3) : const Color(0xFFA7F3D0),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF059669).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: const Color(0xFF059669).withOpacity(0.4)),
                                          ),
                                          child: const Row(
                                            children: [
                                              Icon(Icons.stars_rounded, color: Color(0xFF059669), size: 14),
                                              SizedBox(width: 6),
                                              Text(
                                                'অফিসিয়াল প্যানেল',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF059669),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'আপনার তথ্য ও মজলিস নির্বাচন করুন',
                                      style: TextStyle(
                                        fontSize: isDesktop ? 26 : 20,
                                        fontWeight: FontWeight.w900,
                                        color: textTitle,
                                        letterSpacing: -0.3,
                                      ),
                                      textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'আপনার নাম সংসংোধন বা নিশ্চিত করুন এবং নির্দিষ্ট মজলিসটি নির্বাচন করে আপনার কেন্দ্রীয় ড্যাশবোর্ডে প্রবেশ করুন।',
                                      style: TextStyle(
                                        fontSize: isDesktop ? 14 : 12,
                                        color: textMuted,
                                        height: 1.5,
                                      ),
                                      textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // User Name Onboarding Card
                              _buildNameCard(isDark, cardBg, borderNav, textTitle, textMuted),

                              const SizedBox(height: 24),

                              // Section Header
                              Row(
                                children: [
                                  const Icon(Icons.apps_rounded, size: 20, color: Color(0xFF059669)),
                                  const SizedBox(width: 8),
                                  Text(
                                    'সংগঠন নির্বাচন করুন',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: textTitle,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Organization Cards List (Exact 1 to 5 Order)
                              _buildResponsiveGrid(isDark, cardBg, textTitle, textMuted, isDesktop, isTablet),

                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom Action Bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      color: navBg,
                      border: Border(top: BorderSide(color: borderNav, width: 1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: isDesktop ? 500 : double.infinity),
                        child: SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _handleProceed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF059669),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 6,
                              shadowColor: const Color(0xFF059669).withOpacity(0.4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$currentSelected নিয়ে এগিয়ে যান',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNameCard(
    bool isDark,
    Color cardBg,
    Color borderNav,
    Color textTitle,
    Color textMuted,
  ) {
    const primaryColor = Color(0xFF059669);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isEditingName
              ? primaryColor
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          width: _isEditingName ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.person_outline_rounded, color: primaryColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'ব্যবহারকারীর নাম',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              if (!_isEditingName)
                InkWell(
                  onTap: () {
                    setState(() {
                      _isEditingName = true;
                    });
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _nameFocusNode.requestFocus();
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 14, color: primaryColor),
                        SizedBox(width: 4),
                        Text(
                          'সম্পাদনা',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_isEditingName)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textTitle,
                    ),
                    decoration: InputDecoration(
                      hintText: 'আপনার নাম লিখুন',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: textMuted,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: borderNav),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: borderNav),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                    onSubmitted: (_) {
                      setState(() {
                        _isEditingName = false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isEditingName = false;
                      });
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.check_rounded, color: Colors.white, size: 22),
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _nameController.text.trim().isEmpty ? 'মিজানুর রহমান' : _nameController.text.trim(),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: textTitle,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditingName = true;
                    });
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _nameFocusNode.requestFocus();
                    });
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                  tooltip: 'নাম পরিবর্তন করুন',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildResponsiveGrid(
    bool isDark,
    Color cardBg,
    Color textTitle,
    Color textMuted,
    bool isDesktop,
    bool isTablet,
  ) {
    int crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);
    double aspectRatio = isDesktop ? 1.75 : (isTablet ? 1.8 : 2.5);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _majlisItems.length,
      itemBuilder: (context, index) {
        final item = _majlisItems[index];
        final title = item['title'] as String;
        final subtitle = item['subtitle'] as String;
        final tag = item['tag'] as String;
        final icon = item['icon'] as IconData;
        final color = item['color'] as Color;
        final isHero = item['isHero'] as bool;
        final isSelected = (_selectedOrg ?? 'খেলাফত মজলিস') == title;
        final isHovered = _hoveredOrg == title;

        return MouseRegion(
          onEnter: (_) => setState(() => _hoveredOrg = title),
          onExit: (_) => setState(() => _hoveredOrg = null),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () => setState(() => _selectedOrg = title),
              borderRadius: BorderRadius.circular(20),
              splashColor: color.withOpacity(0.15),
              highlightColor: color.withOpacity(0.08),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withOpacity(isDark ? 0.22 : 0.08)
                      : (isHovered ? (isDark ? const Color(0xFF26334D) : const Color(0xFFF1F5F9)) : cardBg),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? color
                        : (isHovered ? color.withOpacity(0.5) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
                    width: isSelected ? 2.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withOpacity(isDark ? 0.35 : 0.18),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: MajlisAssets.getLogoWidget(title, size: 26),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? color : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? color : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                              width: 2,
                            ),
                          ),
                          child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 15) : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: textTitle,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: textMuted,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
