import 'package:flutter/material.dart';
import 'package:habit_app/ui/widgets/habit_page/habit_frequency.dart';
//import 'package:habit_app/ui/widgets/habit_page/habit_progress.dart';
import 'package:habit_app/ui/widgets/category_icon.dart';

class HabitCardWidget extends StatelessWidget {
  final String habitName;
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;
  final bool isQuantifiable;
  final int? currentProgress;
  final int? totalProgress;
  final bool isDaily;
  final List<String>? selectedDays;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HabitCardWidget({
    super.key,
    required this.habitName,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.isQuantifiable,
    this.currentProgress,
    this.totalProgress,
    required this.isDaily,
    this.selectedDays,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Ordenar los días seleccionados antes de mostrarlos
    List<String> orderedDays = ['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab', 'Dom'];
    selectedDays?.sort((a, b) => orderedDays.indexOf(a).compareTo(orderedDays.indexOf(b)));

    

    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      shadowColor: Theme.of(context).primaryColorLight,
      color: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Theme.of(context).colorScheme.onSurface, width: 0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CategoryIconWidget(icon: categoryIcon, color: categoryColor),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habitName, 
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)
                      ),
                    Text(
                      categoryName, 
                      style: TextStyle(fontSize: 14, color: categoryColor)
                      ),
                  ],
                ),
                const Spacer(),
                
              ],
            ),
            const SizedBox(height: 10),
            // Widget de frecuencia del hábito
            HabitFrequencyWidget(
              isDaily: isDaily,
              selectedDays: selectedDays,
              categoryColor: categoryColor,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
