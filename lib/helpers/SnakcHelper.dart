import 'package:flutter/material.dart';

class SnackHelper {
  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // behavior: SnackBarBehavior.floating,
        content: Text(message, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}