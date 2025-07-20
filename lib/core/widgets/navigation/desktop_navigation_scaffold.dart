import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/widgets/navigation/nav_item.dart';

class DesktopNavigationScaffold extends StatelessWidget {
  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final Widget screen;

  const DesktopNavigationScaffold({
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
          // Sidebar cố định
          Container(
            width: 200,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Logo
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.secondary,
                    backgroundImage: AssetImage('assets/logo/logo.png'),
                  ),
                ),
                const Divider(),
                // Danh sách menu
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      final isSelected = i == selectedIndex;

                      return Tooltip(
                        message: item.label,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.tertiary : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: Icon(
                              item.icon,
                              size: 24,
                              color: isSelected ? AppColors.primary : AppColors.white,
                            ),
                            title: Text(
                              item.label,
                              style: TextStyle(
                                color: isSelected ? AppColors.primary : AppColors.white,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                            onTap: () => onTap(i),
                            horizontalTitleGap: 12,
                            minLeadingWidth: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Container(color: AppColors.backgroundLight, child: screen),
          ),
        ],
      ),
    );
  }

  
}