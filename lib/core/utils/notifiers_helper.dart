// lib/core/helpers/notifier_helper.dart
import 'package:flutter/material.dart';

/// Một Mixin để cung cấp logic quản lý trạng thái (loading, error)
/// cho bất kỳ lớp nào kế thừa từ ChangeNotifier.
mixin NotifierHelper on ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  // Getters công khai để giao diện có thể truy cập
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Thực thi một tác vụ bất đồng bộ và tự động quản lý trạng thái.
  ///
  /// [operation]: Tác vụ chính cần thực thi (ví dụ: gọi API).
  /// [onSuccess]: Callback được gọi khi tác vụ thành công.
  /// [onError]: Callback tùy chọn được gọi khi có lỗi.
  Future<void> execute(
      {required Future<void> Function() operation,
      void Function(String message)? onError}) async {
    _setLoading(true);
    _clearError();

    try {
      await operation();
    } catch (e) {
      final message = e.toString();
      _errorMessage = message;
      if (onError != null) {
        onError(message);
      }
    } finally {
      _setLoading(false);
    }
  }

  // Hàm private để quản lý trạng thái
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Hàm public để giao diện có thể chủ động xóa lỗi
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}