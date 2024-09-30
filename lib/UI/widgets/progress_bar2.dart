// habit_app/ui/widgets/progress_bar.dart

import 'package:flutter/material.dart';

class ProgressBarWidget2 extends StatelessWidget {
  final double progress;

  const ProgressBarWidget2({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Texto del porcentaje
          Text(
            'Progreso del día: ${(progress * 100).toStringAsFixed(0)}%', // Convertir a porcentaje
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 5), // Espacio entre el texto y la barra
          // Barra de progreso
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2C3E50)),
          ),
        ],
      ),
    );
  }
}