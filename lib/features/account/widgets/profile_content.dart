import 'package:flutter/material.dart';
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
    final accountProvider = Provider.of<AccountProvider>(context, listen: false);
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
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editProfile,
                      arguments: account,
                    );
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
                  onTap: () {},
                ),
                ProfileItem(
                  icon: Icons.description_rounded,
                  text: 'Terms & Conditions',
                  onTap: () {},
                ),
                SizedBox(height: 20),
                ProfileItem(
                  icon: Icons.logout_rounded,
                  text: 'Logout',
                  onTap: () async{
                    await accountProvider.logout();
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                    Helpers.showSnackBar(context, 'Logged out successfully');
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
    void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
