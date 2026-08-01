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
        final action = await showDialog<_UnsavedAction>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('অসংরক্ষিত পরিবর্তন'),
            content: const Text(
              'আপনার কিছু অসংরক্ষিত পরিবর্তন রয়েছে। আপনি কি সংরক্ষণ করতে চান নাকি পরিবর্তনগুলো বাতিল করতে চান?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(_UnsavedAction.stay),
                child: const Text('থেকে যান'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(_UnsavedAction.discard),
                child: const Text(
                  'বাতিল করুন',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(dialogContext).pop(_UnsavedAction.save),
                child: const Text('সংরক্ষণ ও প্রস্থান'),
              ),
            ],
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
