import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/khelafot_syllabus_bloc.dart';
import '../bloc/khelafot_syllabus_event.dart';
import '../bloc/khelafot_syllabus_state.dart';
import '../../data/datasources/khelafot_syllabus_remote_datasource.dart';
import '../../data/repositories/khelafot_syllabus_repository_impl.dart';
import '../../domain/entities/khelafot_syllabus_entity.dart';

class KhelafotSyllabusPage extends StatelessWidget {
  const KhelafotSyllabusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KhelafotSyllabusBloc>(
      create: (context) => KhelafotSyllabusBloc(
        repository: KhelafotSyllabusRepositoryImpl(
          remoteDataSource: KhelafotSyllabusRemoteDataSourceImpl(),
        ),
      )..add(GetKhelafotSyllabiEvent()),
      child: const KhelafotSyllabusView(),
    );
  }
}

class KhelafotSyllabusView extends StatefulWidget {
  const KhelafotSyllabusView({super.key});

  @override
  State<KhelafotSyllabusView> createState() => _KhelafotSyllabusViewState();
}

class _KhelafotSyllabusViewState extends State<KhelafotSyllabusView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<KhelafotSyllabusBloc>();
      if (bloc.state is! KhelafotSyllabusLoaded) {
        bloc.add(GetKhelafotSyllabiEvent());
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? const Color(0xFF2E7D32) : const Color(0xFF1B5E20);
    final bgColor = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'খেলাফত মজলিস সিলেবাস',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
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
                    const Icon(Icons.error_outline, size: 54, color: Colors.red),
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

            return Column(
              children: [
                // Top Level Tab Bar
                Container(
                  color: isDark ? const Color(0xFF162032) : Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: primaryColor,
                    labelColor: primaryColor,
                    unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade700,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                    tabs: const [
                      Tab(text: 'প্রথম স্তর (কর্মী)'),
                      Tab(text: 'দ্বিতীয় স্তর (সদস্য)'),
                      Tab(text: 'তৃতীয় স্তর (উচ্চতর)'),
                      Tab(text: 'আলোচনার বিষয়সমূহ'),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Content View
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Level 1
                      _buildLevelView(
                        context,
                        level: data.levels[0],
                        data: data,
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textColor: textColor,
                        subTextColor: subTextColor,
                        showIntro: true,
                      ),
                      // Level 2
                      _buildLevelView(
                        context,
                        level: data.levels[1],
                        data: data,
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textColor: textColor,
                        subTextColor: subTextColor,
                        showIntro: false,
                      ),
                      // Level 3
                      _buildLevelView(
                        context,
                        level: data.levels[2],
                        data: data,
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textColor: textColor,
                        subTextColor: subTextColor,
                        showIntro: false,
                      ),
                      // Discussion Topics
                      _buildDiscussionTopicsView(
                        context,
                        topics: data.discussionTopics,
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textColor: textColor,
                        subTextColor: subTextColor,
                      ),
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

  Widget _buildLevelView(
    BuildContext context, {
    required SyllabusLevel level,
    required KhelafotSyllabusData data,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color subTextColor,
    required bool showIntro,
  }) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Booklet Header Banner
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1B5E20), const Color(0xFF0D3311)]
                  : [const Color(0xFF2E7D32), const Color(0xFF1B5E20)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.organizationName,
                    style: const TextStyle(
                      color: Color(0xFFFFD54F),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      data.publicationDate,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${level.levelTitle} — ${level.subtitle}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Intro (Only on Level 1)
        if (showIntro) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: Color(0xFF059669), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'ভূমিকা (Introduction)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  data.introduction,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.6,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Level Objective Description
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF162E22) : const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFA7F3D0)),
          ),
          child: Text(
            level.description,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF065F46),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Categories List
        ...level.categories.map((category) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Title Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.book_rounded,
                        color: Color(0xFF059669),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(),
                const SizedBox(height: 10),

                // Topics (পাঠ্য বিষয়)
                if (category.topics.isNotEmpty) ...[
                  const Text(
                    'পাঠ্য বিষয়সমূহ:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF059669),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...category.topics.map((topic) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                          Expanded(
                            child: Text(
                              topic,
                              style: TextStyle(
                                fontSize: 13.5,
                                height: 1.5,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],

                // Books (পাঠ্য ও সহায়ক বই)
                if (category.books.isNotEmpty) ...[
                  const Text(
                    'পাঠ্য ও সহায়ক বইসমূহ:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF059669),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...category.books.map((book) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'লেখক/অনুবাদক: ${book.author}',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: subTextColor,
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
                                  ? const Color(0xFF059669).withValues(alpha: 0.15)
                                  : (isDark ? const Color(0xFF334155) : Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              book.isMandatory ? 'পাঠ্য বই' : 'সহায়ক বই',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: book.isMandatory
                                    ? const Color(0xFF059669)
                                    : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDiscussionTopicsView(
    BuildContext context, {
    required List<DiscussionNoteTopicGroup> topics,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF162032) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'আলোচনার বিষয়সমূহ (Discussion Note Topics)',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF059669),
                ),
              ),
              SizedBox(height: 6),
              Text(
                'বিভিন্ন শাখা ও অধঃশাখার নিয়মিত সাধারণ ও স্টাডি সার্কেলের আলোচনার বিষয় তালিকা।',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Topic Groups
        ...topics.map((group) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.categoryName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 8),
                ...group.topics.map((topicItem) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF059669)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            topicItem,
                            style: TextStyle(
                              fontSize: 13.5,
                              height: 1.5,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }
}
