import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/features/account/views/profile_screen.dart';
import 'package:hsp_mobile/features/booking/views/main_list_booking.dart';
import 'package:hsp_mobile/features/catalog/view/category_screen.dart';
import 'package:hsp_mobile/features/home_page.dart';

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
  final List<Widget> _screens = const [
    HomePage(), // Màn hình Home (index 0)
    ProfileScreen(), // Màn hình Profile (index 1)
    CategoryScreen(),
    MainListBooking(),
  ];

  /// Hàm xử lý khi người dùng nhấn vào tab
  /// [index] - chỉ số của tab được nhấn
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật tab hiện tại
    });
  }

  // Danh sách thông tin các tab navigation
  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined, // Icon khi chưa được chọn
      selectedIcon: Icons.home, // Icon khi được chọn
      label: 'navigation.home', // Text hiển thị (sẽ được dịch)
    ),
    NavigationItem(
      icon: Icons.person_outline, // Icon khi chưa được chọn
      selectedIcon: Icons.person, // Icon khi được chọn
      label: 'navigation.profile', // Text hiển thị (sẽ được dịch)
    ),
    NavigationItem(
      icon: Icons.menu_outlined, // Icon khi chưa được chọn
      selectedIcon: Icons.menu, // Icon khi được chọn
      label: 'navigation.menu', // Text hiển thị (sẽ được dịch)
    ),
    NavigationItem(
      icon: Icons.category_outlined, // Icon khi chưa được chọn
      selectedIcon: Icons.category, // Icon khi được chọn
      label: 'navigation.booking', // Text hiển thị (sẽ được dịch)
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Sử dụng widget Responsive để tự động chọn layout phù hợp
    return Responsive(
      mobile: _buildMobileLayout(context), // Layout cho điện thoại
      tablet: _buildTabletLayout(context), // Layout cho tablet
      desktop: _buildDesktopLayout(context), // Layout cho desktop
    );
  }

  /// Xây dựng layout cho mobile (điện thoại)
  /// Sử dụng BottomNavigationBar ở phía dưới màn hình
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      // Hiển thị màn hình tương ứng với tab được chọn
      body: _screens[_selectedIndex],

      // Thanh navigation ở phía dưới
      bottomNavigationBar: BottomNavigationBar(
        // Màu của item được chọn
        selectedItemColor: AppColors.primary,

        // Màu của item chưa được chọn
        unselectedItemColor: AppColors.primaryLight,

        // Màu nền của thanh navigation
        backgroundColor: AppColors.white,

        // Chỉ số của tab hiện tại
        currentIndex: _selectedIndex,

        // Hàm callback khi nhấn vào tab
        onTap: _onItemTapped,

        // Kích thước font cho text của tab được chọn
        selectedFontSize: Responsive.getFontSize(context, base: 12),

        // Kích thước font cho text của tab chưa được chọn
        unselectedFontSize: Responsive.getFontSize(context, base: 12),

        // Tạo danh sách các item cho BottomNavigationBar
        items:
            _navigationItems.map((item) {
              return BottomNavigationBarItem(
                // Icon khi chưa được chọn
                icon: Icon(
                  item.icon,
                  size: Responsive.getFontSize(context, base: 24),
                ),
                // Icon khi được chọn
                activeIcon: Icon(
                  item.selectedIcon,
                  size: Responsive.getFontSize(context, base: 24),
                ),
                // Text hiển thị (được dịch theo ngôn ngữ)
                label: item.label.tr(),
              );
            }).toList(),
      ),
    );
  }

  /// Xây dựng layout cho tablet
  /// Sử dụng NavigationRail ở phía bên trái màn hình
  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Row(
        children: [
          // NavigationRail bên trái với tiêu đề
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
                      _navigationItems.map((item) {
                        return NavigationRailDestination(
                          icon: Icon(item.icon),
                          selectedIcon: Icon(item.selectedIcon),
                          label: Text(item.label.tr()),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),

          // Nội dung bên phải
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  /// Xây dựng layout cho desktop
  /// Sử dụng sidebar menu ở phía bên trái
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Row(
        children: [
          // Sidebar trái
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
                    itemCount: _navigationItems.length,
                    itemBuilder: (context, index) {
                      final item = _navigationItems[index];
                      final isSelected = _selectedIndex == index;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(
                            isSelected ? item.selectedIcon : item.icon,
                            color:
                                isSelected
                                    ? AppColors.primary
                                    : AppColors.primaryLight,
                          ),
                          title: Text(
                            item.label.tr(),
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? AppColors.primary
                                      : AppColors.primaryLight,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
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

          // Nội dung bên phải
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32),
              constraints: BoxConstraints(
                maxWidth: Responsive.getMaxWidth(context),
              ),
              child: _screens[_selectedIndex],
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
