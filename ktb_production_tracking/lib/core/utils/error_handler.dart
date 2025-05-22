import 'package:flutter/material.dart';
import '../../features/auth/login_screen.dart';
import '../errors/app_exception.dart';
import 'dialog_helper.dart';
import 'snackbar_helper.dart';

class ErrorHandler {
  static void handle({
    required BuildContext context,
    required Object error,
    StackTrace? stackTrace,
  }) async {
    String userMessage = "Terjadi kesalahan. Silakan coba lagi.";
    String technicalMessage = error.toString();

    // If AppException, show friendly message
    if (error is AppException) {
      if (error.message == "Unauthorized") {
        // Redirect to login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
        return;
      }
      userMessage = error.message;
    }

    // Show dialog to user
    await DialogHelper.showError(context, userMessage);

    // Show technical error in snackbar for developers
    // ignore: use_build_context_synchronously
    showErrorSnackbar(context, technicalMessage);

    // Optional debug log
    debugPrint('ERROR: $technicalMessage');
    if (stackTrace != null) debugPrint('STACK TRACE: $stackTrace');
  }
}
