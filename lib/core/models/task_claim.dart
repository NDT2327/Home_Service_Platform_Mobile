class TaskClaim {
  final int claimId;
  final int detailId;
  final int housekeeperId;
  final DateTime? claimDate;
  final int statusId;
  final String? note;

  TaskClaim({
    required this.claimId,
    required this.detailId,
    required this.housekeeperId,
    this.claimDate,
    required this.statusId,
    this.note,
  });

  // Factory method to create a TaskClaim instance from a map
  factory TaskClaim.fromMap(Map<String, dynamic> map) {
    return TaskClaim(
      claimId: map['claimId'],
      detailId: map['detailId'],
      housekeeperId: map['housekeeperId'],
      claimDate: map['claimDate'] != null ? DateTime.parse(map['claimDate']) : null,
      statusId: map['statusId'],
      note: map['note'],
    );
  }
}