// lib/features/job/widgets/task_card.dart

import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/enums/booking_status.dart';
import 'package:hsp_mobile/core/utils/helpers.dart';
import 'package:hsp_mobile/features/job/view_model/task_available_view_model.dart';

class TaskCard extends StatelessWidget {
  final TaskAvailableViewModel task;
  final bool showActions;
  final VoidCallback onJobDetail;
  final VoidCallback onClaimJob;

  const TaskCard({
    super.key,
    required this.task,
    required this.showActions,
    required this.onJobDetail,
    required this.onClaimJob,
  });

  @override
  Widget build(BuildContext context) {
    final status = BookingStatusExt.fromId(task.task.bookingStatusId);

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onJobDetail,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, status),
              const SizedBox(height: 12),
              const Divider(color: Colors.white70),
              const SizedBox(height: 12),
              _buildInfoSection(context),
              if (showActions) ...[
                const SizedBox(height: 16),
                _buildActionButtons(status),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BookingStatus status) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.work_history_outlined, color: AppColors.primaryLight, size: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.serviceName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Booking Number: ${task.task.bookingNumber}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.lightGray),
              ),
            ],
          ),
        ),
        _buildStatusBadge(status),
      ],
    );
  }

  Widget _buildStatusBadge(BookingStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label, // Lấy nhãn từ extension
        style: TextStyle(
          color: status.color, // Lấy màu từ extension
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      children: [
        _buildDetailRow(
          context,
          Icons.person_outline,
          'Customer',
          task.customerName,
        ),
        _buildDetailRow(
          context,
          Icons.location_on_outlined,
          'Address',
          task.customerAddress,
        ),
        _buildDetailRow(
          context,
          Icons.calendar_today_outlined,
          'Time',
          Helpers.formatDate(task.task.scheduleDatetime),
        ),
        _buildDetailRow(
          context,
          Icons.monetization_on_outlined,
          'Price',
          Helpers.formatMoney(task.task.unitPrice * task.task.quantity),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.lightGray),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.lightGray),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BookingStatus status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Nút "Claim" chỉ hiển thị khi trạng thái là "Có sẵn"
        if (status == BookingStatus.pending)
          ElevatedButton.icon(
            onPressed: onClaimJob,
            icon: const Icon(Icons.check_circle_outline, size: 18),
            label: const Text("Claimed"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

        // Nút xem chi tiết luôn hiển thị
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: onJobDetail,
          child: const Text(
            "View detail",
            style: TextStyle(color: AppColors.textDark),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.backgroundLight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
