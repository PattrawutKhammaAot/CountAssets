import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

class CustomBotToast {
  static void showWarning(String message) {
    BotToast.showCustomNotification(
      toastBuilder: (_) =>
          _buildNotification(message, Colors.orangeAccent, Icons.warning),
      duration: Duration(seconds: 3),
    );
  }

  static void showError(String message) {
    BotToast.showCustomNotification(
      toastBuilder: (_) => _buildNotification(message, Colors.red, Icons.error),
      duration: Duration(seconds: 3),
    );
  }

  static void showSuccess(String message) {
    BotToast.showCustomNotification(
      toastBuilder: (_) =>
          _buildNotification(message, Colors.green, Icons.check_circle),
      duration: Duration(seconds: 3),
    );
  }

  static Widget _buildNotification(String message, Color color, IconData icon) {
    return Builder(
      builder: (context) {
        final width =
            MediaQuery.of(context).size.width * 0.9; // 90% of screen width
        return Card(
          color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Container(
            width: width,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 25,
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
