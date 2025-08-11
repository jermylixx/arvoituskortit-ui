import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

ui.FragmentProgram? _glassProgram;

class RefractedGlass extends StatefulWidget {
  final ui.Image? background;
  final Widget child;
  final double time;
  final double refract;
  final double gloss;
  final BorderRadius borderRadius;

  const RefractedGlass({
    super.key,
    required this.background,
    required this.child,
    required this.time,
    this.refract = 0.85,
    this.gloss = 0.6,
    this.borderRadius = const BorderRadius.all(Radius.circular(22)),
  });

  @override
  State<RefractedGlass> createState() => _RefractedGlassState();
}

class _RefractedGlassState extends State<RefractedGlass> {
  ui.FragmentShader? _shader;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ensureProgram();
  }

  Future<void> _ensureProgram() async {
    if (_glassProgram == null) {
      _glassProgram = await ui.FragmentProgram.fromAsset('assets/shaders/glass_refract.frag');
    }
    _shader = _glassProgram!.fragmentShader();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final img = widget.background;
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Stack(
        children: [
          if (_shader != null && img != null)
            CustomPaint(
              painter: _GlassPainter(
                shader: _shader!,
                background: img,
                time: widget.time,
                refract: widget.refract,
                gloss: widget.gloss,
              ),
              size: Size.infinite,
            )
          else
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(color: Colors.white.withValues(alpha: 0.05)),
            ),
          Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.28),
                  offset: const Offset(0, 10),
                  blurRadius: 24,
                  spreadRadius: -8,
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.white.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.38],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 12,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(child: widget.child),
        ],
      ),
    );
  }
}

class _GlassPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final ui.Image background;
  final double time;
  final double refract;
  final double gloss;

  _GlassPainter({
    required this.shader,
    required this.background,
    required this.time,
    required this.refract,
    required this.gloss,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);
    shader.setFloat(3, refract);
    shader.setFloat(4, gloss);
    shader.setImageSampler(0, background);
    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _GlassPainter old) {
    return old.background != background ||
        old.time != time ||
        old.refract != refract ||
        old.gloss != gloss;
  }
}

class MockupPage extends StatefulWidget {
  final VoidCallback onContinue;
  const MockupPage({super.key, required this.onContinue});

  @override
  State<MockupPage> createState() => _MockupPageState();
}

class _MockupPageState extends State<MockupPage>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _time = 0;
  final _bgKey = GlobalKey();
  ui.Image? _bgImage;
  int _frameMod = 0;
  bool _capturingBg = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) async {
      _time = elapsed.inMilliseconds / 1000.0;
      if (mounted) setState(() {});
      if (_frameMod++ % 10 == 0) {
        unawaited(_captureBackgroundIfReady());
      }
    })..start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_captureBackgroundIfReady());
    });
  }

  Future<void> _captureBackgroundIfReady() async {
    if (_capturingBg) return;
    final boundary = _bgKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return;
    _capturingBg = true;
    try {
      if (boundary.debugNeedsPaint) {
        await WidgetsBinding.instance.endOfFrame;
        if (!mounted) return;
      }
      final pr = MediaQuery.of(context).devicePixelRatio;
      final img = await boundary.toImage(pixelRatio: pr);
      _bgImage?.dispose();
      _bgImage = img;
    } finally {
      _capturingBg = false;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _bgImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF010406);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            RepaintBoundary(
              key: _bgKey,
              child: ShaderBuilder(
                    (context, shader, child) {
                  return CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: _SmokeBackgroundPainter(
                      shader: shader,
                      time: _time,
                    ),
                  );
                },
                assetKey: 'assets/shaders/smoke_background.frag',
              ),
            ),
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.04),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.06),
                    ],
                    stops: const [0.0, 0.46, 1.0],
                  ),
                ),
                child: const SizedBox.expand(),
              ),
            ),
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
                        return _GlassCard(
                          index: i,
                          time: _time,
                          bgImage: _bgImage,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: _GlossButton(
                      label: 'Jatka sovellukseen',
                      onPressed: widget.onContinue,
                    ),
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

class _SmokeBackgroundPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final double time;
  _SmokeBackgroundPainter({required this.shader, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, time * 0.15);
    shader.setFloat(1, size.width);
    shader.setFloat(2, size.height);
    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _SmokeBackgroundPainter old) {
    return old.time != time || old.shader != shader;
  }
}

class _GlassCard extends StatelessWidget {
  final int index;
  final double time;
  final ui.Image? bgImage;
  const _GlassCard({
    required this.index,
    required this.time,
    required this.bgImage,
  });

  @override
  Widget build(BuildContext context) {
    return RefractedGlass(
      background: bgImage,
      time: time,
      refract: 0.85,
      gloss: 0.5,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontFamily: 'CanavaGrotesk',
                  fontSize: 12,
                  color: Colors.white70,
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlossButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _GlossButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.12),
              Colors.transparent,
            ],
            stops: const [0.0, 0.45],
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5F0073),
              elevation: 6,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'CanavaGrotesk',
                fontSize: 18,
                letterSpacing: 0.2,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
