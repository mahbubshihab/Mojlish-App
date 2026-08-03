import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';
import 'package:mojlish_app/core/services/user_storage_service.dart';

class SocialMediaScreen extends StatefulWidget {
  const SocialMediaScreen({super.key});

  @override
  State<SocialMediaScreen> createState() => _SocialMediaScreenState();
}

class _SocialMediaScreenState extends State<SocialMediaScreen> {
  String _activeMajlisId = 'khelafat';
  String _activeMajlisName = 'খেলাফত মজলিস';
  bool _isLoadingMajlis = true;

  @override
  void initState() {
    super.initState();
    _loadUserMajlis();
  }

  Future<void> _loadUserMajlis() async {
    final rawMajlis = await UserStorageService.getSelectedMajlis();
    final majlisId = _resolveMajlisId(rawMajlis);
    setState(() {
      _activeMajlisId = majlisId;
      _activeMajlisName = _resolveMajlisName(majlisId);
      _isLoadingMajlis = false;
    });
  }

  String _resolveMajlisId(String rawName) {
    final name = rawName.toLowerCase();
    if (name.contains('jubo') || name.contains('youth') || name.contains('যুব')) {
      return 'jubo';
    } else if (name.contains('chatro') || name.contains('student') || name.contains('ছাত্র')) {
      return 'chatro';
    } else if (name.contains('labor') || name.contains('shromik') || name.contains('শ্রমিক')) {
      return 'labor';
    } else if (name.contains('women') || name.contains('mohila') || name.contains('মহিলা')) {
      return 'women';
    }
    return 'khelafat';
  }

  String _resolveMajlisName(String id) {
    switch (id) {
      case 'jubo':
        return 'ইসলামী যুব মজলিস';
      case 'chatro':
        return 'বাংলাদেশ ইসলামী ছাত্র মজলিস';
      case 'labor':
        return 'বাংলাদেশ ইসলামী শ্রমিক মজলিস';
      case 'women':
        return 'বাংলাদেশ ইসলামী মহিলা মজলিস';
      default:
        return 'খেলাফত মজলিস';
    }
  }

  Future<void> _launchSocialUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('লিংক খুলতে সমস্যা হয়েছে: $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textDark = isDark ? Colors.white : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'অফিসিয়াল সোশ্যাল মিডিয়া',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1E293B) : AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoadingMajlis
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('settings')
                  .doc('social_links_$_activeMajlisId')
                  .snapshots(),
                    builder: (context, snapshot) {
                      Map<String, dynamic> linksData = {};

                      if (snapshot.hasData && snapshot.data!.exists) {
                        linksData = snapshot.data!.data() as Map<String, dynamic>;
                      } else {
                        // Fallback default links if cloud doc not initialized yet
                        linksData = {
                          'facebook': {'active': true, 'url': 'https://facebook.com/groups/mojlish'},
                          'youtube': {'active': true, 'url': 'https://youtube.com/mojlishofficial'},
                          'twitter': {'active': false, 'url': ''},
                          'website': {'active': true, 'url': 'https://khelafatmojlish.com'},
                          'telegram': {'active': false, 'url': ''},
                          'whatsapp': {'active': false, 'url': ''},
                        };
                      }

                      // Extract items
                      final facebook = _extractLink(linksData['facebook']);
                      final youtube = _extractLink(linksData['youtube']);
                      final twitter = _extractLink(linksData['twitter']);
                      final website = _extractLink(linksData['website']);
                      final telegram = _extractLink(linksData['telegram']);
                      final whatsapp = _extractLink(linksData['whatsapp']);

                      final activeList = [
                        if (facebook.active && facebook.url.isNotEmpty)
                          _SocialItem('অফিসিয়াল ফেসবুক পেজ / গ্রুপ', FontAwesomeIcons.facebook, const Color(0xFF1877F2), facebook.url),
                        if (youtube.active && youtube.url.isNotEmpty)
                          _SocialItem('অফিসিয়াল ইউটিউব চ্যানেল', FontAwesomeIcons.youtube, const Color(0xFFFF0000), youtube.url),
                        if (twitter.active && twitter.url.isNotEmpty)
                          _SocialItem('অফিসিয়াল এক্স (টুইটার)', FontAwesomeIcons.xTwitter, isDark ? const Color(0xFF475569) : Colors.black87, twitter.url),
                        if (website.active && website.url.isNotEmpty)
                          _SocialItem('অফিসিয়াল ওয়েবসাইট', FontAwesomeIcons.globe, AppTheme.primaryColor, website.url),
                        if (telegram.active && telegram.url.isNotEmpty)
                          _SocialItem('অফিসিয়াল টেলিগ্রাম চ্যানেল', FontAwesomeIcons.telegram, const Color(0xFF24A1DE), telegram.url),
                        if (whatsapp.active && whatsapp.url.isNotEmpty)
                          _SocialItem('অফিসিয়াল হোয়াটসঅ্যাপ গ্রুপ', FontAwesomeIcons.whatsapp, const Color(0xFF25D366), whatsapp.url),
                      ];

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Banner
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(Icons.share_rounded, color: AppTheme.primaryColor, size: 24),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _activeMajlisName,
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textDark),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'অফিসিয়াল সোশ্যাল সংযোগ মাধ্যমসমূহ',
                                          style: TextStyle(fontSize: 12.5, color: textMuted),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            if (activeList.isEmpty)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.link_off_rounded, size: 48, color: textMuted),
                                    const SizedBox(height: 12),
                                    Text(
                                      'বর্তমানে এই সংগঠনের কোনো সক্রিয় সোশ্যাল লিংক যুক্ত নেই',
                                      style: TextStyle(color: textMuted, fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            else
                              ...activeList.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton.icon(
                                      onPressed: () => _launchSocialUrl(item.url),
                                      icon: FaIcon(item.icon, color: Colors.white, size: 20),
                                      label: Text(
                                        item.title,
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: item.color,
                                        foregroundColor: Colors.white,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
    );
  }

  _SocialLinkData _extractLink(dynamic obj) {
    if (obj is Map) {
      final active = obj['active'] == true;
      final url = obj['url']?.toString().trim() ?? '';
      return _SocialLinkData(active: active, url: url);
    }
    return _SocialLinkData(active: false, url: '');
  }
}

class _SocialLinkData {
  final bool active;
  final String url;
  _SocialLinkData({required this.active, required this.url});
}

class _SocialItem {
  final String title;
  final dynamic icon;
  final Color color;
  final String url;
  _SocialItem(this.title, this.icon, this.color, this.url);
}
