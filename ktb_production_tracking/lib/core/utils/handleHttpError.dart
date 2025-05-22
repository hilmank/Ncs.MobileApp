import 'dart:convert';
import 'package:http/http.dart';
import '../errors/app_exception.dart';

void handleHttpError(Response response) {
  try {
    final decoded = jsonDecode(response.body);
    final message = decoded['message'] ??
        decoded['title'] ??
        decoded['detail'] ??
        'Terjadi kesalahan pada server (${response.statusCode}).';

    throw AppException(message, statusCode: response.statusCode);
  } catch (_) {
    throw AppException(response.body.toString(),
        statusCode: response.statusCode);
  }
}
