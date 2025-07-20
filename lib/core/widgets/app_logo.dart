import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 60,
      backgroundColor: AppColors.secondary,
      backgroundImage: AssetImage('assets/logo/logo.png'),
    );
  }
}
