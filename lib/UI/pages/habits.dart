import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';
import 'package:habit_app/ui/widgets/home_page/navigation_bar.dart';
import 'package:habit_app/ui/widgets/shared/empty_message.dart';
import 'package:habit_app/ui/widgets/shared/app_bar.dart';
import 'package:habit_app/ui/widgets/habit_page/habit_card.dart';
import 'package:habit_app/ui/pages/habits_pages/habit_type.dart';
import 'package:habit_app/ui/widgets/shared/bottom_sheet.dart';
import 'package:habit_app/ui/widgets/habit_page/habit_details.dart';
import 'package:habit_app/ui/widgets/habit_page/habit_edit.dart';
import 'package:habit_app/ui/widgets/shared/fab_button.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  final habitController =Get.find<HabitController>(); // Instanciamos el controlador
  final int _currentIndex = 1;  // Para gestionar el índice seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(),

      body: Obx(() {
        // Verificar si hay hábitos
        if (habitController.habits.isEmpty) {
          // Mostrar el mensaje de que no hay hábitos creados
          return const EmptyStateMessageWidget(
            message: 'No tienes ningún hábito...',
            subMessage: 'Prueba agregando uno nuevo :D',
            icon: Icons.check_circle_outline,
          );
        } else {
          // Mostrar la lista de hábitos creados utilizando el nuevo HabitCardWidget
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: habitController.habits.length,
            itemBuilder: (context, index) {
              final habit = habitController.habits[index];

              return GestureDetector(
                onTap: () {
                  _showBottomSheet(context, habit); // Muestra el BottomSheet al hacer tap en la tarjeta
                },
                child: HabitCardWidget(
                  habitName: habit.name,
                  categoryName: habit.categoryName,
                  categoryIcon: habit.categoryIcon,  // Podrías cambiar este ícono según la categoría si tienes un icono específico
                  categoryColor: habit.categoryColor,
                  isQuantifiable: habit.isQuantifiable,
                  currentProgress: habit.isQuantifiable ? habit.completedCount : null,
                  totalProgress: habit.isQuantifiable ? habit.targetCount : null,
                  isDaily: habit.isDaily,
                  selectedDays: habit.selectedDays,
                  onEdit: () {
                    // Lógica para editar el hábito desde el botón de editar dentro del BottomSheet
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

      floatingActionButton: CustomFabButton(
        onPressed: () {
          Get.to(() => HabitTypeSelectionPage()); // Navega a la página correspondiente
        },
      ),

      // Barra de navegación reutilizada
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,  // Marcamos que estamos en la sección de "Hábitos"
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Habit habit) {
  final TextEditingController nameController = TextEditingController(text: habit.name);
  final TextEditingController descriptionController = TextEditingController(text: habit.description ?? '');

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
          habitController.updateHabit(
            habit,
            nameController.text.isNotEmpty ? nameController.text : habit.name,
            descriptionController.text.isNotEmpty ? descriptionController.text : habit.description ?? "",
          );
          Get.back();  // Cierra el BottomSheet después de guardar
        },
      );
    },
  );
}
}
