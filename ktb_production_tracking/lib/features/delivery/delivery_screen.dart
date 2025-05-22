import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/services/delivery_service.dart';
import '../../core/utils/dialog_helper.dart';
import '../../core/utils/shared_prefs_helper.dart';
import '../../core/models/delivery_summary_result.dart';
import '../../core/utils/error_handler.dart';
import '../../shared_widgets/header.dart';
import '../../shared_widgets/loading.dart';

class DeliveryScreen extends StatefulWidget {
  final String userName;
  final int shiftNo;
  final String companyName;

  const DeliveryScreen({
    super.key,
    required this.userName,
    required this.shiftNo,
    this.companyName = "PT. Krama Yudha Ratu Motor",
  });

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final DeliveryService _service = DeliveryService();

  List<DeliverySummaryResult> data = [];
  int totalQty = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSummary();
  }

  Future<void> fetchSummary() async {
    setState(() => isLoading = true);
    try {
      final token = await SharedPrefsHelper.getToken();
      if (token == null || token.isEmpty) throw Exception("Unauthorized");

      final result = await _service.fetchSummary(token);
      final grandTotal = result.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );

      if (!mounted) return;
      setState(() {
        data = result;
        totalQty = grandTotal;
      });
    } catch (e, stackTrace) {
      if (!mounted) return;
      ErrorHandler.handle(context: context, error: e, stackTrace: stackTrace);
    } finally {
      // ignore: control_flow_in_finally
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
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFFBD0000)),
                    onPressed: () {
                      DialogHelper.showConfirmation(
                        context: context,
                        title: "Konfirmasi",
                        message: "Keluar dari Menu Summary Delivery?",
                        onConfirm: () => Navigator.pop(context),
                      );
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Summary Delivery",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  if (!isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                  flex: 3,
                                  child: Text("Variant",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text("QTY",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
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
                                itemCount: data.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final item = data[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 3, child: Text(item.variant)),
                                        Expanded(
                                            flex: 2,
                                            child:
                                                Text(item.quantity.toString())),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFFEDEFF1),
                            ),
                            child: Row(
                              children: [
                                const Expanded(child: Text("Grand Total")),
                                Text(totalQty.toString()),
                              ],
                            ),
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
