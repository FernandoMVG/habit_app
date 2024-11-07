// Nuevo archivo quantifiable_habit_dialog.dart
import 'package:flutter/material.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/UI/widgets/category_icon.dart';

class QuantifiableHabitDialog extends StatefulWidget {
  final Habit habit;
  final HabitController habitController;
  final Function(int) onProgressUpdated;

  const QuantifiableHabitDialog({
    super.key,
    required this.habit,
    required this.habitController,
    required this.onProgressUpdated,
  });

  @override
  State<QuantifiableHabitDialog> createState() => _QuantifiableHabitDialogState();
}

class _QuantifiableHabitDialogState extends State<QuantifiableHabitDialog> {
  late int currentCount;
  late bool hasUpdated;

  @override
  void initState() {
    super.initState();
    currentCount = widget.habit.completedCount;
    hasUpdated = false;
  }

  @override
  Widget build(BuildContext context) {
    int targetCount = widget.habit.targetCount ?? 1;

    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.habit.name),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.habit.categoryColor,
              shape: BoxShape.circle,
            ),
            child: CategoryIconWidget(icon: widget.habit.categoryIcon, color: widget.habit.categoryColor),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            style: TextStyle(
              color: Colors.green[200],
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 10),
          // Botones para incrementar o decrementar el progreso
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  if (currentCount > 0) {
                    setState(() {
                      currentCount--;
                      hasUpdated = true;
                    });
                  }
                },
                icon: const Icon(Icons.remove, color: Colors.black),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  '$currentCount',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.green[200],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (currentCount < targetCount) {
                    setState(() {
                      currentCount++;
                      hasUpdated = true;
                    });
                  }
                },
                icon: const Icon(Icons.add, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              'Hoy $currentCount / $targetCount ${widget.habit.unit ?? ''}',
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          )
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
        TextButton(
          onPressed: () {
            if (hasUpdated) {
              widget.habit.completedCount = currentCount;
              //widget.habit.isCompleted = widget.habit.isHabitCompleted;
              widget.habitController.updateHabitCompletion(widget.habit);
              widget.onProgressUpdated(currentCount);
            }
            Navigator.of(context).pop();
          },
          child: Text(
            'Aceptar',
            style: TextStyle(
              color: widget.habit.categoryColor,
            ),
          ),
        )
      ],
    );
  }
}