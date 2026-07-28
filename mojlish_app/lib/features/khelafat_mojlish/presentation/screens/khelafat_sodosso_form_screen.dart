import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import '../../data/models/khelafat_sodosso_model.dart';

/// খেলাফত মজলিস প্রাথমিক সদস্য ফরম ও ডিজিটাল সদস্যপদ আবেদন স্ক্রিন
class KhelafatSodossoFormScreen extends StatefulWidget {
  const KhelafatSodossoFormScreen({super.key});

  @override
  State<KhelafatSodossoFormScreen> createState() => _KhelafatSodossoFormScreenState();
}

class _KhelafatSodossoFormScreenState extends State<KhelafatSodossoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _fatherNameCtrl = TextEditingController();
  final _qualificationCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _occupationCtrl = TextEditingController();
  final _presentAddressCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _permanentAddressCtrl = TextEditingController();

  bool _acceptedPledge = false;
  List<KhelafatSodossoModel> _savedMembers = [];
  static const String _storageKey = 'khelafat_sodosso_members';

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr != null) {
      final List decoded = jsonDecode(jsonStr);
      setState(() {
        _savedMembers = decoded.map((item) => KhelafatSodossoModel.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedPledge) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('অনুগ্রহ করে অঙ্গীকারনামায় সম্মত হন।'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newMember = KhelafatSodossoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      fatherName: _fatherNameCtrl.text.trim(),
      educationalQualification: _qualificationCtrl.text.trim(),
      age: int.tryParse(_ageCtrl.text.trim()) ?? 0,
      occupation: _occupationCtrl.text.trim(),
      presentAddress: _presentAddressCtrl.text.trim(),
      mobileNo: _mobileCtrl.text.trim(),
      permanentAddress: _permanentAddressCtrl.text.trim(),
      applicationDate: DateTime.now().toString().split(' ')[0],
      acceptedPledge: _acceptedPledge,
    );

    _savedMembers.insert(0, newMember);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_savedMembers.map((m) => m.toJson()).toList()));

    _clearForm();
    setState(() {});

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('প্রাথমিক সদস্য ফরম সফলভাবে জমা হয়েছে!'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    }
  }

  void _clearForm() {
    _nameCtrl.clear();
    _fatherNameCtrl.clear();
    _qualificationCtrl.clear();
    _ageCtrl.clear();
    _occupationCtrl.clear();
    _presentAddressCtrl.clear();
    _mobileCtrl.clear();
    _permanentAddressCtrl.clear();
    _acceptedPledge = false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _fatherNameCtrl.dispose();
    _qualificationCtrl.dispose();
    _ageCtrl.dispose();
    _occupationCtrl.dispose();
    _presentAddressCtrl.dispose();
    _mobileCtrl.dispose();
    _permanentAddressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;
        final bgColor = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8FAFC);
        final cardBg = isDark ? const Color(0xFF162032) : Colors.white;
        final textColor = isDark ? Colors.white : AppTheme.textDark;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF162032) : Colors.white,
            elevation: 0,
            title: const Row(
              children: [
                Icon(Icons.badge_rounded, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text('প্রাথমিক সদস্য ফরম', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form Card
                Card(
                  color: cardBg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'খেলাফত মজলিস — প্রাথমিক সদস্য আবেদন',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryColor),
                          ),
                          const SizedBox(height: 14),

                          _buildTextField('আবেদনকারীর নাম *', _nameCtrl, isDark, textColor, required: true),
                          const SizedBox(height: 10),
                          _buildTextField('পিতার নাম *', _fatherNameCtrl, isDark, textColor, required: true),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: _buildTextField('শিক্ষাগত যোগ্যতা', _qualificationCtrl, isDark, textColor)),
                              const SizedBox(width: 10),
                              Expanded(child: _buildTextField('বয়স', _ageCtrl, isDark, textColor, isNumber: true)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: _buildTextField('পেশা', _occupationCtrl, isDark, textColor)),
                              const SizedBox(width: 10),
                              Expanded(child: _buildTextField('মোবাইল নম্বর *', _mobileCtrl, isDark, textColor, required: true)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildTextField('বর্তমান ঠিকানা', _presentAddressCtrl, isDark, textColor, maxLines: 2),
                          const SizedBox(height: 10),
                          _buildTextField('স্থায়ী ঠিকানা', _permanentAddressCtrl, isDark, textColor, maxLines: 2),

                          const SizedBox(height: 16),

                          // Pledge Card
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF063A2F) : const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppTheme.primaryColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'অঙ্গীকারনামা:',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryColor),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  KhelafatSodossoModel.officialPledgeText,
                                  style: TextStyle(fontSize: 12, height: 1.5, color: isDark ? const Color(0xFFA7F3D0) : AppTheme.primaryDark),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _acceptedPledge,
                                      onChanged: (val) => setState(() => _acceptedPledge = val ?? false),
                                      activeColor: AppTheme.primaryColor,
                                    ),
                                    const Expanded(
                                      child: Text(
                                        'আমি উক্ত অঙ্গীকারনামা পাঠ করেছি এবং এতে সম্মত আছি।',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _saveForm,
                              icon: const Icon(Icons.send_rounded),
                              label: const Text('সদস্য ফরম জমা দিন', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Saved Members List
                if (_savedMembers.isNotEmpty) ...[
                  const Text(
                    'নিবন্ধিত প্রাথমিক সদস্যবৃন্দ:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 10),
                  ..._savedMembers.map(
                    (m) => Card(
                      color: cardBg,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppTheme.primaryColor,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('মোবাইল: ${m.mobileNo} • তারিখ: ${m.applicationDate}'),
                        trailing: const Icon(Icons.verified_rounded, color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, bool isDark, Color textColor, {bool required = false, bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: TextStyle(color: textColor, fontSize: 13),
      validator: required
          ? (val) {
              if (val == null || val.trim().isEmpty) return 'এই ঘরটি পূরণ করা আবশ্যক';
              return null;
            }
          : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 12),
        filled: true,
        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }
}
