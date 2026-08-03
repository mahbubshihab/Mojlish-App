import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mojlish_app/core/services/auth_service.dart';
import 'package:mojlish_app/core/services/user_storage_service.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/theme/theme_manager.dart';
import 'package:mojlish_app/core/constants/majlis_assets.dart';
import 'package:mojlish_app/features/common/auth/presentation/screens/google_login_screen.dart';
import 'package:mojlish_app/features/common/auth/presentation/screens/org_selection_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();

  User? _user;
  String _userEmail = '';
  String _photoUrl = '';
  String _currentMajlis = 'খেলাফত মজলিস';
  bool _isLoading = false;
  bool _isSaving = false;

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
    final email = await UserStorageService.getUserEmail();
    final photoUrl = await UserStorageService.getUserPhotoUrl();
    final majlis = await UserStorageService.getActiveMajlis();

    if (mounted) {
      setState(() {
        _user = user;
        _nameController.text = name.isNotEmpty ? name : (user?.displayName ?? 'মিজানুর রহমান');
        _userEmail = email.isNotEmpty ? email : (user?.email ?? 'mizanur.rahman@gmail.com');
        _photoUrl = photoUrl.isNotEmpty ? photoUrl : (user?.photoURL ?? '');
        _currentMajlis = (majlis != null && majlis.isNotEmpty) ? majlis : 'খেলাফত মজলিস';
        _isLoading = false;
      });
    }
  }

  String _getLogoForMajlis(String majlisName) {
    return MajlisAssets.getLogoPath(majlisName);
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
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        final isDark = themeManager.isDarkMode;

        final scaffoldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
        final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
        final borderNav = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
        final textTitle = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
        final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            title: const Text('প্রোফাইল ও সংগঠন সেটিং'),
            backgroundColor: isDark ? const Color(0xFF1E293B) : AppTheme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 1,
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: Colors.white,
                ),
                onPressed: () => themeManager.toggleTheme(),
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Identity Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderNav),
                              boxShadow: [
                                if (!isDark)
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 36,
                                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.15),
                                  backgroundImage: _photoUrl.isNotEmpty ? NetworkImage(_photoUrl) : null,
                                  child: _photoUrl.isEmpty
                                      ? Text(
                                          _nameController.text.isNotEmpty ? _nameController.text[0] : 'ম',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primaryColor,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _nameController.text.isNotEmpty ? _nameController.text : 'ব্যবহারকারী',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: textTitle,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _userEmail.isNotEmpty ? _userEmail : 'Google Account',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryColor.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Text(
                                          _currentMajlis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Edit Name Section
                          Text(
                            'নাম পরিবর্তন করুন',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textTitle),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nameController,
                            style: TextStyle(color: textTitle),
                            decoration: InputDecoration(
                              hintText: 'আপনার নাম লিখুন',
                              hintStyle: TextStyle(color: textMuted),
                              prefixIcon: Icon(Icons.edit_outlined, color: AppTheme.primaryColor),
                              filled: true,
                              fillColor: cardBg,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: borderNav),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Active Majlis & Switch Button Section
                          Text(
                            'সক্রিয় মজলিস',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textTitle),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderNav),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  _getLogoForMajlis(_currentMajlis),
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.stars_rounded,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    _currentMajlis,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: textTitle,
                                    ),
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const OrgSelectionScreen()),
                                    );
                                    _loadProfileData();
                                  },
                                  icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                                  label: const Text('সুইচ করুন'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.primaryColor,
                                    side: BorderSide(color: AppTheme.primaryColor),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Save Changes Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _saveProfileChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
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
                  ),
                ),
        );
      },
    );
  }
}
