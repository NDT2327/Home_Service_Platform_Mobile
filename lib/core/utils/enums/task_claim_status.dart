enum TaskClaimStatus { claimed, completed, cancelled }

extension TaskClaimStatusExt on TaskClaimStatus {
  static TaskClaimStatus fromId(int id) => switch (id) {
    1 => TaskClaimStatus.claimed,
    2 => TaskClaimStatus.completed,
    3 => TaskClaimStatus.cancelled,
    _ => TaskClaimStatus.claimed,
  };

  String get label => switch (this) {
    TaskClaimStatus.claimed => 'Claimed',
    TaskClaimStatus.completed => 'Completed',
    TaskClaimStatus.cancelled => 'Cancelled',
  };

  String get localized => switch (this) {
    TaskClaimStatus.claimed => 'taskStatus.claimed',
    TaskClaimStatus.completed => 'taskStatus.completed',
    TaskClaimStatus.cancelled => 'taskStatus.cancelled',
  };
}
