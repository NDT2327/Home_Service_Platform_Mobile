import 'dart:convert';

import 'package:hsp_mobile/core/models/promotion.dart';
import 'package:hsp_mobile/core/utils/constants.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  Future<Map<String, String>> get _headers async {
    final token = await SharedPrefsUtils.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  Future<String> createPayment({
    required int bookingId,
    required int userId,
    required double amount,
    required DateTime paymentDate,
    String notes = '',
  }) async {
    final url = Uri.parse('${AppConstants.baseLocalUrl}/payment/momo/create');

    final body = jsonEncode({
      'bookingId': bookingId,
      'userId': userId,
      'amount': amount,
      'paymentDate': paymentDate.toIso8601String(),
      'notes': notes,
    });

    print('Making payment request to: $url');
    print('Request body: $body');

    final response = await http.post(url, headers: await _headers, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print('Parsed JSON: $jsonData');
      
      final paymentUrl = jsonData['data'];
      print('Payment URL from response: $paymentUrl');
      
      if (paymentUrl != null && paymentUrl is String && paymentUrl.isNotEmpty) {
        return paymentUrl;
      } else {
        throw Exception('Invalid response: missing or empty payment URL. Response: $jsonData');
      }
    } else {
      throw Exception('Failed to create payment: ${response.statusCode} ${response.body}');
    }
  } 

  Future<Promotion> getPromotionByCode(String code) async {
    final url = Uri.parse('${AppConstants.baseLocalUrl}/payment/promotions/$code');

    final response = await http.get(url, headers: await _headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final promotionJson = jsonData['data'] as Map<String, dynamic>;
      return Promotion.fromJson(promotionJson);
    } else {
      throw Exception(
        'Failed to fetch promotion: ${response.statusCode} ${response.body}',
      );
    }
  }
}