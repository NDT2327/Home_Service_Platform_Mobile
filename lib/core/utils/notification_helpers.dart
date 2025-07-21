import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationHelpers {
  static void showToast({required String message, bool isError = false}) {
    // ✨ Chuyển đổi màu của Flutter thành chuỗi hex cho web
    String hexColor = (isError ? Colors.red.shade600 : Colors.green.shade600)
        .value
        .toRadixString(16)
        .substring(2); // Bỏ đi 2 ký tự alpha ở đầu

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600, // Cho mobile
      textColor: Colors.white,
      fontSize: 16.0,
      // ✨ SỬ DỤNG THAM SỐ DÀNH RIÊNG CHO WEB
      webShowClose: true, // Cho phép người dùng đóng toast
      webBgColor: "#$hexColor", // Định dạng màu cho web là chuỗi hex
    );
  }
}