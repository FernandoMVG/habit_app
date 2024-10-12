import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:habit_app/ui/widgets/routine/habit_routine_card.dart';

class DailyRoutineWidget extends StatelessWidget {
  final HabitController habitController = Get.find<HabitController>();

  DailyRoutineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Habit> todayHabits = habitController.getTodayHabits();

      if (todayHabits.isEmpty) {
        return const Center(
          child: Text('No tienes hábitos para hoy.'),
        );
      }

      return ListView.builder(
        itemCount: todayHabits.length,
        itemBuilder: (context, index) {
          final habit = todayHabits[index];
          return HabitRoutineCard(habit: habit);
        },
      );
    });
  }
}
