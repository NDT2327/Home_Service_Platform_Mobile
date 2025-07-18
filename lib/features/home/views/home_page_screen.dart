import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/providers/auth_provider.dart';
import 'package:hsp_mobile/core/providers/catalog_provider.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/widgets/custom_appbar.dart';
import 'package:hsp_mobile/features/home/widgets/categories_section.dart';
import 'package:hsp_mobile/features/home/widgets/home_page_header.dart';
import 'package:hsp_mobile/features/home/widgets/service_section.dart';
import 'package:provider/provider.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final catalogProvider = context.read<CatalogProvider>();
      catalogProvider.loadCategories();
      catalogProvider.loadAllServices();
    });
  }

@override
Widget build(BuildContext context) {
  final authProvider = context.watch<AuthProvider>();
  final catalogProvider = context.watch<CatalogProvider>();

  final customerName = authProvider.loginData?.account.fullName ?? 'Khách';
  print(authProvider.loginData?.account.fullName);
  final isLoading = catalogProvider.isLoadingCategories;

  return Scaffold(
    backgroundColor: AppColors.backgroundLight,
    appBar: CustomAppbar(),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                HeaderSection(customerName: customerName),
                const SizedBox(height: 16),
                CategoriesSection(
                  categories: catalogProvider.categories
                      .map((cat) => {
                            'icon': Icons.cleaning_services,
                            'name': cat.categoryName,
                          })
                      .toList(),
                ),
                const SizedBox(height: 24),
                ServicesSection(
                  services: catalogProvider.services
                      .map((svc) => {
                            'icon': Icons.cleaning_services,
                            'title': svc.serviceName,
                            'description': svc.description ?? '',
                          })
                      .toList(),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
  );
}
}