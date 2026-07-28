import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import '../bloc/baytulmal_report_bloc.dart';
import '../bloc/baytulmal_report_event.dart';
import '../bloc/baytulmal_report_state.dart';
import '../../domain/entities/baytulmal_report_entity.dart';
import '../../data/services/student_baytulmal_pdf_service.dart';

class StudentBaytulmalReportScreen extends StatefulWidget {
  final int? initialYear;
  final int? initialMonth;

  const StudentBaytulmalReportScreen({
    super.key,
    this.initialYear,
    this.initialMonth,
  });

  @override
  State<StudentBaytulmalReportScreen> createState() => _StudentBaytulmalReportScreenState();
}

class _StudentBaytulmalReportScreenState extends State<StudentBaytulmalReportScreen> {
  late int _selectedYear;
  late int _selectedMonth;

  // Form Controllers
  final _branchCtrl = TextEditingController();
  final _sessionCtrl = TextEditingController();

  // Income controllers (Taka & Paisa)
  final _jonoshaktiTakaCtrl = TextEditingController();
  final _jonoshaktiPaisaCtrl = TextEditingController();
  final _shakhaTakaCtrl = TextEditingController();
  final _shakhaPaisaCtrl = TextEditingController();
  final _suhridTakaCtrl = TextEditingController();
  final _suhridPaisaCtrl = TextEditingController();
  final _ekkalinTakaCtrl = TextEditingController();
  final _ekkalinPaisaCtrl = TextEditingController();
  final _incomeWordsCtrl = TextEditingController();
  final _prevSurplusTakaCtrl = TextEditingController();
  final _prevSurplusPaisaCtrl = TextEditingController();

  // Expense controllers (Taka & Paisa)
  final _upwardAyanatTakaCtrl = TextEditingController();
  final _upwardAyanatPaisaCtrl = TextEditingController();
  final _upwardSafarTakaCtrl = TextEditingController();
  final _upwardSafarPaisaCtrl = TextEditingController();
  final _officeTakaCtrl = TextEditingController();
  final _officePaisaCtrl = TextEditingController();
  final _transportTakaCtrl = TextEditingController();
  final _transportPaisaCtrl = TextEditingController();
  final _communicationTakaCtrl = TextEditingController();
  final _communicationPaisaCtrl = TextEditingController();
  final _procharTakaCtrl = TextEditingController();
  final _procharPaisaCtrl = TextEditingController();
  final _expenseWordsCtrl = TextEditingController();
  final _prevDeficitTakaCtrl = TextEditingController();
  final _prevDeficitPaisaCtrl = TextEditingController();

  // Custom row controllers map
  final Map<int, TextEditingController> _customIncTitleCtrls = {};
  final Map<int, TextEditingController> _customIncTakaCtrls = {};
  final Map<int, TextEditingController> _customIncPaisaCtrls = {};

  final Map<int, TextEditingController> _customExpTitleCtrls = {};
  final Map<int, TextEditingController> _customExpTakaCtrls = {};
  final Map<int, TextEditingController> _customExpPaisaCtrls = {};

