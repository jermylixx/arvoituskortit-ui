import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/json_models.dart';

class RiddleCardView extends StatefulWidget {
  final String titleFront; // "Kysymys"
  final String titleBack;  // "Vastaus"
  final String textFront;
  final String textBack;
  final List<PicRef> frontPics;
  final List<PicRef> backPics;
  final bool initiallyFlipped;
  final VoidCallback? onEdit;

  const RiddleCardView({
    super.key,
    required this.titleFront,
    required this.titleBack,
    required this.textFront,
    required this.textBack,
    this.frontPics = const [],
    this.backPics = const [],
    this.initiallyFlipped = false,
    this.onEdit,
  });

  @override
  State<RiddleCardView> createState() => _RiddleCardViewState();
}

class _RiddleCardViewState extends State<RiddleCardView> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    if (widget.initiallyFlipped) _ctrl.value = 1;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _flip() {
    if (_ctrl.isAnimating) return;
    if (_ctrl.value < 0.5) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final front = _Face(title: widget.titleFront, text: widget.textFront, pics: widget.frontPics);
    final back = _Face(title: widget.titleBack, text: widget.textBack, pics: widget.backPics);

    return GestureDetector(
      onTap: _flip,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _anim,
            builder: (context, _) {
              final angle = _anim.value * math.pi;
              final isBack = angle > math.pi / 2;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    constraints: const BoxConstraints(minHeight: 220),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(isBack ? math.pi : 0),
                      child: isBack ? back : front,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(icon: const Icon(Icons.edit), onPressed: widget.onEdit),
          ),
        ],
      ),
    );
  }
}

class _Face extends StatelessWidget {
  final String title;
  final String text;
  final List<PicRef> pics;
  const _Face({required this.title, required this.text, required this.pics});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Expanded(child: SingleChildScrollView(child: Text(text, style: theme.textTheme.bodyLarge))),
        if (pics.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 84,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: pics.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => _PicThumb(p: pics[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class _PicThumb extends StatelessWidget {
  final PicRef p;
  const _PicThumb({required this.p});
  @override
  Widget build(BuildContext context) {
    Widget img;
    if (p.type == 'file') {
      img = Image.file(File(p.uri), fit: BoxFit.cover, width: 120, height: 84);
    } else if (p.type == 'dataUri') {
      final bytes = decodeDataUriToBytes(p.uri);
      img = bytes == null
          ? const SizedBox.shrink()
          : Image.memory(bytes, fit: BoxFit.cover, width: 120, height: 84);
    } else {
      img = Image.asset(p.uri, fit: BoxFit.cover, width: 120, height: 84);
    }
    return ClipRRect(borderRadius: BorderRadius.circular(10), child: img);
  }
}
