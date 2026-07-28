import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import '../../data/models/khelafat_karjopronali_data.dart';

/// খেলাফত মজলিস কর্মপ্রণালী নির্দেশিকা রিডার স্ক্রিন
class KhelafatKarjopronaliScreen extends StatefulWidget {
  const KhelafatKarjopronaliScreen({super.key});

  @override
  State<KhelafatKarjopronaliScreen> createState() => _KhelafatKarjopronaliScreenState();
}

class _KhelafatKarjopronaliScreenState extends State<KhelafatKarjopronaliScreen> {
  double _fontSize = 14.0;

  IconData _getIconData(String name) {
    switch (name) {
      case 'campaign':
        return Icons.campaign_rounded;
      case 'groups':
        return Icons.groups_rounded;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet_rounded;
      case 'school':
        return Icons.school_rounded;
      case 'public':
        return Icons.public_rounded;
      default:
        return Icons.menu_book_rounded;
    }
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
                Icon(Icons.menu_book_rounded, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  'কর্মপ্রণালী নির্দেশিকা',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.zoom_in_rounded),
                onPressed: () => setState(() => _fontSize = (_fontSize < 20) ? _fontSize + 1 : _fontSize),
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out_rounded),
                onPressed: () => setState(() => _fontSize = (_fontSize > 12) ? _fontSize - 1 : _fontSize),
              ),
              IconButton(
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                onPressed: () => themeManager.toggleTheme(),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        KhelafatKarjopronaliData.mainTitle,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        KhelafatKarjopronaliData.organizationName,
                        style: const TextStyle(fontSize: 15, color: Color(0xFFCCFBF1), fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        KhelafatKarjopronaliData.subtitle,
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                ...KhelafatKarjopronaliData.sections.map(
                  (section) => Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.04), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D9488).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(_getIconData(section.iconName), color: const Color(0xFF0D9488)),
                        ),
                        title: Text(
                          section.title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        children: [
                          const Divider(height: 12),
                          ...section.bulletPoints.map(
                            (bp) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D9488))),
                                  Expanded(
                                    child: Text(
                                      bp,
                                      style: TextStyle(fontSize: _fontSize, height: 1.6, color: textColor),
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

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
