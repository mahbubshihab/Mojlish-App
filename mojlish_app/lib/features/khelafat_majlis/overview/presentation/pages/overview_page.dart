import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/overview_bloc.dart';
import '../bloc/overview_event.dart';
import '../bloc/overview_state.dart';
import '../../domain/entities/overview_entity.dart';
import '../../data/datasources/overview_remote_data_source.dart';
import '../../data/repositories/overview_repository_impl.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OverviewBloc(
        repository: OverviewRepositoryImpl(
          remoteDataSource: OverviewRemoteDataSourceImpl(),
        ),
      )..add(LoadOverviewEvent()),
      child: const OverviewView(),
    );
  }
}

class OverviewView extends StatefulWidget {
  const OverviewView({super.key});

  @override
  State<OverviewView> createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _chipScrollController = ScrollController();
  int _selectedSectionIndex = 0;
  bool _isProgrammaticScroll = false;

  final GlobalKey _introKey = GlobalKey();
  final GlobalKey _goalKey = GlobalKey();
  final GlobalKey _programsKey = GlobalKey();
  final GlobalKey _membershipKey = GlobalKey();
  final GlobalKey _structureKey = GlobalKey();
  final GlobalKey _baytulmalkey = GlobalKey();
  final GlobalKey _principlesKey = GlobalKey();
  final GlobalKey _commitmentsKey = GlobalKey();
  final GlobalKey _officeKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _checkActiveSection() {
    if (_isProgrammaticScroll) return;
    final keys = [
      _introKey,
      _goalKey,
      _programsKey,
      _membershipKey,
      _structureKey,
      _baytulmalkey,
      _principlesKey,
      _commitmentsKey,
      _officeKey,
    ];

    int newIndex = 0;
    for (int i = 0; i < keys.length; i++) {
      final ctx = keys[i].currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize) {
          final position = box.localToGlobal(Offset.zero);
          if (position.dy <= 200) {
            newIndex = i;
          }
        }
      }
    }

    if (newIndex != _selectedSectionIndex) {
      setState(() {
        _selectedSectionIndex = newIndex;
      });
      _scrollToChip(newIndex);
    }
  }

  void _scrollToChip(int index) {
    if (_chipScrollController.hasClients) {
      final targetOffset = (index * 88.0).clamp(
        0.0,
        _chipScrollController.position.maxScrollExtent,
      );
      _chipScrollController.jumpTo(targetOffset);
    }
  }

  void _scrollToSection(GlobalKey key, int index) {
    _isProgrammaticScroll = true;
    setState(() {
      _selectedSectionIndex = index;
    });
    _scrollToChip(index);
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      ).then((_) {
        Future.delayed(const Duration(milliseconds: 150), () {
          _isProgrammaticScroll = false;
        });
      });
    } else {
      _isProgrammaticScroll = false;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _chipScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = const Color(0xFF059669);
    final scaffoldBg = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);
    final textTitleColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textBodyColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF162032) : Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: textTitleColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'খেলাফত মজলিস পরিচিতি',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocBuilder<OverviewBloc, OverviewState>(
        builder: (context, state) {
          if (state is OverviewLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  const SizedBox(height: 16),
                  Text(
                    'পরিচিতি ডাটা লোড হচ্ছে...',
                    style: TextStyle(color: textBodyColor, fontSize: 14),
                  ),
                ],
              ),
            );
          } else if (state is OverviewError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textTitleColor, fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                      onPressed: () {
                        context.read<OverviewBloc>().add(LoadOverviewEvent());
                      },
                      child: const Text('পুনরায় চেষ্টা করুন', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
            );
          } else if (state is OverviewLoaded) {
            final overview = state.overview;

            return Column(
              children: [
                // Quick Section Navigation Bar
                _buildSectionNavigationChips(primaryColor, isDark),
                
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (!_isProgrammaticScroll) {
                        _checkActiveSection();
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Header Banner
                        _buildHeaderBanner(overview, primaryColor, isDark),
                        const SizedBox(height: 20),

                        // 2. Intro Section
                        Container(key: _introKey),
                        _buildSectionCard(
                          title: 'বিসমিল্লাহির রাহমানির রাহিম — ভূমিকা',
                          icon: Icons.auto_awesome_rounded,
                          primaryColor: primaryColor,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textTitleColor: textTitleColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: overview.introductionParagraphs.map((paragraph) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Text(
                                  paragraph,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    height: 1.6,
                                    color: textBodyColor,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 3. Goal Section
                        Container(key: _goalKey),
                        _buildSectionCard(
                          title: 'সাংগঠনিক লক্ষ্য',
                          icon: Icons.flag_rounded,
                          primaryColor: primaryColor,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textTitleColor: textTitleColor,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star_rounded, color: primaryColor, size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    overview.organizationalGoal,
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                      color: textTitleColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 4. Basic Programs Section (7 items)
                        Container(key: _programsKey),
                        _buildSectionCard(
                          title: 'মৌলিক কর্মসূচি (৭-দফা)',
                          icon: Icons.format_list_numbered_rounded,
                          primaryColor: primaryColor,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textTitleColor: textTitleColor,
                          child: Column(
                            children: overview.basicPrograms.map((program) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: primaryColor,
                                      child: Text(
                                        '${program.number}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            program.title,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            program.description,
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              height: 1.5,
                                              color: textBodyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 5. Membership Section
                        Container(key: _membershipKey),
                        _buildSectionCard(
                          title: 'সদস্যপদ ও কর্মী গঠন',
                          icon: Icons.people_alt_rounded,
                          primaryColor: primaryColor,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textTitleColor: textTitleColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBulletCard(
                                title: 'প্রাথমিক সদস্য',
                                text: overview.membershipInfo.primaryMember,
                                primaryColor: primaryColor,
                                isDark: isDark,
                                textBodyColor: textBodyColor,
                              ),
                              const SizedBox(height: 10),
                              _buildBulletCard(
                                title: 'কর্মী',
                                text: overview.membershipInfo.workerMember,
                                primaryColor: primaryColor,
                                isDark: isDark,
                                textBodyColor: textBodyColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '(৩) সদস্য হওয়ার শর্তাবলী:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: textTitleColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...overview.membershipInfo.conditions.map((cond) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.check_circle_outline_rounded,
                                          size: 18, color: primaryColor),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          cond,
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            height: 1.4,
                                            color: textBodyColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 6. Structure Section
                        Container(key: _structureKey),
                        _buildSectionCard(
                          title: 'সাংগঠনিক স্তর ও কাঠামো',
                          icon: Icons.account_tree_rounded,
                          primaryColor: primaryColor,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textTitleColor: textTitleColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'সাংগঠনিক স্তরসমূহ:',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: overview.structureInfo.levels.map((lvl) {
                                  return Chip(
                                    avatar: const Icon(Icons.layers_rounded, size: 16),
                                    label: Text(
                                      lvl,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                              _buildExpandableTile(
                                title: 'আমীরে খেলাফত মজলিস',
                                content: overview.structureInfo.ameer,
                                primaryColor: primaryColor,
                                textBodyColor: textBodyColor,
                                isDark: isDark,
                              ),
                              _buildExpandableTile(
                                title: 'কেন্দ্রীয় উপদেষ্টা পরিষদ',
                                content: overview.structureInfo.advisoryCouncil,
                                primaryColor: primaryColor,
                                textBodyColor: textBodyColor,
                                isDark: isDark,
                              ),
                              _buildExpandableTile(
                                title: 'সাধারণ পরিষদ',
                                content: overview.structureInfo.generalAssembly,
                                primaryColor: primaryColor,
                                textBodyColor: textBodyColor,
                                isDark: isDark,
                              ),
                              _buildExpandableTile(
                                title: 'কেন্দ্রীয় মজলিসে শূরা',
                                content: overview.structureInfo.shura,
                                primaryColor: primaryColor,
                                textBodyColor: textBodyColor,
                                isDark: isDark,
                              ),
                              _buildExpandableTile(
                                title: 'কেন্দ্রীয় নির্বাহী পরিষদ',
                                content: overview.structureInfo.executiveCouncil,
                                primaryColor: primaryColor,
                                textBodyColor: textBodyColor,
                                isDark: isDark,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 7. Baytulmal Section
                        Container(key: _baytulmalkey),
                        _buildSectionCard(
                          title: 'বায়তুলমাল (সাংগঠনিক তহবিল)',
                          icon: Icons.account_balance_wallet_rounded,
                          primaryColor: primaryColor,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textTitleColor: textTitleColor,
                          child: Text(
                            overview.baytulmalInfo.description,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: textBodyColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 8. Implementation Principles (11 points)
                        Container(key: _principlesKey),
                        _buildSectionCard(
                          title: 'মৌলিক নীতিমালার বাস্তবায়ন (১১টি বিষয়)',
                          icon: Icons.gavel_rounded,
                          primaryColor: primaryColor,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textTitleColor: textTitleColor,
                          child: Column(
                            children: overview.implementationPrinciples.map((principle) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.stars_rounded, size: 18, color: primaryColor),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        principle,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          height: 1.5,
                                          color: textBodyColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 9. Socio-Political Commitments (Section 5 - 25 points)
                        Container(key: _commitmentsKey),
                        _buildSectionCard(
                          title: 'ধারা- ৫: আর্থ-সামাজিক ও রাজনৈতিক অঙ্গীকার (২৫টি দফা)',
                          icon: Icons.policy_rounded,
                          primaryColor: primaryColor,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textTitleColor: textTitleColor,
                          child: Column(
                            children: overview.politicalCommitments.map((item) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  leading: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: primaryColor,
                                    child: Text(
                                      '${item.number}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.bold,
                                      color: textTitleColor,
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                                      child: Text(
                                        item.description,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          height: 1.6,
                                          color: textBodyColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 10. Call to Action & Office Info
                        Container(key: _officeKey),
                        _buildSectionCard(
                          title: overview.callToAction.title,
                          icon: Icons.campaign_rounded,
                          primaryColor: primaryColor,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textTitleColor: textTitleColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                overview.callToAction.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  color: textBodyColor,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Divider(),
                              const SizedBox(height: 10),
                              Text(
                                'কেন্দ্রীয় কার্যালয়',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildContactRow(Icons.location_on_rounded, overview.callToAction.officeAddress, textBodyColor),
                              _buildContactRow(Icons.phone_rounded, 'ফোন : ${overview.callToAction.phone}', textBodyColor),
                              _buildContactRow(Icons.language_rounded, 'Web : ${overview.callToAction.web}', textBodyColor),
                              _buildContactRow(Icons.email_rounded, 'E-mail : ${overview.callToAction.email}', textBodyColor),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Chip(
                                    label: Text('বিনিময় : ${overview.callToAction.price}'),
                                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                                  ),
                                  Chip(
                                    label: Text('নিবন্ধন নং : ${overview.callToAction.regNo}'),
                                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
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

  Widget _buildSectionNavigationChips(Color primaryColor, bool isDark) {
    final sections = [
      {'title': 'ভূমিকা', 'key': _introKey, 'index': 0},
      {'title': 'লক্ষ্য', 'key': _goalKey, 'index': 1},
      {'title': '৭-দফা কর্মসূচি', 'key': _programsKey, 'index': 2},
      {'title': 'সদস্যপদ', 'key': _membershipKey, 'index': 3},
      {'title': 'কাঠামো', 'key': _structureKey, 'index': 4},
      {'title': ' বায়তুলমাল', 'key': _baytulmalkey, 'index': 5},
      {'title': '১১-দফা নীতি', 'key': _principlesKey, 'index': 6},
      {'title': '২৫-দফা অঙ্গীকার', 'key': _commitmentsKey, 'index': 7},
      {'title': 'কার্যালয়', 'key': _officeKey, 'index': 8},
    ];

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 6),
      color: isDark ? const Color(0xFF162032) : Colors.white,
      child: ListView.builder(
        controller: _chipScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: sections.length,
        itemBuilder: (context, idx) {
          final isSelected = _selectedSectionIndex == idx;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(sections[idx]['title'] as String),
              selected: isSelected,
              selectedColor: primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              onSelected: (_) {
                _scrollToSection(sections[idx]['key'] as GlobalKey, idx);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderBanner(OverviewEntity overview, Color primaryColor, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, const Color(0xFF047857)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/khelafot_majlish.png',
              height: 48,
              width: 48,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.stars_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            overview.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            overview.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFFA7F3D0),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color primaryColor,
    required Color cardBg,
    required Color borderColor,
    required Color textTitleColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: textTitleColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildBulletCard({
    required String title,
    required String text,
    required Color primaryColor,
    required bool isDark,
    required Color textBodyColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(fontSize: 13, height: 1.4, color: textBodyColor),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableTile({
    required String title,
    required String content,
    required Color primaryColor,
    required Color textBodyColor,
    required bool isDark,
  }) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            content,
            style: TextStyle(fontSize: 13.5, height: 1.5, color: textBodyColor),
          ),
        )
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
