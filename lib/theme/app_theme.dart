import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF5F0073);     // violetti
  static const secondary = Color(0xFF00783A);   // vihreä
  static const background = Color(0xFF010406);  // lähes musta

  // Nämä jäävät käyttöön kun viitataan tekstiin tummalla pinnalla / korostuksissa
  static const onBackground = Color(0xFFE8EAED);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onSecondary = Color(0xFF001911);

  // Lasin apuvärit (M3: withValues, ei withOpacity)
  static Color glassSurface(BuildContext c) => Colors.white.withValues(alpha: 0.12);
  static Color glassBorder(BuildContext c)  => Colors.white.withValues(alpha: 0.28);
}

class AppMotion {
  static const fast = Duration(milliseconds: 180);
  static const normal = Duration(milliseconds: 200);
  static const curve = Curves.easeInOutCubic;
  static const radius = 20.0;
}

/// Yhtenäinen tumma teema (Material 3)
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'CanavaGrotesk',

  // M3: käytä surface/onSurface. Varsinainen tausta annetaan erikseen scaffoldBackgroundColorilla.
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    surface: Color(0xFF111218),     // neutraali tumma pinta (kortit, levyt)
    onSurface: AppColors.onBackground,
    error: Color(0xFFB00020),
    onError: Colors.white,
  ),

  // Varsinainen appin tausta (entisen backgroundin sijaan)
  scaffoldBackgroundColor: AppColors.background,

  textTheme: const TextTheme(
    // Ilmavaa ja ohutta; säädä näyttökohtaisesti tarpeen mukaan
    bodyLarge:  TextStyle(fontSize: 18, fontWeight: FontWeight.w300, letterSpacing: 0.5),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, letterSpacing: 0.4),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, letterSpacing: 1.0),
  ),

  // Poista M3:n automaattinen tinttaus
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w300,
      color: AppColors.onBackground,
    ),
  ),

  cardTheme: CardTheme(
    color: Colors.white.withValues(alpha: 0.12),
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppMotion.radius),
      side: BorderSide(
        color: Colors.white.withValues(alpha: 0.28),
        width: 1,
      ),
    ),
    elevation: 4,
    shadowColor: Colors.black.withValues(alpha: 0.45),
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
