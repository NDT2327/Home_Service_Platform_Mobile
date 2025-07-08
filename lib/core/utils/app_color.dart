import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2196F3); // Blue
  static const Color primaryLight = Color(0xFF64B5F6); // Lighter Blue (Tint)
  static const Color primaryDark = Color(0xFF1976D2); // Darker Blue (Shade)

  // Secondary Colors
  static const Color secondary = Color(0xFF9C27B0); // Purple
  static const Color secondaryLight = Color(0xFFCE93D8); // Lighter Purple
  static const Color secondaryDark = Color(0xFF7B1FA2); // Darker Purple

  // Tertiary Colors
  static const Color tertiary = Color(0xFF4CAF50); // Green
  static const Color tertiaryLight = Color(0xFF81C784); // Lighter Green
  static const Color tertiaryDark = Color(0xFF388E3C); // Darker Green

  // Accent Colors
  static const Color accentYellow = Color(0xFFFFC107); // Yellow
  static const Color accentOrange = Color(0xFFFF5722); // Orange

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF616161);
  static const Color black = Color(0xFF000000);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5); // Light Background
  static const Color backgroundDark = Color(0xFF121212); // Dark Background

  // Feedback Colors
  static const Color success = Color(0xFF4CAF50); // Green for Success
  static const Color error = Color(0xFFF44336); // Red for Error
  static const Color warning = Color(0xFFFFC107); // Yellow for Warning

  // Text Colors
  static const Color textLight = Color(0xFF000000);
  static const Color textDark = Color(0xFFFFFFFF);

  // Gradients
  static LinearGradient primaryGradient(BuildContext context) {
    return LinearGradient(
      colors: [
        getPrimary(context),
        getPrimary(context).withOpacity(0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient secondaryGradient(BuildContext context) {
    return LinearGradient(
      colors: [
        secondary,
        secondaryLight,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  // Helper Methods to Get Colors Based on Theme
  static Color getPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? primaryDark : primary;
  }

  static Color getSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? secondaryDark : secondary;
  }

  static Color getTertiary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? tertiaryDark : tertiary;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? textDark : textLight;
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? backgroundDark : backgroundLight;
  }

  // Helper Method for Contrast Adjustment
  static Color adjustContrast(Color color, {double factor = 1.0}) {
    // Adjust brightness for better contrast (simplified for WCAG compliance)
    return Color.fromRGBO(
      (color.red * factor).clamp(0, 255).toInt(),
      (color.green * factor).clamp(0, 255).toInt(),
      (color.blue * factor).clamp(0, 255).toInt(),
      1.0,
    );
  }
}