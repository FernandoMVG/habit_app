import 'package:flutter/material.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:habit_app/ui/widgets/category_icon.dart';
import 'package:habit_app/ui/widgets/box_color.dart';
import 'package:habit_app/constants.dart'; // Importa las constantes

class HabitDetailsWidget extends StatelessWidget {
  final Habit habit;

  const HabitDetailsWidget({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado: Nombre del hábito y el icono de categoría
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              habit.name,
              style: titleTextStyle.copyWith(fontSize: 36),
            ),
            CategoryIconWidget(
              icon: habit.categoryIcon,
              color: habit.categoryColor,
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Categoría del hábito
        BoxDays(
          categoryColor: habit.categoryColor,
          text: habit.categoryName,
          fontSize: 18,
        ),

        // Días seleccionados del hábito
        const SizedBox(height: 10),
        if (habit.selectedDays != null && habit.selectedDays!.isNotEmpty)
          Text(
            'Días: ${habit.selectedDays?.join(' - ') ?? 'Todos los días'}',
            style: bodyTextStyle.copyWith(fontSize: 16),
          ),
        const SizedBox(height: 20),

        // Información de las rachas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildStreakInfo(
                Icons.local_fire_department,
                "Actual",
                habit.streakCount,
              ),
            ),
            Expanded(
              child: _buildStreakInfo(
                Icons.emoji_events,
                "Record",
                habit.longestStreak,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Descripción del hábito (opcional)
        if (habit.description != null && habit.description!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              habit.description!,
              style: bodyTextStyle.copyWith(
                fontSize: 24,
                color: Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }

  // Widget auxiliar para mostrar la información de rachas
  Widget _buildStreakInfo(IconData icon, String label, int streak) {
    return Column(
      children: [
        Icon(
          icon,
          size: 40,
          color: icon == Icons.local_fire_department
              ? Colors.orange
              : Colors.blueAccent,
        ),
        const SizedBox(height: 8),
        Text(
          '$streak días',
          style: bodyTextStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: subtitleTextStyle.copyWith(fontSize: 18),
        ),
      ],
    );
  }
}
