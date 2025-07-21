import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/enums/booking_status.dart';
import 'package:hsp_mobile/core/utils/helpers.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/features/job/view_model/task_available_view_model.dart';

class TaskDetailModal extends StatelessWidget {
  final TaskAvailableViewModel bookingDetail;
  final VoidCallback? onClaim;

  const TaskDetailModal({super.key, required this.bookingDetail, this.onClaim});

  @override
  Widget build(BuildContext context) {
    final status = BookingStatusExt.fromId(bookingDetail.task.bookingStatusId);

    return SafeArea(
      child: Container(
        padding: Responsive.getPadding(context),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.mediumGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Text(
                bookingDetail.serviceName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.person, bookingDetail.customerName),
              _buildDetailRow(Icons.phone, bookingDetail.customerPhone),
              _buildDetailRow(Icons.location_on, bookingDetail.customerAddress),
              _buildDetailRow(
                Icons.calendar_today,
                Helpers.formatDate(bookingDetail.task.scheduleDatetime),
              ),
              _buildDetailRow(
                Icons.access_time,
                DateFormat.Hm().format(bookingDetail.task.scheduleDatetime),
              ),
              _buildDetailRow(
                Icons.confirmation_number,
                'Quantity: ${bookingDetail.task.quantity}',
              ),
              _buildDetailRow(
                Icons.monetization_on,
                'Price: ${Helpers.formatMoney(bookingDetail.task.unitPrice)}',
              ),
              _buildDetailRow(
                Icons.calculate,
                'Total amount: ${Helpers.formatMoney(
                  bookingDetail.task.quantity * bookingDetail.task.unitPrice,
                )}',
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('common.close'.tr()),
                  ),
                  if (status == BookingStatus.pending && onClaim != null)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context); // Close modal
                        onClaim!(); // Trigger action
                      },
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      label: Text(
                        'taskClaim.claim'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildDetailRow(IconData icon, String? text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text?.isNotEmpty == true ? text! : "(Chưa có dữ liệu)",
            style: const TextStyle(fontSize: 14, color: AppColors.textLight),
          ),
        ),
      ],
    ),
  );
}
}
