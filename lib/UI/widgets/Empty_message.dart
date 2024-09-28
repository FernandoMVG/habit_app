import 'package:flutter/material.dart';

class EmptyStateMessageWidget extends StatelessWidget {
  final String message;
  final String subMessage;
  final IconData icon;

  const EmptyStateMessageWidget({
    super.key,
    required this.message,
    required this.subMessage,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Color(0xFF2196F3)),
          ),
          Text(
            subMessage,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
