import 'package:flutter/material.dart';

class AppColors {
  // ✅ Primary Colors (dùng các màu xanh chủ đạo từ bạn cung cấp)
  static const Color primary = Color(0xFF1A3343); // big-stone
  static const Color primaryLight = Color(0xFF4C93A5); // hippie-blue (sáng hơn)
  static const Color primaryDark = Color(0xFF101819); // bunker (tối hơn)

  // ✅ Secondary Colors (tông xanh phụ)
  static const Color secondary = Color(0xFF57AEBB); // fountain-blue
  static const Color secondaryLight = Color(0xFF517C86); // smalt-blue
  static const Color secondaryDark = Color(0xFF335861); // spectra

  // ✅ Tertiary Colors (màu be/trung tính)
  static const Color tertiary = Color(0xFFF2D8B5); // sidecar
  static const Color tertiaryLight = Color(0xFFFFFFFF); // trắng
  static const Color tertiaryDark = Color(0xFF625E59); // chicago

  // ✅ Accent Colors
  static const Color accentYellow = Color(0xFFF2D8B5); // dùng sidecar làm điểm nhấn nhẹ
  static const Color accentOrange = Color(0xFF747167); // flint (nhẹ, phù hợp thiết kế tối giản)

  // ✅ Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF424443); // cape-cod
  static const Color black = Color(0xFF000000);

  // ✅ Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5); // Light background
  static const Color backgroundDark = Color(0xFF101819); // bunker

  // ✅ Feedback Colors
  static const Color success = Color(0xFF4CAF50); // vẫn giữ màu xanh lá thông dụng
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);

  // ✅ Text Colors
  static const Color textLight = Color(0xFF000000);
  static const Color textDark = Color(0xFFFFFFFF);

  // ✅ Gradients
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

  // ✅ Helpers theo theme
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

  // ✅ Contrast Helper
  static Color adjustContrast(Color color, {double factor = 1.0}) {
    return Color.fromRGBO(
      (color.red * factor).clamp(0, 255).toInt(),
      (color.green * factor).clamp(0, 255).toInt(),
      (color.blue * factor).clamp(0, 255).toInt(),
      1.0,
    );
  }
}
