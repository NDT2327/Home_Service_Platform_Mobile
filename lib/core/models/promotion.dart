class Promotion {
  final String code;
  final String discountType;
  final double? discountAmount;
  final double? discountPercent;
  final DateTime startDate;
  final DateTime endDate;
  final double? minOrderAmount;
  final double? maxDiscountAmount;
  final DateTime? createdDate;

  Promotion({
    required this.code,
    required this.discountType,
    this.discountAmount,
    this.discountPercent,
    required this.startDate,
    required this.endDate,
    this.minOrderAmount,
    this.maxDiscountAmount,
    this.createdDate,
  });

  // Factory method to create a Promotion instance from a map
  factory Promotion.fromMap(Map<String, dynamic> map) {
    return Promotion(
      code: map['code'],
      discountType: map['discountType'],
      discountAmount: map['discountAmount'] != null ? (map['discountAmount'] as num).toDouble() : null,
      discountPercent: map['discountPercent'] != null ? (map['discountPercent'] as num).toDouble() : null,
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      minOrderAmount: map['minOrderAmount'] != null ? (map['minOrderAmount'] as num).toDouble() : null,
      maxDiscountAmount: map['maxDiscountAmount'] != null ? (map['maxDiscountAmount'] as num).toDouble() : null,
      createdDate: map['createdDate'] != null ? DateTime.parse(map['createdDate']) : null,
    );
  }
}