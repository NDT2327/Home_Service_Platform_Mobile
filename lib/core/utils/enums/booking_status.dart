import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';

enum BookingStatus { pending, confirmed, cancelled, completed }

extension BookingStatusExt on BookingStatus {
  static BookingStatus fromId(int id) => switch (id) {
    1 => BookingStatus.pending,
    2 => BookingStatus.confirmed,
    3 => BookingStatus.cancelled,
    4 => BookingStatus.completed,
    _ => BookingStatus.pending,
  };

  String get label => switch (this) {
    BookingStatus.pending => 'Pending',
    BookingStatus.confirmed => 'Confirmed',
    BookingStatus.cancelled => 'Cancelled',
    BookingStatus.completed => 'Completed',
  };

  String get localized => switch (this) {
    BookingStatus.pending => 'bookingStatus.pending',
    BookingStatus.confirmed => 'bookingStatus.confirmed',
    BookingStatus.cancelled => 'bookingStatus.cancelled',
    BookingStatus.completed => 'bookingStatus.completed',
  };

  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return AppColors.warning;
      case BookingStatus.completed:
        return AppColors.success;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.confirmed:
        return AppColors.cardSecondary; // Hoặc một màu khác cho 'available'

    }
  }
}
