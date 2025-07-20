import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsp_mobile/core/routes/app_routes.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/core/widgets/navigation/navigation_item.dart';
import 'package:hsp_mobile/features/account/account_provider.dart';
import 'package:hsp_mobile/features/account/views/edit_profile_screen.dart';
import 'package:hsp_mobile/features/account/views/profile_screen.dart';
import 'package:hsp_mobile/features/booking/views/main_list_booking.dart';
import 'package:hsp_mobile/features/catalog/view/category_screen.dart';
import 'package:hsp_mobile/features/home/views/home_page_screen.dart';
import 'package:hsp_mobile/features/job/views/job_list_screen.dart';
import 'package:hsp_mobile/features/job/views/my_task_screen.dart';
import 'package:provider/provider.dart';

/// Widget chính quản lý navigation layout cho toàn bộ app
/// Hỗ trợ 3 loại layout: Mobile, Tablet, Desktop
class NavigationLayout extends StatefulWidget {
  const NavigationLayout({super.key});

  @override
  State<NavigationLayout> createState() => _NavigationLayoutState();
}

class _NavigationLayoutState extends State<NavigationLayout> {
  // Biến lưu trữ chỉ số của tab hiện tại được chọn
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;

  // Danh sách các đường dẫn tương ứng với từng tab
  List<String> _getNavigationPaths(int roleId) {
    switch (roleId) {
      case 1: // Admin
        return [
          AppRoutes.home, // Admin dashboard
          AppRoutes.bookingSummary,
          AppRoutes.profile,
        ];
      case 2: // Customer
        return [
          AppRoutes.home,
          AppRoutes.categoryScreen,
          AppRoutes.mainListBooking,
          AppRoutes.profile,
          AppRoutes.editProfile,
          AppRoutes.privacy,
          AppRoutes.termsConditions,
        ];
      case 3: // Housekeeper
        return [
          AppRoutes.jobList,
          AppRoutes.housekeeperMyTask,
          AppRoutes.profile,
          AppRoutes.editProfile,
          AppRoutes.privacy,
          AppRoutes.termsConditions,
        ];
      default:
        return [AppRoutes.home, AppRoutes.profile];
    }
  }

