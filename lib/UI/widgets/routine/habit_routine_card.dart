import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';
import 'package:habit_app/ui/widgets/category_icon.dart';
import 'package:habit_app/ui/widgets/routine/quantifable_dialog.dart';

class HabitRoutineCard extends StatefulWidget {
  final Habit habit;

  const HabitRoutineCard({super.key, required this.habit});

  @override
  State<HabitRoutineCard> createState() => _HabitRoutineCardState();
}

class _HabitRoutineCardState extends State<HabitRoutineCard> {
  final HabitController habitController = Get.find<HabitController>();

  @override
  Widget build(BuildContext context) {
    double progress = widget.habit.targetCount != null && widget.habit.targetCount! > 0
        ? widget.habit.completedCount / widget.habit.targetCount!
        : 0.0;

    return GestureDetector(
      onTap: () {
        if (widget.habit.isQuantifiable) {
          // Mostrar diálogo para hábitos cuantificables
          _showQuantifiableHabitDialog();
        } else {
          // Alternar estado para hábitos binarios
          setState(() {
            widget.habit.toggleCompleted();
            habitController.updateHabitCompletion(widget.habit);
            //habitController.habits.refresh();
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, // Color de fondo de la tarjeta
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            // Icono de categoría en el cuadro de color
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: widget.habit.categoryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: CategoryIconWidget(icon: widget.habit.categoryIcon, color: widget.habit.categoryColor),
            ),
            const SizedBox(width: 10.0),
            // Nombre del hábito y categoría
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.habit.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    widget.habit.categoryName,
                    style: TextStyle(
                      color: widget.habit.categoryColor,
                      fontSize: 14.0,
                    ),
                  ),
                  if (widget.habit.isQuantifiable)
                    // Mostrar barra de progreso para hábitos cuantificables
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: Theme.of(context).primaryColor,
                    ),
                ],
              ),
            ),
            // Indicador de estado (círculo que cambia con el click)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.habit.isCompleted
                    ? Colors.greenAccent
                    : (widget.habit.isMissed ? Colors.redAccent : Colors.grey[300]),
                shape: BoxShape.circle,
              ),
              child: widget.habit.isCompleted
                  ? const Icon(Icons.check, color: Colors.green)
                  : widget.habit.isMissed
                      ? const Icon(Icons.close, color: Colors.red)
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // Mostrar diálogo para actualizar el progreso de un hábito cuantificable
  void _showQuantifiableHabitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuantifiableHabitDialog(
          habit: widget.habit,
          habitController: habitController,
          onProgressUpdated: (int updatedCount) {
            setState(() {
              widget.habit.completedCount = updatedCount;
              widget.habit.isCompleted = widget.habit.isHabitCompleted();
              habitController.updateHabitCompletion(widget.habit);
            });
          },
        );
      },
    );
  }
}