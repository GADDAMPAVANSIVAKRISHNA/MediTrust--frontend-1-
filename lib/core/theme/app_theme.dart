import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryTeal = Color(0xFF13B8A6);
  static const Color primaryPurple = Color(0xFF7B61FF);
  
  static const Color darkBg = Color(0xFF0F172A);
  static const Color lightBg = Color(0xFFFFFFFF);
  
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E293B);
  
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF334155);

  static const Gradient primaryGradient = LinearGradient(
    colors: [primaryTeal, primaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient accentGradient = LinearGradient(
    colors: [primaryPurple, Color(0xFF9F6BFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Gradient tealGradient = LinearGradient(
    colors: [primaryTeal, Color(0xFF0D9488)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const List<BoxShadow> softShadows = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 16.0,
      offset: Offset(0, 8),
    ),
  ];
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryTeal,
      scaffoldBackgroundColor: AppColors.lightBg,
      cardColor: AppColors.cardLight,
      dividerColor: AppColors.borderLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryTeal,
        secondary: AppColors.primaryPurple,
        background: AppColors.lightBg,
        surface: AppColors.cardLight,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        titleLarge: GoogleFonts.poppins(
          color: AppColors.textPrimaryLight,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.poppins(
          color: AppColors.textPrimaryLight,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: AppColors.textPrimaryLight,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: AppColors.textSecondaryLight,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          side: BorderSide(color: AppColors.borderLight, width: 1.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryTeal, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryTeal,
      scaffoldBackgroundColor: AppColors.darkBg,
      cardColor: AppColors.cardDark,
      dividerColor: AppColors.borderDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryTeal,
        secondary: AppColors.primaryPurple,
        background: AppColors.darkBg,
        surface: AppColors.cardDark,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        titleLarge: GoogleFonts.poppins(
          color: AppColors.textPrimaryDark,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.poppins(
          color: AppColors.textPrimaryDark,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: AppColors.textSecondaryDark,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          side: BorderSide(color: AppColors.borderDark, width: 1.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryTeal, width: 1.5),
        ),
      ),
    );
  }
}
