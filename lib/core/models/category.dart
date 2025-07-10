class Category {
  final int categoryId;
  final String categoryName;
  final String? description;
  final String? image;
  final bool isActive;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  Category({
    required this.categoryId,
    required this.categoryName,
    this.description,
    this.image,
    this.isActive = true,
    this.createdDate,
    this.updatedDate,
  });

  // Factory method to create a Category instance from a map
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      description: map['description'],
      image: map['image'],
      isActive: map['isActive'] ?? true,
      createdDate: map['createdDate'] != null ? DateTime.parse(map['createdDate']) : null,
      updatedDate: map['updatedDate'] != null ? DateTime.parse(map['updatedDate']) : null,
    );
  }

  // Factory method to create a Category instance from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      description: json['description'],
      image: json['image'],
      isActive: json['isActive'] ?? true,
      createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']) : null,
      updatedDate: json['updatedDate'] != null ? DateTime.parse(json['updatedDate']) : null,
    );
  }
}