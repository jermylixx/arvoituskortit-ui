import 'package:flutter/material.dart';
import 'data/db.dart';
import 'ui/home.dart';
import 'ui/mockup_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  runApp(App(db: db));
}

class App extends StatefulWidget {
  final AppDatabase db;
  const App({super.key, required this.db});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool showMockup = true;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'CanavaGrotesk',
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF5F0073),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: showMockup
          ? MockupPage(
        onContinue: () {
          setState(() {
            showMockup = false;
          });
        },
      )
          : HomePage(db: widget.db),
    );
  }
}
