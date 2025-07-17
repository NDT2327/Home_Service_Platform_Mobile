import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/features/account/views/profile_screen.dart';

//implement PreferredSizedWidget to customize the height and width of AppBar or tabBar
class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // Tiêu đề tùy chọn, mặc định là appName
  final List<Widget>? actions;

  const CustomAppbar({super.key, this.title, this.actions});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      title: Row(
        children: [
          Text(
            title?.tr() ?? 'appName'.tr(),
            style: TextStyle(
              color: AppColors.primary,
              fontSize: Responsive.getFontSize(context, base: 25),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      centerTitle: false,
      automaticallyImplyLeading: false,
      actions: [
        //notification
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.notifications_outlined, color: AppColors.primary),
        // ),
        //icon profile
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
          icon: Icon(Icons.person_2_rounded, color: AppColors.primary),
        ),
      ],
    );
  }
}
