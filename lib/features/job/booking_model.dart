class BookingModel {
  final int bookingId;
  final String bookingNumber;
  final int detailId;
  final int customerId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String serviceName;
  final DateTime scheduleDatetime;
  final double unitPrice;
  final int quantity;
  final double totalAmount;
  final String notes;
  final String status;

  BookingModel({
    required this.bookingId,
    required this.bookingNumber,
    required this.detailId,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.serviceName,
    required this.scheduleDatetime,
    required this.unitPrice,
    required this.quantity,
    required this.totalAmount,
    required this.notes,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['bookingId'],
      bookingNumber: json['bookingNumber'],
      detailId: json['detailId'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
      serviceName: json['serviceName'],
      scheduleDatetime: DateTime.parse(json['scheduleDatetime']),
      unitPrice: json['unitPrice'].toDouble(),
      quantity: json['quantity'],
      totalAmount: json['totalAmount'].toDouble(),
      notes: json['notes'] ?? '',
      status: json['status'],
    );
  }
}