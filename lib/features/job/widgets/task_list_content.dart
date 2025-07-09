import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/core/widgets/custom_button.dart';
import 'package:hsp_mobile/features/job/task_claim_provider.dart';
import 'package:hsp_mobile/features/job/widgets/task_list_item.dart';

class TaskListContent extends StatelessWidget {
  final TaskClaimProvider provider;

  const TaskListContent({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.errorMessage!,
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, base: 16.sp),
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'taskDetail.retry'.tr(),
              onPressed: () => provider.fetchAvailableTasks(),
              backgroundColor: AppColors.primary,
              textColor: AppColors.white,
            ),
          ],
        ),
      );
    }

    if (provider.availableTasks.isEmpty) {
      return Center(
        child: Text(
          'taskClaim.noTasks'.tr(),
          style: TextStyle(
            fontSize: Responsive.getFontSize(context, base: 16.sp),
            color: AppColors.mediumGray,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: Responsive.getPadding(context),
      itemCount: provider.availableTasks.length,
      itemBuilder: (context, index) {
        final booking = provider.availableTasks[index];
        return TaskListItem(detail: booking);
      },
    );
  }
}