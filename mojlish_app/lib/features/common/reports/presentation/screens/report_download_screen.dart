import 'package:flutter/material.dart';
import 'package:mojlish_app/core/services/pdf_export_service.dart';
import 'package:mojlish_app/features/common/reports/data/services/report_storage_service.dart';
import 'package:mojlish_app/features/common/reports/data/models/daily_personal_entry.dart';
import 'package:mojlish_app/features/common/reports/data/models/majlis_personal_report_config.dart';

/// Dedicated Full-Screen Page for Report Download & Selection
class ReportDownloadScreen extends StatefulWidget {
  final MajlisType majlisType;
  final int initialYear;
  final int initialMonth;

  const ReportDownloadScreen({
    super.key,
    required this.majlisType,
    required this.initialYear,
    required this.initialMonth,
  });

  @override
  State<ReportDownloadScreen> createState() => _ReportDownloadScreenState();
}

class _ReportDownloadScreenState extends State<ReportDownloadScreen> {
  late int _year;
  final Set<int> _selectedMonths = {};
  bool _isGenerating = false;
  bool _useCustomAddress = false;
  final TextEditingController _customAddressController = TextEditingController();

  static const _monthNames = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
  ];

  @override
  void initState() {
    super.initState();
    _year = widget.initialYear;
    _selectedMonths.add(widget.initialMonth);
  }

  @override
  void dispose() {
    _customAddressController.dispose();
    super.dispose();
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
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
      final config = MajlisPersonalReportConfig.getConfig(widget.majlisType);
      final sortedMonths = _selectedMonths.toList()..sort();
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

      await PdfExportService.printOrDownloadMultiMonthPdf(
        majlisName: config.name,
        title: config.subtitle,
        userName: 'রিপোর্ট প্রদানকারী',
        monthsData: monthsPdfDataList,
        logoAssetPath: config.logoPath,
        address: addressToUse,
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
      body: SingleChildScrollView(
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
                          color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _bn(_year),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
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
                        selectedColor: const Color(0xFF0284C7),
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
                          selectedColor: const Color(0xFF0284C7),
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
                          selectedColor: const Color(0xFF0284C7),
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
                    TextField(
                      controller: _customAddressController,
                      decoration: InputDecoration(
                        labelText: 'কাস্টম কার্যালয়ের ঠিকানা লিখুন',
                        hintText: 'যেমন: ঢাকা উত্তর শাখা কার্যালয়, মিরপুর-১০, ঢাকা',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 13.5, color: textColor),
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
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
