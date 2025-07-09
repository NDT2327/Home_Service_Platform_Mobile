class Service {
  final int serviceId;
  // final String serviceId;
  final int categoryId;
  final String serviceName;
  final String? description;
  final String? image;
  final double price;
  final int duration;
  final bool isActive;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  Service({
    required this.serviceId,
    required this.categoryId,
    required this.serviceName,
    this.description,
    this.image,
    required this.price,
    required this.duration,
    this.isActive = true,
    this.createdDate,
    this.updatedDate,
  });

  // Factory method to create a Service instance from a map
  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      serviceId: map['serviceId'],
      categoryId: map['categoryId'],
      serviceName: map['serviceName'],
      description: map['description'],
      image: map['image'],
      price: (map['price'] as num).toDouble(),
      duration: map['duration'],
      isActive: map['isActive'] ?? true,
      createdDate: map['createdDate'] != null ? DateTime.parse(map['createdDate']) : null,
      updatedDate: map['updatedDate'] != null ? DateTime.parse(map['updatedDate']) : null,
    );
  }

  // Factory method to create a Service instance from JSON
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['serviceId'],
      categoryId: json['categoryId'],
      serviceName: json['serviceName'],
      description: json['description'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      duration: json['duration'],
      isActive: json['isActive'] ?? true,
      createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']) : null,
      updatedDate: json['updatedDate'] != null ? DateTime.parse(json['updatedDate']) : null,
    );
  }
}