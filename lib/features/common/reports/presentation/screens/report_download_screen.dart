import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:mojlish_app/core/widgets/ambient_background_widget.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';
import 'package:mojlish_app/features/common/reports/data/models/daily_personal_entry.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';
import 'package:mojlish_app/features/common/reports/data/models/baytulmal_report_entry.dart';
import 'package:mojlish_app/features/common/reports/data/models/zonal_report_entry.dart';
import 'package:mojlish_app/features/common/reports/presentation/screens/pdf_preview_screen.dart';
import 'package:mojlish_app/features/khelafat_majlis/branch_report/data/services/khelafat_branch_report_pdf_service.dart';
import 'package:mojlish_app/features/khelafat_majlis/branch_plan/data/services/khelafat_branch_plan_pdf_service.dart';
import 'package:mojlish_app/features/khelafat_majlis/baytulmal_report/data/services/khelafat_baytulmal_pdf_service.dart';
import 'package:mojlish_app/features/khelafat_majlis/zonal_report/data/services/khelafat_zonal_pdf_service.dart';
import 'package:mojlish_app/features/student_majlis/period_report/data/services/student_period_pdf_service.dart';

/// Categories of report for dynamic header metadata fields
enum ReportCategory {
  personal,
  branchReport,
  branchPlan,
  baytulmalReport,
  zonalReport,
  studentPeriodReport,
}

/// Dedicated Full-Screen Page for Report Download & Selection
class ReportDownloadScreen extends StatefulWidget {
  final MajlisType majlisType;
  final int initialYear;
  final int initialMonth;
  final ReportCategory? reportCategory;

  const ReportDownloadScreen({
    super.key,
    required this.majlisType,
    required this.initialYear,
    required this.initialMonth,
    this.reportCategory,
  });

  @override
  State<ReportDownloadScreen> createState() => _ReportDownloadScreenState();
}

class _ReportDownloadScreenState extends State<ReportDownloadScreen> {
  late int _year;
  late ReportCategory _selectedCategory;
  final Set<int> _selectedMonths = {};
  bool _isGenerating = false;
  bool _useCustomAddress = false;
  final TextEditingController _customAddressController = TextEditingController();

