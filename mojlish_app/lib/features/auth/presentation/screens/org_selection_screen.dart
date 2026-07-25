import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../dashboard/presentation/screens/main_dashboard_screen.dart';

class OrgSelectionScreen extends StatefulWidget {
  const OrgSelectionScreen({super.key});

  @override
  State<OrgSelectionScreen> createState() => _OrgSelectionScreenState();
}

class _OrgSelectionScreenState extends State<OrgSelectionScreen> {
  String? _selectedOrg;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;
        final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
        final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final subtextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade700;
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
                  Image.asset('assets/images/logo.png', height: 120),
                  const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    'খেলাফত মজলিস',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                      color: isDark ? Colors.white : AppTheme.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Subtitle
                  Text(
                    'খেলাফত প্রতিষ্ঠার লক্ষ্যে আন্দোলন গড়ে তুলুন।',
                    style: TextStyle(fontSize: 14, color: subtextColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
                  // Selection text
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'আপনার সংগঠন নির্বাচন করুন:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Grid Selection
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _buildOrgBtn('যুব সংগঠন', Icons.people, Colors.orange, isDark, cardBgColor),
                      _buildOrgBtn('ছাত্র সংগঠন', Icons.school, Colors.blue, isDark, cardBgColor),
                      _buildOrgBtn('মহিলা সংগঠন', Icons.woman, Colors.pink, isDark, cardBgColor),
                      _buildOrgBtn('শ্রমিক সংগঠন', Icons.engineering, Colors.amber.shade700, isDark, cardBgColor),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _selectedOrg != null
                          ? () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const MainDashboardScreen()),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        disabledBackgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'সংগঠন নিশ্চিত করুন',
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

  Widget _buildOrgBtn(String title, IconData icon, Color color, bool isDark, Color defaultCardBg) {
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? color : (isDark ? Colors.grey.shade200 : Colors.grey.shade800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
