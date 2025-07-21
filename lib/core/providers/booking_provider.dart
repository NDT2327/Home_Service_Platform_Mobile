import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/booking.dart';
import 'package:hsp_mobile/core/services/booking_service.dart';

class BookingProvider with ChangeNotifier {
  final BookingService _bookingService = BookingService();
  List<Booking> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Booking> get bookings =>
      List<Booking>.from(_bookings)..sort((a, b) => b.deadline.compareTo(a.deadline));  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadBookingsForUser(int userId) async {
    if (userId == 0) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookings = await _bookingService.getBookingsForUser(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}