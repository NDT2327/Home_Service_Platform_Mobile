enum DiscountType { amount, percent }

extension DiscountTypeExt on DiscountType {
  static DiscountType fromString(String value) {
    return value.toLowerCase() == 'percent'
        ? DiscountType.percent
        : DiscountType.amount;
  }

  String get label => switch (this) {
    DiscountType.amount => 'Fixed Amount',
    DiscountType.percent => 'Percentage',
  };

  String get localized => switch (this) {
    DiscountType.amount => 'discount.amount',
    DiscountType.percent => 'discount.percent',
  };
}
