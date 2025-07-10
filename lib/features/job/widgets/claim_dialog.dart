import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/features/job/task_claim_provider.dart';
import 'package:provider/provider.dart';

class ClaimDialog extends StatelessWidget {
  final BookingDetail detail;
  final int housekeeperId;

  const ClaimDialog({
    super.key,
    required this.detail,
    required this.housekeeperId,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskClaimProvider>(context, listen: false);

    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_turned_in_rounded, size: 48.r, color: AppColors.primary),
            SizedBox(height: 16.h),
            Text(
              'taskClaim.claimConfirm'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, base: 20.sp),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'taskClaim.claimPrompt'.tr(args: [detail.serviceName]),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, base: 16.sp),
                color: AppColors.mediumGray,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('taskClaim.cancel'.tr()),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await provider.claimTask(
                        detailId: detail.detailId,
                        housekeeperId: housekeeperId,
                      );
                      if (context.mounted) Navigator.pop(context);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('taskClaim.claimSuccess'.tr()),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(16.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                    child: Text('taskClaim.confirm'.tr()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}