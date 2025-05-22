import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_result.dart';
import '../constants/api_config.dart';
import '../../core/utils/handleHttpError.dart';

class AuthService {
  final String _baseUrl = '${ApiConfig.baseUrl}/Auth';

  Future<AuthResult?> login(String username, String password, int shift) async {
    try {
      final url = Uri.parse('$_baseUrl/signin');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'shift': shift,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthResult.fromJson(data);
      } else {
        handleHttpError(response);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
