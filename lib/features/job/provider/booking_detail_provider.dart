import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/services/booking_detail_service.dart';

class BookingDetailProvider with ChangeNotifier {
  final BookingDetailService _service = BookingDetailService();

  List<BookingDetail> _details = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BookingDetail> get details => _details;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBookingDetails() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.fetchBookingDetails();
      if (response.statusCode == 200) {
        _details = response.data ?? [];
        _errorMessage = null;
      } else {
        _errorMessage = response.message ?? "Unknown error";
      }
    } catch (e) {
      _errorMessage = 'Failed to load booking details';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  BookingDetail? getDetailById(int detailId) {
    return _details.firstWhere((d) => d.detailId == detailId, orElse: () => null as BookingDetail);
  }
}
