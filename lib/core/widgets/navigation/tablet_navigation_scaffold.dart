import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/widgets/navigation/nav_item.dart';
import 'package:hsp_mobile/core/widgets/navigation/navigation_item.dart';

class TabletNavigationScaffold extends StatelessWidget {
  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final Widget screen;

  const TabletNavigationScaffold({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onTap,
            labelType: NavigationRailLabelType.all,
            destinations: items
                .map((item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      label: Text(item.label),
                    ))
                .toList(),
          ),
          Expanded(child: screen),
        ],
      ),
    );
  }
}
