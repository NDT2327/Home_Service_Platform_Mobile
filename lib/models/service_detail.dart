class ServiceDetail {
  final int serviceDetailId;
  final int serviceId;
  final String optionName;
  final String optionType;
  final double basePrice;
  final String unit;
  final int duration;
  final String? description;
  final bool isActive;

  ServiceDetail({
    required this.serviceDetailId,
    required this.serviceId,
    required this.optionName,
    required this.optionType,
    required this.basePrice,
    required this.unit,
    required this.duration,
    this.description,
    this.isActive = true,
  });

  // Factory method to create a ServiceDetail instance from a map
  factory ServiceDetail.fromMap(Map<String, dynamic> map) {
    return ServiceDetail(
      serviceDetailId: map['serviceDetailId'],
      serviceId: map['serviceId'],
      optionName: map['optionName'],
      optionType: map['optionType'],
      basePrice: (map['basePrice'] as num).toDouble(),
      unit: map['unit'],
      duration: map['duration'],
      description: map['description'],
      isActive: map['isActive'] ?? true,
    );
  }
}