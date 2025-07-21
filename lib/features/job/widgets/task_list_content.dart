import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart'; // Import Responsive widget
import 'package:hsp_mobile/features/job/view_model/task_available_view_model.dart';
import 'package:hsp_mobile/features/job/widgets/task_list_item.dart';

class TaskListContent extends StatelessWidget {
  final List<TaskAvailableViewModel> availableTasks;

  const TaskListContent({super.key, required this.availableTasks});

  @override
  Widget build(BuildContext context) {
    // 1. Xử lý trường hợp danh sách rỗng trước tiên
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

    // 2. ✨ SỬ DỤNG RESPONSIVE WIDGET ĐỂ ĐIỀU KHIỂN BỐ CỤC
    return Responsive(
      // === GIAO DIỆN CHO MOBILE VÀ DESKTOP ===
      // Cả hai đều sử dụng _buildListView để có trải nghiệm cuộn dọc.
      mobile: _buildListView(context),
      desktop: _buildListView(context),

      // === GIAO DIỆN CHO TABLET ===
      // Sử dụng GridView để tận dụng không gian chiều ngang.
      tablet: _buildGridView(context),
    );
  }

  /// Widget để xây dựng giao diện ListView.
  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        // ✨ Điều chỉnh padding cho phù hợp
        horizontal: Responsive.isDesktop(context) ? 0 : 0,
        vertical: 16,
      ),
      itemCount: availableTasks.length,
      itemBuilder: (context, index) {
        final booking = availableTasks[index];
        // TaskListItem sẽ tự xử lý responsive bên trong nó
        return TaskListItem(data: booking);
      },
    );
  }

  /// Widget để xây dựng giao diện GridView.
  Widget _buildGridView(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Điều chỉnh số cột và tỉ lệ co giãn cho tablet
        int crossAxisCount = 2;
        double childAspectRatio = 0.95; // Tỉ lệ này thường tốt cho tablet

        if (constraints.maxWidth > 900) { // Tablet lớn
           childAspectRatio = 1.1;
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
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