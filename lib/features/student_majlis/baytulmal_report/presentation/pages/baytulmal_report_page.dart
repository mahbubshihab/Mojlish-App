import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/baytulmal_report_bloc.dart';
import '../bloc/baytulmal_report_event.dart';
import '../bloc/baytulmal_report_state.dart';

class BaytulmalReportPage extends StatefulWidget {
  final String? initialMonth;
  final String? initialSession;

  const BaytulmalReportPage({
    Key? key,
    this.initialMonth,
    this.initialSession,
  }) : super(key: key);

  @override
  _BaytulmalReportPageState createState() => _BaytulmalReportPageState();
}

class _BaytulmalReportPageState extends State<BaytulmalReportPage> {
  final _formKey = GlobalKey<FormState>();

  // Header
  final _branchController = TextEditingController();
  final _monthController = TextEditingController();
  final _sessionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialMonth != null) {
      _monthController.text = widget.initialMonth!;
    }
    if (widget.initialSession != null) {
      _sessionController.text = widget.initialSession!;
    }
  }

  // Income
  final _jonoshoktiIyanotController = TextEditingController();
  final _shakhaIyanotController = TextEditingController();
  final _shuvakangkhiIyanotController = TextEditingController();
  final _ekkalinAyController = TextEditingController();
  final _motAyInWordsController = TextEditingController();
  final _bigotoSeshonMasherUdbrittoController = TextEditingController();

  // Expenditure
  final _urdhotonIyanotPorishodhController = TextEditingController();
  final _urdhotonSoforController = TextEditingController();
  final _officeController = TextEditingController();
  final _jatayatController = TextEditingController();
  final _jogajogController = TextEditingController();
  final _procharController = TextEditingController();
  final _bigotoSeshonMasherGhattiController = TextEditingController();
  final _motBayInWordsController = TextEditingController();
  final _presidentSignatureController = TextEditingController();
  bool _isSubmitting = false;
  bool _isLocked = false;

  void _openPdfViewer() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF ডাউনলোড প্রস্তুত করা হচ্ছে...'),
        backgroundColor: Color(0xFF0284C7),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('বায়তুলমাল রিপোর্ট'),
      ),
      body: BlocListener<BaytulmalReportBloc, BaytulmalReportState>(
        listener: (context, state) {
          if (state is BaytulmalReportSuccess) {
            setState(() {
              _isSubmitting = false;
              _isLocked = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('রিপোর্ট সফলভাবে জমা দেওয়া হয়েছে!')),
            );
            Navigator.pop(context);
          } else if (state is BaytulmalReportFailure) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ব্যর্থ হয়েছে: ${state.error}')),
            );
          }
        },
        child: Column(
          children: [
            // 📌 Sticky Top Action Bar (Does NOT scroll!)
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF10B981)]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: _isSubmitting
                              ? null
                              : () {
                                  if (_isLocked) {
                                    setState(() => _isLocked = false);
                                  } else {
                                    _submitForm();
                                  }
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _isSubmitting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : Icon(_isLocked ? Icons.edit_note_rounded : Icons.save_rounded, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                _isLocked ? 'এডিট করুন' : 'সংরক্ষণ করুন',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF0284C7), Color(0xFF38BDF8)]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: _openPdfViewer,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.file_download_outlined, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'PDF ডাউনলোড',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 📜 Form Content (Scrolls under the sticky top bar)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeaderSection(),
                      const SizedBox(height: 24),
                      _buildIncomeSection(),
                      const SizedBox(height: 24),
                      _buildExpenditureSection(),
                      const SizedBox(height: 24),
                      _buildSignatureSection(),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('জমা দিন'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('সাধারণ তথ্য', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _branchController,
              decoration: const InputDecoration(labelText: 'শাখা'),
              validator: (val) => val!.isEmpty ? 'প্রয়োজনীয়' : null,
            ),
            TextFormField(
              controller: _monthController,
              decoration: const InputDecoration(labelText: 'মাস'),
            ),
            TextFormField(
              controller: _sessionController,
              decoration: const InputDecoration(labelText: 'সেশন'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('আয়', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildAmountField('জনশক্তি ইয়ানত', _jonoshoktiIyanotController),
            _buildAmountField('শাখা ইয়ানত', _shakhaIyanotController),
            _buildAmountField('শুভাকাঙ্ক্ষী ইয়ানত', _shuvakangkhiIyanotController),
            _buildAmountField('এককালীন আয়', _ekkalinAyController),
            _buildAmountField('বিগত সেশন/মাসের উদ্বৃত্ত', _bigotoSeshonMasherUdbrittoController),
            TextFormField(
              controller: _motAyInWordsController,
              decoration: const InputDecoration(labelText: 'কথায়'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenditureSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('ব্যয়', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildAmountField('উর্ধ্বতন ইয়ানত পরিশোধ', _urdhotonIyanotPorishodhController),
            _buildAmountField('উর্ধ্বতন সফর', _urdhotonSoforController),
            _buildAmountField('অফিস', _officeController),
            _buildAmountField('যাতায়াত', _jatayatController),
            _buildAmountField('যোগাযোগ', _jogajogController),
            _buildAmountField('প্রচার', _procharController),
            _buildAmountField('বিগত সেশন/মাসের ঘাটতি', _bigotoSeshonMasherGhattiController),
            TextFormField(
              controller: _motBayInWordsController,
              decoration: const InputDecoration(labelText: 'কথায়'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: _presidentSignatureController,
          decoration: const InputDecoration(labelText: 'সভাপতির স্বাক্ষর'),
        ),
      ),
    );
  }

  Widget _buildAmountField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      double parseAmount(TextEditingController ctrl) {
        if (ctrl.text.isEmpty) return 0.0;
        return double.tryParse(ctrl.text) ?? 0.0;
      }

      final double jonoshokti = parseAmount(_jonoshoktiIyanotController);
      final double shakha = parseAmount(_shakhaIyanotController);
      final double shuvakangkhi = parseAmount(_shuvakangkhiIyanotController);
      final double ekkalin = parseAmount(_ekkalinAyController);
      final double udbritto = parseAmount(_bigotoSeshonMasherUdbrittoController);

      final double motAy = jonoshokti + shakha + shuvakangkhi + ekkalin;
      final double sorbomotAy = motAy + udbritto;

      final double urdhoton = parseAmount(_urdhotonIyanotPorishodhController);
      final double sofor = parseAmount(_urdhotonSoforController);
      final double office = parseAmount(_officeController);
      final double jatayat = parseAmount(_jatayatController);
      final double jogajog = parseAmount(_jogajogController);
      final double prochar = parseAmount(_procharController);
      final double ghatti = parseAmount(_bigotoSeshonMasherGhattiController);

      final double motBay = urdhoton + sofor + office + jatayat + jogajog + prochar;
      final double sorbomotBay = motBay + ghatti;
      final double udbrittoBaGhatti = sorbomotAy - sorbomotBay;

      final Map<String, dynamic> reportData = {
        'branch': _branchController.text,
        'month': _monthController.text,
        'session': _sessionController.text,
        'jonoshoktiIyanot': jonoshokti,
        'shakhaIyanot': shakha,
        'shuvakangkhiIyanot': shuvakangkhi,
        'ekkalinAy': ekkalin,
        'motAy': motAy,
        'bigotoSeshonMasherUdbritto': udbritto,
        'sorbomotAy': sorbomotAy,
        'motAyInWords': _motAyInWordsController.text,
        'urdhotonIyanotPorishodh': urdhoton,
        'urdhotonSofor': sofor,
        'office': office,
        'jatayat': jatayat,
        'jogajog': jogajog,
        'prochar': prochar,
        'motBay': motBay,
        'bigotoSeshonMasherGhatti': ghatti,
        'sorbomotBay': sorbomotBay,
        'udbrittoBaGhatti': udbrittoBaGhatti,
        'motBayInWords': _motBayInWordsController.text,
        'presidentSignature': _presidentSignatureController.text,
      };

      context.read<BaytulmalReportBloc>().add(SubmitBaytulmalReport(reportData));
    }
  }

  @override
  void dispose() {
    _branchController.dispose();
    _monthController.dispose();
    _sessionController.dispose();
    _jonoshoktiIyanotController.dispose();
    _shakhaIyanotController.dispose();
    _shuvakangkhiIyanotController.dispose();
    _ekkalinAyController.dispose();
    _motAyInWordsController.dispose();
    _bigotoSeshonMasherUdbrittoController.dispose();
    _urdhotonIyanotPorishodhController.dispose();
    _urdhotonSoforController.dispose();
    _officeController.dispose();
    _jatayatController.dispose();
    _jogajogController.dispose();
    _procharController.dispose();
    _bigotoSeshonMasherGhattiController.dispose();
    _motBayInWordsController.dispose();
    _presidentSignatureController.dispose();
    super.dispose();
  }
}
