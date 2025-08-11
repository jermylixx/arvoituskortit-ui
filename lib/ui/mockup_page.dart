import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class EdgeGlass extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final bool glow;
  final bool vignette; // edge darkening; can be disabled for perfectly even fill

  const EdgeGlass({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(22)),
    this.glow = true,
    this.vignette = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF7D3AEF).withValues(alpha: 0.10),
              borderRadius: borderRadius,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
                width: 1.0,
              ),
              boxShadow: glow
                  ? [
                BoxShadow(
                  color: const Color(0xFF7D3AEF).withValues(alpha: 0.12),
                  blurRadius: 18,
                  spreadRadius: -2,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: const Color(0xFF10D18F).withValues(alpha: 0.08),
                  blurRadius: 22,
                  spreadRadius: -6,
                  offset: const Offset(0, 10),
                ),
              ]
                  : null,
            ),
          ),
          if (vignette)
            Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: const RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    Colors.transparent,
                    Color.fromRGBO(0, 0, 0, 0.12),
                  ],
                  stops: [0.82, 1.0],
                ),
              ),
            ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class MockupPage extends StatelessWidget {
  final VoidCallback onContinue;
  const MockupPage({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF010406);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            const AuroraBackground(),
            Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Mockup Preview',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'CanavaGrotesk',
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0.5, 0.75),
                        blurRadius: 1.4,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 8),
                      itemCount: 4,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.74,
                      ),
                      itemBuilder: (context, i) {
                        return _GlassCard(index: i);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: GlassButton(
                    label: 'Jatka sovellukseen',
                    onPressed: onContinue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final int index;
  const _GlassCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return EdgeGlass(
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontFamily: 'CanavaGrotesk',
                  fontSize: 12,
                  color: Colors.white70,
                  shadows: [
                    Shadow(
                      offset: Offset(0.4, 0.6),
                      blurRadius: 0.9,
                      color: Colors.black54,
                    ),
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Lyhyt kysymys tähän ${index + 1}',
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'CanavaGrotesk',
                  fontSize: 14,
                  height: 1.35,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0.8, 1.1),
                      blurRadius: 2.0,
                      color: Colors.black54,
                    ),
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const GlassButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: EdgeGlass(
        borderRadius: BorderRadius.circular(18),
        glow: false,
        vignette: false, // disable edge darkening to avoid any perceived center glow
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onPressed,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'CanavaGrotesk',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.2,
                  shadows: [
                    Shadow(
                      offset: Offset(0.9, 1.2),
                      blurRadius: 2.4,
                      color: Colors.black54,
                    ),
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuroraBackground extends StatefulWidget {
  const AuroraBackground({super.key});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _t = 0;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker((elapsed) {
      _t = elapsed.inMilliseconds / 1000.0;
      if (mounted) setState(() {});
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _AuroraPainter(time: _t),
      child: const SizedBox.expand(),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  final double time;
  _AuroraPainter({required this.time});

  final _violet = const Color(0xFF8125D6);
  final _green = const Color(0xFF10D18F);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF08040D),
          Color(0xFF000000),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, basePaint);

    void drawBlob({
      required Offset center,
      required double radius,
      required Color color,
      required double alpha,
    }) {
      final shader = RadialGradient(
        colors: [
          color.withValues(alpha: alpha),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, Paint()..shader = shader);
    }

    double s(double speed, double phase) => math.sin(time * speed + phase);
    double c(double speed, double phase) => math.cos(time * speed + phase);

    drawBlob(
      center: Offset(w * (0.15 + 0.10 * s(0.12, 0.0)), h * (0.15 + 0.05 * c(0.11, 1.2))),
      radius: h * 0.55,
      color: _violet,
      alpha: 0.42,
    );
    drawBlob(
      center: Offset(w * (0.85 + 0.06 * s(0.10, 2.0)), h * (0.08 + 0.04 * c(0.09, -0.7))),
      radius: h * 0.50,
      color: _violet,
      alpha: 0.35,
    );
    drawBlob(
      center: Offset(w * (0.18 + 0.10 * s(0.09, 1.6)), h * (0.90 + 0.06 * c(0.08, 0.3))),
      radius: h * 0.65,
      color: _green,
      alpha: 0.38,
    );
    drawBlob(
      center: Offset(w * (0.78 + 0.08 * s(0.11, -1.1)), h * (0.78 + 0.05 * c(0.10, 2.2))),
      radius: h * 0.55,
      color: _green,
      alpha: 0.30,
    );

    final veil = Paint()
      ..color = Colors.black.withValues(alpha: 0.06)
      ..blendMode = BlendMode.srcOver;
    canvas.drawRect(Offset.zero & size, veil);

    final vignette = Paint()
      ..shader = const RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          Colors.transparent,
          Color.fromRGBO(0, 0, 0, 0.10),
        ],
        stops: [0.75, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, vignette);
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) {
    return true;
  }
}