  /// Lấy dữ liệu navigation dựa trên roleId
  ({List<Widget> screens, List<NavigationItem> items}) _getNavigationData(
    int roleId,
  ) {
    switch (roleId) {
      case 1: // Admin
        return (
          screens: const [
            HomePageScreen(), // Admin dashboard
            MainListBooking(), // Quản lý booking
            ProfileScreen(), // Hồ sơ admin
          ],
          items: [
            NavigationItem(
              icon: Icons.dashboard_outlined,
              selectedIcon: Icons.dashboard,
              label: 'navigation.dashboard'.tr(),
            ),
            NavigationItem(
              icon: Icons.book_online_outlined,
              selectedIcon: Icons.book_online,
              label: 'navigation.bookings'.tr(),
            ),
            NavigationItem(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: 'navigation.profile'.tr(),
            ),
          ],
        );
      case 2: // Customer
        return (
          screens: const [
            HomePageScreen(),
            CategoryScreen(),
            MainListBooking(),
            ProfileScreen(),
          ],
          items: [
            NavigationItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: 'navigation.home'.tr(),
            ),
            NavigationItem(
              icon: Icons.menu_outlined,
              selectedIcon: Icons.menu,
              label: 'navigation.menu'.tr(),
            ),
            NavigationItem(
              icon: Icons.book_online_outlined,
              selectedIcon: Icons.book_online,
              label: 'navigation.bookings'.tr(),
            ),
            NavigationItem(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: 'navigation.profile'.tr(),
            ),
          ],
        );
      case 3: // Housekeeper
        return (
          screens: const [JobListScreen(), MyTaskScreen(), ProfileScreen()],
          items: [
            NavigationItem(
              icon: Icons.work_outline,
              selectedIcon: Icons.work,
              label: 'navigation.jobs'.tr(),
            ),
            NavigationItem(
              icon: Icons.task_outlined,
              selectedIcon: Icons.task,
              label: 'navigation.my_tasks'.tr(),
            ),
            NavigationItem(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: 'navigation.profile'.tr(),
            ),
          ],
        );
      default:
        return (
          screens: const [HomePageScreen(), ProfileScreen()],
          items: [
            NavigationItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: 'navigation.home'.tr(),
            ),
            NavigationItem(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: 'navigation.profile'.tr(),
            ),
          ],
        );
    }
  }

  /// Hàm xử lý khi người dùng nhấn vào tab
  void _onItemTapped(int index, List<String> paths) {
    setState(() {
      _selectedIndex = index;
      context.go(paths[index]); // Navigate using go_router
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy roleId từ AccountProvider
    final accountProvider = Provider.of<AccountProvider>(context);
    final roleId = accountProvider.currentAccount?.roleId;

    // Kiểm tra nếu chưa đăng nhập hoặc roleId không hợp lệ
    if (roleId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Lấy danh sách màn hình và navigation items dựa trên roleId
    final navigationData = _getNavigationData(roleId);
    final navigationPaths = _getNavigationPaths(roleId);

    // Sử dụng widget Responsive để tự động chọn layout phù hợp
    return Responsive(
      mobile: _buildMobileLayout(context, navigationData, navigationPaths),
      tablet: _buildTabletLayout(context, navigationData, navigationPaths),
      desktop: _buildDesktopLayout(context, navigationData, navigationPaths),
    );
  }

  /// Layout cho mobile (BottomNavigationBar)
  Widget _buildMobileLayout(
    BuildContext context,
    ({List<Widget> screens, List<NavigationItem> items}) navigationData,
    List<String> navigationPaths,
  ) {
    return Scaffold(
      body: navigationData.screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.primaryLight,
        backgroundColor: AppColors.backgroundLight,
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(index, navigationPaths),
        selectedFontSize: Responsive.getFontSize(context, base: 12),
        unselectedFontSize: Responsive.getFontSize(context, base: 12),
        items:
            navigationData.items
                .asMap()
                .entries
                .map(
                  (entry) => BottomNavigationBarItem(
                    icon: Icon(
                      entry.value.icon,
                      size: Responsive.getFontSize(context, base: 24),
                    ),
                    activeIcon: Icon(
                      entry.value.selectedIcon,
                      size: Responsive.getFontSize(context, base: 24),
                    ),
                    label: entry.value.label.tr(),
                  ),
                )
                .toList(),
      ),
    );
  }

  /// Layout cho tablet (NavigationRail)
  Widget _buildTabletLayout(
    BuildContext context,
    ({List<Widget> screens, List<NavigationItem> items}) navigationData,
    List<String> navigationPaths,
  ) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Row(
        children: [
          Column(
            children: [
              Container(
                height: 80,
                width: 72,
                color: AppColors.primary,
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      'CozyCare',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.getFontSize(context, base: 14),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected:
                      (index) => _onItemTapped(index, navigationPaths),
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: AppColors.white,
                  selectedIconTheme: IconThemeData(
                    color: AppColors.primary,
                    size: 28,
                  ),
                  unselectedIconTheme: IconThemeData(
                    color: AppColors.primaryLight,
                    size: 24,
                  ),
                  selectedLabelTextStyle: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelTextStyle: const TextStyle(
                    color: AppColors.primaryLight,
                  ),
                  destinations:
                      navigationData.items
                          .map(
                            (item) => NavigationRailDestination(
                              icon: Icon(item.icon),
                              selectedIcon: Icon(item.selectedIcon),
                              label: Text(item.label.tr()),
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: navigationData.screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  /// Layout cho desktop (Sidebar)
  Widget _buildDesktopLayout(
    BuildContext context,
    ({List<Widget> screens, List<NavigationItem> items}) navigationData,
    List<String> navigationPaths,
  ) {
    final currentPath = GoRouterState.of(context).uri.toString();
    Widget currentScreen = navigationData.screens[_selectedIndex];

    // Cập nhật _selectedIndex
    int newIndex = navigationPaths.indexWhere((path) => currentPath == path);
    if (newIndex != -1 && newIndex != _selectedIndex) {
      _selectedIndex = newIndex;
    }

    // Xử lý các màn hình bổ sung
    if (currentPath.contains(AppRoutes.editProfile)) {
      final account = Provider.of<AccountProvider>(context).currentAccount!;
      currentScreen = EditProfileScreen(account: account);
    } else if (currentPath.contains(AppRoutes.privacy)) {
      currentScreen = const Scaffold(body: Center(child: Text('Privacy Screen')));
    } else if (currentPath.contains(AppRoutes.termsConditions)) {
      currentScreen = const Scaffold(body: Center(child: Text('Terms and Conditions Screen')));
    }

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isSidebarCollapsed ? 72 : 240,
            decoration: BoxDecoration(
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 80,
                  color: AppColors.primary,
                  child: Center(
                    child: _isSidebarCollapsed
                        ? IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _isSidebarCollapsed = false;
                              });
                            },
                          )
                        : Image.asset(
                            'assets/logo/logo.png',
                            width: 150,
                            height: 150,
                          ),
                  ),
                ),
                if (!_isSidebarCollapsed) const SizedBox(height: 16),
                Expanded(
                  child: _isSidebarCollapsed
                      ? ListView.builder(
                          itemCount: navigationData.items.length,
                          itemBuilder: (ctx, idx) {
                            final item = navigationData.items[idx];
                            final isSelected = _selectedIndex == idx;
                            return IconButton(
                              icon: Icon(
                                isSelected ? item.selectedIcon : item.icon,
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.tertiaryLight,
                              ),
                              onPressed: () => _onItemTapped(idx, navigationPaths),
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: navigationData.items.length,
                          itemBuilder: (ctx, idx) {
                            final item = navigationData.items[idx];
                            final isSelected = _selectedIndex == idx;
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryLight
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  isSelected ? item.selectedIcon : item.icon,
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.tertiaryLight,
                                ),
                                title: Text(
                                  item.label.tr(),
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.tertiaryLight,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                                onTap: () => _onItemTapped(idx, navigationPaths),
                                hoverColor: AppColors.primaryLight,
                              ),
                            );
                          },
                        ),
                ),
                if (!_isSidebarCollapsed)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _isSidebarCollapsed = true;
                      });
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.backgroundLight,
              padding: const EdgeInsets.all(32),
              child: currentScreen,
            ),
          ),
        ],
      ),
    );
  }
}
