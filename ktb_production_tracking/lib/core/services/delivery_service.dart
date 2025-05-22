import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_config.dart';
import '../models/delivery_summary_result.dart';
import '../models/delivery_transaction_result.dart';
import '../../core/utils/handleHttpError.dart';

class DeliveryService {
  final String _baseUrl = '${ApiConfig.baseUrl}/Delivery';

  Future<List<DeliverySummaryResult>> fetchSummary(String token) async {
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
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> summaryList = decoded['summary'] ?? [];

        return summaryList
            .map((item) => DeliverySummaryResult.fromJson(item))
            .toList();
      } else {
        handleHttpError(response);
      }
    } catch (e) {
      rethrow;
    }
    throw Exception('Unexpected error in fetchSummary');
  }

  Future<List<DeliveryTransactionResult>> fetchTransactions(
      String token) async {
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
        final List<dynamic> decoded = jsonDecode(response.body);
        return decoded
            .map((item) => DeliveryTransactionResult.fromJson(item))
            .toList();
      } else {
        handleHttpError(response);
      }
    } catch (e) {
      rethrow;
    }
    throw Exception('Unexpected error in fetchTransactions');
  }

  Future<Map<String, dynamic>> updateDeliveryStatus(
      String token, String chassisNo) async {
    final url = Uri.parse("$_baseUrl/update-status?chassisNo=$chassisNo");

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
    throw Exception('Unexpected error in fetchTransactions');
  }
}
