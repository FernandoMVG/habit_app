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
          Icon(icon, size: 80, 
          color: Theme.of(context).colorScheme.primary
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(fontSize: 18, 
            color: Theme.of(context).colorScheme.primary
            ),
          ),
          Text(
            subMessage,
            style: TextStyle(fontSize: 16, 
            color: Theme.of(context).colorScheme.onSurface
            ),
          ),
        ],
      ),
    );
  }
}
