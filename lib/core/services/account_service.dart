import 'dart:convert';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/utils/constants.dart';
import 'package:http/http.dart' as http;

class AccountService {
  final String baseUrl = '${AppConstants.baseLocalUrl}/identity/account';

  //create account
  Future<void> createAccount(Account account) async {
    final url = Uri.parse(baseUrl);
    final body = jsonEncode(account.toJson());

    print('🔸 Sending POST to $url');
    print('🔸 Request body: $body');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('🔹 Response status: ${response.statusCode}');
    print('🔹 Response body: ${response.body}');

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('❌ Failed to create account: ${response.body}');
    }

    print('✅ Account created successfully!');
  }

  //get accounts
  //get account by Id
  //update account
  //get current account
}
