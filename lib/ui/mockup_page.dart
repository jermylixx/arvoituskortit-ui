import 'package:flutter/material.dart';

class MockupPage extends StatelessWidget {
  final VoidCallback onContinue;

  const MockupPage({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010406),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Mockup Preview',
              style: TextStyle(
                fontFamily: 'CanavaGrotesk',
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Gradient-tausta + korttiruudukko
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: <double>[0.0, 0.45, 1.0],
                    colors: <Color>[
                      Color(0xFF5F0073),
                      Color(0xFF010406),
                      Color(0xFF00783A),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: 4,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          children: <Widget>[
                            // Pieni numero vasempaan yläkulmaan
                            const Positioned(
                              top: 6,
                              left: 8,
                              child: Text(
                                '1', // halutessasi vaihda dynaamiseksi
                                style: TextStyle(
                                  fontFamily: 'CanavaGrotesk',
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            // Kysymysteksti keskelle
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Lyhyt kysymys tähän ${index + 1}',
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'CanavaGrotesk',
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Jatka-painike
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5F0073),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Jatka sovellukseen',
                  style: TextStyle(
                    fontFamily: 'CanavaGrotesk',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
