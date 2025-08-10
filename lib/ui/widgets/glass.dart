import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:arvoituskortit/theme/app_theme.dart';

class Glass extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final double blur;
  final double opacity; // 0.08–0.16
  final bool showShine;
  const Glass({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = AppMotion.radius,
    this.blur = 16,
    this.opacity = 0.12,
    this.showShine = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: opacity),
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(color: AppColors.glassBorder(context), width: 1),
              ),
            ),
          ),
          if (showShine)
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha:0.16),
                      Colors.white.withValues(alpha:0.00),
                    ],
                  ),
                ),
              ),
            ),
          // sisältö
          Positioned.fill(
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
