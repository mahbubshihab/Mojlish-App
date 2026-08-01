import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/features/khelafat_majlis/syllabi/khelafot_syllabus/presentation/pages/khelafot_syllabus_page.dart';

class BookItem {
  final String id;
  final String title;
  final String author;
  final String category;
  final String description;
  final String pages;
  final IconData icon;
  final Color coverColor;
  final Widget? targetScreen;

  BookItem({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.description,
    required this.pages,
    required this.icon,
    required this.coverColor,
    this.targetScreen,
  });
}

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  String _selectedCategory = 'সব বই';
  String _searchQuery = '';

  final List<String> _categories = [
    'সব বই',
    'সিলেবাস ও পাঠ্যক্রম',
    'সাংগঠনিক সাহিত্য',
    'ইসলামী দাওয়াত',
    'নীতিমালা ও নির্দেশিকা',
  ];

  late final List<BookItem> _books = [
    BookItem(
      id: '1',
      title: 'খেলাফত মজলিস পরিচিতি ও কর্মসূচি',
      author: 'কেন্দ্রীয় প্রচার ও প্রকাশনা বিভাগ',
      category: 'সাংগঠনিক সাহিত্য',
      description: 'খেলাফত মজলিসের লক্ষ্য, উদ্দেশ্য, ৫ দফা কর্মসূচি ও সাংগঠনিক কাঠামোর পূর্ণাঙ্গ পরিচিতি বই।',
      pages: '৪৮ পৃষ্ঠা',
      icon: Icons.menu_book_rounded,
      coverColor: const Color(0xFF059669),
    ),
    BookItem(
      id: '2',
      title: 'দাওয়াত ও তরবিয়াত গাইড ও সিলেবাস',
      author: 'কেন্দ্রীয় তরবিয়াত পরিষদ',
      category: 'সিলেবাস ও পাঠ্যক্রম',
      description: 'কর্মী ও রুকনদের অধ্যয়ন পাঠ্যক্রম, সিলেবাস এবং আত্মগঠনের নিয়মিত দিকনির্দেশনা।',
      pages: '১১২ পৃষ্ঠা',
      icon: Icons.auto_stories_rounded,
      coverColor: const Color(0xFF2563EB),
      targetScreen: const KhelafotSyllabusPage(),
    ),
    BookItem(
      id: '3',
      title: 'খেলাফত মজলিস গঠনতন্ত্র ও পরিচালনা বিধি',
      author: 'কেন্দ্রীয় নির্বাহী পরিষদ',
      category: 'নীতিমালা ও নির্দেশিকা',
      description: 'সংগঠনের শাখা পরিচালনা, বায়তুলমাল ও সদস্য পদের প্রশাসনিক নিয়মাবলী।',
      pages: '৬৪ পৃষ্ঠা',
      icon: Icons.gavel_rounded,
      coverColor: const Color(0xFFD97706),
    ),
    BookItem(
      id: '4',
      title: 'খেলাফত ব্যবস্থা ও আধুনিক বিশ্ব',
      author: 'চিন্তাবিদ ও গবেষণা পরিষদ',
      category: 'ইসলামী দাওয়াত',
      description: 'ইসলামী রাষ্ট্রব্যবস্থার সৌন্দর্য এবং বিশ্বশান্তিতে খেলাফতের তাৎপর্য শীর্ষক বই।',
      pages: '১৬০ পৃষ্ঠা',
      icon: Icons.public_rounded,
      coverColor: const Color(0xFF7C3AED),
    ),
    BookItem(
      id: '5',
      title: 'বাংলাদেশ ইসলামী ছাত্র মজলিস পরিচিতি',
      author: 'ছাত্র মজলিস প্রকাশনা',
      category: 'সাংগঠনিক সাহিত্য',
      description: 'ছাত্রসমাজের আত্মগঠন ও বিপ্লবপ্রীতি প্রতিষ্ঠার জন্য ছাত্র মজলিসের রূপরেখা।',
      pages: '৪০ পৃষ্ঠা',
      icon: Icons.school_rounded,
      coverColor: const Color(0xFF0284C7),
    ),
    BookItem(
      id: '6',
      title: 'বায়তুলমাল নির্দেশিকা ও হিসাব সংরক্ষণ',
      author: 'কেন্দ্রীয় বায়তুলমাল বিভাগ',
      category: 'নীতিমালা ও নির্দেশিকা',
      description: 'আমদানি, খরচ, ইয়ানত সংগ্রহ এবং শাখা বায়তুলমালের সঠিক হিসাব রাখার নির্দেশিকা।',
      pages: '৩২ পৃষ্ঠা',
      icon: Icons.account_balance_wallet_rounded,
      coverColor: const Color(0xFF0D9488),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textTitle = isDark ? Colors.white : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    final filteredBooks = _books.where((b) {
      final matchesCategory = _selectedCategory == 'সব বই' || b.category == _selectedCategory;
      final matchesSearch = b.title.contains(_searchQuery) || b.author.contains(_searchQuery) || b.description.contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          'বই ও প্রকাশনাসমূহ',
          style: TextStyle(
            color: textTitle,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: cardBg,
        elevation: 0,
        iconTheme: IconThemeData(color: textTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: borderColor, height: 1.0),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Header Container
          Container(
            padding: const EdgeInsets.all(16),
            color: cardBg,
            child: Column(
              children: [
                // Search Input Box
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  style: TextStyle(color: textTitle, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'বইয়ের নাম বা বিষয় দিয়ে খুঁজুন...',
                    hintStyle: TextStyle(color: textMuted, fontSize: 13),
                    prefixIcon: Icon(Icons.search_rounded, color: textMuted),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Category Chips
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, idx) {
                      final cat = _categories[idx];
                      final isSelected = cat == _selectedCategory;
                      return ChoiceChip(
                        label: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF059669),
                        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedCategory = cat);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Books List View
          Expanded(
            child: filteredBooks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 54, color: textMuted),
                        const SizedBox(height: 12),
                        Text(
                          'কোনো বই পাওয়া যায়নি',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textTitle),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _openBookDetails(context, book, isDark, textTitle, textMuted),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Book Cover Thumbnail Badge
                                Container(
                                  width: 64,
                                  height: 84,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        book.coverColor,
                                        book.coverColor.withValues(alpha: 0.75),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: book.coverColor.withValues(alpha: 0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      book.icon,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Book Info Column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Category Tag
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: book.coverColor.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          book.category,
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: book.coverColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),

                                      // Book Title
                                      Text(
                                        book.title,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: textTitle,
                                          height: 1.25,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),

                                      // Author / Publisher
                                      Text(
                                        book.author,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // Pages & Action Button Row
                                      Row(
                                        children: [
                                          Icon(Icons.menu_book, size: 14, color: textMuted),
                                          const SizedBox(width: 4),
                                          Text(
                                            book.pages,
                                            style: TextStyle(fontSize: 11.5, color: textMuted),
                                          ),
                                          const Spacer(),
                                          Text(
                                            'পড়ুন →',
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.bold,
                                              color: book.coverColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _openBookDetails(
    BuildContext context,
    BookItem book,
    bool isDark,
    Color textTitle,
    Color textMuted,
  ) {
    if (book.targetScreen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => book.targetScreen!));
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 90,
                    decoration: BoxDecoration(
                      color: book.coverColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(book.icon, color: Colors.white, size: 36),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: textTitle,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          book.author,
                          style: TextStyle(fontSize: 13, color: textMuted),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'ক্যাটাগরি: ${book.category} • ${book.pages}',
                          style: TextStyle(fontSize: 11.5, color: book.coverColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                'বইয়ের বিবরণ:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textTitle),
              ),
              const SizedBox(height: 6),
              Text(
                book.description,
                style: TextStyle(fontSize: 13, color: textMuted, height: 1.4),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${book.title} খোলা হচ্ছে...'),
                        backgroundColor: book.coverColor,
                      ),
                    );
                  },
                  icon: const Icon(Icons.menu_book_rounded, color: Colors.white),
                  label: const Text(
                    'বইটি অনলাইনে পড়ুন',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: book.coverColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
