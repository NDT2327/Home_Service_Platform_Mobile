
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/core/widgets/custom_text_field.dart';
import 'package:hsp_mobile/core/providers/task_claim_provider.dart';
import 'package:provider/provider.dart';

class RejectDialog extends StatefulWidget {
  final BookingDetail detail;
  final int housekeeperId;

  const RejectDialog({
    super.key,
    required this.detail,
    required this.housekeeperId,
  });

  @override
  State<RejectDialog> createState() => _RejectDialogState();
}

class _RejectDialogState extends State<RejectDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskClaimProvider>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cancel_outlined, size: 48.r, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(
              'taskClaim.rejectReason'.tr(),
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, base: 20.sp),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: _reasonController,
              labelText: 'taskClaim.enterReason'.tr(),
            ),
            SizedBox(height: 24.h),
            Row(
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
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                    onPressed: () async {
                      // final reason = _reasonController.text.trim();
                      // if (reason.isEmpty) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text('taskClaim.enterReasonError'.tr()),
                      //       backgroundColor: AppColors.error,
                      //     ),
                      //   );
                      //   return;
                      // }

                      // try {
                      //   await provider.cancelTaskClaim(widget.detail.detailId, reason);
                      //   if (context.mounted) Navigator.pop(context);
                      //   if (context.mounted) {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //         content: Text(
                      //           'taskClaim.cancelSuccess'.tr(args: [widget.detail.serviceName]),
                      //         ),
                      //         backgroundColor: AppColors.success,
                      //       ),
                      //     );
                      //   }
                      // } catch (e) {
                      //   if (context.mounted) {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //         content: Text(
                      //           'taskClaim.claimError'.tr(args: [e.toString()]),
                      //         ),
                      //         backgroundColor: AppColors.error,
                      //       ),
                      //     );
                      //   }
                      // }
                    },
                    child: Text('taskClaim.submit'.tr()),
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