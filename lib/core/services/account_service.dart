import 'dart:convert';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/models/dtos/base_response.dart';
import 'package:hsp_mobile/core/models/dtos/request/update_account_request.dart';
import 'package:hsp_mobile/core/utils/constants.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:http/http.dart' as http;

class AccountService {
  final String baseUrl = '${AppConstants.baseLocalUrl}/identity/account';
  
  // Headers cho các yêu cầu HTTP
  Future<Map<String, String>> get _headers async {
    final token = await SharedPrefsUtils.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  //create account
  Future<BaseResponse<Account>> createAccount(Account account) async {
try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: await _headers,
        body: jsonEncode(account.toJson()),
      );

      final json = jsonDecode(response.body);
      return BaseResponse.fromJson(
        json,
        (data) => Account.fromMap(data),
      );
    } catch (e) {
      return BaseResponse<Account>(
        statusCode: 500,
        message: 'Failed to create account: $e',
      );
    }
  }

  //get accounts
  //get account by Id
  Future<BaseResponse<Account>> getAccountById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: await _headers,
      );

      final json = jsonDecode(response.body);
      print(json);
      return BaseResponse.fromJson(
        json,
        (data) => Account.fromMap(data),
      );
    } catch (e) {
      return BaseResponse<Account>( 
        statusCode: 500,
        message: 'Failed to fetch account: $e',
      );
    }
  }
  //update account
  Future<BaseResponse<Account>> updateAccount(
    int accountId,
    UpdateAccountRequest request,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$accountId'),
        headers: await _headers,
        body: jsonEncode(request.toJson()),
      );

      final json = jsonDecode(response.body);
      return BaseResponse.fromJson(
        json,
        (data) => Account.fromMap(data),
      );
    } catch (e) {
      return BaseResponse<Account>(
        statusCode: 500,
        message: 'Failed to update account: $e',
      );
    }
  }

  //get current account
    Future<BaseResponse<Account>> getCurrentAccount() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/current'),
        headers: await _headers,
      );

      final json = jsonDecode(response.body);
      return BaseResponse.fromJson(
        json,
        (data) => Account.fromMap(data),
      );
    } catch (e) {
      return BaseResponse<Account>( 
        statusCode: 500,
        message: 'Failed to fetch account: $e',
      );
    }
  }
}
