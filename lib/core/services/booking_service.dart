import 'dart:convert';

import 'package:hsp_mobile/core/models/booking.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/utils/constants.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:http/http.dart' as http;

class BookingService {
  // final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJzdHJpbmciLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjQiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJzdHJpbmciLCJGdWxsTmFtZSI6InN0cmluZyIsIkF2YXRhciI6InN0cmluZyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IjEiLCJSb2xlTmFtZSI6IiIsIlN0YXR1c0lkIjoiMSIsIlN0YXR1c05hbWUiOiIiLCJleHAiOjE3NTIxNzMyMTEsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTE2MyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTE2MyJ9.tEOyFDNkTbK2l5Gn820J1S9xvx1Nurg_bhozEjVdyr8";
  Future<Map<String, String>> get _headers async {
    final token = await SharedPrefsUtils.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  /// Tạo mới một Booking và trả về object Booking vừa được tạo.
  Future<Booking> createBookingAsync({
    required int customerId,
    String? promotionCode,
    DateTime? bookingDate,
    required DateTime deadline,
    required double totalAmount,
    String? notes,
    required int bookingStatusId,
    required int paymentStatusId,
    String? address,
  }) async {
    final url = Uri.parse('${AppConstants.baseLocalUrl}/booking/bookings');

    final body = {
      'customerId': customerId,
      if (promotionCode != null) 'promotionCode': promotionCode,
      if (bookingDate != null) 'bookingDate': bookingDate.toUtc().toIso8601String(),
      'deadline': deadline.toUtc().toIso8601String(),
      'totalAmount': totalAmount,
      if (notes != null) 'notes': notes,
      'bookingStatusId': bookingStatusId,
      'paymentStatusId': paymentStatusId,
      if (address != null) 'address': address,
    };

    final response = await http.post(
      url,
      headers: await _headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      // response JSON: { "data": { ... booking ... }, ... }
      final bookingJson = jsonData['data'] as Map<String, dynamic>;
      return Booking.fromJson(bookingJson);
    } else {
      throw Exception(
        'Failed to create booking: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<BookingDetail> createBookingDetailAsync({
    required int bookingId,
    required int serviceId,
    required DateTime scheduleDatetime,
    required int quantity,
    required double unitPrice
  }) async {
    // Implement the logic to create a booking detail
    final url = Uri.parse('${AppConstants.baseLocalUrl}/booking/booking-details');

    // build request body
    final body = {
      'bookingId': bookingId,
      'serviceId': serviceId,
      'scheduleDatetime': scheduleDatetime.toUtc().toIso8601String(),
      'quantity': quantity,
      'unitPrice': unitPrice,
    };

    final response = await http.post(
      url,
      headers: await _headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      // server trả về { data: { ...bookingDetail... }, ... }
      final detailJson = jsonData['data'] as Map<String, dynamic>;
      return BookingDetail.fromJson(detailJson);
    } else {
      throw Exception(
        'Failed to create booking detail: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<List<BookingDetail>> getBookingDetailsByBookingId(int bookingId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseLocalUrl}/booking/booking-details/booking/$bookingId'),
        headers: await _headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];
        return data.map((json) => BookingDetail.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load booking details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching booking details: $e');
    }
  }

  Future<List<Booking>> getBookingsForUser(int userId) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseLocalUrl}/booking/bookings/users/$userId'),
      headers: await _headers,
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Không thể tải danh sách đặt lịch');
    }
  }
}