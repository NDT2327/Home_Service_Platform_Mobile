import 'dart:convert';
import 'package:hsp_mobile/core/models/booking.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/models/dtos/response/base_response.dart';
import 'package:hsp_mobile/core/models/dtos/response/task_available_response.dart';
import 'package:hsp_mobile/core/utils/constants.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:http/http.dart' as http;

class BookingDetailService {
  //url
  final String baseUrl = '${AppConstants.baseLocalUrl}/booking/booking-details';

  // Headers cho các yêu cầu HTTP
  Future<Map<String, String>> get _headers async {
    final token = await SharedPrefsUtils.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  //fetch booking details
  Future<BaseResponse<List<BookingDetail>>> fetchBookingDetails() async {
    try {
      //get url
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: await _headers,
      );

      //map to json
      final json = jsonDecode(response.body);
      return BaseResponse.fromJson(
        json,
        (data) => (data as List).map((e) => BookingDetail.fromMap(e)).toList(),
      );
    } catch (e) {
      return BaseResponse<List<BookingDetail>>(
        statusCode: 500,
        message: 'Failed to get booking detail: $e',
      );
    }
  }

  //fetch task available
  Future<BaseResponse<List<TaskAvailableResponse>>>
  fetchAvailableTasks() async {
    try {
      //get url
      final response = await http.get(
        Uri.parse('$baseUrl/available-tasks'),
        headers: await _headers,
      );

      //map to json
      final json = jsonDecode(response.body);
      return BaseResponse.fromJson(
        json,
        (data) =>
            (data as List)
                .map((e) => TaskAvailableResponse.fromJson(e))
                .toList(),
      );
    } catch (e) {
      return BaseResponse<List<TaskAvailableResponse>>(
        statusCode: 500,
        message: 'Failed to get available tasks: $e',
      );
    }
  }

  //fetch booking detail by Id
  Future<BaseResponse<BookingDetail>> fetchBookingDetailById(
    int detailId,
  ) async {
    try {
      //get url
      final response = await http.get(
        Uri.parse('$baseUrl/$detailId'),
        headers: await _headers,
      );

      //map to json
      final json = jsonDecode(response.body);
      return BaseResponse.fromJson(json, (data) => BookingDetail.fromMap(data));
    } catch (e) {
      return BaseResponse<BookingDetail>(
        statusCode: 500,
        message: 'Failed to get booking detail: $e',
      );
    }
  }
}
