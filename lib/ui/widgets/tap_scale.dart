import 'package:flutter/material.dart';
import 'package:arvoituskortit/theme/app_theme.dart';

class TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const TapScale({super.key, required this.child, this.onTap});

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> {
  double _scale = 1.0;

  void _down(_) => setState(() => _scale = 0.98);
  void _up(_)   => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _down,
      onTapUp: _up,
      onTapCancel: () => _up(null),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: AppMotion.fast,
        curve: AppMotion.curve,
        child: widget.child,
      ),
    );
  }
}
