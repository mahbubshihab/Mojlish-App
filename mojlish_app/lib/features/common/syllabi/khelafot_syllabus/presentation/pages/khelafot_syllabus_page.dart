import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/khelafot_syllabus_bloc.dart';
import '../bloc/khelafot_syllabus_event.dart';
import '../bloc/khelafot_syllabus_state.dart';
import '../../data/datasources/khelafot_syllabus_remote_datasource.dart';
import '../../data/repositories/khelafot_syllabus_repository_impl.dart';
import '../../domain/entities/khelafot_syllabus_entity.dart';

class KhelafotSyllabusPage extends StatelessWidget {
  const KhelafotSyllabusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KhelafotSyllabusBloc>(
      create: (context) {
        final dataSource = KhelafotSyllabusRemoteDataSourceImpl();
        final repo = KhelafotSyllabusRepositoryImpl(remoteDataSource: dataSource);
        return KhelafotSyllabusBloc(repository: repo)..add(GetKhelafotSyllabiEvent());
      },
      child: const KhelafotSyllabusView(),
    );
  }
}

class KhelafotSyllabusView extends StatefulWidget {
  const KhelafotSyllabusView({Key? key}) : super(key: key);

  @override
  State<KhelafotSyllabusView> createState() => _KhelafotSyllabusViewState();
}

