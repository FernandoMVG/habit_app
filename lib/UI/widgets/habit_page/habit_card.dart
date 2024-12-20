import 'package:flutter/material.dart';
import 'package:habit_app/UI/widgets/habit_page/habit_frequency.dart';
//import 'package:habit_app/ui/widgets/habit_page/habit_progress.dart';
import 'package:habit_app/UI/widgets/category_icon.dart';
import 'package:habit_app/constants.dart';

class HabitCardWidget extends StatelessWidget {
  final String habitName;
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;
  final bool isQuantifiable;
  final int? currentProgress;
  final int? totalProgress;
  final bool isDaily;
  final List<int>? selectedDays;
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
    List<String> weekDays = ['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab', 'Dom'];
    List<String> selectedDaysStrings = selectedDays != null
        ? selectedDays!.map((day) => weekDays[day - 1]).toList()
        : [];

    // Ordenar los días seleccionados antes de mostrarlos
    selectedDaysStrings.sort((a, b) => weekDays.indexOf(a).compareTo(weekDays.indexOf(b)));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(defaultRadius),
        boxShadow: const [
          BoxShadow(
            color: cardShadowColor,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
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
                      style: titleTextStyle.copyWith(fontSize: 20),
                      ),
                    Text(
                      categoryName, 
                      style: labelTextStyle.copyWith(
                        color: categoryColor,
                      ),
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
              selectedDays: selectedDaysStrings,
              categoryColor: categoryColor,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
