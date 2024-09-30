import 'package:flutter/material.dart';

class HabitFrequencyWidget extends StatelessWidget {
  final bool isDaily;
  final List<String>? selectedDays;
  final Color categoryColor;

  const HabitFrequencyWidget({
    super.key,
    required this.isDaily,
    this.selectedDays,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isDaily) {
      return const Text('Diario', style: TextStyle(fontSize: 14, color: Colors.black));
    } else if (selectedDays != null && selectedDays!.isNotEmpty) {
      return Wrap(
        spacing: 8.0,
        children: selectedDays!.map((day) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.2),  // Fondo suave basado en el color de la categoría
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,  // Texto en negro para mejor contraste
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return const Text('Sin días seleccionados', style: TextStyle(fontSize: 14, color: Colors.black));
    }
  }
}

