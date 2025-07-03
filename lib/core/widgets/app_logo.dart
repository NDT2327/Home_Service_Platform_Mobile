import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo/logo.jpg',
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }
}