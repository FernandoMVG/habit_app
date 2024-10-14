import 'package:flutter/material.dart';
import 'package:habit_app/ui/widgets/box_color.dart';

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
    // Si el hábito es diario, mostramos "Diario"
    if (isDaily) {
      return BoxDays(
        categoryColor: categoryColor,
        text: 'Diario',
        ); 
      
      //Si el usuario selecciona todos los días de la semana, marcamos como diario
     } else if (selectedDays != null && selectedDays!.length == 7) {
      return BoxDays(
        categoryColor: categoryColor,
        text: 'Diario',
      );
      // Si el usuario selecciona dias específicos, los mostramos
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

    }  else {
      return Text('Sin días seleccionados', style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyLarge?.color));
    }
  }
}




