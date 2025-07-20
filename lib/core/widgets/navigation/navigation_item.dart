import 'package:flutter/material.dart';

/// Class định nghĩa thông tin cho một item navigation
class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}