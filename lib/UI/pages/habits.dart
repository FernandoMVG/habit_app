import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/domain/models/habit_model.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/UI/widgets/home_page/navigation_bar.dart';
import 'package:habit_app/UI/widgets/shared/empty_message.dart';
import 'package:habit_app/UI/widgets/shared/app_bar.dart';
import 'package:habit_app/UI/widgets/habit_page/habit_card.dart';
import 'package:habit_app/UI/pages/habits_pages/habit_type.dart';
import 'package:habit_app/UI/widgets/shared/bottom_sheet.dart';
import 'package:habit_app/UI/widgets/habit_page/habit_details.dart';
import 'package:habit_app/UI/widgets/habit_page/habit_edit.dart';
import 'package:habit_app/UI/widgets/shared/fab_button.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  final habitController = Get.find<HabitController>(); // Instanciamos el controlador
  final int _currentIndex = 1; // Índice seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(), // AppBar reutilizable

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la sección que solo aparece si hay habitos
            Obx(() {
              if (habitController.habits.isNotEmpty) {
                return Text(
                  'Mis hábitos',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
            // Verificar si hay hábitos y mostrar el contenido
            Expanded(
              child: Obx(() {
                
                if (habitController.habits.isEmpty) {
                  return const EmptyStateMessageWidget(
                    message: 'No tienes ningún hábito...',
                    subMessage: 'Prueba agregando uno nuevo :D',
                    icon: Icons.check_circle_outline,
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: habitController.habits.length,
                    itemBuilder: (context, index) {
                      final habit = habitController.habits[index];

                      return GestureDetector(
                        onTap: () {
                          _showBottomSheet(context, habit);
                        },
                        child: HabitCardWidget(
                          habitName: habit.name,
                          categoryName: habit.categoryName,
                          categoryIcon: habit.categoryIcon,
                          categoryColor: habit.categoryColor,
                          isQuantifiable: habit.isQuantifiable,
                          currentProgress: habit.isQuantifiable
                              ? habit.completedCount
                              : null,
                          totalProgress: habit.isQuantifiable
                              ? habit.targetCount
                              : null,
                          isDaily: habit.isDaily,
                          selectedDays: habit.selectedDays,
                          onEdit: () {
                            _showBottomSheet(context, habit);
                          },
                          onDelete: () {
                            habitController.removeHabit(habit);
                          },
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),

      floatingActionButton: CustomFabButton(
        onPressed: () {
          Get.to(() => HabitTypeSelectionPage()); // Navegar a la página de selección
        },
      ),

      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Habit habit) {
    final TextEditingController nameController =
        TextEditingController(text: habit.name);
    final TextEditingController descriptionController =
        TextEditingController(text: habit.description ?? '');

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CustomBottomSheet(
          content: HabitDetailsWidget(habit: habit),
          editContent: HabitEditWidget(
            nameController: nameController,
            descriptionController: descriptionController,
          ),
          onEdit: () {
            // Activar modo edición
          },
          onDelete: () {
            habitController.removeHabit(habit);
            Get.back();
          },
          onSave: () {
            // Asegura que se puede guardar una descripción vacía
          habitController.updateHabit(
            habit,
            nameController.text.isNotEmpty ? nameController.text : habit.name,
            descriptionController.text,  // Permitir valor vacío
          );
            Get.back(); // Cierra el BottomSheet después de guardar
          },
        );
      },
    );
  }
}
