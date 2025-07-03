class BookingDetail {
  final int detailId;
  final int bookingId;
  final int serviceId;
  final DateTime scheduleDatetime;
  final int quantity;
  final double unitPrice;

  BookingDetail({
    required this.detailId,
    required this.bookingId,
    required this.serviceId,
    required this.scheduleDatetime,
    required this.quantity,
    required this.unitPrice,
  });

  // Factory method to create a BookingDetail instance from a map
  factory BookingDetail.fromMap(Map<String, dynamic> map) {
    return BookingDetail(
      detailId: map['detailId'],
      bookingId: map['bookingId'],
      serviceId: map['serviceId'],
      scheduleDatetime: DateTime.parse(map['scheduleDatetime']),
      quantity: map['quantity'],
      unitPrice: (map['unitPrice'] as num).toDouble(),
    );
  }
}