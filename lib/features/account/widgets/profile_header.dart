import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';

class ProfileHeader extends StatelessWidget {
  final String fullName;
  final String email;
  final String avatar;
  const ProfileHeader({
    super.key,
    required this.fullName,
    required this.email,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: Responsive.isDesktop(context) ? 50 : 40,
                backgroundImage: NetworkImage(avatar),
                backgroundColor: AppColors.mediumGray,
                onBackgroundImageError: (exception, stackTrace) {
                },
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          //fullname
          Text(
            fullName,
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, base: 14),
              color: AppColors.darkGray,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          //email
          Text(
            email,
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, base: 14),
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }
}
