import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/features/profile/widgets/profile_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockAccount = Account(
      accountId: 1,
      email: "housekeeper@cozycare.com",
      password: "1234567890",
      address: "789 Wall Street, NYC",
      avatar: "assets/images/avatar.png",
      phone: "0123456789",
      createdBy: "dddđ",
      fullName: "Le Van Cuong",
      roleId: 3,
      statusId: 1,
    );
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        title: Text(
          "My Profile",
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          //avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(
                  'assets/images/avatar.png',
                ), // Replace with your image
                backgroundColor: Colors.grey[300],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          //Fullname
          Text(
            mockAccount.fullName,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),

          //Item
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ProfileItem(
                    icon: Icons.info_rounded,
                    text: "Information",
                    onTap: () {},
                  ),
                  ProfileItem(
                    icon: Icons.edit_rounded,
                    text: 'Edit Profile',
                    onTap: () {},
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
                    onTap: () {},
                    isLogout: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //mobile layout
  //tablet and desktop layout
}
