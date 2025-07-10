import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/core/widgets/custom_appbar.dart';

class NavigationLayout extends StatefulWidget {
  const NavigationLayout({super.key});

  @override
  State<NavigationLayout> createState() => _NavigationLayoutState();
}

class _NavigationLayoutState extends State<NavigationLayout> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
      appBar: CustomAppbar(
        currentUserName: 'Le Van Cuong',
        showTabBar: _selectedIndex == 0,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'navigation.home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'navigation.profile'.tr(),
          ),
        ],
      ),
    );
  }

  //tablet
  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        currentUserName: 'Lê Văn Cường',
        showTabBar: _selectedIndex == 0,
      ),
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
      appBar: CustomAppbar(
        currentUserName: 'Lê Văn Cường',
        showTabBar: _selectedIndex == 0,
      ),
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
