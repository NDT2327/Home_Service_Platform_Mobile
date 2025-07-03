class Booking {
  final int bookingId;
  final String bookingNumber;
  final int customerId;
  final String? promotionCode;
  final DateTime? bookingDate;
  final DateTime deadline;
  final double totalAmount;
  final String? notes;
  final int bookingStatusId;
  final int paymentStatusId;

  Booking({
    required this.bookingId,
    required this.bookingNumber,
    required this.customerId,
    this.promotionCode,
    this.bookingDate,
    required this.deadline,
    required this.totalAmount,
    this.notes,
    required this.bookingStatusId,
    required this.paymentStatusId,
  });

  // Factory method to create a Booking instance from a map

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      bookingId: map['bookingId'],
      bookingNumber: map['bookingNumber'],
      customerId: map['customerId'],
      promotionCode: map['promotionCode'],
      bookingDate: map['bookingDate'] != null ? DateTime.parse(map['bookingDate']) : null,
      deadline: DateTime.parse(map['deadline']),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      notes: map['notes'],
      bookingStatusId: map['bookingStatusId'],
      paymentStatusId: map['paymentStatusId'],
    );
  }
}