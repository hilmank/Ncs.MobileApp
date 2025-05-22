class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, {this.statusCode});

  @override
  String toString() {
    return statusCode != null
        ? 'AppException: $message (code: $statusCode)'
        : 'AppException: $message';
  }
}
