import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/widgets/custom_appbar.dart';
import 'package:hsp_mobile/features/home/widgets/categories_section.dart';
import 'package:hsp_mobile/features/home/widgets/home_page_header.dart';
import 'package:hsp_mobile/features/home/widgets/promotion_section.dart';
import 'package:hsp_mobile/features/home/widgets/service_section.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            HeaderSection(),
            SizedBox(height: 16),
            CategoriesSection(
              categories: [
                {'icon': Icons.cleaning_services, 'title': 'Dọn dẹp'},
                {'icon': Icons.build, 'title': 'Sửa chữa'},
                {'icon': Icons.child_friendly, 'title': 'Trông trẻ'},
              ],
            ),
            SizedBox(height: 24),
            PromotionsSection(
              promotions: [
                {
                  'title': 'Giảm 20% dịch vụ giặt thảm',
                  'description': 'Áp dụng cho đơn trên 500k',
                  'discount': '-20%',
                  'code': 'CLEAN20',
                  'gradient': LinearGradient(
                    colors: [Colors.purple, Colors.deepPurpleAccent],
                  ),
                },
                {
                  'title': 'Tiết kiệm 100K',
                  'description': 'Khi đặt sửa điện nước',
                  'discount': '-100K',
                  'code': 'FIX100',
                  'gradient': LinearGradient(
                    colors: [Colors.orange, Colors.deepOrangeAccent],
                  ),
                },
              ],
            ),
            SizedBox(height: 24),
            ServicesSection(
              services: [
                {
                  'icon': Icons.cleaning_services,
                  'title': 'Vệ sinh nhà cửa',
                  'description': 'Dịch vụ dọn dẹp theo giờ',
                },
                {
                  'icon': Icons.plumbing,
                  'title': 'Sửa ống nước',
                  'description': 'Xử lý rò rỉ, thay van...',
                },
                {
                  'icon': Icons.electrical_services,
                  'title': 'Sửa điện',
                  'description': 'Thay ổ cắm, sửa chập cháy',
                },
              ],
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
