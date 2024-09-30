import 'package:flutter/material.dart';
import 'package:habit_app/ui/widgets/habit_page/habit_action.dart';
import 'package:habit_app/ui/widgets/habit_page/habit_frequency.dart';
import 'package:habit_app/ui/widgets/habit_page/habit_progress.dart';
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
  List<String> orderedDays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  selectedDays?.sort((a, b) => orderedDays.indexOf(a).compareTo(orderedDays.indexOf(b)));

    return Card(
      elevation: 3,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
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
                    Text(habitName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                    Text(categoryName, style: TextStyle(fontSize: 14, color: categoryColor)),
                  ],
                ),
                const Spacer(),
                HabitActionsWidget(onEdit: onEdit, onDelete: onDelete),
              ],
            ),
            const SizedBox(height: 10),
            HabitFrequencyWidget(isDaily: isDaily, selectedDays: selectedDays, categoryColor: categoryColor,),
            if (isQuantifiable && currentProgress != null && totalProgress != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: HabitProgressWidget(
                  currentProgress: currentProgress!,
                  totalProgress: totalProgress!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
