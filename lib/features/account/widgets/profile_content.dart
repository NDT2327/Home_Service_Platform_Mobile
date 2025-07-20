import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/routes/app_routes.dart';
import 'package:hsp_mobile/core/utils/helpers.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/features/account/account_provider.dart';
import 'package:hsp_mobile/features/account/views/edit_profile_screen.dart';
import 'package:hsp_mobile/features/account/widgets/profile_header.dart';
import 'package:hsp_mobile/features/account/widgets/profile_item.dart';
import 'package:provider/provider.dart';

class ProfileContent extends StatelessWidget {
  final Account account;
  const ProfileContent({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(
      context,
      listen: false,
    );
    final scaffoldMessenger = ScaffoldMessenger.of(context); // Store reference

    return Column(
      children: [
        ProfileHeader(
          fullName: account.fullName,
          email: account.email,
          avatar: account.avatar,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            padding: Responsive.getPadding(context),
            child: Column(
              children: [
                ProfileItem(
                  icon: Icons.edit_rounded,
                  text: 'Edit Profile',
                  onTap: () {
                    context.push(AppRoutes.editProfile, extra: account);
                  },
                ),
                ProfileItem(
                  icon: Icons.lock_rounded,
                  text: 'Change Password',
                  onTap: () {},
                ),
                ProfileItem(
                  icon: Icons.privacy_tip_rounded,
                  text: 'Privacy Policy',
                  onTap: () {
                    context.push(AppRoutes.privacy);
                  },
                ),
                ProfileItem(
                  icon: Icons.description_rounded,
                  text: 'Terms & Conditions',
                  onTap: () {
                    context.push(AppRoutes.termsConditions);
                  },
                ),
                const SizedBox(height: 20),
                ProfileItem(
                  icon: Icons.logout_rounded,
                  text: 'Logout',
                  onTap: () async {
                    try {
                      // Perform logout
                      await accountProvider.logout();
                      // Show snackbar before navigation
                      Helpers.showSnackBarWithMessenger(
                        ScaffoldMessenger.of(context),
                        'Logged out successfully',
                      );
                      // Delay navigation to ensure snackbar is displayed
                      await Future.delayed(const Duration(milliseconds: 500));
                      if (context.mounted) {
                        context.go(AppRoutes.login);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Helpers.showSnackBarWithMessenger(
                          ScaffoldMessenger.of(context),
                          'Login failed: $e',
                        );
                      }
                    }
                  },
                  isLogout: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
