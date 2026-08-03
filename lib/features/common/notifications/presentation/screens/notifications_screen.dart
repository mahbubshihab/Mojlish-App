import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mojlish_app/core/services/notification_service.dart';
import 'package:mojlish_app/core/theme/app_theme.dart';

/// ডায়নামিক ইউনিভার্সাল নোটিফিকেশন স্ক্রিন
/// রিয়েল-টাইম ফায়ারস্টোর নোটিফিকেশন এবং পার-ইউজার রিড কাউন্ট/স্ট্যাটাস সাপোর্ট
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Set<String> _readIds = {};
  bool _isLoadingReadIds = true;

  @override
  void initState() {
    super.initState();
    _loadReadIds();
  }

  Future<void> _loadReadIds() async {
    final ids = await NotificationService.getReadNotificationIds();
    if (mounted) {
      setState(() {
        _readIds = ids;
        _isLoadingReadIds = false;
      });
    }
  }

  Future<void> _markAsRead(String id) async {
    if (_readIds.contains(id)) return;
    await NotificationService.markAsRead(id);
    if (mounted) {
      setState(() {
        _readIds.add(id);
      });
    }
  }

  Future<void> _markAllAsRead(List<String> allIds) async {
    await NotificationService.markAllAsRead(allIds);
    if (mounted) {
      setState(() {
        _readIds.addAll(allIds);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('সকল নোটিফিকেশন পঠিত হিসেবে চিহ্নিত করা হয়েছে'),
          backgroundColor: AppTheme.primaryDark,
        ),
      );
    }
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      const bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
      const months = [
        'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
        'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
      ];
      String bn(int n) => n.toString().split('').map((c) => bnDigits[int.parse(c)]).join();
      return '${bn(date.day)} ${months[date.month - 1]} ${bn(date.year)}';
    }
    return 'সদ্য';
  }

  Future<void> _openLink(String urlStr) async {
    if (urlStr.trim().isEmpty) return;
    String formattedUrl = urlStr.trim();
    if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }
    final Uri? uri = Uri.tryParse(formattedUrl);
    if (uri != null) {
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('এক্সটার্নাল ব্রাউজারে লিংকটি খোলা সম্ভব হয়নি')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('এক্সটার্নal ব্রাউজারে লিংকটি খোলা সম্ভব হয়নি')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('নোটিশ ও ঘোষণা'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded),
            tooltip: 'সব পঠিত হিসেবে চিহ্নিত করুন',
            onPressed: () async {
              final snapshot = await FirebaseFirestore.instance.collection('notifications').get();
              final allIds = snapshot.docs.map((doc) => doc.id).toList();
              _markAllAsRead(allIds);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text('নোটিফিকেশন লোড করতে সমস্যা হয়েছে: ${snapshot.error}'),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting || _isLoadingReadIds) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryDark),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: isDark ? Colors.white38 : Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'কোনো নতুন নোটিশ বা ঘোষণা নেই',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadReadIds,
            color: AppTheme.primaryDark,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;
                final id = doc.id;
                final isRead = _readIds.contains(id);

                final title = data['title'] ?? 'নোটিশ';
                final description = data['description'] ?? '';
                final link = data['link'] ?? '';
                final targetMajlis = data['targetMajlis'] ?? 'সকল';
                final dateStr = _formatDate(data['createdAt']);

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: InkWell(
                    onTap: () => _markAsRead(id),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? (isRead ? const Color(0xFF1E293B) : const Color(0xFF0F172A))
                            : (isRead ? Colors.white : const Color(0xFFF0FDF4)),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isRead
                              ? (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))
                              : AppTheme.primaryDark,
                          width: isRead ? 1.0 : 1.8,
                        ),
                        boxShadow: isRead
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [
                                BoxShadow(
                                  color: AppTheme.primaryDark.withValues(alpha: 0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Unread Green Dot Indicator
                              if (!isRead) ...[
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryDark,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],

                              // Target Majlis Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryDark.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  targetMajlis,
                                  style: const TextStyle(
                                    color: AppTheme.primaryDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const Spacer(),

                              // Date String
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    size: 13,
                                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    dateStr,
                                    style: TextStyle(
                                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Title
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Description Body
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.45,
                              color: isDark ? Colors.white70 : Colors.grey.shade800,
                            ),
                          ),

                          // Web Link Button (if link present)
                          if (link.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () {
                                _markAsRead(id);
                                _openLink(link);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.link_rounded, size: 18, color: AppTheme.primaryDark),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'বিস্তারিত লিংক ওপেন করুন',
                                      style: TextStyle(
                                        color: AppTheme.primaryDark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
