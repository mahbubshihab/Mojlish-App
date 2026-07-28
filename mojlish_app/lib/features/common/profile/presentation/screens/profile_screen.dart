import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mojlish_app/core/services/auth_service.dart';
import 'package:mojlish_app/core/services/user_storage_service.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/features/common/auth/presentation/screens/google_login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  
  User? _user;
  String _currentMajlis = 'খেলাফত মজলিস';
  bool _isLoading = false;
  bool _isSaving = false;

  final List<Map<String, dynamic>> _majlisOptions = [
    {
      'title': 'খেলাফত মজলিস',
      'subtitle': 'প্রধান দলীয় পরিচালনা সংস্থা',
      'color': const Color(0xFF059669),
      'icon': Icons.account_balance_rounded,
    },
    {
      'title': 'ছাত্র মজলিস',
      'subtitle': 'বাংলাদেশ ইসলামী ছাত্র মজলিস',
      'color': const Color(0xFF2563EB),
      'icon': Icons.school_rounded,
    },
    {
      'title': 'যুব মজলিস',
      'subtitle': 'বাংলাদেশ ইসলামী যুব মজলিস',
      'color': const Color(0xFFD97706),
      'icon': Icons.groups_rounded,
    },
    {
      'title': 'মহিলা মজলিস',
      'subtitle': 'ইসলামী মহিলা মজলিস শাখা',
      'color': const Color(0xFFDB2777),
      'icon': Icons.woman_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);
    final user = _authService.currentUser;
    final name = await UserStorageService.getUserName();
    final majlis = await UserStorageService.getActiveMajlis();

    setState(() {
      _user = user;
      _nameController.text = name.isNotEmpty ? name : (user?.displayName ?? '');
      _currentMajlis = (majlis != null && majlis.isNotEmpty) ? majlis : 'খেলাফত মজলিস';
      _isLoading = false;
    });
  }

  Future<void> _saveProfileChanges() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('দয়া করে সঠিক নাম লিখুন')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final newName = _nameController.text.trim();
      await _authService.updateUserName(newName);
      await _authService.updateActiveMajlis(_currentMajlis);

      themeManager.setMajlisTheme(_currentMajlis);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('প্রোফাইল তথ্য সফলভাবে আপডেট হয়েছে')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('আপডেট করতে ব্যর্থ হয়েছে: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _handleSignOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('লগআউট নিশ্চিতকরণ'),
        content: const Text('আপনি কি নিশ্চিত যে আপনি অ্যাপ থেকে বের হতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('না'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('হ্যাঁ, লগআউট', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.signOut();
      await UserStorageService.clearAll();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const GoogleLoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = AppThemeManager.getThemeForMajlis(_currentMajlis);

    return Scaffold(
      appBar: AppBar(
        title: const Text('প্রোফাইল ও সংগঠন সেটিং'),
        backgroundColor: activeTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Identity Card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: activeTheme.primaryColor.withValues(alpha: 0.1),
                            backgroundImage: (_user?.photoURL != null && _user!.photoURL!.isNotEmpty)
                                ? NetworkImage(_user!.photoURL!)
                                : null,
                            child: (_user?.photoURL == null || _user!.photoURL!.isEmpty)
                                ? Icon(Icons.person, size: 40, color: activeTheme.primaryColor)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _nameController.text.isNotEmpty ? _nameController.text : 'ব্যবহারকারী',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _user?.email ?? 'Google Account',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: activeTheme.primaryColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _currentMajlis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: activeTheme.primaryColor,
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
                  const SizedBox(height: 24),

                  // Edit Name Section
                  const Text(
                    'নাম পরিবর্তন করুন',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'আপনার নাম লিখুন',
                      prefixIcon: const Icon(Icons.edit_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Switch Active Majlis Section
                  const Text(
                    'বর্তমান সক্রিয় মজলিস পরিবর্তন করুন',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ..._majlisOptions.map((item) {
                    final isSelected = _currentMajlis == item['title'];
                    final color = item['color'] as Color;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? color : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: ListTile(
                        onTap: () => setState(() => _currentMajlis = item['title']),
                        leading: CircleAvatar(
                          backgroundColor: color.withValues(alpha: 0.2),
                          child: Icon(item['icon'] as IconData, color: color),
                        ),
                        title: Text(
                          item['title'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? color : Colors.black87,
                          ),
                        ),
                        subtitle: Text(item['subtitle'] as String),
                        trailing: Radio<String>(
                          value: item['title'] as String,
                          groupValue: _currentMajlis,
                          activeColor: color,
                          onChanged: (val) {
                            if (val != null) setState(() => _currentMajlis = val);
                          },
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  // Save Changes Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveProfileChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: activeTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'সংরক্ষণ করুন',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sign Out Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _handleSignOut,
                      icon: const Icon(Icons.logout, color: Color(0xFFDC2626)),
                      label: const Text(
                        'লগআউট করুন',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFDC2626)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
