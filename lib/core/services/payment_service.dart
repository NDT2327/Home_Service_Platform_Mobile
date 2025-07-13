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