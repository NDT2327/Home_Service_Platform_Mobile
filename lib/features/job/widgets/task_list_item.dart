import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/providers/task_claim_provider.dart';
import 'package:hsp_mobile/core/utils/notification_helpers.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:hsp_mobile/features/job/view_model/task_available_view_model.dart';
import 'package:hsp_mobile/features/job/widgets/task_detail_modal.dart';
import 'package:hsp_mobile/features/job/widgets/claim_dialog.dart';
import 'package:hsp_mobile/features/job/widgets/task_card.dart';
import 'package:provider/provider.dart';

class TaskListItem extends StatelessWidget {
  final TaskAvailableViewModel data;
  final bool showActions;
  final VoidCallback? onTaskClaimed;

  const TaskListItem({
    super.key,
    required this.data,
    this.showActions = true,
    this.onTaskClaimed,
  });

  Future<void> handleClaimTask({
    required BuildContext context,
    required int detailId,
  }) async {
    final provider = context.read<TaskClaimProvider>();
    final housekeeperId = await SharedPrefsUtils.getAccountId();
    final success = await provider.claimTask(
      detailId: detailId,
      housekeeperId: housekeeperId as int,
      bookingId: data.task.bookingId,
    );

    if (context.mounted) {
      if (success) {
        NotificationHelpers.showToast(message: 'Claimed Task Successfully!');
        onTaskClaimed?.call();
      } else {
        NotificationHelpers.showToast(
          message: provider.errorMessage ?? 'Claimed fail.',
          isError: true,
        );
      }
    }
  }

  // ✨ Logic hiển thị modal chi tiết
  void _showTaskDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (modalContext) => TaskDetailModal(
            bookingDetail: data,
            onClaim: () {
              // Đóng modal chi tiết trước khi mở dialog xác nhận
              Navigator.of(modalContext).pop();
              _showClaimDialog(context, data.task.detailId);
            },
          ),
    );
  }

  // ✨ Logic hiển thị dialog xác nhận
  void _showClaimDialog(BuildContext context, int detailId) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => ClaimDialog(
            onConfirm: () {
              Navigator.of(dialogContext).pop();
              handleClaimTask(context: context, detailId: detailId);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TaskCard(
      task: data,
      showActions: showActions,
      onJobDetail: () => _showTaskDetail(context),
      onClaimJob: () => _showClaimDialog(context, data.task.detailId),
    );
  }
}
