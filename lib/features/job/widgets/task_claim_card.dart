import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/task_claim.dart';
import 'package:hsp_mobile/core/utils/helpers.dart';
import 'package:intl/intl.dart';

class TaskClaimCard extends StatelessWidget {
  final TaskClaim claim;

  const TaskClaimCard({super.key, required this.claim});

  String formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  String getStatusText(int statusId) {
    switch (statusId) {
      case 1:
        return "Claimed";
      case 2:
        return "Completed";
      default:
        return "Unknown";
    }
  }

  Color getStatusColor(int statusId) {
    switch (statusId) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: getStatusColor(claim.statusId),
          child: Text(claim.claimId.toString()),
        ),
        title: Text("Detail ID: ${claim.detailId}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Housekeeper: ${claim.housekeeperId}"),
            Text("Claim date: ${Helpers.formatDate(claim.claimDate)}"),
          ],
        ),
        trailing: Chip(
          label: Text(getStatusText(claim.statusId)),
          backgroundColor: getStatusColor(claim.statusId).withOpacity(0.2),
          labelStyle: TextStyle(
            color: getStatusColor(claim.statusId),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
