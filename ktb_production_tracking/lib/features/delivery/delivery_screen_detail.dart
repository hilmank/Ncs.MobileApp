import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/services/delivery_service.dart';
import '../../core/utils/shared_prefs_helper.dart';
import '../../core/utils/error_handler.dart';
import '../../core/errors/app_exception.dart';
import '../../core/models/delivery_transaction_result.dart';
import '../../core/utils/dialog_helper.dart';
import '../../shared_widgets/header.dart';
import '../../shared_widgets/loading.dart';

class DeliveryDetailScreen extends StatefulWidget {
  final String userName;
  final int shiftNo;
  final String companyName;

  const DeliveryDetailScreen({
    super.key,
    required this.userName,
    required this.shiftNo,
    this.companyName = "PT. Krama Yudha Ratu Motor",
  });

  @override
  State<DeliveryDetailScreen> createState() => _DeliveryDetailScreenState();
}

class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
  final DeliveryService _service = DeliveryService();
  final TextEditingController shiftController =
      TextEditingController(text: "1");
  final TextEditingController snController = TextEditingController();

  List<DeliveryTransactionResult> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    setState(() => isLoading = true);
    try {
      final token = await SharedPrefsHelper.getToken();
      if (token == null || token.isEmpty) {
        throw AppException("Unauthorized");
      }

      final result = await _service.fetchTransactions(token);
      if (!mounted) return;
      setState(() => transactions = result);
    } catch (e, stackTrace) {
      if (!mounted) return;
      ErrorHandler.handle(context: context, error: e, stackTrace: stackTrace);
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> updateDeliveryStatus(String chassisNo) async {
    setState(() => isLoading = true);
    try {
      final token = await SharedPrefsHelper.getToken();
      if (token == null || token.isEmpty) throw AppException("Unauthorized");

      final result = await _service.updateDeliveryStatus(token, chassisNo);
      final delivery = result['delivery'];
      if (delivery == null) {
        throw AppException(
            result['message'] ?? "Data pengiriman tidak ditemukan");
      }

      final newItem = DeliveryTransactionResult.fromJson(delivery);

      setState(() {
        transactions.insert(0, newItem);
        snController.clear();
      });
    } catch (e, stackTrace) {
      if (!mounted) return;
      ErrorHandler.handle(context: context, error: e, stackTrace: stackTrace);
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormatted = DateFormat('EEEE, d MMMM y', 'id_ID').format(now);
    final timeFormatted = DateFormat.Hms().format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            Header(
              userName: widget.userName,
              shiftNo: widget.shiftNo,
              companyName: widget.companyName,
              dateFormatted: dateFormatted,
              timeFormatted: timeFormatted,
            ),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header & Back
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Color(0xFFBD0000)),
                                onPressed: () {
                                  DialogHelper.showConfirmation(
                                    context: context,
                                    title: "Konfirmasi",
                                    message:
                                        "Keluar dari Menu Transaction Delivery?",
                                    onConfirm: () => Navigator.pop(context),
                                  );
                                },
                              ),
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    "Transaction Delivery",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Input Field
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: Text("Chassis No",
                                    style: TextStyle(color: Colors.black54)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: snController,
                                  onSubmitted: (value) {
                                    if (value.trim().isNotEmpty) {
                                      updateDeliveryStatus(value.trim());
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Enter",
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Table View
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                color: const Color(0xFFEDEFF1),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 8),
                                child: const Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Text("#",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    Expanded(
                                        flex: 3,
                                        child: Text("Chassis No.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    Expanded(
                                        flex: 2,
                                        child: Text("Variant",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListView.separated(
                                    itemCount: transactions.length,
                                    separatorBuilder: (_, __) =>
                                        const Divider(height: 1),
                                    itemBuilder: (context, index) {
                                      final row = transactions[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Text('${index + 1}')),
                                            Expanded(
                                                flex: 3,
                                                child: Text(row.chassisNo)),
                                            Expanded(
                                                flex: 2,
                                                child: Text(row.variant)),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Shift info
                        Row(
                          children: [
                            const Text("Shift",
                                style: TextStyle(color: Colors.black87)),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 60,
                              child: TextField(
                                controller: shiftController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text("Day",
                                style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  LoadingOverlay(isLoading: isLoading),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
