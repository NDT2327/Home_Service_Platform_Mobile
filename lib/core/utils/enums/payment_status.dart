enum PaymentStatus { unpaid, paid, refunded }

extension PaymentStatusExt on PaymentStatus {
  static PaymentStatus fromId(int id) => switch (id) {
    1 => PaymentStatus.unpaid,
    2 => PaymentStatus.paid,
    3 => PaymentStatus.refunded,
    _ => PaymentStatus.unpaid,
  };

  String get label => switch (this) {
    PaymentStatus.unpaid => 'Unpaid',
    PaymentStatus.paid => 'Paid',
    PaymentStatus.refunded => 'Refunded',
  };

  String get localized => switch (this) {
    PaymentStatus.unpaid => 'paymentStatus.unpaid',
    PaymentStatus.paid => 'paymentStatus.paid',
    PaymentStatus.refunded => 'paymentStatus.refunded',
  };
}
