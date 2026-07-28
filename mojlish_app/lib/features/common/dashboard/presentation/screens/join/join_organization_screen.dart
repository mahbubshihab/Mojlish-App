import 'package:flutter/material.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import '../../../../../core/theme/app_theme.dart';
import 'package:mojlish_app/features/common/reports/shared/data/services/pdf_generator_service.dart';

class JoinOrganizationScreen extends StatefulWidget {
  const JoinOrganizationScreen({super.key});

  @override
  State<JoinOrganizationScreen> createState() => _JoinOrganizationScreenState();
}

class _JoinOrganizationScreenState extends State<JoinOrganizationScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers
  final _nameCtrl = TextEditingController();
  final _fatherNameCtrl = TextEditingController();
  final _nidCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _joinDateCtrl = TextEditingController();
  final _fbCtrl = TextEditingController();

  // Address
  final _currentAddrCtrl = TextEditingController();
  final _villageCtrl = TextEditingController();
  final _unionCtrl = TextEditingController();
  final _thanaCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();

  String _bloodGroup = 'O+';
  bool _oathAccepted = false;
  bool _isSubmitted = false;

  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _joinDateCtrl.text = '${now.day}/${now.month}/${now.year}';
  }

  @override
  void dispose() {
    for (final ctrl in [
      _nameCtrl,
      _fatherNameCtrl,
      _nidCtrl,
      _phoneCtrl,
      _emailCtrl,
      _joinDateCtrl,
      _fbCtrl,
      _currentAddrCtrl,
      _villageCtrl,
      _unionCtrl,
      _thanaCtrl,
      _districtCtrl
    ]) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_oathAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('অনুগ্রহ করে শপথ ও ঘোষণাটি স্বীকার করুন।', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
      setState(() {
        _isSubmitted = true;
      });
      _showMembershipCard();
    }
  }

  void _showMembershipCard() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final isDark = themeManager.isDarkMode;
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
        final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
        final mutedColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        final cardBorder = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);
        const goldAccent = Color(0xFFD4AF37); // Classic Membership Gold Color

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 600),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: goldAccent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gold Ribbon / Banner Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: const BoxDecoration(
                      color: goldAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13),
                        topRight: Radius.circular(13),
                      ),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'সদস্য কার্ড ও আবেদন রিসিট',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'ইসলামী যুব মজলিস',
                          style: TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Left Slip / Counter Slip Simulation (Dashed line)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: cardBorder),
                            borderRadius: BorderRadius.circular(8),
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('কাউন্টার স্লিপ (অফিস কপি)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: goldAccent)),
                                  Text('ফরম নং: ${_bn(2839)}', style: TextStyle(fontSize: 11, color: mutedColor)),
                                ],
                              ),
                              const Divider(height: 16),
                              _cardRow('নাম:', _nameCtrl.text, textColor, mutedColor),
                              _cardRow('পিতা:', _fatherNameCtrl.text, textColor, mutedColor),
                              _cardRow('মোবাইল:', _phoneCtrl.text, textColor, mutedColor),
                              _cardRow('রক্তের গ্রুপ:', _bloodGroup, textColor, mutedColor),
                              _cardRow('তারিখ:', _joinDateCtrl.text, textColor, mutedColor),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Dashed divider line
                        Row(
                          children: List.generate(
                            30,
                            (index) => Expanded(
                              child: Container(
                                color: index % 2 == 0 ? Colors.transparent : mutedColor.withValues(alpha: 0.4),
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Main Golden Membership Card
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            border: Border.all(color: goldAccent, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [const Color(0xFF1B263B), const Color(0xFF0D1B2A)]
                                  : [Colors.white, const Color(0xFFF0F4F8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 18,
                                    backgroundColor: goldAccent,
                                    child: Icon(Icons.shield, color: Colors.black, size: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('সদস্য পরিচিতি কার্ড', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
                                        const Text('বাংলাদেশ ইসলামী যুব মজলিস', style: TextStyle(fontSize: 9, color: goldAccent, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(color: goldAccent, height: 18, thickness: 1),
                              _cardRow('সদস্যের নাম:', _nameCtrl.text, textColor, mutedColor),
                              _cardRow('পিতার নাম:', _fatherNameCtrl.text, textColor, mutedColor),
                              _cardRow('মোবাইল:', _phoneCtrl.text, textColor, mutedColor),
                              _cardRow('ইমেইল:', _emailCtrl.text.isEmpty ? '-' : _emailCtrl.text, textColor, mutedColor),
                              _cardRow('স্থায়ী জেলা:', _districtCtrl.text, textColor, mutedColor),
                              _cardRow('রক্তের গ্রুপ:', _bloodGroup, Colors.redAccent, mutedColor, isBoldValue: true),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 1,
                                        color: mutedColor.withValues(alpha: 0.6),
                                      ),
                                      const SizedBox(height: 4),
                                      Text('আবেদনকারীর স্বাক্ষর', style: TextStyle(fontSize: 8, color: mutedColor)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 1,
                                        color: mutedColor.withValues(alpha: 0.6),
                                      ),
                                      const SizedBox(height: 4),
                                      Text('শাখা সভাপতি স্বাক্ষর', style: TextStyle(fontSize: 8, color: mutedColor)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Bottom Actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, size: 16),
                            label: const Text('বন্ধ করুন'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: textColor,
                              side: BorderSide(color: cardBorder),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await PdfGeneratorService.generateMembershipPdf(
                                name: _nameCtrl.text.trim(),
                                fatherName: _fatherNameCtrl.text.trim(),
                                nidNo: _nidCtrl.text.trim(),
                                bloodGroup: _bloodGroup,
                                phone: _phoneCtrl.text.trim(),
                                email: _emailCtrl.text.trim(),
                                currentAddress: _currentAddrCtrl.text.trim(),
                                village: _villageCtrl.text.trim(),
                                union: _unionCtrl.text.trim(),
                                thana: _thanaCtrl.text.trim(),
                                district: _districtCtrl.text.trim(),
                                joinDate: _joinDateCtrl.text.trim(),
                                fbLink: _fbCtrl.text.trim(),
                              );
                            },
                            icon: const Icon(Icons.picture_as_pdf, color: Colors.black, size: 16),
                            label: const Text('পিডিএফ ডাউনলোড', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: goldAccent,
                            ),
                          ),
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
    );
  }

  Widget _cardRow(String label, String value, Color textColor, Color labelColor, {bool isBoldValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: TextStyle(color: labelColor, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _bn(int n) {
    const digits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;

        // Dynamic theme colors
        final bg = isDark ? AppTheme.darkBg : const Color(0xFFF8FAFC);
        final appBarBg = isDark ? AppTheme.darkCardBg : Colors.white;
        final cardBg = isDark ? AppTheme.darkCardBg : Colors.white;
        final borderColor = isDark ? AppTheme.darkBorder : const Color(0xFFE2E8F0);
        final textLight = isDark ? AppTheme.darkTextLight : const Color(0xFF0F172A);
        final textMuted = isDark ? AppTheme.darkTextMuted : const Color(0xFF64748B);
        final primary = AppTheme.primaryColor;

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: textLight, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'সদস্য ফরম',
              style: TextStyle(color: textLight, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.wb_sunny : Icons.nightlight_round,
                  color: isDark ? Colors.yellow : Colors.black87,
                ),
                onPressed: () => themeManager.toggleTheme(),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: primary,
                  primary: primary,
                  surface: bg,
                ),
              ),
              child: Stepper(
                type: StepperType.vertical,
                currentStep: _currentStep,
                onStepTapped: (step) => setState(() => _currentStep = step),
                onStepContinue: () {
                  if (_currentStep < 2) {
                    setState(() => _currentStep += 1);
                  } else {
                    _submitForm();
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep -= 1);
                  }
                },
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          style: ElevatedButton.styleFrom(backgroundColor: primary),
                          child: Text(
                            _currentStep == 2 ? 'আবেদন জমা দিন' : 'পরবর্তী',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (_currentStep > 0)
                          OutlinedButton(
                            onPressed: details.onStepCancel,
                            child: Text('পূর্ববর্তী', style: TextStyle(color: textLight)),
                          ),
                      ],
                    ),
                  );
                },
                steps: [
                  // Step 1: Personal Info
                  Step(
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0 ? StepState.complete : StepState.editing,
                    title: Text('ব্যক্তিগত তথ্য', style: TextStyle(color: textLight, fontWeight: FontWeight.bold)),
                    content: Column(
                      children: [
                        _buildField('পূর্ণ নাম', Icons.person, _nameCtrl, textLight, textMuted, borderColor, primary),
                        const SizedBox(height: 12),
                        _buildField('পিতার নাম', Icons.face, _fatherNameCtrl, textLight, textMuted, borderColor, primary),
                        const SizedBox(height: 12),
                        _buildField('জাতীয় পরিচয়পত্র (NID) নম্বর', Icons.credit_card, _nidCtrl, textLight, textMuted, borderColor, primary, keyboardType: TextInputType.number),
                        const SizedBox(height: 12),
                        _buildBloodGroupDropdown(textLight, textMuted, borderColor, primary),
                        const SizedBox(height: 12),
                        _buildField('মোবাইল নাম্বার', Icons.phone, _phoneCtrl, textLight, textMuted, borderColor, primary, keyboardType: TextInputType.phone),
                        const SizedBox(height: 12),
                        _buildField('ইমেইল ঠিকানা (অপশনাল)', Icons.email, _emailCtrl, textLight, textMuted, borderColor, primary, isOptional: true, keyboardType: TextInputType.emailAddress),
                      ],
                    ),
                  ),
                  
                  // Step 2: Address Info
                  Step(
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1 ? StepState.complete : _currentStep == 1 ? StepState.editing : StepState.disabled,
                    title: Text('ঠিকানা', style: TextStyle(color: textLight, fontWeight: FontWeight.bold)),
                    content: Column(
                      children: [
                        _buildField('বর্তমান ঠিকানা', Icons.home, _currentAddrCtrl, textLight, textMuted, borderColor, primary, maxLines: 2),
                        const SizedBox(height: 14),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('স্থায়ী ঠিকানা:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF10B981))),
                        ),
                        const SizedBox(height: 8),
                        _buildField('গ্রাম/মহল্লা', Icons.location_city, _villageCtrl, textLight, textMuted, borderColor, primary),
                        const SizedBox(height: 12),
                        _buildField('ইউনিয়ন/ওয়ার্ড', Icons.view_headline, _unionCtrl, textLight, textMuted, borderColor, primary),
                        const SizedBox(height: 12),
                        _buildField('থানা ও উপজেলা', Icons.layers, _thanaCtrl, textLight, textMuted, borderColor, primary),
                        const SizedBox(height: 12),
                        _buildField('জেলা', Icons.map, _districtCtrl, textLight, textMuted, borderColor, primary),
                      ],
                    ),
                  ),

                  // Step 3: Oath and Submit
                  Step(
                    isActive: _currentStep >= 2,
                    state: _isSubmitted ? StepState.complete : _currentStep == 2 ? StepState.editing : StepState.disabled,
                    title: Text('শপথ ও ঘোষণা', style: TextStyle(color: textLight, fontWeight: FontWeight.bold)),
                    content: Column(
                      children: [
                        _buildField('যোগদানের তারিখ', Icons.calendar_today, _joinDateCtrl, textLight, textMuted, borderColor, primary),
                        const SizedBox(height: 12),
                        _buildField('ফেসবুক লিংক (অপশনাল)', Icons.link, _fbCtrl, textLight, textMuted, borderColor, primary, isOptional: true),
                        const SizedBox(height: 16),
                        
                        // Interactive Oath Paper Card
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1A2E44) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF10B981), width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.shield_outlined, color: Color(0xFF10B981), size: 20),
                                  SizedBox(width: 6),
                                  Text('শপথ ও ঘোষণা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF34D399))),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '“আমি দৃঢ়ভাবে বিশ্বাস করি যে, ইসলামই আল্লাহর একমাত্র মনোনীত জীবনব্যবস্থা। ইসলামী আদর্শের আলোকে যুবসমাজের নেতৃত্বে একটি কল্যাণমুখী সমাজ গড়ার লক্ষ্যে ইসলামী যুব মজলিসের সাথে একমত হয়ে এ সংগঠনে যোগদান করছি। আমি এ লক্ষ্য অর্জনে যথাসাধ্য চেষ্টা করব ইনশাআল্লাহ।”',
                                style: TextStyle(fontSize: 12, color: textLight, height: 1.5, fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        CheckboxListTile(
                          value: _oathAccepted,
                          onChanged: (val) => setState(() => _oathAccepted = val ?? false),
                          activeColor: const Color(0xFF10B981),
                          checkColor: Colors.white,
                          title: Text(
                            'আমি শপথটি সতর্কতার সাথে পাঠ করেছি এবং এর সাথে একমত পোষণ করছি।',
                            style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.bold),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        
                        if (_isSubmitted) ...[
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _showMembershipCard,
                              icon: const Icon(Icons.credit_card, color: Colors.white),
                              label: const Text('আপনার মেম্বারশিপ কার্ড দেখুন', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD4AF37), // Golden Accent
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBloodGroupDropdown(Color textLight, Color textMuted, Color borderColor, Color primary) {
    final isDark = themeManager.isDarkMode;
    final fill = isDark ? const Color(0xFF0F172A) : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'রক্তের গ্রুপ',
          style: TextStyle(color: textMuted, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _bloodGroup,
          items: _bloodGroups.map((g) => DropdownMenuItem(value: g, child: Text(g, style: TextStyle(color: textLight)))).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _bloodGroup = val);
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.bloodtype, color: Colors.redAccent),
            filled: true,
            fillColor: fill,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    String label,
    IconData icon,
    TextEditingController ctrl,
    Color textLight,
    Color textMuted,
    Color borderColor,
    Color primary, {
    TextInputType keyboardType = TextInputType.text,
    bool isOptional = false,
    int maxLines = 1,
  }) {
    final isDark = themeManager.isDarkMode;
    final fill = isDark ? const Color(0xFF0F172A) : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isOptional ? '$label (ঐচ্ছিক)' : label,
          style: TextStyle(color: textMuted, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(color: textLight, fontSize: 14),
          validator: (val) {
            if (isOptional) return null;
            if (val == null || val.trim().isEmpty) return 'এই তথ্যটি আবশ্যক';
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: primary, size: 20),
            filled: true,
            fillColor: fill,
            hintText: '$label লিখুন',
            hintStyle: const TextStyle(color: Color(0xFF4A5568), fontSize: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}
