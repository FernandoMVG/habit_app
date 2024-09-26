import 'package:flutter/material.dart';

class HabitListWidget extends StatelessWidget {
  const HabitListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No tienes ningún hábito... Prueba agregando uno nuevo :D',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
