import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsp_mobile/core/routes/app_routes.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';

class CategoriesSection extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const CategoriesSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Responsive.getPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Categories",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: Responsive.getFontSize(context, base: 20),
            ),
          ),
          SizedBox(height: Responsive.isMobile(context) ? 12 : 20),
          _buildCategoriesLayout(context),
        ],
      ),
    );
  }

  Widget _buildCategoriesLayout(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    if (isMobile) {
      return _buildHorizontalScrollList(context);
    } else if (isTablet) {
      return _buildGridLayout(context, crossAxisCount: 3);
    } else {
      return _buildWrapLayout(context);
    }
  }

  Widget _buildWrapLayout(BuildContext context) {
    final spacing = 24.0;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing + 8,
        children:
            categories.map((category) {
              return _buildCategoryItem(context, category, 0); // index not used
            }).toList(),
      ),
    );
  }

  // Horizontal scroll cho mobile
  Widget _buildHorizontalScrollList(BuildContext context) {
    return SizedBox(
      height: _getCategoryItemHeight(context),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return _buildCategoryItem(context, categories[index], index);
        },
      ),
    );
  }

  // Grid layout cho tablet & desktop
  Widget _buildGridLayout(BuildContext context, {required int crossAxisCount}) {
    final spacing = Responsive.isDesktop(context) ? 24.0 : 16.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          padding: EdgeInsets.only(top: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return _buildCategoryItem(context, categories[index], index);
          },
        );
      },
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    Map<String, dynamic> category,
    int index,
  ) {
    final avatarRadius = _getAvatarRadius(context);
    final textWidth = _getTextWidth(context);
    final fontSize = _getTextFontSize(context);
    final verticalSpacing = Responsive.isDesktop(context) ? 10.0 : 8.0;

    return GestureDetector(
      onTap: () {
        final categoryId = category['id'] as int;
        final categoryName = category['name'] as String;
        GoRouter.of(context).go(
          '${AppRoutes.mainLayout}/customer${AppRoutes.service}/$categoryId',
          extra: categoryName,
        );
      },
      child: SizedBox(
        width: _getItemWidth(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: avatarRadius,
              backgroundColor: Colors.blue.shade100,
              child:
                  category['image'] != null && category['image'].isNotEmpty
                      ? ClipOval(
                        child: Image.network(
                          category['image'],
                          width: avatarRadius * 2,
                          height: avatarRadius * 2,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => Icon(
                                Icons.broken_image,
                                size: avatarRadius * 0.8,
                                color: Colors.blue,
                              ),
                        ),
                      )
                      : Icon(
                        Icons.category,
                        size: avatarRadius * 0.8,
                        color: Colors.blue,
                      ),
            ),
            SizedBox(height: Responsive.isMobile(context) ? 6 : 10),
            Text(
              category['name'],
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  // Helper tính toán kích thước responsive
  double _getCategoryItemHeight(BuildContext context) {
    if (Responsive.isMobile(context)) return 110;
    if (Responsive.isTablet(context)) return 130;
    return 160;
  }

  double _getAvatarRadius(BuildContext context) {
    if (Responsive.isMobile(context)) return 30;
    if (Responsive.isTablet(context)) return 36;
    return 42;
  }

  double _getTextWidth(BuildContext context) {
    if (Responsive.isMobile(context)) return 70;
    if (Responsive.isTablet(context)) return 90;
    return 90;
  }

  double _getTextFontSize(BuildContext context) {
    if (Responsive.isMobile(context)) return 11;
    if (Responsive.isTablet(context)) return 13;
    return 13;
  }

  double _getItemWidth(BuildContext context) {
    if (Responsive.isMobile(context)) return 80;
    if (Responsive.isTablet(context)) return 100;
    return 120; // desktop
  }
}
