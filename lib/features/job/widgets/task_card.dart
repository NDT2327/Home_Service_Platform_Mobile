import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/enums/booking_status.dart';
import 'package:hsp_mobile/core/utils/helpers.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/features/job/view_model/task_available_view_model.dart';

class TaskCard extends StatelessWidget {
  final TaskAvailableViewModel task;
  final bool showActions;
  final Function(TaskAvailableViewModel) onJobDetail;
  final Function(int) onClaimJob;
  final Function(int) onCompleteJob;

  const TaskCard({
    super.key,
    required this.task,
    required this.showActions,
    required this.onJobDetail,
    required this.onClaimJob,
    required this.onCompleteJob,
  });

  @override
  Widget build(BuildContext context) {
    final bookingStatus = BookingStatusExt.fromId(task.task.bookingStatusId);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => onJobDetail(task),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: Responsive.getPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + status badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      task.serviceName,
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(context, base: 18),
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusBadge(context, bookingStatus.label),
                ],
              ),

              const SizedBox(height: 16),
              _buildDetailRow(context, Icons.person, task.customerName),
              _buildDetailRow(context, Icons.location_on, task.customerAddress),
              _buildDetailRow(context, Icons.calendar_today,
                  Helpers.formatDate(task.task.scheduleDatetime)),
              _buildDetailRow(context, Icons.attach_money,
                  Helpers.formatMoney(task.task.unitPrice)),

              const SizedBox(height: 16),

              // Action buttons
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: 12,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => onJobDetail(task),
                      icon: const Icon(Icons.visibility, size: 18),
                      label: Text(
                        "View detail",
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, base: 14),
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    if (showActions && task.task.bookingStatusId == 1)
                      ElevatedButton.icon(
                        onPressed: () => onClaimJob(task.task.detailId),
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text("Claim", style: TextStyle(
                          color: AppColors.lightGray
                        ),),
                      ),
                    if (showActions && task.task.bookingStatusId == 'CLAIMED')
                      ElevatedButton.icon(
                        onPressed: () => onCompleteJob(task.task.detailId),
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text("Complete"),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.mediumGray),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, base: 14),
                color: AppColors.mediumGray,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return AppColors.accentOrange;
      case 'CLAIMED':
        return AppColors.primary;
      case 'COMPLETED':
        return AppColors.success;
      default:
        return AppColors.mediumGray;
    }
  }
}
