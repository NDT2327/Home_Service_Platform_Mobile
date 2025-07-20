import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/widgets/navigation/nav_item.dart';

class MobileNavigationScaffold extends StatelessWidget {
  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final Widget screen;

  const MobileNavigationScaffold({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.primaryLight,
        items:
            items
                .map(
                  (item) => BottomNavigationBarItem(
                    icon: Icon(item.icon),
                    label: item.label,
                  ),
                )
                .toList(),
      ),
    );
  }
}