class _KhelafotSyllabusViewState extends State<KhelafotSyllabusView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isIntroExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final primaryColor = isDark ? const Color(0xFF2E7D32) : const Color(0xFF1B5E20);
    final accentGold = isDark ? const Color(0xFFFFD54F) : const Color(0xFFC59B27);
    final headerGradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF0D3311)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'খেলাফত মজলিস সিলেবাস',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'সংগঠন ও প্রকাশনা তথ্য',
            onPressed: () => _showOrgInfoDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<KhelafotSyllabusBloc, KhelafotSyllabusState>(
        builder: (context, state) {
          if (state is KhelafotSyllabusLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF1B5E20)),
                  SizedBox(height: 16),
                  Text('সিলেবাস তথ্য লোড হচ্ছে...'),
                ],
              ),
            );
          } else if (state is KhelafotSyllabusError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<KhelafotSyllabusBloc>().add(GetKhelafotSyllabiEvent());
                      },
                      child: const Text('পুনরায় চেষ্টা করুন'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is KhelafotSyllabusLoaded) {
            final data = state.fullData;
            final progressPercent = (state.overallProgress * 100).toInt();

            return Column(
              children: [
                // Header Banner & Progress Card
                Container(
                  decoration: BoxDecoration(gradient: headerGradient),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.menu_book_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.organizationName,
                                    style: TextStyle(
                                      color: accentGold,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'পাঠ্যসূচি ও পাঠাগার তালিকা',
                                    style: TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: accentGold.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: accentGold, width: 1),
                              ),
                              child: Text(
                                data.publicationDate.replaceAll('সর্বশেষ সংস্করণ: ', ''),
                                style: TextStyle(
                                  color: accentGold,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        // Progress Bar Card
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.grey.shade900.withOpacity(0.7)
                                : Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.task_alt, color: Colors.white, size: 18),
                                      SizedBox(width: 6),
                                      Text(
                                        'পঠন অগ্রগতি (Book Progress)',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${state.completedBooksCount} / ${state.totalBooks}টি সম্পন্ন ($progressPercent%)',
                                    style: TextStyle(
                                      color: accentGold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: state.overallProgress,
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(accentGold),
                                  minHeight: 8,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Expandable Introduction
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isIntroExpanded = !_isIntroExpanded;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.import_contacts, color: Colors.white70, size: 16),
                                const SizedBox(width: 6),
                                const Text(
                                  'ভূমিকা (Introduction)',
                                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                Icon(
                                  _isIntroExpanded ? Icons.expand_less : Icons.expand_more,
                                  color: Colors.white70,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_isIntroExpanded) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black45 : Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              data.introduction,
                              style: TextStyle(
                                fontSize: 12.5,
                                height: 1.5,
                                color: isDark ? Colors.grey.shade200 : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Search Bar & Filter Chips
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: (query) {
                          context.read<KhelafotSyllabusBloc>().add(
                                FilterSyllabusEvent(query: query),
                              );
                        },
                        decoration: InputDecoration(
                          hintText: 'বইয়ের নাম বা লেখকের নাম দিয়ে খুঁজুন...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<KhelafotSyllabusBloc>().add(
                                          const FilterSyllabusEvent(query: ''),
                                        );
                                  },
                                )
                              : null,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(context, 'সকল বই', 'all', state.bookFilter),
                            const SizedBox(width: 8),
                            _buildFilterChip(context, 'পাঠ্য বই (Mandatory)', 'mandatory', state.bookFilter),
                            const SizedBox(width: 8),
                            _buildFilterChip(context, 'সহায়ক বই (Reference)', 'optional', state.bookFilter),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab Bar
                Container(
                  color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: primaryColor,
                    unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                    indicatorColor: primaryColor,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    tabs: const [
                      Tab(text: 'প্রথম স্তর (কর্মী)'),
                      Tab(text: 'দ্বিতীয় স্তর (সদস্য)'),
                      Tab(text: 'উচ্চতর স্তর'),
                      Tab(text: 'আলোচনার বিষয়সমূহ'),
                    ],
                  ),
                ),

                // Tab Views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Level 1
                      _buildLevelTab(context, data.levels[0], state),
                      // Level 2
                      _buildLevelTab(context, data.levels[1], state),
                      // Level 3
                      _buildLevelTab(context, data.levels[2], state),
                      // Discussion Topics
                      _buildDiscussionTopicsTab(context, data.discussionTopics, state),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFilterChip(
      BuildContext context, String label, String value, String currentFilter) {
    final isSelected = currentFilter == value;
    final primaryColor = const Color(0xFF1B5E20);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: primaryColor.withOpacity(0.2),
      checkmarkColor: primaryColor,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? primaryColor : null,
      ),
      onSelected: (selected) {
        context.read<KhelafotSyllabusBloc>().add(
              FilterSyllabusEvent(query: _searchController.text, bookFilter: value),
            );
      },
    );
  }

  Widget _buildLevelTab(
      BuildContext context, SyllabusLevel level, KhelafotSyllabusLoaded state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Level Info Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1B381D) : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF81C784),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.stars, color: Color(0xFF2E7D32)),
                    const SizedBox(width: 8),
                    Text(
                      '${level.levelTitle} - ${level.subtitle}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  level.description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Categories Accordion / Expansion Tiles
          ...level.categories.map((category) {
            return _buildCategoryCard(context, category, state);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, SyllabusCategory category, KhelafotSyllabusLoaded state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final query = state.searchQuery.trim().toLowerCase();
    final filter = state.bookFilter;

    // Filter books based on search query and mandatory filter
    final filteredBooks = category.books.where((book) {
      final matchesQuery = query.isEmpty ||
          book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);

      bool matchesFilter = true;
      if (filter == 'mandatory') {
        matchesFilter = book.isMandatory;
      } else if (filter == 'optional') {
        matchesFilter = !book.isMandatory;
      }

      return matchesQuery && matchesFilter;
    }).toList();

    // If query is present and no books match and no topic matches, return shrink
    final matchesTopics = category.topics.any((t) => t.toLowerCase().contains(query));
    if (query.isNotEmpty && filteredBooks.isEmpty && !matchesTopics) {
      return const SizedBox.shrink();
    }

    final categoryCompletedCount = category.books
        .where((b) => state.completedBookIds.contains(b.id))
        .length;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        initiallyExpanded: query.isNotEmpty,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1B5E20).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.bookmark_border, color: Color(0xFF1B5E20)),
        ),
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          'পাঠ্য বিষয়: ${category.topics.length}টি | বই: ${category.books.length}টি (সম্পন্ন: $categoryCompletedCount)',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          const Divider(),

          // Topics Section
          if (category.topics.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  Icon(Icons.format_list_bulleted, size: 16, color: Colors.blueGrey),
                  SizedBox(width: 6),
                  Text(
                    'পাঠ্য বিষয় (Study Topics)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...category.topics.map((topic) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6, left: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_right_rounded, size: 18, color: Color(0xFF1B5E20)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        topic,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: isDark ? Colors.grey.shade200 : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 14),
          ],

          // Books Section
          if (category.books.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.amber.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.library_books, size: 16, color: Colors.amber),
                      SizedBox(width: 6),
                      Text(
                        'গ্রন্থাবলী (Books List)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.brown),
                      ),
                    ],
                  ),
                  Text(
                    '${filteredBooks.length}টি দেখাচ্ছে',
                    style: const TextStyle(fontSize: 11, color: Colors.brown),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (filteredBooks.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('কোন বই পাওয়া যায়নি', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ...filteredBooks.map((book) {
              final isCompleted = state.completedBookIds.contains(book.id);
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? (isDark ? Colors.green.shade900.withOpacity(0.3) : Colors.green.shade50)
                      : (isDark ? Colors.grey.shade900 : Colors.grey.shade50),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCompleted
                        ? Colors.green.shade300
                        : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: isCompleted,
                      activeColor: const Color(0xFF1B5E20),
                      onChanged: (val) {
                        context
                            .read<KhelafotSyllabusBloc>()
                            .add(ToggleBookCompletionEvent(bookId: book.id));
                      },
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                              color: isCompleted ? Colors.green.shade800 : null,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'লেখক: ${book.author}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: book.isMandatory
                            ? Colors.red.shade100
                            : Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        book.isMandatory ? 'পাঠ্য বই' : 'সহায়ক বই',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: book.isMandatory
                              ? Colors.red.shade900
                              : Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildDiscussionTopicsTab(
      BuildContext context, List<DiscussionNoteTopicGroup> groups, KhelafotSyllabusLoaded state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final query = state.searchQuery.trim().toLowerCase();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3E2723) : const Color(0xFFEFEBE9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFA1887F)),
            ),
            child: const Row(
              children: [
                Icon(Icons.notes, color: Color(0xFF5D4037)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'নিম্নোক্ত বিষয়সমূহের উপর আলোচনার জন্য নোট তৈরি করবেন',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4E342E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          ...groups.map((group) {
            final matchesQuery = query.isEmpty ||
                group.categoryName.toLowerCase().contains(query) ||
                group.topics.any((t) => t.toLowerCase().contains(query));

            if (!matchesQuery) return const SizedBox.shrink();

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.topic, color: Color(0xFF1B5E20), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          group.categoryName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    ...group.topics.map((topic) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                topic,
                                style: const TextStyle(fontSize: 13, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showOrgInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.business, color: Color(0xFF1B5E20)),
            SizedBox(width: 8),
            Text('প্রকাশনা ও ঠিকানা'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('প্রকাশনায়:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('খেলাফত মজলিস'),
              SizedBox(height: 6),
              Text('ঠিকানা:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('১৬, বিজয়নগর (৫ম তলা), ঢাকা-১০০০'),
              SizedBox(height: 6),
              Text('যোগাযোগ:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('ফোন: ৯৫৮৪৫২১'),
              Text('ইমেইল: khelafatmajlis@gmail.com'),
              Text('ওয়েবসাইট: www.khelafatmajlis.org'),
              SizedBox(height: 6),
              Text('সর্বশেষ সংস্করণ: ডিসেম্বর ২০১৪'),
              Text('বিনিময়: ২০/- (বিশ) টাকা মাত্র'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('বন্ধ করুন'),
          ),
        ],
      ),
    );
  }
}
