import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/features/syllabi/khelafot_syllabus/data/models/khelafot_syllabus_data.dart';

/// খেলাফত মজলিস সিলেবাস রিডার ও ট্র্যাকার স্ক্রিন
class KhelafatSyllabusScreen extends StatefulWidget {
  const KhelafatSyllabusScreen({super.key});

  @override
  State<KhelafatSyllabusScreen> createState() => _KhelafatSyllabusScreenState();
}

class _KhelafatSyllabusScreenState extends State<KhelafatSyllabusScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  Set<String> _readBookKeys = {};

  static const String _readBooksPrefKey = 'khelafat_read_books';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadReadBooks();
  }

  Future<void> _loadReadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_readBooksPrefKey) ?? [];
    setState(() {
      _readBookKeys = list.toSet();
    });
  }

  Future<void> _toggleBookRead(String bookKey) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_readBookKeys.contains(bookKey)) {
        _readBookKeys.remove(bookKey);
      } else {
        _readBookKeys.add(bookKey);
      }
    });
    await prefs.setStringList(_readBooksPrefKey, _readBookKeys.toList());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'security':
      case 'verified_user':
        return Icons.verified_user_rounded;
      case 'menu_book':
        return Icons.menu_book_rounded;
      case 'auto_stories':
        return Icons.auto_stories_rounded;
      case 'volunteer_activism':
      case 'self_improvement':
        return Icons.volunteer_activism_rounded;
      case 'flag':
        return Icons.flag_rounded;
      case 'groups':
        return Icons.groups_rounded;
      case 'gavel':
        return Icons.gavel_rounded;
      case 'account_balance':
        return Icons.account_balance_rounded;
      case 'psychology':
        return Icons.psychology_rounded;
      case 'history_edu':
        return Icons.history_edu_rounded;
      case 'public':
        return Icons.public_rounded;
      default:
        return Icons.book_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;
        final bgColor = isDark ? const Color(0xFF0B132B) : const Color(0xFFF8FAFC);
        final cardBg = isDark ? const Color(0xFF1C2541) : Colors.white;
        final textColor = isDark ? Colors.white : AppTheme.textDark;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF1C2541) : Colors.white,
            elevation: 0,
            title: const Row(
              children: [
                Icon(Icons.menu_book_rounded, color: AppTheme.primaryColor),
                SizedBox(width: 10),
                Text(
                  'খেলাফত মজলিস সিলেবাস',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline_rounded),
                tooltip: 'সিলেবাস তথ্য ও ভূমিকা',
                onPressed: () => _showPublisherInfoDialog(context, isDark),
              ),
              IconButton(
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                onPressed: () => themeManager.toggleTheme(),
              ),
              const SizedBox(width: 8),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.primaryColor,
              indicatorWeight: 3,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(text: '১ম স্তর (কর্মী)'),
                Tab(text: '২য় স্তর (সদস্য)'),
                Tab(text: 'উচ্চতর স্তর'),
              ],
            ),
          ),
          body: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                  style: TextStyle(color: textColor, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'বিষয়, বই বা লেখকের নাম অনুসন্ধান করুন...',
                    hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade500, fontSize: 13),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryColor),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? const Color(0xFF161F38) : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                    ),
                  ),
                ),
              ),

              // Tab View for 3 Levels
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: List.generate(3, (index) {
                    final level = KhelafatSyllabusData.levels[index];
                    return _buildLevelView(level, isDark, cardBg, textColor);
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLevelView(SyllabusLevel level, bool isDark, Color cardBg, Color textColor) {
    // Filter subjects if search query present
    final filteredSubjects = level.subjects.where((sub) {
      if (_searchQuery.isEmpty) return true;
      final titleMatch = sub.title.toLowerCase().contains(_searchQuery);
      final topicMatch = sub.topics.any((t) => t.toLowerCase().contains(_searchQuery));
      final textbookMatch = sub.textbooks.any((b) => b.title.toLowerCase().contains(_searchQuery) || b.author.toLowerCase().contains(_searchQuery));
      final refMatch = sub.referenceBooks.any((b) => b.title.toLowerCase().contains(_searchQuery) || b.author.toLowerCase().contains(_searchQuery));
      return titleMatch || topicMatch || textbookMatch || refMatch;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Target Audience Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars_rounded, color: AppTheme.primaryColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${level.title} — ${level.subtitle}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        level.targetAudience,
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (filteredSubjects.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'কোনো বিষয় বা বই পাওয়া যায়নি',
                  style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredSubjects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final subject = filteredSubjects[index];
                return _buildSubjectCard(subject, isDark, cardBg, textColor);
              },
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(SyllabusSubject subject, bool isDark, Color cardBg, Color textColor) {
    final iconData = _getIconData(subject.iconName);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _searchQuery.isNotEmpty,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: AppTheme.primaryColor, size: 24),
          ),
          title: Text(
            subject.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
          ),
          subtitle: Text(
            '${subject.topics.length}টি পাঠ্য বিষয় • ${subject.textbooks.length}টি পাঠ্য পুস্তক',
            style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            const Divider(height: 16),

            // Topics Section
            if (subject.topics.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.bookmark_outline_rounded, size: 18, color: AppTheme.primaryColor),
                  const SizedBox(width: 6),
                  Text(
                    'পাঠ্য বিষয়সমূহ:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? const Color(0xFF6EE7B7) : AppTheme.primaryDark),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...subject.topics.map(
                (topic) => Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                      Expanded(
                        child: Text(
                          topic,
                          style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade200 : Colors.grey.shade800),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Textbooks Section
            if (subject.textbooks.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.menu_book_rounded, size: 18, color: Colors.blue),
                  const SizedBox(width: 6),
                  Text(
                    'পাঠ্য পুস্তক (অনাবশ্যিক পঠনীয়):',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.blue.shade300 : Colors.blue.shade800),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...subject.textbooks.map((book) => _buildBookRow(book, subject.id, isDark)),
              const SizedBox(height: 14),
            ],

            // Reference Books Section
            if (subject.referenceBooks.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.library_books_rounded, size: 18, color: Colors.purple),
                  const SizedBox(width: 6),
                  Text(
                    'সহায়ক পুস্তক:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.purple.shade300 : Colors.purple.shade800),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...subject.referenceBooks.map((book) => _buildBookRow(book, subject.id, isDark)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookRow(SyllabusBook book, String subjectId, bool isDark) {
    final bookKey = '${subjectId}_${book.title}';
    final isRead = _readBookKeys.contains(bookKey);

    return InkWell(
      onTap: () => _toggleBookRead(bookKey),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          children: [
            Checkbox(
              value: isRead,
              onChanged: (_) => _toggleBookRead(bookKey),
              activeColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: isRead ? TextDecoration.lineThrough : null,
                      color: isRead
                          ? (isDark ? Colors.grey.shade500 : Colors.grey.shade400)
                          : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                  Text(
                    'লেখক: ${book.author}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isRead)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'পঠিত',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showPublisherInfoDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1C2541) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.info_rounded, color: AppTheme.primaryColor),
              SizedBox(width: 10),
              Text('সিলেবাস পরিচিতি ও ভূমিকা'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  KhelafatSyllabusData.introTitle,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  KhelafatSyllabusData.introText,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade300 : Colors.grey.shade800),
                ),
                const Divider(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    KhelafatSyllabusData.publisherInfo,
                    style: TextStyle(fontSize: 12, height: 1.5, color: isDark ? const Color(0xFF6EE7B7) : AppTheme.primaryDark),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('বন্ধ করুন', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
