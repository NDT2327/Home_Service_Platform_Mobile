import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/task_claim.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/enums/task_claim_status.dart';
import 'package:hsp_mobile/core/utils/helpers.dart';

class TaskDetailDialog extends StatelessWidget {
  final Map<String, dynamic> task;

  const TaskDetailDialog({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final claim = task['taskClaim'] as TaskClaim;
    final detail = task['bookingDetail'] as Map<String, dynamic>?;
    final service = task['service'] as Map<String, dynamic>?;
    final booking = task['booking'] as Map<String, dynamic>?;
    final account = task['account'] as Map<String, dynamic>?;

    final serviceName = service?['serviceName'] ?? 'N/A';
    final customerName = account?['fullName']?.toString() ?? detail?['customerName']?.toString() ?? 'N/A';
    final customerPhone = account?['phone']?.toString() ?? detail?['customerPhone']?.toString() ?? 'N/A';
    final customerAddress = account?['address']?.toString() ?? detail?['customerAddress']?.toString() ?? booking?['address']?.toString() ?? 'No address';
    final schedule = detail != null && detail['scheduleDatetime'] != null
        ? Helpers.formatDate(DateTime.parse(detail['scheduleDatetime']), format: 'dd/MM/yyyy HH:mm')
        : 'N/A';
    final price = detail != null && detail['totalAmount'] != null
        ? '${detail['quantity']} × ${Helpers.formatMoney(detail['unitPrice'])} = ${Helpers.formatMoney(detail['totalAmount'])}'
        : 'N/A';
    final notes = detail?['notes']?.toString() ?? claim.note?.toString() ?? 'No notes';
    final status = TaskClaimStatusExt.fromId(claim.statusId).label;
    final claimDate = Helpers.formatDate(claim.claimDate, format: 'dd/MM/yyyy HH:mm');
    final bookingNumber = booking?['bookingNumber'] ?? 'N/A';

    return AlertDialog(
      title: Text(
        'Task Details: $serviceName',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Customer', customerName),
            _buildDetailRow('Phone', customerPhone),
            _buildDetailRow('Address', customerAddress),
            _buildDetailRow('Schedule', schedule),
            _buildDetailRow('Price', price),
            _buildDetailRow('Status', status),
            _buildDetailRow('Claim Date', claimDate),
            _buildDetailRow('Booking Number', bookingNumber),
            _buildDetailRow('Notes', notes, isLongText: true),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Close',
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
      backgroundColor: AppColors.backgroundLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isLongText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: AppColors.textLight),
            maxLines: isLongText ? null : 2,
            overflow: isLongText ? null : TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
