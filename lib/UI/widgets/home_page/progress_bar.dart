import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';

class DailyProgressBar extends StatelessWidget {
  final HabitController habitController = Get.find<HabitController>();

  DailyProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Habit> todayHabits = habitController.getTodayHabits();
      int totalHabits = todayHabits.length;
      int completedHabits = todayHabits.where((habit) => habit.isCompleted).length;

      double progress = totalHabits > 0 ? completedHabits / totalHabits : 0.0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progreso de hoy: $completedHabits/$totalHabits hábitos completados',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: Theme.of(context).primaryColor,
          ),
        ],
      );
    });
  }
}
