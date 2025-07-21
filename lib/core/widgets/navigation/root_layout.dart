import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsp_mobile/core/routes/app_routes.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/core/widgets/navigation/desktop_navigation_scaffold.dart';
import 'package:hsp_mobile/core/widgets/navigation/mobile_navigation_scaffold.dart';
import 'package:hsp_mobile/core/widgets/navigation/nav_item.dart';
import 'package:hsp_mobile/core/widgets/navigation/tablet_navigation_scaffold.dart';
import 'package:hsp_mobile/core/providers/account_provider.dart';
import 'package:hsp_mobile/features/account/views/profile_screen.dart';
import 'package:hsp_mobile/features/booking/views/main_list_booking.dart';
import 'package:hsp_mobile/features/catalog/view/category_screen.dart';
import 'package:hsp_mobile/features/home/views/home_page_screen.dart';
import 'package:hsp_mobile/features/job/views/job_list_screen.dart';
import 'package:hsp_mobile/features/job/views/my_task_screen.dart';
import 'package:provider/provider.dart';

class RootLayout extends StatefulWidget {
  //nhận content của các màn khác được liệt kê trong app_router
  final Widget screen;
  const RootLayout({super.key, required this.screen});

  @override
  State<RootLayout> createState() => _RootLayoutState();
}

class _RootLayoutState extends State<RootLayout> {
  int _selectedIndex = 0;

  //danh sách các screens và items theo role sau khi đăng nhập thành công
  List<NavItem> _getNavigationItems(int roleId) {
    switch (roleId) {
      case 1:
        return [
          //admin
          NavItem(
            Icons.dashboard,
            'navigation.dashboard'.tr(),
            const HomePageScreen(),
            '${AppRoutes.mainLayout}/admin${AppRoutes.home}',
          ),
          NavItem(
            Icons.book_online_outlined,
            'navigation.bookings'.tr(),
            const MainListBooking(),
            '${AppRoutes.mainLayout}/admin${AppRoutes.mainListBooking}',
          ),
          NavItem(
            Icons.person_2_outlined,
            'navigation.profile'.tr(),
            const ProfileScreen(),
            '${AppRoutes.mainLayout}/admin${AppRoutes.profile}',
          ),
        ];
      case 2:
        return [
          //customer
          NavItem(
            Icons.home,
            'navigation.home'.tr(),
            const HomePageScreen(),
            '${AppRoutes.mainLayout}/customer${AppRoutes.home}',
          ),
          NavItem(
            Icons.menu,
            'navigation.menu'.tr(),
            const CategoryScreen(),
            '${AppRoutes.mainLayout}/customer${AppRoutes.categoryScreen}',
          ),
          NavItem(
            Icons.book_online,
            'navigation.bookings'.tr(),
            const MainListBooking(),
            '${AppRoutes.mainLayout}/customer${AppRoutes.mainListBooking}',
          ),
          NavItem(
            Icons.person,
            'navigation.profile'.tr(),
            const ProfileScreen(),
            '${AppRoutes.mainLayout}/customer${AppRoutes.profile}',
          ),
        ];
      case 3:
        return [
          //housekeepr
          NavItem(
            Icons.work,
            'navigation.jobs'.tr(),
            const JobListScreen(),
            '${AppRoutes.mainLayout}/housekeeper${AppRoutes.jobList}',
          ),
          NavItem(
            Icons.task,
            'navigation.my_tasks'.tr(),
            const MyTaskScreen(),
            '${AppRoutes.mainLayout}/housekeeper${AppRoutes.housekeeperMyTask}',
          ),
          NavItem(
            Icons.person,
            'navigation.profile'.tr(),
            const ProfileScreen(),
            '${AppRoutes.mainLayout}/housekeeper${AppRoutes.profile}',
          ),
        ];
      default:
        return [
          NavItem(
            Icons.home,
            'navigation.home'.tr(),
            const HomePageScreen(),
            '${AppRoutes.mainLayout}/default${AppRoutes.home}',
          ),
          NavItem(
            Icons.person,
            'navigation.profile'.tr(),
            const ProfileScreen(),
            '${AppRoutes.mainLayout}/default${AppRoutes.profile}',
          ),
        ];
    }
  }

  void _onItemTapped(int index, List<NavItem> items) {
    setState(() => _selectedIndex = index);
    context.go(items[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final roleId = context.watch<AccountProvider>().currentAccount?.roleId ?? 0;
    final items = _getNavigationItems(roleId);

    return Responsive(
      mobile: MobileNavigationScaffold(
        items: items,
        selectedIndex: _selectedIndex,
        onTap: (i) => _onItemTapped(i, items),
        screen: widget.screen,
      ),
      tablet: TabletNavigationScaffold(
        items: items,
        selectedIndex: _selectedIndex,
        onTap: (i) => _onItemTapped(i, items),
        screen: widget.screen,
      ),
      desktop: DesktopNavigationScaffold(
        items: items,
        selectedIndex: _selectedIndex,
        onTap: (i) => _onItemTapped(i, items),
        screen: widget.screen,
      ),
    );
  }
}
