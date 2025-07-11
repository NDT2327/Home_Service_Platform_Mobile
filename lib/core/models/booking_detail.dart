class BookingDetail {
  final int detailId;
  final int bookingId;
  final int serviceId;
  final DateTime scheduleDatetime;
  final int quantity;
  final double unitPrice;
  final String serviceName;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final double totalAmount;
  final String? notes;
  final String status;
  final String? image;

  BookingDetail({
    required this.detailId,
    required this.bookingId,
    required this.serviceId,
    required this.scheduleDatetime,
    required this.quantity,
    required this.unitPrice,
    required this.serviceName,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.totalAmount,
    this.notes,
    required this.status,
    this.image,
  });

  // Factory method to create a BookingDetail instance from a map
  factory BookingDetail.fromMap(Map<String, dynamic> map) {
    return BookingDetail(
      detailId: map['detailId'] ?? 0,
      bookingId: map['bookingId'] ?? 0,
      serviceId: map['serviceId'] ?? 0,
      scheduleDatetime: DateTime.parse(map['scheduleDatetime'] ?? DateTime.now().toIso8601String()),
      quantity: map['quantity'] ?? 1,
      unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0.0,
      serviceName: map['serviceName'] ?? 'Unknown',
      customerName: map['customerName'] ?? 'Unknown',
      customerPhone: map['customerPhone'] ?? '',
      customerAddress: map['customerAddress'] ?? '',
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      notes: map['notes'],
      status: map['status'] ?? 'PENDING',
      image: map['image'],
    );
  }

  // Factory method to create a BookingDetail instance from JSON
  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    return BookingDetail(
      detailId: json['detailId'] ?? 0,
      bookingId: json['bookingId'] ?? 0,
      serviceId: json['serviceId'] ?? 0,
      scheduleDatetime: DateTime.parse(json['scheduleDatetime'] ?? DateTime.now().toIso8601String()),
      quantity: json['quantity'] ?? 1,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      serviceName: json['serviceName'] ?? 'Unknown',
      customerName: json['customerName'] ?? 'Unknown',
      customerPhone: json['customerPhone'] ?? '',
      customerAddress: json['customerAddress'] ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'],
      status: json['status'] ?? 'PENDING',
      image: json['image'],
    );
  }
}
