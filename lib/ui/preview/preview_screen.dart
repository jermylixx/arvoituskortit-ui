import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _mockScreen(context, 'Päävalikko'),
            _mockScreen(context, 'Selaustila'),
            _mockScreen(context, 'Pelitila: Kysymys'),
            _mockScreen(context, 'Pelitila: Vastaus'),
          ],
        ),
      ),
    );
  }

  Widget _mockScreen(BuildContext context, String title) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                'Tämä on esimerkkiteksti joka käyttää CanavaGrotesk-fonttia ja näyttää miltä tekstit, värit ja kortit näyttävät. '
                    'Voit muuttaa teeman värejä ja fonttikokoa ja nähdä tuloksen heti Hot Reloadilla.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
