class Review {
  final int reviewId;
  final int customerId;
  final int detailId;
  final String reviewTarget;
  final int? rating;
  final String? comment;
  final DateTime? reviewDate;

  Review({
    required this.reviewId,
    required this.customerId,
    required this.detailId,
    required this.reviewTarget,
    this.rating,
    this.comment,
    this.reviewDate,
  });

  // Factory method to create a Review instance from a map
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      reviewId: map['reviewId'],
      customerId: map['customerId'],
      detailId: map['detailId'],
      reviewTarget: map['reviewTarget'],
      rating: map['rating'] != null ? map['rating'] : null,
      comment: map['comment'],
      reviewDate: map['reviewDate'] != null ? DateTime.parse(map['reviewDate']) : null,
    );
  }
}