import 'package:flutter/material.dart';

/// Central Responsive Web Wrapper Widget
/// Constrains screen width on desktop/web displays so mobile-first UIs look sleek, centered, and well-proportioned.
class ResponsiveWebWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveWebWrapper({
    super.key,
    required this.child,
    this.maxWidth = 850,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWebDesktop = screenWidth > 850;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? (isWebDesktop ? const EdgeInsets.symmetric(vertical: 16) : EdgeInsets.zero),
          child: child,
        ),
      ),
    );
  }
}
