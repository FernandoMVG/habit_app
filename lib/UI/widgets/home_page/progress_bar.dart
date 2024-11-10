import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/constants.dart';

class DailyProgressBar extends StatelessWidget {
  final HabitController habitController = Get.find<HabitController>();

  DailyProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Habit> todayHabits = habitController.getTodayHabits();
      int totalHabits = todayHabits.length;
      int completedHabits =
          todayHabits.where((habit) => habit.isCompleted).length;

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
    });
  }

  // Barra de progreso con estilo mejorado
  Widget _buildCustomProgressBar(double progress, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 8, // Altura ajustada
            decoration: BoxDecoration(
              color: navBarInactiveColor, // Fondo inactivo
              borderRadius: BorderRadius.circular(8),
            ),
            child: FractionallySizedBox(
              widthFactor: progress,
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
        const SizedBox(width: 12), // Espacio entre barra y porcentaje
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
