import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/helpers.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';

class TaskDetailModal extends StatelessWidget {
  final BookingDetail bookingDetail;
  final VoidCallback? onClaim;

  const TaskDetailModal({super.key, required this.bookingDetail, this.onClaim});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: Responsive.getPadding(context),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.mediumGray,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            Text(
              bookingDetail.serviceName,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 12.h),
            _buildDetailRow(Icons.person, bookingDetail.customerName),
            _buildDetailRow(Icons.phone, bookingDetail.customerPhone),
            _buildDetailRow(Icons.location_on, bookingDetail.customerAddress),
            _buildDetailRow(
              Icons.calendar_today,
              Helpers.formatDate(bookingDetail.scheduleDatetime),
            ),
            _buildDetailRow(
              Icons.access_time,
              DateFormat.Hm().format(bookingDetail.scheduleDatetime),
            ),
            _buildDetailRow(
              Icons.confirmation_number,
              'Số lượng: ${bookingDetail.quantity}',
            ),
            _buildDetailRow(
              Icons.monetization_on,
              'Đơn giá: ${Helpers.formatMoney(bookingDetail.unitPrice)}',
            ),
            _buildDetailRow(
              Icons.calculate,
              'Tổng tiền: ${Helpers.formatMoney(bookingDetail.totalAmount)}',
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('common.close'.tr()),
                ),
                if (bookingDetail.status == 'PENDING' && onClaim != null)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Close modal
                      onClaim!(); // Trigger action
                    },
                    icon: const Icon(
                      Icons.check_circle,
                      color: AppColors.white,
                    ),
                    label: Text(
                      'taskClaim.claim'.tr(),
                      style: TextStyle(color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.mediumGray),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
