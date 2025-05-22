import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/services/trimming_on_service.dart';
import '../../core/utils/shared_prefs_helper.dart';
import '../auth/login_screen.dart';
import '../../core/utils/dialog_helper.dart';

class TrimmingOnScreen extends StatefulWidget {
  final String userName;
  final int shiftNo;
  final String companyName;

  const TrimmingOnScreen({
    super.key,
    required this.userName,
    required this.shiftNo,
    this.companyName = "PT. Krama Yudha Ratu Motor",
  });

  @override
  State<TrimmingOnScreen> createState() => _TrimmingOnScreenState();
}

class _TrimmingOnScreenState extends State<TrimmingOnScreen> {
  final TrimmingOnService _service = TrimmingOnService();

  List<Map<String, dynamic>> data = [];
  int totalQty = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSummary();
  }

  Future<void> fetchSummary() async {
    try {
      final token = await SharedPrefsHelper.getToken();
      if (token == null || token.isEmpty) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
        return;
      }

      final result = await _service.fetchSummary(token);
      int grandTotal = result.fold(0, (sum, item) => sum + item.quantity);

      setState(() {
        data = result.map((e) => e.toJson()).toList();
        totalQty = grandTotal;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error: $e');
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
            Container(
              color: Color(0xFFBD0000),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Text(
                      "A",
                      style: TextStyle(
                          color: Color(0xFFBD0000),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.userName} (Shift: ${widget.shiftNo})",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(widget.companyName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(dateFormatted,
                          style: const TextStyle(color: Colors.white)),
                      Text(timeFormatted,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
            isLoading
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                                          "Keluar dari Menu Summary Trimming-On?",
                                      onConfirm: () => Navigator.pop(context),
                                    );
                                  },
                                ),
                                const Expanded(
                                  child: Center(
                                    child: Text("Summary Trimming-On",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                  ),
                                ),
                                const SizedBox(width: 48),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Table Header
                          Container(
                            color: const Color(0xFFEDEFF1),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            child: const Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text('Cabin',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 3,
                                    child: Text('Color',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: Text('QTY',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Data Table
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
                                  final row = data[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 3, child: Text(row['cabin'])),
                                        Expanded(
                                            flex: 3, child: Text(row['color'])),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                                row['quantity'].toString())),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Total
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
                  ),
          ],
        ),
      ),
    );
  }
}
