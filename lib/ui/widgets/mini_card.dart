import 'package:flutter/material.dart';
import 'package:arvoituskortit/ui/widgets/glass.dart';

class MiniCard extends StatelessWidget {
  final int number;
  final String questionPreview;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  const MiniCard({
    super.key,
    required this.number,
    required this.questionPreview,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: TapRegion( // toimii myös paksuilla sormilla, ei muuta logiikkaa
        child: GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Glass(
            padding: const EdgeInsets.all(12),
            showShine: true,
            child: Stack(
              children: [
                // pieni numero vasempaan yläkulmaan
                Positioned(
                  left: 0, top: 0,
                  child: Text(
                    number.toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                // keskelle pieni kysymysteksti, max 3 riviä
                Center(
                  child: Text(
                    questionPreview,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12, // pieni, että mahtuu paljon tekstiä
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
