enum BookingStatus { pending, confirmed, cancelled }

extension BookingStatusExt on BookingStatus {
  static BookingStatus fromId(int id) => switch (id) {
    1 => BookingStatus.pending,
    2 => BookingStatus.confirmed,
    3 => BookingStatus.cancelled,
    _ => BookingStatus.pending,
  };

  String get label => switch (this) {
    BookingStatus.pending => 'Pending',
    BookingStatus.confirmed => 'Confirmed',
    BookingStatus.cancelled => 'Cancelled',
  };

  String get localized => switch (this) {
    BookingStatus.pending => 'bookingStatus.pending',
    BookingStatus.confirmed => 'bookingStatus.confirmed',
    BookingStatus.cancelled => 'bookingStatus.cancelled',
  };
}
