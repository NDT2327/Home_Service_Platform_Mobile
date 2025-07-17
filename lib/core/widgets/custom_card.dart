import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? badge;
  final IconData? leadingIcon;
  final Widget? trailing;
  final String? footer;
  final Gradient? gradient;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.title,
    this.subtitle,
    this.badge,
    this.leadingIcon,
    this.trailing,
    this.footer,
    this.gradient,
    this.backgroundColor,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (badge != null || trailing != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: Responsive.getFontSize(context, base: 12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (trailing != null) trailing!,
            ],
          ),
        if (badge != null || trailing != null) const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leadingIcon != null)
              Icon(leadingIcon, color: AppColors.white, size: Responsive.getFontSize(context, base: 24)),
            if (leadingIcon != null) const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: Responsive.getFontSize(context, base: 16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: Responsive.getFontSize(context, base: 14),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              footer!,
              style: TextStyle(
                color: Colors.white,
                fontSize: Responsive.getFontSize(context, base: 12),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(right: 16),
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? (backgroundColor ?? Colors.white) : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: cardContent,
      ),
    );
  }
}
