import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';

class LinkButton extends StatelessWidget{
final String text;
  final VoidCallback onPressed;
  final Color textColor;

  const LinkButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = AppColors.mediumGray,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
