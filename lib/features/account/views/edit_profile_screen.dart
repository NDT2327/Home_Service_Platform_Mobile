import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/features/account/account_provider.dart';
import 'package:hsp_mobile/features/account/widgets/edit_profile_content.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final Account account;

  const EditProfileScreen({super.key, required this.account});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccountProvider>();
    final account = provider.currentAccount ?? widget.account;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
      ),
      body:
          provider.isLoading
              ? Center(child: CircularProgressIndicator())
              : EditProfileContent(account: account),
    );
  }
}
