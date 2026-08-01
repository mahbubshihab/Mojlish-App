import 'package:flutter/material.dart';

/// Decision result for unsaved changes confirmation dialog
enum UnsavedChangesDecision {
  save,
  discard,
  cancel,
}

/// Show unsaved changes confirmation dialog
Future<UnsavedChangesDecision?> showUnsavedChangesDialog(BuildContext context) async {
  return showDialog<UnsavedChangesDecision>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final dialogBg = isDark ? const Color(0xFF162032) : Colors.white;
      final textTitle = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
      final textSub = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569);
      final borderColor = isDark ? const Color(0xFF2A3F58) : const Color(0xFFE2E8F0);

      return Dialog(
        backgroundColor: dialogBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderColor),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFF59E0B),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'অসম্পূর্ণ তথ্য সংরক্ষণ করবেন?',
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                            color: textTitle,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'নিশ্চিতকরণ বার্তা',
                          style: TextStyle(
                            fontSize: 12,
                            color: textSub.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'আপনার কিছু অসম্পূর্ণ বা পরিবর্তিত তথ্য রয়েছে। আপনি কি বের হওয়ার আগে এগুলো সেভ করে রাখতে চান নাকি পরিবর্তন বাতিল করবেন?',
                style: TextStyle(fontSize: 13.5, height: 1.5, color: textSub),
              ),
              const SizedBox(height: 22),
              Column(
                children: [
                  // Row 1: Save & Discard
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFEF4444)),
                          label: const Text('বাতিল করুন'),
                          onPressed: () => Navigator.pop(context, UnsavedChangesDecision.discard),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFEF4444),
                            side: const BorderSide(color: Color(0xFFEF4444)),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.save_rounded, size: 18, color: Colors.white),
                          label: const Text('সেভ করুন'),
                          onPressed: () => Navigator.pop(context, UnsavedChangesDecision.save),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Row 2: Cancel (Stay)
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      icon: Icon(Icons.arrow_back_rounded, size: 16, color: textSub),
                      label: const Text('এখানেই থাকুন'),
                      onPressed: () => Navigator.pop(context, UnsavedChangesDecision.cancel),
                      style: TextButton.styleFrom(
                        foregroundColor: textSub,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// A wrapper widget around PopScope to protect against accidental exits when unsaved changes exist
class UnsavedChangesGuard extends StatelessWidget {
  final Widget child;
  final bool hasUnsavedChanges;
  final Future<bool> Function()? onSave;
  final VoidCallback? onDiscard;

  const UnsavedChangesGuard({
    super.key,
    required this.child,
    required this.hasUnsavedChanges,
    this.onSave,
    this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final decision = await showUnsavedChangesDialog(context);
        if (decision == UnsavedChangesDecision.discard) {
          onDiscard?.call();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        } else if (decision == UnsavedChangesDecision.save) {
          if (onSave != null) {
            final saved = await onSave!();
            if (saved && context.mounted) {
              Navigator.of(context).pop();
            }
          } else {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }
        }
      },
      child: child,
    );
  }
}
