import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF5F0073);     // violetti
  static const secondary = Color(0xFF00783A);   // vihreä
  static const background = Color(0xFF010406);  // lähes musta
  static const onBackground = Color(0xFFE8EAED);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onSecondary = Color(0xFF001911);

  // Lasin apuvärit
  static Color glassSurface(BuildContext c) => Colors.white.withOpacity(0.12);
  static Color glassBorder(BuildContext c)  => Colors.white.withOpacity(0.28);
}

class AppMotion {
  static const fast = Duration(milliseconds: 180);
  static const normal = Duration(milliseconds: 200);
  static const curve = Curves.easeInOutCubic;
  static const radius = 20.0;
}

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  fontFamily: 'CanavaGrotesk',
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    background: AppColors.background,
    onBackground: AppColors.onBackground,
    surface: Color(0x1FFFFFFF), // ei käytetä suoraan; lasi tehdään erillisellä widgetillä
    onSurface: AppColors.onBackground,
    error: Color(0xFFB00020),
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.background,
  textTheme: const TextTheme(
    // Ilmavaa, ohutta. Pienet kirjaimet minikortteihin -> säädetään per screen.
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, letterSpacing: 0.4),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, letterSpacing: 1.0),
  ),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppMotion.radius),
      side: BorderSide(width: 1, color: Colors.white.withOpacity(0.28)),
    ),
    elevation: 4,
    shadowColor: Colors.black.withOpacity(0.45),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppMotion.radius),
      ),
      elevation: 3,
    ),
  ),
);
