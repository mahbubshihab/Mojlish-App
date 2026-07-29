import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import '../../data/models/executive_rules_data.dart';

class KhelafatExecutiveRulesScreen extends StatefulWidget {
  const KhelafatExecutiveRulesScreen({super.key});

  @override
  State<KhelafatExecutiveRulesScreen> createState() =>
      _KhelafatExecutiveRulesScreenState();
}

class _KhelafatExecutiveRulesScreenState
    extends State<KhelafatExecutiveRulesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _chipScrollController = ScrollController();

  String _selectedCategory = 'সবগুলো';
  final Map<String, bool> _expandedSections = {};

  final List<String> _categories = [
    'সবগুলো',
    'ভূমিকা',
    '৭-দফা',
    'দাওয়াত',
    'সংগঠন',
    'প্রশিক্ষণ',
    'অধিকার',
    'পরিশিষ্ট',
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < ExecutiveRulesRepositoryData.sections.length; i++) {
      _expandedSections[ExecutiveRulesRepositoryData.sections[i].id] = i < 2;
    }
  }

  void _onCategorySelected(String category, int index) {
    setState(() {
      _selectedCategory = category;
    });
    if (_chipScrollController.hasClients) {
      final targetOffset = (index * 75.0).clamp(
        0.0,
        _chipScrollController.position.maxScrollExtent,
      );
      _chipScrollController.jumpTo(targetOffset);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _chipScrollController.dispose();
    super.dispose();
  }

  List<ExecutiveRuleSection> get _filteredSections {
    return ExecutiveRulesRepositoryData.sections.where((section) {
      return _selectedCategory == 'সবগুলো' || section.category == _selectedCategory;
    }).toList();
  }

  void _showDocumentInfoModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF162032) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final textColor = isDark ? Colors.white : AppTheme.textDark;
        final subColor = isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.book_outlined,
                      color: Color(0xFF059669),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ExecutiveRulesRepositoryData.documentTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        'প্রকাশনায়: ${ExecutiveRulesRepositoryData.publisher}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF059669),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.history_edu_rounded, 'প্রকাশনা ইতিহাস:',
                  '১ম: ${ExecutiveRulesRepositoryData.firstEdition} | ২য়: ${ExecutiveRulesRepositoryData.secondEdition}\n৩য়: ${ExecutiveRulesRepositoryData.thirdEdition} | ৪র্থ: ${ExecutiveRulesRepositoryData.fourthEdition}',
                  textColor, subColor),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.location_on_outlined, 'কেন্দ্রীয় কার্যালয়:',
                  ExecutiveRulesRepositoryData.officeAddress, textColor, subColor),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.phone_outlined, 'ফোন:',
                  ExecutiveRulesRepositoryData.phone, textColor, subColor),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.email_outlined, 'ই-মেইল:',
                  ExecutiveRulesRepositoryData.email, textColor, subColor),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.language_outlined, 'ওয়েবসাইট:',
                  ExecutiveRulesRepositoryData.website, textColor, subColor),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      Color textColor, Color subColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF059669)),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 13, color: textColor, height: 1.4),
              children: [
                TextSpan(
                  text: '$label ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value, style: TextStyle(color: subColor)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;
        final bgColor =
            isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
        final borderColor =
            isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);
        final textColor = isDark ? Colors.white : AppTheme.textDark;
        final subTextColor =
            isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600;

        final sections = _filteredSections;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF162032) : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: isDark ? Colors.white : Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Row(
              children: [
                Icon(Icons.gavel_rounded, color: Color(0xFF059669)),
                SizedBox(width: 8),
                Text(
                  'কার্যপ্রণালী নির্দেশিকা',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline_rounded,
                    color: Color(0xFF059669)),
                tooltip: 'প্রকাশনা তথ্য',
                onPressed: () => _showDocumentInfoModal(context, isDark),
              ),
            ],
          ),
          body: Column(
            children: [
              // Filter Chips Container
              Container(
                color: isDark ? const Color(0xFF162032) : Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: SizedBox(
                  height: 36,
                  child: ListView.separated(
                    controller: _chipScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return ChoiceChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                    ? const Color(0xFFCBD5E1)
                                    : const Color(0xFF475569)),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF059669),
                        backgroundColor: isDark
                            ? const Color(0xFF0D1B2A)
                            : const Color(0xFFF1F5F9),
                        onSelected: (selected) {
                          if (selected) {
                            _onCategorySelected(category, index);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),

              const Divider(height: 1),

              // Main List
              Expanded(
                child: sections.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_rounded,
                                size: 54, color: subTextColor),
                            const SizedBox(height: 12),
                            Text(
                              'কোন তথ্য খুঁজে পাওয়া যায়নি',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'অন্য কোনো শব্দ বা ফিল্টার ব্যবহার করে চেষ্টা করুন',
                              style:
                                  TextStyle(fontSize: 12, color: subTextColor),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16.0),
                        itemCount: sections.length + 1,
                        itemBuilder: (context, index) {
                          if (index == sections.length) {
                            return _buildFooterCard(
                                context, isDark, cardBg, borderColor, textColor);
                          }

                          final section = sections[index];
                          final isExpanded =
                              _expandedSections[section.id] ?? false;

                          return _buildSectionCard(
                            context,
                            section: section,
                            isExpanded: isExpanded,
                            isDark: isDark,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            textColor: textColor,
                            subTextColor: subTextColor,
                            onToggle: () {
                              setState(() {
                                _expandedSections[section.id] = !isExpanded;
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.small(
            backgroundColor: const Color(0xFF059669),
            child: const Icon(Icons.keyboard_arrow_up_rounded,
                color: Colors.white),
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required ExecutiveRuleSection section,
    required bool isExpanded,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color subTextColor,
    required VoidCallback onToggle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded
              ? const Color(0xFF059669).withValues(alpha: 0.5)
              : borderColor,
          width: isExpanded ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Tile
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Icon badge
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(section.icon,
                        color: const Color(0xFF059669), size: 24),
                  ),
                  const SizedBox(width: 14),

                  // Title & Badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF059669).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                section.sectionNumber,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF059669),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${section.items.length}টি অংশ',
                              style: TextStyle(
                                fontSize: 11,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          section.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Expand Icon
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF059669),
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (section.description.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0D1B2A)
                            : const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFF059669).withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              size: 18, color: Color(0xFF059669)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              section.description,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: isDark
                                    ? const Color(0xFFA7F3D0)
                                    : const Color(0xFF065F46),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Items List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: section.items.length,
                    separatorBuilder: (context, i) => const SizedBox(height: 16),
                    itemBuilder: (context, i) {
                      final item = section.items[i];
                      return _buildItemWidget(
                        context,
                        item: item,
                        isDark: isDark,
                        textColor: textColor,
                        subTextColor: subTextColor,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemWidget(
    BuildContext context, {
    required ExecutiveRuleItem item,
    required bool isDark,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 16, color: Color(0xFF059669)),
                tooltip: 'কপি করুন',
                onPressed: () {
                  final textToCopy =
                      '${item.title}\n\n${item.content}\n${item.bulletPoints.join('\n')}';
                  Clipboard.setData(ClipboardData(text: textToCopy));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('নিয়মটি ক্লিপবোর্ডে কপি হয়েছে'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          if (item.content.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              item.content,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: textColor.withValues(alpha: 0.9),
              ),
            ),
          ],

          // Quote Card (Quran Verse or Hadith)
          if (item.quote != null && item.quote!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2B2111)
                    : const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.format_quote_rounded,
                      color: Color(0xFFD97706), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.quote!,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                        color: isDark
                            ? const Color(0xFFFDE68A)
                            : const Color(0xFF92400E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Bullet Points List
          if (item.bulletPoints.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...item.bulletPoints.map(
              (bp) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6.0, right: 8.0),
                      child: CircleAvatar(
                        radius: 3,
                        backgroundColor: Color(0xFF059669),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        bp,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: textColor.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooterCard(BuildContext context, bool isDark, Color cardBg,
      Color borderColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0, bottom: 24.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF059669),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.account_balance_rounded,
              color: Colors.white, size: 36),
          const SizedBox(height: 8),
          const Text(
            'খেলাফত মজলিসকে জানতে হলে পড়ুন',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Chip(
                  label: Text('সংক্ষিপ্ত পরিচিতি', style: TextStyle(fontSize: 11))),
              Chip(label: Text('গঠনতন্ত্র', style: TextStyle(fontSize: 11))),
              Chip(label: Text('মজলিস সংবাদ', style: TextStyle(fontSize: 11))),
              Chip(label: Text('ঘোষণাপত্র', style: TextStyle(fontSize: 11))),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'www.khelafat-majlis.org',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA7F3D0),
            ),
          ),
        ],
      ),
    );
  }
}
