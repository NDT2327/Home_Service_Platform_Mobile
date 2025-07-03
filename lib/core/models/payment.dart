class Payment {
  final int paymentId;
  final int bookingId;
  final double amount;
  final String paymentMethod;
  final int statusId;
  final DateTime? paymentDate;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final String? notes;

  Payment({
    required this.paymentId,
    required this.bookingId,
    required this.amount,
    required this.paymentMethod,
    required this.statusId,
    this.paymentDate,
    this.createdDate,
    this.updatedDate,
    this.notes,
  });
  // Factory method to create a Payment instance from a map
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      paymentId: map['paymentId'],
      bookingId: map['bookingId'],
      amount: (map['amount'] as num).toDouble(),
      paymentMethod: map['paymentMethod'],
      statusId: map['statusId'],
      paymentDate: map['paymentDate'] != null ? DateTime.parse(map['paymentDate']) : null,
      createdDate: map['createdDate'] != null ? DateTime.parse(map['createdDate']) : null,
      updatedDate: map['updatedDate'] != null ? DateTime.parse(map['updatedDate']) : null,
      notes: map['notes'],
    );
  }
}