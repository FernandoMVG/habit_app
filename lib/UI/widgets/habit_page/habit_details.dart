import 'package:flutter/material.dart';
import 'package:habit_app/models/habit_model.dart';

class HabitDetailsWidget extends StatelessWidget {
  final Habit habit;

  const HabitDetailsWidget({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          habit.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            text: 'Categoría: ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
            children: [
              TextSpan(
                text: habit.categoryName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: habit.categoryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            text: 'Días seleccionados: ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
            children: [
              TextSpan(
                text: habit.selectedDays?.join(', ') ?? "Todos los días",
                style: const TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (habit.description != null && habit.description!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: RichText(
              text: TextSpan(
                text: 'Descripción: ',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                children: [
                  TextSpan(
                    text: habit.description,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
