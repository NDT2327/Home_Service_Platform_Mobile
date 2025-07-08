import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


class TaskService {
  // Lấy booking details chưa có housekeeper nhận từ mock json file
  Future<List<BookingDetail>> getBookingDetails() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/mock_booking.json');
      print('JSON Content: $jsonString');
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);

      final List<dynamic> bookingDetails = jsonData['CozyCare.BookingDb']['BookingDetails'] ?? [];
      final List<dynamic> taskClaims = jsonData['CozyCare.JobDb']['TaskClaims'] ?? [];
      final List<dynamic> services = jsonData['CozyCare.ServiceDb']['Services'] ?? [];
      
      // Map serviceId to image
      final Map<int, String?> serviceImages = {
        for (var service in services) service['serviceId']: service['image'],
      };

      final claimedDetailIds = taskClaims
          .where((claim) => claim['housekeeperId'] != null)
          .map((claim) => claim['detailId'])
          .toSet();
      print('Claimed Detail IDs: $claimedDetailIds');

      final availableDetails = bookingDetails.where((e) => !claimedDetailIds.contains(e['detailId'])).toList();
      print('Available Details: $availableDetails');

      return availableDetails.map((e) => BookingDetail.fromMap({
            ...e,
            'image': serviceImages[e['serviceId']], // Thêm image từ Service
          })).toList();
    } catch (e) {
      print('Error loading booking details: $e');
      return [];
    }
  }
}
