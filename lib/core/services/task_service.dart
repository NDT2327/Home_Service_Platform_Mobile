import 'dart:convert';

import 'package:hsp_mobile/core/models/dtos/response/base_response.dart';
import 'package:hsp_mobile/core/models/task_claim.dart';
import 'package:hsp_mobile/core/services/account_service.dart';
import 'package:hsp_mobile/core/services/booking_detail_service.dart';
import 'package:hsp_mobile/core/services/booking_service.dart';
import 'package:hsp_mobile/core/services/catalog_service.dart';
import 'package:hsp_mobile/core/utils/constants.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:http/http.dart' as http;

class TaskService {
  final String baseUrl = '${AppConstants.baseLocalUrl}/job/taskclaims';

  final _bookingService = BookingService();
  final _bookingDetailService = BookingDetailService();
  final _serviceService = CatalogService();
  final _accountService = AccountService();

  // Headers cho các yêu cầu HTTP
  Future<Map<String, String>> get _headers async {
    final token = await SharedPrefsUtils.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  //fetch task claims
  Future<BaseResponse<List<TaskClaim>>> fetchClaimedTasks() async {
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
        (data) => (data as List).map((e) => TaskClaim.fromMap(e)).toList(),
      );
    } catch (e) {
      return BaseResponse<List<TaskClaim>>(
        statusCode: 500,
        message: 'Failed to fetch task: $e',
      );
    }
  }

  //fetch task claim by id

  //create task claim
  Future<BaseResponse<TaskClaim>> claimTask(
    int detailId,
    int housekeeperId,
  ) async {
    try {
      final body = jsonEncode({
        'detailId': detailId,
        'housekeeperId': housekeeperId,
        'claimDate': DateTime.now().toIso8601String(),
        'statusId': 1,
        'note': 'Claimed by housekeeper',
      });
      //get url
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: await _headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        print("Task claimed successfully");
        return BaseResponse.fromJson(json, (data) => TaskClaim.fromMap(data));
      } else {
        print("Failed to claim task: ${response.body}");
        return BaseResponse<TaskClaim>(
          statusCode: response.statusCode,
          message: 'Failed with status ${response.statusCode}',
        );
      }
    } catch (e) {
      return BaseResponse<TaskClaim>(
        statusCode: 500,
        message: 'Failed to claim task: $e',
      );
    }
  }

  //update task claim

  //search task claim

  //change status

  //fetch task claim by userID
  Future<BaseResponse<List<TaskClaim>>> fetchClaimedTasksByHousekeeperId(
    int housekeeperId,
  ) async {
    try {
      //get url
      final response = await http.get(
        Uri.parse('$baseUrl/users/$housekeeperId'),
        headers: await _headers,
      );
      //map to json
      final json = jsonDecode(response.body);
      return BaseResponse.fromJson(
        json,
        (data) => (data as List).map((e) => TaskClaim.fromMap(e)).toList(),
      );
    } catch (e) {
      return BaseResponse<List<TaskClaim>>(
        statusCode: 500,
        message: 'Failed to fetch task: $e',
      );
    }
  }

  //search task claim by booking detailId

  //fetchTaskClaim for current Housekeeper
  Future<List<Map<String, dynamic>>>
  fetchTaskClaimForCurrentHousekeeper() async {
    try {
      // 1. Lấy housekeeper ID từ token đã lưu
      final housekeeperId = await SharedPrefsUtils.getAccountId();
      if (housekeeperId == null)
        throw Exception("Không tìm thấy Housekeeper ID");

      // 2. Gọi API lấy danh sách claim
      final claimResponse = await fetchClaimedTasksByHousekeeperId(
        housekeeperId,
      );
      final taskClaims = claimResponse.data ?? [];

      // 3. Gộp thêm các thông tin liên quan đến từng claim
      final List<Map<String, dynamic>> enrichedTasks = [];

      for (var claim in taskClaims) {
        final detailId = claim.detailId;
        // 3.1. Lấy thông tin chi tiết dịch vụ
        final bookingDetailRes = await _bookingDetailService
            .fetchBookingDetailById(detailId);
        final bookingDetail = bookingDetailRes.data;
        if (bookingDetail == null) continue;

        // 3.2. Lấy thông tin dịch vụ
        final service = await _serviceService.getServiceById(
          bookingDetail.serviceId,
        );

        // 3.3. Lấy thông tin booking (địa chỉ, khách hàng...)
        final booking = await _bookingService.fetchBookingByBookingId(
          bookingDetail.bookingId,
        );

        // 3.4. Lấy thông tin khách hàng
        final customer = await _accountService.getAccountById(
          booking.customerId,
        );

        // 4. Gom dữ liệu thành 1 map để dễ dùng ở UI
        enrichedTasks.add({
          'taskClaim': claim,
          'bookingDetail': bookingDetail.toMap(),
          'service': service.toMap(),
          'booking': booking.toMap(),
          'account': customer.data!.toMap(),
        });
      }
      return enrichedTasks;
    } catch (e) {
      throw Exception("Error get task claim: $e");
    }
  }
}
