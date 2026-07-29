import 'dart:math';
import 'package:flutter/material.dart';

/// Reusable Ambient Background Wrapper Widget
/// Replaces heavy ambient gradients with the exact, original, subtle grid, 
/// soft glowing circles, and 8-point geometric star pattern from the original report table.
class AmbientBackgroundWidget extends StatelessWidget {
  final Widget child;
  final bool showStars;
  final Color? primaryAccent;

  const AmbientBackgroundWidget({
    super.key,
    required this.child,
    this.showStars = true,
    this.primaryAccent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _OriginalReportBgPainter(
              isDark: isDark,
              accent: primaryAccent ?? const Color(0xFF10B981),
              showStars: showStars,
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _OriginalReportBgPainter extends CustomPainter {
  final bool isDark;
  final Color accent;
  final bool showStars;

  _OriginalReportBgPainter({
    required this.isDark,
    required this.accent,
    required this.showStars,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isDark) {
      final grid = Paint()
        ..color = Colors.grey.withValues(alpha: 0.05)
        ..strokeWidth = 0.5
        ..style = PaintingStyle.stroke;
      for (double x = 0; x < size.width; x += 40) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
      }
      for (double y = 0; y < size.height; y += 40) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
      }
      return;
    }

    // Soft subtle glowing circles (exact parameters from original report table)
    final fill = Paint()
      ..color = accent.withValues(alpha: 0.025)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.05), 130, fill);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.5), 100, fill);

    // Subtle fine grid
    final grid = Paint()
      ..color = accent.withValues(alpha: 0.012)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // 8-point geometric star accents
    if (showStars) {
      final star = Paint()
        ..color = const Color(0xFF1E3A52)
        ..style = PaintingStyle.fill;
      _drawStar(canvas, Offset(size.width * 0.85, size.height * 0.12), 18, star);
      _drawStar(canvas, Offset(size.width * 0.08, size.height * 0.3), 12, star);
    }
  }

  void _drawStar(Canvas canvas, Offset c, double r, Paint p) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final a = i * 45 * pi / 180;
      final rad = i % 2 == 0 ? r : r * 0.45;
      if (i == 0) {
        path.moveTo(c.dx + rad * cos(a), c.dy + rad * sin(a));
      } else {
        path.lineTo(c.dx + rad * cos(a), c.dy + rad * sin(a));
      }
    }
    path.close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_OriginalReportBgPainter oldDelegate) =>
      oldDelegate.isDark != isDark ||
      oldDelegate.accent != accent ||
      oldDelegate.showStars != showStars;
}
