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
    assert(items.length >= 2, 'Phải có ít nhất 2 mục trong BottomNavigationBar');

    return Scaffold(
      body: SafeArea(child: screen),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex.clamp(0, items.length - 1),
        onTap: (index) {
          // Đảm bảo không trỏ vào index sai
          if (index < items.length) {
            onTap(index);
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.primaryLight,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: items
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
