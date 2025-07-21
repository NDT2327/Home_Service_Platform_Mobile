import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/providers/account_provider.dart';
import 'package:hsp_mobile/core/providers/auth_provider.dart';
import 'package:hsp_mobile/core/providers/booking_provider.dart';
import 'package:hsp_mobile/core/providers/catalog_provider.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:hsp_mobile/core/widgets/custom_appbar.dart';
import 'package:hsp_mobile/features/home/widgets/categories_section.dart';
import 'package:hsp_mobile/features/home/widgets/home_page_header.dart';
import 'package:hsp_mobile/features/home/widgets/recent_booking_section.dart';
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
    Future.microtask(() async{
      final catalogProvider = context.read<CatalogProvider>();
      final bookingProvider = context.read<BookingProvider>();
      catalogProvider.loadCategories();
      catalogProvider.loadAllServices();
      final userId = await SharedPrefsUtils.getAccountId() ?? 0;
      await bookingProvider.loadBookingsForUser(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final catalogProvider = context.watch<CatalogProvider>();
    final bookingProvider = context.watch<BookingProvider>();

    final customerName = accountProvider.currentAccount?.fullName ?? "Guest";
    final isLoading = catalogProvider.isLoadingCategories || bookingProvider.isLoading;

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
                  RecentBookingSection(
                    bookings: bookingProvider.bookings
                        .map((booking) => {
                              'bookingNumber': booking.bookingNumber,
                              'deadline': booking.deadline,
                              'totalAmount': booking.totalAmount,
                              'statusId': booking.bookingStatusId,
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