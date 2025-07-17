import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/core/widgets/search_bar_widget.dart';

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}// Header Section Widget - Reusable
class HeaderSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showSearch;
  final double fontSize;
  final EdgeInsetsGeometry? padding;
  final void Function(String)? onSearchChanged;

  const HeaderSection({
    super.key,
    this.title = 'Xin chào! 👋',
    this.subtitle = 'Dịch vụ nhà chuyên nghiệp',
    this.showSearch = true,
    this.fontSize = 24,
    this.padding,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? Responsive.getPadding(context),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGray.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, base: 16),
              color: AppColors.secondary,
            ),
          ),
          if (showSearch) ...[
            const SizedBox(height: 20),
            SearchBarWidget(onChanged: onSearchChanged),
          ]
        ],
      ),
    );
  }
}
