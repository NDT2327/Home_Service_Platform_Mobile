import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUtils {
  static const _keyAccountId = 'accountId';
  static const _keyAccessToken = 'accessToken';
  static const _keyRoleId = 'roleId';

  // Lưu dữ liệu
  static Future<void> saveSession({
    required int accountId,
    required String accessToken,
    required int roleId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAccountId, accountId);
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setInt(_keyRoleId, roleId);
  }

  // Lấy dữ liệu
  static Future<int?> getAccountId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyAccountId);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  static Future<int?> getRoleId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyRoleId);
  }

  // Xoá toàn bộ (khi logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccountId);
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRoleId);
  }

  // Kiểm tra đã đăng nhập chưa
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
