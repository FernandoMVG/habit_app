import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:habit_app/constants.dart';

class DailyProgressBar extends StatelessWidget {
  final habitController = Get.find<HabitController>();

  DailyProgressBar({super.key});

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
          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: cardBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: cardShadowColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progreso de hoy',
                  style: bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'No tienes hábitos para hoy',
                  style: bodyTextStyle.copyWith(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Calcular el progreso para hoy basado en dailyProgress y la fecha simulada
        List<Habit> todayHabits = snapshot.data!;
        final simulatedDate = habitController.simulatedDate.value;
        final todayKey =
            "${simulatedDate.year}-${simulatedDate.month}-${simulatedDate.day}";

        int totalHabits = todayHabits.length;
        int completedHabits = todayHabits.where((habit) {
          int progressForToday = habit.dailyProgress[todayKey] ?? 0;

          // Considerar completado si la frecuencia es 'Sin especificar' y al menos una unidad está marcada
          if (habit.isQuantifiable) {
            if (habit.frequencyType == 'Sin especificar') {
              return progressForToday >= 1;
            } else {
              return progressForToday >= habit.targetCount!;
            }
          } else {
            return progressForToday >= 1;
          }
        }).length;

        double progress = totalHabits > 0 ? completedHabits / totalHabits : 0.0;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: cardShadowColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con el progreso de hoy
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progreso de hoy',
                    style: bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$completedHabits / $totalHabits completados',
                    style: bodyTextStyle.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Barra de progreso personalizada
              _buildCustomProgressBar(progress, context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomProgressBar(double progress, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: navBarInactiveColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: FractionallySizedBox(
              widthFactor: progress > 1.0 ? 1.0 : progress,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.8),
                      primaryColor,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${(progress * 100).toStringAsFixed(0)}%',
          style: bodyTextStyle.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
