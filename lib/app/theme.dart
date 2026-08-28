import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Warm ink surface visual language specified in brief
  static const Color inkSurface = Color(0xFFF5F5F0);
  static const Color inkCard = Color(0xFFFFFFFF);
  static const Color inkDark = Color(0xFF1C3330);
  static const Color inkMuted = Color(0xFF6B7280);
  static const Color accentMoney = Color(0xFFC0642C); // Warm terracotta accent
  static const Color accentMoneyBg = Color(0xFFFDF6F0);
  static const Color inputBg = Color(0xFFEEEEEA);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: inkSurface,
      colorScheme: ColorScheme.fromSeed(
        seedColor: inkDark,
        surface: inkSurface,
        primary: inkDark,
        secondary: accentMoney,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.libreBaskerville(
          color: inkDark,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.libreBaskerville(
          color: inkDark,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.inter(
          color: inkDark,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: inkDark,
          fontSize: 15,
        ),
        bodyMedium: GoogleFonts.inter(
          color: inkMuted,
          fontSize: 13,
        ),
        // Monospace for every number so amounts line up
        labelLarge: GoogleFonts.jetBrainsMono(
          color: accentMoney,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: inkSurface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: inkDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentMoney,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: inkDark, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
