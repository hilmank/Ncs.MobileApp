import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String userName;
  final int shiftNo;
  final String companyName;
  final String dateFormatted;
  final String timeFormatted;

  const Header({
    super.key,
    required this.userName,
    required this.shiftNo,
    required this.companyName,
    required this.dateFormatted,
    required this.timeFormatted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFBD0000),
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
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$userName (Shift: $shiftNo)",
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                companyName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(dateFormatted, style: const TextStyle(color: Colors.white)),
              Text(timeFormatted,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