  bool _isExporting = false;

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = widget.initialYear ?? now.year;
    _selectedMonth = widget.initialMonth ?? now.month;
  }

  @override
  void dispose() {
    _branchCtrl.dispose();
    _sessionCtrl.dispose();

    _jonoshaktiTakaCtrl.dispose();
    _jonoshaktiPaisaCtrl.dispose();
    _shakhaTakaCtrl.dispose();
    _shakhaPaisaCtrl.dispose();
    _suhridTakaCtrl.dispose();
    _suhridPaisaCtrl.dispose();
    _ekkalinTakaCtrl.dispose();
    _ekkalinPaisaCtrl.dispose();
    _incomeWordsCtrl.dispose();
    _prevSurplusTakaCtrl.dispose();
    _prevSurplusPaisaCtrl.dispose();

    _upwardAyanatTakaCtrl.dispose();
    _upwardAyanatPaisaCtrl.dispose();
    _upwardSafarTakaCtrl.dispose();
    _upwardSafarPaisaCtrl.dispose();
    _officeTakaCtrl.dispose();
    _officePaisaCtrl.dispose();
    _transportTakaCtrl.dispose();
    _transportPaisaCtrl.dispose();
    _communicationTakaCtrl.dispose();
    _communicationPaisaCtrl.dispose();
    _procharTakaCtrl.dispose();
    _procharPaisaCtrl.dispose();
    _expenseWordsCtrl.dispose();
    _prevDeficitTakaCtrl.dispose();
    _prevDeficitPaisaCtrl.dispose();

    _disposeCustomCtrls(_customIncTitleCtrls);
    _disposeCustomCtrls(_customIncTakaCtrls);
    _disposeCustomCtrls(_customIncPaisaCtrls);
    _disposeCustomCtrls(_customExpTitleCtrls);
    _disposeCustomCtrls(_customExpTakaCtrls);
    _disposeCustomCtrls(_customExpPaisaCtrls);

    super.dispose();
  }

  void _disposeCustomCtrls(Map<int, TextEditingController> map) {
    for (final c in map.values) {
      c.dispose();
    }
    map.clear();
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  void _populateControllers(StudentBaytulmalReportEntity report) {
    _branchCtrl.text = report.branchName;
    _sessionCtrl.text = report.session;

    _jonoshaktiTakaCtrl.text = report.jonoshaktiAyanatTaka;
    _jonoshaktiPaisaCtrl.text = report.jonoshaktiAyanatPaisa;
    _shakhaTakaCtrl.text = report.shakhaAyanatTaka;
    _shakhaPaisaCtrl.text = report.shakhaAyanatPaisa;
    _suhridTakaCtrl.text = report.suhridAyanatTaka;
    _suhridPaisaCtrl.text = report.suhridAyanatPaisa;
    _ekkalinTakaCtrl.text = report.ekkalinIncomeTaka;
    _ekkalinPaisaCtrl.text = report.ekkalinIncomePaisa;
    _incomeWordsCtrl.text = report.incomeInWords;
    _prevSurplusTakaCtrl.text = report.previousSurplusTaka;
    _prevSurplusPaisaCtrl.text = report.previousSurplusPaisa;

    _upwardAyanatTakaCtrl.text = report.upwardAyanatTaka;
    _upwardAyanatPaisaCtrl.text = report.upwardAyanatPaisa;
    _upwardSafarTakaCtrl.text = report.upwardSafarTaka;
    _upwardSafarPaisaCtrl.text = report.upwardSafarPaisa;
    _officeTakaCtrl.text = report.officeTaka;
    _officePaisaCtrl.text = report.officePaisa;
    _transportTakaCtrl.text = report.transportTaka;
    _transportPaisaCtrl.text = report.transportPaisa;
    _communicationTakaCtrl.text = report.communicationTaka;
    _communicationPaisaCtrl.text = report.communicationPaisa;
    _procharTakaCtrl.text = report.procharTaka;
    _procharPaisaCtrl.text = report.procharPaisa;
    _expenseWordsCtrl.text = report.expenseInWords;
    _prevDeficitTakaCtrl.text = report.previousDeficitTaka;
    _prevDeficitPaisaCtrl.text = report.previousDeficitPaisa;

    // Populate custom income controllers
    for (int i = 0; i < report.customIncomeRows.length; i++) {
      _customIncTitleCtrls.putIfAbsent(i, () => TextEditingController()).text = report.customIncomeRows[i].title;
      _customIncTakaCtrls.putIfAbsent(i, () => TextEditingController()).text = report.customIncomeRows[i].taka;
      _customIncPaisaCtrls.putIfAbsent(i, () => TextEditingController()).text = report.customIncomeRows[i].paisa;
    }

    // Populate custom expense controllers
    for (int i = 0; i < report.customExpenseRows.length; i++) {
      _customExpTitleCtrls.putIfAbsent(i, () => TextEditingController()).text = report.customExpenseRows[i].title;
      _customExpTakaCtrls.putIfAbsent(i, () => TextEditingController()).text = report.customExpenseRows[i].taka;
      _customExpPaisaCtrls.putIfAbsent(i, () => TextEditingController()).text = report.customExpenseRows[i].paisa;
    }
  }

  StudentBaytulmalReportEntity _buildEntityFromForm(StudentBaytulmalReportEntity current) {
    final customIncList = <StudentBaytulmalRowItem>[];
    for (int i = 0; i < current.customIncomeRows.length; i++) {
      final title = _customIncTitleCtrls[i]?.text.trim() ?? current.customIncomeRows[i].title;
      final taka = _customIncTakaCtrls[i]?.text.trim() ?? '0';
      final paisa = _customIncPaisaCtrls[i]?.text.trim() ?? '0';
      customIncList.add(StudentBaytulmalRowItem(title: title, taka: taka, paisa: paisa));
    }

    final customExpList = <StudentBaytulmalRowItem>[];
    for (int i = 0; i < current.customExpenseRows.length; i++) {
      final title = _customExpTitleCtrls[i]?.text.trim() ?? current.customExpenseRows[i].title;
      final taka = _customExpTakaCtrls[i]?.text.trim() ?? '0';
      final paisa = _customExpPaisaCtrls[i]?.text.trim() ?? '0';
      customExpList.add(StudentBaytulmalRowItem(title: title, taka: taka, paisa: paisa));
    }

    return StudentBaytulmalReportEntity(
      id: '$_selectedYear-$_selectedMonth',
      year: _selectedYear,
      month: _selectedMonth,
      session: _sessionCtrl.text.trim(),
      branchName: _branchCtrl.text.trim(),
      jonoshaktiAyanatTaka: _jonoshaktiTakaCtrl.text.trim(),
      jonoshaktiAyanatPaisa: _jonoshaktiPaisaCtrl.text.trim(),
      shakhaAyanatTaka: _shakhaTakaCtrl.text.trim(),
      shakhaAyanatPaisa: _shakhaPaisaCtrl.text.trim(),
      suhridAyanatTaka: _suhridTakaCtrl.text.trim(),
      suhridAyanatPaisa: _suhridPaisaCtrl.text.trim(),
      ekkalinIncomeTaka: _ekkalinTakaCtrl.text.trim(),
      ekkalinIncomePaisa: _ekkalinPaisaCtrl.text.trim(),
      customIncomeRows: customIncList,
      incomeInWords: _incomeWordsCtrl.text.trim(),
      previousSurplusTaka: _prevSurplusTakaCtrl.text.trim(),
      previousSurplusPaisa: _prevSurplusPaisaCtrl.text.trim(),
      upwardAyanatTaka: _upwardAyanatTakaCtrl.text.trim(),
      upwardAyanatPaisa: _upwardAyanatPaisaCtrl.text.trim(),
      upwardSafarTaka: _upwardSafarTakaCtrl.text.trim(),
      upwardSafarPaisa: _upwardSafarPaisaCtrl.text.trim(),
      officeTaka: _officeTakaCtrl.text.trim(),
      officePaisa: _officePaisaCtrl.text.trim(),
      transportTaka: _transportTakaCtrl.text.trim(),
      transportPaisa: _transportPaisaCtrl.text.trim(),
      communicationTaka: _communicationTakaCtrl.text.trim(),
      communicationPaisa: _communicationPaisaCtrl.text.trim(),
      procharTaka: _procharTakaCtrl.text.trim(),
      procharPaisa: _procharPaisaCtrl.text.trim(),
      customExpenseRows: customExpList,
      expenseInWords: _expenseWordsCtrl.text.trim(),
      previousDeficitTaka: _prevDeficitTakaCtrl.text.trim(),
      previousDeficitPaisa: _prevDeficitPaisaCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final bg = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFCBD5E1);
    final textLight = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final inputFill = isDark ? const Color(0xFF0A1628) : const Color(0xFFF1F5F9);
    const accentGreen = Color(0xFF10B981);
    const accentRed = Color(0xFFEF4444);
    const primaryBlue = Color(0xFF0EA5E9);

    return BlocProvider(
      create: (_) => StudentBaytulmalReportBloc()
        ..add(LoadStudentBaytulmalReportData(year: _selectedYear, month: _selectedMonth)),
      child: BlocConsumer<StudentBaytulmalReportBloc, StudentBaytulmalReportState>(
        listener: (context, state) {
          if (state is StudentBaytulmalReportLoaded) {
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: accentGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: accentRed,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          final bloc = context.read<StudentBaytulmalReportBloc>();

          if (state is StudentBaytulmalReportLoading) {
            return Scaffold(
              backgroundColor: bg,
              appBar: AppBar(title: const Text('বায়তুলমাল রিপোর্ট'), backgroundColor: cardBg),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is StudentBaytulmalReportError) {
            return Scaffold(
              backgroundColor: bg,
              appBar: AppBar(title: const Text('বায়তুলমাল রিপোর্ট'), backgroundColor: cardBg),
              body: Center(child: Text('ত্রুটি: ${state.message}', style: TextStyle(color: textLight))),
            );
          }

          if (state is StudentBaytulmalReportLoaded) {
            final report = state.report;
            final isLocked = state.isLocked;
            final isSaving = state.isSaving;

            _populateControllers(report);

            return Scaffold(
              backgroundColor: bg,
              appBar: AppBar(
                backgroundColor: cardBg,
                elevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(color: textLight),
                title: const Column(
                  children: [
                    Text(
                      'বায়তুলমাল রিপোর্ট',
                      style: TextStyle(color: primaryBlue, fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'বাংলাদেশ ইসলামী ছাত্র মজলিস',
                      style: TextStyle(color: Color(0xFF0284C7), fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isLocked ? Icons.edit : Icons.lock_outline,
                      color: primaryBlue,
                    ),
                    tooltip: isLocked ? 'এডিট করুন' : 'লক করুন',
                    onPressed: () => bloc.add(ToggleLockStatusEvent()),
                  ),
                  IconButton(
                    icon: _isExporting
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.picture_as_pdf, color: Color(0xFFEF4444)),
                    tooltip: 'PDF এক্সপোর্ট',
                    onPressed: () async {
                      setState(() => _isExporting = true);
                      try {
                        final currentReport = _buildEntityFromForm(report);
                        await StudentBaytulmalPdfService.generateAndSharePdf(currentReport);
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('PDF এক্সপোর্টে সমস্যা হয়েছে: $e')),
                        );
                      } finally {
                        if (mounted) setState(() => _isExporting = false);
                      }
                    },
                  ),
                ],
              ),
              body: Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: _BaytulmalPainter(isDark: isDark))),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Month Banner
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: primaryBlue.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.account_balance_wallet, color: primaryBlue, size: 26),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_monthNames[_selectedMonth - 1]} ${_bn(_selectedYear)} মাসের রিপোর্ট',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Color(0xFF0284C7),
                                      ),
                                    ),
                                    Text(
                                      isLocked ? 'রিপোর্টটি লক করা আছে (এডিট করতে উপরে চাপুন)' : 'এডিট মোড চালু আছে',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isLocked ? accentGreen : const Color(0xFFF59E0B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 1. Header Information Fields (Branch, Month, Session)
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionHeader('সাধারণ তথ্য'),
                              Row(
                                children: [
                                  Expanded(
                                    child: _formField('শাখা', 'শাখার নাম লিখুন', _branchCtrl, isLocked, textLight, textMuted, borderColor, inputFill),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _formField('সেশন', 'যেমন: ২০২৫-২০২৬', _sessionCtrl, isLocked, textLight, textMuted, borderColor, inputFill),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 2. আয় (Income Table)
                        _buildIncomeTable(
                          report: report,
                          isLocked: isLocked,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textLight: textLight,
                          textMuted: textMuted,
                          inputFill: inputFill,
                          accentGreen: accentGreen,
                          onAddRow: () {
                            _showAddRowDialog(context, 'নতুন আয়ের খাত যোগ করুন', (title) {
                              bloc.add(AddCustomIncomeRowEvent(title: title));
                            });
                          },
                          onRemoveRow: (idx) {
                            bloc.add(RemoveCustomIncomeRowEvent(index: idx));
                          },
                        ),
                        const SizedBox(height: 20),

                        // 3. ব্যয় (Expense Table)
                        _buildExpenseTable(
                          report: report,
                          isLocked: isLocked,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textLight: textLight,
                          textMuted: textMuted,
                          inputFill: inputFill,
                          accentRed: accentRed,
                          onAddRow: () {
                            _showAddRowDialog(context, 'নতুন ব্যয়ের খাত যোগ করুন', (title) {
                              bloc.add(AddCustomExpenseRowEvent(title: title));
                            });
                          },
                          onRemoveRow: (idx) {
                            bloc.add(RemoveCustomExpenseRowEvent(index: idx));
                          },
                        ),
                        const SizedBox(height: 24),

                        // Save Action Button
                        if (!isLocked) ...[
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: isSaving
                                  ? null
                                  : () {
                                      final updatedReport = _buildEntityFromForm(report);
                                      bloc.add(SaveStudentBaytulmalReportData(report: updatedReport));
                                    },
                              icon: isSaving
                                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : const Icon(Icons.save, color: Colors.white),
                              label: Text(
                                isSaving ? 'সেভ হচ্ছে...' : 'রিপোর্ট সেভ করুন',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildIncomeTable({
    required StudentBaytulmalReportEntity report,
    required bool isLocked,
    required Color cardBg,
    required Color borderColor,
    required Color textLight,
    required Color textMuted,
    required Color inputFill,
    required Color accentGreen,
    required VoidCallback onAddRow,
    required Function(int) onRemoveRow,
  }) {
    final currentEntity = _buildEntityFromForm(report);
    final totalInc = currentEntity.totalIncome;
    final grandInc = currentEntity.grandTotalIncome;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 4, height: 20, decoration: BoxDecoration(color: accentGreen, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 10),
                  Text('আয়', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: accentGreen)),
                ],
              ),
              if (!isLocked)
                TextButton.icon(
                  onPressed: onAddRow,
                  icon: Icon(Icons.add_circle_outline, size: 16, color: accentGreen),
                  label: Text('খাত যোগ করুন', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accentGreen)),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(color: accentGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('আয়ের উৎস', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textLight))),
                SizedBox(width: 70, child: Text('টাকা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textLight), textAlign: TextAlign.center)),
                const SizedBox(width: 8),
                SizedBox(width: 60, child: Text('পয়সা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textLight), textAlign: TextAlign.center)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Pre-printed rows
          _tableInputRow('১. জনশক্তি এয়ানত (সদস্য/সহযোগী সদস্য/কর্মী)', _jonoshaktiTakaCtrl, _jonoshaktiPaisaCtrl, isLocked, textLight, borderColor, inputFill),
          _tableInputRow('২. শাখা এয়ানত', _shakhaTakaCtrl, _shakhaPaisaCtrl, isLocked, textLight, borderColor, inputFill),
          _tableInputRow('৩. শুভাকাঙ্ক্ষী এয়ানত', _suhridTakaCtrl, _suhridPaisaCtrl, isLocked, textLight, borderColor, inputFill),
          _tableInputRow('৪. এককালীন আয় (বিস্তারিত আলাদা কাগজে)', _ekkalinTakaCtrl, _ekkalinPaisaCtrl, isLocked, textLight, borderColor, inputFill),

          // Custom Rows
          for (int i = 0; i < report.customIncomeRows.length; i++) ...[
            _customTableInputRow(
              index: i,
              defaultTitle: report.customIncomeRows[i].title,
              titleCtrls: _customIncTitleCtrls,
              takaCtrls: _customIncTakaCtrls,
              paisaCtrls: _customIncPaisaCtrls,
              isLocked: isLocked,
              textLight: textLight,
              borderColor: borderColor,
              inputFill: inputFill,
              onRemove: () => onRemoveRow(i),
            ),
          ],

          const Divider(height: 24),

          // Summary section for Income
          _formField('কথায় (আয়ের মোট পরিমাণ)', 'যেমন: পাঁচ হাজার টাকা মাত্র', _incomeWordsCtrl, isLocked, textLight, textMuted, borderColor, inputFill),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: accentGreen.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('মোট আয়:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textLight)),
                    Text('৳ ${totalInc.toStringAsFixed(2)}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: accentGreen)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('বিগত সেশন/মাসের উদ্বৃত্ত:', style: TextStyle(fontSize: 12, color: textMuted))),
                    SizedBox(width: 80, child: _miniNumberField(_prevSurplusTakaCtrl, 'টাকা', isLocked, textLight, borderColor, inputFill, onChanged: (_) => setState(() {}))),
                    const SizedBox(width: 6),
                    SizedBox(width: 60, child: _miniNumberField(_prevSurplusPaisaCtrl, 'পয়সা', isLocked, textLight, borderColor, inputFill, onChanged: (_) => setState(() {}))),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('সর্বমোট আয়:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: accentGreen)),
                    Text('৳ ${grandInc.toStringAsFixed(2)}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: accentGreen)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseTable({
    required StudentBaytulmalReportEntity report,
    required bool isLocked,
    required Color cardBg,
    required Color borderColor,
    required Color textLight,
    required Color textMuted,
    required Color inputFill,
    required Color accentRed,
    required VoidCallback onAddRow,
    required Function(int) onRemoveRow,
  }) {
    final currentEntity = _buildEntityFromForm(report);
    final totalExp = currentEntity.totalExpense;
    final grandExp = currentEntity.grandTotalExpense;
    final grandInc = currentEntity.grandTotalIncome;
    final balance = currentEntity.balance;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 4, height: 20, decoration: BoxDecoration(color: accentRed, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 10),
                  Text('ব্যয়', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: accentRed)),
                ],
              ),
              if (!isLocked)
                TextButton.icon(
                  onPressed: onAddRow,
                  icon: Icon(Icons.add_circle_outline, size: 16, color: accentRed),
                  label: Text('খাত যোগ করুন', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accentRed)),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(color: accentRed.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('ব্যয়ের খাত', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textLight))),
                SizedBox(width: 70, child: Text('টাকা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textLight), textAlign: TextAlign.center)),
                const SizedBox(width: 8),
                SizedBox(width: 60, child: Text('পয়সা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textLight), textAlign: TextAlign.center)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Pre-printed rows
          _tableInputRow('১. ঊর্ধ্বতন এয়ানত পরিশোধ', _upwardAyanatTakaCtrl, _upwardAyanatPaisaCtrl, isLocked, textLight, borderColor, inputFill),
          _tableInputRow('২. ঊর্ধ্বতন সফর', _upwardSafarTakaCtrl, _upwardSafarPaisaCtrl, isLocked, textLight, borderColor, inputFill),
          _tableInputRow('৩. অফিস', _officeTakaCtrl, _officePaisaCtrl, isLocked, textLight, borderColor, inputFill),
          _tableInputRow('৪. যাতায়াত', _transportTakaCtrl, _transportPaisaCtrl, isLocked, textLight, borderColor, inputFill),
          _tableInputRow('৫. যোগাযোগ', _communicationTakaCtrl, _communicationPaisaCtrl, isLocked, textLight, borderColor, inputFill),
          _tableInputRow('৬. প্রচার', _procharTakaCtrl, _procharPaisaCtrl, isLocked, textLight, borderColor, inputFill),

          // Custom Rows
          for (int i = 0; i < report.customExpenseRows.length; i++) ...[
            _customTableInputRow(
              index: i,
              defaultTitle: report.customExpenseRows[i].title,
              titleCtrls: _customExpTitleCtrls,
              takaCtrls: _customExpTakaCtrls,
              paisaCtrls: _customExpPaisaCtrls,
              isLocked: isLocked,
              textLight: textLight,
              borderColor: borderColor,
              inputFill: inputFill,
              onRemove: () => onRemoveRow(i),
            ),
          ],

          const Divider(height: 24),

          // Summary section for Expense
          _formField('কথায় (ব্যয়ের মোট পরিমাণ)', 'যেমন: চার হাজার টাকা মাত্র', _expenseWordsCtrl, isLocked, textLight, textMuted, borderColor, inputFill),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentRed.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: accentRed.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('মোট ব্যয়:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textLight)),
                    Text('৳ ${totalExp.toStringAsFixed(2)}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: accentRed)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('বিগত সেশন/মাসের ঘাটতি:', style: TextStyle(fontSize: 12, color: textMuted))),
                    SizedBox(width: 80, child: _miniNumberField(_prevDeficitTakaCtrl, 'টাকা', isLocked, textLight, borderColor, inputFill, onChanged: (_) => setState(() {}))),
                    const SizedBox(width: 6),
                    SizedBox(width: 60, child: _miniNumberField(_prevDeficitPaisaCtrl, 'পয়সা', isLocked, textLight, borderColor, inputFill, onChanged: (_) => setState(() {}))),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('সর্বমোট ব্যয়:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: accentRed)),
                    Text('৳ ${grandExp.toStringAsFixed(2)}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: accentRed)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('সর্বমোট আয় (উপরে থেকে আনীত):', style: TextStyle(fontSize: 13, color: textMuted)),
                    Text('৳ ${grandInc.toStringAsFixed(2)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      balance >= 0 ? 'উদ্বৃত্ত:' : 'ঘাটতি:',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: balance >= 0 ? const Color(0xFF10B981) : accentRed),
                    ),
                    Text(
                      '৳ ${balance.abs().toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: balance >= 0 ? const Color(0xFF10B981) : accentRed),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('(ঘাটতি তালিকার বিস্তারিত আলাদা কাগজে)', style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: textMuted)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableInputRow(
    String label,
    TextEditingController takaCtrl,
    TextEditingController paisaCtrl,
    bool isLocked,
    Color textLight,
    Color borderColor,
    Color inputFill,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: TextStyle(fontSize: 12, color: textLight, fontWeight: FontWeight.w500)),
          ),
          SizedBox(
            width: 70,
            child: _miniNumberField(takaCtrl, 'টাকা', isLocked, textLight, borderColor, inputFill, onChanged: (_) => setState(() {})),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: _miniNumberField(paisaCtrl, 'পয়সা', isLocked, textLight, borderColor, inputFill, onChanged: (_) => setState(() {})),
          ),
        ],
      ),
    );
  }

  Widget _customTableInputRow({
    required int index,
    required String defaultTitle,
    required Map<int, TextEditingController> titleCtrls,
    required Map<int, TextEditingController> takaCtrls,
    required Map<int, TextEditingController> paisaCtrls,
    required bool isLocked,
    required Color textLight,
    required Color borderColor,
    required Color inputFill,
    required VoidCallback onRemove,
  }) {
    final titleCtrl = titleCtrls.putIfAbsent(index, () => TextEditingController(text: defaultTitle));
    final takaCtrl = takaCtrls.putIfAbsent(index, () => TextEditingController());
    final paisaCtrl = paisaCtrls.putIfAbsent(index, () => TextEditingController());

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: titleCtrl,
              enabled: !isLocked,
              style: TextStyle(fontSize: 12, color: textLight),
              decoration: InputDecoration(
                hintText: 'খাতের নাম',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                fillColor: inputFill,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 65,
            child: _miniNumberField(takaCtrl, 'টাকা', isLocked, textLight, borderColor, inputFill, onChanged: (_) => setState(() {})),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 55,
            child: _miniNumberField(paisaCtrl, 'পয়সা', isLocked, textLight, borderColor, inputFill, onChanged: (_) => setState(() {})),
          ),
          if (!isLocked)
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 18, color: Colors.red),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }

  Widget _miniNumberField(
    TextEditingController ctrl,
    String hint,
    bool isLocked,
    Color textLight,
    Color borderColor,
    Color inputFill, {
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: ctrl,
      enabled: !isLocked,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right,
      onChanged: onChanged,
      style: TextStyle(fontSize: 12, color: textLight),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 10, color: Colors.grey),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        fillColor: inputFill,
        filled: true,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF0EA5E9))),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor.withValues(alpha: 0.4))),
      ),
    );
  }

  Widget _formField(
    String label,
    String hint,
    TextEditingController ctrl,
    bool isLocked,
    Color textLight,
    Color textMuted,
    Color borderColor,
    Color inputFill,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: textMuted, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          enabled: !isLocked,
          style: TextStyle(fontSize: 13, color: textLight),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            fillColor: inputFill,
            filled: true,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF0EA5E9))),
            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor.withValues(alpha: 0.4))),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(width: 4, height: 18, decoration: BoxDecoration(color: const Color(0xFF0EA5E9), borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
        ],
      ),
    );
  }

  void _showAddRowDialog(BuildContext context, String title, Function(String) onAdd) {
    final textCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: textCtrl,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'খাতের নাম লিখুন',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('বাতিল')),
            ElevatedButton(
              onPressed: () {
                onAdd(textCtrl.text.trim());
                Navigator.pop(ctx);
              },
              child: const Text('যোগ করুন'),
            ),
          ],
        );
      },
    );
  }
}

class _BaytulmalPainter extends CustomPainter {
  final bool isDark;
  _BaytulmalPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isDark) {
      final grid = Paint()..color = Colors.grey.withValues(alpha: 0.05)..strokeWidth = 0.5..style = PaintingStyle.stroke;
      for (double x = 0; x < size.width; x += 40) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
      }
      for (double y = 0; y < size.height; y += 40) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
      }
      return;
    }

    final fill = Paint()..color = const Color(0xFF0EA5E9).withValues(alpha: 0.02)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.05), 130, fill);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.5), 100, fill);

    final grid = Paint()..color = const Color(0xFF0EA5E9).withValues(alpha: 0.01)..strokeWidth = 0.5..style = PaintingStyle.stroke;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
  }

  @override
  bool shouldRepaint(_BaytulmalPainter _) => false;
}
