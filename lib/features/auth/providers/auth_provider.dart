import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/dtos/base_response.dart';
import 'package:hsp_mobile/core/models/dtos/login_response.dart';
import 'package:hsp_mobile/core/services/auth_service.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;
  LoginResponse? loginData;

  Future<bool> login(String input, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final BaseResponse<LoginResponse> response = await _authService.login(
        input,
        password,
      );

      if (response.data != null) {
        loginData = response.data;
        isLoading = false;
        // lưu session
        await SharedPrefsUtils.saveSession(
          accountId: response.data!.account.accountId,
          accessToken: response.data!.accessToken,
          roleId: response.data!.account.roleId,
        );
        notifyListeners();
        return true;
      } else {
        errorMessage = response.message ?? 'Unknown error';
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
    return false;
  }
}
