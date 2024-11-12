import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:habit_app/UI/widgets/routine/habit_routine_card.dart';

class DailyRoutineWidget extends StatelessWidget {
  final habitController = Get.find<HabitController>();

  DailyRoutineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Habit>>(
      stream: habitController.getTodayHabitsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar los hábitos.'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No tienes hábitos para hoy.'),
          );
        }

        // Obtener los hábitos del día
        List<Habit> todayHabits =
            habitController.getTodayHabits(snapshot.data!);

        // Filtrar hábitos en no completados y completados
        final simulatedDate = habitController.simulatedDate.value;
        final todayKey =
            "${simulatedDate.year}-${simulatedDate.month}-${simulatedDate.day}";

        List<Habit> notCompletedHabits = todayHabits.where((habit) {
          int progressForToday = habit.dailyProgress[todayKey] ?? 0;

          // Verificar si el hábito no está completado
          if (habit.isQuantifiable) {
            if (habit.targetCount != null) {
              // Si es continuo con un targetCount, considerar completado si progressForToday >= targetCount
              return progressForToday < habit.targetCount!;
            } else if (habit.frequencyType == 'Sin especificar') {
              // Si es continuo con frequencyType 'Sin especificar', considerar completado si progressForToday >= 1
              return progressForToday < 1;
            }
          } else {
            // Si es discreto, considerar completado si progressForToday >= 1
            return progressForToday < 1;
          }

          // Por defecto, no está completado
          return true;
        }).toList();

        List<Habit> completedHabits = todayHabits.where((habit) {
          int progressForToday = habit.dailyProgress[todayKey] ?? 0;

          // Verificar si el hábito está completado
          if (habit.isQuantifiable) {
            if (habit.targetCount != null) {
              // Si es continuo con un targetCount, considerar completado si progressForToday >= targetCount
              return progressForToday >= habit.targetCount!;
            } else if (habit.frequencyType == 'Sin especificar') {
              // Si es continuo con frequencyType 'Sin especificar', considerar completado si progressForToday >= 1
              return progressForToday >= 1;
            }
          } else {
            // Si es discreto, considerar completado si progressForToday >= 1
            return progressForToday >= 1;
          }

          // Por defecto, no está completado
          return false;
        }).toList();

        return ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            // Título "Mi rutina" y hábitos no completados
            if (notCompletedHabits.isNotEmpty) ...[
              Text(
                'Mi rutina',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 5),
              ...notCompletedHabits
                  .map((habit) => HabitRoutineCard(habit: habit)),
            ],

            // Separador entre secciones
            if (completedHabits.isNotEmpty && notCompletedHabits.isNotEmpty)
              const Divider(height: 20),

            // Título "Completados" y hábitos completados
            if (completedHabits.isNotEmpty) ...[
              Text(
                'Completados',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 5),
              ...completedHabits.map((habit) => HabitRoutineCard(habit: habit)),
            ],
          ],
        );
      },
    );
  }
}
