import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/features/job/widgets/task_list_item.dart';

class TaskListContent extends StatelessWidget {
  final List<BookingDetail> availableTasks;

  const TaskListContent({super.key, required this.availableTasks});

  @override
  Widget build(BuildContext context) {
    // Kiểm tra nếu danh sách rỗng
    if (availableTasks.isEmpty) {
      return Center(
        child: Text(
          'taskClaim.noTasks'.tr(),
          style: TextStyle(
            fontSize: Responsive.getFontSize(context, base: 16),
            color: AppColors.mediumGray,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Tự động điều chỉnh số cột dựa trên chiều rộng
        int crossAxisCount = 1;
        double childAspectRatio = 1.0;
        
        if (constraints.maxWidth > 1400) {
          // Desktop extra large
          crossAxisCount = 4;
          childAspectRatio = 1.1;
        } else if (constraints.maxWidth > 1200) {
          // Desktop large
          crossAxisCount = 3;
          childAspectRatio = 1.0;
        } else if (constraints.maxWidth > 900) {
          // Desktop medium
          crossAxisCount = 2;
          childAspectRatio = 1.1;
        } else if (constraints.maxWidth > 600) {
          // Tablet
          crossAxisCount = 2;
          childAspectRatio = 0.9;
        } else {
          // Mobile - sử dụng ListView
          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            itemCount: availableTasks.length,
            itemBuilder: (context, index) {
              final booking = availableTasks[index];
              return TaskListItem(data: booking);
            },
          );
        }

        // GridView cho tablet và desktop với spacing được cải thiện
        return GridView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth > 900 ? 24: 16,
            vertical: 16,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: constraints.maxWidth > 900 ? 24 : 16,
            mainAxisSpacing: constraints.maxWidth > 900 ? 24 : 16,
          ),
          itemCount: availableTasks.length,
          itemBuilder: (context, index) {
            final booking = availableTasks[index];
            return TaskListItem(data: booking);
          },
        );
      },
    );
  }
}