import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';

//implement PreferredSizedWidget to customize the height and width of AppBar or tabBar
class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String currentUserName;
  final String? title; // Tiêu đề tùy chọn, mặc định là appName
  final List<Widget>? actions;

  const CustomAppbar({
    super.key,
    required this.currentUserName,
    this.title,
    this.actions,
  });

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
              color: AppColors.textLight,
              fontSize: Responsive.getFontSize(context, base: 20),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Text(
              'home.welcome'.tr(args: [currentUserName]),
              style: TextStyle(
                color: AppColors.black,
                fontSize: Responsive.getFontSize(context, base: 14),
              ),
            ),
          ),
        ],
      ),
      centerTitle: false,
      automaticallyImplyLeading: false,
      actions: actions,
    );
  }
}