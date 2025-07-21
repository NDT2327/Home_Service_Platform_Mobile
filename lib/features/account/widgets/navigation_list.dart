import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/routes/app_routes.dart';
import 'package:hsp_mobile/core/utils/notification_helpers.dart';
import 'package:hsp_mobile/core/providers/account_provider.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:hsp_mobile/features/account/widgets/profile_item.dart';
import 'package:provider/provider.dart';

class NavigationList extends StatelessWidget {
  final Account account;

  const NavigationList({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(
      context,
      listen: false,
    );

    final items = [
      {
        'icon': Icons.edit_rounded,
        'text': 'Edit Profile',
        'route': AppRoutes.editProfile,
        'isEdit': true,
      },
      {
        'icon': Icons.privacy_tip_rounded,
        'text': 'Privacy Policy',
        'route': AppRoutes.privacy,
      },
      {
        'icon': Icons.description_rounded,
        'text': 'Terms & Conditions',
        'route': AppRoutes.termsConditions,
      },
    ];

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ProfileItem(
                icon: Icons.logout_rounded,
                text: 'Logout',
                onTap: () async {
                  await accountProvider.logout();
                  NotificationHelpers.showToast(message: 'Logout successfully');
                  context.go(AppRoutes.login);
                },
                isLogout: true,
              ),
            );
          }

          final item = items[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(item['icon'] as IconData, color: Colors.grey[600]),
              title: Text(
                item['text'] as String,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.normal,
                ),
              ),
              onTap: () async{
                if (item['isEdit'] == true) {
                  final roleId = await SharedPrefsUtils.getRoleId() ?? 0;
                  final route = AppRoutes.getEditProfileRoute(roleId);
                  context.push(route, extra: account);
                  debugPrint("Navigating to $route with account: ${account.fullName}");
                } else {
                  context.push(item['route'] as String);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
