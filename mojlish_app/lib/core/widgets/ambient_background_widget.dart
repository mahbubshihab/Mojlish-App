import 'dart:math';
import 'package:flutter/material.dart';

/// Reusable Ambient Background Wrapper Widget
/// Displays soft glowing radial gradients, floating ambient particles,
/// and geometric Islamic star patterns for both Light and Dark modes.
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
    final accent = primaryAccent ?? const Color(0xFF10B981);

    return Stack(
      children: [
        // 1. Base Gradient Background
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.8, -0.6),
                radius: 1.4,
                colors: isDark
                    ? [
                        accent.withValues(alpha: 0.12),
                        const Color(0xFF162032),
                        const Color(0xFF0D1B2A),
                      ]
                    : [
                        accent.withValues(alpha: 0.08),
                        const Color(0xFFF1F5F9),
                        const Color(0xFFF8FAFC),
                      ],
              ),
            ),
          ),
        ),

        // 2. Secondary Glowing Ambient Light Bubble
        Positioned(
          bottom: -80,
          right: -80,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (primaryAccent ?? const Color(0xFF0284C7)).withValues(alpha: isDark ? 0.15 : 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // 3. Geometric Star & Grid Overlay
        if (showStars)
          Positioned.fill(
            child: CustomPaint(
              painter: _AmbientIslamicStarPainter(
                isDark: isDark,
                accent: accent,
              ),
            ),
          ),

        // 4. Main Content Child
        Positioned.fill(child: child),
      ],
    );
  }
}

class _AmbientIslamicStarPainter extends CustomPainter {
  final bool isDark;
  final Color accent;

  _AmbientIslamicStarPainter({required this.isDark, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle background grid
    final gridPaint = Paint()
      ..color = (isDark ? accent : Colors.grey).withValues(alpha: isDark ? 0.025 : 0.04)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const step = 45.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Floating 8-point geometric star accents
    final starPaint = Paint()
      ..color = (isDark ? accent : const Color(0xFF059669)).withValues(alpha: isDark ? 0.06 : 0.05)
      ..style = PaintingStyle.fill;

    _draw8PointStar(canvas, Offset(size.width * 0.88, size.height * 0.08), 24, starPaint);
    _draw8PointStar(canvas, Offset(size.width * 0.12, size.height * 0.28), 16, starPaint);
    _draw8PointStar(canvas, Offset(size.width * 0.92, size.height * 0.65), 20, starPaint);
    _draw8PointStar(canvas, Offset(size.width * 0.08, size.height * 0.82), 14, starPaint);
  }

  void _draw8PointStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = i * 45 * pi / 180;
      final r = i % 2 == 0 ? radius : radius * 0.45;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_AmbientIslamicStarPainter oldDelegate) =>
      oldDelegate.isDark != isDark || oldDelegate.accent != accent;
}
