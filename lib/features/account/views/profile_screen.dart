import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/routes/app_routes.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:hsp_mobile/features/account/account_provider.dart';
import 'package:hsp_mobile/features/account/views/edit_profile_screen.dart';
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
  Widget _buildDesktopLayout(BuildContext context, Account account) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Row(
        children: [
          //Sidebar
          Container(
            width: 320,
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
                const SizedBox(height: 30),
                NavigationList(account: account),
              ],
            ),
          ),
          //Main conten
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32),
              child: _getSelectedContent(context, account),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSelectedContent(BuildContext context, Account account) {
    switch (selectedIndex) {
      case 0:
        return EditProfileScreen(account: account);
      default:
        return ProfileContent(account: account);
    }
  }
}
