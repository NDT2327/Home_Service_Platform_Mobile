import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsp_mobile/core/routes/app_routes.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/enums/booking_status.dart';
import 'package:hsp_mobile/core/utils/helpers.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/core/widgets/link_button.dart';

class RecentBookingSection extends StatelessWidget {
  final List<Map<String, dynamic>> bookings;

  const RecentBookingSection({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    // Get the most recent booking (first item after sorting by deadline)
    final recentBooking = bookings.isNotEmpty ? bookings.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: Responsive.getPadding(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'home.recent_booking'.tr(),
                style: TextStyle(
                  fontSize: Responsive.getFontSize(context, base: 18),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
              if (bookings.isNotEmpty)
                LinkButton(
                  text: 'home.view_all'.tr(),
                  textColor: AppColors.primary,
                  onPressed: () {
                    context.push('${AppRoutes.mainLayout}/customer${AppRoutes.mainListBooking}');
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        recentBooking == null
            ? Padding(
              padding: Responsive.getPadding(context),
              child: Text(
                'home.no_bookings'.tr(),
                style: TextStyle(
                  fontSize: Responsive.getFontSize(context, base: 16),
                  color: Colors.grey[600],
                ),
              ),
            )
            : _buildBookingCard(context, recentBooking),
      ],
    );
  }

  Widget _buildBookingCard(BuildContext context, Map<String, dynamic> booking) {
    final status = BookingStatusExt.fromId(booking['statusId'] as int);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking['bookingNumber'],
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, base: 16),
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Helpers.formatDate(booking['deadline'] as DateTime),

              style: TextStyle(
                fontSize: Responsive.getFontSize(context, base: 14),
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              Helpers.formatMoney(booking['totalAmount'] as double),
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, base: 14),
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              status.label,
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, base: 14),
                color: status.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
