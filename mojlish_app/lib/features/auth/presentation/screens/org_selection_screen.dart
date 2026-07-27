import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../../core/services/user_storage_service.dart';
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
        final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
        final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final subtextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
        final labelColor = isDark ? Colors.grey.shade200 : AppTheme.textDark;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            elevation: 0,
            title: Text(
              'মজলিস অ্যাপ',
              style: TextStyle(
                color: isDark ? AppTheme.primaryColor : AppTheme.primaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: isDark ? Colors.amber : Colors.grey.shade700,
                ),
                tooltip: isDark ? 'লাইট থিম' : 'ডার্ক থিম',
                onPressed: () => themeManager.toggleTheme(),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset('assets/images/logo.png', height: 100),
                  const SizedBox(height: 12),
                  
                  // Title
                  Text(
                    'খেলাফত মজলিস',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 26,
                      color: isDark ? Colors.white : AppTheme.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  
                  // Subtitle
                  Text(
                    'খেলাফত প্রতিষ্ঠার লক্ষ্যে আন্দোলন গড়ে তুলুন।',
                    style: TextStyle(fontSize: 13, color: subtextColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  
                  // Selection text
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'আপনার মজলিস নির্বাচন করুন:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Central & Surrounding 5-Majlis Layout
                  _buildMajlisLayout(isDark, cardBgColor),
                  
                  const SizedBox(height: 32),
                  
                  // Confirm Button
                  SizedBox(
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: _selectedOrg != null ? 3 : 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'মজলিস নিশ্চিত করুন',
                            style: TextStyle(
                              fontSize: 18,
                              color: _selectedOrg != null
                                  ? Colors.white
                                  : (isDark ? Colors.grey.shade500 : Colors.grey.shade600),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: _selectedOrg != null
                                ? Colors.white
                                : (isDark ? Colors.grey.shade500 : Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMajlisLayout(bool isDark, Color defaultCardBg) {
    return Column(
      children: [
        // Top 2 Satellite Cards: যুব মজলিস & ছাত্র মজলিস
        Row(
          children: [
            Expanded(child: _buildSatelliteMajlisCard('যুব মজলিস', Icons.groups, Colors.orange, isDark, defaultCardBg)),
            const SizedBox(width: 12),
            Expanded(child: _buildSatelliteMajlisCard('ছাত্র মজলিস', Icons.school, Colors.blue, isDark, defaultCardBg)),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Central Hero Circle for খেলাফত মজলিস (মাঝখানে প্রধান মজলিস)
        _buildCentralMajlisCircle(
          title: 'খেলাফত মজলিস',
          subtitle: 'প্রধান মজলিস',
          color: AppTheme.primaryColor,
          isDark: isDark,
          defaultCardBg: defaultCardBg,
        ),
        
        const SizedBox(height: 16),
        
        // Bottom 2 Satellite Cards: মহিলা মজলিস & শ্রমিক মজলিস
        Row(
          children: [
            Expanded(child: _buildSatelliteMajlisCard('মহিলা মজলিস', Icons.woman, Colors.pink, isDark, defaultCardBg)),
            const SizedBox(width: 12),
            Expanded(child: _buildSatelliteMajlisCard('শ্রমিক মজলিস', Icons.engineering, Colors.amber.shade700, isDark, defaultCardBg)),
          ],
        ),
      ],
    );
  }

  Widget _buildCentralMajlisCircle({
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
    required Color defaultCardBg,
  }) {
    bool isSelected = _selectedOrg == title;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOrg = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(isDark ? 0.25 : 0.12)
              : defaultCardBg,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? color : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(isDark ? 0.4 : 0.25),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Center circular icon badge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(isSelected ? 0.2 : 0.1),
                border: Border.all(color: color, width: 1.5),
              ),
              child: Image.asset('assets/images/logo.png', height: 32, width: 32),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isSelected ? color : (isDark ? Colors.white : AppTheme.primaryDark),
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Icon(Icons.check_circle, color: color, size: 20),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFF34D399) : AppTheme.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSatelliteMajlisCard(
    String title,
    IconData icon,
    Color color,
    bool isDark,
    Color defaultCardBg,
  ) {
    bool isSelected = _selectedOrg == title;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOrg = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(isDark ? 0.25 : 0.1)
              : defaultCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(isSelected ? 0.2 : (isDark ? 0.15 : 0.08)),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? color : (isDark ? color.withOpacity(0.8) : color),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isSelected
                          ? color
                          : (isDark ? Colors.grey.shade200 : Colors.grey.shade800),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.check_circle, color: color, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}
