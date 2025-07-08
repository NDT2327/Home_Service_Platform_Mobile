import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/enum.dart';


class TaskCard extends StatelessWidget {
  final String serviceName;
  final DateTime scheduleTime;
  final String customerName;
  final String address;
  final String customerPhone;
  final String status;
  final String? image; // Thêm trường image
  final VoidCallback? onTap;
  final VoidCallback? onCompleted;
  final VoidCallback? onCancel;

  const TaskCard({
    super.key,
    required this.serviceName,
    required this.scheduleTime,
    required this.customerName,
    required this.address,
    required this.customerPhone,
    required this.status,
    this.image,
    this.onTap,
    this.onCompleted,
    this.onCancel,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'claimed':
        return AppColors.success;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.hourglass_empty;
      case 'cancelled':
        return Icons.cancel;
      case 'claimed':
        return Icons.assignment_turned_in;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActionable = status.toLowerCase() == TaskClaimStatus.claimed.name;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        color: AppColors.backgroundLight,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(
            color: _getStatusColor().withOpacity(0.5),
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiển thị hình ảnh dịch vụ
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: image != null && image!.isNotEmpty
                    ? Image.network(
                        image!,
                        width: 80.w,
                        height: 80.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                      )
                    : _buildPlaceholderImage(),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceName,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextColor(context),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'taskClaim.schedule'.tr(args: [DateFormat('dd/MM/yyyy HH:mm').format(scheduleTime)]),
                      style: TextStyle(fontSize: 14.sp, color: AppColors.mediumGray),
                    ),
                    Text(
                      'taskClaim.customer'.tr(args: [customerName]),
                      style: TextStyle(fontSize: 14.sp, color: AppColors.mediumGray),
                    ),
                    Text(
                      'taskClaim.address'.tr(args: [address]),
                      style: TextStyle(fontSize: 14.sp, color: AppColors.mediumGray),
                    ),
                    Text(
                      'taskClaim.phone'.tr(args: [customerPhone]),
                      style: TextStyle(fontSize: 14.sp, color: AppColors.mediumGray),
                    ),
                    Row(
                      children: [
                        Icon(_getStatusIcon(), color: _getStatusColor(), size: 16.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'taskClaim.status'.tr(args: [status]),
                          style: TextStyle(fontSize: 14.sp, color: _getStatusColor()),
                        ),
                      ],
                    ),
                    if (isActionable) SizedBox(height: 12.h),
                    if (isActionable)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: onCompleted,
                              icon: Icon(Icons.check, size: 16.sp),
                              label: Text('taskClaim.complete'.tr(), style: TextStyle(fontSize: 14.sp)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                foregroundColor: AppColors.white,
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                textStyle: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: onCancel,
                              icon: Icon(Icons.close, size: 16.sp),
                              label: Text('taskClaim.cancel'.tr(), style: TextStyle(fontSize: 14.sp)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: BorderSide(color: AppColors.error),
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                textStyle: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 80.w,
      height: 80.h,
      color: AppColors.mediumGray.withOpacity(0.2),
      child: Icon(
        Icons.image_not_supported,
        color: AppColors.mediumGray,
        size: 40.sp,
      ),
    );
  }
}