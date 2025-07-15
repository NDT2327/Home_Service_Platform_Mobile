import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class Helpers {
  //show notifications
static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
      if (scaffoldMessenger != null) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: isError ? Colors.red : Colors.green,
          ),
        );
      } else {
        debugPrint("⚠️ ScaffoldMessenger not found for current context.");
      }
    });
  }


  //format date
  static String formatDate(DateTime date, {String format = "dd/MM/yyyy"}) {
    return DateFormat(format).format(date);
  }

  // Hide the keyboard when the user taps an area that is not a TextField.
  static void unfocusKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  //format money
  static String formatMoney(double amount){
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');
    return formatter.format(amount);
  }
}
