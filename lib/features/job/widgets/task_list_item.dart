import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsp_mobile/core/utils/helpers.dart';
import 'package:hsp_mobile/features/job/view_model/task_available_view_model.dart';
import 'package:hsp_mobile/features/job/views/task_detail_modal.dart';
import 'package:hsp_mobile/features/job/widgets/claim_dialog.dart';
import 'package:hsp_mobile/features/job/widgets/task_card.dart';

class TaskListItem extends StatelessWidget {
  final TaskAvailableViewModel data;
  final bool showActions;

  const TaskListItem({
    super.key,
    required this.data,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return TaskCard(
      task: data,
      showActions: showActions,
      onJobDetail: (task) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          builder: (context) => TaskDetailModal(
            bookingDetail: task, // nếu TaskDetailModal cần BookingDetail thì cần map tay
            onClaim: () {
              showDialog(
                context: context,
                builder: (_) => ClaimDialog(
                  detailId: task.task.detailId,
                  housekeeperId: 3, // bạn có thể lấy từ Provider nếu cần
                ),
              );
            },
          ),
        );
      },
      onClaimJob: (detailId) {
        Helpers.showSnackBar(context, 'Đã nhận công việc ID: $detailId');
      },
      onCompleteJob: (detailId) {
        Helpers.showSnackBar(context, 'Đã hoàn tất công việc ID: $detailId');
      },
    );
  }
}
