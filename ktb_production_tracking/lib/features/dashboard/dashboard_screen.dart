import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../auth/login_screen.dart';
import '../delivery/delivery_screen_detail.dart';
import '../trimming_on/trimming_on_detail_screen.dart';
import '../trimming_on/trimming_on_screen.dart';
import '../delivery/delivery_screen.dart';
import '../settings/configuration_screen.dart';
import '../../core/utils/shared_prefs_helper.dart';
import '../../core/utils/dialog_helper.dart';
import '../../shared_widgets/header.dart';

class DashboardScreen extends StatelessWidget {
  final String userName;
  final String companyName;
  final String role;
  final int shiftNo;

  const DashboardScreen({
    super.key,
    required this.userName,
    required this.role,
    required this.shiftNo,
    this.companyName = "PT. Krama Yudha Ratu Motor",
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormatted = DateFormat('EEEE, d MMMM y', 'id_ID').format(now);
    final timeFormatted = DateFormat.Hms().format(now);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            Header(
              userName: userName,
              shiftNo: shiftNo,
              companyName: companyName,
              dateFormatted: dateFormatted,
              timeFormatted: timeFormatted,
            ),
            // Menu Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Menu",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFFBD0000),
                    ),
                  ),
                  if (role == 'admin')
                    Tooltip(
                      message: "Settings",
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ConfigurationScreen(),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/icons/settings.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Menu Cards
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  if (role == 'admin' || role == 'trimming-on')
                    _MenuCard(
                      title: "Summary Trimming-On",
                      icon: Image.asset('assets/icons/summary.png',
                          width: 48, height: 48),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TrimmingOnScreen(
                              userName: userName,
                              shiftNo: shiftNo,
                              companyName: companyName,
                            ),
                          ),
                        );
                      },
                    ),
                  if (role == 'admin' || role == 'trimming-on')
                    _MenuCard(
                      title: "Transaction Trimming-On",
                      icon: Image.asset('assets/icons/transaction.png',
                          width: 48, height: 48),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TrimmingOnDetailScreen(
                              userName: userName,
                              shiftNo: shiftNo,
                              companyName: companyName,
                            ),
                          ),
                        );
                      },
                    ),
                  if (role == 'admin' || role == 'delivery')
                    _MenuCard(
                      title: "Summary Delivery",
                      icon: Image.asset('assets/icons/summary.png',
                          width: 48, height: 48),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DeliveryScreen(
                              userName: userName,
                              shiftNo: shiftNo,
                              companyName: companyName,
                            ),
                          ),
                        );
                      },
                    ),
                  if (role == 'admin' || role == 'delivery')
                    _MenuCard(
                      title: "Transaction Delivery",
                      icon: Image.asset('assets/icons/transaction.png',
                          width: 48, height: 48),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DeliveryDetailScreen(
                              userName: userName,
                              shiftNo: shiftNo,
                              companyName: companyName,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBD0000),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      DialogHelper.showConfirmation(
                        context: context,
                        title: "Konfirmasi",
                        message: "Keluar dari Aplikasi?",
                        onConfirm: () async {
                          await SharedPrefsHelper.clear();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text("LOGOUT",
                        style: TextStyle(color: Colors.white)),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Menu Card
class _MenuCard extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback? onTap;

  const _MenuCard({
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 12),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
