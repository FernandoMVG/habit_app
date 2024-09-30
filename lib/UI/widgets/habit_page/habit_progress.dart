import 'package:flutter/material.dart';

class HabitProgressWidget extends StatelessWidget {
  final int currentProgress;
  final int totalProgress;

  const HabitProgressWidget({
    super.key,
    required this.currentProgress,
    required this.totalProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: currentProgress / totalProgress,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
          minHeight: 6,
        ),
        const SizedBox(height: 4),
        Text(
          '$currentProgress/$totalProgress completado',
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }
}
