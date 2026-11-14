import 'package:flutter/material.dart';

class AppTheme {
  static const green = Color(0xFF354B38);
  static const gold = Color(0xFFC5A15A);
  static const canvas = Color(0xFFF8F5EF);
  static const ink = Color(0xFF252923);
  static const muted = Color(0xFF85877F);
  static const line = Color(0xFFEAE5DA);

  static ThemeData light() => _theme(Brightness.light);
  static ThemeData dark() => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: green,
      brightness: brightness,
      primary: dark ? const Color(0xFFB4C9AE) : green,
      secondary: gold,
      surface: dark ? const Color(0xFF20251F) : Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: dark ? const Color(0xFF171B17) : canvas,
      fontFamily: 'Vazirmatn',
      textTheme: ThemeData(brightness: brightness).textTheme.apply(
        bodyColor: dark ? const Color(0xFFF3F0E9) : ink,
        displayColor: dark ? const Color(0xFFF3F0E9) : ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? const Color(0xFF171B17) : canvas,
        foregroundColor: dark ? Colors.white : ink,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF252B25) : Colors.white,
        hintStyle: const TextStyle(color: muted, fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      ),
      dividerColor: dark ? Colors.white12 : line,
    );
  }
}
