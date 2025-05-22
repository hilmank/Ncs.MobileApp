import 'package:flutter/material.dart';

class DialogHelper {
  /// Show error popup dialog
  static Future<void> showError(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            const Text("Error", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Row(
          children: [
            const Icon(Icons.error, color: Color(0xFFBD0000)),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(backgroundColor: Color(0xFFBD0000)),
            child: const Text('Ok', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Show confirmation dialog with Yes/No
  static Future<void> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: TextButton.styleFrom(backgroundColor: Color(0xFFBD0000)),
            child: const Text("Ya", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
