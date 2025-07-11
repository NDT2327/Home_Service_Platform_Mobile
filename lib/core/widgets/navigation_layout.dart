import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/core/widgets/custom_appbar.dart';
import 'package:hsp_mobile/features/home_page.dart';
import 'package:hsp_mobile/features/profile/views/profile_screen.dart';

class NavigationLayout extends StatefulWidget {
  const NavigationLayout({super.key});

  @override
  State<NavigationLayout> createState() => _NavigationLayoutState();
}

class _NavigationLayoutState extends State<NavigationLayout> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [HomePage(), ProfileScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Danh sách các mục navigation
  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home,
      label: 'navigation.home',
      showTabBar: false, // Hiển thị tab bar khi ở màn hình này
    ),
    NavigationItem(
      icon: Icons.person,
      label: 'navigation.profile',
      showTabBar: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _buildMobileLayout(context),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  //mobile
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.primaryLight,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items:
            _navigationItems.map((item) {
              return BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label.tr(),
              );
            }).toList(),
      ),
    );
  }

  //tablet
  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.home),
                label: Text('navigation.home'.tr()),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.person),
                label: Text('navigation.profile'.tr()),
              ),
            ],
          ),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }

  //desktop
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: Text(
                    'navigation.menu'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.getFontSize(context, base: 24),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text('navigation.home'.tr()),
                  selected: _selectedIndex == 0,
                  onTap: () {
                    _onItemTapped(0);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('navigation.profile'.tr()),
                  selected: _selectedIndex == 1,
                  onTap: () {
                    _onItemTapped(1);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final bool showTabBar;

  NavigationItem({
    required this.icon,
    required this.label,
    this.showTabBar = false,
  });
}
