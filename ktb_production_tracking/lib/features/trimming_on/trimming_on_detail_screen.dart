import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/services/trimming_on_service.dart';
import '../../core/utils/shared_prefs_helper.dart';
import '../../core/errors/app_exception.dart';
import '../../core/models/trimming_on_transaction_result.dart';
import '../../core/utils/dialog_helper.dart';
import '../../core/utils/error_handler.dart';
import '../../shared_widgets/header.dart';
import '../../shared_widgets/loading.dart';

class TrimmingOnDetailScreen extends StatefulWidget {
  final String userName;
  final int shiftNo;
  final String companyName;

  const TrimmingOnDetailScreen({
    super.key,
    required this.userName,
    required this.shiftNo,
    this.companyName = "PT. Krama Yudha Ratu Motor",
  });

  @override
  State<TrimmingOnDetailScreen> createState() => _TrimmingOnDetailScreenState();
}

class _TrimmingOnDetailScreenState extends State<TrimmingOnDetailScreen> {
  final TrimmingOnService _service = TrimmingOnService();
  final TextEditingController shiftController =
      TextEditingController(text: "1");
  final TextEditingController snController = TextEditingController();

  List<TrimmingOnTransactionResult> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    setState(() => isLoading = true);
    try {
      final token = await SharedPrefsHelper.getToken();
      if (token == null || token.isEmpty) {
        throw AppException("Unauthorized");
      }

      final data = await _service.fetchTransactions(token);
      final list =
          data.map((e) => TrimmingOnTransactionResult.fromJson(e)).toList();
      if (!mounted) return;
      setState(() {
        transactions = list;
      });
    } catch (e, stack) {
      if (!mounted) return;
      ErrorHandler.handle(context: context, error: e, stackTrace: stack);
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> updateTrimmingOnStatus(String cabinNo) async {
    setState(() => isLoading = true);
    try {
      final token = await SharedPrefsHelper.getToken();
      if (token == null || token.isEmpty) throw AppException("Unauthorized");

      final result = await _service.updateStatus(token, cabinNo);
      final trimming = result['trimming'];
      if (trimming == null) {
        throw AppException(result['message'] ?? "Data tidak ditemukan");
      }

      final newItem = TrimmingOnTransactionResult.fromJson(trimming);
      setState(() {
        transactions.insert(0, newItem);
        snController.clear();
      });
    } catch (e, stack) {
      if (!mounted) return;
      ErrorHandler.handle(context: context, error: e, stackTrace: stack);
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
        child: Stack(
          children: [
            Column(
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
                        icon: const Icon(Icons.arrow_back,
                            color: Color(0xFFBD0000)),
                        onPressed: () {
                          DialogHelper.showConfirmation(
                            context: context,
                            title: "Konfirmasi",
                            message:
                                "Keluar dari Menu Transaction Trimming-On?",
                            onConfirm: () => Navigator.pop(context),
                          );
                        },
                      ),
                      const Expanded(
                        child: Center(
                          child: Text("Transaction Trimming-On",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Cabin SN input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text("Cabin SN",
                            style: TextStyle(color: Colors.black54)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: snController,
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              updateTrimmingOnStatus(value.trim());
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Enter",
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Table
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 900,
                        child: Column(
                          children: [
                            Container(
                              color: const Color(0xFFEDEFF1),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              child: const Row(
                                children: [
                                  SizedBox(
                                      width: 40,
                                      child: Text("#",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(
                                      width: 100,
                                      child: Text("Cabin No.",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(
                                      width: 80,
                                      child: Text("Color",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(
                                      width: 120,
                                      child: Text("Production Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(
                                      width: 60,
                                      child: Text("Shift",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(
                                      width: 80,
                                      child: Text("Line",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(
                                      width: 80,
                                      child: Text("Current",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(
                                      width: 100,
                                      child: Text("Process ID",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(
                                      width: 80,
                                      child: Text("Status",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                ],
                              ),
                            ),
                            Expanded(
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
                                        SizedBox(
                                            width: 40,
                                            child: Text('${index + 1}')),
                                        SizedBox(
                                            width: 100,
                                            child: Text(row.cabinNo)),
                                        SizedBox(
                                            width: 80, child: Text(row.color)),
                                        SizedBox(
                                            width: 120,
                                            child: Text(DateFormat('dd-MM-yyyy')
                                                .format(row.productionDate))),
                                        SizedBox(
                                            width: 60,
                                            child:
                                                Text(row.shiftNo.toString())),
                                        SizedBox(
                                            width: 80, child: Text(row.line)),
                                        SizedBox(
                                            width: 80,
                                            child: Text(row.current)),
                                        SizedBox(
                                            width: 100,
                                            child: Text(row.processId)),
                                        SizedBox(
                                            width: 80,
                                            child: Text(row.status ?? '-')),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Shift Info
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
                              borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("Day", style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ],
            ),
            LoadingOverlay(isLoading: isLoading),
          ],
        ),
      ),
    );
  }
}
