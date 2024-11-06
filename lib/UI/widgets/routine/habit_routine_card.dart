import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/UI/widgets/category_icon.dart';
import 'package:habit_app/UI/widgets/routine/quantifable_dialog.dart';
import 'package:habit_app/UI/widgets/routine/progress_bar_routine.dart';
import 'package:habit_app/constants.dart';

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
          _showQuantifiableHabitDialog();
        } else {
          setState(() {
            habitController.toggleHabitCompletion(widget.habit);
          });
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
                color: widget.habit.categoryColor,
                borderRadius: BorderRadius.circular(defaultRadius),
              ),
              child: CategoryIconWidget(
                icon: widget.habit.categoryIcon,
                color: widget.habit.categoryColor,
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.habit.name,
                    style: titleTextStyle.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    widget.habit.categoryName,
                    style: labelTextStyle.copyWith(
                      color: widget.habit.categoryColor,
                    ),
                  ),
                  const SizedBox(height: 5.0),

                  if (widget.habit.isQuantifiable)
                    CustomProgressBar(progress: progress),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.habit.isCompleted
                    ? accentColor
                    : (widget.habit.isMissed ? errorColor : cardShadowColor),
                shape: BoxShape.circle,
              ),
              child: widget.habit.isCompleted
                  ? const Icon(Icons.check, color: Colors.white)
                  : widget.habit.isMissed
                      ? const Icon(Icons.close, color: Colors.white)
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuantifiableHabitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuantifiableHabitDialog(
          habit: widget.habit,
          habitController: habitController,
          onProgressUpdated: (int updatedCount) {
            setState(() {
              habitController.updateQuantifiableHabitProgress(widget.habit, updatedCount);
            });
          },
        );
      },
    );
  }
}
