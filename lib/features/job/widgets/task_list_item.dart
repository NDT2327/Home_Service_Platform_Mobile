import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsp_mobile/core/utils/helpers.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:hsp_mobile/core/providers/task_claim_provider.dart';
import 'package:hsp_mobile/features/job/view_model/task_available_view_model.dart';
import 'package:hsp_mobile/features/job/views/task_detail_modal.dart';
import 'package:hsp_mobile/features/job/widgets/claim_dialog.dart';
import 'package:hsp_mobile/features/job/widgets/task_card.dart';
import 'package:provider/provider.dart';

class TaskListItem extends StatelessWidget {
  final TaskAvailableViewModel data;
  final bool showActions;

  const TaskListItem({super.key, required this.data, this.showActions = true});

  Future<void> handleClaimTask({
    required BuildContext context, // Stable context
    required TaskClaimProvider provider,
    required int detailId,
    required int bookingId,
  }) async {
    // Check if the widget is still mounted before proceeding
    if (!context.mounted) return;

    final housekeeperId = await SharedPrefsUtils.getAccountId();
    await provider.claimTask(
      detailId: detailId,
      housekeeperId: housekeeperId as int,
      bookingId: bookingId,
    );

    // Check again if the widget is mounted before showing SnackBar
    if (!context.mounted) return;
    Helpers.showSnackBar(context, 'Nhận công việc thành công!');

    // if (provider.errorMessage == null) {
    //   Helpers.showSnackBar(context, 'Nhận công việc thành công!');
    // } else {
    //   Helpers.showSnackBar(context, 'Lỗi: ${provider.errorMessage}');
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Store a stable context for async operations
    final stableContext = context;

    return TaskCard(
      task: data,
      showActions: showActions,
      onJobDetail: (task) {
        showModalBottomSheet(
          context: stableContext,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          builder:
              (modalContext) => TaskDetailModal(
                bookingDetail: task,
                onClaim: () {
                  showDialog(
                    context: modalContext,
                    builder:
                        (dialogContext) => ClaimDialog(
                          onConfirm: () async {
                            final provider = Provider.of<TaskClaimProvider>(
                              dialogContext,
                              listen: false,
                            );
                            Navigator.of(
                              dialogContext,
                              rootNavigator: true,
                            ).pop();
                            await handleClaimTask(
                              context: stableContext, // Use stable context
                              provider: provider,
                              detailId: task.task.detailId,
                              bookingId: task.task.bookingId,
                            );
                          },
                        ),
                  );
                },
              ),
        );
      },
      onClaimJob: (detailId) {
        showDialog(
          context: stableContext,
          barrierDismissible: false,
          builder:
              (dialogContext) => ClaimDialog(
                onConfirm: () async {
                  final provider = Provider.of<TaskClaimProvider>(
                    dialogContext,
                    listen: false,
                  );
                  // Close the dialog
                  Navigator.of(dialogContext, rootNavigator: true).pop();
                  // Handle the task claim
                  await handleClaimTask(
                    context: stableContext,
                    provider: provider,
                    detailId: detailId,
                    bookingId: data.task.bookingId,
                  );
                },
                onCancel: () {
                  Navigator.of(dialogContext, rootNavigator: true).pop();
                },
              ),
        );
      },
      onCompleteJob: (detailId) {
        Helpers.showSnackBar(
          stableContext,
          'Đã hoàn tất công việc ID: $detailId',
        );
      },
    );
  }
}
