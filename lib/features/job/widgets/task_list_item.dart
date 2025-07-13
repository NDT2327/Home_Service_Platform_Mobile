import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/models/task_claim.dart';
import 'package:hsp_mobile/core/utils/helpers.dart';
import 'package:hsp_mobile/features/job/views/task_detail_modal.dart';
import 'package:hsp_mobile/features/job/widgets/claim_dialog.dart';
import 'package:hsp_mobile/features/job/widgets/task_card.dart';

class TaskListItem extends StatelessWidget {
  final dynamic data;
  //final BookingDetail detail;
  final bool showActions;

  const TaskListItem({
    super.key,
    required this.data,
    //required this.detail,
    this.showActions = true,
  });

  BookingDetail? _getBookingDetail() {
    if (data is BookingDetail) {
      return data as BookingDetail;
    } else if (data is TaskClaim) {
      return (data as TaskClaim).detail;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final booking = _getBookingDetail();

    if (booking == null) {
      return const SizedBox.shrink(); // trả về widget rỗng
    }
    return TaskCard(
      bookingDetail: booking,
      showActions: showActions,
      onJobDetail: (booking) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          builder:
              (context) => TaskDetailModal(
                bookingDetail: booking,
                onClaim: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => ClaimDialog(
                          detail: booking, // hoặc bookingDetail
                          housekeeperId: 3,
                        ),
                  );
                },
              ),
        );
      },
      onClaimJob: (detailId) {
        // TODO: Trigger claim job API
        Helpers.showSnackBar(context, 'Đã nhận công việc ID: $detailId');
      },
      onCompleteJob: (detailId) {
        // TODO: Trigger complete job API
        Helpers.showSnackBar(context, 'Đã hoàn tất công việc ID: $detailId');
      },
    );
  }
}
