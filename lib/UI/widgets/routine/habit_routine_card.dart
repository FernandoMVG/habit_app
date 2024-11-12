import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/UI/widgets/category_icon.dart';
import 'package:habit_app/UI/widgets/routine/quantifable_dialog.dart';
import 'package:habit_app/UI/widgets/routine/progress_bar_routine.dart';
import 'package:habit_app/constants.dart';

class HabitRoutineCard extends StatelessWidget {
  final Habit habit;

  const HabitRoutineCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HabitController>(
      builder: (habitController) {
        double progress = 0;
        final simulatedDate = habitController.simulatedDate.value;
        final todayKey =
            "${simulatedDate.year}-${simulatedDate.month}-${simulatedDate.day}";

        int progressForToday = habit.dailyProgress[todayKey] ?? 0;

        if (habit.targetCount != null && habit.targetCount! > 0) {
          progress = progressForToday / habit.targetCount!;
        } else if (habit.frequencyType == 'Sin especificar' &&
            progressForToday >= 1) {
          progress = 1;
        }

        return GestureDetector(
          onTap: () {
            if (habit.isQuantifiable) {
              _showQuantifiableHabitDialog(context, habitController);
            } else {
              habitController.toggleHabitCompletion(habit);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: cardBackgroundColor,
              borderRadius: BorderRadius.circular(defaultRadius),
              boxShadow: const [
                BoxShadow(
                  color: cardShadowColor,
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: habit.categoryColor,
                    borderRadius: BorderRadius.circular(defaultRadius),
                  ),
                  child: CategoryIconWidget(
                    icon: habit.categoryIcon,
                    color: habit.categoryColor,
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.name,
                        style: titleTextStyle.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        habit.categoryName,
                        style: labelTextStyle.copyWith(
                          color: habit.categoryColor,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      if (habit.isQuantifiable)
                        CustomProgressBar(progress: progress),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: habit.isCompleted || (progressForToday > 0)
                        ? accentColor
                        : (habit.isMissed ? errorColor : cardShadowColor),
                    shape: BoxShape.circle,
                  ),
                  child: habit.isCompleted || (progressForToday > 0)
                      ? const Icon(Icons.check, color: Colors.white)
                      : habit.isMissed
                          ? const Icon(Icons.close, color: Colors.white)
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showQuantifiableHabitDialog(
      BuildContext context, HabitController habitController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuantifiableHabitDialog(
          habit: habit,
          habitController: habitController,
          onProgressUpdated: (int updatedCount) {
            habitController.updateQuantifiableHabitProgress(
                habit, updatedCount);
          },
        );
      },
    );
  }
}
