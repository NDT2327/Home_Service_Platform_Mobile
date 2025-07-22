import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:hsp_mobile/core/providers/account_provider.dart';
import 'package:hsp_mobile/features/account/views/edit_profile_screen.dart';
import 'package:hsp_mobile/features/account/views/privacy_screen.dart';
import 'package:hsp_mobile/features/account/views/term_condition_screen.dart';
import 'package:hsp_mobile/features/account/widgets/navigation_list.dart';
import 'package:hsp_mobile/features/account/widgets/profile_content.dart';
import 'package:hsp_mobile/features/account/widgets/profile_header.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    final account = accountProvider.currentAccount;

    // Kiểm tra trạng thái đăng nhập
    return FutureBuilder<bool>(
      future: SharedPrefsUtils.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Kiểm tra dữ liệu tài khoản
        if (account == null) {
          return Scaffold(
            body: Center(
              child:
                  accountProvider.isLoading
                      ? const CircularProgressIndicator()
                      : Text(accountProvider.errorMessage ?? 'No account data'),
            ),
          );
        }

        return Responsive(
          mobile: _buildMobileLayout(context, account),
          tablet: _buildTabletLayout(context, account),
          desktop: _buildDesktopLayout(context, account),
        );
      },
    );
  }

  //mobile layout
  Widget _buildMobileLayout(BuildContext context, Account account) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        title: Text(
          "My Profile",
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: Responsive.getFontSize(context, base: 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: ProfileContent(account: account),
    );
  }

  //tablet
  Widget _buildTabletLayout(BuildContext context, Account account) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Row(
        children: [
          //sidebar
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                ProfileHeader(
                  fullName: account.fullName,
                  email: account.email,
                  avatar: account.avatar,
                ),
                const SizedBox(height: 20),
                NavigationList(account: account),
              ],
            ),
          ),
          //Content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: _getSelectedContent(context, account),
            ),
          ),
        ],
      ),
    );
  }

  //desktop
  //desktop layout với trang trí nâng cao
  Widget _buildDesktopLayout(BuildContext context, Account account) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundLight,
              AppColors.backgroundLight.withOpacity(0.8),
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Row(
          children: [
            //Enhanced Sidebar
            Container(
              width: 340,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(4, 0),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    spreadRadius: 0,
                    blurRadius: 40,
                    offset: const Offset(8, 0),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade100, width: 1),
              ),
              child: Column(
                children: [
                  // Header với gradient background
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: ProfileHeader(
                      fullName: account.fullName,
                      email: account.email,
                      avatar: account.avatar,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Decorative divider
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.grey.shade300,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(child: NavigationList(account: account)),
                  // Bottom decorative element
                  Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.verified_user,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Verified Account",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //Enhanced Main Content Area
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main content with enhanced container
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              spreadRadius: 0,
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              spreadRadius: 0,
                              blurRadius: 40,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.grey.shade100,
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _getSelectedContent(context, account),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods để lấy thông tin trang hiện tại
  String _getPageTitle() {
    switch (selectedIndex) {
      case 0:
        return "Edit Profile";
      case 1:
        return "Privacy Settings";
      case 2:
        return "Terms & Conditions";
      default:
        return "Profile Overview";
    }
  }

  String _getPageSubtitle() {
    switch (selectedIndex) {
      case 0:
        return "Update your personal information";
      case 1:
        return "Manage your privacy preferences";
      case 2:
        return "Review our terms and conditions";
      default:
        return "Manage your account settings";
    }
  }

  IconData _getPageIcon() {
    switch (selectedIndex) {
      case 0:
        return Icons.edit_outlined;
      case 1:
        return Icons.privacy_tip_outlined;
      case 2:
        return Icons.description_outlined;
      default:
        return Icons.person_outline;
    }
  }

  Widget _getSelectedContent(BuildContext context, Account account) {
    switch (selectedIndex) {
      case 0:
        return EditProfileScreen(account: account);
      case 1:
        return PrivacyScreen();
      case 2:
        return TermsConditionsScreen();
      default:
        return ProfileContent(account: account);
    }
  }
}
