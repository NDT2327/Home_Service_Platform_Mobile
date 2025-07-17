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
  final String? address;

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
    this.address,
  });

  // Factory method to create a Booking instance from a map

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      bookingId: map['bookingId'],
      bookingNumber: map['bookingNumber'],
      customerId: map['customerId'],
      promotionCode: map['promotionCode'],
      bookingDate:
          map['bookingDate'] != null
              ? DateTime.parse(map['bookingDate'])
              : null,
      deadline: DateTime.parse(map['deadline']),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      notes: map['notes'],
      bookingStatusId: map['bookingStatusId'],
      paymentStatusId: map['paymentStatusId'],
      address: map['address'],
    );
  }

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    bookingId: json['bookingId'],
    bookingNumber: json['bookingNumber'],
    customerId: json['customerId'],
    promotionCode: json['promotionCode'],
    bookingDate: DateTime.parse(json['bookingDate']),
    deadline: DateTime.parse(json['deadline']),
    totalAmount: (json['totalAmount'] as num).toDouble(),
    notes: json['notes'],
    bookingStatusId: json['bookingStatusId'],
    paymentStatusId: json['paymentStatusId'],
    address: json['address'],
  );

  Map<String, dynamic> toMap() => {
        'bookingId': bookingId,
        'bookingNumber': bookingNumber,
        'customerId': customerId,
        'promotionCode': promotionCode,
        'bookingDate': bookingDate?.toIso8601String(),
        'deadline': deadline.toIso8601String(),
        'totalAmount': totalAmount,
        'notes': notes,
        'bookingStatusId': bookingStatusId,
        'paymentStatusId': paymentStatusId,
        'address': address,
      };
}
