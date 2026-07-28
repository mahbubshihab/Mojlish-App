import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/services/user_storage_service.dart';
import '../../../dashboard/presentation/screens/main_dashboard_screen.dart';

class OrgSelectionScreen extends StatefulWidget {
  const OrgSelectionScreen({super.key});

  @override
  State<OrgSelectionScreen> createState() => _OrgSelectionScreenState();
}

class _OrgSelectionScreenState extends State<OrgSelectionScreen> {
  String? _selectedOrg;

  @override
  void initState() {
    super.initState();
    _loadSavedMajlis();
  }

  Future<void> _loadSavedMajlis() async {
    final saved = await UserStorageService.getSelectedMajlis();
    setState(() {
      _selectedOrg = saved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;
        final bgColor = isDark ? const Color(0xFF0B132B) : const Color(0xFFF1F5F9);
        final cardBgColor = isDark ? const Color(0xFF1C2541) : Colors.white;
        final subtextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF1C2541) : Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/logo.png', height: 28),
                const SizedBox(width: 10),
                Text(
                  'মজলিস নির্বাচন',
                  style: TextStyle(
                    color: isDark ? Colors.white : AppTheme.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: isDark ? Colors.amber : Colors.grey.shade700,
                ),
                tooltip: isDark ? 'লাইট থিম' : 'ডার্ক থিম',
                onPressed: () => themeManager.toggleTheme(),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 800;
              final contentWidth = isDesktop ? 1050.0 : constraints.maxWidth;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 32.0 : 20.0,
                            vertical: isDesktop ? 24.0 : 16.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Header Banner
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isDark
                                        ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                                        : [const Color(0xFFECFDF5), Colors.white],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF10B981).withOpacity(0.3) : const Color(0xFFA7F3D0),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'আপনার মজলিস নির্বাচন করুন',
                                      style: TextStyle(
                                        fontSize: isDesktop ? 22 : 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? const Color(0xFF34D399) : AppTheme.primaryDark,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'আপনার দায়িত্বে থাকা মজলিসটি সিলেক্ট করে ড্যাশবোর্ডে প্রবেশ করুন',
                                      style: TextStyle(fontSize: isDesktop ? 14 : 12, color: subtextColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Central & Surrounding 5-Majlis Layout
                              _buildMajlisLayout(isDark, cardBgColor, isDesktop),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      // Confirm Bar
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1C2541) : Colors.white,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
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
                                onPressed: _selectedOrg != null
                                    ? () async {
                                        await UserStorageService.saveSelectedMajlis(_selectedOrg!);
                                        if (mounted) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (_) => const MainDashboardScreen()),
                                          );
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  disabledBackgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  elevation: _selectedOrg != null ? 4 : 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _selectedOrg != null ? '$_selectedOrg নিয়ে এগিয়ে যান' : 'একটি মজলিস নির্বাচন করুন',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _selectedOrg != null
                                            ? Colors.white
                                            : (isDark ? Colors.grey.shade500 : Colors.grey.shade600),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: _selectedOrg != null
                                          ? Colors.white
                                          : (isDark ? Colors.grey.shade500 : Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMajlisLayout(bool isDark, Color cardBg, bool isDesktop) {
    if (isDesktop) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSatelliteMajlisCard(
                  title: 'যুব মজলিস',
                  subtitle: 'বাংলাদেশ ইসলামী যুব মজলিস',
                  icon: Icons.groups_rounded,
                  color: const Color(0xFFF59E0B),
                  isDark: isDark,
                  cardBg: cardBg,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCentralHeroCard(
                  title: 'খেলাফত মজলিস',
                  subtitle: 'কেন্দ্রীয় ও প্রধান মজলিস',
                  color: AppTheme.primaryColor,
                  isDark: isDark,
                  cardBg: cardBg,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSatelliteMajlisCard(
                  title: 'ছাত্র মজলিস',
                  subtitle: 'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                  icon: Icons.school_rounded,
                  color: const Color(0xFF3B82F6),
                  isDark: isDark,
                  cardBg: cardBg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSatelliteMajlisCard(
                  title: 'মহিলা মজলিস',
                  subtitle: 'ইসলামী মহিলা মজলিস',
                  icon: Icons.woman_rounded,
                  color: const Color(0xFFEC4899),
                  isDark: isDark,
                  cardBg: cardBg,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSatelliteMajlisCard(
                  title: 'শ্রমিক মজলিস',
                  subtitle: 'বাংলাদেশ ইসলামী শ্রমিক মজলিস',
                  icon: Icons.engineering_rounded,
                  color: const Color(0xFF10B981),
                  isDark: isDark,
                  cardBg: cardBg,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        // Top 2 Satellite Cards: যুব মজলিস & ছাত্র মজলিস
        Row(
          children: [
            Expanded(
              child: _buildSatelliteMajlisCard(
                title: 'যুব মজলিস',
                subtitle: 'বাংলাদেশ ইসলামী যুব মজলিস',
                icon: Icons.groups_rounded,
                color: const Color(0xFFF59E0B),
                isDark: isDark,
                cardBg: cardBg,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSatelliteMajlisCard(
                title: 'ছাত্র মজলিস',
                subtitle: 'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                icon: Icons.school_rounded,
                color: const Color(0xFF3B82F6),
                isDark: isDark,
                cardBg: cardBg,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Central Main Emblem: খেলাফত মজলিস
        _buildCentralHeroCard(
          title: 'খেলাফত মজলিস',
          subtitle: 'কেন্দ্রীয় ও প্রধান মজলিস',
          color: AppTheme.primaryColor,
          isDark: isDark,
          cardBg: cardBg,
        ),

        const SizedBox(height: 16),

        // Bottom 2 Satellite Cards: মহিলা মজলিস & শ্রমিক মজলিস
        Row(
          children: [
            Expanded(
              child: _buildSatelliteMajlisCard(
                title: 'মহিলা মজলিস',
                subtitle: 'ইসলামী মহিলা মজলিস',
                icon: Icons.woman_rounded,
                color: const Color(0xFFEC4899),
                isDark: isDark,
                cardBg: cardBg,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSatelliteMajlisCard(
                title: 'শ্রমিক মজলিস',
                subtitle: 'বাংলাদেশ ইসলামী শ্রমিক মজলিস',
                icon: Icons.engineering_rounded,
                color: const Color(0xFF10B981),
                isDark: isDark,
                cardBg: cardBg,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCentralHeroCard({
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
    required Color cardBg,
  }) {
    bool isSelected = _selectedOrg == title;

    return GestureDetector(
      onTap: () => setState(() => _selectedOrg = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(isDark ? 0.25 : 0.12)
              : cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(isDark ? 0.4 : 0.25),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/logo.png',
                height: 36,
                width: 36,
                errorBuilder: (_, __, ___) => Icon(Icons.star_rounded, color: color, size: 32),
              ),
            ),
            const SizedBox(width: 14),
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
                          color: isDark ? Colors.white : AppTheme.primaryDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'মূল দল',
                          style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? color : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                  width: 2,
                ),
              ),
              child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 18) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSatelliteMajlisCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
    required Color cardBg,
  }) {
    bool isSelected = _selectedOrg == title;

    return GestureDetector(
      onTap: () => setState(() => _selectedOrg = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(isDark ? 0.25 : 0.12)
              : cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(isDark ? 0.35 : 0.2),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? color : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? color : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                      width: 2,
                    ),
                  ),
                  child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 14) : null,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.primaryDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
