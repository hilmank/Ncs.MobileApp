import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const LoadingOverlay({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Container(
      // ignore: deprecated_member_use
      color: Colors.white.withOpacity(0.2),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.red),
      ),
    );
  }
}
