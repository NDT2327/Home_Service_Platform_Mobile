import 'package:flutter/material.dart';

class NavItem {
  final IconData icon;
  final String label;
  final Widget screen;
  final String route;

  NavItem(this.icon, this.label, this.screen, this.route);
}
