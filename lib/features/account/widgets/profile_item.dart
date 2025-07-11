import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';

class ProfileItem extends StatelessWidget {
  //mỗi item cần một icon và text
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool isLogout;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? AppColors.accentOrange : null),
      title: Text(
        text,
        style: TextStyle(
          color: isLogout ? AppColors.accentOrange : null,
          fontWeight: isLogout ? FontWeight.bold : null,
        ),
      ),
      trailing:
          isLogout
              ? null
              : Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.mediumGray,
                size: 16,
              ),
      onTap: onTap,
    );
  }
}
