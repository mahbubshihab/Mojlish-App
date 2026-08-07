import 'package:flutter/material.dart';

/// Intercepts back navigation if [hasUnsavedChanges] is true,
/// showing a confirmation dialog to Save & Exit, Discard, or Stay.
class UnsavedChangesGuard extends StatelessWidget {
  final bool hasUnsavedChanges;
  final Future<bool> Function()? onSave;
  final Widget child;

  const UnsavedChangesGuard({
    super.key,
    required this.hasUnsavedChanges,
    this.onSave,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final dialogBg = isDark ? const Color(0xFF1E293B) : Colors.white;
        final titleColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
        final textColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

        final action = await showDialog<_UnsavedAction>(
          context: context,
          builder: (dialogContext) => Dialog(
            backgroundColor: dialogBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            elevation: 12,
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Warning Icon Badge
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.2 : 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFF59E0B),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Title
                  Text(
                    'অসংরক্ষিত পরিবর্তন',
                    style: TextStyle(
                      fontSize: 18.5,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Body Text
                  Text(
                    'আপনার কিছু অসংরক্ষিত পরিবর্তন রয়েছে। আপনি কি সংরক্ষণ করতে চান নাকি পরিবর্তনগুলো বাতিল করতে চান?',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: textColor,
                      height: 1.45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),

                  // Buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Save & Exit (Primary Green Gradient)
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF059669), Color(0xFF10B981)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981).withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Navigator.of(dialogContext).pop(_UnsavedAction.save),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save_rounded, color: Colors.white, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'সংরক্ষণ ও প্রস্থান',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Row for Discard & Stay
                      Row(
                        children: [
                          // Stay Button
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => Navigator.of(dialogContext).pop(_UnsavedAction.stay),
                                child: Text(
                                  'থেকে যান',
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Discard Button
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4444).withValues(alpha: isDark ? 0.2 : 0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => Navigator.of(dialogContext).pop(_UnsavedAction.discard),
                                child: const Text(
                                  'বাতিল করুন',
                                  style: TextStyle(
                                    color: Color(0xFFEF4444),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        if (action == null || action == _UnsavedAction.stay) {
          return;
        }

        if (action == _UnsavedAction.discard) {
          if (context.mounted) {
            Navigator.of(context).pop(result);
          }
        } else if (action == _UnsavedAction.save) {
          final success = await onSave?.call() ?? true;
          if (success && context.mounted) {
            Navigator.of(context).pop(result);
          }
        }
      },
      child: child,
    );
  }
}

enum _UnsavedAction { stay, discard, save }
