import 'package:flutter/material.dart';
import 'data/db.dart';
import 'ui/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  runApp(App(db: db));
}

class App extends StatelessWidget {
  final AppDatabase db;
  const App({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5EF38C), brightness: Brightness.dark),
      useMaterial3: true,
      cardTheme: CardTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    );
    return MaterialApp(debugShowCheckedModeBanner: false, theme: theme, home: HomePage(db: db));
  }
}