  // Header info controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _presidentNameController = TextEditingController();
  final TextEditingController _sessionController = TextEditingController();
  final TextEditingController _treasurerNameController = TextEditingController();
  final TextEditingController _zoneNameController = TextEditingController();
  final TextEditingController _directorNameController = TextEditingController();

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
  ];

  @override
  void initState() {
    super.initState();
    _year = widget.initialYear;
    _selectedMonths.add(widget.initialMonth);
    _selectedCategory = widget.reportCategory ?? ReportCategory.personal;
  }

  @override
  void dispose() {
    _customAddressController.dispose();
    _nameController.dispose();
    _branchController.dispose();
    _presidentNameController.dispose();
    _sessionController.dispose();
    _treasurerNameController.dispose();
    _zoneNameController.dispose();
    _directorNameController.dispose();
    super.dispose();
  }

  Color get _categoryAccentColor {
    switch (_selectedCategory) {
      case ReportCategory.personal:
        return const Color(0xFF10B981);
      case ReportCategory.branchReport:
        return const Color(0xFF2563EB);
      case ReportCategory.branchPlan:
        return const Color(0xFF8B5CF6);
      case ReportCategory.baytulmalReport:
        return const Color(0xFFD97706);
      case ReportCategory.zonalReport:
        return const Color(0xFF0284C7);
      case ReportCategory.studentPeriodReport:
        return const Color(0xFF2563EB);
    }
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  String _formatMonthRange(List<int> sortedMonths) {
    if (sortedMonths.isEmpty) return '';
    if (sortedMonths.length == 1) return _monthNames[sortedMonths.first - 1];

    bool isConsecutive = true;
    for (int i = 0; i < sortedMonths.length - 1; i++) {
      if (sortedMonths[i + 1] != sortedMonths[i] + 1) {
        isConsecutive = false;
        break;
      }
    }
    if (isConsecutive) {
      return '${_monthNames[sortedMonths.first - 1]} - ${_monthNames[sortedMonths.last - 1]}';
    }
    if (sortedMonths.length == 2) {
      return '${_monthNames[sortedMonths[0] - 1]} ও ${_monthNames[sortedMonths[1] - 1]}';
    }
    final leading = sortedMonths.sublist(0, sortedMonths.length - 1).map((m) => _monthNames[m - 1]).join(', ');
    final last = _monthNames[sortedMonths.last - 1];
    return '$leading ও $last';
  }

  Map<String, String> _buildHeaderMetadata() {
    final Map<String, String> meta = {};
    switch (_selectedCategory) {
      case ReportCategory.personal:
        if (_nameController.text.trim().isNotEmpty) {
          meta['কর্মীর নাম'] = _nameController.text.trim();
        }
        if (_branchController.text.trim().isNotEmpty) {
          meta['শাখা'] = _branchController.text.trim();
        }
        break;
      case ReportCategory.branchReport:
      case ReportCategory.branchPlan:
        if (_branchController.text.trim().isNotEmpty) {
          meta['শাখা'] = _branchController.text.trim();
        }
        break;
      case ReportCategory.baytulmalReport:
        if (_branchController.text.trim().isNotEmpty) {
          meta['শাখা'] = _branchController.text.trim();
        }
        break;
      case ReportCategory.zonalReport:
        if (_zoneNameController.text.trim().isNotEmpty) {
          meta['জোন'] = _zoneNameController.text.trim();
        }
        break;
      case ReportCategory.studentPeriodReport:
        if (_branchController.text.trim().isNotEmpty) {
          meta['শাখা'] = _branchController.text.trim();
        }
        if (_sessionController.text.trim().isNotEmpty) {
          meta['সেশন'] = _sessionController.text.trim();
        }
        break;
    }
    return meta;
  }

  Future<void> _startPdfExport() async {
    if (_selectedMonths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('কমপক্ষে ১টি মাস নির্বাচন করুন'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final sortedMonths = _selectedMonths.toList()..sort();
      final monthRangeStr = _formatMonthRange(sortedMonths);

      switch (_selectedCategory) {
        case ReportCategory.branchReport:
          final pdf = pw.Document(
            theme: pw.ThemeData.withFont(
              base: await PdfExportService.loadSutonnyFont(),
              bold: await PdfExportService.loadBengaliBoldFont(),
            ),
          );
          for (final m in sortedMonths) {
            final branchData = await ReportStorageService.getBranchReport(_year, m);
            final mapData = Map<String, dynamic>.from(branchData ?? {});
            if (_branchController.text.trim().isNotEmpty) {
              mapData['shakhaName'] = _branchController.text.trim();
            }
            mapData['month'] = _monthNames[m - 1];
            mapData['year'] = _bn(_year);
            await KhelafatBranchReportPdfService.generatePdfBytes(mapData, pdfDocument: pdf);
          }
          final pdfBytes = await pdf.save();
          if (mounted) {
            await PdfPreviewScreen.open(
              context,
              pdfBytes,
              'শাখার রিপোর্ট — $monthRangeStr ${_bn(_year)}',
            );
          }
          return;

        case ReportCategory.branchPlan:
          final pdf = pw.Document(
            theme: pw.ThemeData.withFont(
              base: await PdfExportService.loadSutonnyFont(),
              bold: await PdfExportService.loadBengaliBoldFont(),
            ),
          );
          for (final m in sortedMonths) {
            final planData = await ReportStorageService.getBranchPlan(_year, m);
            await KhelafatBranchPlanPdfService.generatePdfBytes(
              shakhaName: _branchController.text.trim(),
              month: _monthNames[m - 1],
              year: _bn(_year),
              data: planData ?? {},
              pdfDocument: pdf,
            );
          }
          final pdfBytes = await pdf.save();
          if (mounted) {
            await PdfPreviewScreen.open(
              context,
              pdfBytes,
              'শাখা পরিকল্পনা — $monthRangeStr ${_bn(_year)}',
            );
          }
          return;

        case ReportCategory.baytulmalReport:
          final pdf = pw.Document(
            theme: pw.ThemeData.withFont(
              base: await PdfExportService.loadSutonnyFont(),
              bold: await PdfExportService.loadBengaliBoldFont(),
            ),
          );
          for (final m in sortedMonths) {
            final mapData = await ReportStorageService.getBaytulmalReport(_year, m);
            final entry = BaytulmalReportEntry.fromMap(mapData, _year, m).copyWith(
              branchName: _branchController.text.trim(),
              month: _monthNames[m - 1],
              year: _bn(_year),
            );
            await KhelafatBaytulmalPdfService.generatePdfBytes(entry: entry, pdfDocument: pdf);
          }
          final pdfBytes = await pdf.save();
          if (mounted) {
            await PdfPreviewScreen.open(
              context,
              pdfBytes,
              'বায়তুলমাল রিপোর্ট — $monthRangeStr ${_bn(_year)}',
            );
          }
          return;

        case ReportCategory.zonalReport:
          final pdf = pw.Document(
            theme: pw.ThemeData.withFont(
              base: await PdfExportService.loadSutonnyFont(),
              bold: await PdfExportService.loadBengaliBoldFont(),
            ),
          );
          for (final m in sortedMonths) {
            final mapData = await ReportStorageService.getZonalReport(_year, m);
            final entry = ZonalReportEntry.fromMap(mapData, _year, m).copyWith(
              zoneName: _zoneNameController.text.trim(),
              month: _monthNames[m - 1],
              year: _bn(_year),
            );
            await KhelafatZonalPdfService.generatePdfBytes(entry: entry, pdfDocument: pdf);
          }
          final pdfBytes = await pdf.save();
          if (mounted) {
            await PdfPreviewScreen.open(
              context,
              pdfBytes,
              'জোনাল রিপোর্ট — $monthRangeStr ${_bn(_year)}',
            );
          }
          return;

        case ReportCategory.studentPeriodReport:
          final pdfBytes = await StudentPeriodPdfService.generatePdfBytes(
            shakhaName: _branchController.text.trim(),
            periodName: _sessionController.text.trim().isNotEmpty ? _sessionController.text.trim() : monthRangeStr,
            data: {},
          );
          if (mounted) {
            await PdfPreviewScreen.open(
              context,
              pdfBytes,
              'মেয়াদী রিপোর্ট — $monthRangeStr',
            );
          }
          return;

        case ReportCategory.personal:
          break;
      }

      final config = MajlisPersonalReportConfig.getConfig(widget.majlisType);
      final allEntries = await ReportStorageService.getAllPersonalEntries();
      final List<MonthReportPdfData> monthsPdfDataList = [];

      final headers = ['তাং', ...config.columns.map((c) => c.title)];

      for (final month in sortedMonths) {
        final monthName = _monthNames[month - 1];
        final daysInMonth = DateTime(_year, month + 1, 0).day;
        final monthEntries = <String, DailyPersonalEntry>{};

        for (final e in allEntries.entries) {
          try {
            final d = DateTime.parse(e.key);
            if (d.year == _year && d.month == month) {
              monthEntries[e.key] = e.value;
            }
          } catch (_) {}
        }

        final List<List<String>> tableData = [];
        for (int day = 1; day <= daysInMonth; day++) {
          final dateStr = '$_year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
          final entry = monthEntries[dateStr];
          final dayBn = _bn(day).padLeft(2, '০');
          final List<String> row = [dayBn];

          for (final col in config.columns) {
            if (entry == null) {
              row.add(col.id == 'atmo' ? 'হ্যাঁ / না' : '');
            } else {
              switch (col.id) {
                case 'quran':
                  final val = (entry.quranSura.isNotEmpty || entry.quranAyah.isNotEmpty)
                      ? '${entry.quranSura} ${entry.quranAyah}'.trim()
                      : entry.quranStudy;
                  row.add(val);
                  break;
                case 'hadith':
                  final val = (entry.hadithCount.isNotEmpty || entry.hadithTopic.isNotEmpty)
                      ? '${entry.hadithCount} ${entry.hadithTopic}'.trim()
                      : entry.hadithStudy;
                  row.add(val);
                  break;
                case 'literature':
                  final val = (entry.islamicLitBook.isNotEmpty || entry.islamicLitPages.isNotEmpty)
                      ? '${entry.islamicLitBook} ${entry.islamicLitPages}'.trim()
                      : entry.islamicLiterature;
                  row.add(val);
                  break;
                case 'textbook':
                  row.add(entry.textbookHours.isNotEmpty ? entry.textbookHours : entry.textbookStudy);
                  break;
                case 'jamaat':
                  row.add(entry.jamaatPrayer);
                  break;
                case 'contact':
                case 'kormi_contact':
                  final val = (entry.contactCount.isNotEmpty || entry.contactName.isNotEmpty)
                      ? '${entry.contactCount} ${entry.contactName}'.trim()
                      : entry.contact;
                  row.add(val);
                  break;
                case 'dawat':
                case 'dawat_contact':
                  final val = (entry.memberContactCount.isNotEmpty || entry.memberContactName.isNotEmpty)
                      ? '${entry.memberContactCount} ${entry.memberContactName}'.trim()
                      : entry.dawah;
                  row.add(val);
                  break;
                case 'dawat_materials':
                  row.add(entry.dawahMaterials);
                  break;
                case 'meeting':
                  row.add(entry.meetingName);
                  break;
                case 'time':
                case 'sanghotonik_time':
                  final val = entry.orgTime.isNotEmpty ? entry.orgTime : entry.timeService;
                  row.add(val);
                  break;
                case 'job_business':
                  row.add(entry.jobBusinessTime);
                  break;
                case 'social':
                  row.add(entry.socialService);
                  break;
                case 'newspaper':
                  row.add(entry.newspaperTime);
                  break;
                case 'exercise':
                  row.add(entry.physicalExerciseTime);
                  break;
                case 'family_social':
                  row.add(entry.familyWelfareTime);
                  break;
                case 'atmo':
                  row.add(entry.selfAnalysis.isNotEmpty ? entry.selfAnalysis : 'হ্যাঁ / না');
                  break;
                default:
                  row.add('');
              }
            }
          }
          tableData.add(row);
        }

        // Add Total Row matching original form image
        final totalRow = ['মোট'];
        for (int i = 1; i < headers.length; i++) {
          if (headers[i].contains('কোরআন') || headers[i].contains('হাদীস')) {
            totalRow.add('/');
          } else {
            totalRow.add('');
          }
        }
        tableData.add(totalRow);

        monthsPdfDataList.add(
          MonthReportPdfData(
            year: _year,
            month: month,
            monthName: monthName,
            headers: headers,
            tableData: tableData,
            filledDays: monthEntries.length,
            totalDays: daysInMonth,
            comments: config.footerNotes.isNotEmpty ? config.footerNotes.first : null,
          ),
        );
      }

      final addressToUse = _useCustomAddress && _customAddressController.text.trim().isNotEmpty
          ? _customAddressController.text.trim()
          : config.address;

      final headerMetadata = _buildHeaderMetadata();
      final userNameToUse = _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : _presidentNameController.text.trim().isNotEmpty
              ? _presidentNameController.text.trim()
              : _directorNameController.text.trim().isNotEmpty
                  ? _directorNameController.text.trim()
                  : _treasurerNameController.text.trim().isNotEmpty
                      ? _treasurerNameController.text.trim()
                      : 'রিপোর্ট প্রদানকারী';

      if (!mounted) return;

      await PdfExportService.printOrDownloadMultiMonthPdf(
        majlisName: config.name,
        title: config.subtitle,
        userName: userNameToUse,
        monthsData: monthsPdfDataList,
        logoAssetPath: config.logoPath,
        address: addressToUse,
        headerMetadata: headerMetadata,
        context: context,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('পিডিএফ এক্সপোর্ট করা হয়েছে'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('পিডিএফ তৈরিতে সমস্যা হয়েছে: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Widget _buildHeaderInfoCard(Color cardBg, Color borderColor, Color textColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'রিপোর্ট হেডার ও তথ্যাবলী',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 12),
          _buildCategoryInputFields(textColor, isDark),
        ],
      ),
    );
  }

  Widget _buildCategoryInputFields(Color textColor, bool isDark) {
    switch (_selectedCategory) {
      case ReportCategory.personal:
        return Column(
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'কর্মীর নাম',
              hintText: 'যেমন: আব্দুল্লাহ',
              textColor: textColor,
              isDark: isDark,
              prefixIcon: Icon(Icons.person_outline_rounded, size: 18, color: _categoryAccentColor),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _branchController,
              label: 'শাখা',
              hintText: 'যেমন: ঢাকা উত্তর শাখা',
              textColor: textColor,
              isDark: isDark,
              prefixIcon: Icon(Icons.business_outlined, size: 18, color: _categoryAccentColor),
            ),
          ],
        );
      case ReportCategory.branchReport:
      case ReportCategory.branchPlan:
        return Column(
          children: [
            _buildTextField(
              controller: _branchController,
              label: 'শাখার নাম',
              hintText: 'যেমন: মিরপুর শাখা',
              textColor: textColor,
              isDark: isDark,
              prefixIcon: Icon(Icons.business_outlined, size: 18, color: _categoryAccentColor),
            ),
          ],
        );
      case ReportCategory.baytulmalReport:
        return Column(
          children: [
            _buildTextField(
              controller: _branchController,
              label: 'শাখার নাম',
              hintText: 'যেমন: মিরপুর শাখা',
              textColor: textColor,
              isDark: isDark,
              prefixIcon: Icon(Icons.business_outlined, size: 18, color: _categoryAccentColor),
            ),
          ],
        );
      case ReportCategory.zonalReport:
        return Column(
          children: [
            _buildTextField(
              controller: _zoneNameController,
              label: 'জোনের নাম',
              hintText: 'যেমন: ঢাকা উত্তর জোন',
              textColor: textColor,
              isDark: isDark,
              prefixIcon: Icon(Icons.business_outlined, size: 18, color: _categoryAccentColor),
            ),
          ],
        );
      case ReportCategory.studentPeriodReport:
        return Column(
          children: [
            _buildTextField(
              controller: _branchController,
              label: 'শাখার নাম',
              hintText: 'যেমন: মিরপুর শাখা',
              textColor: textColor,
              isDark: isDark,
              prefixIcon: Icon(Icons.business_outlined, size: 18, color: _categoryAccentColor),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _sessionController,
              label: 'সেশন / মেয়াদ',
              hintText: 'যেমন: ২০২৫-২০২৬',
              textColor: textColor,
              isDark: isDark,
              prefixIcon: Icon(Icons.date_range_outlined, size: 18, color: _categoryAccentColor),
            ),
          ],
        );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required Color textColor,
    required bool isDark,
    Widget? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              fontSize: 13,
            ),
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: isDark
                ? const Color(0xFF0F172A).withValues(alpha: 0.7)
                : const Color(0xFFF1F5F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _categoryAccentColor,
                width: 1.8,
              ),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          style: TextStyle(fontSize: 13.5, color: textColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'রিপোর্ট ডাউনলোড',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
      body: AmbientBackgroundWidget(
        primaryAccent: _categoryAccentColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Year Selector Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('বছর নির্বাচন', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left_rounded, size: 24),
                          onPressed: () => setState(() => _year--),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: _categoryAccentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _bn(_year),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _categoryAccentColor),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right_rounded, size: 24),
                          onPressed: () => setState(() => _year++),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Month Selection Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'মাস নির্বাচন (${_selectedMonths.length} টি মাস)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedMonths.addAll(List.generate(12, (i) => i + 1));
                                });
                              },
                              child: const Text('সবগুলো', style: TextStyle(fontSize: 12.5)),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() => _selectedMonths.clear());
                              },
                              child: const Text('মুছুন', style: TextStyle(fontSize: 12.5, color: Colors.redAccent)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(12, (index) {
                        final m = index + 1;
                        final isSelected = _selectedMonths.contains(m);
                        return ChoiceChip(
                          label: Text(_monthNames[index]),
                          selected: isSelected,
                          selectedColor: _categoryAccentColor,
                          labelStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : textColor,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedMonths.add(m);
                              } else {
                                _selectedMonths.remove(m);
                              }
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Report Header & Metadata Information Card
              _buildHeaderInfoCard(cardBg, borderColor, textColor, isDark),
              const SizedBox(height: 16),

              // Address Selection Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'পিডিএফ হেডার ঠিকানা নির্বাচন',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('কেন্দ্রীয় কার্যালয়'),
                            selected: !_useCustomAddress,
                            selectedColor: _categoryAccentColor,
                            labelStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: !_useCustomAddress ? FontWeight.bold : FontWeight.normal,
                              color: !_useCustomAddress ? Colors.white : textColor,
                            ),
                            onSelected: (val) {
                              if (val) setState(() => _useCustomAddress = false);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('কাস্টম ঠিকানা'),
                            selected: _useCustomAddress,
                            selectedColor: _categoryAccentColor,
                            labelStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: _useCustomAddress ? FontWeight.bold : FontWeight.normal,
                              color: _useCustomAddress ? Colors.white : textColor,
                            ),
                            onSelected: (val) {
                              if (val) setState(() => _useCustomAddress = true);
                            },
                          ),
                        ),
                      ],
                    ),
                    if (_useCustomAddress) ...[
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _customAddressController,
                        label: 'কাস্টম কার্যালয়ের ঠিকানা লিখুন',
                        hintText: 'যেমন: ঢাকা উত্তর শাখা কার্যালয়, মিরপুর-১০, ঢাকা',
                        textColor: textColor,
                        isDark: isDark,
                        prefixIcon: Icon(Icons.location_on_outlined, size: 18, color: _categoryAccentColor),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Minimalist Action Download Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isGenerating ? null : _startPdfExport,
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.picture_as_pdf_rounded, size: 22),
                  label: Text(
                    _isGenerating ? 'পিডিএফ তৈরি হচ্ছে...' : 'পিডিএফ ডাউনলোড করুন',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _categoryAccentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
