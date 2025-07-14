
import 'package:hsp_mobile/core/models/account.dart';

class LoginResponse {
  final String accessToken;
  final DateTime expires;
  final Account account;

  LoginResponse({
    required this.accessToken,
    required this.expires,
    required this.account,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      expires: DateTime.parse(json['expires']),
      account: Account.fromMap(json['account']),
    );
  }
}
