import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_config.dart';
import '../../core/utils/handleHttpError.dart';

class TrimmingOnService {
  final String _baseUrl = '${ApiConfig.baseUrl}/TrimmingOn';

  Future<Map<String, dynamic>> fetchSummary(String token) async {
    final url = Uri.parse("$_baseUrl/summary");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        handleHttpError(response);
      }
    } catch (e) {
      rethrow;
    }
    throw Exception('fetchSummary did not return a value');
  }

  Future<List<Map<String, dynamic>>> fetchTransactions(String token) async {
    final url = Uri.parse("$_baseUrl/transaction");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        handleHttpError(response);
      }
    } catch (e) {
      rethrow;
    }
    throw Exception('fetchTransactions did not return a value');
  }

  Future<Map<String, dynamic>> updateStatus(
      String token, String cabinNo) async {
    final url = Uri.parse("$_baseUrl/update-status?cabinNo=$cabinNo");

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        handleHttpError(response);
      }
    } catch (e) {
      rethrow;
    }
    throw Exception('fetchTransactions did not return a value');
  }
}
