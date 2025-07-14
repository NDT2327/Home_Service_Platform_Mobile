class TaskAvailableResponse {
  final int detailId;
  final int bookingId;
  final int serviceId;
  final DateTime scheduleDatetime;
  final int quantity;
  final double unitPrice;

  final String bookingNumber;
  final int bookingStatusId;

  TaskAvailableResponse({
    required this.detailId,
    required this.bookingId,
    required this.serviceId,
    required this.scheduleDatetime,
    required this.quantity,
    required this.unitPrice,
    this.bookingNumber = '', // fallback
    this.bookingStatusId = 0,
  });

  factory TaskAvailableResponse.fromJson(Map<String, dynamic> json) {
    return TaskAvailableResponse(
      detailId: json['detailId'],
      bookingId: json['bookingId'],
      serviceId: json['serviceId'],
      scheduleDatetime: DateTime.parse(json['scheduleDatetime']),
      quantity: json['quantity'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      bookingNumber: json['bookingNumber'] ?? '',
      bookingStatusId: json['bookingStatusId'] ?? 0,
    );
  }
}
