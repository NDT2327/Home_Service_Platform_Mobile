import 'package:hsp_mobile/core/models/booking_detail.dart';

class TaskClaim {
  final int claimId;
  final int detailId;
  final int housekeeperId;
  final DateTime claimDate;
  final int statusId;
  final String? note;

  BookingDetail? detail;

  TaskClaim({
    required this.claimId,
    required this.detailId,
    required this.housekeeperId,
    required this.claimDate,
    required this.statusId,
    this.note,
    this.detail,
  });

  // Factory method to create a TaskClaim instance from a map
  factory TaskClaim.fromMap(Map<String, dynamic> map) {
    return TaskClaim(
      claimId: map['claimId'],
      detailId: map['detailId'],
      housekeeperId: map['housekeeperId'],
      claimDate: DateTime.parse(map['claimDate']),
      statusId: map['statusId'],
      note: map['note'],
    );
  }
}