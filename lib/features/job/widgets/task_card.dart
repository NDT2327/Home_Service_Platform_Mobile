import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/models/task_claim.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/enum.dart';
import 'package:hsp_mobile/core/utils/helpers.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';

class TaskCard extends StatelessWidget {
  final BookingDetail bookingDetail;
  final bool showActions;
  final Function(BookingDetail) onJobDetail;
  final Function(int) onClaimJob;
  final Function(int) onCompleteJob;

  const TaskCard({
    super.key,
    required this.bookingDetail,
    required this.showActions,
    required this.onJobDetail,
    required this.onClaimJob,
    required this.onCompleteJob,
  });

  Color getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return AppColors.accentOrange;
      case 'CLAIMED':
        return AppColors.primary;
      case 'COMPLETED':
        return AppColors.success;
      default:
        return AppColors.mediumGray;
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'PENDING':
        return 'taskDetail.pending'.tr();
      case 'CLAIMED':
        return 'taskDetail.claimed'.tr();
      case 'COMPLETED':
        return 'taskDetail.completed'.tr();
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Padding(
        padding: Responsive.getPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookingDetail.serviceName,
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, base: 18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Text(
                      //   bookingDetail.category,
                      //   style: TextStyle(
                      //     fontSize: Responsive.getFontSize(context, base: 14),
                      //     color: AppColors.mediumGray,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: getStatusColor(
                      bookingDetail.status,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    getStatusText(bookingDetail.status),
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, base: 12),
                      color: getStatusColor(bookingDetail.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _buildDetailRow(context, Icons.person, bookingDetail.customerName),
            _buildDetailRow(
              context,
              Icons.location_on,
              bookingDetail.customerAddress,
            ),
            _buildDetailRow(
              context,
              Icons.calendar_today,
              Helpers.formatDate(bookingDetail.scheduleDatetime),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Helpers.formatMoney(bookingDetail.unitPrice),
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, base: 20),
                    fontWeight: FontWeight.bold,
                    color: AppColors.tertiary,
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => onJobDetail(bookingDetail),
                      icon: const Icon(
                        Icons.visibility,
                        size: 16,
                        color: AppColors.black,
                      ),
                      label: Text(
                        'taskClaim.details'.tr(),
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(
                            context,
                            base: 16.sp,
                          ),
                          color: AppColors.black,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    if (showActions && bookingDetail.status == 'PENDING')
                      ElevatedButton.icon(
                        onPressed: () => onClaimJob(bookingDetail.detailId),
                        icon: const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.white,
                        ),
                        label: Text(
                          'taskClaim.claim'.tr(),
                          style: TextStyle(
                            fontSize: Responsive.getFontSize(
                              context,
                              base: 16.sp,
                            ),
                            color: AppColors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                        ),
                      ),
                    if (showActions && bookingDetail.status == 'CLAIMED')
                      ElevatedButton.icon(
                        onPressed: () => onCompleteJob(bookingDetail.detailId),
                        icon: const Icon(Icons.check_circle, size: 16),
                        label: Text('taskClaim.complete'.tr()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tertiaryLight,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.mediumGray),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, base: 14),
                color: AppColors.mediumGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
