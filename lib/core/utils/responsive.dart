import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  static double getMaxWidth(BuildContext context) {
  if (isMobile(context)) return MediaQuery.of(context).size.width;
  if (isTablet(context)) return 500;
  return 800;
}

static double getFontSize(BuildContext context, {required double base}) {
  if (isMobile(context)) return base * 0.9;
  if (isTablet(context)) return base * 1.0;
  return base * 1.2;
}

static EdgeInsets getPadding(BuildContext context) {
  if (isMobile(context)) return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  if (isTablet(context)) return const EdgeInsets.symmetric(horizontal: 24, vertical: 24);
  return const EdgeInsets.symmetric(horizontal: 32, vertical: 32);
}
}