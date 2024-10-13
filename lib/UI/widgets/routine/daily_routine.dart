import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:habit_app/ui/widgets/routine/habit_routine_card.dart';

class DailyRoutineWidget extends StatelessWidget {
  final habitController = Get.find<HabitController>();

  DailyRoutineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Obtener los hábitos del día
      List<Habit> todayHabits = habitController.getTodayHabits();

      // Filtrar hábitos en no completados y completados
      List<Habit> notCompletedHabits =
          todayHabits.where((habit) => !habit.isCompleted).toList();
      List<Habit> completedHabits =
          todayHabits.where((habit) => habit.isCompleted).toList();

      if (todayHabits.isEmpty) {
        return const Center(
          child: Text('No tienes hábitos para hoy.'),
        );
      }

      return ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          // Título "Mi rutina" y hábitos no completados
          if (notCompletedHabits.isNotEmpty) ...[
            Text(
              'Mi rutina',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 5),
            ...notCompletedHabits.map((habit) => HabitRoutineCard(habit: habit)),
          ],

          // Separador entre secciones
          if (completedHabits.isNotEmpty && notCompletedHabits.isNotEmpty)
            const Divider(height: 20),

          // Título "Completados" y hábitos completados
          if (completedHabits.isNotEmpty) ...[
            Text(
              'Completados',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 5),
            ...completedHabits.map((habit) => HabitRoutineCard(habit: habit)),
          ],
        ],
      );
    });
  }
}
