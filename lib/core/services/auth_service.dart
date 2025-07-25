import 'dart:convert';
import 'dart:io';
import 'package:hsp_mobile/core/models/dtos/response/base_response.dart';
import 'package:hsp_mobile/core/models/dtos/response/login_response.dart';
import 'package:hsp_mobile/core/utils/constants.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<BaseResponse<LoginResponse>> login(
    String input,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseLocalUrl}/identity/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'input': input, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return BaseResponse<LoginResponse>.fromJson(
          json,
          (data) => LoginResponse.fromJson(data),
        );
      } else {
        final errorJson = jsonDecode(response.body);
        throw Exception(
          errorJson['message'] ??
              'Failed to login with status: ${response.statusCode}',
        );
      }
    } on SocketException {
      // ✨ CHỈ BẮT LỖI MẠNG (KHÔNG CÓ KẾT NỐI INTERNET)
      throw Exception('Network error: Please check your internet connection.');
    }
  }
}
