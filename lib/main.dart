import 'package:flutter/material.dart';

import 'data/db.dart';
import 'ui/theme.dart';
import 'ui/main_menu.dart';
import 'data/importer.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  runApp(App(db: db));
}

/// Root of the application.  It instantiates the database, applies the
/// unified dark theme and decides whether to show the mockup preview or the
/// main menu.  The mockup page is shown once on startup to familiarise
/// users with the new aesthetic; tapping the continue button will reveal
/// the main menu.
class App extends StatefulWidget {
  final AppDatabase db;
  const App({super.key, required this.db});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _showMockup = true;

  @override
  void initState() {
    super.initState();
    // Seed the database with the built‑in seed.json on first launch.  We
    // detect an empty table and import the seed dataset as baseline.
    _maybeSeedDatabase();
  }

  Future<void> _maybeSeedDatabase() async {
    // Count existing cards; if zero, import from assets/seed.json
    final existing = await widget.db.select(widget.db.cards).get();
    if (existing.isEmpty) {
      final json = await rootBundle.loadString('assets/seed.json');
      final importer = Importer(widget.db);
      await importer.importFromJsonString(json, isBaseline: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: MainMenuPage(db: widget.db),
    );
  }

}