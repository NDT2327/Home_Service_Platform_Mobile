// Reusable Search Bar Widget
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Tìm dịch vụ...',
    this.onChanged,
    this.onSubmitted,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.textLight),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: AppColors.textLight),
        ),
      ),
    );
  }
}
