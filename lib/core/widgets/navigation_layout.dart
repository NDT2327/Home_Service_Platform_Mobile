import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/features/account/account_provider.dart';
import 'package:hsp_mobile/features/account/views/profile_screen.dart';
import 'package:hsp_mobile/features/booking/views/main_list_booking.dart';
import 'package:hsp_mobile/features/catalog/view/category_screen.dart';
import 'package:hsp_mobile/features/home_page.dart';
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
  // 0 = Home, 1 = Profile
  int _selectedIndex = 0;

  // Danh sách các màn hình tương ứng với từng tab
  // final List<Widget> _screens = const [
  //   HomePage(), // Màn hình Home (index 0)
  //   ProfileScreen(), // Màn hình Profile (index 1)
  //   CategoryScreen(),
  //   MainListBooking(),
  // ];

   /// Lấy dữ liệu navigation dựa trên roleId
  ({List<Widget> screens, List<NavigationItem> items}) _getNavigationData(int roleId) {
    switch (roleId) {
      case 1: // Admin
        return (
          screens: const [
            HomePage(), // Admin dashboard (có thể thay bằng AdminDashboardScreen)
            MainListBooking(), // Quản lý booking
            ProfileScreen(), // Hồ sơ admin
          ],
          items: [
            NavigationItem(
              icon: Icons.dashboard_outlined,
              selectedIcon: Icons.dashboard,
              label: 'navigation.dashboard',
            ),
            NavigationItem(
              icon: Icons.book_online_outlined,
              selectedIcon: Icons.book_online,
              label: 'navigation.bookings',
            ),
            NavigationItem(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: 'navigation.profile',
            ),
          ],
        );
      case 2: // Customer
        return (
          screens: const [
            HomePage(),
            CategoryScreen(),
            MainListBooking(),
            ProfileScreen(),
          ],
          items: [
            NavigationItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: 'navigation.home',
            ),
            NavigationItem(
              icon: Icons.menu_outlined,
              selectedIcon: Icons.menu,
              label: 'navigation.menu',
            ),
            NavigationItem(
              icon: Icons.book_online_outlined,
              selectedIcon: Icons.book_online,
              label: 'navigation.bookings',
            ),
            NavigationItem(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: 'navigation.profile',
            ),
          ],
        );
      case 3: // Housekeeper
        return (
          screens: const [
            //HousekeeperHomeScreen(currentUserName: "Housekeeper"),
            JobListScreen(),
            MyTaskScreen(),
            ProfileScreen(),
          ],
          items: [
            // NavigationItem(
            //   icon: Icons.home_outlined,
            //   selectedIcon: Icons.home,
            //   label: 'navigation.home',
            // ),
            NavigationItem(
              icon: Icons.work_outline,
              selectedIcon: Icons.work,
              label: 'navigation.jobs',
            ),
            NavigationItem(
              icon: Icons.task_outlined,
              selectedIcon: Icons.task,
              label: 'navigation.my_tasks',
            ),
            NavigationItem(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: 'navigation.profile',
            ),
          ],
        );
      default:
        return (
          screens: const [HomePage(), ProfileScreen()],
          items: [
            NavigationItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: 'navigation.home',
            ),
            NavigationItem(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: 'navigation.profile',
            ),
          ],
        );
    }
  }

  /// Hàm xử lý khi người dùng nhấn vào tab
  /// [index] - chỉ số của tab được nhấn
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật tab hiện tại
    });
  }

  // Danh sách thông tin các tab navigation
  // final List<NavigationItem> _navigationItems = [
  //   NavigationItem(
  //     icon: Icons.home_outlined, // Icon khi chưa được chọn
  //     selectedIcon: Icons.home, // Icon khi được chọn
  //     label: 'navigation.home', // Text hiển thị (sẽ được dịch)
  //   ),
  //   NavigationItem(
  //     icon: Icons.person_outline, // Icon khi chưa được chọn
  //     selectedIcon: Icons.person, // Icon khi được chọn
  //     label: 'navigation.profile', // Text hiển thị (sẽ được dịch)
  //   ),
  //   NavigationItem(
  //     icon: Icons.menu_outlined, // Icon khi chưa được chọn
  //     selectedIcon: Icons.menu, // Icon khi được chọn
  //     label: 'navigation.menu', // Text hiển thị (sẽ được dịch)
  //   ),
  //   NavigationItem(
  //     icon: Icons.category_outlined, // Icon khi chưa được chọn
  //     selectedIcon: Icons.category, // Icon khi được chọn
  //     label: 'navigation.booking', // Text hiển thị (sẽ được dịch)
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    //get current account's role
    final accountProvider = Provider.of<AccountProvider>(context);
    final roleId = accountProvider.currentAccount?.roleId;
    print(roleId);

        // Kiểm tra nếu chưa đăng nhập hoặc roleId không hợp lệ
    if (roleId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Lấy danh sách màn hình và navigation items dựa trên roleId
    final navigationData = _getNavigationData(roleId);

    // Sử dụng widget Responsive để tự động chọn layout phù hợp
    return Responsive(
      mobile: _buildMobileLayout(context, navigationData), // Layout cho điện thoại
      tablet: _buildTabletLayout(context, navigationData), // Layout cho tablet
      desktop: _buildDesktopLayout(context, navigationData), // Layout cho desktop
    );
  }

  /// Xây dựng layout cho mobile (điện thoại)
  /// Sử dụng BottomNavigationBar ở phía dưới màn hình
   /// Layout cho mobile (BottomNavigationBar)
  Widget _buildMobileLayout(BuildContext context, ({List<Widget> screens, List<NavigationItem> items}) navigationData) {
    return Scaffold(
      body: navigationData.screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.primaryLight,
        backgroundColor: AppColors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedFontSize: Responsive.getFontSize(context, base: 12),
        unselectedFontSize: Responsive.getFontSize(context, base: 12),
        items: navigationData.items
            .map((item) => BottomNavigationBarItem(
                  icon: Icon(item.icon, size: Responsive.getFontSize(context, base: 24)),
                  activeIcon: Icon(item.selectedIcon, size: Responsive.getFontSize(context, base: 24)),
                  label: item.label.tr(),
                ))
            .toList(),
      ),
    );
  }

  /// Layout cho tablet (NavigationRail)
  Widget _buildTabletLayout(BuildContext context, ({List<Widget> screens, List<NavigationItem> items}) navigationData) {
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
                  onDestinationSelected: _onItemTapped,
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: AppColors.white,
                  selectedIconTheme: IconThemeData(color: AppColors.primary, size: 28),
                  unselectedIconTheme: IconThemeData(color: AppColors.primaryLight, size: 24),
                  selectedLabelTextStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                  unselectedLabelTextStyle: const TextStyle(color: AppColors.primaryLight),
                  destinations: navigationData.items
                      .map((item) => NavigationRailDestination(
                            icon: Icon(item.icon),
                            selectedIcon: Icon(item.selectedIcon),
                            label: Text(item.label.tr()),
                          ))
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
  Widget _buildDesktopLayout(BuildContext context, ({List<Widget> screens, List<NavigationItem> items}) navigationData) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Row(
        children: [
          Container(
            width: 240,
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(1, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 80,
                  color: AppColors.backgroundLight,
                  child: Center(
                    child: Image.asset(
                      'assets/logo/logo.jpg',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: navigationData.items.length,
                    itemBuilder: (context, index) {
                      final item = navigationData.items[index];
                      final isSelected = _selectedIndex == index;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(
                            isSelected ? item.selectedIcon : item.icon,
                            color: isSelected ? AppColors.primary : AppColors.primaryLight,
                          ),
                          title: Text(
                            item.label.tr(),
                            style: TextStyle(
                              color: isSelected ? AppColors.primary : AppColors.primaryLight,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          onTap: () => _onItemTapped(index),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32),
              constraints: BoxConstraints(maxWidth: Responsive.getMaxWidth(context)),
              child: navigationData.screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

/// Class định nghĩa thông tin cho một item navigation
class NavigationItem {
  final IconData icon; // Icon khi chưa được chọn
  final IconData selectedIcon; // Icon khi được chọn
  final String label; // Text hiển thị

  NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
