import 'dart:convert';
import 'dart:io';
import 'package:hsp_mobile/core/models/booking.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/models/service.dart';
import 'package:hsp_mobile/core/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:hsp_mobile/core/utils/constants.dart';

class ApiService {

  static Future<List<User>> fetchUsers() async {
    
    final response = await http.get(Uri.parse('${AppConstants.baseUrl}/users'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<Booking>> getBookingsForUser(int userId) async {
    final response = await http.get(Uri.parse('${AppConstants.baseLocalUrl}/booking/bookings/users/$userId'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Không thể tải danh sách đặt lịch');
    }
  }

  Future<List<BookingDetail>> getBookingDetailsByBookingId(int bookingId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseLocalUrl}/booking/booking-details/booking/$bookingId'),
        headers: {'Content-Type': 'application/json'},
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
  
  Future<Service> getServiceById(int serviceId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseLocalUrl}/catalog/services/$serviceId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Service.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to load service: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching service: $e');
    }
  }
}
