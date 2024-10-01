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
      return BoxDays(
        categoryColor: categoryColor,
        text: 'Todos los días',
        ); 
      
      //
    } else if (selectedDays != null && selectedDays!.isNotEmpty) {
      return Wrap(
        spacing: 8.0,
        children: selectedDays!.map((day) {
          return BoxDays(
            categoryColor: categoryColor,
            text: day,
          );
        }).toList(),
      );
    } else {
      return Text('Sin días seleccionados', style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyLarge?.color));
    }
  }
}

//Widget para envolver la frecuencia en cajita de color
class BoxDays extends StatelessWidget {
  final Color categoryColor;
  final String text;
  
  const BoxDays({
    super.key,
    required this.categoryColor,
    required this.text
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),  // Fondo suave basado en el color de la categoría
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: Theme.of(context).textTheme.bodyLarge?.fontWeight,
                color: categoryColor,
              ),
            ),
          );
  }
}



