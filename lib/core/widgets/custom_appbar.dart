import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';

//implement PreferredSizedWidget to customize the height and width of AppBar or tabBar
class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String currentUserName;
  final List<Widget>? actions;
  final bool showTabBar;
  final TabController? tabController;

  const CustomAppbar({
    super.key,
    required this.currentUserName,
    this.actions,
    this.showTabBar = false,
    this.tabController,
  });

  @override
  //TODO: implement preferredSize
  Size get preferredSize =>
      Size.fromHeight(showTabBar ? 100.h : kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('appName').tr(),
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.black,
      elevation: 1,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(
            child: Text(
              'home.welcome'.tr(args: [currentUserName]),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
        if (actions != null) ...actions!,
      ],
    );
  }
}
