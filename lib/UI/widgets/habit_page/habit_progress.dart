import 'package:flutter/material.dart';

class HabitProgressWidget extends StatelessWidget {
  final int streakCount; // Racha actual
  final int longestStreak; // Racha más larga

  const HabitProgressWidget({
    super.key,
    required this.streakCount,
    required this.longestStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Racha actual con icono y texto
        Row(
          children: [
            const Icon(Icons.local_fire_department, color: Colors.orange),
            const SizedBox(width: 8),
            Text(
              'Racha actual: $streakCount días',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Racha más larga como texto o etiqueta simple
        Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Text(
              'Racha más larga: $longestStreak días',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}
